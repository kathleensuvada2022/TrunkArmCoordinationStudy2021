function ACT3D_TACS
% AMA 1/7/2020 Adapted from main.m and make.m
%KCS 10.23.20 - adding PPS callback function for checkbox EDITS TO PPS1 CLASS 


% Not using Blender, commen next line
% addpath Blender Blender\BlenderPlayer Blender\create_thread 	% change paths for Blender
% Add the GUI, callback and timer functions to this main program instead of having separate m
% files.
% addpath create_windows create_windows\create_gui_components create_windows\main_window
% addpath callbacks callbacks\main_window_callbacks
% addpath timer
% The following folders should be the same for all the ACT3D users
addpath HapticAPI2
% addpath HapticAPI26 % This folder is not in the Kacey folders. Find out why
addpath parallel_port
addpath Metria
% addpath pnet % I don't think this one is used as it is not in the code
% folder

% load library used for parallel port
% % % if ( ~libisloaded('inpout32') )
% % %     loadlibrary inpout32 inpout32.h;
% % % end

%% GUI VISUALIZATION CODE
% Start by closing open figures and creating the main figure window for the GUI
close all;
scrsz = get(groot,'ScreenSize');
act3dTACS = figure('Name','ACT3D - Trunk Arm Coordination Study','NumberTitle','off','OuterPosition',[0.25*scrsz(3) 40 0.75*scrsz(3) scrsz(4)-40]);
act3dTACS.MenuBar = 'none';
act3dTACS.CloseRequestFcn = @GUI_closeMain;

%% Initialize objects and variables
% Note that myhandles is available to all the subfunctions in this program
% and therefore there is no need to use guidata to save myhandles for
% access across functions. But it is necessary if using external functions
myhandles = guihandles(act3dTACS);

% Each robot has a different IP address, set the correct one here
% AMA - Hard coded this
% Options: 'MC Lab: 10.30.203.26' or 'NI Lab:10.30.203.36'
% myhandles.room='MC Lab/10.30.203.36'; % Neuroimaging lab                                 
% myhandles.ipaddress='10.30.203.36'; 
myhandles.act3d.id='ACT3D36';

% Declare class objects
% Moved the robot and haptic class declarations to ACT3D_Init_Callback
% % % myhandles.robot = Robot(myhandles.ipaddress); 
% % % myhandles.haptic = Haptic(myhandles.robot);
% myhandles.judp = Judp;
% myhandles.nidaq = Nidaq; % MOVE TO DAQ_INIT FUNCTION
myhandles.ttl = TTL_digital_four_lines;                                     % KCS 8.14.20 Using TTL now with real time metria?Need TTL? Ask how metria working  
% quanser = Quanser; % We use NI cards, not Quanser
% display = Display(robot,judp); % Replaced with AddEXPDisplay

% Create ACT3D timer
myhandles.timer = timer;
myhandles.timer.period = 1/50;    % Timer frequency = 50 hz


% myhandles.act3d.load=10; ???
% ACT3D variables saved: 1)sample, 2)duration between current and previous samples,
% 3)xyz end effector position, 6)xyz velocity, 9)xyz force, xyz torque (removed),
% 12)shoulder flexion angle, 13)elbow flexion angle, 14)shoulder abduction
% angle, 15)xyz hand position, 18)boolean telling if arm is on the table
% obj.data( 1, obj.currentIteration ) = obj.currentIteration;
% obj.data( 2, obj.currentIteration ) = obj.currentPeriod;
% obj.data( 3:5, obj.currentIteration ) = robot.endEffectorPosition;
% obj.data( 6:8, obj.currentIteration ) = robot.endEffectorVelocity;
% obj.data( 9:11, obj.currentIteration ) = robot.endEffectorForce;
% obj.data( 12, obj.currentIteration ) = display.shoulderFlexionAngle;    % do i use IK or end effector rotation from robot?
% obj.data( 13, obj.currentIteration ) = display.elbowAngle;
% obj.data( 14, obj.currentIteration ) = display.shoulderAbductionAngle;
% obj.data( 15, obj.currentIteration ) = robot.endEffectorRotation(1);
% obj.data( 16:18, obj.currentIteration ) = display.fingerTipPosition;
% obj.data( 19, obj.currentIteration ) = obj.isArmOnTable;
% obj.data( 20:22, obj.currentIteration ) = robot.endEffectorTorque; % Added NH 1/17/16
% %obj.data( 22:24, obj.currentIteration ) = display.shoulderPosition;

myhandles.act3d.nVars=19;
myhandles.act3d.state='DISCONNECTED';
myhandles.act3d.loadtype='abs';

% Initialize DAQ variables
myhandles.daq.Device='Dev1';
myhandles.daq.nChan=15; 
myhandles.daq.sRate=1000;
myhandles.daq.sTime=10;
myhandles.daq.Channels = 0:myhandles.daq.nChan-1; % Channel list for DAQ
myhandles.daq.ChannelNames = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','Channel 16','Channel 17','Channel 18','Channel 19','Channel 20','Channel 21','Channel 22','Channel 23','Channel 24'};
% myhandles.ChannelNames = myhandles.ChannelNames(1:myhandles.nChan);
myhandles.daq.maxChannels = 24;
% Initialize beep played at the beginning of each trial (queue for
% participant)
[y,fs]=audioread('beep.wav');
myhandles.beep=audioplayer(y,fs);

myhandles.exp.origin=[0 0 0]; % Origin for the visual feedback display == midpoint between shoulders
myhandles.exp.armLength=29; % Upper arm length in cm
myhandles.exp.e2hLength=25; % Elbow to hand distance in cm
myhandles.exp.ee2eLength=15; % End effector to elbow distance in cm
myhandles.exp.abdAngle=90;
myhandles.exp.shfAngle=45;
myhandles.exp.elfAngle=90;
myhandles.exp.arm = 'right';                                                  
myhandles.exp.fname='trial';
myhandles.exp.itrial=1;
%  myhandles.exp.endforce=5.6;
% myhandles.exp.endpos=[3.24 -2.31 4.56];
% myhandles.exp.shpos=[0 0 0];
%  myhandles.exp.armwgt=15;
myhandles.exp.data=zeros(floor(myhandles.daq.sTime/myhandles.timer.period),myhandles.act3d.nVars);  
setappdata(act3dTACS,'databuffer',[]);


myhandles.met.port=6111; % Verify the Metria system's address
% myhandles.met.markerID=19;

myhandles.CreateStruct=struct('Interpreter','tex','WindowStyle','modal');



myhandles=GUI_AddPanels(act3dTACS,myhandles);

% Create user visual display feedback figure and return the axis, line and   KCS 8.17.20 Why need to return axis of the visual feedback? 
% text handles
[myhandles.exp.fig,myhandles.exp.hAxis,myhandles.exp.hLine,myhandles.exp.hLabel]=GUI_AddEXPDisplay(act3dTACS,myhandles);

guidata(act3dTACS, myhandles);

return

%% Evaluate whether experiment needs to be an object. What does Experiment really do??
% 
% myhandles.experiment = Experiment(myhandles.timerFrequency);

% hold gui and component data
% mainWindow = [];    
% emgChannels = [];
% addDisplay = []; %--> Created for Kacey 4.29.2019
% initializeRobot = [];
% participantParameters = [];
% setTargets = [];
% trialParameters = [];

% This function just sets the name and size (height and width) of each of
% the windows used in the program. Instead, set the size when creating the
% window.
% [ mainWindow, emgChannels, addDisplay, initializeRobot, participantParameters, setTargets, trialParameters ] = ...
%     InitializeStructures(...
%     mainWindow, emgChannels, addDisplay, initializeRobot, participantParameters, setTargets, trialParameters );

%%  Construct GUI 
% THIS IS NOW IN THE MAIN PROGRAM AND ADDGUIPANELS
% mainWindow = CreateMainWindow( mainWindow, robot.deviceId );
% EMG channels window - Only create if option is checked on console (take
% code from emgDAQ)
% emgChannels.figureHandle = CreateWindowFigure( emgChannels.name,...
%     emgChannels.figureWidth, emgChannels.figureHeight );
% emgChannels = CreateEmgChannelsComponents( emgChannels, mainWindow.daqParametersPanel.daqChannelsEditBox );
% disp('got to line 72 of main.m');
% figure(mainWindow.figureHandle); % bring main window to the front

% addDisplay = CreateEmgChannelsComponents( addDisplay, mainWindow.daqParametersPanel.daqChannelsEditBox );
% figure(mainWindow.figureHandle); % bring main window to the front

% % initialize robot window
% initializeRobot.figureHandle = CreateWindowFigure( initializeRobot.name,...
%     initializeRobot.figureWidth, initializeRobot.figureHeight );
% initializeRobot = CreateInitializeRobotComponents( initializeRobot, robot );
% set( initializeRobot.figureHandle, 'Visible','Off' );
% disp('got to line 84 of main.m');
% % participant parameters window
% participantParameters.figureHandle = CreateWindowFigure(...
%     participantParameters.name, participantParameters.figureWidth, participantParameters.figureHeight );
% participantParameters = CreateParticipantParametersComponents( participantParameters );
% set( participantParameters.figureHandle, 'Visible','Off' );
% disp('got to line 90 of main.m');
% % set targets window 
% setTargets.figureHandle = CreateWindowFigure( setTargets.name,...
%     setTargets.figureWidth, setTargets.figureHeight );
% setTargets = CreateSetTargetsComponents( setTargets, participantParameters );
% set( setTargets.figureHandle, 'Visible','Off' );
% disp('got to line 96 of main.m');
% % trial parameters window
% trialParameters.figureHandle = CreateWindowFigure( trialParameters.name,...
%     trialParameters.figureWidth, trialParameters.figureHeight );
% trialParameters = CreateTrialParametersComponents( trialParameters );
% set( trialParameters.figureHandle, 'Visible','Off' );
% disp('got to line 102 of main.m');
% % Changed for Kacey! Adding additional display window :)
% addDisplay.figureHandle = CreateWindowFigure( addDisplay.name,...
%     addDisplay.figureWidth, addDisplay.figureHeight );
% addDisplay = CreateAddDisplayComponents(addDisplay,participantParameters);
% disp('got to line 107 of main.m');

%% Callbacks
% set key press callbacks
% set( mainWindow.figureHandle, 'KeyPressFcn',{@Keypress,robot,mainWindow} )
% 
% % main window (ACT3D Interface) and callbacks
% mainWindow = CreateProtocolPanelCallbacks( mainWindow );
% mainWindow = CreateDaqParametersPanelCallbacks( mainWindow, emgChannels, experiment, trialParameters, nidaq, ttl, quanser );
% %%% A.M. Keeping addDisplay while debugging
% mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot, haptic,...
%    display, initializeRobot, participantParameters, trialParameters, experiment,...
%    timerObject, setTargets, emgChannels, nidaq, ttl,quanser, judp, addDisplay );
% % % % mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot, haptic,...
% % % %     display, initializeRobot, participantParameters, trialParameters, experiment,...
% % % %     timerObject, setTargets, emgChannels, nidaq, ttl,quanser, judp );
% disp('got to line 122 of main.m');
% mainWindow = CreateMenubarCallback( mainWindow, robot, initializeRobot,...
%     setTargets, trialParameters, participantParameters, display, timerObject, judp );
% 
% % callbacks for the five sub windows
% 
% % no callbacks needed for emg channels window
% set( emgChannels.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please close the main window') );
% 
% % initializeRobot = CreateInitializeRobotCallbacks( initializeRobot, mainWindow,...
% %     robot, haptic, display, participantParameters, setTargets, timerObject, experiment, judp );
% 
% %SA,AM 10.8.19 editing the arguments to include addDisplay
% initializeRobot = CreateInitializeRobotCallbacks( initializeRobot, mainWindow,...
%     robot, haptic, display, addDisplay, participantParameters, setTargets, timerObject, experiment, judp );
% 
% disp('got to line 133 of main.m');
% participantParameters = CreateParticipantParametersCallbacks(...
%     initializeRobot, mainWindow, robot, display, addDisplay, participantParameters, timerObject );
% disp('got to line 136 of main.m');
% setTargets = CreateSetTargetsCallbacks( initializeRobot, mainWindow,...
%     participantParameters, setTargets, robot, haptic, display, judp, timerObject );
% disp('got to line 139 of main.m');
% trialParameters = CreateTrialParametersCallbacks( initializeRobot,...
%     mainWindow, participantParameters, trialParameters, robot, haptic,...
%     display, timerFrequency, setTargets, timerObject, experiment );
% 
% disp('got to line 144 of main.m');
% 
% %%  Set the properties of the timer object that gets data from  HapticMaster and updates visual feedback MOVED THIS TO ACT3D_INIT_CALLBACK
% % set properties and start the timer
% 
% % timerObject = SetTimerProperties( timerObject, display, robot, mainWindow, experiment,...
% %     timerFrequency, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp );
% % start(timerObject);
% 
% %We need to modify SetTimerProperties to take in our new structure-
% %addDisplay
% 
% 
% % timerObject = SetTimerProperties( timerObject, display, robot, mainWindow, experiment,...
% %     timerFrequency, trialParameters, setTargets, emgChannels, addDisplay, nidaq, ttl, quanser, judp );
% % 
% % disp('got to line 159 of main.m');
% % start(timerObject);
% % disp('got to line 160 of main.m');
% % 
% % 
% % disp('got to line 169 of main.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GUI Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to create the panels for ACT3D, DAQ, Experimental Setup, Experimental Protocol and Metria with associated callback functions
% @(hObject,eventdata)TargetDAQ('Acquire_Callback',hObject,eventdata,guidata(hObject))
function myhandles=GUI_AddPanels(fighandle,myhandles)
% Get figure structure
% myhandles = guidata(fighandle);

% KCS 8.17.20 Changed fonts to make bigger on GUI and panels

%% ACT3D Panel
act3dPanel = uipanel('Title','ACT3D','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Tag','numChanET','Position',[0.01,0.55,0.3,0.45]);
% State
uicontrol(act3dPanel,'Style','text','String','Current State','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.78,.4,.15],'FontSize',12);
myhandles.ui.act3d_state=uicontrol(act3dPanel,'Style','text','String',myhandles.act3d.state,'HorizontalAlignment','left','Units','normalized','Position',[0.3,0.78,.6,.15],'FontSize',18,'ForegroundColor','b');
% Initialize/Normal/Fix ACT3D pushbutton 
myhandles.ui.act3d_init=uicontrol(act3dPanel,'Style','pushbutton','Callback',@ACT3D_Init_Callback,'String','INIT','Units','normalized','Position',[0.2 0.6 0.67 0.2],'FontSize',14,'BackgroundColor','y');
% Table on/off
uicontrol(act3dPanel,'Style','text','String','Table','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.4,.3,.1],'FontSize',12);
myhandles.ui.act3d_tablebg = uibuttongroup('Parent',act3dPanel,'Tag','TableBG','SelectionChangedFcn',@ACT3D_tablebg_Callback,'Position',[0.4 0.43 .4 .1],'BorderType','none');
uicontrol(myhandles.ui.act3d_tablebg,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0 0 0.45 1],'FontSize',12); %,'Enable','off');
myhandles.ui.act3d_tableoff=uicontrol(myhandles.ui.act3d_tablebg,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.5 0 0.45 1],'FontSize',12); %,'Enable','off');
myhandles.ui.act3d_tablebg.SelectedObject=myhandles.ui.act3d_tableoff;
% Load
uicontrol(act3dPanel,'Style','text','String',sprintf('Load\n(+ up, - down)'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.16,0.3,0.1],'FontSize',12);
myhandles.ui.act3d_load = uicontrol(act3dPanel,'Style','edit','String','','Tag','load','Callback',@ACT3D_load_Callback,'Units','normalized','Position',[.4 .2 .15 .14],'HorizontalAlignment','center','FontSize',12,'Enable','off');
% Load specified as AMA 8/24/20 Changed to drop down menu
myhandles.ui.act3d_loadtype=uicontrol(act3dPanel,'Style','popup','Tag','loadtype','String',{'N','% Abduction Max','% Arm weight'},'Units','normalized','Position',[0.6 .07 .35 0.23],'FontSize',14,'Callback',@ACT3D_loadtype_Callback);
% myhandles.ui.act3d_loadbg1 = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG1','SelectionChangedFcn',@ACT3D_loadbg1_Callback,'Position',[0.59 .2 .36 0.18],'BorderType','none');
% uicontrol(myhandles.ui.act3d_loadbg1,'Style','radiobutton','Tag','max','String','% Abduction Max','Units','normalized','Position',[0 0.66 1 0.33],'FontSize',12);
% uicontrol(myhandles.ui.act3d_loadbg1,'Style','radiobutton','Tag','wgh','String','% Arm weight','Units','normalized','Position',[0 0.33 1 0.33],'FontSize',12);
% myhandles.ui.act3d_absload=uicontrol(myhandles.ui.act3d_loadbg1,'Style','radiobutton','Tag','abs','String','Value in N','Units','normalized','Position',[0 0 1 0.33],'FontSize',12);
% myhandles.ui.act3d_loadbg1.SelectedObject=myhandles.ui.act3d_absload;
% Load on/off
myhandles.ui.act3d_loadbg = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG2','SelectionChangedFcn',@ACT3D_loadbg_Callback,'Position',[0.4 0.05 .55 .12]);
uicontrol(myhandles.ui.act3d_loadbg,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0.15 0 0.45 1],'FontSize',12);
myhandles.ui.act3d_loadoff=uicontrol(myhandles.ui.act3d_loadbg,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.7 0 0.45 1],'FontSize',12);
myhandles.ui.act3d_loadbg.SelectedObject=myhandles.ui.act3d_loadoff;

%% Experimental Setup Panel
expPanel = uipanel('Title','Experimental Setup','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.01,0.01,0.3,0.53]);
% Arm length
uicontrol(expPanel,'Style','text','String','Upper arm length (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.6,0.1],'FontSize',12);
myhandles.ui.exp_ualength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.armLength),'Callback',@EXP_UALength_Callback,'Tag','UALength','HorizontalAlignment','center','Units','normalized','Position',[.65 .9 .3 .1],'UserData','right','FontSize',12);
% Elbow to hand (3rd MCP) distance
uicontrol(expPanel,'Style','text','String','Elbow to hand (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.73,0.6,0.1],'FontSize',12);
myhandles.ui.exp_ehlength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.e2hLength),'Callback',@EXP_EHLength_Callback,'Tag','EHLength','HorizontalAlignment','center','Units','normalized','Position',[.65 .6 .3 .1],'UserData','right','FontSize',12);
% End effector to hand (3rd MCP) distance
uicontrol(expPanel,'Style','text','String','End effector to elbow (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.58,0.6,0.1],'FontSize',12);
myhandles.ui.exp_eeelength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.ee2eLength),'Callback',@EXP_EELength_Callback,'Tag','EELength','HorizontalAlignment','center','Units','normalized','Position',[.65 .75 .3 .1],'UserData','right','FontSize',12);
% Shoulder abduction angle - used to compute shoulder position
uicontrol(expPanel,'Style','text','String','Shoulder Abduction (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.43,.6,.1],'FontSize',12);
myhandles.ui.exp_abdangle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.abdAngle),'Callback',@EXP_abdAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .45 .3 .1],'UserData','right','FontSize',12);
% Shoulder horizontal flexion angle - used to compute shoulder position
uicontrol(expPanel,'Style','text','String','Shoulder Horizontal Flexion (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.28,.6,.1],'FontSize',12);
myhandles.ui.exp_shfAngle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.shfAngle),'Callback',@EXP_shfAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .3 .3 .1],'UserData','right','FontSize',12);
% Elbow flexion angle - used to compute shoulder position
uicontrol(expPanel,'Style','text','String','Elbow Flexion (deg)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.13,.6,0.1],'FontSize',12);
myhandles.ui.exp_elfAngle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.elfAngle),'Callback',@EXP_elfAngle_Callback,'Tag','EFAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .15 .3 .1],'UserData','right','FontSize',12);
% Arm selection (right or left) button group
armbg = uibuttongroup('Parent',expPanel,'Tag','ArmBG','SelectionChangedFcn',@EXP_armbg_Callback,'Position',[0.05 0.02 0.9 0.1],'BorderType','none');
uicontrol(armbg,'Style','radiobutton','Tag','right','String','Right arm','Units','normalized','Position',[0.2 0 0.4 0.9],'FontSize',12);
uicontrol(armbg,'Style','radiobutton','Tag','left','String','Left arm','Units','normalized','Position',[0.65 0 0.4 0.9],'FontSize',12);

%% DAQ Panel
daqPanel = uipanel('Title','DAQ','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.7,0.35,0.3]);
% Number of channels
uicontrol(daqPanel,'Style','text','String','# of Channels','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.85,.5,.1],'FontSize',12);
myhandles.ui.daq_nChan = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.nChan),'Tag','numChan','Callback',@DAQ_nChan_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .84 .3 .15],'FontSize',12);
% Sampling rate
uicontrol(daqPanel,'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.65,.6,0.1],'FontSize',12);
myhandles.ui.daq_srate = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.sRate),'Tag','sampRate','Callback',@DAQ_sRate_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .64 .3 .15],'FontSize',12);
% Sampling length
uicontrol(daqPanel,'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.45,0.6,0.1],'FontSize',12);
myhandles.ui.daq_stime = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.sTime),'Tag','sampTime','Callback',@DAQ_sTime_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .44 .3 .15],'FontSize',12);
% Realtime DAQ Checkbox
myhandles.ui.daq_rt = uicontrol(daqPanel,'Style','checkbox','String','Realtime DAQ','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_RT_Callback,'Position',[0.55 0.3 0.4 0.1],'FontSize',12);
myhandles.daq.rt = 0;
% TTL Checkbox
myhandles.ui.daq_ttl = uicontrol(daqPanel,'Style','checkbox','String','TTL Pulse','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_TTL_Callback,'Position',[0.15 0.3 0.3 0.1],'FontSize',12);
myhandles.daq.ttl = 0;
% Initialize DAQ pushbutton 
uicontrol(daqPanel,'Style','pushbutton','Callback',@DAQ_Init_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.2 0.02 0.6 0.24],'FontSize',12);
% Timer - not enabled in this version
% tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% myhandles.Timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.Timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);

%% Protocol Panel
proPanel = uipanel('Title','Experimental Protocol','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.34,0.35,0.35]);
% File name
uicontrol(proPanel,'Style','text','String','File Name','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.5,0.1],'FontSize',12);
myhandles.ui.exp_fname = uicontrol(proPanel,'Style','edit','String',myhandles.exp.fname,'Callback',@EXP_fname_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.55 .9 .4 .1],'FontSize',12);
% Trial number
uicontrol(proPanel,'Style','text','String','Trial number','HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.73,0.5,0.1],'FontSize',12);
myhandles.ui.exp_itrial = uicontrol(proPanel,'Style','edit','String',num2str(myhandles.exp.itrial),'HorizontalAlignment','Center','Callback',@EXP_iTrial_Callback,'Units','normalized','Position',[0.55 0.75 0.4 0.1],'FontSize',12);
% Locate shoulder and weigh arm pushbutton 
myhandles.ui.exp_pblswa=uicontrol(proPanel,'Style','pushbutton','Callback',@EXP_LSWA_Callback,'HorizontalAlignment','center','String','<html><center>LOCATE SHOULDER<br/>WEIGH ARM<br/>SET HOME TARGET</center></html>','Units','normalized','Position',[0.05 0.45 0.4 0.2],'FontSize',12,'BackgroundColor','c','Enable','off');
% Get max SABD button 
myhandles.ui.exp_pbmsabd=uicontrol(proPanel,'Style','pushbutton','Callback',@EXP_MSABD_Callback,'HorizontalAlignment','center','String','<html><center>GET MAXIMUM<br/>SABD FORCE</center></html>','Units','normalized','Position',[0.55 0.45 0.4 0.2],'FontSize',12,'BackgroundColor','c','Enable','off');
% Acquire GO button
fighandle.KeyPressFcn = @gKeyPress_Callback;
myhandles.ui.exp_go = uicontrol(proPanel,'Style','pushbutton','Callback',@EXP_Go_Callback,'HorizontalAlignment','center','String','GO! (Press "g")','Units','normalized','Position',[0.2 0.23 0.6 0.17],'FontWeight','Bold','FontSize',12,'Enable','Off','BackgroundColor','g','Enable','off');
% File save directory
myhandles.ui.exp_dir = uicontrol(proPanel,'Style','text','String',sprintf('Data will be saved in %s',pwd),'HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.001,0.9,0.2],'FontSize',12);

%% Monitor Panel
monPanel = uipanel('Title','Signal Monitor','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.01,0.35,0.32]);
% Endpoint vertical force
uicontrol(monPanel,'Style','text','String','Endpoint vertical force (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.74,.55,.18],'FontSize',12);
myhandles.ui.mon_eforce=uicontrol(monPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.74,.4,.18],'FontSize',14,'ForegroundColor','b');
% Endpoint position
uicontrol(monPanel,'Style','text','String','Endpoint position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.57,.5,.18],'FontSize',12);
myhandles.ui.mon_epos=uicontrol(monPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.57,.46,.18],'FontSize',14,'ForegroundColor','b');
% Shoulder position
uicontrol(monPanel,'Style','text','String','Shoulder position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.4,.5,.18],'FontSize',12);
 myhandles.ui.mon_spos=uicontrol(monPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.4,.46,.18],'FontSize',14,'ForegroundColor','b');
% Arm weight
uicontrol(monPanel,'Style','text','String','Arm weight (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.22,.5,.18],'FontSize',12);
myhandles.ui.mon_awgt=uicontrol(monPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.22,.4,.18],'FontSize',14,'ForegroundColor','b');

% Shoulder Abduction Max
uicontrol(monPanel,'Style','text','String','Maximum SABD Force (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.05,.5,.18],'FontSize',12);
myhandles.ui.mon_sabd=uicontrol(monPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.05,.4,.18],'FontSize',14,'ForegroundColor','b');



%% Metria Panel
metPanel = uipanel('Title','Metria Motion Capture','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.68,0.65,0.31,0.35]);
% Motion Capture Checkbox
myhandles.ui.met_on = uicontrol(metPanel,'Style','checkbox','String','Enable Motion Capture','Units','Normalized','Enable','On','Interruptible','on','Callback',@MET_MC_Callback,'Position',[0.05 0.88 0.9 0.1],'FontSize',12);
myhandles.met.on = 0;
% Marker ID and visibility
uicontrol(metPanel,'Style','text','String','Marker ID','HorizontalAlignment','center','Units','normalized','Position',[0.35,0.7,0.25,0.15],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Visible','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.7,0.3,0.15],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Trunk','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.55,0.3,0.15],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Shoulder','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.37,0.3,0.15],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Arm','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.19,0.3,0.15],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Forearm','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.01,0.3,0.15],'FontSize',12);
myhandles.ui.met_markerid(1) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .57 .25 .15],'FontSize',12);
myhandles.ui.met_markerid(2) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .39 .25 .15],'FontSize',12);
myhandles.ui.met_markerid(3) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .21 .25 .15],'FontSize',12);
myhandles.ui.met_markerid(4) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .03 .25 .15],'FontSize',12);
myhandles.ui.met_markervis(1)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.56,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(2)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.38,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(3)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.2,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(4)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.02,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);

%% PPS Panel
ppsPanel = uipanel('Title','Pressure Profile Systems','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.68,0.48,0.31,0.12]);
% Initialize Mats
myhandles.ui.pps_on = uicontrol(ppsPanel,'Style','checkbox','String','Toggle PPS System ','Units','Normalized','Enable','On','Interruptible','on','Callback',@PPS_Callback,'Position',[0.05 0.8 0.9 0.2],'FontSize',13); 

%deleted KCS --> move down to the EXP_displaydata function 
% a = axes('position', [.70,0.04,.28,.39]);
%   grid on
%  grid minor
%  
% colorbar;
% title('Pressure Distribution (psi)');
%             

 

%% GUI MENU ITEMS
% Setup Menu
setupMenu = uimenu(fighandle,'Label','Setup');
% Are the output arguments needed?
uimenu(setupMenu,'Label','Participant Information','Callback',{@EXP_partInfo_Callback,myhandles});

uimenu(setupMenu,'Label','Save Setup','Callback',@EXP_saveSetup_Callback);
uimenu(setupMenu,'Label','Load Setup','Callback',@EXP_loadSetup_Callback);

% ACT3D Menu
act3dMenu = uimenu(fighandle,'Label','ACT3D');
% Are the output arguments needed?
myhandles.ui.menu_off=uimenu(act3dMenu,'Label','Power off','Callback',{@ACT3D_poweroff_Callback,myhandles},'Enable','off');

% Save data in Figure
% guidata(fighandle,myhandles)
end
                                                                            % KCS 8.18.20 In visual Disp need midline? 
                                                                            % KCS 9.15.20 Can't run to get display now because of computations at the end
% Function to create visual feedback display
function [hFig,hAxes,hLine,hLabel]=GUI_AddEXPDisplay(fighandle,myhandles)
% hLine(1) - Cross mark - horizontal
% hLine(2) - Cross mark - vertical
% hLine(3) - endpoint trace
% hLine(4) - home target
larm=(myhandles.exp.armLength+myhandles.exp.e2hLength)/100; % Convert to m
scrsz = get(groot,'ScreenSize'); % 3 - horizontal, 4 - vertical
hFig = figure('NumberTitle','off','OuterPosition',[0.25*scrsz(3) 40 0.75*scrsz(3) scrsz(4)-40],'Color','k','MenuBar','none','CloseRequestFcn',@GUI_closeEXPDisp);
hAxes=axes('visible','on','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','Position',[0.01 0.01 0.98 0.92],'DataAspectRatio',[1 1 1]);
set(hAxes,'xlim',[-0.3 0.3],'ylim',[-0.05 1.15*larm]); % Want both axes to be 0-centered, y-axis equal to 120% arm length, x-axis 80 cm.
hLine=zeros(5,1);
% hLine(1)=line(hAxes,[-0.04 0.04],[0 0],'LineWidth',4, 'Color','w'); % Cross mark - horizontal     % KCS 8.18.20 do these change colors to green once in home?
% hLine(2)=line(hAxes,[0 0],[-0.04 0.04],'LineWidth',4, 'Color','w'); % Cross mark - vertical       % KCS 8.18.20 maybe make green?
% hLine(3)=line(hAxes,[0 0],[0 0],'LineWidth',4, 'Color','b','Visible','off'); % endpoint trace
% hLine(4)=rectangle(hAxes,'Position',[-0.05 -0.05 0.1 0.1],'Curvature',[1 1],'EdgeColor','g','LineWidth',3,'Visible','on'); % home target
% line(hAxes,[0 0],[0 1.2*larm],'LineStyle','--','LineWidth',3, 'Color','w'); % Midline  
% line(hAxes,[-0.6 0.6],[1.1 1.1]*larm,'LineWidth',6,'Color','r'); % Target line
% AMA - changed to run in Matlab 2014
hLine(1)=line([-0.04 0.04],[0 0],'LineWidth',4, 'Color','w'); % Cross mark - horizontal     
hLine(2)=line([0 0],[-0.04 0.04],'LineWidth',4, 'Color','w'); % Cross mark - vertical       
hLine(3)=line([0 0],[0 0],'LineWidth',4, 'Color','b','Visible','off'); % endpoint trace
hLine(4)=rectangle('Position',[-0.05 -0.05 0.1 0.1],'Curvature',[1 1],'EdgeColor','g','LineWidth',3,'Visible','on'); % home target
line([0 0],[0 1.2*larm],'LineStyle','--','LineWidth',3, 'Color','w'); % Midline  
line([-0.4 0.4],[1.1 1.1]*larm,'LineWidth',6,'Color','r'); % Target line

hLabel = uicontrol(hFig,'Style','text','BackgroundColor','k','ForegroundColor','w','HorizontalAlignment','center','Units','normalized','FontSize',30,'Position',[0.4 0.9 0.2 0.09]);
hLabel.String='REACH HERE!';                                                 %KCS 8.18.20 ADDED REACH HERE.. when does this show up? 

end

%% GUI close functions to cleanup once GUI is closed 
                                                                            % KCS 8.17.20 Need to close main GUI first not the Visual Display
function GUI_closeMain(source,event) 
% Close all windows and stop and delete timer when the main window is closed
% This function replaces CloseMainWindow_Callback.m
% set callback for what happens on closing the main window
% set( mainWindow.figureHandle, 'CloseRequestFcn', {@CloseMainWindow_Callback,...
%     mainWindow, emgChannels.figureHandle, initializeRobot.figureHandle, setTargets.figureHandle,...
%     participantParameters.figureHandle, trialParameters.figureHandle,...
%     timerObject, display, judp, haptic, robot, experiment, nidaq, ttl, quanser } );
    myhandles=guidata(source);
    if isfield(myhandles,'robot'), ACT3D_poweroff_Callback(myhandles,[],[],[]); end
    
    if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer); end
%     % Add GUI windows to be closed with the main window
% %     delete(source,timerObject,robot,judp,haptic,experiment,nidaq,ttl);
    delete(myhandles.timer)
    
%     delete(myhandles.judp)
    if isfield(myhandles.daq,'ni'), delete(myhandles.daq.ni); end
    delete(myhandles.ttl)
    if isfield(myhandles.daq,'fig'), delete(myhandles.daq.fig); end
    if isfield(myhandles.exp,'fig'), delete(myhandles.exp.fig); end
    delete(source)
    disp('Goodbye :)');
end

function GUI_closeDAQDisp(source,event)
% Prevent users from closing DAQ window before closing program
    warndlg('Close DAQ display window by disabling DAQ or closing program','ACT3D-TACS',myhandles.CreateStruct);
end

function GUI_closeEXPDisp(source,event)
% Prevent users from closing DAQ window before closing program
    warndlg('Close user feedback display window by closing program','ACT3D-TACS',myhandles.CreateStruct);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Menu Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                            % KCS 9.15.20 Purpose of the menu callbacks? 
% Power off the device (ACT3D menu option)
% AMA - ERROR TOO MANY INPUT ARGUMENTS
function ACT3D_poweroff_Callback(hObject,event,temp,TEMP)
%         myhandles.robot = Robot(myhandles.ipaddress);
%         myhandles.haptic = Haptic(myhandles.robot);
%         % Initialize HM and create haptic objects (table and wall) and bias force
%         myhandles.act3d.state='INITIALIZED';
%     myhandles.robot.SwitchState('fixed');
    if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer); end
%     myhandles.robot.delete()
%     myhandles.haptic.delete()
%     rmfield(myhandles,{'robot','haptic'});
    myhandles.act3d.state='DISCONNECTED';
    myhandles.ui.act3d_state.String=myhandles.act3d.state;
    set(myhandles.ui.act3d_init,'String','INIT')
    
    % Disable load text box, LSWA and MSABD buttons and power off menu
    % option
    myhandles.ui.act3d_load.Enable='off';
    myhandles.ui.exp_pblswa.Enable='off';
    myhandles.ui.exp_pbmsabd.Enable='off';
    myhandles.ui.menu_off.Enable='off';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Timer Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timer callback function - timer object created at startup                 % KCS 8.17.20 Purpose of Timer Callbacks? Constant updating
% Displays user feedback in "real" time.
function ACT3D_Timer_Callback(hObject,event)
    % arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
    databuffer=getappdata(act3dTACS,'databuffer');                          % KCS 8.17.20 Data Buffer? What do 
    % Read current data from ACT3D
    myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
    % update status panel CHANGED TO ONLY ALERT USER IF STATUS IS DIFFERENT FROM
    % CURRENT.
    % set( mainWindow.statusPanel.secondColumn(2), 'String', robot.currentState );
    % Compare current state with intended state and alert if different
%     if ~strcmp(myhandles.robot.currentState,lower(myhandles.act3d.state))
%         disp([myhandles.robot.currentState,'-',myhandles.act3d.state])
%         warndlg(['Warning: ACT3D current state is ' myhandles.robot.currentState '. Power off device and re-initialize'])
%         stop(myhandles.timer)  %KCS 10.2.20 COMMENTED OUT
%         myhandles.ui.act3d_state.Enable='off';
%         return
%     end

    % set( mainWindow.statusPanel.secondColumn(8), 'String', num2str(robot.inertia) );
    % Update monitor variables:
    set(myhandles.ui.mon_eforce,'String',num2str(myhandles.robot.endEffectorForce(3))); % Vertical endpoint force
%     set(myhandles.ui.mon_eforce,'String',num2str(myhandles.robot.endEffectorRotation*180/pi)); % Vertical endpoint force
    hpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp); % Compute hand (3rd MCP) position

    % Update display feedback
                                                                           
                                                                            
%      myhandles.exp.fig,myhandles.exp.hAxis,myhandles.exp.hLine,myhandles.exp.hLabel
%      myhandles.exp.hLine(1) - Cross mark - horizontal
%      myhandles.exp.hLine(2) - Cross mark - vertical
%      myhandles.exp.hLine(3) - home target
     
    hpos=hpos-myhandles.exp.origin(:);
%     hpos=myhandles.robot.endEffectorPosition(:);
% set(myhandles.ui.mon_epos,'String',mat2str(hpos'*100,4));
set(myhandles.ui.mon_epos,'String',num2str([hpos'*100,4],'%7.2f'));

%     set(myhandles.ui.mon_epos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
%     set(myhandles.ui.mon_spos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
    databuffer=[databuffer;hpos'];
    setappdata(act3dTACS,'databuffer',databuffer)

    if strcmp(myhandles.exp.arm,'right'), hpos(1:2)=-hpos(1:2); end % Flip coordinate system so that + is to the right and forward
    set(myhandles.exp.hLine(1),'XData',[hpos(1)-0.05 hpos(1)+0.05],'YData',[hpos(2) hpos(2)]); % Cross mark - horizontal
    set(myhandles.exp.hLine(2),'XData',[hpos(1) hpos(1)],'YData',[hpos(2)-0.05 hpos(2)+0.05]); % Cross mark - vertical
    set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
    drawnow
    
    % Update Signal Monitor Panel Variables
    
    %Added KCS 10.2.2020 -- 
    % Endpoint Vertical force
%     set(uicontrol(monPanel,'Style','text','String',num2str(12),'HorizontalAlignment','left','Units','normalized','Position',[0.56,0.74,.4,.18],'FontSize',14,'ForegroundColor','b');

    
    % set( mainWindow.statusPanel.secondColumn(4), 'String', num2str(robot.endEffectorForce(3)) );
    % compute new finger tip location
    % chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
    % disp('got to line 20 in TimerCallback');
    % display.ComputeArmAngles( robot.endEffectorPosition, robot.endEffectorRotation, arm, chairPosition );
    % disp('got to line 23 in TimerCallback');
    % display.ComputeFingerTipPosition(robot.endEffectorPosition,robot.endEffectorRotation, arm );
    % xval_pos = display.fingerTipPosition(1); %robot.endEffectorPosition(1);
    % yval_pos = display.fingerTipPosition(2); %robot.endEffectorPosition(2);
    % armlength = getappdata(addDisplay.figureHandle,'totalArmLength');
    % xval_pos = display.fingerTipPosition(1); %robot.endEffectorPosition(1);
    % yval_pos = display.fingerTipPosition(2); %robot.endEffectorPosition(2);
    % armlength = getappdata(addDisplay.figureHandle,'totalArmLength');
    % xval_SP=display.shoulderPosition(chairPosition,1);
    % yval_SP=display.shoulderPosition(chairPosition,2);
    % if strcmp(arm,'Right')
    % %     yval_new = -(yval_pos-yval_SP)/armlength;
    % %     yval_new = (-(yval_pos+yval_SP)/armlength)*100;
    %     xval_new = -xval_pos + (xval_SP+0.2);
    %     yval_new = -yval_pos + yval_SP;
    % %     yval_new = -(yval_pos-yval_SP);
    % else
    % %     yval_new = -(yval_pos-yval_SP)/armlength;
    %     xval_new = xval_pos - (xval_SP + 0.15);
    %     yval_new = yval_pos - yval_SP;
    % end
    % set(addDisplay.hline1,'Xdata',[xval_new-0.05 xval_new+0.05],'Ydata',[yval_new yval_new],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0])
    % set(addDisplay.hline2,'Xdata',[xval_new xval_new],'Ydata',[yval_new-0.05 yval_new+0.05],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);
    % %% Before recording any data  
    % if (display.fingerTipPosition(1) - display.home.position(chairPosition,1))^2 +...
    %             (display.fingerTipPosition(2) - display.home.position(chairPosition,2))^2 +...
    %             (display.fingerTipPosition(3) - display.home.position(chairPosition,3))^2 ...
    %              < (display.radius)^2  || ...
    %              ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
    %         %experiment.isPreTrial = 0;
    %         experiment.isInHome = 1;
    %         experiment.targetOnTime = experiment.preTrialTime; %When fingers enter the home sphere
    % %         disp('reached line 126 of timer function');
    %         if experiment.isHomeSphereWhite == 1
    %             disp('Home Reached!')
    %             judp.Write('home color green');
    %             disp('at home, should be green');
    %             %AM edit 10.8.19
    %             set(addDisplay.reachsign,'Visible','on')
    %             %end of AM edit
    % %             set(addDisplay.newCircle,'FaceColor','g'); %removing for now
    % %             disp('reached line 131 of timer function');
    % %%This changes the homeCircle to green when hand hovers above it
    %             %%%set(addDisplay.homeCircle,'FaceColor','g'); %green = [0 1 0.5]; red = [1 0 0.5]
    %            
    % 
    %             experiment.isHomeSphereWhite = 0;
    %         end
    %         if isDaqSwitchChecked == 1
    %             if isTtlChecked == 1
    %                 ttl.Toggle([1 0 0 0]); %TTL to mark when fingers are first in in home sphere
    % %                ttl.Toggle([0 0 0 0]); %TTL to mark when fingers are first in in home sphere
    %             end
    %         end
    %         %disp('reached line 145 of timer function');
    %         display.home.iterationsInside = display.home.iterationsInside + 1;
    %         homeSphereTriggerTime = str2double( get( trialParameters.homeSphereTriggerTimeEditBox, 'String' ) );
    %         if display.home.iterationsInside >  timerFrequency*homeSphereTriggerTime ||...		% 2 seconds
    %             ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
    %             % make the home sphere invisible
    %             judp.Write('home visible off');
    % %             set(addDisplay.newCircle,'FaceColor','g'); %Testing to see if our circle target changes to blue once the green sphere disappears
    %             %%% added by AM while testing (09/11/19)
    %             set(addDisplay.homeCircle,'Visible','off'); %Testing to see if our circle target changes to blue once the green sphere disappears
    %             %%%
    %             disp(['In home for ', num2str(display.home.iterationsInside), ' iterations'])
    % 
    %             experiment.isPreTrial = 0;
    %             
    %             % Moved to Experiment for target to be on during start of experiment
    % %             if strcmp(currentMode,'Target')
    % %                 % make the target sphere visible
    % %                 %set( display.targetSphereHandle, 'Visible', 'on' );   % turn target sphere off
    % %                 judp.Write('target visible on');
    % %                 
    % %             end
    %             
    %             %set( display.fingerTipPositionTraceHandle, 'Visible','on' );
    %             % begin displaying the trace of the tip of the middle finger
    %             % send 'trace visible on'
    %             
    %             %judp.Write('trace visible on');
    %            
    %             %experiment.isRecordingData = 1;
    %             display.home.iterationsInside = 0;
    %             experiment.periodId = tic;
    % %             disp('reached line 208 of timer function');
    % 			% set filename for emg data and start acquiring EMG data
    % 
    % % Commented out for Kacey 6/13/19			
    % %             if isDaqSwitchChecked == 1
    % %                 if isTtlChecked == 1
    % %                     ttl.Toggle([1 1 0 0]); % Mark the time in the home sphere
    % %                 end
    % %             end
    %             %experiment.targetOnTime = experiment.preTrialTime;
    %         end
    %         
    %     else
    %         if experiment.isHomeSphereWhite == 0
    %             judp.Write('home color white');
    %             disp('changed the newCircle to blue when home sphere turned white');
    %             %%%set(addDisplay.newCircle,'FaceColor','b');
    %             experiment.isHomeSphereWhite = 1;
    % %             disp('reached line 226 of timer function');
    %         end
    %         %display.home.iterationsInside = display.home.iterationsInside - 1;
    %         %display.home.iterationsInside = 0;
    % end
    % %% While recording data
    % if experiment.isRecordingData == 1  ||  experiment.isPreTrial == 1
    %     experiment.currentPeriod = toc(experiment.periodId);
    %     experiment.periodId = tic;
    %     %moved up, start recording current trial time at the beginning
    %     experiment.currentIteration = experiment.currentIteration + 1;
    %     experiment.RecordData(robot,display);
    %     experiment.currentTrialTime = experiment.currentTrialTime + experiment.currentPeriod;
    % %     disp('reached line 242 of timer function');
    % end
    % if experiment.isRecordingData == 1 && experiment.isPreTrial == 0
    %     daqParametersPanel = mainWindow.daqParametersPanel;
    %     isDaqSwitchChecked = get( daqParametersPanel.daqSwitchCheckBox, 'Value' );
    %     isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
    % %     if (display.fingerTipPosition(1) - display.home.position(chairPosition,1))^2 +...
    % %             (display.fingerTipPosition(2) - display.home.position(chairPosition,2))^2 +...
    % %             (display.fingerTipPosition(3) - display.home.position(chairPosition,3))^2 ...
    % %              > (display.radius)^2  || ...
    % %              ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
    %                 experiment.isInHome = 1;
    %   
    % if experiment.isInHome == 1
    %             experiment.leaveHome = experiment.currentTrialTime; %Time when fingers leave the home sphere
    %             experiment.isInHome = 0;
    %             experiment.leftHome = 1;
    %          end
    % %          disp('reached line 260 of timer function');
    % % Commented out for Kacey 6/13/19
    % %          if isDaqSwitchChecked == 1
    % %              if isTtlChecked == 1
    % %                  ttl.Toggle([1 1 0 0]); %TTL to mark when finger tips leave the home sphere
    % %                  %judp.Write('home color white'); % Home sphere turns white when you move out of it
    % %              end
    % %          end
    %          
    %    % end
    %     % CHECKING IF TARGET IS REACHED
    %     %A.M. TO-DO: check where target location is getting set and how to make
    %     %sure that it is the home circle that is a % of arm length and not arm
    %     %angles - can print out the fingertip and target locations from TimerCallback to see if it
    %     %is actually inside the target when it looks like it's inside the
    %     %target on screen
    %     % Determing if target has been reached
    %     
    %     %//A.M. Testing by printing values 
    % %     print('FT Pos 1',display.fingerTipPosition(1))
    % %     print('FT Pos 2',display.fingerTipPosition(2))
    % %     print('FT Pos 3',display.fingerTipPosition(3))
    % %     print('Unknown 1',display.target.position(chairPosition,1))
    % %     print('Unknown 2',display.target.position(chairPosition,2))
    % %     print('Unknown 3',display.target.position(chairPosition,3))
    % %     %//
    %     
    %     
    %     if (display.fingerTipPosition(1) - display.target.position(chairPosition,1))^2 +...
    %             (display.fingerTipPosition(2) - display.target.position(chairPosition,2))^2 +...
    %             (display.fingerTipPosition(3) - display.target.position(chairPosition,3))^2 ...
    %              < (display.radius)^2 
    %          
    %          if experiment.leftHome == 1
    %             experiment.targetReached = experiment.currentTrialTime;
    %             experiment.reachedTarget = 1;
    %             disp('Target Reached!')
    %             experiment.leftHome = 0;
    % %             disp('reached line 298 of timer function');
    %          end
    %          
    %         display.target.iterationsInside = display.target.iterationsInside + 1;
    %         targetSphereTriggerTime = str2double( get( trialParameters.targetSphereTriggerTimeEditBox, 'String' ) );
    %         
    %         % Keep target sphere visible for alloted amount of time
    %         if display.target.iterationsInside >  timerFrequency*targetSphereTriggerTime ||...
    %             ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
    %             % make the target sphere invisible
    %             judp.Write('target visible off');
    %             disp(['In target for ', num2str(display.target.iterationsInside), ' iterations'])
    %             display.target.iterationsInside = 0;
    % %             disp('reached line 311 of timer function');
    %         end

    % Commented out for Kacey 6/13/19
    %          if isDaqSwitchChecked == 1
    %              if isTtlChecked == 1
    %                  ttl.Toggle([1 1 1 0]); %TTL to mark when finger tips reach the target
    %              end
    %          end
    %     end
    %     
    %     % end experiment after a designated time has elapsed
    %     maxTrialDuration = str2double( get(trialParameters.maxTrialDurationEditBox,'String') );
    %     if ( experiment.currentTrialTime >= maxTrialDuration + experiment.preTrialTime)
    %         experiment.trialLength = experiment.currentTrialTime - experiment.currentPeriod;
    %         experiment.Terminate( mainWindow, display, trialParameters, emgChannels,...
    %             setTargets, nidaq, ttl, quanser, judp, addDisplay );
    %     end
    %     
    %     % edited 1/10/15
    %     %isSlantSelected = get( mainWindow.trialConditionsPanel.slantToggleButton, 'Value' );
    %     isLoadSelected = get( mainWindow.trialConditionsPanel.loadToggleButton, 'Value' );
    %     isSynergySelected = get( mainWindow.trialConditionsPanel.synergyToggleButton, 'Value' );
    %     %disp('reached line 299 of timer function');
    %     if (isLoadSelected == 1 || isSynergySelected == 1) && experiment.leftHome == 1
    %         % check to see if the person has their hand near the table when the
    %         % target is set to lift
    %         if experiment.tableZ + 0.003 >= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 0
    %             judp.Write('table color red');
    %             disp('should be red- not lifting sufficiently')
    %             %disp('reached line 306 of timer function');
    % %             set(addDisplay.newCircle,'FaceColor','r'); %don't change home
    % %             circle to red yet
    % %             setappdata(circleLift,'FaceColor',[1 0 0.5]) %Sabeen add for Kacey's circle to lift 5.29.19
    %             %Sabeen adding for Kacey to turn her circle red 5.29.19
    %             experiment.isArmCloseToTable = 1;
    %         elseif experiment.tableZ + 0.002 <= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 1
    %             judp.Write('table color blue');
    % %             disp('should be blue- IS lifting sufficiently')
    % %             set(addDisplay.newCircle,'FaceColor','b');
    % %             setappdata(circleLift,'FaceColor',[0 1 0.5]) %Sabeen add for Kacey's circle to lift 5.29.19
    %             %Sabeen adding for Kacey to turn her circle green 5.29.19
    %             experiment.isArmCloseToTable = 0;
    % %             disp('reached line 354 of timer function');
    %         end
    % %         homeEE = display.home.position(chairPosition,1) - display.upperArmLength - display.lowerArmLength - display.elbowToEndEffector;
    % %         currentEE = robot.endEffectorPosition(1);
    % %         angle = 10;
    % %         zdisplacement = (currentEE - homeEE)*cos(angle*pi/180);
    % %         
    % %         if experiment.tableZ + zdisplacement + 0.003 >= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 0
    % %             judp.Write('table color red');
    % %             experiment.isArmCloseToTable = 1;
    % %         elseif experiment.tableZ + zdisplacement + 0.002 <= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 1
    % %             judp.Write('table color blue');
    % %             experiment.isArmCloseToTable = 0;
    % %         end
    %         if experiment.tableZ + 0.002 >= robot.endEffectorPosition(3)
    %             experiment.isArmOnTable = 1;
    %         else
    %             experiment.isArmOnTable = 0;
    %         end
    % %         disp('reached line 373 of timer function');
    %     end
    % 
    % end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ACT3D Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACT3D Initialize Pushbutton - when program started, button allows user to
% initialize ACT3D. It then toggles between NORMAL and FIXED.
function ACT3D_Init_Callback(hObject,event)
switch hObject.String
    case 'INIT'
        hObject.String='NORMAL';
        % Declare robot and haptic classes
        myhandles.robot = Robot(myhandles.act3d);
        myhandles.haptic = Haptic(myhandles.robot);
        % Initialize HM and create haptic objects (table and wall) and bias force
        myhandles.act3d.state='INITIALIZED';
        myhandles.robot.SwitchState(lower(myhandles.act3d.state));
        myhandles.ui.act3d_state.String=myhandles.act3d.state;
        % Create the haptic table in the position and size set in the class declaration (@Haptic.m)
        myhandles.haptic.isHorizontalCreated = myhandles.haptic.Create(myhandles.haptic.horizontalName,myhandles.haptic.isHorizontalCreated,...
            myhandles.haptic.horizontalPosition, myhandles.haptic.horizontalSize);
        % Create a haptic wall - DISABLED HERE
        % myhandles.haptic.isVerticalCreated = haptic.Create(myhandles.haptic.verticalName, myhandles.haptic.isVerticalCreated,...
        %    myhandles.haptic.verticalPosition, myhandles.haptic.verticalSize );
        % Create the vertical load
        myhandles.robot.CreateBiasForce;
        % Create the haptic spring and damper - DISABLED HERE
        %     myhandles.robot.CreateSpring;
        %     myhandles.robot.CreateDamper;
        % Enable load text box, LSWA and MSABD buttons and power off menu
        % option
        myhandles.ui.act3d_load.Enable='on';
        myhandles.ui.exp_pblswa.Enable='on';
        myhandles.ui.exp_pbmsabd.Enable='on';
        myhandles.ui.menu_off.Enable='on';
        % Assign timer callback function and start it
        myhandles.timer.TimerFcn=@ACT3D_Timer_Callback;
        %A.M. testing to see which line of code is causing the TimerFcn error
        myhandles.timer.Name = 'RTD';
        myhandles.timer.ExecutionMode = 'fixedRate'; % Changed to 'queue' from 'fixedrate' mode so that period is on average the set period.
        start(myhandles.timer);
    case 'NORMAL'
        hObject.String='FIXED';
        myhandles.act3d.state='NORMAL';
        myhandles.robot.SwitchState(lower(myhandles.act3d.state));
        myhandles.ui.act3d_state.String=myhandles.act3d.state;
    case 'FIXED'
        hObject.String='NORMAL';
        myhandles.act3d.state='FIXED';
        myhandles.robot.SwitchState(lower(myhandles.act3d.state));
        myhandles.ui.act3d_state.String=myhandles.act3d.state;      
    end
end

% Table option checkbox group
function ACT3D_tablebg_Callback(~,event)
    myhandles.act3d.table = event.NewValue.Tag;
    switch myhandles.act3d.table
        case 'on'
            % check to see if the arm is above the haptic table
            myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
            if myhandles.robot.endEffectorPosition(3) < myhandles.haptic.horizontalPosition(3)
                uiwait(warndlg('Please raise the ACT3D above the haptic table','ACT3D-TACS',myhandles.CreateStruct));
            end
            myhandles.haptic.isHorizontalEnabled = myhandles.haptic.Enable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
        case 'off'
            % turn off horizontal effect AMA THIS GIVES AN ERROR
            myhandles.haptic.isHorizontalEnabled = myhandles.haptic.Disable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName );
    end
% guidata(fighandle,myhandles)
% disp(myhandles.act3d.table)
end

% Set desired ACT3D endpoint vertical force. UIControl enabled when ACT3D
% is initialized. Endpoint force value depends on load value type (% Max
% SABD, % Arm Weight, Absolute in N)
function ACT3D_load_Callback(hObject,event)
    force=str2double(hObject.String);
    
    switch myhandles.act3d.loadtype
        case 'max'
            if force>100 || force<0 
                warndlg('Warning: % Maximum Abduction Force should be between 0 and 100','ACT3D-TACS',myhandles.CreateStruct);
                return
            end
            % 0% is no abduction effort so ACT3D must generate force equal to limb weight
            % 10% means participant needs to generate 10% of max SABD force
            % abductionForceProvided(3) = limbWeight - (percentAbductionMaxValue/100) * abductionMax;
            myhandles.exp.endforce=-force*myhandles.exp.max_sabd/100 - myhandles.exp.arm_weight;
        case 'wgh'
            if force>100 
                uiwait(warndlg('Warning: % Load is greater than 100% Arm Weight','ACT3D-TACS',myhandles.CreateStruct));
            end
            % 100% means participant needs to support the limb and ACT3D 0 N
            % 0% means participant does 0 effort and ACT3D supports limb
            % abductionForceProvided(3) = limbWeight * (percentSupportValue/100) - limbWeight;
     
            myhandles.exp.endforce= abs(myhandles.exp.arm_weight)*force/100 + myhandles.exp.arm_weight;
        case 'abs'
            myhandles.exp.endforce=force;
            
    end
    set(myhandles.ui.mon_awgt,'String',mat2str([myhandles.exp.arm_weight myhandles.exp.endforce])); % Vertical endpoint force
end

% Set the load type = {'abs','max','wgh'} corresponding to (Absolute in N, 
% Max SABD, % Arm Weight)
% If max or wgh, check to see that max SABD or arm weight exist
function ACT3D_loadtype_Callback(source,event)
%     myhandles.act3d.loadtype = event.NewValue.Tag;
    switch source.Value
        case 1
            myhandles.act3d.loadtype='abs';
        case 2
            if ~isfield(myhandles.exp,'max_sabd')
                warndlg('Warning: Measure or Enter Maximum Shoulder Abduction Force first','ACT3D-TACS',myhandles.CreateStruct)
%                 myhandles.ui.act3d_loadbg.SelectedObject=myhandles.ui.act3d_absload;
            end
            myhandles.act3d.loadtype = 'max';
        case 3
            if ~isfield(myhandles.exp,'arm_weight')
                warndlg('Warning: Measure Arm Weight first','ACT3D-TACS',myhandles.CreateStruct)
                return
%                 myhandles.ui.act3d_loadbg.SelectedObject=myhandles.ui.act3d_absload;
            end
            myhandles.act3d.loadtype = 'wgh';
    end
    if isfield(myhandles.exp,'endforce'), ACT3D_load_Callback(myhandles.ui.act3d_load,[]); end
% guidata(fighandle,myhandles)
% disp(myhandles.act3d.loadtype)
end

% Enable vertical force or load {'on','off'}. If haptic table is enabled,
% shift down when enabling load, shift back up when disabling load
function ACT3D_loadbg_Callback(~,event)
    % Load state = {'on','off'}
    myhandles.act3d.loadstate = event.NewValue.Tag;
    switch myhandles.act3d.loadstate
        case 'on'
            % If haptic table enabled, disable, move down 6 cm and enable
            if myhandles.haptic.isHorizontalEnabled
                uiwait(warndlg('\fontsize{12}Warning: Haptic table will be moved down 4 cm','ACT3D-TACS',myhandles.CreateStruct));
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Disable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
                myhandles.haptic.horizontalPosition(3) = -0.24;
                % set position of horizontal haptic effect in robot
                myhandles.haptic.SetPosition(myhandles.haptic.horizontalPosition,myhandles.haptic.horizontalName);
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Enable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
            end
            myhandles.robot.SetExternalForce([0 0 myhandles.exp.endforce]);    
        case 'off'
            myhandles.robot.SetExternalForce([0 0 0]);    
            if myhandles.haptic.isHorizontalEnabled
                % Fix ACT3D before removing table
                uiwait(warndlg('\fontsize{12}Warning: Haptic table will be moved to default position, move ACT-3D above table','ACT3D-TACS',myhandles.CreateStruct));
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Disable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
                myhandles.haptic.horizontalPosition(3) = -0.2;
                % set position of horizontal haptic effect in robot
                myhandles.haptic.SetPosition(myhandles.haptic.horizontalPosition,myhandles.haptic.horizontalName);
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Enable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
            end
    end        
% guidata(fighandle,myhandles)
% disp(myhandles.act3d.loadstate)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DAQ Panel Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to set the number of DAQ channels
function DAQ_nChan_Callback(source,event)
    newNumChan = str2double(source.String);
    %         numChan = myhandles.nChan;
    if newNumChan ~= myhandles.daq.nChan
        myhandles.daq.nChan=newNumChan;
        myhandles.daq.Channels=0:myhandles.daq.nChan-1;

        % Check to make sure specified # of channels is within allowable range
        if newNumChan < 1 || newNumChan > myhandles.daq.maxChannels
            %                 max = myhandles.maxChannels;
            warning = 'Warning: incorrect number of channels entered- min of 1 and max of %d needed for proper usage. Please re-enter appropriate value.';
            str = sprintf(warning,myhandles.daq.maxChannels);
            errordlg(str,'ACT3D-TACS',myhandles.CreateStruct);
            return
        end
        % Update the plots based on the new # of channels
        [myhandles.daq.Axis,myhandles.daq.Line,myhandles.daq.Label]=DAQ_createFig(myhandles.daq.nChan,myhandles.daq.ChannelNames);

    end
end

% Set the sampling rate
function DAQ_sRate_Callback(source,event)
    myhandles.sRate = str2double(source.String);
    if isfield(myhandles.daq,'ni'),
        DAQ_Init_Callback([],[]);
    end
end

% Set the sampling time
function DAQ_sTime_Callback(hObject,event)
    myhandles.sTime = str2num(source.String);
    if isfield(myhandles.daq,'ni'), 
        DAQ_Init_Callback([],[]); 
    end
end

% Set real time DAQ
function DAQ_RT_Callback(hObject,event)
    myhandles.daq.rt = hObject.Value;
    % Change DAQ object to continuous time acquisition
    if myhandles.daq.rt
        % Change DAQ object to continuous time acquisition
        myhandles.daq.ni.IsContinuous = true;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = 0.1*myhandles.daq.sRate;
        for i=1:myhandles.daq.nChan
            set(myhandles.daq.Line(i,1),'XData',[],'YData',[]);
            set(myhandles.daq.Line(i,2),'XData',[],'YData',[]);
        end
        startBackground(myhandles.daq.ni);
    else
        stop(myhandles.daq.ni);
        myhandles.daq.ni.IsContinuous = false;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = 0.1*myhandles.daq.sRate;
    end
end

% Set TTL digital output - EMPTY FOR NOW, FILL IT IN IF NEEDED
function DAQ_TTL_Callback(hObject,event)
end

% Create DAQ object
function DAQ_Init_Callback(source,event)
% Delete DAQ objects if they already exist to avoid errors
if isfield(myhandles.daq,'ni'), delete(myhandles.daq.ni); myhandles=rmfield(myhandles.daq,'ni'); end
% Create DAQ session
myhandles.daq.ni = daq.createSession('ni');
% Add analog input channels specified in myhandles.Channels
myhandles.daq.ni.addAnalogInputChannel(myhandles.daq.Device,floor(myhandles.daq.Channels/8)*16+rem(myhandles.daq.Channels,8),'Voltage');
% Set DAQ object sampling rate and time
myhandles.daq.ni.Rate = myhandles.daq.sRate;
myhandles.daq.ni.DurationInSeconds = myhandles.daq.sTime;
% Add listener object
lh = addlistener(myhandles.daq.ni, 'DataAvailable', @DAQ_localTimerAction);
myhandles.ui.daq_rt.Enable = 'on';

% Create figure to plot EMGs
[myhandles.daq.Axis,myhandles.daq.Line,myhandles.daq.Label]=DAQ_createFig(myhandles.daq.nChan,myhandles.daq.ChannelNames);

% Create databuffer to plot previous EMG values in real time display
myhandles.daq.timebuffer=(0:myhandles.daq.sRate*2-1)'/myhandles.daq.sRate;
% Create data buffer in app for real time data display
setappdata(myhandles.daq.fig,'databuffer',zeros(length(myhandles.daq.timebuffer),myhandles.daq.nChan));

%Enable GO button
myhandles.ui.exp_go.Enable='on';

stop(myhandles.timer)

end

% Function to create the figure and axes objects for DAQ data display
function [hAxis,hLine,hLabel]=DAQ_createFig(nChan,yaxlabel)
    if ~isfield(myhandles.daq,'fig')
        myhandles.daq.fig = figure('Name','EMG DAQ','NumberTitle','off','OuterPosition',[0.25*scrsz(3) 40 0.5*scrsz(3) scrsz(4)-40]);
        myhandles.daq.fig.MenuBar = 'none';
        myhandles.daq.fig.CloseRequestFcn =  @GUI_closeDAQDisp;
    else
        figure(myhandles.daq.fig)
    end
    
    % Create panel of fixed size
%     plotPanel = uipanel('Tag','plotPanel','Position',[0.01,0.01,0.98,0.98]);
    nrows=ceil(nChan/2);
    ncol=2; % Arrange plots in two columns
    axheight=0.98/nrows;
    if nChan>1, axwidth=0.44; else axwidth=0.98; end
    axposx=[0.055, 0.55];
    hAxis=zeros(nChan,1);   % Plot axes
    hLabel=zeros(nChan,1);  % Plot ylabels
    hLine=zeros(nChan,2);  % [rectifiedEMG envelopeEMG] traces -
    for i=1:nChan
%         hAxis(i)=axes(plotPanel,'Position',[axposx(2-mod(i,2)),(nrows-ceil(i/2))*axheight,axwidth,axheight],'XTickLabel','');
        hAxis(i)=axes('Position',[axposx(2-mod(i,2)),(nrows-ceil(i/2))*axheight,axwidth,axheight],'XTickLabel','');
        hLabel(i) = uicontrol('Style','text','BackgroundColor','w','HorizontalAlignment','left','Units','normalized','FontSize',9,'Position',[axposx(2-mod(i,2))+0.3,(nrows-ceil(i/2))*axheight+axheight-0.03,0.14,0.025]);
        ylabel(hAxis(i), yaxlabel{i},'Color','[0.5 0 0.9]','FontWeight','bold');
        hLine(i,1)=line('Parent',hAxis(i),'Xdata',[],'Ydata',[],'Color','b','LineWidth',2);
        hLine(i,2)=line('Parent',hAxis(i),'Xdata',[],'Ydata',[],'Color','r','LineWidth',2);
    end
end

% AMA - function to display data in real time and play beep at 200 ms 
function DAQ_localTimerAction(source, event)
    if ~myhandles.daq.rt
        if source.ScansAcquired == 0.2*myhandles.daq.sRate, play(myhandles.beep, [1 myhandles.beep.SampleRate*0.5]); end
    else
        DAQ_localDisplayData(myhandles.daq.timebuffer,event.Data,myhandles.daq.nChan)
    end
end

% Function to display data in real time - should probably be merged into
% localTimerAction.
function DAQ_localDisplayData(t,data,nChan)
blocksize=size(data,1);
databuffer=getappdata(myhandles.daq.fig,'databuffer');
databuffer=[data;databuffer(1:end-blocksize,:)];
setappdata(myhandles.daq.fig,'databuffer',databuffer)
for i=1:nChan
set(myhandles.daq.Line(i,1),'XData',t,'YData',databuffer(:,i));
set(myhandles.daq.Label(i),'String',num2str([max(databuffer(:,i)) min(databuffer(:,i))],'%.3f  %.3f'));
end
drawnow

% databuffer=getappdata(act3dTACS,'databuffer');                          % KCS 8.17.20 Data Buffer? What do 
% Read current data from ACT3D
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
set(myhandles.ui.mon_eforce,'String',num2str(myhandles.robot.endEffectorForce(3))); % Vertical endpoint force
hpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp); % Compute hand (3rd MCP) position
hpos=hpos-myhandles.exp.origin(:);
set(myhandles.ui.mon_epos,'String',num2str([hpos'*100,4],'%7.2f'));

% databuffer=[databuffer;hpos'];
% setappdata(act3dTACS,'databuffer',databuffer)

if strcmp(myhandles.exp.arm,'right'), hpos(1:2)=-hpos(1:2); end % Flip coordinate system so that + is to the right and forward
set(myhandles.exp.hLine(1),'XData',[hpos(1)-0.05 hpos(1)+0.05],'YData',[hpos(2) hpos(2)]); % Cross mark - horizontal
set(myhandles.exp.hLine(2),'XData',[hpos(1) hpos(1)],'YData',[hpos(2)-0.05 hpos(2)+0.05]); % Cross mark - vertical
% set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
drawnow

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPeriment Setup and Protocol Panels Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Right or Left Arm Checkbox group
function EXP_armbg_Callback(~,event)
myhandles.exp.arm = event.NewValue.Tag;
% guidata(fighandle,myhandles)
% disp(myhandles.exp.arm)
end

% Set upper arm length in cm
function EXP_UALength_Callback(hObject,event)
    myhandles.exp.armLength=str2double(hObject.String);
end

% Set end effector to elbow distance in cm
function EXP_EELength_Callback(hObject,event)
    myhandles.exp.ee2eLength=str2double(hObject.String);
end

% Set forearm (elbow to hand) length in cm
function EXP_EHLength_Callback(hObject,event)
    myhandles.exp.e2hLength=str2double(hObject.String);
end

% Set shoulder abduction angle in degrees
function EXP_abdAngle_Callback(hObject,event)
    myhandles.exp.abdAngle=str2double(hObject.String);
end

% Set shoulder horizontal flexion angle in degrees
function EXP_shfAngle_Callback(hObject,event)
    myhandles.exp.shfAngle=str2double(hObject.String);
end

% Set ebow flextion angle in degrees
function EXP_elfAngle_Callback(hObject,event)
    myhandles.exp.elfAngle=str2double(hObject.String);
end

% function to read in the file name
function EXP_fname_Callback(source,event,varargin)
if length(varargin)==1, source.String = myhandles.exp.partID; end % Called from subjInfo_Close
myhandles.exp.fname = source.String;
myhandles.exp.itrial=1; myhandles.ui.exp_itrial.String=num2str(myhandles.exp.itrial);

if ~isfield(myhandles.exp,'dir')
    myhandles.exp.dir = uigetdir(pwd,'Select Directory to Save Data');
    set(myhandles.ui.exp_dir,'String',myhandles.exp.dir);
end

if exist([myhandles.exp.dir '\' myhandles.exp.fname num2str(myhandles.exp.itrial) '.mat'],'file')==2
    response=questdlg('The data file already exists. Do you want to overwrite it?','ACT3D - Trunk Arm Coordination Study','Yes','No','No');
    if strcmp(response,'No')
        prompt={'Enter the file name:','Enter the trial number:'};
        def={myhandles.exp.fname num2str(myhandles.exp.itrial)};
        dlgTitle='Input File Name';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        myhandles.exp.fname=answer{1};set(source,'String',myhandles.exp.fname);
        myhandles.exp.itrial=str2num(answer{2}); set(myhandles.ui.exp_itrial,'String',num2str(myhandles.exp.itrial))
    end
end
end
% Display and set the trial number
function EXP_iTrial_Callback(hObject,event)
myhandles.exp.itrial = str2num(hObject.String);
if exist([myhandles.exp.dir '\' myhandles.exp.fname num2str(myhandles.exp.itrial) '.mat'],'file')==2
    response=questdlg('The data file already exists. Do you want to overwrite it?','ACT3D - Trunk Arm Coordination Study','Yes','No','No');
    if strcmp(response,'No')
        prompt={'Enter the file name:','Enter the trial number:'};
        def={myhandles.exp.fname num2str(myhandles.exp.itrial)};
        dlgTitle='Input File Name';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        myhandles.exp.fname=answer{1};set(source,'String',myhandles.exp.fname);
        myhandles.exp.itrial=str2num(answer{2}); set(myhandles.ui.exp_itrial,'String',num2str(myhandles.exp.itrial))
    end
end
end

% Locate shoulder, weigh arm and set home target button. Make this a two
% step procedure: 1) set midline 2) set home target and weigh arm
% Based on locateShoulderPushButton_Callback in CreateInitializeRobotCallbacks.m
function EXP_LSWA_Callback(hObject,event)
stop(myhandles.timer);

% Make sure table is ON and if it isn't, alert user to turn it on before
% calling function
if myhandles.ui.act3d_tablebg.SelectedObject==myhandles.ui.act3d_tableoff
    warndlg('Turn virtual table ON before calling locate shoulder procedure','ACT3D-TACS',myhandles.CreateStruct);
    return
end

% If device is in FIXED state, switch to NORMAL
if strcmp(myhandles.robot.currentState,'fixed')
    uiwait(msgbox('\fontsize{12}Switching to NORMAL state','ACT3D-TACS',myhandles.CreateStruct));
    set(myhandles.ui.act3d_state,'String','NORMAL');
    ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
%     myhandles.act3d.state='NORMAL';
%     myhandles.robot.SwitchState(lower(myhandles.act3d.state));
%     myhandles.ui.act3d_state.String=myhandles.act3d.state;
end

% Prompt user to align tip of middle finger with participant's midline
uiwait(msgbox('\fontsize{12}Move 3rd MCP joint in front of sternum with elbow at 90 degrees','ACT3D-TACS',myhandles.CreateStruct));

% switch the robot to FIXED state to keep the participant's arm still
set(myhandles.ui.act3d_state,'String','FIXED');
ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
% myhandles.act3d.state='FIXED';
% myhandles.robot.SwitchState(lower(myhandles.act3d.state));
% myhandles.ui.act3d_state.String=myhandles.act3d.state;

% Read endpoint effector position
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
myhandles.exp.midpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp);
myhandles.exp.origin(1)=myhandles.exp.midpos(1);

% Switch to NORMAL state
uiwait(msgbox('\fontsize{12}Switching to NORMAL state','ACT3D-TACS',myhandles.CreateStruct));
set(myhandles.ui.act3d_state,'String','NORMAL');
ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
% myhandles.act3d.state='NORMAL';
% myhandles.robot.SwitchState(lower(myhandles.act3d.state));
% myhandles.ui.act3d_state.String=myhandles.act3d.state;

% Prompt user to align tip of middle finger with participant's midline
uiwait(msgbox('\fontsize{12}Move 3rd MCP joint in front of shoulder with elbow at 90 degrees','ACT3D-TACS',myhandles.CreateStruct));

% switch the robot to FIXED state to keep the participant's arm still
set(myhandles.ui.act3d_state,'String','FIXED');
ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
% myhandles.act3d.state='FIXED';
% myhandles.robot.SwitchState(lower(myhandles.act3d.state));
% myhandles.ui.act3d_state.String=myhandles.act3d.state;


% Read endpoint effector position
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
myhandles.exp.hometar=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp);
myhandles.exp.shpos=getshoulderpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp);
% myhandles.exp.origin(2:3)=myhandles.exp.hometar(2:3);
myhandles.exp.origin(2:3)=myhandles.exp.shpos(2:3);
myhandles.exp.hometar=myhandles.exp.hometar-myhandles.exp.origin';
myhandles.exp.shpos=myhandles.exp.shpos-myhandles.exp.origin;
myhandles.exp.arm_weight=myhandles.robot.endEffectorForce(3);
% num2str([hpos'*100,4],'%7.2f'));
set(myhandles.ui.mon_spos,'String',num2str([myhandles.exp.hometar'*100,4],'%7.2f')); 
set(myhandles.ui.mon_awgt,'String',mat2str(myhandles.exp.arm_weight)); % Vertical endpoint force

if strcmp(myhandles.exp.arm,'right'),
    set(myhandles.exp.hLine(4),'Position',[-myhandles.exp.hometar(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
end

start(myhandles.timer);

end

% Get maximum shoulder abduction force
function EXP_MSABD_Callback(hObject,event)
% switch the robot to FIXED state to keep the participant's arm still
stop(myhandles.timer)
if strcmp(myhandles.act3d.state,'NORMAL')
    uiwait(msgbox('\fontsize{12}Switching to NORMAL state, move to home position','ACT3D-TACS',myhandles.CreateStruct));
    set(myhandles.ui.act3d_state,'String','FIXED');
    ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
end
zforce=zeros(2000,1);
i=0;
tic
while toc<5
    i=i+1;
    myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
    zforce(i)=myhandles.robot.endEffectorForce(3);
    set(myhandles.ui.mon_eforce,'String',num2str(zforce(i),4)); % Vertical endpoint force
end
myhandles.exp.max_sabd=max(zforce);
% Change this to display in a field created for max SABD force
set(myhandles.ui.mon_sabd,'String',num2str(myhandles.exp.max_sabd,4)); % Vertical endpoint force

start(myhandles.timer)

end
%% 

% Go button
function EXP_Go_Callback(hObject,event)
hObject.Enable = 'off';

% If running real time daq, stop first
myhandles.daq.rt=0;
DAQ_RT_Callback(myhandles.ui.daq_rt,event)
myhandles.ui.daq_rt.Enable = 'off'; % disable realtime checkbox

%START EMG and PPS
[data,t]=startForeground(myhandles.daq.ni);
myhandles.pps.StartPPS
if ~isfield(myhandles.exp,'dir'), myhandles.exp.dir=pwd; end



% Once data collection is over, plot EMGs, ACT-3D endpoint trajectory,
% Metria and PPS data
EXP_displayData(myhandles.daq.nChan, t, data, myhandles.daq.sRate, [myhandles.exp.dir,'\',myhandles.exp.fname,num2str(myhandles.exp.itrial),'.mat']);
myhandles.exp.itrial = myhandles.exp.itrial+1;
myhandles.ui.exp_itrial.String = num2str(myhandles.exp.itrial);
hObject.Enable = 'on';
myhandles.daq.rt.Enable = 'on';

%%
% Function to plot data at the end of the data acquisition: EMG,
% Kinematics, Pressure
function EXP_displayData(nChan, t, data, sRate, filename)
%PPS Data Read and Stop
myhandles.pps.ReadData
myhandles.pps.StopPPS
    
    % Plot EMG data in EMG figure
    % Compute the rectified average EMG
    meandata=meanfilt(abs(data),0.1*sRate);

    for i=1:nChan
%             get(myhandles.Line(i,1),'XData')
%             get(myhandles.Line(i,2),'XData')
        set(myhandles.daq.Line(i,1),'XData',t,'YData',abs(data(:,i))); 
        set(myhandles.daq.Line(i,2),'XData',t,'YData',meandata(:,i));
        set(myhandles.daq.Label(i),'String',num2str(max(meandata(:,i)),'%.3f  '));
    end
    drawnow
    
    
    
    % ADD IN PPS DISPLAY IN myhandles.exp.hpAxis using contourf 
  

    

    
    
    % Add code to show trajectory CoP during trial
    
    %how to track center of pressure of the mat function in matlab? Maybe
    %don't need here but can do after in analysis
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Nayo's Code for plotting
%     
%     
% % Create new window to plot PPS Data post trial
% %   [nsamples x cells]
%             
%             cla(pressureMat.axisPressureMat);
%             axes(pressureMat.axisPressureMat);
%             
%             t_pps_length = length(find(pps.time_out)); % # of frames read
%             t = zeros(1,length(obj.data(2,:))); % # of columns in obj.data
%             t_pps = zeros(1,t_pps_length); % time in # of frames
%          
%             %Image_plot = zeros(25, 17);
%             Image_plot = zeros(27, 21); %<= updated for new pressure mat 3/2/18
%             
%             % Reconstruct time vector for ACT3D data. Replace with cumsum
%             % and correct for t(1) instead of 1440
%             for i = 1:length(obj.data(2,:))
%                 t(i) = sum(obj.data(2,1:i));
%             end
%             
%             % Replace with t=t-t(1);
%             for j = 2:length(t)
%                 t(j) = t(j) - t(1);
%             end
%             
%             t(1) = 0;
%             
%             
% 
% % Replace sampling rate with PPS scan rate
%             t_pps(1,:)=(t_pps(1,:)-t_pps(1,1))/myhandles.exp.pSrate;
%             % PPSdata [framesize x nscans]
%             PPSdata = pps.data_out;
%             
%             SumOfPPSdata = nansum(PPSdata); % sum pressure across whole mat [1 x nscans]
%             SumOfPPSdata = SumOfPPSdata(1:t_pps_length); % Remove beyond scanned frames
%             
%      
%             
%             [temp2, max_index] = max(SumOfPPSdata); % Max pressure across mat and time
%             
%             %Image_plot_temp = pps.data_out(:,max_index); %<= Does not call the adjusted data which sets values <0.5 to zero
%             Image_plot_temp = PPSdata(:,max_index); % Data where max occurred
%             
%             numElementRows = size(Image_plot,1); 
%             numElementCol = size(Image_plot,2);
%             
% %             for z = 1:17
% %                 Image_plot(1:25, z) = Image_plot_temp(25*(z-1)+1:25*z, 1);
% %             end
%             
% %           Replace with reshape(Image_plot_temp, numElementRows,
% %           numElementCol)
%             for z = 1:numElementCol
%                 Image_plot(1:numElementRows, z) = Image_plot_temp(numElementRows*(z-1)+1:numElementRows*z, 1);
%             end
%             % z 1 2 3 4.....ncol
%             % 1 
%             % 2
%             % 3
%             % .
%             % .
%             %nrows
%             
%             
%             % line(pps.maxTime{1,i},pps.maxPressure{i});
%             %             subplot (4,2,[1 3]);
%             %             surf(Image_plot');
%             %             colorbar;
%             %             title('pressure distribution (psi)');
%             
%             %             subplot (4,2,[1 3]);
%             
%             %contourf(Image_plot([1:22],2:17)');
%             contourf(Image_plot(1:numElementRows,1:numElementCol)');
%             ylabel('Fingers', 'FontWeight', 'bold')
% %             figure
% %             imagesc(Image_plot(1:numElementRows,1:numElementCol)');
% %             ylabel('Fingers', 'FontWeight', 'bold')
%             
% 
%             colorbar;
%             title('Pressure Distribution (psi)');
%             
% %            
% %  
%             
%     
% end

    
    
    
    
    
    
    
     % AMA - only save the time and data matrices. All the other
     % parameters should be saved in a setup file
    save(filename,'t','data');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% METria Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to initialize METria system Motion Capture
function MET_MC_Callback(hObject,event)
myhandles.met.on=1;

socket = metriaComm_openSocket(myhandles.met.port);
metriahandles.socket = socket;

% disp('socket: ');
% disp(socket);
%         handles.pbAcquire.Enable = 'off';
% Call the initialization mex function that opens the port --> need
% to have the function return a handle to the port so that we can
% send and read from it, and close it when finished
metriahandles.blflag=[0 0 0]; % used to indicate which segments have had landmarks digitized (thorax, scapula, humerus)

[metriahandles,metriahandles.hLine,metriahandles.hText,metriahandles.hPatch]=InitDisplay(metriahandles);

metriahandles.daqtimer = createTimer(metriahandles);

set(metriahandles.textbox3,'String','System ready');
metriahandles.digitPB.Enable = 'on';
metriahandles.rbRTDaq.Enable = 'on';
metriahandles.rbTDisp.Enable = 'on';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%KCS 10.21.20 - adding PPS callback function
%% PPS Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to initialize PPS sytem-- USES PPS1 Class

function PPS_Callback(hObject,event)
    disp('In PPS Callback')
    myhandles.pps = PPS;
    % Create axes for the two mats and save in myhandles.exp.hpAxis
    myhandles.pps.Initialize;
    
    % Plot baseline (contourf)

    %Added 11.6.2020 to reshape and transpose data matrix so elements
    %arranged in order and orientation as the pressure mat
    
    %mat 1 myhandles.pps.

newdatamat1 = myhandles.ans.data_out(1:5000,1:256);
avgbaselinemat1 = mean(newdatamat1);
avgbaselinemat1 = reshape(avgbaselinemat1,16,16);
avgbaselinemat1 = reshape(avgbaselinemat1',16,16);


    %mat 2

newdatamat2 = myhandles.ans.data_out(1:5000,257:end);
avgbaselinemat2 = mean(newdatamat2);
avgbaselinemat2 = reshape(avgbaselinemat2,16,16);
avgbaselinemat2 = reshape(avgbaselinemat2',16,16);

% because of how contour f works (columns x axis) fine to stop here, but if using imagesc
 % or something different may need avgbaselinemat2 = flip(avgbaselinemat2)

figure
subplot(2,1,1)
contourf(avgbaselinemat1,'--') 
title('Pressure Mat 1')
colorbar
subplot(2,1,2)
contourf(avgbaselinemat2,'--')
title('Pressure Mat 2')
colorbar
    
    
   % In Go button with ACT3D, DAQ and Metria starts 
%     pps.StartPPS;  
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Menu Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Participant Info window
function EXP_partInfo_Callback(hObject,event)
% Create figure and add text and edit components
scrsz = get(groot,'ScreenSize');
h = figure('Name','Participant Information','NumberTitle','off','OuterPosition',[0.7*scrsz(3) 0.4*scrsz(4) 0.3*scrsz(3) 0.6*scrsz(4)],...
    'MenuBar','none','ToolBar','none');
set(h,'CloseRequestFcn',{@EXP_partInfo_Close,h});
%         subj_fig.Position = [100,100,400,500];
fighandles=guidata(h);
uicontrol(h,'Style','text','FontSize',12,'String','Participant Information','HorizontalAlignment','Center','Units','normalized','Position',[.05,.85,.9,.125]);
uicontrol(h,'Style','text','FontSize',10,'String','Participant ID','HorizontalAlignment','Left','Units','normalized','Position',[.05,.75,.2,.125]);
fighandles.hsubjid=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.83125,.3125,.05],'Callback',@EXP_partInfo_ID);
uicontrol(h,'Style','text','FontSize',10,'String','Experimental Protocol','HorizontalAlignment','Left','Units','normalized','Position',[.05,.65,.2,.125]);
fighandles.hprotocol=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.72125,.5,.05],'Callback',@EXP_partInfo_ExpProt);

uicontrol(h,'Style','text','FontSize',10,'String','Notes','HorizontalAlignment','Left','Units','normalized','Position',[.05,.54,.4,.125]);
fighandles.hnotes=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Max',10,'Min',0,'Visible','on','Position',[.05,.325,.9,.3],'Callback',@EXP_partInfo_Notes);
%         pbZeroFM = uicontrol(targetDAQ.Fig,'Style','pushbutton','Callback',@Zero_FM_Callback,'String','Zero FM','FontWeight','Bold','FontSize',9,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.825 0.400 0.10 0.05]);

if isfield(myhandles.exp,'partID')
    set(fighandles.hpartid,'String',myhandles.exp.partID); 
    set(fighandles.hprotocol,'String',myhandles.exp.Protocol); 
    set(fighandles.hnotes,'String',myhandles.exp.Notes); 
end

guidata(h,fighandles);

uicontrol(h,'Style','pushbutton','Callback',{@EXP_partInfo_Close,h,fighandles},'String','OK','FontSize',12,'Units','normalized','HorizontalAlignment','Center','Position',[.5,.125,.15,.1]);

uiwait(h);
delete(h)
end

function EXP_partInfo_ID(source,event)
    myhandles.exp.partID=source.String;
end

function EXP_partInfo_ExpProt(source,event)
    myhandles.exp.Protocol=source.String;
end

function EXP_partInfo_Notes(source,event)
    myhandles.exp.Notes=source.String;
end

% Function to close the Participant Information window
function EXP_partInfo_Close(hObject,event,varargin)
h=varargin{1};
if length(varargin)>1
    dlghandles=varargin{2};
    myhandles.exp.partID=get(dlghandles.hsubjid,'String');
    myhandles.exp.Protocol=get(dlghandles.hprotocol,'String');
    myhandles.exp.Notes=get(dlghandles.hnotes,'String');
    EXP_fname_Callback('','',myhandles.exp.partID)
end
uiresume(h);
end

% Functions to save and load the experiment setup in a file named subjID_Setup.mat
function EXP_saveSetup_Callback(source,event)
    % AMA ADD ACT3D VARIABLES THAT NEED TO BE SAVED
if isfield(myhandles.exp,'partID')
    setup.exp=struct('Date',date,'partID',myhandles.exp.partID,'Protocol',myhandles.exp.Protocol,'Notes',myhandles.exp.Notes);
    setup.daq=struct('nChan',myhandles.daq.nChan,'Channels',myhandles.daq.Channels,'ChannelNames',{myhandles.daq.ChannelNames},...
        'sRate',myhandles.daq.sRate,'sTime',myhandles.daq.sTime);
    if isfield(myhandles,exp,'dir'), [fname,pname]=uiputfile('','Save the setup file (*.mat)',[myhandles.exp.dir '\' myhandles.exp.partID '_Setup.mat']);
    else [fname,pname]=uiputfile('','Save the setup file (*.mat)',[myhandles.exp.partID '_Setup.mat']);
    end
    % AMA Add dialog box if setup file already exists
    if fname~=0, save(fullfile(pname,fname),'setup');
    else
        warndlg('\fontsize{12}Setup file was not saved','Save Setup','ACT3D-TACS',myhandles.CreateStruct)
    end
else
    warndlg('\fontsize{12}Please fill the participant information form first','Save Setup','ACT3D-TACS',myhandles.CreateStruct);
end
end

function EXP_loadSetup_Callback(source,event)
    % AMA ADD ACT3D VARIABLES THAT NEED TO BE LOADED
if isfield(myhandles.exp,'dir'), [fname,pname] = uigetfile([myhandles.exp.dir '\*.mat'],'Select the setup file (*.mat)');
else [fname,pname] = uigetfile([pwd '\*.mat'],'Select the setup file (*.mat)');
end
% UNCOMMENT THIS BLOCK - WAS GIVING ERROR WITH SUBSETNAMES NOT BEING
% INITIALIZED
% if fname~=0 
%     load(fullfile(pname,fname),'setup');
%     if exist('setup')
%         setnames=fieldnames(setup);
%         for i=1:length(setnames)   % Don't do the same for the filter settings
% %                     if ~strcmp(setnames{i},'filters')
%             eval(['subsetnames=fieldnames(setup.' setnames{i} ');'])
%             for j=1:length(subsetnames)
%                 eval(['myhandles.' setnames{i} '.' subsetnames{j} '=setup.' setnames{i} '.' subsetnames{j} ';'])
%             end
% %                     end
%         end           
%     end
% 
%     % Update ACT3D Variables
%     myhandles.ui.daq_sRate.String=num2str(myhandles.daq.sRate);
%     myhandles.ui.daq_sTime.String=num2str(myhandles.daq.sTime);
%     myhandles.ui.daq_nChan.String=num2str(myhandles.daq.nChan);
%     myhandles.ui.daq_fname.String=num2str(myhandles.daq.fname);
%     % Adjust # of panels
%     [myhandles.daq.Axis,myhandles.daq.Line,myhandles.daq.Label]=DAQ_createFig(myhandles.daq.nChan,myhandles.daq.ChannelNames);
% end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Function to compute the hand position (3rd MCP) from the end effector position
function p=gethandpos(x,th,exp)
% x - ACT3D end effector position
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - hand position

if strcmp(exp.arm,'right')
    p=x(:)+rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
else
    p=x(:)+rotz(th)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
end

end

function p=getshoulderpos(x,th,exp)
% AMA 10/6/20 - Still need to fill in this function
% x - hand (3rd MCP joint) position
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - shoulder position
% Compute shoulder position assuming that the participants trunk is
% parallel to the ACT3D x-axis

if strcmp(exp.arm,'right')
    % p(1) = x(1) - (exp.e2hLength/100)*cos(th) + exp.armLength*cos(exp.elfAngle*pi/180-th);
    % p(2) = x(2) + (exp.e2hLength/100)*sin(th) + exp.armLength*sin(exp.elfAngle*pi/180-th);
    % p(3) = x(3) + sqrt(exp.armLength^2 + exp.e2hLength^2)*cos(exp.abdAngle*pi/180)/100;
    p(1) = x(1);
    p(2) = x(2) + sqrt(exp.armLength^2 + exp.ee2eLength^2)/100;
    p(3) = x(3) + sqrt(exp.armLength^2 + exp.ee2eLength^2)*cos(exp.abdAngle*pi/180)/100;
    
else
    p(1) = x(1);
    p(2) = x(2) - sqrt(exp.armLength^2 + exp.ee2eLength^2)/100;
    p(3) = x(3) + sqrt(exp.armLength^2 + exp.ee2eLength^2)*cos(exp.abdAngle*pi/180)/100;
    
end

            % rotate shoulder abduction angle to 0 degrees in the plane
            % that the subject is reaching
%             adjustedShoulderAbductionAngle = shoulderAbductionAngle - pi/2;
           
            % compute shoulder position using arm measurements and initial end effector position
%  	ShoulderX = tHmPos.m_dCoords[0] - (dForearmLength)*cos(dArmrestAngle) + UAL*cos(dHomeElbowAngle-dArmrestAngle) + dArmRestOffsetX;
% 	ShoulderY = tHmPos.m_dCoords[1] + (dForearmLength)*sin(dArmrestAngle) + UAL*sin(dHomeElbowAngle-dArmrestAngle) + dArmRestOffsetY;
% 	ShoulderZ = tHmPos.m_dCoords[2] + dArmRestOffsetZ;// + (0.5*dShoulderRadius);
% if strcmp(arm,'Right')
 
% AMA - Why isn't the elbow angle used to compute shoulder position???
%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     - obj.elbowToEndEffector * cos(endEffectorRotation)  ...
%                     + obj.upperArmLength * cos(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
% 				obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     + obj.elbowToEndEffector * sin(endEffectorRotation)...
%                     + obj.upperArmLength * sin(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);

%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     - obj.elbowToEndEffector * cos(pi/4)  ...
%                     + obj.upperArmLength * cos(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
% 				obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     + obj.elbowToEndEffector * sin(pi/4)...
%                     + obj.upperArmLength * sin(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
% 
%             % left arm
%             else
%                 % shoulder x position
%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     + obj.upperArmLength * cos( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * cos( endEffectorRotation ) ;
%                 
%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     + obj.upperArmLength * cos( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * cos( pi/4 ) ;
                
                % shoulder y position
%                 obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     - obj.upperArmLength * sin( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * sin( endEffectorRotation );
%                   
%                   obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     - obj.upperArmLength * sin( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * sin( pi/4 );   
%             end
%             
%             obj.shoulderPosition(chairPosition,3) = endEffectorPosition(3) -...
% 				obj.upperArmLength * sin(adjustedShoulderAbductionAngle);
end
end



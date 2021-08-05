function ACT3D_TACS
% AMA 1/7/2020 Adapted from main.m and make.m
% KCS 10.23.20 - adding PPS callback function for checkbox EDITS TO PPS1 CLASS
% AMA 11/2/20 - adding Metria functions

% AMA 11/16/20
% * Add trunk home position
% * Add graphical feedback of trunk home and current position (sphere and
% cube)
% * KCS Populate the PPS figures with CoP
% * Test GO button
% * Check Save Setup and Save data functions DONE
% * Fix Metria mex files to output marker ID and issue with the two cameras

% AMA 11/17/20
% * Fix Metria data to add trunk home position
% * Add graphical feedback of trunk home and current position (sphere and cube)
% * KCS Populate the PPS figures with CoP
% * Fix home target and hand position feedback

% Not using Blender, comment next line
% addpath Blender Blender\BlenderPlayer Blender\create_thread 	% change paths for Blender
% Add the GUI, callback and timer functions to this main program instead of having separate m
% files.
% addpath create_windows create_windows\create_gui_components create_windows\main_window
% addpath callbacks callbacks\main_window_callbacks
% addpath timer
% The appropriate ACT3D API is added in @Robot depending on which device is
% being used
% addpath HapticAPI2 
addpath parallel_port
addpath Metria
% addpath HapticAPI26 % This folder is not in the Kacey folders. Find out why
% addpath pnet % I don't think this one is used as it is not in the code
% folder

% load library used for parallel port
% % % if ( ~libisloaded('inpout32') )
% % %     loadlibrary inpout32 inpout32.h;
% % % end

%% GUI VISUALIZATION CODE
% Start by closing open figures and creating the main figure window for the GUI
close force all;
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


% myhandles.act3d.load=10; ???

% AMA 11/15/20 
% ACT3D variables saved in old version: 1)sample, 2)duration between current and previous samples,
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

% ACT-3D data saved in current version
% Column 1 source.ScansAcquired
% Column 2-4 hand position (3rd MCP)
% Column 5-7 robot.endEffectorPosition
% Column 8 robot.endEffectorRotation(1);
% Column 9-11 robot.endEffectorVelocity;
% Column 12-14 robot.endEffectorForce;
% Column 15-17 robot.endEffectorTorque;

myhandles.act3d.nVars=19;
myhandles.act3d.state='DISCONNECTED';
myhandles.act3d.loadtype='abs';
myhandles.act3d.sRate=50; % Sampling rate for ACT3D data collection and real time feedback
myhandles.act3d.nChan=17;

% Create ACT3D timer
myhandles.timer = timer;
myhandles.timer.period = 1/myhandles.act3d.sRate;    % Timer frequency = 50 hz

% Initialize DAQ variables
myhandles.daq.Device='Dev1';
myhandles.daq.Enable=0;
myhandles.daq.nChan=15; 
myhandles.daq.sRate=1000;
myhandles.daq.sTime=5;
myhandles.daq.Channels = 0:myhandles.daq.nChan-1; % Channel list for DAQ
myhandles.daq.ChannelNames = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','Channel 16','Channel 17','Channel 18','Channel 19','Channel 20','Channel 21','Channel 22','Channel 23','Channel 24'};
% myhandles.ChannelNames = myhandles.ChannelNames(1:myhandles.nChan);
myhandles.daq.maxChannels = 24;
% Initialize beep played at the beginning of each trial (queue for
% participant)
[y,fs]=audioread('beep.wav');
myhandles.beep=audioplayer(y,fs);

myhandles.exp.origin=[0 0 0]'; % Origin for the visual feedback display == midpoint between shoulders
myhandles.exp.armLength=29; % Upper arm length in cm
myhandles.exp.e2hLength=25; % Elbow to hand (3rd MCP) distance in cm
myhandles.exp.ee2eLength=15; % End effector to elbow distance in cm
myhandles.exp.abdAngle=90;
myhandles.exp.shfAngle=45;
myhandles.exp.elfAngle=90;
myhandles.exp.arm = 'right';                                                  
myhandles.exp.fname='trial';
myhandles.exp.itrial=1;
%  myhandles.exp.endforce=5.6;
% myhandles.exp.endpos=[3.24 -2.31 4.56];
myhandles.exp.hometar=[];
myhandles.exp.shpos=[];
myhandles.exp.arm_weight=[];
myhandles.exp.max_sabd=[];
myhandles.exp.isrunning=0;
myhandles.exp.dir=pwd;

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
myhandles.ui.act3d_init=uicontrol(act3dPanel,'Style','pushbutton','Callback',@ACT3D_Init_Callback,'String','INIT','Units','normalized','Position',[0.2 0.6 0.6 0.2],'FontSize',14,'BackgroundColor','y');
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
myhandles.ui.daq_init = uicontrol(daqPanel,'Style','pushbutton','Callback',@DAQ_Init_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.2 0.02 0.6 0.24],'FontSize',12,'Enable','off');
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
metPanel = uipanel('Title','Metria Motion Capture','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.68,0.5,0.31,0.5]);
% Motion Capture Checkbox
myhandles.ui.met_on = uicontrol(metPanel,'Callback',@MET_Init_Callback,'Style','checkbox','String','Enable Motion Capture','Units','Normalized','Enable','On','Interruptible','on','Position',[0.05 0.9 0.9 0.1],'FontSize',12);
myhandles.met.on = 0;
% Marker ID and visibility

uicontrol(metPanel,'Style','text','String','Marker ID','HorizontalAlignment','center','Units','normalized','Position',[0.3,0.8,0.3,0.1],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Visible','HorizontalAlignment','center','Units','normalized','Position',[0.63,0.8,0.3,0.1],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Trunk','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.7,0.3,0.1],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Shoulder','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.55,0.3,0.1],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Arm','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.4,0.35,0.1],'FontSize',12);
uicontrol(metPanel,'Style','text','String','Forearm','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.25,0.3,0.1],'FontSize',12);
myhandles.ui.met_markerid(1) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .72 .25 .1],'FontSize',12);
myhandles.ui.met_markerid(2) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .57 .25 .1],'FontSize',12);
myhandles.ui.met_markerid(3) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .42 .25 .1],'FontSize',12);
myhandles.ui.met_markerid(4) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .27 .25 .1],'FontSize',12);
myhandles.ui.met_markervis(1)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.71,0.25,0.1],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(2)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.56,0.25,0.1],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(3)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.41,0.25,0.1],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(4)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.26,0.25,0.1],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
% Digitize BL pushbutton 
myhandles.ui.met_dig=uicontrol(metPanel,'Style','pushbutton','Callback',@MET_DigitizeBL_Callback,'String','<html><center>DIGITIZE<br/>BONY LANDMARKS</center></html>','Units','normalized','Position',[0.2 0.05 0.6 0.18],'FontSize',14,'BackgroundColor','y','Enable','Off');

%% PPS Panel
ppsPanel = uipanel('Title','Pressure Profile Systems','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.68,0.4,0.31,0.08]);
% Initialize Mats
myhandles.ui.pps_on = uicontrol(ppsPanel,'Style','checkbox','String','Enable PPS System ','Units','Normalized','Enable','On','Interruptible','on','Callback',@PPS_Init_Callback,'Position',[0.05 0.1 0.95 0.9],'FontSize',13); 
% data=load('ppstest.mat');
uicontrol(act3dTACS,'Style','text','String','SEAT','HorizontalAlignment','center','Units','normalized','Position',[0.68,0.37,0.15,0.02],'FontSize',12);
myhandles.ui.pps_ax1 = axes('Position', [.68,0.15,.15,.22],'visible','on','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','DataAspectRatio',[1 1 1]);
% line('Xdata',0:400,'Ydata',0:400,'Marker','o','MarkerSize',2,'Color','y','MarkerFaceColor','y','LineStyle','none')
% set(hAxes,'xlim',[0 200],'ylim',[-0.05 1.15*larm]); % Want both axes to be 0-centered, y-axis equal to 120% arm length, x-axis 80 cm.
uicontrol(act3dTACS,'Style','text','String','BACK','HorizontalAlignment','center','Units','normalized','Position',[0.84,0.37,0.15,0.02],'FontSize',12);
myhandles.ui.pps_ax2 = axes('position', [.84,0.15,.15,.22],'visible','on','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','DataAspectRatio',[1 1 1]);
% line('Xdata',0:400,'Ydata',400:-1:0,'Marker','o','MarkerSize',2, 'Color','w','MarkerFaceColor','w','LineStyle','none')

%% GUI MENU ITEMS
% Setup Menu
setupMenu = uimenu(fighandle,'Label','Setup');
% Are the output arguments needed?
uimenu(setupMenu,'Label','Participant Information','Callback',@EXP_partInfo_Callback);

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
% scrsz = get(groot,'ScreenSize'); % 3 - horizontal, 4 - vertical
scrszpos = get(groot,'MonitorPositions'); % Row 1 Additional monitor, Row2 main monitor
if size(scrszpos,1)==1, 
    hFig = figure('NumberTitle','off','OuterPosition',[0.25*scrszpos(3) 40 0.75*scrszpos(3) scrszpos(4)-40],'Color','k','MenuBar','none','CloseRequestFcn',@GUI_closeEXPDisp);
else
    hFig = figure('NumberTitle','off','OuterPosition',[scrszpos(1,1) 1 scrszpos(1,3) scrszpos(1,4)],'Color','k','MenuBar','none','CloseRequestFcn',@GUI_closeEXPDisp);
end
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
%     databuffer=getappdata(act3dTACS,'databuffer');                          % KCS 8.17.20 Data Buffer? What do 
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
                                                                           
                                                                            
     
    % Update Signal Monitor Panel Variables
%     hpos=myhandles.robot.endEffectorPosition(:);
    set(myhandles.ui.mon_epos,'String',num2str([hpos'*100 myhandles.robot.endEffectorRotation],'%7.2f'));

%     set(myhandles.ui.mon_epos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
%     set(myhandles.ui.mon_spos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
%     databuffer=[databuffer;hpos'];
%     setappdata(act3dTACS,'databuffer',databuffer)

%      myhandles.exp.fig,myhandles.exp.hAxis,myhandles.exp.hLine,myhandles.exp.hLabel
%      myhandles.exp.hLine(1) - Cross mark - horizontal
%      myhandles.exp.hLine(2) - Cross mark - vertical
%      myhandles.exp.hLine(3) - home target
    if strcmp(myhandles.exp.arm,'right'), hpos(1:2)=-hpos(1:2); end % Flip coordinate system so that + is to the right and forward
    set(myhandles.exp.hLine(1),'XData',hpos(1)+[-0.05 0.05],'YData',[hpos(2) hpos(2)]); % Cross mark - horizontal
    set(myhandles.exp.hLine(2),'XData',[hpos(1) hpos(1)],'YData',hpos(2)+[-0.05 0.05]); % Cross mark - vertical
%     set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
    drawnow
    
    
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
        % Enable load text box, LSWA, MSABD and INIT DAQ buttons and power off menu
        % option
        myhandles.ui.act3d_load.Enable='on';
        myhandles.ui.exp_pblswa.Enable='on';
        myhandles.ui.exp_pbmsabd.Enable='on';
        myhandles.ui.menu_off.Enable='on';
        myhandles.ui.daq_init.Enable='on';
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
function DAQ_sTime_Callback(source,event)
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
        % If timer is running, stop
        % Change DAQ object to continuous time acquisition
        myhandles.daq.ni.IsContinuous = true;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = myhandles.daq.sRate/myhandles.act3d.sRate;
        for i=1:myhandles.daq.nChan
            set(myhandles.daq.Line(i,1),'XData',[],'YData',[]);
            set(myhandles.daq.Line(i,2),'XData',[],'YData',[]);
        end
        startBackground(myhandles.daq.ni);
    else
        stop(myhandles.daq.ni);
        myhandles.daq.ni.IsContinuous = false;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = myhandles.daq.sRate/myhandles.act3d.sRate;
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
% So that the DataAvailable event is triggered at 50Hz
myhandles.daq.ni.NotifyWhenDataAvailableExceeds=myhandles.daq.ni.Rate/myhandles.act3d.sRate;
% Add listener object 
% By default the DataAvailable event triggers when 1/10 second worth of data is available for analysis. 
% To specify a different threshold, change the value of NotifyWhenDataAvailableExceeds.
setappdata(act3dTACS,'expdatabuffer',zeros(myhandles.daq.sTime*myhandles.act3d.sRate,myhandles.act3d.nChan));
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
persistent counter
if isempty(counter), counter = 0; end
counter = counter+1;

% Read current data from ACT3D
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);

hpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp); % Compute hand (3rd MCP) position

if myhandles.exp.isrunning
    if source.ScansAcquired == 0.2*myhandles.daq.sRate, play(myhandles.beep, [1 myhandles.beep.SampleRate*0.5]); end
    % Collect ACT-3D data
    data=getappdata(act3dTACS,'expdatabuffer');
    
    % ACT3D Data matrix:
    % Column 1 source.ScansAcquired
    % Column 2-4 hand position (3rd MCP)
    % Column 5-7 robot.endEffectorPosition
    % Column 8 robot.endEffectorRotation(1);
    % Column 9-11 robot.endEffectorVelocity;
    % Column 12-14 robot.endEffectorForce;
    % Column 15-17 robot.endEffectorTorque;

    % Check in case timer interrupt goes over
    if counter<=size(data,1)
        data(counter,:)=[source.ScansAcquired hpos' myhandles.robot.endEffectorPosition',...
            myhandles.robot.endEffectorRotation(1),myhandles.robot.endEffectorVelocity',...
            myhandles.robot.endEffectorForce',myhandles.robot.endEffectorTorque'];
        setappdata(act3dTACS,'expdatabuffer',data);
        if myhandles.met.on,
            metdata=getappdata(act3dTACS,'metdatabuffer');
            metdata(counter,:) = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker);
            setappdata(act3dTACS,'metdatabuffer',metdata);
        else
            metdata=[];
        end
     end

end
% Display the EMG (myhandles.daq.timebuffer, event.Data), ACT3D (hpos,zforce), METRIA (trunk pos) 
DAQ_localDisplayData(myhandles.daq.timebuffer,event.Data,hpos,myhandles.robot.endEffectorRotation(1),myhandles.robot.endEffectorForce(3),metdata)
end

% Function to display data in real time - should probably be merged into
% localTimerAction.
function DAQ_localDisplayData(daqt,daqdata,hpos,eerotation,zforce,metdata)
% if myhandles.daq.rt
% Only show EMG in real time if not running a trial
if ~myhandles.exp.isrunning
    blocksize=size(daqdata,1);
    daqdatabuffer=getappdata(myhandles.daq.fig,'databuffer');
    daqdatabuffer=[daqdatabuffer(blocksize+1:end,:);daqdata];
    setappdata(myhandles.daq.fig,'databuffer',daqdatabuffer)
    for i=1:size(daqdatabuffer,2)
        set(myhandles.daq.Line(i,1),'XData',daqt,'YData',daqdatabuffer(:,i));
        set(myhandles.daq.Label(i),'String',num2str([max(daqdatabuffer(:,i)) min(daqdatabuffer(:,i))],'%.3f  %.3f'));
    end
    drawnow
end

% Update display
set(myhandles.ui.mon_eforce,'String',num2str(zforce)); % Vertical endpoint force
set(myhandles.ui.mon_epos,'String',num2str([hpos'*100, eerotation],'%7.2f'));

if strcmp(myhandles.exp.arm,'right'), hpos(1:2)=-hpos(1:2); end % Flip coordinate system so that + is to the right and forward
set(myhandles.exp.hLine(1),'XData',[hpos(1)-0.05 hpos(1)+0.05],'YData',[hpos(2) hpos(2)]); % Cross mark - horizontal
set(myhandles.exp.hLine(2),'XData',[hpos(1) hpos(1)],'YData',[hpos(2)-0.05 hpos(2)+0.05]); % Cross mark - vertical
% set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
drawnow

% ADD Trunk position display
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
if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer);
elseif myhandles.daq.rt
    myhandles.daq.rt=0;
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
end
myhandles.exp.origin=zeros(3,1); % Reset the origin to zero
% STEP 1
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
disp([myhandles.exp.midpos myhandles.exp.origin])

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
myhandles.exp.shpos=getshoulderpos(myhandles.exp.hometar,myhandles.exp);
myhandles.exp.origin(2:3)=myhandles.exp.shpos(2:3);
myhandles.exp.arm_weight=myhandles.robot.endEffectorForce(3);

disp([myhandles.exp.origin myhandles.robot.endEffectorPosition(:) myhandles.exp.hometar myhandles.exp.shpos])

set(myhandles.ui.mon_spos,'String',num2str([myhandles.exp.hometar'*100 myhandles.robot.endEffectorRotation],'%7.2f')); 
set(myhandles.ui.mon_awgt,'String',mat2str(myhandles.exp.arm_weight)); % Vertical endpoint force

if strcmp(myhandles.exp.arm,'right'),
    set(myhandles.exp.hLine(4),'Position',[-myhandles.exp.hometar(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
end

start(myhandles.timer);

end

% Get maximum shoulder abduction force
function EXP_MSABD_Callback(hObject,event)
% Stop timer or real time DAQ if on
if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer);
elseif myhandles.daq.rt
    myhandles.daq.rt=0;
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
end
% switch the robot to FIXED state to keep the participant's arm still
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

% Restart the timer for ACT3D real time display
start(myhandles.timer)

end
%% 

% Go button
function EXP_Go_Callback(hObject,event)
hObject.Enable = 'off';

% If running real time daq or timer, stop first
if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer);
elseif myhandles.daq.rt
    myhandles.daq.rt=0;
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
    myhandles.ui.daq_rt.Enable = 'off'; % disable realtime checkbox
end

% Turn off trajectory from previous trial
set(myhandles.exp.hLine(3),'Visible','off');

%Initialize data buffers
if myhandles.met.on, setappdata(act3dTACS,'metdatabuffer',zeros(myhandles.daq.sTime*myhandles.act3d.sRate,3+8*myhandles.met.nmarker)); end
setappdata(act3dTACS,'databuffer',zeros(myhandles.daq.sTime*myhandles.act3d.sRate,myhandles.act3d.nChan));

%Start DAQ, PPS and METRIA depending on which is enabled
if isfield(myhandles,'pps'), myhandles.pps.StartPPS; end

% Note that the NIDAQ object has to exist to do the data acquisition. In a
% future version make it optional and allow data acquisition with the timer
[daqdata,daqt]=startForeground(myhandles.daq.ni);

actdata=getappdata(act3dTACS,'databuffer');

% startForeground blocks program flow, so the following code won't be
% executed until data acquisition is done
if isfield(myhandles,'pps')
    % Read data from PPS
    [~,ppst,ppsdata]=myhandles.pps.ReadData;
    ppst=ppst-ppst(1);
    myhandles.pps.StopPPS;
else
    ppsdata=[]; ppst=[];
end
if myhandles.met.on, 
    metdata=getappdata(act3dTACS,'metdatabuffer'); 
else
    metdata=[];
end

% Once data collection is over
% 1) Plot EMGs, ACT-3D endpoint trajectory, Metria and PPS data
% 2) Save trial data
% 3) Update trial number
% if ~isfield(myhandles.exp,'dir'), myhandles.exp.dir=pwd; end

EXP_displayData(actdata, daqt, daqdata, ppsdata, metdata);

% AMA - only save the time and data matrices. All the other parameters should be saved in a setup file
filename=fullfile(myhandles.exp.dir,myhandles.exp.fname,num2str(myhandles.exp.itrial),'.mat');
save(filename,actdata, daqt, daqdata, ppst, ppsdata, metdata)

% Update trial number and enable RT DAQ
myhandles.exp.itrial = myhandles.exp.itrial+1;
myhandles.ui.exp_itrial.String = num2str(myhandles.exp.itrial);
hObject.Enable = 'on';
myhandles.daq.rt.Enable = 'on';
start(myhandles.timer); % Restart timer

end
%%
% Function to plot data at the end of the data acquisition: EMG,
% Kinematics, Pressure
% Edit to make input arguments variable depending on whether we have PPS
% and Metria data
function EXP_displayData(actdata,daqt,daqdata,ppsdata,metdata)
    % Plot EMG data in EMG figure
    % Compute the rectified average EMG
    meandata=meanfilt(abs(daqdata),0.1*myhandles.daq.sRate);

    for i=1:myhandles.daq.nChan
%             get(myhandles.Line(i,1),'XData')
%             get(myhandles.Line(i,2),'XData')
        set(myhandles.daq.Line(i,1),'XData',daqt,'YData',abs(daqdata(:,i))); 
        set(myhandles.daq.Line(i,2),'XData',daqt,'YData',meandata(:,i));
        set(myhandles.daq.Label(i),'String',num2str(max(meandata(:,i)),'%.3f  '));
    end
%     drawnow
    
    % Draw the movement trajectory
    if strcmp(myhandles.exp.arm,'right'),
        set(myhandles.exp.hLine(3),'XData',-actdata(:,2),'YData',-actdata(:,3),'Visible','on');
    else
        set(myhandles.exp.hLine(3),'XData',actdata(:,2),'YData',actdata(:,3),'Visible','on');
    end
%     drawnow
    
    % ADD METRIA DATA DISPLAY - A message indicating if there were markers
    % that were invisible during the trial and the number of frames.
    
    % ADD PPS DISPLAY (CoP) IN myhandles.exp.hpAxis using contourf 
%   set(myhandles.pps_hline(1),'Xdata',PoC(:,1),'Ydata',PoC(:,2))
%   set(myhandles.pps_hline(2),'Xdata',PoC(:,3),'Ydata',PoC(:,4))
    drawnow

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% METria Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to initialize communication with METria system
function MET_Init_Callback(hObject,event)
myhandles.met.on=hObject.Value;

if myhandles.met.on
    % Get marker IDs
    for i=1:length(myhandles.ui.met_markerid)
        myhandles.met.markerid(i)=str2double(get(myhandles.ui.met_markerid(i),'String'));
    end
    % Create met field in myhandles - FUTURE DEVELOPMENT: CODE METRIA AS AN
    % OBJECT
    myhandles.met.port=6111; % Verify the Metria system's address
%     myhandles.met.timer = timer;
%     myhandles.met.timer.period = 1/myhandles.act3d.sRate;    % Timer frequency = 50 hz
%     myhandles.met.timer.TimerFcn=@MET_Timer_Callback;
    myhandles.met.nmarker=4; % Don't include probe here
    % Open port to communicate with Metria system
    myhandles.met.socket = metriaComm_openSocket(myhandles.met.port);
        
    % Enable digitize button
    set(myhandles.ui.met_dig,'Enable','On');
else
    metriaComm_closeSocket(myhandles.met.socket);
%     myhandles=rmfield(myhandles,'met');
end

end

% Function to create GUI to digitize Bony Landmarks with the METria system
function MET_DigitizeBL_Callback(hObject,event)
scrsz = get(groot,'ScreenSize');
digGUI = figure('Name','ACT3D_TACS - METRIA', ...
    'NumberTitle', 'off', 'DeleteFcn',@MET_closeDBLGUI,'OuterPosition',[0.2*scrsz(3) 0.2*scrsz(4) 0.6*scrsz(3) 0.6*scrsz(4)]);
% digGUI.Visible = 'on';
digGUI.MenuBar = 'none';
% movegui(digGUI.Fig,'center')
dig = guihandles(digGUI);
% dig.h=digGUI;
% dig.socket=myhandles.met.socket;
% Create timer
dig.currentSEG=1;
dig.currentBL=1;
dig.fname='BL';

dig.blah = axes('Parent', digGUI,'Units','normal','Position', [0.05 0.2 .43 .55],'Color','k');
rotate3d(dig.blah)
% set(dig.blah.Toolbar,'Visible','on');

% Create text and cube handles
yloc=0.8:-0.2:0.2;
cmap=colormap(parula(5));

for i=1:4
    hText(i)=text('Position',[0.05 yloc(i)],'FontSize',14,'Color',cmap(i,:),'Parent',dig.blah);
end

% Initialize patch objects
plotcube(dig.blah,[],0,[0 0 0],'b'); % Forearm/hand - blue
plotcube(dig.blah,[],0,[0 0 0],'r'); % Humerus - red
plotcube(dig.blah,[],0,[0 0 0],'y'); % Scapula - yellow
plotcube(dig.blah,[],0,[0 0 0],'g'); % Scapula - green
dig.hPatch=plotcube(dig.blah,[],0,[0 0 0],'w'); % Pointer tool - white


% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr) 
plotcube(dig.blah,dig.hPatch(1:6),[5 5 5],[2 2 2],[]);
plotcube(dig.blah,dig.hPatch(7:12),[5 5 5],[5 5 5],[]);
plotcube(dig.blah,dig.hPatch(13:18),[5 5 5],[10 10 10],[]);
plotcube(dig.blah,dig.hPatch(19:24),[5 5 5],[20 20 20],[]);

uicontrol(digGUI,'Style','text','String','Digitize Bony Landmarks','HorizontalAlignment','center','Units','normalized','Position',[0.2,0.85,.6,.1],'FontSize',18,'FontWeight','bold');

dig.Segments = {'Trunk';'Scapula';'Humerus';'Forearm'};
dig.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

uicontrol(digGUI,'Style','text','String','Select Segment','HorizontalAlignment','center','Units','normalized','Position',[0.52,0.75,.2,.1],'FontSize',16);
dig.ui.segmlist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectSEG,'String',dig.Segments,'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.52,0.6,0.2,0.2]);
uicontrol(digGUI,'Style','text','String','Select Bony Landmark','HorizontalAlignment','center','Units','normalized','Position',[0.78,0.75,.2,.1],'FontSize',16);
dig.ui.bllist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectBL,'String',dig.bonylmrks{1},'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.78,0.55,0.2,0.25]);

dig.ui.digbutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_recordBL_Callback,'String','DIGITIZE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.4 0.2 0.1],'BackgroundColor','b');
dig.ui.savebutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_saveBL_Callback,'String','SAVE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.25 0.2 0.1],'BackgroundColor','g','Enable','off');
% metriahandles.backPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','BackgroundColor','blue','Callback',@backPB_Callback,'String','BACK','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.7875 0.50 0.125 0.05]);

% metriahandles.textbox1 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.71,.25,.15,.1]);
% metriahandles.textbox2 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.58,.125,.4,.125]);
% metriahandles.textbox3 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.025,.0125,.9,.1]);

guidata(digGUI,dig)
    
end

% Function to record bony landmark positions
function MET_selectSEG(hObject,event)
dig=guidata(hObject);
dig.currentSEG=get(hObject,'Value');
dig.currentBL=1;
set(dig.ui.bllist,'String',dig.bonylmrks{dig.currentSEG},'Value',dig.currentBL);
guidata(hObject,dig)
end

function MET_selectBL(hObject,event)
dig=guidata(hObject);
dig.currentBL=get(hObject,'Value');
guidata(hObject,dig)
end

% records location of all of the markers - called when click on digitize
% --> will grab and save whole row. what's in row for data coming back from
% metria?
function MET_recordBL_Callback(hObject,event)
dig=guidata(hObject);
% Initialize bl cell array the first time Digitize BL is called
if ~isfield(dig,'bl'), dig.bl=cell(1,5); set(dig.ui.savebutton,'Enable','on'); end
% Inititalize bl matrix the first time Digitize BL for current segment
% is called
if isempty(dig.bl{dig.currentSEG}),dig.bl{dig.currentSEG}=zeros(length(dig.bonylmrks{dig.currentSEG}),3+8*(myhandles.met.nmarker+1)); end
% Read single frame from Metria to digitize current bony landmark
% (dig.currentBL) in current segment (dig.currentSEG) --- UNCOMMENT READS A
% SINGLE FRAME --> communicates with metria
dig.bl{dig.currentSEG}(dig.currentBL,:) = metriaComm_collectPoint(dig.socket,length(dig.Segments)+1); % Include probe
% test = metriaComm_collectPoint(dig.socket,length(dig.Segments))
% disp(dig.bl{dig.currentSEG}(:,1:3))
% disp(dig.bl{dig.currentSEG}(:,4:end))
% disp(size(test))
% If there are more bony landmarks to digitize, update current bony
% landmark index
if dig.currentBL<length(dig.bonylmrks{dig.currentSEG})
    dig.currentBL=dig.currentBL+1;
    set(dig.ui.bllist,'Value',dig.currentBL);
    % If there are NO more bony landmarks to digitize, set current bony
    % landmark index to 1
else
    % If there are more segments to digitize, update current segment index
    if dig.currentSEG<length(dig.Segments)
        dig.currentSEG=dig.currentSEG+1;
        dig.currentBL=1; % Re-initialize bony landmark index
        set(dig.ui.segmlist,'Value',dig.currentSEG);
        MET_selectSEG(dig.ui.segmlist,event)
    else
        % If there are NO more segments (and landmarks) to digitize, update current segment
        % and bony landmark indices
        uiwait(msgbox('\fontsize{12}All bony landmarks have been digitized','ACT3D-TACS',myhandles.CreateStruct));

    end
end
guidata(hObject,dig)

end

function MET_saveBL_Callback(hObject,event)
dig=guidata(hObject);
% Check to see if file already exists to avoid overwriting
if exist(fullfile(myhandles.exp.dir,[dig.fname '.mat']),'file')==2
    response=questdlg('The file already exists. Do you want to overwrite it?','ACT3D - Trunk Arm Coordination Study','Yes','No','No');
    if strcmp(response,'No')
        prompt={'Enter new file name:'};
        def={dig.fname};
        dlgTitle='Input File Name';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        dig.fname=answer{1};
    end
end
save(fullfile(myhandles.exp.dir,dig.fname),'-struct','dig','bl')
guidata(hObject,dig)     

end

% Function called when digitize window is closed
function MET_closeDBLGUI(hObject,event)
dig=guidata(hObject);
if isfield(dig,'bl')
    MET_saveBL_Callback(hObject,event)
end
delete(hObject)
end

%KCS 10.21.20 - adding PPS callback function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PPS Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to initialize PPS sytem-- USES PPS Class
function PPS_Init_Callback(hObject,event)
%     disp('In PPS Callback')
myhandles.pps_on=hObject.Value;

if myhandles.pps_on
    myhandles.pps = PPS('TactArray_Trunk',myhandles.exp.dir);
    % Create axes for the two mats and save in myhandles.exp.hpAxis
    myhandles.pps.Initialize(myhandles.exp.dir);
    set(myhandles.ui.pps_ax1,'Visible','on')
    myhandles.pps_hline(1)=line('Xdata',0,'Ydata',0,'Marker','o','MarkerSize',2,'Color','y','MarkerFaceColor','y','LineStyle','none');

    set(myhandles.ui.pps_ax2,'Visible','on')
    myhandles.pps_hline(2)=line('Xdata',0,'Ydata',0,'Marker','o','MarkerSize',2,'Color','w','MarkerFaceColor','w','LineStyle','none');

else
    myhandles.pps.delete;
    myhandles=rmfield(myhandles,'pps');
    set(myhandles.ui.pps_ax1,'Visible','off')
    set(myhandles.ui.pps_ax2,'Visible','off')
end
    
% AMA Is the code below necessary?
    % Plot baseline (contourf)

    %mat 1 myhandles.pps.

% newdatamat1 = ans.data_out(1:5000,1:256);
% avgbaselinemat1 = mean(newdatamat1);
% avgbaselinemat1 = reshape(avgbaselinemat1,16,16);
% avgbaselinemat1 = reshape(avgbaselinemat1',16,16);
% 
% 
%     %mat 2
% 
% newdatamat2 =ans.data_out(1:5000,257:end);
% avgbaselinemat2 = mean(newdatamat2);
% avgbaselinemat2 = reshape(avgbaselinemat2,16,16);
% avgbaselinemat2 = reshape(avgbaselinemat2',16,16);
% 
% 
% figure
% subplot(2,1,1)
% contourf(avgbaselinemat1,'--')
% title('Pressure Mat 1')
% colorbar
% subplot(2,1,2)
% contourf(avgbaselinemat2,'--')
% title('Pressure Mat 2')
% colorbar
    
    
   % In Go button with ACT3D, DAQ and Metria starts 
%     pps.StartPPS;  
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Menu Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Participant Info window
function EXP_partInfo_Callback(source,event)
% Create figure and add text and edit components
scrsz = get(groot,'ScreenSize');
h = figure('Name','Participant Information','NumberTitle','off','OuterPosition',[0.7*scrsz(3) 0.4*scrsz(4) 0.3*scrsz(3) 0.6*scrsz(4)],...
    'MenuBar','none','ToolBar','none');
set(h,'CloseRequestFcn',{@EXP_partInfo_Close,h});
%         subj_fig.Position = [100,100,400,500];
fighandles=guidata(h);
uicontrol(h,'Style','text','FontSize',12,'String','Participant Information','HorizontalAlignment','Center','Units','normalized','Position',[.05,.85,.9,.125]);
uicontrol(h,'Style','text','FontSize',10,'String','Participant ID','HorizontalAlignment','Left','Units','normalized','Position',[.05,.75,.2,.125]);
fighandles.hpartid=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.83125,.3125,.05],'Callback',@EXP_partInfo_ID);
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
    myhandles.exp.partID=get(dlghandles.hpartid,'String');
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
    setup.exp=struct('Date',date,'partID',myhandles.exp.partID,'Protocol',myhandles.exp.Protocol,'Notes',myhandles.exp.Notes,...
        'arm',myhandles.exp.arm,'armLength',myhandles.exp.armLength,'e2hLength',myhandles.exp.e2hLength,...
        'ee2eLength',myhandles.exp.ee2eLength,'abdAngle',myhandles.exp.abdAngle,'shfAngle',myhandles.exp.shfAngle,...
        'elfAngle',myhandles.exp.elfAngle,'hometar',myhandles.exp.hometar,'shpos',myhandles.exp.shpos,...
        'armweight',myhandles.exp.arm_weight,'max_sabd',myhandles.exp.max_sabd);
    setup.daq=struct('nChan',myhandles.daq.nChan,'Channels',myhandles.daq.Channels,'ChannelNames',{myhandles.daq.ChannelNames},...
        'sRate',myhandles.daq.sRate,'sTime',myhandles.daq.sTime);
    if isfield(myhandles.exp,'dir'), [fname,pname]=uiputfile('','Save the setup file (*.mat)',fullfile(myhandles.exp.dir,[myhandles.exp.partID '_Setup.mat']));
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
if fname~=0 
    load(fullfile(pname,fname),'setup');
    if exist('setup')
        setnames=fieldnames(setup);
        for i=1:length(setnames)   
            eval(['subsetnames=fieldnames(setup.' setnames{i} ');'])
            for j=1:length(subsetnames)
                eval(['myhandles.' setnames{i} '.' subsetnames{j} '=setup.' setnames{i} '.' subsetnames{j} ';'])
            end
        end           
    end

    % Update ACT3D Variables
    myhandles.ui.daq_sRate.String=num2str(myhandles.daq.sRate);
    myhandles.ui.daq_sTime.String=num2str(myhandles.daq.sTime);
    myhandles.ui.daq_nChan.String=num2str(myhandles.daq.nChan);
    myhandles.ui.exp_ualength.String=num2str(myhandles.exp.armLength);
    myhandles.ui.exp_ehlength.String=num2str(myhandles.exp.e2hLength);
    myhandles.ui.exp_eeelength.String=num2str(myhandles.exp.ee2eLength);
    myhandles.ui.exp_abdangle.String=num2str(myhandles.exp.abdAngle);
    myhandles.ui.exp_shfAngl.String=num2str(myhandles.exp.shfAngle);
    myhandles.ui.exp_elfAngle.String=num2str(myhandles.exp.elfAngle);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computation functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Function to compute the hand position (3rd MCP) from the end effector position
function p=gethandpos(x,th,exp)
% x - ACT3D end effector position
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - hand position column vector

if strcmp(exp.arm,'right')
    p=x(:)+rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
else
    p=x(:)+rotz(th)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
end
p=p-exp.origin; % Correct for the origin once it's set


end

% Function to compute the shoulder position based on the hand position and
% known elbow flexion angle.
function p=getshoulderpos(x,exp)
% x - end effector position
% exp - structure with experiment variables
% p - shoulder position in cm
% Compute shoulder position assuming that the participant's trunk is
% parallel to the ACT3D x-axis and the 3rd MCP is aligned with the shoulder

% Compute shoulder position using law of cosines on triangle defined by
% the A) shoulder, B) end effector and C) elbow: AB=sqrt(AC^2+BC^2 - 2*AC*BC*cos(the)
% AB=shoulder to hand distance, AC=armLength, BC=e2hLength

ds2h=sqrt(exp.armLength^2 + exp.e2hLength^2 - 2*exp.armLength*exp.e2hLength*cosd(exp.elfAngle))/100;
if strcmp(exp.arm,'right')
    p=[0; ds2h*sind(exp.abdAngle); ds2h*cosd(exp.abdAngle)];
else
    p=[0; -ds2h*sind(exp.abdAngle); ds2h*cosd(exp.abdAngle)];    
end
p = x(:) + p;    


% From Air Hockey game code          
% compute shoulder position using arm measurements and initial end effector position
%  	ShoulderX = tHmPos.m_dCoords[0] - (dForearmLength)*cos(dArmrestAngle) + UAL*cos(dHomeElbowAngle-dArmrestAngle) + dArmRestOffsetX;
% 	ShoulderY = tHmPos.m_dCoords[1] + (dForearmLength)*sin(dArmrestAngle) + UAL*sin(dHomeElbowAngle-dArmrestAngle) + dArmRestOffsetY;
% 	ShoulderZ = tHmPos.m_dCoords[2] + dArmRestOffsetZ;// + (0.5*dShoulderRadius);
% if strcmp(arm,'Right')

% AMA - Why isn't the elbow angle used to compute shoulder position???
% From Stuart's code
            % rotate shoulder abduction angle to 0 degrees in the plane
            % that the subject is reaching
%             adjustedShoulderAbductionAngle = shoulderAbductionAngle - pi/2;
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

% Function to plot a cube in haxes
function h=plotcube(haxes,hpatch,edges,origin,clr)
% PLOTCUBE - Display a 3D-cube in the current axes
%
%   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES : 1 or 3-element vector that defines the length of cube edges
%   * ORIGIN: 3-element vector that defines the origin point of the cube
%   * COLOR : 3-elements vector that defines the faces color of the cube
%
%   * ALPHA (constant): scalar that defines the transparency of the cube faces (from 0
%             to 1)
%
% Example:
%   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0]);
%   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0]);
%   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]);

alpha=0.7;

XYZ = { ...
    [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
    [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
    [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
    [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
    [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
    [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
    };

if size(edges)<3, edges=repmat(edges,1,3); end

XYZ = mat2cell(...
    cellfun( @(x,y,z) x*y+z , ...
    XYZ , ...
    repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...
    repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
    'UniformOutput',false), ...
    6,[1 1 1]);

if isempty(hpatch)
    cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
        repmat({clr},6,1),...
        repmat({'FaceAlpha'},6,1),...
        repmat({alpha},6,1),...
        repmat({'Parent'},6,1),...
        repmat({haxes},6,1)...
        );
    h=get(haxes,'Children');
else
    cellfun(@set,mat2cell(hpatch,[1 1 1 1 1 1],1),...
        repmat({'XData'},6,1),XYZ{1},...
        repmat({'YData'},6,1),XYZ{2},...
        repmat({'ZData'},6,1),XYZ{3});
end

end
end



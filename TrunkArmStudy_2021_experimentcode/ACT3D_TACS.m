function ACT3D_TACS(varargin)
% AMA 1/7/2020 Adapted from main.m and make.m
% KCS 10.23.20 - adding PPS callback function for checkbox EDITS TO PPS1 CLASS
% AMA 11/2/20 - adding Metria functions

% AMA 11/20/20
% Metria update rate is 13.5 Hz

% AMA 11/19/20
% * Metria feedback - fix (when markers not visible)
% * Make display shorter (move red line closer)
% * Crosshairs off

% AMA 11/16/20
% * Add trunk home position
% * Add graphical feedback of trunk home and current position (sphere and
% cube)

% AMA 11/17/20
% * Fix Metria data to add trunk home position
% * Compiler instruction mex -lws2_32 metriaComm_openSocket.cpp
% * Add graphical feedback of trunk home and current position (sphere and cube)

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

% Used to keep track of timer interrupts (from timer or DAQ objects) to
% save data
global counter

% addpath HapticAPI26 % This folder is not in the Kacey folders. Find out why
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

myhandles.txt_struct=struct('Interpreter','tex','WindowStyle','modal');

% Read input variables if there are any
if ~isempty(varargin)
    if length(varargin)<2
        myhandles.exp.partID=varargin{1};
    else
        myhandles.exp.partID=varargin{1};
        myhandles.exp.arm=lower(varargin{2});
        myhandles.exp.dir=fullfile('D:','Kacey','data',varargin{1},varargin{2});
    end
end
% Each robot has a different IP address, set the correct one here
% AMA - Hard coded this
% Options: 'MC Lab: 10.30.203.26' or 'NI Lab:10.30.203.36'
% myhandles.room='MC Lab/10.30.203.36'; % Neuroimaging lab                                 
% myhandles.ipaddress='10.30.203.36'; 
% myhandles.act3d.id='ACT3D36';
myhandles.act3d.id='ACT3D26';

% Declare class objects
myhandles.robot = Robot(myhandles.act3d.id); 
myhandles.haptic = Haptic(myhandles.robot);
myhandles.ttl = TTL_digital_four_lines;                                     % KCS 8.14.20 Using TTL now with real time metria?Need TTL? Ask how metria working  

% myhandles.judp = Judp;
% myhandles.nidaq = Nidaq; % MOVE TO DAQ_INIT FUNCTION
% quanser = Quanser; % We use NI cards, not Quanser
% display = Display(robot,judp); % Replaced with AddEXPDisplay

% ACT-3D data saved
% Column 1 period in s
% Column 2-4 hand position (3rd MCP)
% Column 5-7 robot.endEffectorPosition
% Column 8 robot.endEffectorRotation(1);
% Column 9-11 robot.endEffectorVelocity;
% Column 12-14 robot.endEffectorForce;
% Column 15-17 robot.endEffectorTorque;

myhandles.act3d.state='DISCONNECTED';
myhandles.act3d.loadtype='abs';
myhandles.act3d.nVars=17;

% MOVED TO INIT_DAQ
% % Initialize DAQ variables
% myhandles.daq.Device='Dev1';
% myhandles.daq.Enable=0;
% myhandles.daq.nChan=16; 
% myhandles.daq.sRate=1000;
% myhandles.daq.sTime=5;
% myhandles.daq.Channels = 0:myhandles.daq.nChan-1; % Channel list for DAQ
% myhandles.daq.ChannelNames = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','ADEL','Channel 17','Channel 18','Channel 19','Channel 20','Channel 21','Channel 22','Channel 23','Channel 24'};
% % myhandles.ChannelNames = myhandles.ChannelNames(1:myhandles.nChan);
% myhandles.daq.maxChannels = 24;
% % Initialize beep played at the beginning of each trial (queue for
% % participant)
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
%  myhandles.exp.endforce=5.6;
% myhandles.exp.endpos=[3.24 -2.31 4.56];
myhandles.exp.hometar=[];
myhandles.exp.shpos=[];
myhandles.exp.arm_weight=[];
myhandles.exp.max_sabd=[];
myhandles.exp.isrunning=0;
myhandles.exp.fname='trial';
myhandles.exp.itrial=1;
myhandles.exp.sTime=5; % The time in seconds of the trial
myhandles.exp.sRate=50; % Sampling rate for experiment data collection (act3d,Metria) and real time feedback
% myhandles.exp.dir=pwd;

myhandles.daq.on=0;
myhandles.met.on=0;
myhandles.pps.on=0;

% Populate the figure with the different panels
myhandles=GUI_AddPanels(act3dTACS,myhandles);

% Create user visual display feedback figure and return the axis, line and   KCS 8.17.20 Why need to return axis of the visual feedback? 
% text handles
[myhandles.exp.fig1,myhandles.exp.hAxis,myhandles.exp.hLine,myhandles.exp.hLabel]=GUI_AddEXPDisplay(act3dTACS,myhandles);

% AMA 11/21/20 Renamed timer object to myhandles.exp.timer and consolidated
% timer callback functions between Windows and NIDAQ timers.
% Create experiment timer
myhandles.exp.timer = timer;
myhandles.exp.timer.period = 1/myhandles.exp.sRate;    % Timer frequency = 50 hz
myhandles.exp.timer.Name = 'EXP_RTD';
myhandles.exp.timer.ExecutionMode = 'fixedRate'; % Changed to 'queue' from 'fixedrate' mode so that period is on average the set period.
% Assign timer callback function and start it
myhandles.exp.timer.TimerFcn=@EXP_localTimerAction;
start(myhandles.exp.timer);

guidata(act3dTACS, myhandles);

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
myhandles.ui.exp_armbg = uibuttongroup('Parent',expPanel,'Tag','ArmBG','SelectionChangedFcn',@EXP_armbg_Callback,'Position',[0.05 0.02 0.9 0.1],'BorderType','none');
uicontrol(myhandles.ui.exp_armbg,'Style','radiobutton','Tag','right','String','Right arm','Units','normalized','Position',[0.2 0 0.4 0.9],'FontSize',12);
uicontrol(myhandles.ui.exp_armbg,'Style','radiobutton','Tag','left','String','Left arm','Units','normalized','Position',[0.65 0 0.4 0.9],'FontSize',12);

%% DAQ Panel
daqPanel = uipanel('Position',[0.32,0.75,0.35,0.25],'Title','DAQ','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]');
% Number of channels
uicontrol(daqPanel,'Units','normalized','Position',[0.05,0.75,.5,.15],'Style','text','String','# of Channels','HorizontalAlignment','left','FontSize',12);
myhandles.ui.daq_nChan = uicontrol(daqPanel,'Units','normalized','Position',[.65 .81 .3 .18],'Style','edit','Tag','numChan','Callback',@DAQ_nChan_Callback,'HorizontalAlignment','center','FontSize',12);
% Sampling rate
uicontrol(daqPanel,'Units','normalized','Position',[0.05,0.52,.6,0.15],'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','FontSize',12);
myhandles.ui.daq_srate = uicontrol(daqPanel,'Units','normalized','Position',[.65 .58 .3 .18],'Style','edit','Tag','sampRate','Callback',@DAQ_sRate_Callback,'HorizontalAlignment','center','FontSize',12);
% Realtime DAQ Checkbox
myhandles.ui.daq_rt = uicontrol(daqPanel,'Units','Normalized','Position',[0.55 0.39 0.4 0.15],'Style','checkbox','String','Realtime DAQ','Enable','Off','Interruptible','on','Callback',@DAQ_RT_Callback,'FontSize',12);
myhandles.daq.rt = 0;
% TTL Checkbox
myhandles.ui.daq_ttl = uicontrol(daqPanel,'Units','Normalized','Position',[0.15 0.39 0.3 0.15],'Style','checkbox','String','TTL Pulse','Enable','Off','Interruptible','on','Callback',@DAQ_TTL_Callback,'FontSize',12);
myhandles.daq.ttl = 0;
% Initialize DAQ pushbutton 
myhandles.ui.daq_init = uicontrol(daqPanel,'Units','normalized','Position',[0.2 0.05 0.6 0.3],'Style','pushbutton','Callback',@DAQ_Init_Callback,'String','Initialize DAQ','FontSize',12,'BackgroundColor',[.5 .5 .5]);
% Timer - not enabled in this version
% tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% myhandles.exp.timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.exp.timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);

%% Protocol Panel
proPanel = uipanel('Position',[0.32,0.3,0.35,0.44],'Title','Experimental Protocol','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]');
% File name
uicontrol(proPanel,'Units','normalized','Position',[0.05,0.86,0.5,0.1],'Style','text','String','File Name','HorizontalAlignment','left','FontSize',12);
myhandles.ui.exp_fname = uicontrol(proPanel,'Units','normalized','Position',[.55 .88 .4 .11],'Style','edit','String',myhandles.exp.fname,'Callback',@EXP_fname_Callback,'HorizontalAlignment','center','FontSize',12);
% % Trial number
uicontrol(proPanel,'Units','normalized','Position',[0.05,0.72,0.5,0.1],'Style','text','String','Trial number','HorizontalAlignment','Left','FontSize',12);
myhandles.ui.exp_itrial = uicontrol(proPanel,'Units','normalized','Position',[0.55 0.74 0.4 0.11],'Style','edit','String',num2str(myhandles.exp.itrial),'HorizontalAlignment','Center','Callback',@EXP_iTrial_Callback,'FontSize',12);
% Sampling length
uicontrol(proPanel,'Units','normalized','Position',[0.05,0.58,0.5,0.1],'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','FontSize',12);
myhandles.ui.exp_sTime = uicontrol(proPanel,'Units','normalized','Position',[0.55,0.6,0.4,0.11],'Style','edit','String',num2str(myhandles.exp.sTime),'Tag','sampTime','Callback',@EXP_sTime_Callback,'HorizontalAlignment','center','FontSize',12);
% Locate shoulder, weigh arm and set home target pushbutton 
myhandles.ui.exp_pblswa=uicontrol(proPanel,'Units','normalized','Position',[0.05 0.34 0.4 0.22],'Style','pushbutton','Callback',@EXP_LSWA_Callback,'HorizontalAlignment','center','String','<html><center>LOCATE SHOULDER<br/>WEIGH ARM<br/>SET HOME TARGET</center></html>','FontSize',12,'BackgroundColor','c','Enable','off');
% Get max SABD button 
myhandles.ui.exp_pbmsabd=uicontrol(proPanel,'Units','normalized','Position',[0.55 0.34 0.4 0.22],'Style','pushbutton','Callback',@EXP_MSABD_Callback,'HorizontalAlignment','center','String','<html><center>GET MAXIMUM<br/>SABD FORCE</center></html>','FontSize',12,'BackgroundColor','c','Enable','off');
% Acquire GO button
fighandle.KeyPressFcn = @gKeyPress_Callback;
myhandles.ui.exp_go = uicontrol(proPanel,'Units','normalized','Position',[0.2 0.11 0.6 0.2],'Style','pushbutton','Callback',@EXP_Go_Callback,'HorizontalAlignment','center','String','GO! (Press "g")','FontWeight','Bold','FontSize',12,'BackgroundColor','g');
% File save directory
if isfield(myhandles.exp,'dir')
    myhandles.ui.exp_dir = uicontrol(proPanel,'Units','normalized','Position',[0.05,0.005,0.9,0.08],'Style','text','String',sprintf('Data will be saved in %s',myhandles.exp.dir),'HorizontalAlignment','Left','FontSize',12);
else
    myhandles.ui.exp_dir = uicontrol(proPanel,'Units','normalized','Position',[0.05,0.005,0.9,0.08],'Style','text','String',sprintf('Data will be saved in %s',pwd),'HorizontalAlignment','Left','FontSize',12);
end    

%% Monitor Panel
monPanel = uipanel('Position',[0.32,0.01,0.35,0.28],'Title','Signal Monitor','FontSize',14,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]');
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
myhandles.ui.pps_tle1 = uicontrol(act3dTACS,'Style','text','String','SEAT','HorizontalAlignment','center','visible','off','Units','normalized','Position',[0.68,0.37,0.15,0.02],'FontSize',12);
myhandles.ui.pps_ax1 = axes('Position', [.68,0.15,.15,.22],'visible','off','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','DataAspectRatio',[1 1 1]);
myhandles.pps.hline(1)=line('Xdata',0,'Ydata',0,'Marker','o','MarkerSize',2,'Color','y','MarkerFaceColor','y','LineStyle','none');
% line('Xdata',0:400,'Ydata',0:400,'Marker','o','MarkerSize',2,'Color','y','MarkerFaceColor','y','LineStyle','none')
% set(hAxes,'xlim',[0 200],'ylim',[-0.05 1.15*larm]); % Want both axes to be 0-centered, y-axis equal to 120% arm length, x-axis 80 cm.
myhandles.ui.pps_tle2 = uicontrol(act3dTACS,'Style','text','String','BACK','HorizontalAlignment','center','visible','off','Units','normalized','Position',[0.84,0.37,0.15,0.02],'FontSize',12);
myhandles.ui.pps_ax2 = axes('position', [.84,0.15,.15,.22],'visible','off','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','DataAspectRatio',[1 1 1]);
myhandles.pps.hline(2)=line('Xdata',0,'Ydata',0,'Marker','o','MarkerSize',2,'Color','w','MarkerFaceColor','w','LineStyle','none');

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
set(hAxes,'xlim',[-0.3 0.3],'ylim',[-0.12 0.8*larm]); % Want both axes to be 0-centered, y-axis equal to 120% arm length, x-axis 80 cm.
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
line([0 0],[-0.12 0.7*larm],'LineStyle','--','LineWidth',3, 'Color','w'); % Midline  
hLine(5)=line([-0.4 0.4],[0.7 0.7]*larm,'LineWidth',6,'Color','r'); % Target line

hLabel = uicontrol(hFig,'Style','text','BackgroundColor','k','ForegroundColor','w','HorizontalAlignment','center','Units','normalized','FontSize',30,'Position',[0.3 0.85 0.4 0.09]);
hLabel.String='REACH HERE!';                                                 %KCS 8.18.20 ADDED REACH HERE.. when does this show up? 

end

%% GUI close functions to cleanup once GUI is closed 
                                                                            
function GUI_closeMain(source,event) 
% Close all windows and stop and delete timer when the main window is closed
% This function replaces CloseMainWindow_Callback.m
% set callback for what happens on closing the main window
% set( mainWindow.figureHandle, 'CloseRequestFcn', {@CloseMainWindow_Callback,...
%     mainWindow, emgChannels.figureHandle, initializeRobot.figureHandle, setTargets.figureHandle,...
%     participantParameters.figureHandle, trialParameters.figureHandle,...
%     timerObject, display, judp, haptic, robot, experiment, nidaq, ttl, quanser } );
%     myhandles=guidata(source);
%     if isfield(myhandles,'robot')
%         ACT3D_poweroff_Callback(myhandles,[],[],[]); 
% end

    if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer); end
    myhandles.haptic.delete()
    myhandles.robot.delete()
    
    if myhandles.met.on, metriaComm_closeSocket(myhandles.met.socket); delete(myhandles.met.fig);end
%     % Add GUI windows to be closed with the main window
% %     delete(source,timerObject,robot,judp,haptic,experiment,nidaq,ttl);
    
%     delete(myhandles.judp)
    if isfield(myhandles.daq,'ni'), delete(myhandles.daq.ni); end
    if myhandles.daq.on, delete(myhandles.daq.fig); end
    delete(myhandles.ttl)
    delete(myhandles.exp.fig1)
    delete(myhandles.exp.timer)
    delete(source)
    disp('Goodbye :)');
end

function GUI_closeDAQDisp(source,event)
% Prevent users from closing DAQ window before closing program
    warndlg('Close DAQ display window by disabling DAQ or closing program','ACT3D-TACS',myhandles.txt_struct);
end

function GUI_closeEXPDisp(source,event)
% Prevent users from closing DAQ window before closing program
    warndlg('Close user feedback display window by closing program','ACT3D-TACS',myhandles.txt_struct);
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
    if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer); end
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
% function ACT3D_Timer_Callback(hObject,event)
%     % arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
% %     databuffer=getappdata(act3dTACS,'databuffer');                          % KCS 8.17.20 Data Buffer? What do 
%     % Read current data from ACT3D
%     myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
%     % update status panel CHANGED TO ONLY ALERT USER IF STATUS IS DIFFERENT FROM
%     % CURRENT.
%     % set( mainWindow.statusPanel.secondColumn(2), 'String', robot.currentState );
%     % Compare current state with intended state and alert if different
% %     if ~strcmp(myhandles.robot.currentState,lower(myhandles.act3d.state))
% %         disp([myhandles.robot.currentState,'-',myhandles.act3d.state])
% %         warndlg(['Warning: ACT3D current state is ' myhandles.robot.currentState '. Power off device and re-initialize'])
% %         stop(myhandles.exp.timer)  %KCS 10.2.20 COMMENTED OUT
% %         myhandles.ui.act3d_state.Enable='off';
% %         return
% %     end
% 
%     % set( mainWindow.statusPanel.secondColumn(8), 'String', num2str(robot.inertia) );
%     % Update monitor variables:
%     set(myhandles.ui.mon_eforce,'String',num2str(myhandles.robot.endEffectorForce(3))); % Vertical endpoint force
% %     set(myhandles.ui.mon_eforce,'String',num2str(myhandles.robot.endEffectorRotation*180/pi)); % Vertical endpoint force
%     hpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp); % Compute hand (3rd MCP) position
% 
%     % Update display feedback and Signal Monitor Panel Variables
% %     hpos=myhandles.robot.endEffectorPosition(:);
%     set(myhandles.ui.mon_epos,'String',num2str([hpos'*100 myhandles.robot.endEffectorRotation*180/pi],'%7.2f'));
% %     set(myhandles.ui.mon_sabd,'String',num2str(myhandles.robot.endEffectorPosition*100,'%7.2f'));
% %     set(myhandles.ui.mon_epos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
% %     set(myhandles.ui.mon_spos,'String',mat2str(myhandles.robot.endEffectorPosition(:)',3));
% %     databuffer=[databuffer;hpos'];
% %     setappdata(act3dTACS,'databuffer',databuffer)
% 
% %      myhandles.fig1,myhandles.exp.hAxis,myhandles.exp.hLine,myhandles.exp.hLabel
% %      myhandles.exp.hLine(1) - Cross mark - horizontal
% %      myhandles.exp.hLine(2) - Cross mark - vertical
% %      myhandles.exp.hLine(3) - home target
%     hpos=hpos-myhandles.exp.origin;
%     if strcmp(myhandles.exp.arm,'right'), hpos(1:2)=-hpos(1:2); end % Flip coordinate system so that + is to the right and forward
%     set(myhandles.exp.hLine(1),'XData',hpos(1)+[-0.05 0.05],'YData',[hpos(2) hpos(2)]); % Cross mark - horizontal
%     set(myhandles.exp.hLine(2),'XData',[hpos(1) hpos(1)],'YData',hpos(2)+[-0.05 0.05]); % Cross mark - vertical
% %     set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
%     drawnow
%     
%     % Update Metria display when digitizing bony landmarks
%     lside=50;
%     if myhandles.met.on
%         [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker);
%         metdataexp=[metdata1 metdata2];
%         lside=50;
%         for i=1:myhandles.met.nmarker
%             markeridx=find(metdataexp==myhandles.met.markerid(i),1);
%             if isempty(markeridx)
%                 set(myhandles.ui.met_markervis(i),'String','NO','ForegroundColor','r')
%                 plotcube(myhandles.met.disp,myhandles.met.hPatch(6*i-5:6*i),0,[0 0 0],[]);
%                 set(myhandles.met.hText(i),'Visible','off')
%             else
%                 set(myhandles.ui.met_markervis(i),'String','YES','ForegroundColor','g')
%                 plotcube(myhandles.met.disp,myhandles.met.hPatch(6*i-5:6*i),lside*ones(1,3),metdataexp(markeridx+(1:3)),[]);
%                 set(myhandles.met.hText(i),'Position',metdataexp(markeridx+(1:3))+lside*ones(1,3))
%                 set(myhandles.met.hText(i),'Visible','on')
%             end
%         end
%     end
% end

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
%         myhandles.robot = Robot(myhandles.act3d);
%         myhandles.haptic = Haptic(myhandles.robot);
        % Initialize HM and create haptic objects (table and wall) and bias force
        myhandles.act3d.state='INITIALIZED';
        myhandles.robot.SwitchState(lower(myhandles.act3d.state));
        myhandles.ui.act3d_state.String=myhandles.act3d.state;
        % Create the haptic table object in the position and size set in the class declaration (@Haptic.m)
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
%         MOVED TO MAIN PROGRAM
%         % Assign timer callback function and start it
%         % AMA 11/21/20 Changed to EXP_Timer which consolidates ACT3D and
%         % DAQ timer functions
%         myhandles.exp.timer.TimerFcn=@EXP_Timer_Callback;
%         %A.M. testing to see which line of code is causing the TimerFcn error
%         myhandles.exp.timer.Name = 'EXP_RTD';
%         myhandles.exp.timer.ExecutionMode = 'fixedRate'; % Changed to 'queue' from 'fixedrate' mode so that period is on average the set period.
%         start(myhandles.exp.timer);
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
                uiwait(warndlg('Please raise the ACT3D above the haptic table','ACT3D-TACS',myhandles.txt_struct));
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
                warndlg('Warning: % Maximum Abduction Force should be between 0 and 100','ACT3D-TACS',myhandles.txt_struct);
                return
            end
            % 0% is no abduction effort so ACT3D must generate force equal to limb weight
            % 10% means participant needs to generate 10% of max SABD force
            % abductionForceProvided(3) = limbWeight - (percentAbductionMaxValue/100) * abductionMax;
            myhandles.exp.endforce=-force*myhandles.exp.max_sabd/100 - myhandles.exp.arm_weight;
        case 'wgh'
            if force>100 
                uiwait(warndlg('Warning: % Load is greater than 100% Arm Weight','ACT3D-TACS',myhandles.txt_struct));
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
                warndlg('Warning: Measure or Enter Maximum Shoulder Abduction Force first','ACT3D-TACS',myhandles.txt_struct)
%                 myhandles.ui.act3d_loadbg.SelectedObject=myhandles.ui.act3d_absload;
            end
            myhandles.act3d.loadtype = 'max';
        case 3
            if ~isfield(myhandles.exp,'arm_weight')
                warndlg('Warning: Measure Arm Weight first','ACT3D-TACS',myhandles.txt_struct)
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
                uiwait(warndlg('\fontsize{12}Warning: Haptic table will be moved down 4 cm','ACT3D-TACS',myhandles.txt_struct));
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Disable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
                myhandles.haptic.horizontalPosition(3) = -0.24;
                % set position of horizontal haptic effect in robot
                myhandles.haptic.SetPosition(myhandles.haptic.horizontalPosition,myhandles.haptic.horizontalName);
                myhandles.haptic.isHorizontalEnabled=myhandles.haptic.Enable(myhandles.haptic.isHorizontalCreated,myhandles.haptic.isHorizontalEnabled,myhandles.haptic.horizontalName);
            end
            pause(1)
            myhandles.robot.SetExternalForce([0 0 myhandles.exp.endforce]);    
        case 'off'
            myhandles.robot.SetExternalForce([0 0 0]);    
            if myhandles.haptic.isHorizontalEnabled
                % Fix ACT3D before removing table
                uiwait(warndlg('\fontsize{12}Warning: Haptic table will be moved to default position, move ACT-3D above table','ACT3D-TACS',myhandles.txt_struct));
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
            errordlg(str,'ACT3D-TACS',myhandles.txt_struct);
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
function EXP_sTime_Callback(source,event)
    myhandles.exp.sTime = str2num(source.String);
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
        if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer); end
        % Change DAQ object to continuous time acquisition
        myhandles.daq.ni.IsContinuous = true;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = myhandles.daq.sRate/myhandles.exp.sRate;
        for i=1:myhandles.daq.nChan
            set(myhandles.daq.Line(i,1),'XData',[],'YData',[]);
            set(myhandles.daq.Line(i,2),'XData',[],'YData',[]);
        end
        startBackground(myhandles.daq.ni);
    else
        stop(myhandles.daq.ni);
        myhandles.daq.ni.IsContinuous = false;
        myhandles.daq.ni.NotifyWhenDataAvailableExceeds = myhandles.daq.sRate/myhandles.exp.sRate;
        start(myhandles.exp.timer)
    end
end

% Set TTL digital output - EMPTY FOR NOW, FILL IT IN IF NEEDED
function DAQ_TTL_Callback(hObject,event)
end

% Create DAQ object
function DAQ_Init_Callback(source,event)
stop(myhandles.exp.timer)
myhandles.daq.on=1;
% Initialize DAQ variables
myhandles.daq.Device='Dev1';
% myhandles.daq.Enable=0;
myhandles.daq.nChan=16;
myhandles.daq.sRate=1000;
myhandles.daq.sTime=myhandles.exp.sTime;
myhandles.daq.Channels = 0:myhandles.daq.nChan-1; % Channel list for DAQ
myhandles.daq.ChannelNames = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','ADEL','Channel 17','Channel 18','Channel 19','Channel 20','Channel 21','Channel 22','Channel 23','Channel 24'};
% myhandles.ChannelNames = myhandles.ChannelNames(1:myhandles.nChan);
myhandles.daq.maxChannels = 24;

% Change color on Initialize DAQ button
set(myhandles.ui.daq_init,'String','DAQ Initialized');

% Fill in panel text boxes with default values
set(myhandles.ui.daq_nChan,'String',num2str(myhandles.daq.nChan));
set(myhandles.ui.daq_srate,'String',num2str(myhandles.daq.sRate));

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
myhandles.daq.ni.NotifyWhenDataAvailableExceeds=myhandles.daq.ni.Rate/myhandles.exp.sRate;
% Add listener object 
% By default the DataAvailable event triggers when 1/10 second worth of data is available for analysis. 
% To specify a different threshold, change the value of NotifyWhenDataAvailableExceeds.
% setappdata(act3dTACS,'expdatabuffer',zeros(myhandles.daq.sTime*myhandles.exp.sRate,myhandles.act3d.nVars));
lh = addlistener(myhandles.daq.ni, 'DataAvailable', @EXP_localTimerAction);
myhandles.ui.daq_rt.Enable = 'on';

% Create figure to plot EMGs
[myhandles.daq.Axis,myhandles.daq.Line,myhandles.daq.Label]=DAQ_createFig(myhandles.daq.nChan,myhandles.daq.ChannelNames);

% Create databuffer to plot previous EMG values in real time display
myhandles.daq.timebuffer=(0:myhandles.daq.sRate*2-1)'/myhandles.daq.sRate;
% Create data buffer in daq.fig for real time data display
setappdata(myhandles.daq.fig,'databuffer',zeros(length(myhandles.daq.timebuffer),myhandles.daq.nChan));
% MOVED TO GO BUTTON
% %Initialize data buffers
% setappdata(act3dTACS,'actdatabuffer',zeros(myhandles.daq.sTime*myhandles.exp.sRate,myhandles.act3d.nVars));
% if myhandles.met.on, setappdata(act3dTACS,'metdatabuffer',zeros(myhandles.daq.sTime*myhandles.exp.sRate,(3+8*myhandles.met.nmarker)*2)); end

% %Enable GO button
% myhandles.ui.exp_go.Enable='on';
start(myhandles.exp.timer)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EXPeriment Setup and Protocol Panels Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AMA - function to display data in real time and play beep at 200 ms 
% AMA 11/21/20 Renamed to EXP_localTimerAction to merge timer and DAQ timer
% functions
function EXP_localTimerAction(source, event)

% if myhandles.daq.on, 
%     counter=source.
% else    
%     counter=myhandles.exp.timer.TasksExecuted;
% end
% Read current data from ACT3D
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);
hpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp); % Compute hand (3rd MCP) position
data={[hpos',myhandles.robot.endEffectorRotation(1),myhandles.robot.endEffectorForce(3)]};
% NI DAQ data only needed if RT checkbox is on
if myhandles.daq.on, if myhandles.daq.rt, data{2}=event.Data; end; end
if myhandles.met.on
     metriadata = metriaComm_collectPoint2(myhandles.met.socket,myhandles.met.markerid(1:4),myhandles.met.cameraSerials);
 
% [metdata] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker); % Changed by KCS 12.9.2020 for new metriaComm_collectPoint
%     metriadata=[metdata1,metdata2];
    
%     [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker);
%     metriadata=[metdata1,metdata2];
    data{3}=metriadata;
%     disp(metriadata(counter,:))
end


% If collecting data (initiated with GO button), play sound at 200 ms after start of trial
% and populate ACT3D and Metria databuffers
if myhandles.exp.isrunning
    % Play sound at 200 ms after start of trial either with Windows timer
    % or NIDAQ timer
    counter=counter+1;
    if myhandles.daq.on
       time=double(source.ScansAcquired)/myhandles.daq.sRate;
%          if counter<5, disp([counter t myhandles.daq.sRate;]); end
       if time == 0.2, play(myhandles.beep, 1000); end
    else
        if myhandles.exp.timer.TasksExecuted == 0.2*myhandles.exp.sRate, play(myhandles.beep, 1000); end
        time=myhandles.exp.timer.InstantPeriod;
    end
    % Collect ACT-3D data
    actdata=getappdata(act3dTACS,'actdatabuffer');
    if myhandles.met.on, metdatabuffer=getappdata(act3dTACS,'metdatabuffer');  end
    
    % ACT3D Data matrix:
    % Column 1 period in s
    % Column 2-4 hand position (3rd MCP)
    % Column 5-7 robot.endEffectorPosition
    % Column 8 robot.endEffectorRotation(1);
    % Column 9-11 robot.endEffectorVelocity;
    % Column 12-14 robot.endEffectorForce;
    % Column 15-17 robot.endEffectorTorque;

    % Check in case timer interrupt goes over
    if counter<=size(actdata,1)
        actdata(counter,:)=[time hpos' myhandles.robot.endEffectorPosition,...
            myhandles.robot.endEffectorRotation(1),myhandles.robot.endEffectorVelocity,...
            myhandles.robot.endEffectorForce,myhandles.robot.endEffectorTorque];
        setappdata(act3dTACS,'actdatabuffer',actdata);
%         disp([counter actdata(counter,:)])
    	if myhandles.met.on, metdatabuffer(counter,:)=metriadata; setappdata(act3dTACS,'metdatabuffer',metdatabuffer); end
    
    end
end
% Display data
% disp(myhandles.robot.endEffectorRotation(1))

EXP_localDisplayData(data)

end

% Function to display data in real time - should probably be merged into
% localTimerAction.
% AMA 11/21/20 Merged Windows timer and NIDAQ timer data display into
% EXP_localDisplayData
function EXP_localDisplayData(data)
% data={actdata,daqdata,metdata}
% Only show EMG in real time if not running a trial
if myhandles.daq.rt && ~myhandles.exp.isrunning
    daqdata=data{2};
    blocksize=size(daqdata,1);
    daqdatabuffer=getappdata(myhandles.daq.fig,'databuffer');
    daqdatabuffer=[daqdatabuffer(blocksize+1:end,:);daqdata];
    setappdata(myhandles.daq.fig,'databuffer',daqdatabuffer)
    for i=1:size(daqdatabuffer,2)
        set(myhandles.daq.Line(i,1),'XData',myhandles.daq.timebuffer,'YData',daqdatabuffer(:,i));
        set(myhandles.daq.Label(i),'String',num2str([max(daqdatabuffer(:,i)) min(daqdatabuffer(:,i))],'%.3f  %.3f'));
    end
    drawnow % Is this needed and the drawnow at the end of the function needed? TEST
end

% Update Signal Monitor display
% data{1}(1:3)=hpos
% data{1}(4)=myhandles.robot.endEffectorRotation(1)
% data{1}(5)=myhandles.robot.endEffectorForce(3)
set(myhandles.ui.mon_epos,'String',num2str([data{1}(1:3)*100, data{1}(4)*180/pi],'%7.2f'));
set(myhandles.ui.mon_eforce,'String',num2str(data{1}(5))); % Vertical endpoint force

% Update participant feedback
if strcmp(myhandles.exp.arm,'right'), data{1}(1:2)=-data{1}(1:2); end % Flip coordinate system so that + is to the right and forward
set(myhandles.exp.hLine(1),'XData',data{1}(1)+[-0.05 0.05],'YData',data{1}([2 2])); % Cross mark - horizontal
set(myhandles.exp.hLine(2),'XData',data{1}([1 1]),'YData',data{1}(2)+[-0.05 0.05]); % Cross mark - vertical
% set(myhandles.exp.hLine(3),'XData',databuffer(:,1),'YData',databuffer(:,2));
drawnow

% Update Metria Motion Capture panel and ADD trunk position display
% AMA 11/19/20
if myhandles.met.on && length(data)==3
    lside=50;
    metdata=data{3};
    for i=1:myhandles.met.nmarker
        markeridx=find(metdata==myhandles.met.markerid(i),1);
        if isempty(markeridx)
            set(myhandles.ui.met_markervis(i),'String','NO','ForegroundColor','r')
            plotcube(myhandles.met.disp,myhandles.met.hPatch(6*i-5:6*i),0,[0 0 0],[]);
            set(myhandles.met.hText(i),'Visible','off')
        else
            set(myhandles.ui.met_markervis(i),'String','YES','ForegroundColor','g')
            plotcube(myhandles.met.disp,myhandles.met.hPatch(6*i-5:6*i),lside*ones(1,3),metdata(markeridx+(1:3)),[]);
            set(myhandles.met.hText(i),'Position',metdata(markeridx+(1:3))+lside*ones(1,3))
            set(myhandles.met.hText(i),'Visible','on')
        end
%         drawnow
    end
end


end

% Go button
function EXP_Go_Callback(hObject,event)
% myhandles.exp.partID='test';
% myhandles.exp.dir=pwd;
if ~isfield(myhandles.exp,'partID')
    msgbox('\fontsize{12}Please fill the participant information form first','Save Setup','ACT3D-TACS',myhandles.txt_struct);
    return
end

hObject.Enable = 'off';
% If running real time daq or timer, stop first
if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer); end

if myhandles.daq.on
    if myhandles.daq.rt
        myhandles.daq.rt=0;
        DAQ_RT_Callback(myhandles.ui.daq_rt,event)
        myhandles.ui.daq_rt.Enable = 'off'; % disable realtime checkbox
    end
end

%Initialize data buffers and set to zero
setappdata(act3dTACS,'actdatabuffer',zeros(myhandles.exp.sTime*myhandles.exp.sRate,myhandles.act3d.nVars));
if myhandles.met.on, setappdata(act3dTACS,'metdatabuffer',zeros(myhandles.exp.sTime*myhandles.exp.sRate,(2+8*myhandles.met.nmarker))); end

% Turn off trajectory from previous trial
set(myhandles.exp.hLine(3),'Visible','off');

%Start DAQ, PPS and METRIA depending on which is enabled
if myhandles.pps.on, myhandles.pps.mats.StartPPS; end

myhandles.exp.isrunning=1;
counter=0;
% Note that the NIDAQ object has to exist to do the data acquisition. In a
% future version make it optional and allow data acquisition with the timer
if myhandles.daq.on, 
% startForeground blocks program flow, so the following code won't be
% executed until data acquisition is done
    [daqdata,daqt]=startForeground(myhandles.daq.ni);
    data.daq={daqt,daqdata};
    EXP_TimerStopAction(hObject,event,data)
else
%     data=
    myhandles.exp.timer.StopFcn=@EXP_TimerStopAction;
    myhandles.exp.timer.TasksToExecute=myhandles.exp.sTime*myhandles.exp.sRate;
    start(myhandles.exp.timer);
end

end


function EXP_TimerStopAction(hObject,event,data)
actdata=getappdata(act3dTACS,'actdatabuffer');
data.act=actdata;

if myhandles.met.on 
    data.met=getappdata(act3dTACS,'metdatabuffer');
end

if myhandles.pps.on
    % Read data from PPS
    [~,ppst,ppsdata]=myhandles.pps.mats.ReadData;
%     size(ppsdata)
    ppst=ppst-ppst(1);
    myhandles.pps.mats.StopPPS;
    data.pps={ppst,ppsdata};
end

% Once data collection is over
% 1) Plot EMGs, ACT-3D endpoint trajectory, Metria and PPS data
% 2) Save trial data
% 3) Update trial number
% if ~isfield(myhandles.exp,'dir'), myhandles.exp.dir=pwd; end

EXP_displayData(data);

% AMA - only save the time and data matrices. All the other parameters should be saved in a setup file
filename=fullfile(myhandles.exp.dir,[myhandles.exp.fname,num2str(myhandles.exp.itrial),'.mat']);
save(filename,'data')

% Update trial number and enable RT DAQ
myhandles.exp.itrial = myhandles.exp.itrial+1;
myhandles.ui.exp_itrial.String = num2str(myhandles.exp.itrial);
myhandles.ui.exp_go.Enable = 'on';
myhandles.daq_rt.Enable = 'on';
myhandles.exp.isrunning=0;
myhandles.exp.timer.TasksToExecute=Inf;
myhandles.exp.timer.StopFcn='';

start(myhandles.exp.timer); % Restart timer

end

% Function to plot data at the end of the data acquisition: EMG,
% Kinematics, Pressure
% Edit to make input arguments variable depending on whether we have PPS
% and Metria data
function EXP_displayData(data)
    % Plot EMG data in EMG figure
    % Compute the rectified average EMG
    % Draw the movement trajectory
    actdata=data.act;
    if strcmp(myhandles.exp.arm,'right')
        set(myhandles.exp.hLine(3),'XData',-actdata(:,2),'YData',-actdata(:,3),'Visible','on');
%         set(myhandles.exp.hLine(3),'XData',-0.1:0.01:0.1,'YData',0:0.01:0.2,'Visible','on');
    else
        set(myhandles.exp.hLine(3),'XData',actdata(:,2),'YData',actdata(:,3),'Visible','on');
    end
    drawnow
    
    if myhandles.daq.on
        daqt=data.daq{1};
        daqdata=data.daq{2};
        meandata=meanfilt(abs(daqdata),0.1*myhandles.daq.sRate);
        
        for i=1:myhandles.daq.nChan
            %             get(myhandles.Line(i,1),'XData')
            %             get(myhandles.Line(i,2),'XData')
            set(myhandles.daq.Line(i,1),'XData',daqt,'YData',abs(daqdata(:,i)));
            set(myhandles.daq.Line(i,2),'XData',daqt,'YData',meandata(:,i));
            set(myhandles.daq.Label(i),'String',num2str(max(meandata(:,i)),'%.3f  '));
        end
        figure(myhandles.daq.fig)
        %     drawnow
    end
    
%     drawnow
    
    % ADD METRIA DATA DISPLAY - A message indicating if there were markers
    % that were invisible during the trial and the number of frames.
    
    % Display PPS center of pressure
    if myhandles.pps.on
        ppsdata=data.pps{2}(20:end,:); % saving the large matrix of pressure data from both PPS mats 2.1.21
        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);

     
        nframes=size(ppsdata,1);
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1];
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2];
        set(myhandles.pps.hline(1),'Xdata',CoP1(:,1),'Ydata',CoP1(:,2))
        set(myhandles.pps.hline(2),'Xdata',CoP2(:,1),'Ydata',CoP2(:,2))
        set(myhandles.pps.hline(1),'Xdata',CoP1(:,1),'Ydata',CoP1(:,2))
        set(myhandles.pps.hline(2),'Xdata',CoP2(:,1),'Ydata',CoP2(:,2))
        

%         size(ppsdata)
%         figure(5)
%         subplot(221),plot(CoP1(:,1),CoP1(:,2))
%         subplot(222),plot(CoP2(:,1),CoP2(:,2))
%         subplot(223),plot(-actdata(:,2),-actdata(:,3))
%         
    end

    drawnow
    

end

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
function EXP_fname_Callback(source,event)
% if length(varargin)==1, source.String = myhandles.exp.partID; end % Called from subjInfo_Close
myhandles.exp.fname = source.String;
myhandles.exp.itrial=1; myhandles.ui.exp_itrial.String=num2str(myhandles.exp.itrial);

if ~isfield(myhandles.exp,'dir')
    myhandles.exp.dir = uigetdir(pwd,'Select Directory to Save Data');
    set(myhandles.ui.exp_dir,'String',myhandles.exp.dir);
end

if exist(fullfile(myhandles.exp.dir,[myhandles.exp.fname num2str(myhandles.exp.itrial) '.mat']),'file')==2
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
function EXP_iTrial_Callback(hObject,~)
myhandles.exp.itrial = str2num(hObject.String);
if exist(fullfile(myhandles.exp.dir,[myhandles.exp.fname num2str(myhandles.exp.itrial) '.mat']),'file')==2
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
if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer);
elseif myhandles.daq.rt
    myhandles.daq.rt=0;
    set(myhandles.ui.daq_rt,'Value',0);
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
end
myhandles.exp.origin=zeros(3,1); % Reset the origin to zero
% STEP 1 - Get midline position
% Make sure table is ON and if it isn't, alert user to turn it on before
% calling function
if myhandles.ui.act3d_tablebg.SelectedObject==myhandles.ui.act3d_tableoff
    warndlg('Turn virtual table ON before calling locate shoulder procedure','ACT3D-TACS',myhandles.txt_struct);
    return
end

% If device is in FIXED state, switch to NORMAL
if strcmp(myhandles.robot.currentState,'fixed')
    uiwait(msgbox('\fontsize{12}Switching to NORMAL state','ACT3D-TACS',myhandles.txt_struct));
    set(myhandles.ui.act3d_state,'String','NORMAL');
    ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
%     myhandles.act3d.state='NORMAL';
%     myhandles.robot.SwitchState(lower(myhandles.act3d.state));
%     myhandles.ui.act3d_state.String=myhandles.act3d.state;
end

% Prompt user to align tip of middle finger with participant's midline
uiwait(msgbox('\fontsize{12}Move 3rd MCP joint in front of sternum with elbow at 90 degrees','ACT3D-TACS',myhandles.txt_struct));

% switch the robot to FIXED state to keep the participant's arm still
set(myhandles.ui.act3d_state,'String','FIXED');
ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
% myhandles.act3d.state='FIXED';
% myhandles.robot.SwitchState(lower(myhandles.act3d.state));
% myhandles.ui.act3d_state.String=myhandles.act3d.state;

% Read endpoint effector position
myhandles.robot.SetForceGetInfo(myhandles.exp.arm);

% Read trunk position if Metria is on
lside=50;
if myhandles.met.on
%    [metdata1,metdata2] =
%    metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker); % Changed by KCS 12.9.2020 for new metriaComm_collectPoint
     [metdata] = metriaComm_collectPoint2(myhandles.met.socket,myhandles.met.markerid(1:4),myhandles.met.cameraSerials); % Changed by KCS 12.9.2020 for new metriaComm_collectPoint
%     metdata=[metdata1,metdata2];
    markeridx=find(metdata==myhandles.met.markerid(1),1); % Find trunk marker position
    if isempty(markeridx)
        set(myhandles.ui.met_markervis(1),'String','NO','ForegroundColor','r')
        plotcube(myhandles.met.disp,myhandles.met.hPatch(1:6),0,[0 0 0],[]);
        set(myhandles.met.hText(1),'Visible','off')
        uiwait(msgbox('\fontsize{12}Trunk marker not visible','ACT3D-TACS',myhandles.txt_struct));
    else
        myhandles.exp.trunkhome=metdata(markeridx+(1:3))';
        set(myhandles.ui.met_markervis(1),'String','YES','ForegroundColor','g')
        plotcube(myhandles.met.disp,myhandles.met.hPatch(1:6),lside*ones(1,3),myhandles.exp.trunkhome',[]);
        set(myhandles.met.hText(1),'Position',myhandles.exp.trunkhome'+lside*ones(1,3))
        set(myhandles.met.hText(1),'Visible','on')
        set(myhandles.met.hLine,'Position',[myhandles.exp.trunkhome(1:2)'-[50 50] 100 100]); % trunk home target
    end
end
myhandles.exp.midpos=gethandpos(myhandles.robot.endEffectorPosition,myhandles.robot.endEffectorRotation,myhandles.exp);
% disp([myhandles.exp.midpos myhandles.exp.origin])

% Switch to NORMAL state
uiwait(msgbox('\fontsize{12}Switching to NORMAL state','ACT3D-TACS',myhandles.txt_struct));
set(myhandles.ui.act3d_state,'String','NORMAL');
ACT3D_Init_Callback(myhandles.ui.act3d_state,[])
% myhandles.act3d.state='NORMAL';
% myhandles.robot.SwitchState(lower(myhandles.act3d.state));
% myhandles.ui.act3d_state.String=myhandles.act3d.state;

% Prompt user to align tip of middle finger with participant's midline
uiwait(msgbox('\fontsize{12}Move 3rd MCP joint in front of shoulder with elbow at 90 degrees','ACT3D-TACS',myhandles.txt_struct));

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
% myhandles.exp.origin(2:3)=myhandles.exp.shpos(2:3);
myhandles.exp.origin(1)=myhandles.exp.midpos(1);
myhandles.exp.origin(2:3)=myhandles.exp.hometar(2:3)-[0.05;0];
myhandles.exp.arm_weight=myhandles.robot.endEffectorForce(3);

myhandles.exp.hometar=myhandles.exp.hometar-myhandles.exp.origin;
myhandles.exp.shpos=myhandles.exp.shpos-myhandles.exp.origin;

% disp([myhandles.exp.origin myhandles.robot.endEffectorPosition(:) myhandles.exp.hometar myhandles.exp.shpos])

set(myhandles.ui.mon_spos,'String',num2str(myhandles.exp.shpos'*100,'%7.2f')); 
set(myhandles.ui.mon_awgt,'String',mat2str(myhandles.exp.arm_weight)); % Vertical endpoint force

if strcmp(myhandles.exp.arm,'right'),
%     cursorpos=myhandles.exp.hometar-myhandles.exp.origin;
%     set(myhandles.exp.hLine(4),'Position',[-cursorpos(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
    set(myhandles.exp.hLine(4),'Position',[-myhandles.exp.hometar(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
else
%     cursorpos=myhandles.exp.hometar-myhandles.exp.origin;
%     set(myhandles.exp.hLine(4),'Position',[cursorpos(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
    set(myhandles.exp.hLine(4),'Position',[myhandles.exp.hometar(1:2)'-[0.05 0.05] 0.1 0.1]); % home target
end
larm=(myhandles.exp.armLength+myhandles.exp.e2hLength)/100;
set(myhandles.exp.hLine(5),'Xdata',[-0.4 0.4],'Ydata',1.1*(larm-myhandles.exp.origin(2))*[1 1]); % home target

% Update trunk home position if Metria on
if myhandles.met.on
    set(myhandles.met.hLine,'Position',[myhandles.exp.trunkhome(1:2)'-[50 50] 100 100]); % trunk home target
end

drawnow
start(myhandles.exp.timer);

end

% Get maximum shoulder abduction force
function EXP_MSABD_Callback(hObject,event)
% Stop timer or real time DAQ if on
if strcmp(myhandles.exp.timer.Running,'on'), stop(myhandles.exp.timer);
elseif myhandles.daq.rt
    myhandles.daq.rt=0;
    set(myhandles.ui.daq_rt,'Value',0);
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
end
% switch the robot to FIXED state to keep the participant's arm still
if strcmp(myhandles.act3d.state,'NORMAL')
    uiwait(msgbox('\fontsize{12}Switching to NORMAL state, move to home position','ACT3D-TACS',myhandles.txt_struct));
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
start(myhandles.exp.timer)

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% METria Panel Callback Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to initialize communication with METria system
function MET_Init_Callback(hObject,event)
myhandles.met.on=hObject.Value;
if myhandles.met.on
    % Get marker IDs
    stop(myhandles.exp.timer)
    for i=1:length(myhandles.ui.met_markerid)
        myhandles.met.markerid(i)=str2double(get(myhandles.ui.met_markerid(i),'String'));
    end
    myhandles.met.nmarker=4; % Don't include probe here
    myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
    myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
    myhandles.met.markerid=[80 19 87 73 237]; %added pointer tool in 237
    myhandles.met.cameraSerials =  [24 25];% 12.4.2020 added for new Metria code via Hendrik
    for i=1:myhandles.met.nmarker
        set(myhandles.ui.met_markerid(i),'String',num2str(myhandles.met.markerid(i)))
    end
    % Create met field in myhandles - FUTURE DEVELOPMENT: CODE METRIA AS AN
    % OBJECT
    myhandles.met.port=6111; % Verify the Metria system's address
%     myhandles.met.timer = timer;
%     myhandles.met.timer.period = 1/myhandles.exp.sRate;    % Timer frequency = 50 hz
%     myhandles.met.timer.TimerFcn=@MET_Timer_Callback;
    
    % Create figure, axes and cube for trunk position feedback
    scrsz = get(groot,'ScreenSize');
    myhandles.met.fig = figure('Name','ACT3D_TACS - TRUNK POSITION FEEDBACK', ...
        'NumberTitle', 'off','OuterPosition',[0.1*scrsz(3) 0.5*scrsz(4) 0.3*scrsz(3) 0.5*scrsz(4)]);
    
    larm=(myhandles.exp.armLength+myhandles.exp.e2hLength)*10; % Convert to m
    cmap=['c';'r';'y';'g';'w'];
    myhandles.met.disp = axes('Parent',myhandles.met.fig,'Units','normal','Position', [0 0.05 1 0.93],'Color','k','DataAspectRatio',[1 1 1]);
    set(myhandles.met.disp,'xlim',[-400 400],'ylim',[-500 500],'zlim',[-400 400]);
    for i=1:myhandles.met.nmarker
        if i<myhandles.met.nmarker, plotcube(myhandles.met.disp,[],0,[0 0 0],cmap(i)); % Forearm/hand - blue
        else myhandles.met.hPatch=plotcube(myhandles.met.disp,[],0,[0 0 0],cmap(i)); % Pointer tool - white
        end
    end
    myhandles.met.hPatch=flip(myhandles.met.hPatch); % Flip so that the first patch object is the trunk

    % Initialize text objects
    for i=1:myhandles.met.nmarker
        myhandles.met.hText(i)=text('String',myhandles.met.Segments{i},'FontSize',12,'Color',cmap(i),'Parent',myhandles.met.disp,'Visible','off');
    end
    
    % Initialize trunk home circle
    if isfield(myhandles.exp,'trunkhome'), trhome=myhandles.exp.trunkhome(1:2)';
    else trhome=[-50 -50];
    end
    myhandles.met.hLine=rectangle('Position',[trhome 100 100],'Curvature',[1 1],'EdgeColor','m','LineWidth',3,'Visible','on'); % home target
    % Open port to communicate with Metria system
    myhandles.met.socket = metriaComm_openSocket(myhandles.met.port);

    % Enable digitize button
    set(myhandles.ui.met_dig,'Enable','On');
    start(myhandles.exp.timer)

else
    stop(myhandles.exp.timer)
    metriaComm_closeSocket(myhandles.met.socket);
    set(myhandles.ui.met_dig,'Enable','Off');
    delete(myhandles.met.fig)
    start(myhandles.exp.timer)
    
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

larm=(myhandles.exp.armLength+myhandles.exp.e2hLength)/100; % Convert to m
myhandles.met.blah = axes('Parent', digGUI,'Units','normal','Position', [0.05 0.2 .43 .55],'Color','k','DataAspectRatio',[1 1 1]);
set(myhandles.met.blah,'xlim',[-0.3 0.3],'ylim',[-0.05 1.2*larm],'zlim',[-1 1]); 
% set(dig.blah.Toolbar,'Visible','on');

% Create text and cube handles
% 1 Trunk marker - blue
% 2 Scapula marker - red
% 3 Humerus marker - yellow
% 4 Forearm/hand marker - green
% 5 Wand tip - white
% cmap=colormap(parula(5));
cmap=['b';'r';'y';'g';'w'];

% Initialize patch objects
for i=1:myhandles.met.nmarker+1 % Include probe
    if i<5, plotcube(myhandles.met.blah,[],0,[0 0 0],cmap(i)); % Forearm/hand - blue
    else myhandles.met.hPatch=plotcube(dig.blah,[],0,[0 0 0],cmap(i)); % Pointer tool - white
    end
end

% Initialize text objects
for i=1:myhandles.met.nmarker+1 % Include probe
    myhandles.met.hText(i)=text('String',myhandles.met.Segments{i},'FontSize',12,'Color',cmap(i),'Parent',dig.blah);
end
myhandles.met.hPatch=flip(myhandles.met.hPatch); % Flip so that the first patch object is the trunk

% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr)
% p0=zeros(5,3); p0(:,2)=0.12*(0:1:4)';
% lside=0.05;
% for i=1:myhandles.met.nmarker+1
%     plotcube(dig.blah,dig.hPatch(6*i-5:6*i),lside*ones(1,3),p0(i,:),[]);
%     set(hText(i),'Position',p0(i,:)+lside*ones(1,3))
% end

uicontrol(digGUI,'Style','text','String','Digitize Bony Landmarks','HorizontalAlignment','center','Units','normalized','Position',[0.2,0.85,.6,.1],'FontSize',18,'FontWeight','bold');

uicontrol(digGUI,'Style','text','String','Select Segment','HorizontalAlignment','center','Units','normalized','Position',[0.52,0.75,.2,.1],'FontSize',16);
dig.ui.segmlist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectSEG,'String',myhandles.met.Segments,'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.52,0.6,0.2,0.2]);
uicontrol(digGUI,'Style','text','String','Select Bony Landmark','HorizontalAlignment','center','Units','normalized','Position',[0.78,0.75,.2,.1],'FontSize',16);
dig.ui.bllist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectBL,'String',myhandles.met.bonylmrks{1},'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.78,0.55,0.2,0.25]);

dig.ui.digbutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_recordBL_Callback,'String','DIGITIZE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.4 0.2 0.1],'BackgroundColor','b');
dig.ui.savebutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_saveBL_Callback,'String','SAVE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.25 0.2 0.1],'BackgroundColor','g','Enable','off');

if myhandles.daq.rt
    myhandles.daq.rt=0;
    set(myhandles.ui.daq_rt,'Value',0);
    DAQ_RT_Callback(myhandles.ui.daq_rt,event)
end
if strcmp(myhandles.exp.timer.Running,'off'), start(myhandles.exp.timer); end
guidata(digGUI,dig)
end

% Function to record bony landmark positions
function MET_selectSEG(hObject,event)
dig=guidata(hObject);
dig.currentSEG=get(hObject,'Value');
dig.currentBL=1;
set(dig.ui.bllist,'String',myhandles.met.bonylmrks{dig.currentSEG},'Value',dig.currentBL);
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
if isempty(dig.bl{dig.currentSEG}),dig.bl{dig.currentSEG}=zeros(length(myhandles.met.bonylmrks{dig.currentSEG}),16); end
% Read single frame from Metria to digitize current bony landmark
% (dig.currentBL) in current segment (dig.currentSEG) --- UNCOMMENT READS A
% SINGLE FRAME --> communicates with metria
stop(myhandles.exp.timer)
%  [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker+1); % Include probe

 [metdata] = metriaComm_collectPoint2(myhandles.met.socket,myhandles.met.markerid,myhandles.met.cameraSerials); % Include probe % Changed by KCS 12.9.2020 for new metriaComm_collectPoint
% metdata=[metdata1(4:end) metdata2(4:end)];
probeidx=find(metdata==237,1);
if ~isempty(probeidx)
   markeridx=find(metdata==myhandles.met.markerid(dig.currentBL),1);
   if isempty(markeridx)
       uiwait(msgbox('\fontsize{12}Marker not visible. Re-digitize','ACT3D-TACS',myhandles.txt_struct));
       return
   else
       dig.bl{dig.currentSEG}(dig.currentBL,:)=metdata([markeridx+(0:7),probeidx+(0:7)]);
   end
else
   uiwait(msgbox('\fontsize{12}Probe not visible. Re-digitize','ACT3D-TACS',myhandles.txt_struct));
   return
end

% test = metriaComm_collectPoint(dig.socket,length(myhandles.met.Segments))
% disp(dig.bl{dig.currentSEG}(:,1:3))
% disp(dig.bl{dig.currentSEG}(:,4:end))
% disp(size(test))
% If there are more bony landmarks to digitize, update current bony
% landmark index
if dig.currentBL<length(myhandles.met.bonylmrks{dig.currentSEG})
    dig.currentBL=dig.currentBL+1;
    set(dig.ui.bllist,'Value',dig.currentBL);
    % If there are NO more bony landmarks to digitize, set current bony
    % landmark index to 1
else
    % If there are more segments to digitize, update current segment index
    if dig.currentSEG<myhandles.met.nmarker
        dig.currentSEG=dig.currentSEG+1;
        dig.currentBL=1; % Re-initialize bony landmark index
        set(dig.ui.segmlist,'Value',dig.currentSEG);
        MET_selectSEG(dig.ui.segmlist,event)
    else
        % If there are NO more segments (and landmarks) to digitize, update current segment
        % and bony landmark indices
        uiwait(msgbox('\fontsize{12}All bony landmarks have been digitized','ACT3D-TACS',myhandles.txt_struct));

    end
end
start(myhandles.exp.timer)
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
stop(myhandles.exp.timer)
myhandles.pps.on=hObject.Value;

if myhandles.pps.on
    if ~isfield(myhandles.exp,'dir')
        msgbox('\fontsize{12}Saving baseline in program directory','ACT3D-TACS',myhandles.txt_struct)
        dir=pwd;
    else
        dir=myhandles.exp.dir;
    end
    myhandles.pps.mats = PPS('TactArray_Trunk',dir);
    % Create axes for the two mats and save in myhandles.exp.hpAxis
    myhandles.pps.mats.Initialize(dir);
    set(myhandles.ui.pps_ax1,'Visible','on'); set(myhandles.ui.pps_tle1,'Visible','on')
    set(myhandles.ui.pps_ax2,'Visible','on'); set(myhandles.ui.pps_tle2,'Visible','on')
else
    myhandles.pps.mats.delete;
%     myhandles=rmfield(myhandles.pps,'mats');
    set(myhandles.ui.pps_ax1,'Visible','off'); set(myhandles.ui.pps_tle1,'Visible','off')
    set(myhandles.ui.pps_ax2,'Visible','off'); set(myhandles.ui.pps_tle2,'Visible','off')

end
start(myhandles.exp.timer)
 
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
    if isfield(myhandles.exp,'Protocol')
        set(fighandles.hprotocol,'String',myhandles.exp.Protocol); 
        set(fighandles.hnotes,'String',myhandles.exp.Notes); 
    end
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
    EXP_fname_Callback(myhandles.ui.exp_fname,'')
end
uiresume(h);
end

% Functions to save and load the experiment setup in a file named subjID_Setup.mat
function EXP_saveSetup_Callback(source,event)
    % AMA ADD ACT3D VARIABLES THAT NEED TO BE SAVED
if isfield(myhandles.exp,'partID')
    setup.exp=struct('Date',date,'partID',myhandles.exp.partID,'Protocol',myhandles.exp.Protocol,'Notes',myhandles.exp.Notes,...
        'sTime',myhandles.exp.sTime,'sRate',myhandles.exp.sRate,'arm',myhandles.exp.arm,...
        'armLength',myhandles.exp.armLength,'e2hLength',myhandles.exp.e2hLength,...
        'ee2eLength',myhandles.exp.ee2eLength,'abdAngle',myhandles.exp.abdAngle,'shfAngle',myhandles.exp.shfAngle,...
        'elfAngle',myhandles.exp.elfAngle,'hometar',myhandles.exp.hometar,'shpos',myhandles.exp.shpos,...
        'armweight',myhandles.exp.arm_weight,'max_sabd',myhandles.exp.max_sabd);
    if myhandles.daq.on
        setup.daq=struct('nChan',myhandles.daq.nChan,'Channels',myhandles.daq.Channels,'ChannelNames',{myhandles.daq.ChannelNames},...
            'sRate',myhandles.daq.sRate);
    end
    if isfield(myhandles.exp,'dir'), [fname,pname]=uiputfile('','Save the setup file (*.mat)',fullfile(myhandles.exp.dir,[myhandles.exp.partID '_Setup.mat']));
    else [fname,pname]=uiputfile('','Save the setup file (*.mat)',[myhandles.exp.partID '_Setup.mat']);
    end
    % AMA Add dialog box if setup file already exists
    if fname~=0, save(fullfile(pname,fname),'setup');
    else
        msgbox('\fontsize{12}Setup file was not saved','ACT3D-TACS',myhandles.txt_struct)
    end
else
    msgbox('\fontsize{12}Please fill the participant information form first','Save Setup','ACT3D-TACS',myhandles.txt_struct);
end
end

function EXP_loadSetup_Callback(source,event)
if isfield(myhandles.exp,'dir'), [fname,pname] = uigetfile([myhandles.exp.dir '/*.mat'],'Select the setup file (*.mat)');
else [fname,pname] = uigetfile([pwd '/*.mat'],'Select the setup file (*.mat)');
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
    set(myhandles.ui.exp_ualength,'String',num2str(myhandles.exp.armLength));
    set(myhandles.ui.exp_ehlength,'String',num2str(myhandles.exp.e2hLength));
    set(myhandles.ui.exp_eeelength,'String',num2str(myhandles.exp.ee2eLength));
    set(myhandles.ui.exp_abdangle,'String',num2str(myhandles.exp.abdAngle));
    set(myhandles.ui.exp_shfAngle,'String',num2str(myhandles.exp.shfAngle));
    set(myhandles.ui.exp_elfAngle,'String',num2str(myhandles.exp.elfAngle));
    set(myhandles.ui.exp_sTime,'String',num2str(myhandles.exp.sTime));
    if strcmp(myhandles.exp.arm,'right'), myhandles.ui.exp_armbg.Children(2).Value=1;
    else myhandles.ui.exp_armbg.Children(1).Value=1;
    end
    if isfield(setup,'daq')
%         set(myhandles.ui.daq_sRate,'String',num2str(myhandles.daq.sRate));
        set(myhandles.ui.daq_nChan,'String',num2str(myhandles.daq.nChan));
    end
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
%     p=x(:)-rotz(th-3*pi/2)*[0 (exp.e2hLength-exp.ee2eLength)/100 0]';
else
    p=x(:)+rotz(th)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
%     p=x(:)-rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
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





function ReachTr(act3d)
% Main program for reaching experiments in Trunk-arm interaction study
% AMA - December 19, 2019

% Program is written to work with both ACT-3Ds passed as a string variable:
% * 'ACT3D26' - NI Lab/10.30.203.26
% * 'ACT3D36' - MC Lab/10.30.203.36

% Create timer object
timerObject = timer;

% Is it necessary to add the paths?
% addpath Blender Blender\BlenderPlayer Blender\create_thread 	% change paths for Blender
addpath create_windows create_windows\create_gui_components create_windows\main_window
addpath callbacks callbacks\main_window_callbacks
addpath parallel_port
addpath pnet
addpath timer

switch act3d
    case 'ACT3D26'
        addpath HapticAPI26
    case 'ACT3D36'
        addpath HapticAPI26
    otherwise
        disp('Do not recognize ' act3d '. Try again')
        return
end

% load library used for parallel port
if ( ~libisloaded('inpout32') )
    loadlibrary inpout32 inpout32.h;
end

% User chooses current room/robot IP address.  
% Each robot has a different IP address.

% default='MC Lab/10.30.203.36';
% room = questdlg('Which device are you using?', ...
%     'Device Choice',...
%     'NI Lab/10.30.203.26', 'MC Lab/10.30.203.36', default);

% declare class objects
robot = Robot(act3d);  
haptic = Haptic(robot);
judp = Judp;
display = Display(robot,judp);
nidaq = Nidaq;
ttl = TTL_digital_four_lines;
quanser = Quanser;

timerFrequency = 50;    %hz
experiment = Experiment( timerFrequency );

disp('got to line 46 of main.m');
%% Initialize structures and all variables in structures
% hold gui and component data 
mainWindow = [];    
emgChannels = [];
addDisplay = []; %--> Created for Kacey 4.29.2019
initializeRobot = [];
participantParameters = [];
setTargets = [];
trialParameters = [];

%Modified 'InitializeStructures' code to take in the addDisplay array and
%create a structure from it
[ mainWindow, emgChannels, addDisplay, initializeRobot, participantParameters, setTargets, trialParameters ] = ...
    InitializeStructures(...
    mainWindow, emgChannels, addDisplay, initializeRobot, participantParameters, setTargets, trialParameters );

disp('got to line 63 of main.m');
%%  Construct GUI 

mainWindow = CreateMainWindow( mainWindow, robot.deviceId );

% EMG channels window
emgChannels.figureHandle = CreateWindowFigure( emgChannels.name,...
    emgChannels.figureWidth, emgChannels.figureHeight );
emgChannels = CreateEmgChannelsComponents( emgChannels, mainWindow.daqParametersPanel.daqChannelsEditBox );
disp('got to line 72 of main.m');
figure(mainWindow.figureHandle); % bring main window to the front

% addDisplay = CreateEmgChannelsComponents( addDisplay, mainWindow.daqParametersPanel.daqChannelsEditBox );
% figure(mainWindow.figureHandle); % bring main window to the front


% initialize robot window
initializeRobot.figureHandle = CreateWindowFigure( initializeRobot.name,...
    initializeRobot.figureWidth, initializeRobot.figureHeight );
initializeRobot = CreateInitializeRobotComponents( initializeRobot, robot );
set( initializeRobot.figureHandle, 'Visible','Off' );
disp('got to line 84 of main.m');
% participant parameters window
participantParameters.figureHandle = CreateWindowFigure(...
    participantParameters.name, participantParameters.figureWidth, participantParameters.figureHeight );
participantParameters = CreateParticipantParametersComponents( participantParameters );
set( participantParameters.figureHandle, 'Visible','Off' );
disp('got to line 90 of main.m');
% set targets window 
setTargets.figureHandle = CreateWindowFigure( setTargets.name,...
    setTargets.figureWidth, setTargets.figureHeight );
setTargets = CreateSetTargetsComponents( setTargets, participantParameters );
set( setTargets.figureHandle, 'Visible','Off' );
disp('got to line 96 of main.m');
% trial parameters window
trialParameters.figureHandle = CreateWindowFigure( trialParameters.name,...
    trialParameters.figureWidth, trialParameters.figureHeight );
trialParameters = CreateTrialParametersComponents( trialParameters );
set( trialParameters.figureHandle, 'Visible','Off' );
disp('got to line 102 of main.m');
% Changed for Kacey! Adding additional display window :)
addDisplay.figureHandle = CreateWindowFigure( addDisplay.name,...
    addDisplay.figureWidth, addDisplay.figureHeight );
addDisplay = CreateAddDisplayComponents(addDisplay,participantParameters);
disp('got to line 107 of main.m');
%% Callbacks
% set key press callbacks
set( mainWindow.figureHandle, 'KeyPressFcn',{@Keypress,robot,mainWindow} )

% main window (ACT3D Interface) and callbacks
mainWindow = CreateProtocolPanelCallbacks( mainWindow );
mainWindow = CreateDaqParametersPanelCallbacks( mainWindow, emgChannels, experiment, trialParameters, nidaq, ttl, quanser );
%%% A.M. Keeping addDisplay while debugging
mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot, haptic,...
   display, initializeRobot, participantParameters, trialParameters, experiment,...
   timerObject, setTargets, emgChannels, nidaq, ttl,quanser, judp, addDisplay );
% % % mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot, haptic,...
% % %     display, initializeRobot, participantParameters, trialParameters, experiment,...
% % %     timerObject, setTargets, emgChannels, nidaq, ttl,quanser, judp );
disp('got to line 122 of main.m');
mainWindow = CreateMenubarCallback( mainWindow, robot, initializeRobot,...
    setTargets, trialParameters, participantParameters, display, timerObject, judp );

% callbacks for the five sub windows

% no callbacks needed for emg channels window
set( emgChannels.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please close the main window') );

% initializeRobot = CreateInitializeRobotCallbacks( initializeRobot, mainWindow,...
%     robot, haptic, display, participantParameters, setTargets, timerObject, experiment, judp );

%SA,AM 10.8.19 editing the arguments to include addDisplay
initializeRobot = CreateInitializeRobotCallbacks( initializeRobot, mainWindow,...
    robot, haptic, display, addDisplay, participantParameters, setTargets, timerObject, experiment, judp );

disp('got to line 133 of main.m');
participantParameters = CreateParticipantParametersCallbacks(...
    initializeRobot, mainWindow, robot, display, addDisplay, participantParameters, timerObject );
disp('got to line 136 of main.m');
setTargets = CreateSetTargetsCallbacks( initializeRobot, mainWindow,...
    participantParameters, setTargets, robot, haptic, display, judp, timerObject );
disp('got to line 139 of main.m');
trialParameters = CreateTrialParametersCallbacks( initializeRobot,...
    mainWindow, participantParameters, trialParameters, robot, haptic,...
    display, timerFrequency, setTargets, timerObject, experiment );

disp('got to line 144 of main.m');

%%  Set the properties of the timer object that gets data from  HapticMaster and updates visual feedback
% set properties and start the timer

% timerObject = SetTimerProperties( timerObject, display, robot, mainWindow, experiment,...
%     timerFrequency, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp );
% start(timerObject);

%We need to modify SetTimerProperties to take in our new structure-
%addDisplay


timerObject = SetTimerProperties( timerObject, display, robot, mainWindow, experiment,...
    timerFrequency, trialParameters, setTargets, emgChannels, addDisplay, nidaq, ttl, quanser, judp );

disp('got to line 159 of main.m');
start(timerObject);
disp('got to line 160 of main.m');

%% Close all windows and stop and delete timer when the main window is closed

% set callback for what happens on closing the main window
set( mainWindow.figureHandle, 'CloseRequestFcn', {@CloseMainWindow_Callback,...
    mainWindow, emgChannels.figureHandle, initializeRobot.figureHandle, setTargets.figureHandle,...
    participantParameters.figureHandle, trialParameters.figureHandle,...
    timerObject, display, judp, haptic, robot, experiment, nidaq, ttl, quanser } );
disp('got to line 169 of main.m');

end

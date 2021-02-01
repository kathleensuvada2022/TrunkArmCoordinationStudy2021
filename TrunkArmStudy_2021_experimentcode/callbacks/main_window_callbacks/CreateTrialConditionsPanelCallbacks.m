%% function declaring the callback functions for each component
function mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot,...
   haptic, display, initializeRobot, participantParameters, trialParameters,...
   experiment, timerObject, setTargets, emgChannels, nidaq, ttl, quanser, judp, addDisplay )
 
 %%% A.M. Commenting this out to include addDisplay
% % %  function mainWindow = CreateTrialConditionsPanelCallbacks( mainWindow, robot,...
% % %    haptic, display, initializeRobot, participantParameters, trialParameters,...
% % %    experiment, timerObject, setTargets, emgChannels, nidaq, ttl, quanser, judp)

%protocolPanel = mainWindow.protocolPanel;
trialConditionsPanel = mainWindow.trialConditionsPanel;

set(trialConditionsPanel.statePopUpMenu,...
    'Callback',{@statePopUpMenu_Callback,mainWindow,robot,haptic, timerObject});
set(trialConditionsPanel.modePopUpMenu,...
    'Callback',{@modePopUpMenu_Callback,mainWindow,robot, initializeRobot});

set(trialConditionsPanel.percentLimbSupportEditBox,...
    'Callback',{@percentLimbSupportEditBox_Callback,mainWindow,robot,participantParameters,timerObject});
set(trialConditionsPanel.percentAbductionMaxEditBox,...
    'Callback',{@percentAbductionMaxEditBox_Callback,mainWindow,robot,participantParameters,initializeRobot,trialParameters, timerObject});

set(trialConditionsPanel.horizontalToggleButton,...
    'Callback',{@horizontalToggleButton_Callback,mainWindow,robot,haptic,display, judp});
set(trialConditionsPanel.verticalToggleButton,...
    'Callback',{@verticalToggleButton_Callback,mainWindow,robot,haptic,display});

%Table Condition
set(trialConditionsPanel.slantToggleButton,...
    'Callback',{@slantToggleButton_Callback, mainWindow, setTargets, display, haptic, experiment, judp, robot});
%Load Condition
set(trialConditionsPanel.loadToggleButton,...
    'Callback',{@loadToggleButton_Callback, mainWindow, setTargets, display, haptic, experiment, judp, robot});
%Synergy Quantification Condition
set(trialConditionsPanel.synergyToggleButton,...
    'Callback',{@synergyToggleButton_Callback, mainWindow, setTargets, display, haptic, experiment, judp, robot});
%set(trialConditionsPanel.liftToggleButton,...
%    'Callback',{@liftToggleButton_Callback, mainWindow, robot, setTargets, display, haptic, experiment, judp});
%set(trialConditionsPanel.liftToggleButton,...
%    'Callback',{@liftToggleButton_Callback, mainWindow, setTargets, display, haptic, experiment, judp, robot});

%Using damper for ABD Max
set(trialConditionsPanel.damperToggleButton,...
     'Callback',{@damperToggleButton_Callback,mainWindow,robot});
set(trialConditionsPanel.coefficientEditBox,...
     'Callback',{@coefficientEditBox_Callback,mainWindow,robot});

set(trialConditionsPanel.externalForceEditBox(1),...
    'Callback',{@externalForceEditBox_Callback,mainWindow,robot,participantParameters,initializeRobot,timerObject});
set(trialConditionsPanel.externalForceEditBox(2),...
    'Callback',{@externalForceEditBox_Callback,mainWindow,robot,participantParameters,initializeRobot,timerObject});
set(trialConditionsPanel.externalForceEditBox(3),...
    'Callback',{@externalForceEditBox_Callback,mainWindow,robot,participantParameters,initializeRobot,timerObject});
%%% A.M. debugging and adding addDisplay for now
set(trialConditionsPanel.startTrialPushButton,...
    'Callback',{@startTrialPushButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp, addDisplay });
% % % set(trialConditionsPanel.startTrialPushButton,...
% % %     'Callback',{@startTrialPushButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp});
set(trialConditionsPanel.startSetPushButton,...
    'Callback',{@startSetPushButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp, addDisplay});
% % % set(trialConditionsPanel.startSetPushButton,...
% % %     'Callback',{@startSetPushButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp});
set(trialConditionsPanel.abortPushButton,...
    'Callback',{@abortPushButton_Callback,mainWindow,robot,experiment,display, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp, addDisplay});
% % % set(trialConditionsPanel.abortPushButton,...
% % %     'Callback',{@abortPushButton_Callback,mainWindow,robot,experiment,display, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp});

%Shoulder ABD Max
set(trialConditionsPanel.abdMaxToggleButton,...
    'Callback',{@abdMaxToggleButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp, addDisplay});
% % % set(trialConditionsPanel.abdMaxToggleButton,...
% % %     'Callback',{@abdMaxToggleButton_Callback,mainWindow,robot,trialParameters,experiment,display,setTargets, nidaq, ttl, quanser, judp});
end

%% callbacks
function statePopUpMenu_Callback(hObject, eventdata, mainWindow, robot, haptic, timerObject )

stop(timerObject);

% get chosen state
stateString = get(hObject,'String');
stateValue = get(hObject,'Value');
newState = stateString{stateValue};

% switch state in HapticMaster
robot.SwitchState(newState);

switch robot.currentState
    case 'off'
        % make state list - off, initialize, (normal and fixed if isInitialed = 1?
        set(hObject,'String',{'off','initialized','normal'}); % normal and fixed?
    
    case 'initialized'
        % make state list - initialized, normal, fixed and off
        set(hObject,'String',{'initialized','normal','fixed','off'});
        robot.RemoveAllHapticEffects;
        haptic.isHorizontalCreated = 0;
        haptic.isHorizontalCreated = haptic.Create( haptic.horizontalName, haptic.isHorizontalCreated,...
            haptic.horizontalPosition, haptic.horizontalSize );
        haptic.isVerticalCreated = 0;
        haptic.isVerticalCreated = haptic.Create( haptic.verticalName, haptic.isVerticalCreated,...
            haptic.verticalPosition, haptic.verticalSize );
        %pause(20);
        robot.isBiasForceCreated = 0;
        robot.CreateBiasForce;
        robot.isSpringCreated = 0;
        robot.CreateSpring;
        robot.CreateDamper;
                    
    case 'normal'
        % make state list
        set(hObject,'String',{'normal','fixed','off'});
    
    case 'fixed'
        % make state list
        set(hObject,'String',{'fixed','normal','off'});
        %potential bug fix for dropped horizontal table
        if haptic.isHorizontalEnabled == 1
            [retVal, response] = haSendCommand( haptic.deviceId, ['set ' haptic.horizontalName ' enable'] );
                    if (retVal == 0)
                        disp('Haptic effect enabled');
                        %isEnabled = 1;
                    else
                        disp (['--- ERROR: ' response]);
                    end
        end
    
    otherwise
        disp('Error detecting current state of HapticMaster. Please try again.');
end

set(hObject,'Value',1);

start(timerObject);

end

%%

function modePopUpMenu_Callback(hObject, eventdata, mainWindow, robot, initializeRobot )
end


function percentLimbSupportEditBox_Callback(hObject, eventdata, mainWindow, robot, participantParameters, timerObject )

stop(timerObject);

percentSupportString = get(hObject,'String');

isLoadSelected = get(mainWindow.trialConditionsPanel.loadToggleButton,'Value');

if  isLoadSelected == 1   ||   isempty(percentSupportString)
    
    abductionForceProvided(1:3) = 0;
    
    if ~isempty(percentSupportString)
        percentSupportValue = str2double(percentSupportString);
        limbWeight = str2double(get( participantParameters.limbWeightEditBox, 'String' ));
        
        abductionForceProvided(3) = limbWeight * (percentSupportValue/100) - limbWeight;
        
        % if the value provided causes a force more than 2x limbweight (up or
        % down), ask the user if that's what they intended
        if abs( abductionForceProvided(3) ) > abs( 2 * limbWeight )
            default='No';
            answer = questdlg('This value is more than twice limbweight.  Are you sure you want to apply this much force?', ...
                'Value is twice limbweight',...
                'Yes', 'No',default);
            if ~strcmp(answer,'No')
                % make the string empty in the edit box
                set(hObject,'String','');
                abductionForceProvided = [ 0, 0, 0 ];
            end
        end
        
    end
else
    disp('Please select load case');
    set(hObject,'String','');
    return;
end

robot.externalForce = abductionForceProvided;

% set external force 
robot.SetExternalForce(abductionForceProvided);

start(timerObject);

% display values in external force edit boxes
set( mainWindow.trialConditionsPanel.externalForceEditBox(1), 'String', num2str(robot.externalForce(1)) );
set( mainWindow.trialConditionsPanel.externalForceEditBox(2), 'String', num2str(robot.externalForce(2)) );
set( mainWindow.trialConditionsPanel.externalForceEditBox(3), 'String', num2str(robot.externalForce(3)) );

% display value for external force provided in status panel variable
set( mainWindow.statusPanel.secondColumn(9), 'String', [num2str(robot.externalForce(1)) '  ' num2str(robot.externalForce(2)) '  ' num2str(robot.externalForce(3))] );

end


function percentAbductionMaxEditBox_Callback(hObject, eventdata, mainWindow, robot, participantParameters, initializeRobot, trialParameters, timerObject )

stop(timerObject);

isLoadSelected = get(mainWindow.trialConditionsPanel.loadToggleButton,'Value');
isSynergySelected = get(mainWindow.trialConditionsPanel.synergyToggleButton,'Value');
percentAbductionMaxString = get(hObject,'String');

if  isLoadSelected == 1 || isSynergySelected == 1 ||   isempty(percentAbductionMaxString)
    
    abductionForceProvided(1:3) = 0;
    
    if ~isempty(percentAbductionMaxString)
        percentAbductionMaxValue = str2double(percentAbductionMaxString);
        
        limbWeight = str2double(get( participantParameters.limbWeightEditBox, 'String' ));
        
        abductionMax = str2double( get( participantParameters.abductionMaxForceEditBox, 'String' ) );
        
        abductionForceProvided(3) = limbWeight - (percentAbductionMaxValue/100) * abductionMax;    % 0% is weightless, 12.5 means subject lifts 12.5% of limb weight
        
        % if the value provided causes a force more than 2x limbweight (up or
        % down), ask the user if that's what they intended
        if abs( abductionForceProvided(3) ) > abs( 2 * limbWeight )
            default='No';
            answer = questdlg('This value is more than twice limbweight.  Are you sure you want to apply this much force?', ...
                'Value is twice limbweight',...
                'Yes', 'No',default);
            if strcmp(answer,'No')
                % make the string empty in the edit box
                set(hObject,'String','');
                abductionForceProvided = [ 0, 0, 0 ];
            end
        end
        
    end
else
    disp('Please select load condition');
    set(hObject,'String','');
    return;
end

robot.externalForce = abductionForceProvided;

% set external force 
robot.SetExternalForce(abductionForceProvided);

start(timerObject);

% display values in external force edit boxes
set( mainWindow.trialConditionsPanel.externalForceEditBox(1), 'String', num2str(robot.externalForce(1)) );
set( mainWindow.trialConditionsPanel.externalForceEditBox(2), 'String', num2str(robot.externalForce(2)) );
set( mainWindow.trialConditionsPanel.externalForceEditBox(3), 'String', num2str(robot.externalForce(3)) );

% display value for external force provided in status panel variable
set( mainWindow.statusPanel.secondColumn(9), 'String', [num2str(robot.externalForce(1)) '  ' num2str(robot.externalForce(2)) '  ' num2str(robot.externalForce(3))] );

end


function horizontalToggleButton_Callback(hObject, eventdata, mainWindow, robot, haptic, display, judp)

isHorizontalSelected = get( hObject, 'Value' );

if isHorizontalSelected == 1
    % check to see if the arm is high enough to turn on the haptic haptic
    arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
    robot.SetForceGetInfo(arm);
    if robot.endEffectorPosition(3) > haptic.horizontalPosition(3)
        % turn on horizontal haptic effect
        haptic.isHorizontalEnabled = haptic.Enable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
        
        % turn the graphical table on in blender
		judp.Write('table visible on');
    else
        % turn off horizontal haptic effect (table)
        disp('Please raise your arm above the horizontal haptic effect');   %make dialog box for this error?
        set(hObject,'Value',0);  % turn toggle button back off
    end
else
    % turn off horizontal effect
    haptic.isHorizontalEnabled = haptic.Disable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
    
    % turn the graphical table off in blender
	judp.Write('table visible off');
end

end


function verticalToggleButton_Callback(hObject, eventdata, mainWindow, robot, haptic, display)

isVerticalSelected = get( hObject, 'Value' );

if isVerticalSelected == 1
    % turn on vertical haptic effect
    haptic.isVerticalEnabled = haptic.Enable( haptic.isVerticalCreated, haptic.isVerticalEnabled, haptic.verticalName );
    
else
    % turn off vertical haptic effect
    haptic.isVerticalEnabled = haptic.Disable( haptic.isVerticalCreated, haptic.isVerticalEnabled, haptic.verticalName );
end

end

%5/30/15 Changed to horizontal for table condition THIS IS THE TABLE BUTTON
%CALLBACK
function slantToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, robot, setTargets, display, haptic, experiment, judp )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )

isSlantSelected = get(hObject,'Value');

if isSlantSelected

    %offset = -display.radius - 0.01;    % move table 6 cm down
    offset = 0;
    % judp.Write('table move -.06');        % move table 1 m down in blender

    % change angle of haptic effect
    haptic.horizontalAngle = 0; %-5;

else
    %offset = display.radius + 0.01;     % move table 6 cm down
    offset = 0;
    % judp.Write('table move .06');         % move table 1 m down in blender

    haptic.horizontalAngle = 0;
end

haptic.horizontalPosition(3) = haptic.horizontalPosition(3) + offset;
experiment.tableZ = experiment.tableZ + offset;

% turn horizontal haptic effect off
if haptic.isHorizontalEnabled == 1
    haptic.isHorizontalEnabled = haptic.Disable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
end
set( mainWindow.trialConditionsPanel.horizontalToggleButton, 'Value', 0 );

%set(display.planeHandle, 'Visible', 'off' );
% make the table invisible
judp.Write('table visible off');

% set position of horizontal haptic effect in robot
haptic.SetPosition( haptic.horizontalPosition, haptic.horizontalName );

% change angle of haptic effect
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
haptic.SetPlaneAngle( haptic.horizontalAngle, haptic.horizontalName, arm );

% set visual position of haptic table
zdata = get( display.planeHandle, 'ZData' );
zdata = zdata + offset;
set( display.planeHandle, 'ZData', zdata );
% send 'table position x y z' - use haptic.horizontalPosition(1:3)

end

%5/30/15 Changed to lowered table for load conditions
function loadToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, robot, setTargets, display, haptic, experiment, judp )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )

isLoadSelected = get(hObject,'Value');

if isLoadSelected
    offset = -display.radius - 0.01;    % move table 6 cm down
    %offset = 0;
    judp.Write('table move -.06');        % move table 1 m down in blender

    % change angle of haptic effect
    %haptic.horizontalAngle = 5;

else
    offset = display.radius + 0.01;     % move table 6 cm up
    %offset = 0;
    judp.Write('table move .06');         % move table 1 m down in blender

    %haptic.horizontalAngle = 0;
end

haptic.horizontalPosition(3) = haptic.horizontalPosition(3) + offset;
experiment.tableZ = experiment.tableZ + offset;

% turn horizontal haptic effect off
if haptic.isHorizontalEnabled == 1
    haptic.isHorizontalEnabled = haptic.Disable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
end
set( mainWindow.trialConditionsPanel.horizontalToggleButton, 'Value', 0 );

%set(display.planeHandle, 'Visible', 'off' );
% make the table invisible
judp.Write('table visible off');

% set position of horizontal haptic effect in robot
haptic.SetPosition( haptic.horizontalPosition, haptic.horizontalName );

% % change angle of haptic effect
% arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
% haptic.SetPlaneAngle( haptic.horizontalAngle, haptic.horizontalName, arm );

% set visual position of haptic table
zdata = get( display.planeHandle, 'ZData' );
zdata = zdata + offset;
set( display.planeHandle, 'ZData', zdata );
% send 'table position x y z' - use haptic.horizontalPosition(1:3)

end

%Lowered Table for synergy quantification
function synergyToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, robot, setTargets, display, haptic, experiment, judp )
%function liftToggleButton_Callback(hObject, eventdata, mainWindow, setTargets, display, haptic, experiment, judp, robot )

isSynergySelected = get(hObject,'Value');

if isSynergySelected
    offset = -display.radius - 0.01;    % move table 6 cm down
    judp.Write('table move -.06');        % move table 1 m down in blender
else
    offset = display.radius + 0.01;     % move table 6 cm up
    judp.Write('table move .06');         % move table 1 m up in blender
end

haptic.horizontalPosition(3) = haptic.horizontalPosition(3) + offset;
experiment.tableZ = experiment.tableZ + offset;

% turn horizontal haptic effect off
if haptic.isHorizontalEnabled == 1
    haptic.isHorizontalEnabled = haptic.Disable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
end
set( mainWindow.trialConditionsPanel.horizontalToggleButton, 'Value', 0 );

%set(display.planeHandle, 'Visible', 'off' );
% make the table invisible
judp.Write('table visible off');

% set position of horizontal haptic effect in robot
haptic.SetPosition( haptic.horizontalPosition, haptic.horizontalName );

% change angle of haptic effect
%arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
%haptic.SetPlaneAngle( haptic.horizontalAngle, haptic.horizontalName, arm );

% set visual position of haptic table
zdata = get( display.planeHandle, 'ZData' );
zdata = zdata + offset;
set( display.planeHandle, 'ZData', zdata );
% send 'table position x y z' - use haptic.horizontalPosition(1:3)

end

function damperToggleButton_Callback(hObject, eventdata, mainWindow, robot)

isDamperSelected = get( hObject, 'Value' );

if robot.isDamperCreated
    % enable damper if the button is clicked
    if isDamperSelected
        
        robot.EnableDamper;
        disp('Damper enabled');
   
    % disable damper if the button is unclicked
    else
    
        robot.DisableDamper;
        disp('Damper disabled');
    end
else
    set( hObject, 'Value',0 );
end


end


function coefficientEditBox_Callback(hObject, eventdata, mainWindow,robot)
% set the coefficient in the xy plane for the damper if it's created

value = str2double( get( hObject, 'String' ) );
damperCoefficient = [ value, value, 0 ];

if robot.isDamperCreated
    robot.SetDamperCoefficient(damperCoefficient);
    disp('Damper coefficient in the horizontal plane is set');
end

end


function externalForceEditBox_Callback(hObject, eventdata, mainWindow,robot,participantParameters,initializeRobot, timerObject)

% get all 3 forces
externalForce(1) = str2double( get( mainWindow.trialConditionsPanel.externalForceEditBox(1), 'String' ) );
externalForce(2) = str2double( get( mainWindow.trialConditionsPanel.externalForceEditBox(2), 'String' ) );
externalForce(3) = str2double( get( mainWindow.trialConditionsPanel.externalForceEditBox(3), 'String' ) );

% set external force 
robot.externalForce = externalForce;
robot.SetExternalForce(externalForce);

% display value for external force provided in status panel variable
set( mainWindow.statusPanel.secondColumn(9), 'String', [num2str(robot.externalForce(1)) '  ' num2str(robot.externalForce(2)) '  ' num2str(robot.externalForce(3))] );

end

%%%A.M 6.18.2019 keeping addDisplay argument for now
function startTrialPushButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp, addDisplay )
% % % function startTrialPushButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp )
% start experiment
experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay);
% % % experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp);
%  Start(obj, mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay )
end


function startSetPushButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp, addDisplay )
% % % function startSetPushButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp)

experiment.isStartSetSelected = 1;

% start experiment
experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay);
% % % experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp);

end


function abortPushButton_Callback(hObject, eventdata, mainWindow, robot, experiment, display, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp, addDisplay )
% % % function abortPushButton_Callback(hObject, eventdata, mainWindow, robot, experiment, display, trialParameters, setTargets, emgChannels, nidaq, ttl, quanser, judp )
%% abort experiment
experiment.isStartSetSelected = 0;
%experiment.Terminate( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp );
if experiment.isPreTrial == 1
    experiment.Abort( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp, addDisplay );
%%% experiment.Abort( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp );
else
    experiment.Terminate( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp, addDisplay );
%%% experiment.Terminate( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp );
end
end

function abdMaxToggleButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp, addDisplay )
%%%function abdMaxToggleButton_Callback(hObject, eventdata, mainWindow, robot, trialParameters, experiment, display, setTargets, nidaq, ttl, quanser, judp )
    
% Set Shoulder Abduction Max Variable
experiment.shoulderABDMaxTrial = 1;

% Set Condition to 1 so that the target will not be visible
experiment.condition = 1;
set( mainWindow.protocolPanel.conditionEditBox, 'Value', 1)
set( mainWindow.protocolPanel.conditionEditBox, 'String', experiment.condition );

% Start Experimental Trial
experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay);
%%%experiment.Start(mainWindow, display, setTargets, nidaq, ttl, quanser, judp);

% Pause to enable data file writing before reloading
pause(20);

% Get filename of just recorded data
folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
if iscell(folder)
    folder = folder{1};
end
filename = get( mainWindow.daqParametersPanel.filenameEditBox, 'String' );

% Load and filter data file
load([folder '\' filename]);
data = cell2mat(trialData(11,2:end));

% data = data-abs(mean(data(1:50))); %%Sabeen changed to match new ABD max
% measurement 5.29.19
data = data-mean(data(1:50));

[b,a] = butter(8,.4);
filteredData = filtfilt(b,a,data);

%Find Force Max
[c,d] = max(filteredData);
if d+5 <= length(filteredData)
    shoulderABDMax = mean(filteredData(d-5:d+5));
else
    shoulderABDMax = mean(filteredData(d-5:end));
end

% Plot data
figure(10); plot(data,'r'); hold on; plot(filteredData); hold off;
title('Shoulder Abduction Max Force')
xlabel('Samples')
ylabel('Z Force Measurment (N)')
legend('Raw Data','Filtered Data','Location','SouthEast')

%Display results
% AMA 4/1/20 This command is wrong, need to convert from number to string
% num2str(shoulderABDMax)
set( mainWindow.trialConditionsPanel.filenameEditBox, 'String',shoulderABDMax);
disp(['Shoulder Abduction Max Updated: ',num2str(shoulderABDMax)])

end


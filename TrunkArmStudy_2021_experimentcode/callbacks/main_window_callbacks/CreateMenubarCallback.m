%% function declaring the callback functions for each component
function mainWindow = CreateMenubarCallback( mainWindow, robot,...
    initializeRobot, setTargets, trialParameters, participantParameters, display, timerObject, judp )

experimentMenubarChoices = get(mainWindow.experimentMenubar,'Children');
set(experimentMenubarChoices(4),...
    'Callback',{@InitializeRobot_Callback,mainWindow,robot,initializeRobot,timerObject});
set(experimentMenubarChoices(3),...
    'Callback',{@ParticipantParameters_Callback,participantParameters,timerObject});
set(experimentMenubarChoices(2),...
    'Callback',{@SetTargets_Callback,mainWindow,robot,setTargets,timerObject});
set(experimentMenubarChoices(1),...
    'Callback',{@TrialParameters_Callback,mainWindow,robot,trialParameters,timerObject});

viewMenubarChoices = get(mainWindow.viewMenubar,'Children');

set(viewMenubarChoices(3),...
    'Callback',{@TopDown_Callback,mainWindow,display,judp});
set(viewMenubarChoices(2),...
    'Callback',{@Side_Callback,mainWindow,display,judp});
set(viewMenubarChoices(1),...
    'Callback',{@Standard_Callback,mainWindow,display,judp});

end


%% callbacks
function InitializeRobot_Callback(hObject, eventdata, mainWindow, robot, initializeRobot, timerObject)

stop(timerObject);

% make window visible and modal so you can't click other windows
set( initializeRobot.figureHandle, 'Visible','On');%, 'WindowStyle','modal' );

% save the current data set of participantParameters in case the user
% selects cancel in the participant parameters window
filename = get( initializeRobot.filenameEditBox, 'String' );
setappdata(initializeRobot.figureHandle, 'previousFilename', filename );

armObject = get( initializeRobot.armButtonGroup, 'SelectedObject' );
setappdata(initializeRobot.figureHandle, 'previousArm', armObject );

start(timerObject);


end

function ParticipantParameters_Callback(hObject, eventdata, participantParameters, timerObject)

stop(timerObject);

set( participantParameters.figureHandle, 'Visible','On');%, 'WindowStyle','modal' );

start(timerObject);

end


function SetTargets_Callback(hObject, eventdata, mainWindow, robot, setTargets, timerObject)

stop(timerObject);

% make window visible and modal so you can't click other windows
set( setTargets.figureHandle, 'Visible','On');%, 'WindowStyle','modal' );

% save the current data set of participantParameters in case the user
% selects cancel in the participant parameters window
setappdata(setTargets.figureHandle, 'previousData', setTargets);

start(timerObject);


end


function TrialParameters_Callback(hObject, eventdata, mainWindow, robot, trialParameters, timerObject)

stop(timerObject);

% make window visible and modal so you can't click other windows
set( trialParameters.figureHandle, 'Visible','On');%, 'WindowStyle','modal' );

% save the current data set of trial parameters in case the user
% selects cancel in the trial parameters window
setappdata(trialParameters.figureHandle, 'previousData', trialParameters);

start(timerObject);

end


function TopDown_Callback(hObject, eventdata, mainWindow, display, judp)
% get arm
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end

judp.Write('view top');

end


function Side_Callback(hObject, eventdata, mainWindow, display, judp)
% get arm
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end

judp.Write('view side');

end


function Standard_Callback(hObject, eventdata, mainWindow, display, judp)
% get arm
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end

judp.Write('view standard');

end

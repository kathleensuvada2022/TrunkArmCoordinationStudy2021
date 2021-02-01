function trialParameters = CreateTrialParametersCallbacks(...
    initializeRobot, mainWindow, participantParameters, trialParameters,...
    robot, haptic, display, timerFrequency, setTargets, timerObject, experiment )

% these four shouldn't be needed for the permanent solution
set(trialParameters.homeSphereTriggerTimeEditBox,...
    'Callback',{@homeSphereTriggerTimeEditBox_Callback,mainWindow, display, timerFrequency});
set(trialParameters.targetSphereTriggerTimeEditBox,...
    'Callback',{@targetSphereTriggerTimeEditBox_Callback,mainWindow, display, timerFrequency});
set(trialParameters.maxTrialDurationEditBox,...
    'Callback',{@maxTrialDurationEditBox_Callback,mainWindow});

set(trialParameters.setVerticalEffectLocationPushButton,...
    'Callback',{@setVerticalEffectLocationPushButton_Callback,mainWindow,trialParameters,haptic,timerObject, display,robot});

set(trialParameters.okPushButton,...
    'Callback',{@okPushButton_Callback,mainWindow,trialParameters,haptic});
set(trialParameters.cancelPushButton,...
    'Callback',{@cancelPushButton_Callback,mainWindow,trialParameters,haptic});

set( trialParameters.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please click OK or Cancel') );

end


function homeSphereTriggerTimeEditBox_Callback(hObject, eventdata, mainWindow, display, timerFrequency )
end

function targetSphereTriggerTimeEditBox_Callback(hObject, eventdata, mainWindow, display, timerFrequency )
end

function maxTrialDurationEditBox_Callback(hObject, eventdata, mainWindow )
end


function setVerticalEffectLocationPushButton_Callback(hObject, eventdata, mainWindow, trialParameters, haptic, timerObject, display, robot )

stop(timerObject);

% if the table is at a plane other than 0, create a vertical effect for the
% participant to rest on. If the table is set to 0, remove this effect.
haptic.verticalPosition(2) = robot.endEffectorPosition(2);

if haptic.isVerticalCreated == 1
    haptic.SetPosition( haptic.verticalPosition, haptic.verticalName );
    if haptic.isVerticalEnabled == 1
        haptic.isVerticalEnabled = haptic.Disable( haptic.isVerticalCreated, haptic.isVerticalEnabled, haptic.verticalName );
    end
    set( mainWindow.trialConditionsPanel.verticalToggleButton, 'Value', 0 );
else
    disp('ERROR: --- Vertical effect has not been created');
end

start(timerObject);

end


function okPushButton_Callback(hObject, eventdata, mainWindow, trialParameters, haptic )

% save the current elevation plane and number of trials and change the text in the main window

% make this window invisible
set( trialParameters.figureHandle, 'Visible','Off', 'WindowStyle','normal' );

end


function cancelPushButton_Callback(hObject, eventdata, mainWindow, trialParameters, haptic )

% revert data to previous values
numberOfTrials = getappdata( trialParameters.figureHandle, 'numberOfTrials' );
set( trialParameters.numberOfTrialsEditBox, 'String', numberOfTrials );

% make this window invisible
set( trialParameters.figureHandle, 'Visible','Off', 'WindowStyle','normal' );

end

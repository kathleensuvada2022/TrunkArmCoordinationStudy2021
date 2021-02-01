function structure = CreateTrialParametersComponents( structure )

%% variables used throughout this function

%% text labels
textFromLeft = 0.01;
textFromBottom = [0.8267, 0.6256, 0.4256];
textWidth = 0.86;
textHeight = 0.12;
textString = {'Home Sphere Trigger Off Timer (seconds) [1]:', ...
    'Target Sphere Trigger Off Timer (seconds) [2]:', ...
    'Max Trial Duration (seconds) [6]:'};

for i = 1 : length(textString)
    textPosition = [ textFromLeft, textFromBottom(i), textWidth, textHeight ];
    CreateTextComponent( structure.figureHandle, textPosition, textString(i) );
end


%% edit boxes
editBoxFromLeft = textFromLeft + textWidth + 0.02;
editBoxFromBottom = textFromBottom;
editBoxWidth = 0.09808;
editBoxHeight = 0.13;

% home sphere trigger time edit box
editBoxPosition = [ editBoxFromLeft, editBoxFromBottom(1), editBoxWidth, editBoxHeight ];
homeSphereTriggerTimeString = '1';
structure.homeSphereTriggerTimeEditBox = CreateEditBoxComponent( structure.figureHandle, editBoxPosition, homeSphereTriggerTimeString );
setappdata( structure.figureHandle, 'homeSphereTriggerTime', homeSphereTriggerTimeString );

% target sphere trigger time edit box
editBoxPosition = [ editBoxFromLeft, editBoxFromBottom(2), editBoxWidth, editBoxHeight ];
targetSphereTriggerTimeString = '2';
structure.targetSphereTriggerTimeEditBox = CreateEditBoxComponent( structure.figureHandle, editBoxPosition, targetSphereTriggerTimeString );
setappdata( structure.figureHandle, 'targetSphereTriggerTime', targetSphereTriggerTimeString );

% max trial duration edit box
editBoxPosition = [ editBoxFromLeft, editBoxFromBottom(3), editBoxWidth, editBoxHeight ];
maxTrialDurationString = '6';
structure.maxTrialDurationEditBox = CreateEditBoxComponent( structure.figureHandle, editBoxPosition, maxTrialDurationString );
setappdata( structure.figureHandle, 'maxTrialDuration', maxTrialDurationString );

%% buttons to set the height of the displayed objects, vertical effect
%% location, inclined plane height
pushButtonHeight = 0.1467;
pushButtonFromLeft = textFromLeft;
pushButtonWidth = 0.5;

% create button to set vertical effect location
setVerticalEffectLocationPushButtonFromBottom = 0.275;

setVerticalEffectLocationPushButtonPosition = [ pushButtonFromLeft, setVerticalEffectLocationPushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];
structure.setVerticalEffectLocationPushButton = CreatePushButtonComponent(...
    structure.figureHandle, setVerticalEffectLocationPushButtonPosition, 'Set Vertical Effect Location');


%% ok and cancel pushbuttons
pushButtonFromBottom = 0.09333;
pushButtonWidth = 0.16;

okPushButtonFromLeft = 0.5864; 
okPushButtonPosition = [ okPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];
structure.okPushButton = CreatePushButtonComponent(...
    structure.figureHandle, okPushButtonPosition, 'OK');

% cancel push button
cancelPushButtonFromLeft = 0.7932;
cancelPushButtonPosition = [ cancelPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];
structure.cancelPushButton = CreatePushButtonComponent(...
    structure.figureHandle, cancelPushButtonPosition, 'Cancel');
set( structure.cancelPushButton, 'Enable','off');

end
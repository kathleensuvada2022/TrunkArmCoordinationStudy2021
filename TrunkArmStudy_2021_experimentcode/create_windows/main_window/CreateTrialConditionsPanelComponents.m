function panel = CreateTrialConditionsPanelComponents( panel )

%% Insert static text labels
textString = { 'State:', 'Mode:', '% Limb Weight:', '% Abduction Max:',...
    'Haptic effects:', 'Type:', 'Damper:', 'Coefficient in XY:', 'Set Force In',};

% textString = { 'State:', 'Mode:', '% Limb Weight:', '% Abduction Max:',...
%     'Haptic effects:', 'Type:', 'Set Force In',};


%text = zeros( 1, length(textString) );

textFromLeft = 0.01;    
textHeight = 0.048;

panelHeight = 1;
top = panelHeight - textHeight - 0.01; 
%spaceBetweenText = 5; 
%bottom = top - spaceBetweenText * length(textString);
textFromBottom = [top, top-3.5/40, top-7/40, top-9.5/40, top-13.5/40, top-19.5/40, top-23.2/40, top-25.7/40, top-29/40]; 

textWidth = 0.5;

for textIndex = 1:length(textString)
    textPosition = [ textFromLeft textFromBottom(textIndex) textWidth textHeight ];
    %panel.text(textIndex) = 
    CreateTextComponent( panel.handle, textPosition, textString(textIndex) );
end


%% Start and Abort buttons - switch to each having a pushbutton
% push button dimensions
pushButtonFromBottom = 0.01;
pushButtonWidth = 0.29;
pushButtonHeight = 0.0565;

% position of start trialbutton
startTrialPushButtonFromLeft = textFromLeft;
startTrialPushButtonPosition = [ startTrialPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

% create start trial button
panel.startTrialPushButton = CreatePushButtonComponent(...
        panel.handle, startTrialPushButtonPosition, 'Start Trial');
set(panel.startTrialPushButton,'Enable','off');

% position of start set button
startSetPushButtonFromLeft = textFromLeft + pushButtonWidth;
startSetPushButtonPosition = [ startSetPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

% create start trial button
panel.startSetPushButton = CreatePushButtonComponent(...
        panel.handle, startSetPushButtonPosition, 'Start Set');
set(panel.startSetPushButton,'Enable','off');

% position of abort button
abortPushButtonFromLeft = startSetPushButtonFromLeft + pushButtonWidth;
abortPushButtonPosition = [ abortPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

% create abort button
panel.abortPushButton = CreatePushButtonComponent(...
        panel.handle, abortPushButtonPosition, 'Abort');
set(panel.abortPushButton,'Enable','off');    % abort will be enabled when experiments are running


%% Insert "State" pop-up menu
%stateString = {'Off','Initialize','Normal','Fixed','Fail'};
stateString = {'off','initialized'};
componentsFromLeft = textWidth + 0.15;
popUpMenuHeight = 0.053;
statePopUpMenuFromBottom = 0.99 - popUpMenuHeight;
popUpMenuWidth = 0.33;

panel.statePopUpMenu = uicontrol('Parent', panel.handle,...
    'Style', 'popupmenu',...
    'Units','normalized',...
    'Position', [ componentsFromLeft statePopUpMenuFromBottom popUpMenuWidth popUpMenuHeight ],...
    'String',stateString,...
    'HorizontalAlignment','left',...
    'FontSize',13.9);


%% Insert "Mode" pop-up menu
modeString = {'Target','Workspace','ABDMax'};
modePopUpMenuFromBottom = textFromBottom(2);

panel.modePopUpMenu = uicontrol('Parent', panel.handle,...
    'Style', 'popupmenu',...
    'Units','normalized',...
    'Position', [ componentsFromLeft modePopUpMenuFromBottom popUpMenuWidth popUpMenuHeight ],...
    'String',modeString,...
    'HorizontalAlignment','left',...
    'FontSize',13.9);


%% percent limb weight edit box
editBoxWidth = 0.2;
editBoxHeight = 0.06;
percentLimbSupportEditBoxFromBottom = textFromBottom(3);
editBoxPosition = [ componentsFromLeft percentLimbSupportEditBoxFromBottom editBoxWidth editBoxHeight ];

panel.percentLimbSupportEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '');
%set(panel.percentLimbSupportEditBox,'Enable','off');  % disable edit box


%% Percent abduction max edit box
percentAbductionMaxEditBoxFromBottom = textFromBottom(4);
editBoxPosition = [ componentsFromLeft percentAbductionMaxEditBoxFromBottom editBoxWidth editBoxHeight ];
panel.percentAbductionMaxEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '' );

%% Insert "Haptic table" toggle buttons
toggleWidth = pushButtonWidth;
toggleHeight = pushButtonHeight;

% horizontal toggle button
horizontalToggleButtonFromBottom = textFromBottom(5);
horizontalToggleButtonPosition = [componentsFromLeft horizontalToggleButtonFromBottom toggleWidth toggleHeight];
panel.horizontalToggleButton = CreateToggleButton( panel.handle, horizontalToggleButtonPosition, 'Horizontal' );

% vertical toggle button
verticalToggleButtonFromBottom = textFromBottom(5)-0.06;
verticalToggleButtonPosition = [componentsFromLeft verticalToggleButtonFromBottom toggleWidth toggleHeight];
panel.verticalToggleButton = CreateToggleButton( panel.handle, verticalToggleButtonPosition, 'Vertical' );

% slant toggle button
slantToggleButtonFromBottom = textFromBottom(6);
slantToggleButtonPosition = [(componentsFromLeft - toggleWidth) slantToggleButtonFromBottom toggleWidth toggleHeight];
panel.slantToggleButton = CreateToggleButton( panel.handle, slantToggleButtonPosition, 'Table' ); %Changed text to slant table. Code says slant for this condition!

% load toggle button
loadToggleButtonFromBottom = textFromBottom(6);
loadToggleButtonPosition = [componentsFromLeft loadToggleButtonFromBottom toggleWidth toggleHeight];
panel.loadToggleButton = CreateToggleButton( panel.handle, loadToggleButtonPosition, 'Load' ); %Changed text to slant table. All code still says lift for this condition!

% synergy toggle button
synergyToggleButtonFromBottom = textFromBottom(6)-0.06;
synergyToggleButtonPosition = [(componentsFromLeft - toggleWidth) synergyToggleButtonFromBottom toggleWidth toggleHeight];
panel.synergyToggleButton = CreateToggleButton( panel.handle, synergyToggleButtonPosition, 'Synergy' ); %button for synergy quantification

%% Insert damper components
% toggle button
damperToggleButtonFromBottom = textFromBottom(7);
damperToggleButtonPosition = [componentsFromLeft damperToggleButtonFromBottom toggleWidth toggleHeight];
panel.damperToggleButton = CreateToggleButton( panel.handle, damperToggleButtonPosition, 'Damper' );
set(panel.damperToggleButton,'Enable','on');

% coeffiecient edit box
coefficientEditBoxFromBottom = textFromBottom(8);
editBoxPosition = [ componentsFromLeft coefficientEditBoxFromBottom editBoxWidth editBoxHeight ];
panel.coefficientEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '0' );
set(panel.coefficientEditBox,'Enable','on');


%% insert set external force text and edit boxes
% text
textWidth = 0.06;
textFromLeft = componentsFromLeft - 0.05;
spacing = textHeight + 0.02;
externalForceFromBottom = textFromBottom(9) : -spacing : textFromBottom(9)-spacing*3;
textString = { 'X:', 'Y:', 'Z:' };

for j = 1 : length( textString )
    textPosition = [ textFromLeft externalForceFromBottom(j) textWidth textHeight ];
    CreateTextComponent( panel.handle, textPosition, textString(j) );
end

% edit boxes
editBoxFromLeft = textFromLeft + textWidth + 0.01;
for j = 1 : length(textString)
    editBoxPosition = [ editBoxFromLeft externalForceFromBottom(j) editBoxWidth editBoxHeight ];
    panel.externalForceEditBox(j) = CreateEditBoxComponent( panel.handle, editBoxPosition, '0' );
end
%set( panel.externalForceEditBox(:), 'Enable', 'off');

% units for external forces (newtons)
unitFromLeft = editBoxFromLeft + editBoxWidth + 0.05;
unitsWidth = 0.05;
for j = 1 : length(textString)
    textPosition = [ unitFromLeft externalForceFromBottom(j) unitsWidth textHeight ];
    CreateTextComponent( panel.handle, textPosition, 'N' );
end


%% Insert Record Shoulder Abduction Max
% toggle button
abdMaxToggleButtonFromBottom = pushButtonHeight*3;
abdMaxToggleButtonPosition = [startTrialPushButtonFromLeft abdMaxToggleButtonFromBottom pushButtonWidth+.2 pushButtonHeight];
panel.abdMaxToggleButton = CreateToggleButton( panel.handle, abdMaxToggleButtonPosition, 'Record ABD Max' );
set(panel.abdMaxToggleButton,'Enable','on');

% create Shoulder Abduction Max text
filenameTextFromBottom = pushButtonHeight*2 +.002;
textPosition = [ startTrialPushButtonFromLeft filenameTextFromBottom 0.5 textHeight ];
textString = 'Shoulder Abduction Max:';
CreateTextComponent( panel.handle, textPosition, textString );

% create file name edit box
filenameEditBoxFromBottom = pushButtonHeight*1.5;
filenameEditBoxWidth = 0.5;
editBoxPosition = [ startTrialPushButtonFromLeft filenameEditBoxFromBottom filenameEditBoxWidth textHeight ];
panel.filenameEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '' );
set( panel.filenameEditBox, 'Enable', 'off' );
end

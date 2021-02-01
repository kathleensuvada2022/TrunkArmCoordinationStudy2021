function panel = CreateDaqParametersPanelComponents( panel )
%CREATEDAQPARAMETERSCOMPONENTS Summary of this function goes here
%   Detailed explanation goes here

panelHeight = 1; 

% checkbox to turn on DAQ
daqSwitchCheckBoxFromLeft = 0.001;
daqSwitchCheckBoxFromBottom = panelHeight - 0.1;
daqSwitchCheckBoxWidth = 0.304;
daqSwitchCheckBoxHeight = 0.107;
daqSwitchCheckBoxPosition = [ daqSwitchCheckBoxFromLeft daqSwitchCheckBoxFromBottom daqSwitchCheckBoxWidth daqSwitchCheckBoxHeight ];
panel.daqSwitchCheckBox = uicontrol('Parent', panel.handle,...
    'Style', 'checkbox',...
    'Units','normalized',...
    'Position', daqSwitchCheckBoxPosition,...
    'String','DAQ Switch',...
    'FontSize',12);
%set( panel.daqSwitchCheckBox, 'Enable','off' );
set( panel.daqSwitchCheckBox, 'Value',1 );

%% Insert static text labels
textString = { 'DAQ Channels:', 'Sampling Rate:', 'Max Pre-Trial Time:', 'DAQ Device:'};

textFromLeft = daqSwitchCheckBoxFromLeft;    
textHeight = 0.08;

textTop = daqSwitchCheckBoxFromBottom - daqSwitchCheckBoxHeight - 0.02; 
spaceBetweenText = textHeight + 0.05; 
textBottom = textTop - spaceBetweenText * (length(textString)-1);
textFromBottom = textTop : -spaceBetweenText : textBottom;
textWidth = 0.38;

for textIndex = 1:length(textString)
    textPosition = [ textFromLeft textFromBottom(textIndex) textWidth textHeight ];
    CreateTextComponent( panel.handle, textPosition, textString(textIndex) );
end

%% first four edit boxes
editBoxWidth = 0.16;
editBoxHeight = 0.1;
editBoxFromLeft = textWidth + 0.03;
editBoxFromBottom = textFromBottom;

% create daq channels edit box
editBoxPosition = [ editBoxFromLeft editBoxFromBottom(1) editBoxWidth editBoxHeight ];
panel.daqChannelsEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '18' );
%set( panel.daqChannelsEditBox, 'Enable', 'off' );

% create sampling rate edit box
editBoxPosition = [ editBoxFromLeft editBoxFromBottom(2) editBoxWidth editBoxHeight ];
panel.samplingRateEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '1000' );

% create max trial time edit box
editBoxPosition = [ editBoxFromLeft editBoxFromBottom(3) editBoxWidth editBoxHeight ];
panel.maxPreTrialTimeEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '20' );

% create check boxes for QUANSER,NIDAQ and TTL

checkboxWidth = 0.3;
checkboxHeight = 0.1;
nidaqCheckboxFromLeft = textFromLeft;
checkboxFromBottom = editBoxFromBottom(end) - editBoxHeight;

nidaqCheckboxPosition = [ nidaqCheckboxFromLeft checkboxFromBottom checkboxWidth checkboxHeight ];
panel.nidaqCheckbox = CreateCheckboxComponent( panel.handle, nidaqCheckboxPosition, 'NI-DAQ' );

ttlCheckboxFromLeft = textFromLeft + checkboxWidth + 0.02;
ttlCheckboxPosition = [ ttlCheckboxFromLeft checkboxFromBottom checkboxWidth checkboxHeight ];
panel.ttlCheckbox = CreateCheckboxComponent( panel.handle, ttlCheckboxPosition, 'TTL' );

quanserCheckboxFromLeft = ttlCheckboxFromLeft + checkboxWidth + 0.02;
quanserCheckboxPosition = [ quanserCheckboxFromLeft checkboxFromBottom checkboxWidth checkboxHeight ];
panel.quanserCheckbox = CreateCheckboxComponent( panel.handle, quanserCheckboxPosition, 'Quanser' );
%{
popUpMenuString = {'NI-DAQ','Quanser'};
popUpMenuFromLeft = editBoxFromLeft;
popUpMenuFromBottom = textFromBottom(4) + 0.01;
popUpMenuWidth = 0.25;
popUpMenuHeight = 0.1;

panel.daqDevicePopUpMenu = uicontrol('Parent', panel.handle,...
    'Style', 'popupmenu',...
    'Units','normalized',...
    'Position', [ popUpMenuFromLeft popUpMenuFromBottom popUpMenuWidth popUpMenuHeight ],...
    'String',popUpMenuString,...
    'HorizontalAlignment','left',...
    'FontSize',13.9);
set( panel.daqDevicePopUpMenu, 'Value',2 ); % default to quanser
%}

% units
unitString = { 'Hz', 's' };

unitFromLeft = editBoxFromLeft + editBoxWidth + 0.01;
unitFromBottom = textFromBottom(2:3);
unitWidth = 0.07;

for unitIndex = 1:length(unitString)
    textPosition = [ unitFromLeft unitFromBottom(unitIndex) unitWidth textHeight ];
    CreateTextComponent( panel.handle, textPosition, unitString(unitIndex) );
end

%{
% create EMG maxes check box
emgMaxesCheckBoxFromLeft = textFromLeft;
emgMaxesCheckBoxFromBottom = textFromBottom(end) - textHeight - 0.05;
emgMaxesCheckBoxWidth = 0.31;
emgMaxesCheckBoxHeight = 0.1;
emgMaxesCheckBoxPosition = [ emgMaxesCheckBoxFromLeft emgMaxesCheckBoxFromBottom emgMaxesCheckBoxWidth emgMaxesCheckBoxHeight ];
panel.emgMaxesCheckBox = uicontrol('Parent', panel.handle,...
    'Style', 'checkbox',...
    'Units','normalized',...
    'Position', emgMaxesCheckBoxPosition,...
    'String','EMG Maxes',...
    'FontSize',12);
set( panel.emgMaxesCheckBox, 'Enable','Off' );
%}

% create file name text
filenameTextFromBottom = checkboxFromBottom - checkboxHeight - 0.03;
textPosition = [ textFromLeft filenameTextFromBottom textWidth textHeight ];
textString = 'Filename:';
CreateTextComponent( panel.handle, textPosition, textString );

% create file name edit box
filenameEditBoxFromBottom = filenameTextFromBottom - textHeight - 0.02;
filenameEditBoxWidth = 0.98;
editBoxPosition = [ textFromLeft filenameEditBoxFromBottom filenameEditBoxWidth editBoxHeight ];
panel.filenameEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '' );
set( panel.filenameEditBox, 'Enable', 'off' );

% create initialize DAQ push button
pushButtonWidth = 0.35;
pushButtonHeight = 0.23;
initializeDaqPushButtonFromBottom = panelHeight - pushButtonHeight;
pushButtonFromLeft = 1 - pushButtonWidth - 0.01;
pushButtonPosition = [ pushButtonFromLeft, initializeDaqPushButtonFromBottom, pushButtonWidth, pushButtonHeight ];
panel.initializeDaqPushButton = CreatePushButtonComponent(...
        panel.handle, pushButtonPosition, 'Initialize DAQ');

% create record EMG maxes push button
recordMaxesPushButtonFromBottom = initializeDaqPushButtonFromBottom - pushButtonHeight - 0.02;
pushButtonPosition = [ pushButtonFromLeft, recordMaxesPushButtonFromBottom, pushButtonWidth, pushButtonHeight ];
panel.recordEmgMaxesPushButton = CreatePushButtonComponent(...
        panel.handle, pushButtonPosition, 'Record Maxes');
    
end


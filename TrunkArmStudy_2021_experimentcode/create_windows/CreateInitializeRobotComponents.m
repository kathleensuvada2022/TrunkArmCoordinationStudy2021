function structure = CreateInitializeRobotComponents( structure, robot )

%% variables used throughout this function
textHeight = 0.02854;
componentsFromLeft = 0.02824; 
pushButtonHeight = 0.03767;
editBoxHeight = 0.03196;

%% Set Inertia component
inertiaFromBottom = 0.9418;

% text
inertiaString = 'Set Inertia: [6]';
inertiaTextWidth = 0.2871;
textPosition = [ componentsFromLeft inertiaFromBottom inertiaTextWidth textHeight ];

structure.inertiaText = CreateTextComponent( structure.figureHandle, textPosition, inertiaString );

% edit box
inertiaEditBoxFromLeft = 0.3671;
inertiaEditBoxWidth = 0.1271;
inertiaEditBoxPosition = [ inertiaEditBoxFromLeft inertiaFromBottom inertiaEditBoxWidth editBoxHeight ];
inertiaEditBoxString = robot.inertia;
structure.inertiaEditBox = CreateEditBoxComponent( structure.figureHandle, inertiaEditBoxPosition, inertiaEditBoxString);
robot.SetInertia( robot.inertia );

%% Arm Button Group
% button group
armButtonGroupFromBottom = 0.8037;
armButtonGroupWidth = 0.2706;
armButtonGroupHeight = 0.1153;
armButtonGroupPosition = [ componentsFromLeft, armButtonGroupFromBottom,...
    armButtonGroupWidth, armButtonGroupHeight ];
structure.armButtonGroup = uibuttongroup('Parent', structure.figureHandle,...
    'Units','normalized',...
    'Title','Arm',...
    'FontSize',12,...
    'Position',armButtonGroupPosition);

armRadioButtonFromLeft = 0.1188;
radioButtonHeight = 0.38;
radioButtonWidth = 0.7129;

% right radio button
rightRadioButtonFromBottom = 0.641;
radioButtonPosition = [ armRadioButtonFromLeft rightRadioButtonFromBottom radioButtonWidth radioButtonHeight ];
structure.rightRadioButton = CreateRadioButtonComponent( structure.armButtonGroup,...
    radioButtonPosition, 'Right' );

% left radio button
leftRadioButtonFromBottom = 0.225;
radioButtonPosition = [ armRadioButtonFromLeft leftRadioButtonFromBottom radioButtonWidth radioButtonHeight ];
structure.leftRadioButton = CreateRadioButtonComponent( structure.armButtonGroup,...
    radioButtonPosition, 'Left' );
%set( structure.leftRadioButton, 'Enable','off');

set( structure.armButtonGroup, 'SelectedObject', structure.rightRadioButton );
setappdata( structure.figureHandle, 'arm', structure.rightRadioButton );


% Print Rotation button
printRotationPushButtonFromLeft = componentsFromLeft + armButtonGroupWidth + 0.1;
printRotationPushButtonFromBottom = armButtonGroupFromBottom + 0.05;
printRotationPushButtonWidth = 0.45;
printRotationPushButtonPosition = [ printRotationPushButtonFromLeft, printRotationPushButtonFromBottom,...
    printRotationPushButtonWidth, pushButtonHeight ];

structure.printRotationPushButton = CreatePushButtonComponent(...
    structure.figureHandle,...
    printRotationPushButtonPosition,...
    'Print Rotation');


%% Scope Panel and components
% panel
scopePanelTitle = 'Scope';

scopePanelWidth = 0.9435; 
scopePanelHeight = 0.1564;
scopePanelFromBottom = 0.6153;
scopePanelPosition = [ componentsFromLeft, scopePanelFromBottom, scopePanelWidth, scopePanelHeight ];    % [left bottom width height]

structure.scopePanel = CreatePanel( scopePanelPosition, structure.figureHandle, scopePanelTitle );
set(structure.scopePanel,'Title','Scope','FontSize',12);

scopeTextHeight = 0.25;

% "save file in:" text
savefileString = 'Save File In:';
savefileFromBottom = 0.7544;
savefileTextWidth = 0.5;
textPosition = [ componentsFromLeft savefileFromBottom savefileTextWidth scopeTextHeight ];

structure.inertiaText = CreateTextComponent( structure.scopePanel, textPosition, savefileString );

% browse push button
browsePushButtonFromLeft = 0.7649;
browsePushButtonFromBottom = 0.7565;
browsePushButtonWidth = 0.20413;
browsePushButtonHeight = 0.287;
browsePushButtonPosition = [ browsePushButtonFromLeft, browsePushButtonFromBottom,...
    browsePushButtonWidth, browsePushButtonHeight ];

structure.browsePushButton = CreatePushButtonComponent(...
    structure.scopePanel, browsePushButtonPosition, 'Browse');

% filename edit box
filenameEditBoxFromBottom = 0.5391;
filenameEditBoxWidth = 0.9509;
filenameEditBoxHeight = 0.2;
editBoxPosition = [ componentsFromLeft filenameEditBoxFromBottom filenameEditBoxWidth filenameEditBoxHeight ];
structure.filenameEditBox = CreateEditBoxComponent( structure.scopePanel,...
    editBoxPosition, pwd );
setappdata(structure.figureHandle,'filename',pwd);

% "Frequency (Hz): [250]" text
frequencyString = 'Frequency (Hz): [250]';
frequencyFromBottom = 0.1491;
frequencyTextWidth = 0.4811;
textPosition = [ componentsFromLeft frequencyFromBottom frequencyTextWidth scopeTextHeight ];

CreateTextComponent( structure.scopePanel, textPosition, frequencyString );

% frequency pop-up menu
frequencyPopUpMenuString = {'250','1','2'}; % add all frequency values
frequencyPopUpMenuFromLeft = 0.769;
popUpMenuWidth = 0.2;
popUpMenuHeight = 0.270;

structure.frequencyPopUpMenu = uicontrol('Parent', structure.scopePanel,...
    'Style', 'popupmenu',...
    'Units','normalized',...
    'Position', [ frequencyPopUpMenuFromLeft frequencyFromBottom popUpMenuWidth popUpMenuHeight ],...
    'String',frequencyPopUpMenuString,...
    'HorizontalAlignment','left',...
    'FontSize',13.9);
set(structure.frequencyPopUpMenu,'Enable','Off'); %temp - not yet implemented

%% Participant Parameters, Locate Shoulder, Compute Abd Max Force, Weigh Arm push buttons
% Participant Parameters push button
participantParametersPushButtonFromLeft = componentsFromLeft;
participantParametersPushButtonFromBottom = 0.531;
participantParametersPushButtonWidth = 0.6;
participantParametersPushButtonPosition = [ participantParametersPushButtonFromLeft, participantParametersPushButtonFromBottom,...
    participantParametersPushButtonWidth, pushButtonHeight ];

structure.participantParametersPushButton = CreatePushButtonComponent(...
    structure.figureHandle,...
    participantParametersPushButtonPosition,...
    'Participant Parameters');


% Load Positions push button - this button will load home, target, and
% shoulder positions from a previous experiment.
loadPositionsPushButtonFromBottom = 0.450;
loadPositionsPushButtonWidth = 0.45;
loadPositionsPushButtonPosition = [ componentsFromLeft, loadPositionsPushButtonFromBottom,...
    loadPositionsPushButtonWidth, pushButtonHeight ];

structure.loadPositionsPushButton = CreatePushButtonComponent(...
    structure.figureHandle, loadPositionsPushButtonPosition, 'Load Positions');
set(structure.loadPositionsPushButton,'Enable','on');

    
% Locate Shoulder push button
locateShoulderPushButtonFromBottom = 0.352;
locateShoulderPushButtonWidth = 0.43;
locateShoulderPushButtonPosition = [ componentsFromLeft, locateShoulderPushButtonFromBottom,...
    locateShoulderPushButtonWidth, pushButtonHeight ];

structure.locateShoulderPushButton = CreatePushButtonComponent(...
    structure.figureHandle, locateShoulderPushButtonPosition, 'Locate Shoulder');

%% Chair Position Button Group
% button group
chairPositionButtonGroupHeight = 0.112;
chairPositionButtonGroupWidth = 0.35;
chairPositionButtonGroupFromLeft = componentsFromLeft + locateShoulderPushButtonWidth + 0.1; 
chairPositionButtonGroupFromBottom = 0.316;
chairPositionButtonGroupPosition = [ chairPositionButtonGroupFromLeft, chairPositionButtonGroupFromBottom,...
    chairPositionButtonGroupWidth, chairPositionButtonGroupHeight ];
structure.chairPositionButtonGroup = uibuttongroup('Parent', structure.figureHandle,...
    'Units','normalized',...
    'Title','Chair Position',...
    'FontSize',12,...
    'Position',chairPositionButtonGroupPosition );

chairPositionRadioButtonFromLeft = 0.0726;

% one radio button
oneRadioButtonFromBottom = 0.613;
radioButtonPosition = [ chairPositionRadioButtonFromLeft oneRadioButtonFromBottom radioButtonWidth radioButtonHeight ];
structure.oneRadioButton = CreateRadioButtonComponent( structure.chairPositionButtonGroup,...
    radioButtonPosition, 'One' );

% two radio button
twoRadioButtonFromBottom = 0.227;
radioButtonPosition = [ chairPositionRadioButtonFromLeft twoRadioButtonFromBottom radioButtonWidth radioButtonHeight ];
structure.twoRadioButton = CreateRadioButtonComponent( structure.chairPositionButtonGroup,...
    radioButtonPosition, 'Two' );
%set( structure.twoRadioButton, 'Enable','off');

set( structure.chairPositionButtonGroup, 'SelectedObject', structure.oneRadioButton );
setappdata( structure.figureHandle, 'chairPosition', structure.oneRadioButton );


% push button to compute the abduction max force of the subject  
computeAbdMaxForcePushButtonFromBottom = 0.241;
computeAbdMaxForcePushButtonWidth = 0.65;
computeAbdMaxForcePushButtonPosition = [ componentsFromLeft, computeAbdMaxForcePushButtonFromBottom,...
    computeAbdMaxForcePushButtonWidth, pushButtonHeight ];

structure.computeAbdMaxForcePushButton = CreatePushButtonComponent(...
    structure.figureHandle, computeAbdMaxForcePushButtonPosition, 'Compute Abd Max Force');

% Weigh Arm push button
weighArmPushButtonFromBottom = 0.185;
weighArmPushButtonWidth = 0.355;
weighArmPushButtonPosition = [ componentsFromLeft, weighArmPushButtonFromBottom,...
    weighArmPushButtonWidth, pushButtonHeight ];

structure.weighArmPushButton = CreatePushButtonComponent(...
    structure.figureHandle, weighArmPushButtonPosition, 'Weigh Arm');
setappdata( structure.figureHandle, 'limbWeight', 25 );

% Save Participant Parameters to File push button
savePPToFilePushButtonFromBottom = 0.123;
savePPToFilePushButtonWidth = 0.9;
savePPToFilePushButtonPosition = [ componentsFromLeft, savePPToFilePushButtonFromBottom,...
    savePPToFilePushButtonWidth, pushButtonHeight ];

structure.savePPToFilePushButton = CreatePushButtonComponent(...
    structure.figureHandle, savePPToFilePushButtonPosition, 'Save Participant Parameters to File');
setappdata( structure.figureHandle, 'limbWeight', 25 );



%% OK and Cancel push buttons
% OK push button
okPushButtonFromBottom = 0.0205;
okPushButtonWidth = 0.2;
okPushButtonPosition = [ componentsFromLeft, okPushButtonFromBottom,...
    okPushButtonWidth, pushButtonHeight ];

structure.okPushButton = CreatePushButtonComponent(...
    structure.figureHandle, okPushButtonPosition, 'OK');

% Cancel push button
cancelPushButtonFromLeft = 0.228;
cancelPushButtonFromBottom = okPushButtonFromBottom;
cancelPushButtonWidth = okPushButtonWidth;
cancelPushButtonPosition = [ cancelPushButtonFromLeft, cancelPushButtonFromBottom,...
    cancelPushButtonWidth, pushButtonHeight ];

structure.cancelPushButton = CreatePushButtonComponent(...
    structure.figureHandle, cancelPushButtonPosition, 'Cancel');
set( structure.cancelPushButton, 'Enable','off');

end
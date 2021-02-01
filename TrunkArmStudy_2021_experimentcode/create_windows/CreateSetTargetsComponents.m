function structure = CreateSetTargetsComponents( structure, participantParameters )


disp('entered create set target components');
%% variables used throughout this function
firstColumnFromLeft = 0.0167; 

textHeight = 0.053;

pushButtonFromBottom = 0.035;
pushButtonWidth = 0.15;
pushButtonHeight = 0.0623;

radioButtonFromBottom = 0.88 : -0.17 : 0.88-0.17*5;
radioButtonHeight = 0.12;

editBoxWidth = 0.2;
editBoxHeight = pushButtonHeight;

buttonGroupFromBottom = 0.494;

%% target positions button group and radio buttons
% button group
targetsButtonGroupFromLeft = 0.545;
targetsButtonGroupWidth = 0.428;
targetsButtonGroupHeight = 0.468;
targetsButtonGroupPosition = [ targetsButtonGroupFromLeft, buttonGroupFromBottom,...
    targetsButtonGroupWidth, targetsButtonGroupHeight ];
structure.targetsButtonGroup = uibuttongroup('Parent', structure.figureHandle,...
    'Units','normalized',...
    'Title','targets',...
    'FontSize',12,...
    'Position',targetsButtonGroupPosition);

firstColumnRadioButtonWidth = 0.55;
firstColumnRadioButtonFromLeft = 0.04;

% target 1 radio button (40 deg SF, 10 deg EF)
target1RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(1)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.target1RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, target1RadioButtonPosition, 'Target 1' );
%set(structure.target1RadioButton,'Enable','Off');    %temp - not implemented

% target 2 radio button (60 deg SF, 10 deg EF)
target2RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(2)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.target2RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, target2RadioButtonPosition, 'Target 2' );
%set(structure.target2RadioButton,'Enable','Off');    %temp - not implemented

% target 3 radio button (80 deg SF, 10 deg EF)
target3RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(3)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.target3RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, target3RadioButtonPosition, 'Target 3' );
%set(structure.target3RadioButton,'Enable','Off');    %temp - not implemented

% target 4 radio button (100 deg SF, 10 deg EF)
target4RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(4)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.target4RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, target4RadioButtonPosition, 'Target 4' );
%set(structure.target4RadioButton,'Enable','Off');    %temp - not implemented

% retrieve radio button
retrieveRadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(5)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.retrieveRadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, retrieveRadioButtonPosition, 'Retrieve' );
set(structure.retrieveRadioButton,'Enable','Off');    %temp - not implemented

% custom radio button
customRadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(6)...
    firstColumnRadioButtonWidth radioButtonHeight ];
structure.customRadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, customRadioButtonPosition, 'Custom' );
set( structure.targetsButtonGroup, 'SelectedObject', structure.customRadioButton );
setappdata( structure.figureHandle, 'target', structure.customRadioButton );

%--
secondColumnRadioButtonFromLeft = firstColumnRadioButtonFromLeft + firstColumnRadioButtonWidth + 0.02;
secondColumnRadioButtonWidth = 0.35;

% S1 radio button
S1_RadioButtonPosition = [ secondColumnRadioButtonFromLeft radioButtonFromBottom(1)...
    secondColumnRadioButtonWidth radioButtonHeight ];
structure.S1_RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, S1_RadioButtonPosition, 'S1' );

% R radio button
R_RadioButtonPosition = [ secondColumnRadioButtonFromLeft radioButtonFromBottom(2)...
    secondColumnRadioButtonWidth radioButtonHeight ];
structure.R_RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, R_RadioButtonPosition, 'R' );

% E1 radio button
E1_RadioButtonPosition = [ secondColumnRadioButtonFromLeft radioButtonFromBottom(3)...
    secondColumnRadioButtonWidth radioButtonHeight ];
structure.E1_RadioButton = CreateRadioButtonComponent(...
    structure.targetsButtonGroup, E1_RadioButtonPosition, 'E1' );


%% text for target position and target angles
secondRowFromBottom = buttonGroupFromBottom - 0.1;
thirdRowFromBottom = secondRowFromBottom - 0.1;
fourthRowFromBottom = thirdRowFromBottom - 0.1;
xyzTextWidth = 0.04;

% X:
textPosition = [ firstColumnFromLeft secondRowFromBottom xyzTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'X:');

% Y:
textPosition = [ firstColumnFromLeft thirdRowFromBottom xyzTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'Y:');

% Z:
textPosition = [ firstColumnFromLeft fourthRowFromBottom xyzTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'Z:');

% Shoulder Flexion Angle:
angleFromLeft = 0.3;
angleTextWidth = 0.45;
textPosition = [ angleFromLeft secondRowFromBottom angleTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'Shoulder Flexion Angle:');

% Elbow Angle:
textPosition = [ angleFromLeft thirdRowFromBottom angleTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'Elbow Angle:');

% Shoulder Abduction Angle:
textPosition = [ angleFromLeft fourthRowFromBottom angleTextWidth textHeight ];
CreateTextComponent( structure.figureHandle, textPosition, 'Shoulder Abduction Angle:');


%% edit boxes for target positions and angles
% x edit box
firstColumnEditBoxFromLeft = firstColumnFromLeft + xyzTextWidth + 0.01;
editBoxPosition = [ firstColumnEditBoxFromLeft secondRowFromBottom editBoxWidth editBoxHeight ];
structure.xEditBox = CreateEditBoxComponent( structure.figureHandle,...
    editBoxPosition, '');
set(structure.xEditBox,'Enable','Off');    %temp - not implemented

% y edit box
editBoxPosition = [ firstColumnEditBoxFromLeft thirdRowFromBottom editBoxWidth editBoxHeight ];
structure.yEditBox = CreateEditBoxComponent( structure.figureHandle,... 
    editBoxPosition, '');
set(structure.yEditBox,'Enable','Off');    %temp - not implemented

% z edit box
editBoxPosition = [ firstColumnEditBoxFromLeft fourthRowFromBottom editBoxWidth editBoxHeight ];
structure.zEditBox = CreateEditBoxComponent( structure.figureHandle,... 
    editBoxPosition, '');
set(structure.zEditBox,'Enable','Off');    %temp - not implemented

% shoulder flexion angle edit box
secondColumnEditBoxFromLeft = angleFromLeft + angleTextWidth + 0.01;
editBoxPosition = [ secondColumnEditBoxFromLeft secondRowFromBottom editBoxWidth editBoxHeight ];
structure.shoulderFlexionAngleEditBox = CreateEditBoxComponent( structure.figureHandle,...
    editBoxPosition, '80');

% elbow angle edit box
editBoxPosition = [ secondColumnEditBoxFromLeft thirdRowFromBottom editBoxWidth editBoxHeight ];
structure.elbowAngleEditBox = CreateEditBoxComponent( structure.figureHandle, editBoxPosition, '20');

% shoulder abduction angle edit box
editBoxPosition = [ secondColumnEditBoxFromLeft fourthRowFromBottom editBoxWidth editBoxHeight ];
structure.shoulderAbductionAngleEditBox = CreateEditBoxComponent( structure.figureHandle,...
    editBoxPosition, '85');


% create degrees sign for the angles
unitFromLeft = secondColumnEditBoxFromLeft + editBoxWidth + 0.005;
unitWidth = xyzTextWidth;
unitFromBottom = [ secondRowFromBottom thirdRowFromBottom fourthRowFromBottom ] + 0.05;
for i = 1:3
    textPosition = [ unitFromLeft unitFromBottom(i) unitWidth textHeight ];
    CreateTextComponent( structure.figureHandle, textPosition, 'o');
end

%% axes
axesFromLeft = firstColumnFromLeft + 0.02;
axesFromBottom = 0.496;
axesWidth = 0.483;
axesHeight = 0.468;

structure.axesHandle = axes( 'Parent',structure.figureHandle, 'units','normalized',...
    'Position',[ axesFromLeft, axesFromBottom, axesWidth, axesHeight ],...
    'XTick',[],'YTick',[]);

% plot sample arm
upperArmX = [0 0.2394];
upperArmY = upperArmX;
lowerArmX = [0.2394 -0.0918];
lowerArmY = [0.2394 0.5707];
structure.armLineSeries = plot( structure.axesHandle,...
    upperArmX, upperArmY,...
    lowerArmX, lowerArmY);
set(structure.armLineSeries,'LineWidth',3);
set(structure.armLineSeries,'Color','black');
set( structure.axesHandle, 'XTick',[] );
set( structure.axesHandle, 'YTick',[] );
hold on

% plot sample target at origin
radius = 0.02;
numberOfPoints = 50;
[origin_x, origin_y, z] = cylinder(radius, numberOfPoints);
target_x = origin_x(1,:);% + lowerArmX(2);
target_y = origin_y(1,:);% + lowerArmY(2) + 0.05;
structure.targetLineSeries = plot( structure.axesHandle,...
    target_x, target_y);
set(structure.targetLineSeries,'LineWidth',5)
set(structure.targetLineSeries,'Color','red')

xlim([-0.8 0.8])
ylim([-0.4 1.2])
hold off

%% Chair position radio button group - equivalent to the chair position 
%% button group in the initialize robot window
% button group
chairPositionButtonGroupHeight = 0.151;
chairPositionButtonGroupWidth = 0.25;
chairPositionButtonGroupFromLeft = firstColumnEditBoxFromLeft;
chairPositionButtonGroupFromBottom = fourthRowFromBottom - editBoxHeight - 0.1;
chairPositionButtonGroupPosition = [ chairPositionButtonGroupFromLeft, chairPositionButtonGroupFromBottom,...
    chairPositionButtonGroupWidth, chairPositionButtonGroupHeight ];
structure.chairPositionButtonGroup = uibuttongroup('Parent', structure.figureHandle,...
    'Units','normalized',...
    'Title','Chair Position',...
    'FontSize',12,...
    'Position',chairPositionButtonGroupPosition );

chairPositionRadioButtonFromLeft = 0.155;
chairPositionRadioButtonWidth = 0.58;
chairPositionRadioButtonHeight = 0.404;

% one radio button
oneRadioButtonFromBottom = 0.509;
radioButtonPosition = [ chairPositionRadioButtonFromLeft oneRadioButtonFromBottom...
    chairPositionRadioButtonWidth chairPositionRadioButtonHeight ];
structure.oneRadioButton = CreateRadioButtonComponent( structure.chairPositionButtonGroup,...
    radioButtonPosition, 'One' );

% two radio button
twoRadioButtonFromBottom = 0.105;
radioButtonPosition = [ chairPositionRadioButtonFromLeft twoRadioButtonFromBottom...
    chairPositionRadioButtonWidth chairPositionRadioButtonHeight ];
structure.twoRadioButton = CreateRadioButtonComponent( structure.chairPositionButtonGroup,...
    radioButtonPosition, 'Two' );

set( structure.chairPositionButtonGroup, 'SelectedObject', structure.oneRadioButton );
setappdata( structure.figureHandle, 'chairPosition', structure.oneRadioButton );


%% toggle button to determine the height of the target sphere. Either the
%% target will be on the table or above the table
previewToggleButtonFromLeft = 0.43;
previewToggleButtonFromBottom = 0.0547;
previewToggleButtonPosition = [ previewToggleButtonFromLeft, previewToggleButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];
structure.previewToggleButton = CreateToggleButton( structure.figureHandle, previewToggleButtonPosition, 'Preview' );


%% ok and cancel push buttons
% ok push button
okPushButtonFromLeft = 0.68;
okPushButtonPosition = [ okPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

structure.okPushButton = CreatePushButtonComponent(...
    structure.figureHandle, okPushButtonPosition, 'OK');

% cancel push button
cancelPushButtonFromLeft = okPushButtonFromLeft + pushButtonWidth + 0.01;
cancelPushButtonPosition = [ cancelPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];
structure.cancelPushButton = CreatePushButtonComponent(...
    structure.figureHandle, cancelPushButtonPosition, 'Cancel');
set( structure.cancelPushButton, 'Enable','off');

end
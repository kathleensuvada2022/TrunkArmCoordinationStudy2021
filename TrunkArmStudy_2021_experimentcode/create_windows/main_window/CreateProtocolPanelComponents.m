function panel = CreateProtocolPanelComponents( panel )

%% create two static text components

textString = { 'Experimental Variables', 'Values to test' };

panelWidth = 1;%panel.panelPosition(3);
panelHeight = 1;%panel.panelPosition(4);
panelEdge = 0.001;%panel.panelEdge(1);
textFromLeft = [ 0.001, panelWidth/2 ];    
textHeight = 0.1;
textFromBottom = panelHeight - panelEdge*2 - textHeight;
textWidth = 0.4;    

for textIndex = 1:length(textString)
    textPosition = [ textFromLeft(textIndex) textFromBottom textWidth textHeight ];
    CreateTextComponent( panel.handle, textPosition, textString(textIndex) );
end


%% create listbox and edit text box components
boxHeight = 0.4;
boxFromBottom = textFromBottom - boxHeight;
boxWidth = panelWidth/2 - 0.005;  

% experimental variables listbox
% listboxString = {'% support','hand task'};
listboxString = {'% support','restraint'}; %Changed for Kacey 5.30.18

% listbox position
listboxFromLeft = textFromLeft(1); 
listboxPosition = [ listboxFromLeft boxFromBottom boxWidth boxHeight ];

panel.experimentalVariablesListbox = CreateListboxComponent( panel.handle,...
    listboxPosition, listboxString );

% edit text box underneath "values"
% panel.userData.percentSupportValuesString = {'Tbl','20','35','50','65','80','95'};
% panel.userData.taskValuesString = {'Neutral','Open','Close'};
panel.userData.percentSupportValuesString = {'Tbl','20','40','50'};
panel.userData.taskValuesString = {'Restrained','Unrestrained'};
% panel.userData.targetValuesString = {'T1','T1','T1','T1','T2','T2','T2','T2',...
%     'T3','T3','T3','T3','T4','T4','T4','T4'};

editBoxFromLeft = textFromLeft(2); 
editBoxPosition = [ editBoxFromLeft boxFromBottom boxWidth boxHeight ];

panel.valuesEditBox = uicontrol('Parent', panel.handle,...
    'Max',2,...         % allow multi-line editing
    'Style', 'edit',...
    'Units','normalized',...
    'Position', editBoxPosition,...
    'String',panel.userData.percentSupportValuesString,...
    'FontSize',11,...
    'HorizontalAlignment','left',...
    'UserData',panel.userData);


%% create push button components
% standard push button height and distance from the bottom of the panel
pushButtonHeight = 0.136;
pushButtonWidth = 0.24;
pushButtonFromBottom = boxFromBottom - pushButtonHeight;

% Create "Add" push button
addPushButtonFromLeft = listboxFromLeft; 
addPushButtonPosition = [ addPushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

addPushButtonString = 'Add';

panel.addPushButton = CreatePushButtonComponent(...
    panel.handle, addPushButtonPosition, addPushButtonString);


% Create "Remove" push button
removePushButtonFromLeft = addPushButtonFromLeft + pushButtonWidth; 
removePushButtonPosition = [ removePushButtonFromLeft, pushButtonFromBottom,...
    pushButtonWidth, pushButtonHeight ];

removePushButtonString = 'Remove';

panel.removePushButton = CreatePushButtonComponent(...
    panel.handle, removePushButtonPosition, removePushButtonString );


% Create "Randomize" push button
pushButtonWidth = 0.3;
randomizePushButtonFromLeft = editBoxFromLeft;
randomizePushButtonPosition = [ randomizePushButtonFromLeft pushButtonFromBottom...
    pushButtonWidth pushButtonHeight ];

randomizePushButtonString = 'Randomize';

panel.randomizePushButton = CreatePushButtonComponent(...
    panel.handle, randomizePushButtonPosition, randomizePushButtonString );

%% Creat Condition Edit Box

editBoxWidth = 0.15;
editBoxHeight = 0.13;
conditionEditBoxFromLeft = randomizePushButtonFromLeft + pushButtonWidth + 0.02;
conditionEditBoxFromBottom = pushButtonFromBottom;
editBoxPosition = [ conditionEditBoxFromLeft conditionEditBoxFromBottom editBoxWidth editBoxHeight ];

panel.conditionEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, '2');

%% create Radio Button Components

panel.condition = 2;
% button group
conditionsButtonGroupFromLeft = textFromLeft(1);
conditionsButtonGroupWidth = panelWidth - 0.005;
conditionsButtonGroupHeight = 0.34;
buttonGroupFromBottom = pushButtonFromBottom - conditionsButtonGroupHeight - 0.005;

conditionsButtonGroupPosition = [ conditionsButtonGroupFromLeft, buttonGroupFromBottom,...
    conditionsButtonGroupWidth, conditionsButtonGroupHeight ];
panel.conditionsButtonGroup = uibuttongroup('Parent', panel.handle,...
    'Units','normalized',...
    'Title','Conditions',...
    'FontSize',10,...
    'Position',conditionsButtonGroupPosition);

RadioButtonWidth = panelWidth/3 - 0.008;
firstColumnRadioButtonFromLeft = 0.01;
secondColumnRadioButtonFromLeft = firstColumnRadioButtonFromLeft + RadioButtonWidth + 0.005;
thirdColumnRadioButtonFromLeft = secondColumnRadioButtonFromLeft + RadioButtonWidth + 0.005;

radioButtonFromBottom = 0.55 : -0.50 : 0.55-0.50;
radioButtonHeight = 0.5;

% Condition 1 radio button: Home Neutral
condition1RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(1)...
    RadioButtonWidth radioButtonHeight ];
panel.condition1RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition1RadioButtonPosition, 'Home-Neutral' );

% Condition 2 radio button: Target Neutral
condition2RadioButtonPosition = [ firstColumnRadioButtonFromLeft radioButtonFromBottom(2)...
    RadioButtonWidth radioButtonHeight ];
panel.condition2RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition2RadioButtonPosition, 'Target-Neutral' );
set( panel.conditionsButtonGroup, 'SelectedObject', panel.condition2RadioButton );
display('Target-Neutral selected');

% Condition 3 radio button: Home Close
condition3RadioButtonPosition = [ secondColumnRadioButtonFromLeft radioButtonFromBottom(1)...
    RadioButtonWidth radioButtonHeight ];
panel.condition3RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition3RadioButtonPosition, 'Home-Open' );

% Condition 4 radio button: Target Close
condition4RadioButtonPosition = [ secondColumnRadioButtonFromLeft radioButtonFromBottom(2)...
    RadioButtonWidth radioButtonHeight ];
panel.condition4RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition4RadioButtonPosition, 'Target-Open' );

% Condition 5 radio button: Home Close
condition5RadioButtonPosition = [ thirdColumnRadioButtonFromLeft radioButtonFromBottom(1)...
    RadioButtonWidth radioButtonHeight ];
panel.condition5RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition5RadioButtonPosition, 'Home-Close' );

% Condition 6 radio button: Target Close
condition6RadioButtonPosition = [ thirdColumnRadioButtonFromLeft radioButtonFromBottom(2)...
    RadioButtonWidth radioButtonHeight ];
panel.condition6RadioButton = CreateRadioButtonComponent(...
    panel.conditionsButtonGroup, condition6RadioButtonPosition, 'Target-Close' );

end

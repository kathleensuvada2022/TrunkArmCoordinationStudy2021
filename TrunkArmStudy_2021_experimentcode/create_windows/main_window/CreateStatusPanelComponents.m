function panel = CreateStatusPanelComponents( panel, deviceId )

%% first column - variables
% string in each text component
firstColumnString = { 'HapticMaster status:' 'State:' 'Distance Reached:' 'Force:' 'Trials completed:' 'Arm:' 'Target:'...
    'Inertia:' 'External force:' 'Experiment status:' 'File saved to:' 'Chair Position:' };

% initialize components
firstColumn = zeros( 1, length(firstColumnString) );

% determine position of each text component (in characters)
firstColumnFromLeft = 0.02;
spaceBetweenText = .08;
%panelHeight = panel.panelPosition(4);
top = 0.941;
bottom = top - spaceBetweenText*length(firstColumnString);
firstColumnFromBottom = top : -spaceBetweenText : bottom;
firstColumnWidth = 0.467;     %28
textHeight = 0.048;

for i = 1:length(firstColumn)
    textPosition = [ firstColumnFromLeft firstColumnFromBottom(i) firstColumnWidth textHeight ];
    firstColumn(i) = CreateTextComponent( panel.handle, textPosition, firstColumnString(i) );
end

%% second column of text components
% string in each text component
secondColumnString = { 'Disconnected' 'Off' '000.00' '0.00', '', 'Right' 'Target 1'...
    '8' '0  0  0' 'Trial Complete' pwd '1' };
if deviceId > 0
    secondColumnString{1} = 'Connected';
end

% initialize components
secondColumn = zeros( 1, length(firstColumnString) );

% determine position of each text component (in characters)
secondColumnFromLeft = firstColumnWidth + 0.05;
secondColumnFromBottom = firstColumnFromBottom;
secondColumnWidth(1:length(secondColumnString)) = 0.465;
secondColumnWidth([ 3, 4, 8]) = 0.2;

% 5th row is an edit box (below), so it's skipped
for i = [1:4 6:length(secondColumn)]
    if i == 11 %Larger text box for filename
        newTextHeight = textHeight*1.5;
        textPosition = [ secondColumnFromLeft secondColumnFromBottom(i) secondColumnWidth(i) newTextHeight ];
        panel.secondColumn(i) = CreateTextComponent( panel.handle, textPosition, secondColumnString(i) );
    else
        textPosition = [ secondColumnFromLeft secondColumnFromBottom(i) secondColumnWidth(i) textHeight ];
        panel.secondColumn(i) = CreateTextComponent( panel.handle, textPosition, secondColumnString(i) );
    end
   
end

% create edit box in the 5th row for trials completed
editBoxHeight = 0.05;
editBoxWidth = 0.1;
editBoxPosition = [ secondColumnFromLeft secondColumnFromBottom(5) editBoxWidth editBoxHeight ];
panel.secondColumn(5) = CreateEditBoxComponent( panel.handle, editBoxPosition, '00' );



%% third column - units and total trials
% units
% values 4, 8 need unit labels

% string in each text component
unitString = {'%','N','kg*m^2'};

% initialize components
unit = zeros(1,length(unitString));

% determine position of each text component (in characters)
unitFromLeft(1:3) = secondColumnFromLeft + secondColumnWidth(3) + 0.01;
unitFromBottom = [ secondColumnFromBottom(3) secondColumnFromBottom(4) secondColumnFromBottom(8) ];
unitWidth = 0.2;

for i=1:length(unitString)
    textPosition = [ unitFromLeft(i) unitFromBottom(i) unitWidth textHeight ];
    unit(i) = CreateTextComponent( panel.handle, textPosition, unitString(i) );
end

%total trials
trialsFromBottom = secondColumnFromBottom(5);

% the 'of' string in between current trial number and total trial number
ofString='of';
ofFromLeft = secondColumnFromLeft + editBoxWidth + 0.05;
ofWidth = 0.08;

ofPosition = [ ofFromLeft trialsFromBottom ofWidth textHeight ];
CreateTextComponent( panel.handle, ofPosition, ofString );

% number of total trials
totalTrialsString = '10';
totalTrialsFromLeft = ofFromLeft + ofWidth + 0.05;

% create edit box 
editBoxPosition = [ totalTrialsFromLeft trialsFromBottom editBoxWidth editBoxHeight ];
panel.totalTrialsEditBox = CreateEditBoxComponent( panel.handle, editBoxPosition, totalTrialsString );

%totalTrialsPosition = [ totalTrialsFromLeft trialsFromBottom totalTrialsWidth textHeight ];
%panel.totalTrials = CreateTextComponent( panel.handle, totalTrialsPosition, totalTrialsString );

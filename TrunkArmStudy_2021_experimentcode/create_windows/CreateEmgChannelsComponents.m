function structure = CreateEmgChannelsComponents( structure, daqChannelsEditBox )

%textString = {'BIC', 'TRILT', 'TRILH', 'ADL', 'IDL', 'PDL', 'O_TRILT', 'O_IDL', 'TTL'};
%textString = {'BIC', 'TRILT', 'ADL', 'IDL', 'PDL', 'BIC2', 'TRILT2', 'IDL2'};
% textString = {'BIC_L', 'TRI_L', 'BRD_L', 'ADL_L', 'IDL_L','PDL_L', ...
%     'BIC_R', 'TRI_R', 'BRD_R', 'ADL_R', 'IDL_R','PDL_R','FFlx_L',...
%     'FFlx_R', 'FExt_L', 'FExt_R','Fingers', 'Thumb'};

% textString = {'BIC', 'TRI', 'Empty', 'IDL', 'WFFlx' 'WFExt', ...
%     'cBIC', 'cTRI', 'cIDL', 'cWFFlx' 'cWFExt',...
%     'Empty','Empty','Empty','Empty','Empty','Empty','Empty'};

textString = {'Ch1', 'Ch2', 'Ch3', 'Ch4', 'Ch5' 'Ch6', ...
    'Ch7', 'Ch8', 'Ch9', 'Ch10' 'Ch11',...
    'Ch12','Ch13','Ch14','Ch15','Ch16','Empty','Empty'};


totalChannels = length(textString);

% axisWidth = 0.3196;
% axisHeight = 0.1636;

axisWidth = 0.2;
axisHeight = 0.13;

textFromLeft1 = 0.016; %0.01580;
textWidth =  0.06; %0.07047;
textHeight = 0.026; %0.04596;
axisTop =  0.8143;
textTop = axisTop + axisHeight/4;

%% create names for the first 10 axis
textBottom = textTop - ( axisHeight*ceil(totalChannels/3) );
textFromBottom = textTop : -(axisHeight +0.02) : textBottom ;
for textIndex = 1 : ceil(totalChannels/3)
    textPosition = [ textFromLeft1, textFromBottom(textIndex), textWidth, textHeight ];
    structure.labels(textIndex) = CreateTextComponent( structure.figureHandle, textPosition, textString(textIndex));
end

% create y axis location vector to alternate the side of the axis the y axis is 
% labeled for each graph - alternates "left" "right", for the amount of emg channels used
yAxisLocation = cell(totalChannels,1);
for i=1:totalChannels
    if mod(i,2)==1     % odd
        yAxisLocation{i} = 'Left';
    else     % even
        yAxisLocation{i} = 'Right';
    end
end

%% create the first column of 10 axis
axisFromLeft1 = 0.1; %0.1227;
axisNumber = 1;
firstColumnEmgAmount = ceil(totalChannels/3);
axisBottom = axisTop - ( axisHeight * firstColumnEmgAmount );
axisFromBottom = axisTop : -(axisHeight + 0.02): axisBottom;
for axisIndex = 1 : firstColumnEmgAmount
    axisPosition = [ axisFromLeft1 axisFromBottom(axisIndex) axisWidth axisHeight ];
    structure.axis(axisNumber) = CreateAxesComponent( structure.figureHandle, axisPosition, yAxisLocation{axisNumber} );
    axisNumber = axisNumber + 1;
end
% set the last component to have an tick marks and a name
%XTick = '''XTick'',[0.0, 0.2, 0.4, 0.6, 0.8, 1.0], ' ;
%XTickLabelMode = '''XTickLabelMode'',''auto'', ' ;
%XTickMode = '''XTickMode'',''auto''' ;
set(structure.axis(firstColumnEmgAmount),...
    'XTick',[0.0, 0.2, 0.4, 0.6, 0.8, 1.0],...
    'XTickLabelMode','auto',...
    'XTickMode','auto' );
xlabel( structure.axis(firstColumnEmgAmount), 't (s)' );

%% create names for the second 20 axis
textBottom = textTop - axisHeight*(totalChannels - ceil(totalChannels/3));
textFromBottom = textTop : -(axisHeight + 0.02) : textBottom;
textFromLeft2 = 0.336; %0.5079;
textNumber = firstColumnEmgAmount + 1;
for textIndex = 1 : totalChannels - 2*ceil(totalChannels/3)
    textPosition = [ textFromLeft2, textFromBottom(textIndex), textWidth, textHeight ];
    structure.labels(textNumber) = CreateTextComponent( structure.figureHandle, textPosition, textString(textNumber) );
    textNumber = textNumber + 1;
end

%% create the second column of 10 axis
axisFromLeft2 = 0.42; %0.6075;
secondColumnEmgAmount = totalChannels - 2*ceil(totalChannels/3);
axisBottom = axisTop - ( axisHeight * secondColumnEmgAmount );
axisFromBottom = axisTop : -(axisHeight + 0.02) : axisBottom;
for axisIndex = 1 : secondColumnEmgAmount
    axisPosition = [ axisFromLeft2 axisFromBottom(axisIndex) axisWidth axisHeight ];
    structure.axis(axisNumber) = CreateAxesComponent( structure.figureHandle, axisPosition, yAxisLocation{axisNumber} );
    axisNumber = axisNumber + 1;
end
% set the last component to have an labeled tick marks
set(structure.axis(secondColumnEmgAmount),...
    'XTick',[0.0, 0.2, 0.4, 0.6, 0.8, 1.0],...
    'XTickLabelMode','auto',...
    'XTickMode','auto' );
xlabel( structure.axis(secondColumnEmgAmount), 't (s)' );

%% create names for the third 20 axis
textBottom = textTop - axisHeight*(totalChannels - ceil(totalChannels/3));
textFromBottom = textTop : -(axisHeight + 0.02) : textBottom;
textFromLeft3 = 0.656; %0.5079;
textNumber = firstColumnEmgAmount + secondColumnEmgAmount + 1;
for textIndex = 1 : totalChannels - 2*ceil(totalChannels/3)
    textPosition = [ textFromLeft3, textFromBottom(textIndex), textWidth, textHeight ];
    structure.labels(textNumber) = CreateTextComponent( structure.figureHandle, textPosition, textString(textNumber) );
    textNumber = textNumber + 1;
end

%% create the third column of 10 axis
axisFromLeft3 = 0.74; %0.6075;
thirdColumnEmgAmount = totalChannels - 2*ceil(totalChannels/3);
axisBottom = axisTop - ( axisHeight * thirdColumnEmgAmount );
axisFromBottom = axisTop : -(axisHeight+0.02) : axisBottom;
for axisIndex = 1 : thirdColumnEmgAmount
    axisPosition = [ axisFromLeft3 axisFromBottom(axisIndex) axisWidth axisHeight ];
    structure.axis(axisNumber) = CreateAxesComponent( structure.figureHandle, axisPosition, yAxisLocation{axisNumber} );
    axisNumber = axisNumber + 1;
end
% set the last component to have an labeled tick marks
set(structure.axis(totalChannels),...
    'XTick',[0.0, 0.2, 0.4, 0.6, 0.8, 1.0],...
    'XTickLabelMode','auto',...
    'XTickMode','auto' );
xlabel( structure.axis(totalChannels), 't (s)' );
end
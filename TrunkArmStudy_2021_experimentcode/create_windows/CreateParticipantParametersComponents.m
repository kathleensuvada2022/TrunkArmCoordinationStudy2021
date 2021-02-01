function structure = CreateParticipantParametersComponents( structure )

%% variables used throughout this function
textHeight = 0.035;
firstColumnFromLeft = 0.01; 
pushButtonHeight = 0.0388;
editBoxWidth = 0.197;
editBoxHeight = 0.04;

%% load from file push button
loadFromFilePushButtonFromBottom = 0.942;
loadFromFilePushButtonWidth = 0.43;
loadFromFilePushButtonPosition = [ firstColumnFromLeft, loadFromFilePushButtonFromBottom,...
    loadFromFilePushButtonWidth, pushButtonHeight ];

structure.loadFromFilePushButton = CreatePushButtonComponent(...
    structure.figureHandle, loadFromFilePushButtonPosition, 'Load From File');


%% first column - text labels
% string in each text component
firstColumnString = { 'Participant ID:', 'Age:', 'Gender:', 'ACT3D Version:',...
    'Upper Arm Length:', 'Lower Arm Length:', 'Elbow To End Effector:',...
    'Hand Length:', 'Elbow Flexion:', 'Shoulder Flexion:','Shoulder Abduction:'...
    'Abduction Max (torque):', 'Abduction Max (force):', 'Limb Weight:' };

% initialize components
structure.firstColumn = zeros( 1, length(firstColumnString) );

% determine position of each text component (in characters)
firstColumnFromLeft = 0.0308;
textSpacing = 0.054;
firstColumnFromBottom = 0.89 : -textSpacing : 0.89 - textSpacing * 14; 
firstColumnWidth = 0.62;

for i = 1:length(firstColumnString)
    textPosition = [ firstColumnFromLeft firstColumnFromBottom(i) firstColumnWidth textHeight ];
    CreateTextComponent( structure.figureHandle, textPosition, firstColumnString(i) ); 
end

%% second column - edit boxes
editBoxFromLeft = firstColumnFromLeft + firstColumnWidth + 0.02;

% Participant ID edit box
participantIdFromBottom = firstColumnFromBottom(1);
participantIdString = 'PxxAA';
structure.participantIdEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft participantIdFromBottom editBoxWidth editBoxHeight ],participantIdString);
setappdata( structure.figureHandle, 'participantId', participantIdString );

% Age edit box
ageFromBottom = firstColumnFromBottom(2);
ageString = '00';
structure.ageEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft ageFromBottom editBoxWidth editBoxHeight ], ageString );
setappdata( structure.figureHandle, 'age', ageString  );

% Gender edit box
genderFromBottom = firstColumnFromBottom(3);
genderString = 'M';
structure.genderEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft genderFromBottom editBoxWidth editBoxHeight ], genderString );
setappdata( structure.figureHandle, 'gender', genderString  );

% ACT3D Version edit box
act3dVersionFromBottom = firstColumnFromBottom(4);
act3dVersionString = '1.2';
structure.act3dVersionEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft act3dVersionFromBottom editBoxWidth editBoxHeight ], act3dVersionString );
setappdata( structure.figureHandle, 'act3dVersion', act3dVersionString  );

% Upper Arm Length edit box
upperArmLengthFromBottom = firstColumnFromBottom(5);
upperArmLengthString = '00';
structure.upperArmLengthEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft upperArmLengthFromBottom editBoxWidth editBoxHeight ], upperArmLengthString );
setappdata( structure.figureHandle, 'upperArmLength', upperArmLengthString  );

% Lower Arm Length edit box
lowerArmLengthFromBottom = firstColumnFromBottom(6);
lowerArmLengthString = '00';
structure.lowerArmLengthEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft lowerArmLengthFromBottom editBoxWidth editBoxHeight ], lowerArmLengthString );
setappdata( structure.figureHandle, 'lowerArmLength', lowerArmLengthString  );

% Elbow To End Effector edit box
elbowToEndEffectorFromBottom = firstColumnFromBottom(7);
elbowToEndEffectorString = '00';
structure.elbowToEndEffectorEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft elbowToEndEffectorFromBottom editBoxWidth editBoxHeight ], elbowToEndEffectorString );
setappdata( structure.figureHandle, 'elbowToEndEffector', elbowToEndEffectorString  );

% Hand Length edit box
handLengthFromBottom = firstColumnFromBottom(8);
handLengthString = '00';
structure.handLengthEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft handLengthFromBottom editBoxWidth editBoxHeight ], handLengthString );
setappdata( structure.figureHandle, 'handLength', handLengthString );

% Elbow Flexion edit box
elbowFlexionFromBottom = firstColumnFromBottom(9);
elbowFlexionString = '90';
structure.elbowFlexionEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft elbowFlexionFromBottom editBoxWidth editBoxHeight ], elbowFlexionString );
setappdata( structure.figureHandle, 'elbowFlexion', elbowFlexionString );

% Shoulder Flexion edit box
shoulderFlexionFromBottom = firstColumnFromBottom(10);
shoulderFlexionString = '40';
structure.shoulderFlexionEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft shoulderFlexionFromBottom editBoxWidth editBoxHeight ], shoulderFlexionString );
setappdata( structure.figureHandle, 'shoulderFlexion', shoulderFlexionString );

% Shoulder Abduction edit box
shoulderAbductionFromBottom = firstColumnFromBottom(11);
shoulderAbductionString = '85';
structure.shoulderAbductionEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft shoulderAbductionFromBottom editBoxWidth editBoxHeight ], shoulderAbductionString );
setappdata( structure.figureHandle, 'shoulderAbduction', shoulderAbductionString );

% Abduction Max torque edit box
abductionMaxFromBottom = firstColumnFromBottom(12);
abductionMaxString = '0';
structure.abductionMaxTorqueEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft abductionMaxFromBottom editBoxWidth editBoxHeight ], abductionMaxString );
setappdata( structure.figureHandle, 'abductionMax', abductionMaxString );

% Abduction Max force edit box
abductionMaxFromBottom = firstColumnFromBottom(13);
abductionMaxString = '0';
structure.abductionMaxForceEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft abductionMaxFromBottom editBoxWidth editBoxHeight ], abductionMaxString );
setappdata( structure.figureHandle, 'abductionMax', abductionMaxString );
set( structure.abductionMaxForceEditBox, 'Enable', 'on' );

% Limb Weight edit box
limbWeightFromBottom = firstColumnFromBottom(14);
limbWeightString = '0';
structure.limbWeightEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ editBoxFromLeft limbWeightFromBottom editBoxWidth editBoxHeight ], limbWeightString );
setappdata( structure.figureHandle, 'limbWeight', limbWeightString );
set( structure.limbWeightEditBox, 'Enable', 'off' );

%% Units that acompany edit boxes
% string in each text component
unitsString = { 'cm', 'cm', 'cm', 'cm', 'o', 'o', 'o', 'N-m', 'N', 'N' };
    
% initialize components
structure.units = zeros( 1, length(unitsString) );

% determine position of each text component (in characters)
unitsFromLeft = editBoxFromLeft + editBoxWidth + 0.01;
unitsFromBottom = 0.675 : -textSpacing : 0.675-textSpacing*9;%[ 0.829, , 33, 29.5, 26.5, 23, 18.75, 15, 11.75  ] + 4;
unitsWidth = 0.15;%[ 5.4, 5.4, 5.4, 5.4, 2.2, 2.2, 8, 2.6, 2.6 ];
unitsFromBottom(5:7) = unitsFromBottom(5:7) + 0.01;

for i = 1:length(unitsString)
    textPosition = [ unitsFromLeft unitsFromBottom(i) unitsWidth textHeight ];
    structure.units(i) = CreateTextComponent( structure.figureHandle,...
        textPosition, unitsString(i) );
end

%% Notes - text and edit box
% Notes text
notesTextString = 'Notes:';
notesTextFromBottom = 0.15;
notesTextWidth = 0.2;
notesTextPosition = [ firstColumnFromLeft notesTextFromBottom notesTextWidth textHeight ];
structure.notesText = CreateTextComponent( structure.figureHandle,...
    notesTextPosition, notesTextString );

% Notes edit box
notesEditBoxFromBottom = 0.0823;
notesEditBoxWidth = 0.864;
notesEditBoxHeight = 0.063;
notesString = '';
structure.notesEditBox = CreateEditBoxComponent( structure.figureHandle,...
    [ firstColumnFromLeft notesEditBoxFromBottom notesEditBoxWidth notesEditBoxHeight ], notesString );
setappdata( structure.figureHandle, 'notes', notesString );



%% Save to File, Save, and Cancel push buttons
% Save to File push button
saveToFilePushButtonFromLeft = firstColumnFromLeft;
saveToFilePushButtonFromBottom = 0.0188;
saveToFilePushButtonWidth = 0.35;
saveToFilePushButtonPosition = [ saveToFilePushButtonFromLeft, saveToFilePushButtonFromBottom,...
    saveToFilePushButtonWidth, pushButtonHeight ];

structure.saveToFilePushButton = CreatePushButtonComponent(...
    structure.figureHandle, saveToFilePushButtonPosition, 'Save to File');

% Ok push button
okPushButtonFromLeft = saveToFilePushButtonFromLeft + saveToFilePushButtonWidth + 0.1;
okPushButtonFromBottom = saveToFilePushButtonFromBottom;
okPushButtonWidth = 0.23;
okPushButtonPosition = [ okPushButtonFromLeft, okPushButtonFromBottom,...
    okPushButtonWidth, pushButtonHeight ];

structure.okPushButton = CreatePushButtonComponent(...
    structure.figureHandle, okPushButtonPosition, 'OK');

% Cancel push button
cancelPushButtonFromLeft = okPushButtonFromLeft + okPushButtonWidth + 0.005;
cancelPushButtonFromBottom = okPushButtonFromBottom;
cancelPushButtonWidth = okPushButtonWidth;
cancelPushButtonPosition = [ cancelPushButtonFromLeft, cancelPushButtonFromBottom,...
    cancelPushButtonWidth, pushButtonHeight ];

structure.cancelPushButton = CreatePushButtonComponent(...
    structure.figureHandle, cancelPushButtonPosition, 'Cancel');
set( structure.cancelPushButton, 'Enable','off');

end
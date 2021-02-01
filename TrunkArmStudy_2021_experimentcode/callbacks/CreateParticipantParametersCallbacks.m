function participantParameters = CreateParticipantParametersCallbacks(...
    initializeRobot, mainWindow, robot, display, addDisplay, participantParameters, timerObject )

set(participantParameters.loadFromFilePushButton,...
    'Callback',{@loadFromFilePushButton_Callback,mainWindow,participantParameters,initializeRobot, timerObject});

set(participantParameters.participantIdEditBox,...
    'Callback',{@participantIdEditBox_Callback,mainWindow});
set(participantParameters.ageEditBox,...
    'Callback',{@ageEditBox_Callback,mainWindow});
set(participantParameters.genderEditBox,...
    'Callback',{@genderEditBox_Callback,participantParameters});
set(participantParameters.act3dVersionEditBox,...
    'Callback',{@act3dVersionEditBox_Callback,mainWindow});
set(participantParameters.upperArmLengthEditBox,...
    'Callback',{@upperArmLengthEditBox_Callback,mainWindow});
set(participantParameters.lowerArmLengthEditBox,...
    'Callback',{@lowerArmLengthEditBox_Callback,mainWindow});
set(participantParameters.elbowToEndEffectorEditBox,...
    'Callback',{@elbowToEndEffectorEditBox_Callback,mainWindow});
set(participantParameters.handLengthEditBox,...
    'Callback',{@handLengthEditBox_Callback,mainWindow});
set(participantParameters.elbowFlexionEditBox,...
    'Callback',{@elbowFlexionEditBox_Callback,mainWindow});
set(participantParameters.shoulderFlexionEditBox,...
    'Callback',{@shoulderFlexionEditBox_Callback,mainWindow});
set(participantParameters.shoulderAbductionEditBox,...
    'Callback',{@shoulderAbductionEditBox_Callback,mainWindow});
set(participantParameters.abductionMaxTorqueEditBox,...
    'Callback',{@abductionMaxTorqueEditBox_Callback,mainWindow,participantParameters,display});
set(participantParameters.abductionMaxForceEditBox,...
    'Callback',{@abductionMaxForceEditBox_Callback,mainWindow});
set(participantParameters.limbWeightEditBox,...
    'Callback',{@limbWeightEditBox_Callback,mainWindow});

set(participantParameters.notesEditBox,...
    'Callback',{@notesEditBox_Callback,mainWindow});

set(participantParameters.saveToFilePushButton,...
    'Callback',{@saveToFilePushButton_Callback,mainWindow,participantParameters, initializeRobot});
set(participantParameters.okPushButton,...
    'Callback',{@okPushButton_Callback,mainWindow, participantParameters, display, robot, addDisplay});
set(participantParameters.cancelPushButton,...
    'Callback',{@cancelPushButton_Callback,mainWindow, participantParameters, display});

set( participantParameters.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please click Ok or Cancel') );

end

function loadFromFilePushButton_Callback(hObject, eventdata, mainWindow, participantParameters, initializeRobot, timerObject )

stop(timerObject);

% load data
[filename, pathname] = uigetfile('*.mat', 'Pick an M-file');
if filename == 0
    start(timerObject);
    return;
end
filepath = [pathname filename];
data = importdata(filepath);

% write data for each variable into the corresponding edit box
set( participantParameters.participantIdEditBox, 'String', data{1,2} );
set( participantParameters.ageEditBox, 'String',data{2,2} );
set( participantParameters.genderEditBox, 'String',data{3,2} );
set( participantParameters.act3dVersionEditBox, 'String',data{4,2} );
set( participantParameters.upperArmLengthEditBox, 'String',data{5,2} );
set( participantParameters.lowerArmLengthEditBox, 'String',data{6,2} );
set( participantParameters.elbowToEndEffectorEditBox, 'String',data{7,2} );
set( participantParameters.handLengthEditBox, 'String',data{8,2} );
set( participantParameters.elbowFlexionEditBox, 'String',data{9,2} );
set( participantParameters.shoulderFlexionEditBox, 'String',data{10,2} );
set( participantParameters.shoulderAbductionEditBox, 'String',data{11,2} );
set( participantParameters.abductionMaxTorqueEditBox, 'String',data{12,2} );
set( participantParameters.abductionMaxForceEditBox, 'String',data{13,2} );
set( participantParameters.limbWeightEditBox, 'String', data{14,2} );
set( participantParameters.notesEditBox, 'String', data{15,2} );
if strcmp( data{16,2}, 'Right' )
    set( initializeRobot.armButtonGroup, 'SelectedObject', initializeRobot.rightRadioButton);
else
    set( initializeRobot.armButtonGroup, 'SelectedObject', initializeRobot.leftRadioButton);
end

% don't allow a new abduction max force to be computed when one is loaded
% from a file
% set( initializeRobot.computeAbdMaxForcePushButton, 'Enable','Off' );

start(timerObject);

disp('Participant parameters loaded from .mat file');

end


% do we need callbacks for the edit boxes?
function participantIdEditBox_Callback(hObject, eventdata, mainWindow )
end

function ageEditBox_Callback(hObject, eventdata, mainWindow )
end

function genderEditBox_Callback(hObject, eventdata, mainWindow )
end

function act3dVersionEditBox_Callback(hObject, eventdata, mainWindow )
end

function upperArmLengthEditBox_Callback(hObject, eventdata, mainWindow )
end

function lowerArmLengthEditBox_Callback(hObject, eventdata, mainWindow )
end

function elbowToEndEffectorEditBox_Callback(hObject, eventdata, mainWindow )
end

function handLengthEditBox_Callback(hObject, eventdata, mainWindow )
end

function elbowFlexionEditBox_Callback(hObject, eventdata, mainWindow )
end

function shoulderFlexionEditBox_Callback(hObject, eventdata, mainWindow )
end

function shoulderAbductionEditBox_Callback(hObject, eventdata, mainWindow )
end

function abductionMaxTorqueEditBox_Callback(hObject, eventdata, mainWindow, participantParameters, display )
torque = str2double( get( hObject, 'String') );

force = round( torque / display.shoulderToEndEffector );

% set the abduction max force value based on this value
set( participantParameters.abductionMaxForceEditBox, 'String', num2str(force,'%3.2f') );

end


function abductionMaxForceEditBox_Callback(hObject, eventdata, mainWindow )
disp('Abduction Max Force updated')
end

function limbWeightEditBox_Callback(hObject, eventdata, mainWindow )
end

function notesEditBox_Callback(hObject, eventdata, mainWindow )
end


function saveToFilePushButton_Callback(hObject, eventdata, mainWindow, participantParameters, initializeRobot )
% get all data in edit boxes
participantId = get(participantParameters.participantIdEditBox,'String' );
age = get( participantParameters.ageEditBox, 'String' );
gender = get( participantParameters.genderEditBox,'String' );
act3dVersion = get( participantParameters.act3dVersionEditBox, 'String' );
upperArmLength = get( participantParameters.upperArmLengthEditBox, 'String' );
lowerArmLength = get( participantParameters.lowerArmLengthEditBox, 'String' );
elbowToEndEffector = get( participantParameters.elbowToEndEffectorEditBox, 'String' );
handLength = get( participantParameters.handLengthEditBox, 'String' );
elbowFlexion = get( participantParameters.elbowFlexionEditBox, 'String' );
shoulderFlexion = get( participantParameters.shoulderFlexionEditBox, 'String' );
shoulderAbduction = get( participantParameters.shoulderAbductionEditBox, 'String' );
abductionMaxTorque = get( participantParameters.abductionMaxTorqueEditBox,'String' );
abductionMaxForce = get( participantParameters.abductionMaxForceEditBox,'String' );
limbWeight = get( participantParameters.limbWeightEditBox, 'String' );
notes = get( participantParameters.notesEditBox, 'String' );
armObject = get( initializeRobot.armButtonGroup, 'SelectedObject' );
arm = get( armObject, 'String' );

% save all data in the edit boxes to a file
filename = ['participantID_' participantId '.mat'];
folder = get(mainWindow.statusPanel.secondColumn(11), 'String' );
data = { 'participantId',participantId; 'age',age; 'gender',gender;...
    'act3dVersion',act3dVersion; 'upperArmLength',upperArmLength;
    'lowerArmLength',lowerArmLength; 'elbowToEndEffector',elbowToEndEffector;...
    'handLength',handLength; 'elbowFlexion',elbowFlexion;...
    'shoulderFlexion',shoulderFlexion; 'shoulderAbduction',shoulderAbduction;...
    'abductionMaxTorque',abductionMaxTorque;...
    'abductionMaxForce',abductionMaxForce; 'limbWeight',limbWeight;...
    'notes',notes; 'arm',arm };
        
filepath = [char(folder) '\' filename];
save(filepath,'data');

disp('Participant parameters saved to .mat file');

end

function okPushButton_Callback(hObject, eventdata, mainWindow, participantParameters, display, robot, addDisplay )

disp('entered the okpushbutton_callback line 193 in createParticipantParametersCallbacks.m');
% save all data in the edit boxes as data for the program
participantId = get(participantParameters.participantIdEditBox,'String' );
setappdata( participantParameters.figureHandle, 'participantId', participantId  );

age = get( participantParameters.ageEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'age', age  );

gender = get( participantParameters.genderEditBox,'String' );
setappdata( participantParameters.figureHandle, 'gender', gender  );

act3dVersion = get( participantParameters.act3dVersionEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'act3dVersion', act3dVersion  );

upperArmLength = get( participantParameters.upperArmLengthEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'upperArmLength', upperArmLength  );
display.upperArmLength = str2double( upperArmLength ) / 100;

lowerArmLength = get( participantParameters.lowerArmLengthEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'lowerArmLength', lowerArmLength  );
display.lowerArmLength = str2double(lowerArmLength ) / 100;

elbowToEndEffector = get( participantParameters.elbowToEndEffectorEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'elbowToEndEffector', elbowToEndEffector  );
display.elbowToEndEffector = str2double( elbowToEndEffector ) / 100;

handLength = get( participantParameters.handLengthEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'handLength', handLength  );
display.handLength = str2double( handLength ) / 100;

elbowFlexion = get( participantParameters.elbowFlexionEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'elbowFlexion', elbowFlexion  );

shoulderFlexion = get( participantParameters.shoulderFlexionEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'shoulderFlexion', shoulderFlexion  );

shoulderAbduction = get( participantParameters.shoulderAbductionEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'shoulderAbduction', shoulderAbduction  );

abductionMaxTorque = get( participantParameters.abductionMaxTorqueEditBox,'String' );
setappdata( participantParameters.figureHandle, 'abductionMaxTorque', abductionMaxTorque  );

abductionMaxForce = get( participantParameters.abductionMaxForceEditBox,'String' );
setappdata( participantParameters.figureHandle, 'abductionMaxTorque', abductionMaxForce  );

limbWeight = get( participantParameters.limbWeightEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'limbWeight', limbWeight  );

notes = get( participantParameters.notesEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'notes', notes  );

% make this window invisible
set( participantParameters.figureHandle, 'Visible','Off', 'WindowStyle','normal' );

elbowToEndEffector = get( participantParameters.elbowToEndEffectorEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'elbowToEndEffector', elbowToEndEffector  );
display.elbowToEndEffector = str2double( elbowToEndEffector ) / 100;

handLength = get( participantParameters.handLengthEditBox, 'String' );
setappdata( participantParameters.figureHandle, 'handLength', handLength  );
display.handLength = str2double( handLength ) / 100;

%Added for Kacey's additional display 5.1.19

% display.shoulderPosition(1);
% display.shoulderPosition(2);

%SA, AM 10.8.19 commenting out changes to addDisplay and moving it to the
%locateShoulder button callback 
% chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
% 
% totalArmLength = (display.upperArmLength + display.lowerArmLength + display.handLength);
% setappdata(addDisplay.figureHandle,'shoulderXVal',display.shoulderPosition(1));
% setappdata(addDisplay.figureHandle,'shoulderYVal',display.shoulderPosition(2));
% setappdata(addDisplay.figureHandle,'totalArmLength',totalArmLength);
% 
% xval_pos = robot.endEffectorPosition(1);
% yval_pos = robot.endEffectorPosition(2);
% 
% armlength = totalArmLength;
% xval_HP = display.home.position(chairPosition,1); %Converting to cm
% yval_HP = display.home.position(chairPosition,2);
% %     addDisplay.figureHandle,'shoulderXVal',display.shoulderPosition(1));
%     %Sabeen added for Kacey's additional display circle for lift
% % circleLift = getappdata(addDisplay.figureHandle,'newCircle');
% 
% % %     getappdata(addDisplay.figureHandle,'newCircle')
% 
% 
% display.home.position(chairPosition,1);
% % xval_new = (xval_pos-xval_SP)/armlength;
% 
% % xval_new = xval_pos/armlength;
% arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
% if strcmp(arm,'Right')
% 
%     
% %AM editing 9.25.19 changing - to +
%     xval_HPnorm = (xval_HP-display.shoulderPosition(1))/armlength;
%     yval_HPnorm = (yval_HP-display.shoulderPosition(2))/armlength;
% %end of AM edit
% 
% else
%     %AM editing 9.25.19 changing + to -
%     xval_HPnorm = -(xval_HP-display.shoulderPosition(1))/armlength;
%     yval_HPnorm = -(yval_HP-display.shoulderPosition(2))/armlength;
% % end of AM edit 
% % 
% % if strcmp(arm,'Right')
% %     %AM editing 10.7.19 
% %     val_HPnorm = (val_HP-display.shoulderPosition(1:2));
% % %end of AM edit
% % else
% %     %AM editing 9.25.19 changing + to -
% %     val_HPnorm = -(xval_HP-display.shoulderPosition(1));
% %     yval_HPnorm = -(yval_HP-display.shoulderPosition(2));
% % % end of AM edit 
% 
% 
% 
% %     yval_HPnorm = yval_HP;                                                                                                                                                                                    al_HPnorm = (yval_HP);
% end
% r = 0.15;
% disp('entered the okpushbutton_callback line 309 in createParticipantParametersCallbacks.m');
% % silly = get(addDisplay.homeCircle)
% 
% %% // 15.7.19 AM TO-DO: Need to work on the issue of homeRect being created twice: homeRect can show up here, on Save Participant Parameters button click, and not in the beginning
% %% //Remove homeRect visibility from CreateAddDisplayComponents.m file so that it is only created here
% 
% % set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1-r yval_HPnorm-0.1 2*r 2*r]); %green = [0 1 0.5]; red = [1 0 0.5] %we want to normalize our home position to our arm length
% % set(addDisplay.homeCircle,'Visible','on'); %green = [0 1 0.5]; red = [1 0 0.5]
% % set(addDisplay.homeCircle,'EdgeColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% % set(addDisplay.homeCircle,'FaceColor','none');
% 
% %//AM editing for Kacey to make sure that the homeCircle position changes
% %//according to the position it is set to 9.24.19
% %//set(addDisplay.homeCircle,'Position',[r .25 2*r 2*r]); %green = [0 1 0.5]; red = [1 0 0.5] %we want to normalize our home position to our arm length
% %//set(addDisplay.homeCircle,'Position',[-1 -1 2*r 2*r]);
% %//set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1 yval_HPnorm-0.1 2*r 2*r]); 
% % KCS and AM Editing 9.26.19 
% %set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1 -(yval_HPnorm-0.1) 2*r 2*r]);
% %set(addDisplay.homeCircle,'Position',[xval_HPnorm -(yval_HPnorm) 2*r 2*r]);
% %set(addDisplay.homeCircle,'Position',[xval_HPnorm+0.1 -(yval_HPnorm+0.1) 2*r 2*r]);
% 
% 
% %AM 10.7.19 adding display statements to debug 
% disp('entered the okpushbutton_callback line 336 in createParticipantParametersCallbacks.m');
% xval_HPnorm
% yval_HPnorm
% 
% %AM 10.7.19 to-do: comment out this line so that the visual gets updated in
% %the locate shoulder push button callback and not in this callback
% set(addDisplay.homeCircle,'Position',[xval_HPnorm -(yval_HPnorm) 2*r 2*r]);
% %THE LINE ABOVE WORKS 10.03 KCS AND AM
% 
% set(addDisplay.homeCircle,'Visible','on'); %green = [0 1 0.5]; red = [1 0 0.5]
% % set(addDisplay.homeCircle,'EdgeColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% 
% %//A.M TO-DO: Change opacity of blue so that crosshair is still visible inside the blue circle because it is currently not seen 
% set(addDisplay.homeCircle,'FaceColor','b');

%end of SA, AM 10.8.19 edit

%// A.M TO-DO: display text along with homeCircle 
%// A.M edit: displaying the text 'HOME'
% str = 'HOME';
% addDisplay.homeCircle.UserData.str = str;
% addDisplay.homeCircle.UserData.t = text(0+r+(6.5*r)/2,0.25+(2*r)/2, homeRect.UserData.str, 'HorizontalAlignment','center', 'Color','white','FontSize',16,'Visible','off')



%%//

% addDisplay.homeCircle = homeRect;
% set(addDisplay.homeRect,'Position',[xval_HPnorm-r yval_HPnorm 2*r 2*r],'Curvature',[1 1],'FaceColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% addDisplay.homeCircle = homeRect;

% set(addDisplay.homeCircle,'Position',[xval_HPnorm-r yval_HPnorm 2*r 2*r]);
% homeRect = rectangle('Position',[0-r 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% structure.homeCircle = homeRect;

% addDisplay.shoulderXVal = display.shoulderPosition(1); %Converting to cm
% addDisplay.shoulderYVal = display.shoulderPosition(2);
% addDisplay.totalArmLength = totalArmLength;
% 
% addDisplay.x = Circle(2,[shoulderXVal,shoulderYVal+totalArmLength]); %Want total arm length to be in mm so multiply result by 1000
% set(addDisplay.hline3,'Xdata',addDisplay.x(:,1),'Ydata',addDisplay.x(:,2),'Color','g','LineWidth',2);
% 
% matchX = -(-35+shoulderXVal) + (35+shoulderXVal) - shoulderYVal;
% 
% set(addDisplay.cone1,'Xdata',[-25+shoulderXVal -35+shoulderXVal],'Ydata',[shoulderYVal,shoulderYVal+totalArmLength+5],'LineWidth',1.5, 'Color','b');
% set(addDisplay.cone2,'Xdata',[25+shoulderXVal 35+shoulderXVal],'Ydata',[shoulderYVal,shoulderYVal+totalArmLength+5],'LineWidth',1.5, 'Color','g');
% set(addDisplay.baseLine,'Xdata',[-25+shoulderXVal 25+shoulderXVal],'Ydata',[shoulderYVal,shoulderYVal],'LineWidth',1.5, 'Color',[1 0 0]);

end

function cancelPushButton_Callback(hObject, eventdata, mainWindow, participantParameters, display )

% revert values in edit text boxes to previous values
participantId = getappdata( participantParameters.figureHandle, 'participantId' );
set( participantParameters.participantIdEditBox, 'String', participantId );

age = getappdata( participantParameters.figureHandle, 'age' );
set( participantParameters.ageEditBox, 'String',age );

gender = getappdata( participantParameters.figureHandle, 'gender' );
set( participantParameters.genderEditBox, 'String',gender );

act3dVersion = getappdata( participantParameters.figureHandle, 'act3dVersion' );
set( participantParameters.act3dVersionEditBox, 'String',act3dVersion );

upperArmLength = getappdata( participantParameters.figureHandle, 'upperArmLength' );
set( participantParameters.upperArmLengthEditBox, 'String',upperArmLength );

lowerArmLength = getappdata( participantParameters.figureHandle, 'lowerArmLength' );
set( participantParameters.lowerArmLengthEditBox, 'String',lowerArmLength );

elbowToEndEffector = getappdata( participantParameters.figureHandle, 'elbowToEndEffector' );
set( participantParameters.elbowToEndEffectorEditBox, 'String',elbowToEndEffector );

handLength = getappdata( participantParameters.figureHandle, 'handLength' );
set( participantParameters.handLengthEditBox, 'String',handLength );

elbowFlexion = getappdata( participantParameters.figureHandle, 'elbowFlexion' );
set( participantParameters.elbowFlexionEditBox, 'String',elbowFlexion );

shoulderFlexion = getappdata( participantParameters.figureHandle, 'shoulderFlexion' );
set( participantParameters.shoulderFlexionEditBox, 'String',shoulderFlexion );

shoulderAbduction = getappdata( participantParameters.figureHandle, 'shoulderAbduction' );
set( participantParameters.shoulderAbductionEditBox, 'String',shoulderAbduction );

abductionMaxTorque = getappdata( participantParameters.figureHandle, 'abductionMaxTorque' );
set( participantParameters.abductionMaxTorqueEditBox, 'String',abductionMaxTorque );

abductionMaxForce = getappdata( participantParameters.figureHandle, 'abductionMaxForce' );
set( participantParameters.abductionMaxForceEditBox, 'String',abductionMaxForce );

limbWeight = getappdata( participantParameters.figureHandle, 'limbWeight' );
set( participantParameters.limbWeightEditBox, 'String', limbWeight );

notes = getappdata( participantParameters.figureHandle, 'notes' );
set( participantParameters.notesEditBox, 'String', notes );

% make this window invisible
set( participantParameters.figureHandle, 'Visible','Off', 'WindowStyle','normal' );

end

% function [ initializeRobot, mainWindow ] = CreateInitializeRobotCallbacks(...
%     initializeRobot, mainWindow, robot, haptic, display, participantParameters,...
% 	setTargets, timerObject, experiment, judp )

%SA, AM 10.8.19 editing function to include addDisplay
function [ initializeRobot, mainWindow ] = CreateInitializeRobotCallbacks(...
    initializeRobot, mainWindow, robot, haptic, display, addDisplay, participantParameters,...
	setTargets, timerObject, experiment, judp )


set(initializeRobot.inertiaEditBox,...
    'Callback',{@inertiaEditBox_Callback,mainWindow, robot});

set(initializeRobot.rightRadioButton,...
    'Callback',{@rightRadioButton_Callback,mainWindow,robot,initializeRobot,display, haptic, judp, timerObject});
set(initializeRobot.leftRadioButton,...
    'Callback',{@leftRadioButton_Callback,mainWindow,robot,initializeRobot,display, haptic, judp, timerObject});

set(initializeRobot.printRotationPushButton,...
    'Callback',{@printRotationPushButton_Callback,robot});

set(initializeRobot.browsePushButton,...
    'Callback',{@browsePushButton_Callback,mainWindow,initializeRobot});
set(initializeRobot.filenameEditBox,...
    'Callback',{@filenameEditBox_Callback,mainWindow});
set(initializeRobot.frequencyPopUpMenu,...
    'Callback',{@frequencyPopUpMenu_Callback,mainWindow,robot});

set(initializeRobot.participantParametersPushButton,...
    'Callback',{@participantParametersPushButton_Callback,mainWindow,robot,participantParameters,timerObject});
set(initializeRobot.loadPositionsPushButton,...
    'Callback',{@loadPositionsPushButton_Callback,timerObject,mainWindow,robot,display,initializeRobot,...
    participantParameters,setTargets,haptic,experiment,judp});

% set(initializeRobot.locateShoulderPushButton,...
%     'Callback',{@locateShoulderPushButton_Callback,mainWindow,robot,display,initializeRobot,participantParameters,setTargets,...
%     haptic,timerObject,experiment, judp});

%SA, AM 10.8.19 editing function to include addDisplay
set(initializeRobot.locateShoulderPushButton,...
    'Callback',{@locateShoulderPushButton_Callback,mainWindow,robot,display,addDisplay,initializeRobot,participantParameters,setTargets,...
    haptic,timerObject,experiment, judp});

set(initializeRobot.oneRadioButton,...
    'Callback',{@chairPositionRadioButton_Callback,mainWindow,initializeRobot,display,setTargets,judp,timerObject});
set(initializeRobot.twoRadioButton,...
    'Callback',{@chairPositionRadioButton_Callback,mainWindow,initializeRobot,display,setTargets,judp,timerObject});

set(initializeRobot.computeAbdMaxForcePushButton,...
    'Callback',{@computeAbdMaxForcePushButton_Callback,mainWindow,display, robot, participantParameters});
set(initializeRobot.weighArmPushButton,...
    'Callback',{@weighArmPushButton_Callback,mainWindow,robot,initializeRobot,participantParameters});
set(initializeRobot.savePPToFilePushButton,...
    'Callback',{@savePPToFilePushButton_Callback,mainWindow, participantParameters, initializeRobot});

set(initializeRobot.okPushButton,...
    'Callback',{@okPushButton_Callback,mainWindow,robot,initializeRobot});
set(initializeRobot.cancelPushButton,...
    'Callback',{@cancelPushButton_Callback,mainWindow,robot,initializeRobot});

set( initializeRobot.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please click OK or Cancel') );

end

function inertiaEditBox_Callback(hObject, eventdata, mainWindow, robot )

inertiaValue = str2double ( get( hObject, 'String' ) );
if inertiaValue > 16 || inertiaValue < 4
    disp('Inertia should be no more than 16 and no less than 4 kg*m^2');
    return;
end
robot.SetInertia( inertiaValue );
%set( mainWindow.statusPanel.secondColumn(8), 'String',
%num2str(robot.SetInertia) );   %needed?

end

%% try just using a callback for the hapticgroup
function rightRadioButton_Callback(hObject, eventdata, mainWindow, robot, initializeRobot, display, haptic, judp, timerObject)
newArm = 'Right';

disp('Please wait. Opening right arm render...');

SwitchArm( mainWindow, newArm, initializeRobot, hObject, timerObject, display, judp, haptic );

% set position of vertical effect
haptic.verticalPosition = [0, 0.04, 0];
if haptic.isVerticalCreated == 1
    haptic.SetPosition(haptic.verticalPosition,haptic.verticalName);
end

end

function leftRadioButton_Callback(hObject, eventdata, mainWindow, robot, initializeRobot, display, haptic, judp, timerObject)
newArm = 'Left';

disp('Please wait.  Opening left arm render...');

SwitchArm( mainWindow, newArm, initializeRobot, hObject, timerObject, display, judp, haptic );

% set position of vertical effect
haptic.verticalPosition = [0, -0.04, 0];
if haptic.isVerticalCreated == 1
    haptic.SetPosition(haptic.verticalPosition,haptic.verticalName);
end

end


function SwitchArm( mainWindow, newArm, initializeRobot, hObject, timerObject, display, judp, haptic )

% get old arm
oldArm = get( mainWindow.statusPanel.secondColumn(6), 'String' );

% Inverse kinematics function in visualfeedback class is computed  
% differently according to the arm used
set( mainWindow.statusPanel.secondColumn(6), 'String', newArm);
set(initializeRobot.armButtonGroup,'SelectedObject',hObject);

%view( display.axesHandle, 180, 30 );
% close thread/blender and open a new thread/blender showing the right arm
stop( timerObject );

% disable mouse clicking

display.CloseDisplay(oldArm, judp);

display.StartBlender(newArm, judp);

% enable mouse clicking

start( timerObject );

disp([newArm ' arm loaded']);

% change visiblity of the haptic table in the display 
if haptic.isHorizontalEnabled
    judp.Write('table visible on');
else
    judp.Write('table visible off');
end

end


function printRotationPushButton_Callback(hObject, eventdata, robot )
% The user should point the orthosis towards the new robot.  The value printed should read 0 degrees.
disp('Please have the orthosis pointed directly away from the robot chassis');
angle = robot.endEffectorRotation * 180/pi;
disp(['The current angle of the orthosis is ' num2str(angle) ' degrees']);
end



%%
function browsePushButton_Callback(hObject, eventdata, mainWindow, initializeRobot )
folderName = uigetdir(pwd);
if folderName ~= 0
    set(initializeRobot.filenameEditBox,'String',folderName);
    set( mainWindow.statusPanel.secondColumn(11), 'String',folderName );
end
end

function frequencyPopUpMenu_Callback(hObject, eventdata, mainWindow, robot)
% --- NOT YET IMPLEMENTED - CURRENTLY DISABLED ---
% may create two timers. one for graphics (~50-60 hz). other timer for getting data from robot. 
% this popup would change the frequency getting data from the robot.
end


function participantParametersPushButton_Callback(hObject, eventdata, mainWindow, robot, participantParameters, timerObject )

stop(timerObject);

% make participant parameters window visible and switch to modal to not allow other windows to be clicked
set( participantParameters.figureHandle, 'Visible','On');%, 'WindowStyle','modal' );

start(timerObject);

end


function loadPositionsPushButton_Callback(hObject, eventdata, timerObject, mainWindow, robot, display, initializeRobot, participantParameters, setTargets, haptic, experiment, judp )

stop(timerObject);

% load ()_target.mat file
[filename, pathname] = uigetfile('*.mat', 'Pick a mat-file');
if filename == 0
    start(timerObject);
    return;
end
positionsData = importdata( [pathname '\' filename] ); 

% get chair position from file name
chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );

% put the home, target, and shoulder position in the display class variables
display.home.position(chairPosition,1) = positionsData{2,1};
display.home.position(chairPosition,2) = positionsData{3,1};
display.home.position(chairPosition,3) = positionsData{4,1};

display.home.positionAngles(chairPosition,1) = positionsData{2,2};
display.home.positionAngles(chairPosition,2) = positionsData{3,2};
display.home.positionAngles(chairPosition,3) = positionsData{4,2};

display.target.position(chairPosition,1) = positionsData{2,3};
display.target.position(chairPosition,2) = positionsData{3,3};
display.target.position(chairPosition,3) = positionsData{4,3};

display.target.positionAngles(chairPosition,1) = positionsData{2,4};
display.target.positionAngles(chairPosition,2) = positionsData{3,4};
display.target.positionAngles(chairPosition,3) = positionsData{4,4};

display.shoulderPosition(chairPosition,1) = positionsData{2,5};
display.shoulderPosition(chairPosition,2) = positionsData{3,5};
display.shoulderPosition(chairPosition,3) = positionsData{4,5};

%{
[ x,y,z ] = display.ComputeSphere( display.radius, display.home.position(chairPosition,:) );
set( display.homeSphereHandle, 'XData',x, 'YData',y, 'ZData',z );
%}
blenderAngles = display.home.positionAngles(chairPosition,:) * 180/pi;
judp.Write( [ 'home position ',...
    num2str(blenderAngles(1)), ' ',...
    num2str(blenderAngles(2)), ' ',...
    num2str(blenderAngles(3)) ] );

%{
[ x,y,z ] = display.ComputeSphere( display.radius, display.target.position(chairPosition,:) );
set( display.targetSphereHandle, 'XData',x, 'YData',y, 'ZData',z );
%}
blenderAngles = display.target.positionAngles(chairPosition,:) * 180/pi;
judp.Write( [ 'target position ',...
    num2str(blenderAngles(1)), ' ',...
    num2str(blenderAngles(2)), ' ',...
    num2str(blenderAngles(3)) ] );


fprintf('home, target, and shoulder positions are loaded\n');

start(timerObject);

end

% 
% function locateShoulderPushButton_Callback(hObject, eventdata, mainWindow,...
%     robot, display, initializeRobot, participantParameters, setTargets,...
%     haptic, timerObject, experiment, judp )
%SA, AM 10.8.19 editing locateShoulder function to accept addDisplay as an argument
function locateShoulderPushButton_Callback(hObject, eventdata, mainWindow,...
    robot, display, addDisplay, initializeRobot, participantParameters, setTargets,...
    haptic, timerObject, experiment, judp )

stop(timerObject);

% switch the robot to a fixed state to keep the participant's arm still
robot.SwitchState('fixed');
set(mainWindow.trialConditionsPanel.statePopUpMenu,'String',{'fixed','normal','off'});
set(mainWindow.trialConditionsPanel.statePopUpMenu,'Value',1);

%this is a bug fix. prevents table from dropping out when robot is switched
%from fixed to normal
%haptic.isHorizontalEnabled = haptic.Disable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
%haptic.isHorizontalEnabled = haptic.Enable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );

% re enable horizontal block, vertical block, bias force, spring, damper
if haptic.isHorizontalEnabled == 1
    haptic.isHorizontalEnabled = 0;
    haptic.isHorizontalEnabled = haptic.Enable( haptic.isHorizontalCreated, haptic.isHorizontalEnabled, haptic.horizontalName );
end
if haptic.isVerticalEnabled == 1
    haptic.isVerticalEnabled = 0;
    haptic.isVerticalEnabled = haptic.Enable( haptic.isVerticalCreated, haptic.isVerticalEnabled, haptic.verticalName );
end

%robot.EnableBiasForce;
%robot.EnableSpring;
% if robot.isDamperEnabled == 1
%     robot.EnableDamper;
% end

% get current end or position, arm selected, chair position, 
% and elbow flexion angle for computing the location of the shoulder

shoulderFlexionAngle = get( participantParameters.shoulderFlexionEditBox, 'String' );
shoulderFlexionAngle = str2double(shoulderFlexionAngle) * pi/180;

shoulderAbductionAngle = get( participantParameters.shoulderAbductionEditBox, 'String' );
shoulderAbductionAngle = str2double(shoulderAbductionAngle) * pi/180;
%shoulderAbductionAngle = shoulderAbductionAngle - pi/2;

arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end
robot.SetForceGetInfo(arm);

chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );

% change position of haptic table to later change the angle around this
% position
haptic.horizontalPosition(1:2) = robot.endEffectorPosition(1:2);

%display.ComputeShoulderAbductionAngle(robot.endEffectorPosition,chairPosition);
display.ComputeFingerTipPosition( robot.endEffectorPosition, robot.endEffectorRotation, arm );

chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
display.ComputeShoulderPosition( robot.endEffectorPosition, robot.endEffectorRotation(1), shoulderFlexionAngle, shoulderAbductionAngle, arm, chairPosition );

% temp
%[ x,y,z ] = display.ComputeSphere( display.radius, display.shoulderPosition(chairPosition,:) );
%set( display.shoulderPositionHandle, 'XData',x, 'YData',y, 'ZData',z );

% set the position of the home sphere at the tip of the hand
display.SetHomePosition( robot.endEffectorPosition, robot.endEffectorRotation(1), arm, judp, chairPosition );
% 10.8.19: SA and AM adding in the addDisplay edits here so that display
% properties are the same as Blender

chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );

UAL = str2double(getappdata(participantParameters.figureHandle,'upperArmLength'));
% disp('UAL: ');
% disp(UAL);
LAL = str2double(getappdata(participantParameters.figureHandle,'lowerArmLength'));
% disp('LAL: ');
% disp(LAL);
HL = str2double(getappdata(participantParameters.figureHandle,'handLength'));
% disp('HL: ');
% disp(HL);

totalArmLength = (UAL + LAL + HL);
% setappdata(addDisplay.figureHandle,'shoulderXVal',display.shoulderPosition(1));
% setappdata(addDisplay.figureHandle,'shoulderYVal',display.shoulderPosition(2));
% setappdata(addDisplay.figureHandle,'totalArmLength',totalArmLength);

armlength = totalArmLength;

% COORDINATE TRANSFORMATION RIGHT ARM - FIX
% xval_HP = -display.home.position(chairPosition,1)+(display.shoulderPosition(1)+0.2); %Converting to cm
% yval_HP = -display.home.position(chairPosition,2)+display.shoulderPosition(2);

% COORDINATE TRANSFORMATION LEFT ARM
xval_HP = display.home.position(chairPosition,1) - (display.shoulderPosition(chairPosition,1)+0.15);
yval_HP = display.home.position(chairPosition,2) - display.shoulderPosition(chairPosition,2);

% xval_HP = robot.endEffectorPosition(1)
% yval_HP = robot.endEffectorPosition(2)

setappdata(addDisplay.figureHandle,'shoulderXVal',xval_HP);
setappdata(addDisplay.figureHandle,'shoulderYVal',yval_HP);
setappdata(addDisplay.figureHandle,'totalArmLength',totalArmLength);

r=0.06;
set(addDisplay.homeCircle,'Position',[xval_HP-r yval_HP-r 2*r 2*r],'Visible','on'); %,'EdgeColor','b', 'LineWidth',2);

set(addDisplay.newCircle,'Position',[xval_HP-r 0.65-r 2*r 2*r])

% disp('In createParticipantParametersCallbacks.m');
% disp(['end effector= ',num2str(robot.endEffectorPosition(1:2))]);
% disp(['shoulder= ',num2str(display.shoulderPosition(chairPosition,1:2))]);
% disp(['home=' num2str([xval_HP yval_HP])]);
% disp(['finger tip= ',num2str(display.fingerTipPosition(1:2))]);


%     addDisplay.figureHandle,'shoulderXVal',display.shoulderPosition(1));
    %Sabeen added for Kacey's additional display circle for lift
% circleLift = getappdata(addDisplay.figureHandle,'newCircle');

% %     getappdata(addDisplay.figureHandle,'newCircle')


% display.home.position(chairPosition,1);
% xval_new = (xval_pos-xval_SP)/armlength;

% xval_new = xval_pos/armlength;
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
% if strcmp(arm,'Right')
% 
%    %SA,AM editing 10.8.19 changing + to - for both
%     
% %     xval_HPnorm = -(xval_HP-display.shoulderPosition(1))/armlength;
% %     yval_HPnorm = -(yval_HP-display.shoulderPosition(2))/armlength;
% % % % SA, AM, last edit 10.8.19
% % % %     yval_HPnorm = ((-(yval_HP+display.shoulderPosition(2)))/armlength)*100;
% % % % %     xval_HPnorm = -(xval_HP-display.shoulderPosition(1));
% % % %     xval_HPnorm = ((-(xval_HP))/armlength)*100;
% %     xval_HPnorm = xval_HP;
% %     yval_HPnorm = yval_HP;
% %     display.shoulderPosition(1)
% %     xval_HPnorm = (xval_HP+display.shoulderPosition(1));
% %     yval_HPnorm = (yval_HP-display.shoulderPosition(2))
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
% r = 0.05;
% disp('entered the okpushbutton_callback line 309 in createParticipantParametersCallbacks.m');
% silly = get(addDisplay.homeCircle)

%% // 15.7.19 AM TO-DO: Need to work on the issue of homeRect being created twice: homeRect can show up here, on Save Participant Parameters button click, and not in the beginning
%% //Remove homeRect visibility from CreateAddDisplayComponents.m file so that it is only created here

% set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1-r yval_HPnorm-0.1 2*r 2*r]); %green = [0 1 0.5]; red = [1 0 0.5] %we want to normalize our home position to our arm length
% set(addDisplay.homeCircle,'Visible','on'); %green = [0 1 0.5]; red = [1 0 0.5]
% set(addDisplay.homeCircle,'EdgeColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% set(addDisplay.homeCircle,'FaceColor','none');

%//AM editing for Kacey to make sure that the homeCircle position changes
%//according to the position it is set to 9.24.19
%//set(addDisplay.homeCircle,'Position',[r .25 2*r 2*r]); %green = [0 1 0.5]; red = [1 0 0.5] %we want to normalize our home position to our arm length
%//set(addDisplay.homeCircle,'Position',[-1 -1 2*r 2*r]);
%//set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1 yval_HPnorm-0.1 2*r 2*r]); 
% KCS and AM Editing 9.26.19 
%set(addDisplay.homeCircle,'Position',[xval_HPnorm-0.1 -(yval_HPnorm-0.1) 2*r 2*r]);
%set(addDisplay.homeCircle,'Position',[xval_HPnorm -(yval_HPnorm) 2*r 2*r]);
%set(addDisplay.homeCircle,'Position',[xval_HPnorm+0.1 -(yval_HPnorm+0.1) 2*r 2*r]);


%AM 10.7.19 adding display statements to debug 

%AM 10.7.19 to-do: comment out this line so that the visual gets updated in
%the locate shoulder push button callback and not in this callback
%set(addDisplay.homeCircle,'Position',[-(xval_HPnorm)-2*r (-(yval_HPnorm))-r 2*r 2*r]);
% set(addDisplay.homeCircle,'Position',[-(xval_HPnorm+r) (-(yval_HPnorm)) 2*r 2*r]);
%set(addDisplay.newCircle.UserData.t,'Visible','off');
% set(addDisplay.homeCircle,'Position',[1 -(yval_HPnorm) 2*r 2*r]);
%THE LINE ABOVE WORKS 10.03 KCS AND AM
% xval_HP is already in display coordinate system
% set(addDisplay.homeCircle,'Position',[xval_HP+r yval_HP+r 2*r 2*r]);
% 
% set(addDisplay.homeCircle,'Visible','on'); %green = [0 1 0.5]; red = [1 0 0.5]
% % set(addDisplay.homeCircle,'EdgeColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% 
% %//A.M TO-DO: Change opacity of blue so that crosshair is still visible inside the blue circle because it is currently not seen 
% set(addDisplay.homeCircle,'FaceColor', 'none', 'EdgeColor','b', 'LineWidth',2);
%AM edit 10.8.19 adding opacity 
%set(addDisplay.homeCircle,'FaceAlpha',0.5);
% set(addDisplay.newCircle, 'Position',[xval_HP+r 0.65+r 2*r 2*r]); %green = [0 1 0.5]; red = [1 0 0.5]

%set(addDisplay.shoulderRect,'Position',[0.2 0 r r],'FaceColor', 'none','EdgeColor', 'r','LineWidth',1);

%end of 10.8.19 SA,AM edit

% compute and set new target position
targetShoulderAbductionAngle = get( setTargets.shoulderAbductionAngleEditBox, 'String' );
targetShoulderAbductionAngle = str2double(targetShoulderAbductionAngle) * pi/180;
%targetShoulderAbductionAngle = targetShoulderAbductionAngle - pi/2;

targetShoulderFlexionAngle = get( setTargets.shoulderFlexionAngleEditBox, 'String' );
targetShoulderFlexionAngle = str2double(targetShoulderFlexionAngle) * pi/180;

targetElbowAngle = get( setTargets.elbowAngleEditBox, 'String' );
targetElbowAngle = str2double(targetElbowAngle) * pi/180;

display.SetTargetPosition( arm, targetShoulderFlexionAngle, targetElbowAngle, targetShoulderAbductionAngle, judp, chairPosition );

% set the target position at the computed position
% send 'target position x y z'
%[sphereX,sphereY,sphereZ] = display.ComputeSphere( display.radius, display.target.position );
%set( display.targetSphereHandle, 'XData',sphereX, 'YData',sphereY, 'ZData',sphereZ );

% set new position in setTargets window
set( setTargets.xEditBox, 'String', num2str(display.target.position(chairPosition,1)) );
set( setTargets.yEditBox, 'String', num2str(display.target.position(chairPosition,2)) );
set( setTargets.zEditBox, 'String', num2str(display.target.position(chairPosition,3)) );

%//// new AM and AMA edits 10.7.19
% % Update home and target positions based on current endpoint position
% set(addDisplay.homeCircle,'Position',[display.home.position() 2*r 2*r]);
% %THE LINE ABOVE WORKS 10.03 KCS AND AM
% 
% set(addDisplay.homeCircle,'Visible','on'); %green = [0 1 0.5]; red = [1 0 0.5]
% % set(addDisplay.homeCircle,'EdgeColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% 
% %//A.M TO-DO: Change opacity of blue so that crosshair is still visible inside the blue circle because it is currently not seen 
% set(addDisplay.homeCircle,'FaceColor','b');
%//// new AM and AMA edits 10.7.19

fprintf('Shoulder located\n');

% save home, target, and shoulder positions
positionsData{1,1} = 'home positions';
positionsData{1,2} = 'home angles';
positionsData{1,3} = 'target position';
positionsData{1,4} = 'target angles';
positionsData{1,5} = 'shoulder position';
%positionsData{1,6} = 'table height';
positionsData{1,6} = 'end effector position';
positionsData{1,7} = 'end effector rotation';

positionsData{2,1} = display.home.position(chairPosition,1);
positionsData{3,1} = display.home.position(chairPosition,2);
positionsData{4,1} = display.home.position(chairPosition,3);

positionsData{2,2} = display.home.positionAngles(chairPosition,1);
positionsData{3,2} = display.home.positionAngles(chairPosition,2);
positionsData{4,2} = display.home.positionAngles(chairPosition,3);

positionsData{2,3} = display.target.position(chairPosition,1);
positionsData{3,3} = display.target.position(chairPosition,2);
positionsData{4,3} = display.target.position(chairPosition,3);

positionsData{2,4} = display.target.positionAngles(chairPosition,1);
positionsData{3,4} = display.target.positionAngles(chairPosition,2);
positionsData{4,4} = display.target.positionAngles(chairPosition,3);

positionsData{2,5} = display.shoulderPosition(chairPosition,1);
positionsData{3,5} = display.shoulderPosition(chairPosition,2);
positionsData{4,5} = display.shoulderPosition(chairPosition,3);

%Added in end effector position and rotation data
positionsData{2,6} = robot.endEffectorPosition(1);
positionsData{3,6} = robot.endEffectorPosition(2);
positionsData{4,6} = robot.endEffectorPosition(3);

positionsData{2,7} = robot.endEffectorRotation(1);

% folder to save to
folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
if iscell(folder), folder = folder{1}; end

filename = [ 'chair_position_' num2str(chairPosition) ];
save([folder '\' filename], 'positionsData');
            
fprintf('chair position saved to file\n')

start(timerObject);

end


function chairPositionRadioButton_Callback(hObject, eventdata, mainWindow, initializeRobot, display, setTargets, judp, timerObject )
% change home position number in status panel and choice in other chair
% position button group

stop(timerObject);

label = get( hObject, 'String');
if strcmp(label,'One')
    chairPosition = 1;
    set( initializeRobot.oneRadioButton, 'Value',1 );
    set( setTargets.oneRadioButton, 'Value',1 );
else
    chairPosition = 2;
    set( initializeRobot.twoRadioButton, 'Value',1 );
    set( setTargets.twoRadioButton, 'Value',1 );
end

set( mainWindow.statusPanel.secondColumn(12), 'String', num2str(chairPosition) );

% set home position
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end

blenderAngles = display.home.positionAngles(chairPosition,:) * 180/pi;
judp.Write( [ 'home position ',  num2str(blenderAngles(1)), ' ',...
    num2str(blenderAngles(2)), ' ',  num2str(blenderAngles(3)) ] );

% compute and set new target position
blenderAngles = display.target.positionAngles(chairPosition,:) * 180/pi;
judp.Write( [ 'target position ',  num2str(blenderAngles(1)), ' ',...
    num2str(blenderAngles(2)), ' ',  num2str(blenderAngles(3)) ] );

start(timerObject);

end


% Computes the distance from the shoulder to the end effector and then computes: force = torque / distance
function computeAbdMaxForcePushButton_Callback(hObject, eventdata, mainWindow, display, robot, participantParameters )

% Display dialog box if this button has already been clicked once.  We
% don't want to use more than one abduction max force value.  This would
% result in different forces for the same % abduction max values.
if display.shoulderToEndEffector ~= 0
    default = 'Cancel';
    answer = questdlg('You have already set the abduction max force value.  Are you sure you want to compute a different value?',...
        'Overwrite Abduction Max Force',...
        'Overwrite', 'Cancel', default);
    if strcmp( answer, 'Cancel' )
        return;
    end
end

% compute new abduction max force value ( force = torque / r ) using the 
% distance from the shoulder to the end effector as r.  Only need to set
% this value once.
chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
display.shoulderToEndEffector = norm( robot.endEffectorPosition - display.shoulderPosition(chairPosition,:) );
torque = str2double( get( participantParameters.abductionMaxTorqueEditBox, 'String' ) );
force = torque / display.shoulderToEndEffector;
set( participantParameters.abductionMaxForceEditBox, 'String', num2str(force,'%3.2f') );

disp(['Moment Arm (end effector to shoulder) = ', num2str(display.shoulderToEndEffector,'%3.2f'), ' m'] );
disp(['Abduction max torque value is ', num2str(torque,'%3.2f'), ' Nm'] );
disp(['Abduction max force value is ', num2str(force,'%3.2f'), ' N'] );

end


function weighArmPushButton_Callback(hObject, eventdata, mainWindow, robot, initializeRobot, participantParameters )

% Acquire limb weight samples  
maxLimbWeightSamples = 400;
limbWeightSamples = zeros(1,maxLimbWeightSamples);
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
for sample = 1:maxLimbWeightSamples
    robot.SetForceGetInfo(arm);
    limbWeightSamples(sample) = robot.endEffectorForce(3);
end

% Average the samples to get a limb weight value
limbWeight = mean(limbWeightSamples);
set( participantParameters.limbWeightEditBox, 'String', num2str(-limbWeight,'%3.2f') );
fprintf('The weight of the participant''s limb is %3.2f N\n',-limbWeight);

% switch the robot back to a normal state
robot.SwitchState('normal');
set(mainWindow.trialConditionsPanel.statePopUpMenu,'String',{'normal','fixed','off'});
set(mainWindow.trialConditionsPanel.statePopUpMenu,'Value',1);

end


% does the same thing as the push button "Save To File" in the Participant
% Parameters window
function savePPToFilePushButton_Callback(hObject, eventdata, mainWindow, participantParameters, initializeRobot )

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
    'handLength',handLength; 'elbowFlexion',elbowFlexion;, ...
    'shoulderFlexion',shoulderFlexion; 'shoulderAbduction',shoulderAbduction;,...
	'abductionMaxTorque',abductionMaxTorque;...
    'abductionMaxForce',abductionMaxForce; 'limbWeight',limbWeight;...
    'notes',notes; 'arm',arm };
    
filepath = [char(folder) '\' filename];
save(filepath,'data');

disp('Participant parameters saved to .mat file');

end


function okPushButton_Callback(hObject, eventdata, mainWindow, robot, initializeRobot )

% save fileanme and the arm in the figure handle properties
armObject = get( initializeRobot.armButtonGroup, 'SelectedObject' );
setappdata( initializeRobot.figureHandle, 'arm',armObject );
arm = get( armObject, 'String' );

filename = get( initializeRobot.filenameEditBox, 'String' );
setappdata(initializeRobot.figureHandle,'filename',filename);
set( mainWindow.statusPanel.secondColumn(11), 'String', filename );

% make initialize robot window invisible and save what's been done
set(initializeRobot.figureHandle, 'Visible','off', 'WindowStyle','normal');

end


function cancelPushButton_Callback(hObject, eventdata, mainWindow, robot, initializeRobot )

% make initialize robot window invisible and revert to previous values
set(initializeRobot.figureHandle, 'Visible','off', 'WindowStyle','normal');

% revert back to previous arm and filename for initialize robot window only
armObject = getappdata( initializeRobot.figureHandle,'arm' );
set( initializeRobot.armButtonGroup, 'SelectedObject', armObject );
arm = get( armObject, 'String' );

filename = getappdata(initializeRobot.figureHandle,'filename');
set( initializeRobot.filenameEditBox, 'String', filename );

end


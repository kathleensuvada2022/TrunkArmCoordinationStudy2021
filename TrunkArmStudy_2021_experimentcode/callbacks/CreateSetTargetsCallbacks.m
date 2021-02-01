%%// A.M. : TO-DO: Need to find out whether this callback is still in use
%%for anything

function setTargets = CreateSetTargetsCallbacks(...
    initializeRobot, mainWindow, participantParameters, setTargets,...
    robot, haptic, display, judp, timerObject )


set(setTargets.target1RadioButton,...
    'Callback',{@target1RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.target2RadioButton,...
    'Callback',{@target2RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.target3RadioButton,...
    'Callback',{@target3RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.target4RadioButton,...
    'Callback',{@target4RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.retrieveRadioButton,...
    'Callback',{@retrieveRadioButton_Callback,mainWindow,setTargets, display, judp });
set(setTargets.customRadioButton,...
    'Callback',{@customRadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.S1_RadioButton,...
    'Callback',{@S1_RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.R_RadioButton,...
    'Callback',{@R_RadioButton_Callback,mainWindow,setTargets, display, judp});
set(setTargets.E1_RadioButton,...
    'Callback',{@E1_RadioButton_Callback,mainWindow,setTargets, display, judp});


set(setTargets.xEditBox,...
    'Callback',{@positionEditBox_Callback,mainWindow});
set(setTargets.yEditBox,...
    'Callback',{@positionEditBox_Callback,mainWindow});
set(setTargets.zEditBox,...
    'Callback',{@positionEditBox_Callback,mainWindow});
set(setTargets.shoulderFlexionAngleEditBox,...
    'Callback',{@angleEditBox_Callback,mainWindow, setTargets,display, judp});
set(setTargets.elbowAngleEditBox,...
    'Callback',{@angleEditBox_Callback,mainWindow, setTargets,display, judp});
set(setTargets.shoulderAbductionAngleEditBox,...
    'Callback',{@angleEditBox_Callback,mainWindow, setTargets,display, judp});

set(setTargets.oneRadioButton,...
    'Callback',{@chairPositionRadioButton_Callback,mainWindow,initializeRobot,display,setTargets,timerObject,judp});
set(setTargets.twoRadioButton,...
    'Callback',{@chairPositionRadioButton_Callback,mainWindow,initializeRobot,display,setTargets,timerObject,judp});
set(setTargets.previewToggleButton,...
    'Callback',{@previewToggleButton_Callback,mainWindow,setTargets,display,judp});
set(setTargets.okPushButton,...
    'Callback',{@okPushButton_Callback,mainWindow,setTargets,display, judp});
set(setTargets.cancelPushButton,...
    'Callback',{@cancelPushButton_Callback,mainWindow,setTargets,display});

set( setTargets.figureHandle, 'CloseRequestFcn', @(x,y)disp('Please click OK or Cancel') );

end


function target1RadioButton_Callback(hObject, eventdata, mainWindow,setTargets, display, judp )
% set shoulder flexion, elbow flexion, and shoulder abduction angles and
% the corresponding x, y, and z values


shoulderFlexionAngle = '40';
elbowFlexionAngle = '80';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowFlexionAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function target2RadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )
% set shoulder flexion, elbow flexion, and shoulder abduction angles and
% the corresponding x, y, and z values

shoulderFlexionAngle = '60';
elbowAngle = '10';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );
end


function target3RadioButton_Callback(hObject, eventdata, mainWindow,setTargets, display, judp )
% set shoulder flexion, elbow flexion, and shoulder abduction angles and
% the corresponding x, y, and z values

shoulderFlexionAngle = '80';
elbowAngle = '10';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );
end


function target4RadioButton_Callback(hObject, eventdata, mainWindow,setTargets, display, judp )
% set shoulder flexion, elbow flexion, and shoulder abduction angles and
% the corresponding x, y, and z values

shoulderFlexionAngle = '100';
elbowAngle = '10';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );
end

function retrieveRadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )
% --- NOT YET IMPLEMENTED - CURRENTLY DISABLED ---
% change axes to display elbow extension target and make all other targets invisible
end



function customRadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

shoulderFlexionAngle = get( setTargets.shoulderFlexionAngleEditBox, 'String' );
elbowAngle = get( setTargets.elbowAngleEditBox, 'String' );
shoulderAbductionAngle = get( setTargets.shoulderAbductionAngleEditBox, 'String' );

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function S1_RadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

shoulderFlexionAngle = '70';
elbowAngle = '110';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function R_RadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

shoulderFlexionAngle = '70';
elbowAngle = '10';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function E1_RadioButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

shoulderFlexionAngle = '40';
elbowAngle = '10';
shoulderAbductionAngle = '90';

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp )

set( setTargets.shoulderFlexionAngleEditBox, 'String', shoulderFlexionAngle );
set( setTargets.elbowAngleEditBox, 'String', elbowAngle );
set( setTargets.shoulderAbductionAngleEditBox, 'String', shoulderAbductionAngle );

arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
if iscell(arm)
    arm = arm{1};
end


% convert to radians in double format
shoulderFlexionAngle = str2double(shoulderFlexionAngle) *pi/180;
elbowAngle = str2double(elbowAngle) *pi/180;
shoulderAbductionAngle = str2double(shoulderAbductionAngle) *pi/180;
%shoulderAbductionAngle = shoulderAbductionAngle - pi/2;

chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );

% set target position on figure
display.SetTargetPosition( arm, shoulderFlexionAngle, elbowAngle, shoulderAbductionAngle, judp, chairPosition );

%[sphereX,sphereY,sphereZ] = display.ComputeSphere( display.radius, display.target.position );
%set( display.targetSphereHandle, 'XData',sphereX, 'YData',sphereY, 'ZData',sphereZ );
% set target position in blender
% send 'target position x y z'

% set target position in edit boxes
set( setTargets.xEditBox, 'String', num2str(display.target.position(chairPosition,1)) );
set( setTargets.yEditBox, 'String', num2str(display.target.position(chairPosition,2)) );
set( setTargets.zEditBox, 'String', num2str(display.target.position(chairPosition,3)) );

% make the current object the selected object in case radio button was unclicked
set( setTargets.targetsButtonGroup, 'SelectedObject', hObject );
end

function positionEditBox_Callback(hObject, eventdata, mainWindow )
% --- NOT YET IMPLEMENTED - CURRENTLY DISABLED ---
% change target location on axes
%{
%shoulderFlexionAngle = str2double( get( setTargets.shoulderFlexionAngleEditBox, 'String' ) );
%elbowAngle = str2double( get( setTargets.elbowAngleEditBox, 'String' ) );
%shoulderAbductionAngle = str2double( get( setTargets.shoulderAbductionAngleEditBox, 'String' ) );
if ( shoulderAngle ~= 0  &&  elbowAngle ~= 0 )
    x=0;
    y=0;

else
    % compute forward kinematics for right arm to determine target position
    targetX = upperArmLength*cos(shoulderAngle) + lowerArmLength*cos(elbowAngle+shoulderAngle);
    targetY = upperArmLength*sin(shoulderAngle) + lowerArmLength*sin(elbowAngle+shoulderAngle);
    if strcmp(arm,'Left')
        targetX = -targetX;
    end

end
%}

% set target position

end


function angleEditBox_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

shoulderFlexionAngle =  get( setTargets.shoulderFlexionAngleEditBox, 'String' );
elbowAngle = get( setTargets.elbowAngleEditBox, 'String' );
shoulderAbductionAngle = get( setTargets.shoulderAbductionAngleEditBox, 'String' );

hObject = setTargets.customRadioButton;

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

end


function chairPositionRadioButton_Callback(hObject, eventdata, mainWindow, initializeRobot, display, setTargets, timerObject, judp )
% change home position number in status panel and choice in other chair
% position button group

stop(timerObject);


label = get( hObject, 'String');
if strcmp(label,'One')
    chairPosition = 1;
    set( initializeRobot.oneRadioButton, 'Value',1 );
    set( setTargets.oneRadioButton, 'Value',1);
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

shoulderFlexionAngle =  get( setTargets.shoulderFlexionAngleEditBox, 'String' );
elbowAngle = get( setTargets.elbowAngleEditBox, 'String' );
shoulderAbductionAngle = get( setTargets.shoulderAbductionAngleEditBox, 'String' );

hObject = get( setTargets.targetsButtonGroup, 'SelectedObject' );

radioCallback( setTargets, shoulderFlexionAngle, elbowAngle,...
    shoulderAbductionAngle, mainWindow, display, hObject, judp );

start(timerObject);

end

function previewToggleButton_Callback( hObject, eventdata, mainWindow, setTargets, display, judp )
value = get( hObject, 'Value' );
%chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
if value == 1
    %set( display.targetSphereHandle(chairPosition), 'Visible', 'on' );
    judp.Write('home visible on');
    judp.Write('target visible on');
    
else
    %set( display.targetSphereHandle(chairPosition), 'Visible', 'off' );
    judp.Write('home visible off');
    judp.Write('target visible off');
end

end


function okPushButton_Callback(hObject, eventdata, mainWindow, setTargets, display, judp )

% save target in the figure handle properties
targetObject = get( setTargets.targetsButtonGroup, 'SelectedObject' );
setappdata(setTargets.figureHandle, 'target',targetObject );

% save the current target choice in the status panel of the main window
targetChoice = get( targetObject, 'String' );
set( mainWindow.statusPanel.secondColumn(7), 'String', targetChoice );

% get x and y and save them to target position
targetPositionX = str2double( get( setTargets.xEditBox, 'String' ) );
targetPositionY = str2double( get( setTargets.yEditBox, 'String' ) );
targetPositionZ = str2double( get( setTargets.zEditBox, 'String' ) );
chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
display.target.position(chairPosition,:) = [ targetPositionX, targetPositionY, targetPositionZ ];

% turn off the preview button, target and home spheres in case they are visible
set( setTargets.previewToggleButton, 'Value', 0 );
%set( display.targetSphereHandle, 'Visible', 'off' );
judp.Write('target visible off');
judp.Write('home visible off');


% make this window invisible
set( setTargets.figureHandle, 'Visible','Off', 'WindowStyle','modal' );

end


function cancelPushButton_Callback(hObject, eventdata, mainWindow, setTargets, display)

% revert target selection to previous selection, x, y, and angle boxes to
% previous values
targetObject = getappdata(setTargets.figureHandle,'target');
set( setTargets.targetsButtonGroup, 'SelectedObject', targetObject );

% revert target choice and position to previous values - temp
targetChoice = get( targetObject, 'String' );
customRadioButton_Callback( targetObject, [], mainWindow, setTargets, display );

% make this window invisible
set( setTargets.figureHandle, 'Visible','Off', 'WindowStyle','normal' );

end


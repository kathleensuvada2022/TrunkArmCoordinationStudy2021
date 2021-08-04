% Math to compute shoulder position based on end effector position

% First compute elbow position
elbowPosition(1) = endEffectorPosition(1) - obj.elbowToEndEffector * cos(endEffectorRotation);
if strcmp( arm, 'Left' )
    elbowPosition(2) = endEffectorPosition(2) - obj.elbowToEndEffector * sin(endEffectorRotation);
    %elbowPosition(2) = endEffectorPosition(2) - obj.elbowToEndEffector * sin(pi/4);
else % right
    elbowPosition(2) = endEffectorPosition(2) + obj.elbowToEndEffector * sin(endEffectorRotation);
    %elbowPosition(2) = endEffectorPosition(2) + obj.elbowToEndEffector * sin(pi/4);
end

elbowPosition(3) = endEffectorPosition(3);

% Then compute shoulder position
if strcmp(arm,'Right')
    obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
        - obj.elbowToEndEffector * cos(endEffectorRotation)  ...
        + obj.upperArmLength * cos(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
    obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
        + obj.elbowToEndEffector * sin(endEffectorRotation)...
        + obj.upperArmLength * sin(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
    % left arm
else
    % shoulder x position
    obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
        + obj.upperArmLength * cos( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
        - obj.elbowToEndEffector * cos( endEffectorRotation ) ;
    % shoulder y position
    obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
        - obj.upperArmLength * sin( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
        - obj.elbowToEndEffector * sin( endEffectorRotation );
end

obj.shoulderPosition(chairPosition,3) = endEffectorPosition(3) -...
    obj.upperArmLength * sin(adjustedShoulderAbductionAngle);

% Matrix algebra:
if strcmp(exp.arm,'right')
    epos=robot.endEffectorPosition(:)+rotz(-robot.endEffectorRotation)*[-exp.e2hLength 0 0];
else
    epos=robot.endEffectorPosition(:)+rotz(robot.endEffectorRotation)*[-exp.e2hLength 0 0];
end

%% Compute fingertip position
if strcmp(arm,'Right')
    obj.fingerTipPosition(1) = endEffectorPosition(1) +...
        ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
        * cos(endEffectorRotation) );
   
    obj.fingerTipPosition(2) = endEffectorPosition(2) -...
        ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
        * sin(endEffectorRotation) );
    
    obj.fingerTipPosition(3) = endEffectorPosition(3);
    
else % left arm
    obj.fingerTipPosition(1) = endEffectorPosition(1) +...
        ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
        * cos(endEffectorRotation) );
    
    obj.fingerTipPosition(2) = endEffectorPosition(2) +...
        ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
        * sin(endEffectorRotation) );
    
    obj.fingerTipPosition(3) = endEffectorPosition(3);
end

% Matrix algebra:
if strcmp(exp.arm,'right')
    epos=robot.endEffectorPosition(:)+rotz(-robot.endEffectorRotation)*[exp.e2hLength 0 0];
else
    epos=robot.endEffectorPosition(:)+rotz(robot.endEffectorRotation)*[exp.e2hLength 0 0];
end


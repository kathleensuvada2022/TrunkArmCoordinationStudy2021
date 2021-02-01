%// A.M TO-DO: Need to check if this code is being used 

classdef Display < handle
    %DISPLAY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        home;   % struct containing home target variables
        target; % struct containing variables for the target
        radius = 0.05;
        figureHandle;
        axesHandle;
        lineSeriesHandle;
        planeHandle;
        planeTop;
        homeSphereHandle;
        targetSphereHandle;
        endEffectorHandle;
        shoulderPositionHandle;
        fingerTipPositionHandle;
        fingerTipPositionTraceHandle;
        fingerTipPositionTraceIteration=0;
        fingerTipPositionTrace = zeros(3,300);
        
        % position where the end of the arm is at 40 degrees shoulder flexion
        % and 90 degrees elbow flexion.  Used to compute target position.
        distalEndOfArmAtHome = [ 0.1722, 0.5902, 0.3596 ];
        
        
        shoulderPosition = [ 0.25, 0.4, -0.1;  0.25, 0.5, -0.1  ];
        %A.M. 10.7.2019 Commented out above line to debug
        %shoulderPosition = [ 0, 0, 0;  0, 0, 0  ];
        
        % these angles are the saved angles and defined as the clinically
        % relevant angles
        % -- is sf=0,e=0 ; < is s~30,ef~135 ;  for right arm: > is sf=30,e=135
        shoulderFlexionAngle = 40*(pi/180);
        elbowAngle = 90*(pi/180);
        shoulderAbductionAngle = 85*(pi/180);
        
        upperArmLength = 0.352;
        lowerArmLength = 0.287;
        handLength = 0.191;
        elbowToEndEffector = 0.232;
        fingerTipPosition = [0 0 0];        % finger tip position for display
        shoulderToEndEffector=0; 			% in meters
        
    end
    
    methods
        % constructor
        function obj = Display( robot, judp, obj ) %#ok<INUSD>
            
            % initialize class properties
            % 2 rows for 2 chair positions
            obj.home.position = [ 0, 0, 0;  0, 0.01, 0 ];
            obj.home.positionAngles = [ 0, 0, 0;  0, 0, 0 ];
            obj.home.iterationsInside = 0;
            obj.target.position = [ 0, 0.02, 0;  0, 0.03, 0 ];
            obj.target.positionAngles = [ 0, 0, 0;  0, 0, 0 ];

            
            obj.target.iterationsInside = 0;
            obj.target.iterations = 0;
            
            % get arm selected
            obj.StartBlender('Right', judp);
            
        end
       
        % destructor
        function delete(obj, arm, judp )
            obj.CloseDisplay(arm, judp);
            %stop( obj.updateDisplayTimer );
            %delete( obj.updateDisplayTimer );
        end
        
        
        function obj = StartBlender( obj, arm, judp)
            if strcmp( arm, 'Right' )
                % change this to a right arm exe
                create_async('Init','right');
            else
                % change this to a left arm exe
                create_async('Init','left');
            end
            
            pause(3);
            
            % if not disconnected, then disconnect
            isSocketClosed = get( judp.socketReceive, 'Closed' );
            if strcmp(isSocketClosed,'off')
                judp.Disconnect;
            end
            
            % Create connection to udp connection
            judp.Connect;
            
            %pause(3);
            
        end
        
        
        function obj = ComputeArmAngles( obj, endEffectorPosition, endEffectorRotation, arm, chairPosition )
            
            % compute shoulder abduction angle
            %obj.ComputeShoulderAbductionAngle( endEffectorPosition, chairPosition );
            %obj.shoulderAbductionAngle = 0; %temp

            %z = endEffectorPosition(3) - obj.shoulderPosition(3);
            %xyz = norm( endEffectorPosition - obj.shoulderPosition );
            %obj.upperArmLength + obj.elbowToEndEffector;
            %sqrt( abs(endEffectorPosition - obj.shoulderPosition)^2 ...
            %+ abs(endEffectorPosition(1) - obj.shoulderPosition(1))^2 );
            %obj.shoulderAbductionAngle = asin( z/xyz );
            
            
            % compute elbow position
            elbowPosition(1) = endEffectorPosition(1) - obj.elbowToEndEffector * cos(endEffectorRotation);
            %elbowPosition(1) = endEffectorPosition(1) - obj.elbowToEndEffector * cos(pi/4);
            
            if strcmp( arm, 'Left' )
                elbowPosition(2) = endEffectorPosition(2) - obj.elbowToEndEffector * sin(endEffectorRotation);
                %elbowPosition(2) = endEffectorPosition(2) - obj.elbowToEndEffector * sin(pi/4);
            else % right
                elbowPosition(2) = endEffectorPosition(2) + obj.elbowToEndEffector * sin(endEffectorRotation);
                %elbowPosition(2) = endEffectorPosition(2) + obj.elbowToEndEffector * sin(pi/4);
            end
            
            elbowPosition(3) = endEffectorPosition(3);
            
            % compute shoulder abduction angle
            obj.ComputeShoulderAbductionAngle( chairPosition, elbowPosition );
            % Is this still needed?
			%elbowPosition(3) = endEffectorPosition(3)...
            %    - (obj.elbowToEndEffector * sin(obj.shoulderAbductionAngle));
            
            x = elbowPosition(1) - obj.shoulderPosition(chairPosition,1);
            y = elbowPosition(2) - obj.shoulderPosition(chairPosition,2);
            if strcmp( arm, 'Left' )
                obj.shoulderFlexionAngle = - atan2( y, x ) + pi;
                obj.elbowAngle = pi - endEffectorRotation - obj.shoulderFlexionAngle;
                %obj.elbowAngle = pi - pi/4 - obj.shoulderFlexionAngle;
            else
                obj.shoulderFlexionAngle = atan2( y, x ) + pi;
                % test this!
                obj.elbowAngle = pi - endEffectorRotation - obj.shoulderFlexionAngle;
                %obj.elbowAngle = pi - pi/4 - obj.shoulderFlexionAngle;
            end
        end
        
        
        function obj = ComputeShoulderAbductionAngle( obj, chairPosition, elbowPosition )
        
            xyz = elbowPosition - obj.shoulderPosition(chairPosition,:);
            z = elbowPosition(3) - obj.shoulderPosition(chairPosition,3);
            
            obj.shoulderAbductionAngle = pi/2 + asin( z/norm(xyz) );
            
        end
        
        
        function obj = ComputeFingerTipPosition( obj, endEffectorPosition,...
                endEffectorRotation, arm )
            
            if strcmp(arm,'Right')
                
                obj.fingerTipPosition(1) = endEffectorPosition(1) +...
                    ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
                    * cos(endEffectorRotation) );
                
%                  obj.fingerTipPosition(1) = endEffectorPosition(1) +...
%                     ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
%                     * cos(pi/4) );
                
                obj.fingerTipPosition(2) = endEffectorPosition(2) -...
                    ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
                    * sin(endEffectorRotation) );
                
%                 obj.fingerTipPosition(2) = endEffectorPosition(2) -...
%                     ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
%                     * sin(pi/4) );
                
                obj.fingerTipPosition(3) = endEffectorPosition(3);
                
                
            else % left arm
                
                
                obj.fingerTipPosition(1) = endEffectorPosition(1) +...
                    ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
                    * cos(endEffectorRotation) );
                
%                 obj.fingerTipPosition(1) = endEffectorPosition(1) +...
%                     ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
%                     * cos(pi/4) );
                
                obj.fingerTipPosition(2) = endEffectorPosition(2) +...
                    ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
                    * sin(endEffectorRotation) );
                
%                  obj.fingerTipPosition(2) = endEffectorPosition(2) +...
%                     ( (obj.handLength + obj.lowerArmLength - obj.elbowToEndEffector)...
%                     * sin(pi/4) );
                
                obj.fingerTipPosition(3) = endEffectorPosition(3);

            end
            
        end
        
        
        function obj = CloseDisplay( obj, arm, judp )    % should I change these last two arguments to ~ or remove?
            % terminate blender program
			% end thread using blender
			% close socket
            judp.Write('disconnect');
            disp('disconnect sent');
            
            disp('UDP connection closed');

            pause(3);
            
            judp.Disconnect;
            
            %% end thread
            %% CHANGE THESE CALLS TO RIGHT AND LEFT ARM FUNCTION CALLS
            if strcmp(arm, 'Right')
                try
                    % use dos command to remove program in the second thread
                    !taskkill /f /im visual_right_arm.exe
                catch
                    disp('Blender could not be closed.  Please close manually.');
                end

                % finish the separate thread - change this to left or right arm
                create_async('Finish','right');
            
            else
                try
                    % use dos command to remove program in the second thread
                    !taskkill /f /im visual_left_arm.exe
                catch
                    disp('Blender could not be closed.  Please close manually.');
                end

                % finish the separate thread - change this to left or right arm
                create_async('Finish','left');
                
            end

            %{
			if ishandle(obj.figureHandle)
                close(obj.figureHandle);
            end
			%}
        end
                
        
        function obj = ComputeShoulderPosition( obj, endEffectorPosition, endEffectorRotation, shoulderFlexionAngle, shoulderAbductionAngle, arm, chairPosition )
        
            % rotate shoulder abduction angle to 0 degrees in the plane
            % that the subject is reaching
            adjustedShoulderAbductionAngle = shoulderAbductionAngle - pi/2;
           
            % compute shoulder position using arm measurements and initial end effector position
            if strcmp(arm,'Right')
                
                obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
                    - obj.elbowToEndEffector * cos(endEffectorRotation)  ...
                    + obj.upperArmLength * cos(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
				obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
                    + obj.elbowToEndEffector * sin(endEffectorRotation)...
                    + obj.upperArmLength * sin(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);

%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     - obj.elbowToEndEffector * cos(pi/4)  ...
%                     + obj.upperArmLength * cos(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);
% 				obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     + obj.elbowToEndEffector * sin(pi/4)...
%                     + obj.upperArmLength * sin(shoulderFlexionAngle) * cos(adjustedShoulderAbductionAngle);

            % left arm
            else
                % shoulder x position
                obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
                    + obj.upperArmLength * cos( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
					- obj.elbowToEndEffector * cos( endEffectorRotation ) ;
                
%                 obj.shoulderPosition(chairPosition,1) = endEffectorPosition(1)...
%                     + obj.upperArmLength * cos( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * cos( pi/4 ) ;
                
                % shoulder y position
                obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
                    - obj.upperArmLength * sin( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
					- obj.elbowToEndEffector * sin( endEffectorRotation );
                  
%                   obj.shoulderPosition(chairPosition,2) = endEffectorPosition(2)...
%                     - obj.upperArmLength * sin( shoulderFlexionAngle ) * cos(adjustedShoulderAbductionAngle)...
% 					- obj.elbowToEndEffector * sin( pi/4 );   
            end
            
            obj.shoulderPosition(chairPosition,3) = endEffectorPosition(3) -...
				obj.upperArmLength * sin(adjustedShoulderAbductionAngle);
            
            
        end
        
        
        function obj = SetTargetPosition( obj, arm, shoulderFlexionAngle, elbowAngle, shoulderAbductionAngle, judp, chairPosition )
            
            if nargin == 1  % if there are no inputs
                shoulderFlexionAngle = obj.shoulderFlexionAngle;
                elbowAngle = obj.elbowAngle;
                shoulderAbductionAngle = obj.shoulderAbductionAngle;
            end
            
            % rotate shoulder abduction angle to 0 degrees in the plane
            % that the subject is reaching
            adjustedShoulderAbductionAngle = shoulderAbductionAngle - pi/2;
            
            
            if ( isnan(shoulderFlexionAngle)  ||  isnan(elbowAngle)  ||  isnan(shoulderAbductionAngle) )
                obj.target.position(chairPosition,1) = 0;
                obj.target.position(chairPosition,2) = 0;
                obj.target.position(chairPosition,3) = 0;
                
            else
                % compute forward kinematics using desired arm angles to determine target position
                relativeElbowAngle = elbowAngle + shoulderFlexionAngle;
                
                distance(1) = obj.upperArmLength * cos(adjustedShoulderAbductionAngle) * cos(shoulderFlexionAngle) ...
                    + ( (obj.lowerArmLength + obj.handLength) * cos(relativeElbowAngle) );
                
                distance(2) = obj.upperArmLength * cos(adjustedShoulderAbductionAngle) * sin(shoulderFlexionAngle)...
                    + ( (obj.lowerArmLength + obj.handLength) * sin(relativeElbowAngle) );
                
                distance(3) = sin(adjustedShoulderAbductionAngle) * obj.upperArmLength;
                
                
                if strcmp(arm,'Right')
                    obj.target.position(chairPosition,2) = obj.shoulderPosition(chairPosition,2) - distance(2);
                    
                else % left arm
                    obj.target.position(chairPosition,2) = obj.shoulderPosition(chairPosition,2) + distance(2);
                end
                
                obj.target.position(chairPosition,1) = obj.shoulderPosition(chairPosition,1) - distance(1);
                obj.target.position(chairPosition,3) = obj.shoulderPosition(chairPosition,3) + distance(3); 
            
            end
            
            %{
            [sphereX,sphereY,sphereZ] = obj.ComputeSphere( obj.radius,obj.target.position );
            set( obj.targetSphereHandle, 'XData',sphereX, 'YData',sphereY, 'ZData',sphereZ );
            %}
            obj.target.positionAngles(chairPosition,:) = [ shoulderFlexionAngle, elbowAngle,...
                shoulderAbductionAngle ];
			blenderAngles = obj.target.positionAngles(chairPosition,:) * 180/pi;
            blenderAngles(3) = blenderAngles(3) - 90;
			judp.Write(['target position ', num2str(blenderAngles(1)), ' ',...
                num2str(blenderAngles(2)), ' ', num2str(blenderAngles(3)) ] );

        end
        
        function [x,y,z] = ComputeSphere(radius,location)
            % taken from: http://www.mathworks.com/matlabcentral/newsreader/view_thread/169373
            phi=linspace(0,pi,30);
            theta=linspace(0,2*pi,40);
            [phi,theta]=meshgrid(phi,theta);

            x = radius * sin(phi).* cos(theta) + location(1);
            y = radius * sin(phi).* sin(theta) + location(2);
            z = radius * cos(phi) + location(3); 
        end
        
        function obj = SetHomePosition( obj, endEffectorPosition, endEffectorRotation, arm, judp, chairPosition )
            
            % place new home position at the finger tips 
            
             obj.ComputeFingerTipPosition( endEffectorPosition, endEffectorRotation, arm );
%             obj.ComputeFingerTipPosition( endEffectorPosition, pi/4, arm );

            
            % save angles for this home position
            obj.home.position(chairPosition,:) = obj.fingerTipPosition;

            obj.ComputeArmAngles( endEffectorPosition, endEffectorRotation, arm, chairPosition );
            %obj.ComputeArmAngles( endEffectorPosition, pi/4, arm, chairPosition );
            
            % save angles for this home position
            obj.home.positionAngles(chairPosition,:) = [ obj.shoulderFlexionAngle, obj.elbowAngle, obj.shoulderAbductionAngle ];
            
            % send arm angles where the home position should be set
            blenderAngles = obj.home.positionAngles(chairPosition,:) * 180/pi;
            blenderAngles(3) = blenderAngles(3) - 90;
            judp.Write( [ 'home position ',  num2str(blenderAngles(1)), ' ',...
                num2str(blenderAngles(2)), ' ',  num2str(blenderAngles(3)) ] );
        end
        
        
        function obj = RefreshDisplay( obj, experiment, judp, arm )
            
            % display the arm at the new angles 
        
            % convert clincal angles to angles for blender to use
            blenderAngles = obj.ConvertToBlenderAngles(arm);
            %blenderAngles=[70,-10,0];
            judp.Write( ['arm angles ', num2str(blenderAngles(1)), ' ',...
                num2str(blenderAngles(2)), ' ', num2str(blenderAngles(3))] );
            
            % display the trace of the finger tip position if the trial is running
            if experiment.isRecordingData == 1  &&  experiment.isArmOnTable == 0
                obj.fingerTipPositionTraceIteration = obj.fingerTipPositionTraceIteration + 1;
                obj.fingerTipPositionTrace(:,obj.fingerTipPositionTraceIteration) = obj.fingerTipPosition;
                
                % draw a point from the previous finger tip position to the
                % current position
                if mod( obj.fingerTipPositionTraceIteration, 5 ) == 0
                    judp.Write( 'trace append' );
                end
            end
        end
        
        
        function [ blenderAngles, obj ] = ConvertToBlenderAngles(obj, arm)
            % convert to angles to degrees.  abduction is negative for the
            % shoulder abduction angle, since blender uses a right handed
            % coordinate system.
            if strcmp(arm,'Left')
                blenderAngles(1) = -obj.shoulderFlexionAngle*180/pi; 
                blenderAngles(2) = obj.elbowAngle*180/pi; 
            else
                blenderAngles(1) = obj.shoulderFlexionAngle*180/pi; 
                blenderAngles(2) = -obj.elbowAngle*180/pi; 
            end
            
            blenderAngles(3) = (obj.shoulderAbductionAngle-pi/2)*180/pi; 
            
        end
    
        
    end
    
    methods (Static)
    end
     
end


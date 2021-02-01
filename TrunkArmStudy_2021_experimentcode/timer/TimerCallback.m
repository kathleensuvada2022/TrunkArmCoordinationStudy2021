function TimerCallback( obj, event, display, robot, mainWindow, experiment,...
    timerFrequency, trialParameters, setTargets, emgChannels, addDisplay, nidaq, ttl, quanser, judp )
% 
% function TimerCallback( obj, display, robot, mainWindow, experiment,...
%     timerFrequency, trialParameters, setTargets, emgChannels, addDisplay, nidaq, ttl, quanser, judp )

% disp('got to line 7 in TimerCallback');
% get new end effector position
arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );
robot.SetForceGetInfo(arm);
% disp('got to line 11 in TimerCallback');
% update status panel
set( mainWindow.statusPanel.secondColumn(2), 'String', robot.currentState );
% disp('got to line 14 in TimerCallback');
set( mainWindow.statusPanel.secondColumn(8), 'String', num2str(robot.inertia) );
% disp('got to line 16 in TimerCallback');
set( mainWindow.statusPanel.secondColumn(4), 'String', num2str(robot.endEffectorForce(3)) );
% disp('got to line 18 in TimerCallback');
% compute new finger tip location
chairPosition = str2double( get( mainWindow.statusPanel.secondColumn(12), 'String' ) );
% disp('got to line 20 in TimerCallback');
display.ComputeArmAngles( robot.endEffectorPosition, robot.endEffectorRotation, arm, chairPosition );
% disp('got to line 23 in TimerCallback');
display.ComputeFingerTipPosition(robot.endEffectorPosition,robot.endEffectorRotation, arm );
% disp('got to line 25 in TimerCallback');


%//A.M. Testing by printing values 
%disp('FT Pos 1:')
%disp(display.fingerTipPosition(1))
% disp('got to line 30 in TimerCallback');
% print('FT Pos 2',display.fingerTipPosition(2))
% disp('got to line 32 in TimerCallback');
% print('FT Pos 3',display.fingerTipPosition(3))
% disp('got to line 34 in TimerCallback');
%disp('Unknown 1:')
%disp(display.home.position(chairPosition,1))
% disp('got to line 36 in TimerCallback');
% print('Unknown 2',display.home.position(chairPosition,2))
% disp('got to line 38 in TimerCallback');
% print('Unknown 3',display.home.position(chairPosition,3))
%//

% display.ComputeSphere( display.radius, display.fingerTipPosition );

% display.fingerTipPosition(1)
% disp('obj.fingerTipPosition(1): ');
% disp(obj.fingerTipPosition(1))
% obj.fingerTipPosition(1)
% display.target.position
% set(addDisplay.cpx, display.fingerTipPosition(1));
% set(addDisplay.cpy, display.fingerTipPosition(2));
% display.fingerTipPosition
% set(addDisplay.hline3,'Xdata',addDisplay.x(:,1),'Ydata',addDisplay.x(:,2),'Color','g','LineWidth',2);
% display.fingerTipPosition
% fingerTipX
% fingerTipY

%Equation for yvalues is: ypos = (currpos-SPy)/armlength
% xval = (display.fingerTipPosition(1));
% yval = (display.fingerTipPosition(2));
% 
% robot.endEffectorPosition(1);
% robot.endEffectorPosition(2);
% disp('got to line 65 in TimerCallback');
xval_pos = display.fingerTipPosition(1); %robot.endEffectorPosition(1);
yval_pos = display.fingerTipPosition(2); %robot.endEffectorPosition(2);
% disp('got to line 70 in TimerCallback');
armlength = getappdata(addDisplay.figureHandle,'totalArmLength');
% xval_SP = getappdata(addDisplay.figureHandle,'shoulderXVal'); %Converting to cm
% % disp('got to line 73 in TimerCallback');
% yval_SP = getappdata(addDisplay.figureHandle,'shoulderYVal');
% disp('got to line 75 in TimerCallback');
%     addDisplay.figureHandle,'shoulderXVal',display.shoulderPosition(1));
    %Sabeen added for Kacey's additional display circle for lift
% circleLift = getappdata(addDisplay.figureHandle,'newCircle');

% %     getappdata(addDisplay.figureHandle,'newCircle')

%CHECK IF THIS IS BETTER
xval_SP=display.shoulderPosition(chairPosition,1);
yval_SP=display.shoulderPosition(chairPosition,2);

% disp('got to line 84 in TimerCallback');
% xval_new = (xval_pos-xval_SP)/armlength;

%%%// A.M. 13th September 2019 Try to work with x value signs to fix
%mirroring issue / it works now :D
% disp('xval_pos: ');
% disp(xval_pos);

% xval_new = (-(xval_pos)/armlength)*100;
%%%
% xval_new = xval_pos/armlength;

%// A.M. 14th August 2019 Try to work with signs to fix mirroring issue
% disp('yval_pos: ');
% disp(yval_pos);
% disp('yval_SP: ');
% disp(yval_SP);

if strcmp(arm,'Right')
%     yval_new = -(yval_pos-yval_SP)/armlength;
%     yval_new = (-(yval_pos+yval_SP)/armlength)*100;
    xval_new = -xval_pos + (xval_SP+0.2);
    yval_new = -yval_pos + yval_SP;
%     yval_new = -(yval_pos-yval_SP);
else
%     yval_new = -(yval_pos-yval_SP)/armlength;
    xval_new = xval_pos - (xval_SP + 0.15);
    yval_new = yval_pos - yval_SP;
end
set(addDisplay.hline1,'Xdata',[xval_new-0.05 xval_new+0.05],'Ydata',[yval_new yval_new],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0])
set(addDisplay.hline2,'Xdata',[xval_new xval_new],'Ydata',[yval_new-0.05 yval_new+0.05],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);

%disp('yval_pos: ');
%disp(yval_pos);
%disp('yval_SP: ');
%disp(yval_SP);
% disp('In timer')
% disp([robot.endEffectorPosition(1) robot.endEffectorPosition(2)])
% disp(['fingertip= ',num2str([xval_pos yval_pos])])
% disp(['shoulder= ',num2str([xval_SP yval_SP])])
% disp(['cross hair= ',num2str([xval_new yval_new])]);
% disp('got to line 103 in TimerCallback');
% set(addDisplay.hline1,'Xdata',[xval_new-0.15 xval_new+0.15],'Ydata',[yval_new yval_new],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);
% set(addDisplay.hline2,'Xdata',[xval_new xval_new],'Ydata',[yval_new-0.15 yval_new+0.15],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);

% disp('reached line 107 of timer function');
%% start of experiment when participant needs to move hand to home sphere
% if hand is in sphere for certain amount of time, turn target sphere on s
% and home sphere off
modeString = get(mainWindow.trialConditionsPanel.modePopUpMenu,'String');
modeValue = get(mainWindow.trialConditionsPanel.modePopUpMenu,'Value');
currentMode = modeString{modeValue};

if experiment.isBreakTime == 1
    experiment.currentBreakPeriod = toc(experiment.breakId);
    experiment.breakId = tic;
    experiment.breakTime = experiment.breakTime + experiment.currentBreakPeriod;
    if experiment.breakTime > 4
        judp.Write('table color blue');
        experiment.Start( mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay );
        experiment.isBreakTime = 0;
        experiment.breakTime = 0;
        experiment.currentBreakPeriod = toc(experiment.breakId);
    end
end

% disp('reached line 128 of timer function');

if experiment.isPreTrial == 1
    experiment.isRecordingData = 1;
	experiment.preTrialTime = experiment.preTrialTime + experiment.currentPeriod;
    maxPreTrialTime = str2double ( get( mainWindow.daqParametersPanel.maxPreTrialTimeEditBox, 'String' ) );
    if experiment.preTrialTime >= maxPreTrialTime
        experiment.isStartSetSelected = 0;
        experiment.isPreTrial = 0;
        experiment.Abort( mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp, addDisplay );
    end
    
    daqParametersPanel = mainWindow.daqParametersPanel;
    isDaqSwitchChecked = get( daqParametersPanel.daqSwitchCheckBox, 'Value' );
    isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
    
    


    % are finger tips in home sphere?
    % sphere equation is: (x-a)^2 + (y-b)^2 + (z-c)^2 = r^2
    if (display.fingerTipPosition(1) - display.home.position(chairPosition,1))^2 +...
            (display.fingerTipPosition(2) - display.home.position(chairPosition,2))^2 +...
            (display.fingerTipPosition(3) - display.home.position(chairPosition,3))^2 ...
             < (display.radius)^2  || ...
             ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
        %experiment.isPreTrial = 0;
        experiment.isInHome = 1;
        experiment.targetOnTime = experiment.preTrialTime; %When fingers enter the home sphere
%         disp('reached line 126 of timer function');
        if experiment.isHomeSphereWhite == 1
            disp('Home Reached!')
            judp.Write('home color green');
            disp('at home, should be green');
            %AM edit 10.8.19
            set(addDisplay.reachsign,'Visible','on')
            %end of AM edit
%             set(addDisplay.newCircle,'FaceColor','g'); %removing for now
%             disp('reached line 131 of timer function');
%%This changes the homeCircle to green when hand hovers above it
            %%%set(addDisplay.homeCircle,'FaceColor','g'); %green = [0 1 0.5]; red = [1 0 0.5]
           

            experiment.isHomeSphereWhite = 0;
        end
        if isDaqSwitchChecked == 1
            if isTtlChecked == 1
                ttl.Toggle([1 0 0 0]); %TTL to mark when fingers are first in in home sphere
%                ttl.Toggle([0 0 0 0]); %TTL to mark when fingers are first in in home sphere
            end
        end
        %disp('reached line 145 of timer function');
        display.home.iterationsInside = display.home.iterationsInside + 1;
        homeSphereTriggerTime = str2double( get( trialParameters.homeSphereTriggerTimeEditBox, 'String' ) );
        if display.home.iterationsInside >  timerFrequency*homeSphereTriggerTime ||...		% 2 seconds
            ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
            % make the home sphere invisible
            judp.Write('home visible off');
%             set(addDisplay.newCircle,'FaceColor','g'); %Testing to see if our circle target changes to blue once the green sphere disappears
            %%% added by AM while testing (09/11/19)
            set(addDisplay.homeCircle,'Visible','off'); %Testing to see if our circle target changes to blue once the green sphere disappears
            %%%
            disp(['In home for ', num2str(display.home.iterationsInside), ' iterations'])

            experiment.isPreTrial = 0;
            
            % Moved to Experiment for target to be on during start of experiment
%             if strcmp(currentMode,'Target')
%                 % make the target sphere visible
%                 %set( display.targetSphereHandle, 'Visible', 'on' );   % turn target sphere off
%                 judp.Write('target visible on');
%                 
%             end
            
            %set( display.fingerTipPositionTraceHandle, 'Visible','on' );
            % begin displaying the trace of the tip of the middle finger
            % send 'trace visible on'
            
            %judp.Write('trace visible on');
           
            %experiment.isRecordingData = 1;
            display.home.iterationsInside = 0;
            experiment.periodId = tic;
%             disp('reached line 208 of timer function');
			% set filename for emg data and start acquiring EMG data

% Commented out for Kacey 6/13/19			
%             if isDaqSwitchChecked == 1
%                 if isTtlChecked == 1
%                     ttl.Toggle([1 1 0 0]); % Mark the time in the home sphere
%                 end
%             end
            %experiment.targetOnTime = experiment.preTrialTime;
        end
        
    else
        if experiment.isHomeSphereWhite == 0
            judp.Write('home color white');
            disp('changed the newCircle to blue when home sphere turned white');
            %%%set(addDisplay.newCircle,'FaceColor','b');
            experiment.isHomeSphereWhite = 1;
%             disp('reached line 226 of timer function');
        end
        %display.home.iterationsInside = display.home.iterationsInside - 1;
        %display.home.iterationsInside = 0;
    end
end


%% during trial when recording data
if experiment.isRecordingData == 1  ||  experiment.isPreTrial == 1
    experiment.currentPeriod = toc(experiment.periodId);
    experiment.periodId = tic;
    %moved up, start recording current trial time at the beginning
    experiment.currentIteration = experiment.currentIteration + 1;
    experiment.RecordData(robot,display);
    experiment.currentTrialTime = experiment.currentTrialTime + experiment.currentPeriod;
%     disp('reached line 242 of timer function');
end
if experiment.isRecordingData == 1 && experiment.isPreTrial == 0
    daqParametersPanel = mainWindow.daqParametersPanel;
    isDaqSwitchChecked = get( daqParametersPanel.daqSwitchCheckBox, 'Value' );
    isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
%     if (display.fingerTipPosition(1) - display.home.position(chairPosition,1))^2 +...
%             (display.fingerTipPosition(2) - display.home.position(chairPosition,2))^2 +...
%             (display.fingerTipPosition(3) - display.home.position(chairPosition,3))^2 ...
%              > (display.radius)^2  || ...
%              ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
                experiment.isInHome = 1;
  
if experiment.isInHome == 1
            experiment.leaveHome = experiment.currentTrialTime; %Time when fingers leave the home sphere
            experiment.isInHome = 0;
            experiment.leftHome = 1;
         end
%          disp('reached line 260 of timer function');
% Commented out for Kacey 6/13/19
%          if isDaqSwitchChecked == 1
%              if isTtlChecked == 1
%                  ttl.Toggle([1 1 0 0]); %TTL to mark when finger tips leave the home sphere
%                  %judp.Write('home color white'); % Home sphere turns white when you move out of it
%              end
%          end
         
   % end
    % CHECKING IF TARGET IS REACHED
    %A.M. TO-DO: check where target location is getting set and how to make
    %sure that it is the home circle that is a % of arm length and not arm
    %angles - can print out the fingertip and target locations from TimerCallback to see if it
    %is actually inside the target when it looks like it's inside the
    %target on screen
    % Determing if target has been reached
    
    %//A.M. Testing by printing values 
%     print('FT Pos 1',display.fingerTipPosition(1))
%     print('FT Pos 2',display.fingerTipPosition(2))
%     print('FT Pos 3',display.fingerTipPosition(3))
%     print('Unknown 1',display.target.position(chairPosition,1))
%     print('Unknown 2',display.target.position(chairPosition,2))
%     print('Unknown 3',display.target.position(chairPosition,3))
%     %//
    
    
    if (display.fingerTipPosition(1) - display.target.position(chairPosition,1))^2 +...
            (display.fingerTipPosition(2) - display.target.position(chairPosition,2))^2 +...
            (display.fingerTipPosition(3) - display.target.position(chairPosition,3))^2 ...
             < (display.radius)^2 
         
         if experiment.leftHome == 1
            experiment.targetReached = experiment.currentTrialTime;
            experiment.reachedTarget = 1;
            disp('Target Reached!')
            experiment.leftHome = 0;
%             disp('reached line 298 of timer function');
         end
         
        display.target.iterationsInside = display.target.iterationsInside + 1;
        targetSphereTriggerTime = str2double( get( trialParameters.targetSphereTriggerTimeEditBox, 'String' ) );
        
        % Keep target sphere visible for alloted amount of time
        if display.target.iterationsInside >  timerFrequency*targetSphereTriggerTime ||...
            ( strcmp(currentMode,'Workspace')  &&  display.fingerTipPosition(3) > experiment.tableZ + 0.002 ) % caveat for heavy workspace loads
            % make the target sphere invisible
            judp.Write('target visible off');
            disp(['In target for ', num2str(display.target.iterationsInside), ' iterations'])
            display.target.iterationsInside = 0;
%             disp('reached line 311 of timer function');
        end
        
% Commented out for Kacey 6/13/19
%          if isDaqSwitchChecked == 1
%              if isTtlChecked == 1
%                  ttl.Toggle([1 1 1 0]); %TTL to mark when finger tips reach the target
%              end
%          end
    end
    
    % end experiment after a designated time has elapsed
    maxTrialDuration = str2double( get(trialParameters.maxTrialDurationEditBox,'String') );
    if ( experiment.currentTrialTime >= maxTrialDuration + experiment.preTrialTime)
        experiment.trialLength = experiment.currentTrialTime - experiment.currentPeriod;
        experiment.Terminate( mainWindow, display, trialParameters, emgChannels,...
            setTargets, nidaq, ttl, quanser, judp, addDisplay );
    end
    
    % edited 1/10/15
    %isSlantSelected = get( mainWindow.trialConditionsPanel.slantToggleButton, 'Value' );
    isLoadSelected = get( mainWindow.trialConditionsPanel.loadToggleButton, 'Value' );
    isSynergySelected = get( mainWindow.trialConditionsPanel.synergyToggleButton, 'Value' );
    %disp('reached line 299 of timer function');
    if (isLoadSelected == 1 || isSynergySelected == 1) && experiment.leftHome == 1
        % check to see if the person has their hand near the table when the
        % target is set to lift
        if experiment.tableZ + 0.003 >= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 0
            judp.Write('table color red');
            disp('should be red- not lifting sufficiently')
            %disp('reached line 306 of timer function');
%             set(addDisplay.newCircle,'FaceColor','r'); %don't change home
%             circle to red yet
%             setappdata(circleLift,'FaceColor',[1 0 0.5]) %Sabeen add for Kacey's circle to lift 5.29.19
            %Sabeen adding for Kacey to turn her circle red 5.29.19
            experiment.isArmCloseToTable = 1;
        elseif experiment.tableZ + 0.002 <= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 1
            judp.Write('table color blue');
%             disp('should be blue- IS lifting sufficiently')
%             set(addDisplay.newCircle,'FaceColor','b');
%             setappdata(circleLift,'FaceColor',[0 1 0.5]) %Sabeen add for Kacey's circle to lift 5.29.19
            %Sabeen adding for Kacey to turn her circle green 5.29.19
            experiment.isArmCloseToTable = 0;
%             disp('reached line 354 of timer function');
        end
%         homeEE = display.home.position(chairPosition,1) - display.upperArmLength - display.lowerArmLength - display.elbowToEndEffector;
%         currentEE = robot.endEffectorPosition(1);
%         angle = 10;
%         zdisplacement = (currentEE - homeEE)*cos(angle*pi/180);
%         
%         if experiment.tableZ + zdisplacement + 0.003 >= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 0
%             judp.Write('table color red');
%             experiment.isArmCloseToTable = 1;
%         elseif experiment.tableZ + zdisplacement + 0.002 <= robot.endEffectorPosition(3)  &&  experiment.isArmCloseToTable == 1
%             judp.Write('table color blue');
%             experiment.isArmCloseToTable = 0;
%         end
        if experiment.tableZ + 0.002 >= robot.endEffectorPosition(3)
            experiment.isArmOnTable = 1;
        else
            experiment.isArmOnTable = 0;
        end
%         disp('reached line 373 of timer function');
    end

end

% disp('reached line 378 of timer function');
display.RefreshDisplay(experiment, judp, arm );
% disp('reached line 380 of timer function');
end
classdef Experiment < handle
    %EXPERIMENT Summary of this class goes here
    %   Detailed explanation goes here
%         function obj = Experiment( timerFrequency, obj )
%         function obj = Start(obj, mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay )
%         function obj = Initialize(obj, trialConditionsPanel, experimentMenubar, experimentStatus )
    
    %% properties
    properties
        duration = 15;  % seconds
        currentIteration=0;
        currentPeriod = 0;
        currentTrialTime = 0; % time elapsed after the home sphere disappears
		preTrialTime = 0; % Maximum time allowed before trial starts
        isInHome = 0; %records whether fingers are in home 
        leftHome = 0; % records whether fingers have left home
        reachedTarget = 0; % records whether fingers have reached the target
        periodId = 0;
        iterationId = 0;
        isStartSetSelected = 0;
        tableZ = -0.051374;
        isArmCloseToTable = 0;
        isArmOnTable = 0;
        isRecordingData = 0;
        isPreTrial = 0;
        isHomeSphereWhite = 1;
        emgMaxesExcelHandle = 0;
        targetOnTime = 0; %time when home shpere turns green 
        leaveHome = 0; %time when home position is left
        targetReached = 0; %time when target is reached. If zero, target not reached
        trialLength = 0;
        isBreakTime = 0;
        currentBreakPeriod = 0;
        breakId = 0;
        breakTime = 0;
        
        condition = 2;
        shoulderABDMaxTrial = 0;
        
        % variables saved: sample, duration between current and previous samples,
        % xyz end effector position, xyz velocity, xyz force, xyz torque (removed),
        % shoulder flexion angle, elbow flexion angle, shoulder abduction
        % angle, xyz hand position, boolean telling if arm is on the table
        numberOfVariables = 19;
        
        totalIterations;
        data;% = zeros( 20, 15 );
        participantForce = zeros(3,3000);
        peakVelocity = 0;
        minSetVelocity = 0;
        maxSetVelocity = 0;
        meanSetVelocity = 0;
        velocity = [];
        
        maxDistance = 0;
        minSetDistance = 0;
        maxSetDistance = 0;
        meanSetDistance = 0;
        distance = [];
    end
    
    %% methods
    methods
        %% constructor
        function obj = Experiment( timerFrequency, obj )
            obj.totalIterations = obj.duration * timerFrequency;     % iterations for the duration of the experiment
            obj.data = zeros( obj.numberOfVariables, obj.totalIterations );
        end
        
        function delete(obj)
        end
        
        %% start experiment
      %%%  function obj = Start(obj, mainWindow, display, setTargets, nidaq, ttl, quanser, judp)
      %%%  A.M. Keeping addDisplay for now     
        function obj = Start(obj, mainWindow, display, setTargets, nidaq, ttl, quanser, judp, addDisplay)
            
            trialConditionsPanel = mainWindow.trialConditionsPanel;
            statusPanel = mainWindow.statusPanel;
            daqParametersPanel = mainWindow.daqParametersPanel;

            obj.Initialize(trialConditionsPanel,...
                mainWindow.experimentMenubar, mainWindow.statusPanel.secondColumn(10));
            
            % Determine Trial Condition
            obj.condition = get( mainWindow.protocolPanel.conditionEditBox, 'Value' );
            conditionString = get( mainWindow.protocolPanel.conditionEditBox, 'String' );
            
            
            % figure out and set filename
            modeString = get(trialConditionsPanel.modePopUpMenu,'String');
            modeValue = get(trialConditionsPanel.modePopUpMenu,'Value');
            currentMode = modeString{modeValue};
            
            trial = get( statusPanel.secondColumn(5), 'String' );
            if iscell(trial), trial = trial{1};  end
            
            percentAbdMax = get(trialConditionsPanel.percentAbductionMaxEditBox,'String');
            if ~isempty(percentAbdMax)
                percentAbdMax = num2str(round(str2double(percentAbdMax)));
                support = [ 'mvt_' percentAbdMax ];
            else
                support = 'table';
            end
            
            % set filename 
            % 1-15-16 added condition string to end of filename
            if obj.shoulderABDMaxTrial == 1
                filename = [ 'shoulderABDMax_' trial ];
            else
                filename = [ currentMode '_' trial '_' conditionString '_' support ];
            end
            
			% See if there is already a file with this name.  If so, warn
            % the user that starting a trial will overwrite that data.
            folder = get( statusPanel.secondColumn(11), 'String');
            if iscell(folder)
                folder = folder{1};
            end
            if exist([folder '\' filename '.mat'],'file') ~= 0
                default = 'Abort Trial';
                answer = questdlg('There is another trial with this filename',...
                    'Overwrite File',...
                    'Overwrite', 'Abort Trial', default);
                if strcmp( answer, 'Abort Trial' )
                    set( daqParametersPanel.filenameEditBox, 'String', '' );
                    obj.Shutdown(trialConditionsPanel, mainWindow.experimentMenubar, statusPanel.secondColumn(10) );
                    return;
                end
            end
            
            set( daqParametersPanel.filenameEditBox, 'String', filename );
            
			obj.Initialize(trialConditionsPanel,...
                mainWindow.experimentMenubar, statusPanel.secondColumn(10));
            
            %pause(10);  %pause time between trials
            
            % start emg acquisition
            % start to record EMG data and display the EMG data after the recoding is finished
            isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
            isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');

            if isQuanserChecked == 1
                quanser.Start;
            elseif isNidaqChecked == 1
                % No longer saving all DAQ files but this saves a log file each time (6/6/14)
                filename = get( mainWindow.daqParametersPanel.filenameEditBox, 'String' );
                folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
                if iscell(folder)
                    folder = folder{1};
                end
                %set(nidaq.analogInputObject, 'LogFileName', [ folder '\' filename '_emg.daq' ] );
                set(nidaq.analogInputObject, 'LogFileName', [ folder '\logfile_emg.daq' ] );
                nidaq.Start;
            end
            
            %%%Added by AM to send TTL so that Metria saves as soon as a
            %%%trial starts
            isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
            if isTtlChecked
                 ttl.Toggle([1 0 0 0]);
            end
            %%%


            % begin trial
            %pause(10);  %pause time between trials
            judp.Write('table color blue');
            judp.Write('home visible on');
            
            %AM 10.8.19 edit
%             set(addDisplay.newCircle.UserData.t,'Visible','off');
            set(addDisplay.reachsign,'Visible','off')
            
            %AM TO-DO: find out where the position properties of this are
            %set 9.24.19
            set(addDisplay.homeCircle,'Visible','on');
%             set(addDisplay.newCircle,'FaceColor','b');
            
            % add for target to be on at the start for target conditions
            if mod(obj.condition,2) == 0
                judp.Write('target visible on');
            end
            
            obj.isPreTrial = 1;
            obj.preTrialTime = 0;
            obj.periodId = tic;

        end
        
        %% initialize interface on experiment start
        function obj = Initialize(obj, trialConditionsPanel, experimentMenubar, experimentStatus )
            % enable abort button to allow for ending experiments early.  Disable all
            % other buttons that could affect the HapticMaster during the experiment
            set(trialConditionsPanel.startTrialPushButton,'Enable','off');
            set(trialConditionsPanel.startSetPushButton,'Enable','off');
            set(trialConditionsPanel.abortPushButton,'Enable','on');
            set(trialConditionsPanel.statePopUpMenu,'Enable','off');
            set(trialConditionsPanel.modePopUpMenu,'Enable','off');
            set(trialConditionsPanel.percentLimbSupportEditBox,'Enable','off');
            set(trialConditionsPanel.percentAbductionMaxEditBox,'Enable','off');
            set(trialConditionsPanel.horizontalToggleButton,'Enable','off');
            set(trialConditionsPanel.verticalToggleButton,'Enable','off');
            set(trialConditionsPanel.slantToggleButton,'Enable','off');
            set(trialConditionsPanel.loadToggleButton,'Enable','off');
            set(trialConditionsPanel.synergyToggleButton,'Enable','off');
            set(trialConditionsPanel.damperToggleButton,'Enable','off');
            set(trialConditionsPanel.coefficientEditBox,'Enable','off');
            set(experimentMenubar,'Enable','off');
            
            % "Experiment Running" is displayed as the experiment status
            set(experimentStatus,'String','Experiment Running');
            
        end
        
        % needed?
        function obj = RunWorkspace(obj)
            % --- NOT IMPLEMENTED YET ---
        end
        
        %% record data
        function obj = RecordData(obj, robot, display )
            % save: sample, period between current and previous sample,
            % xyz end effector position, xyz velocity, xyz force, xyz torque,
            % shoulder flexion angle, elbow flexion angle, shoulder abduction
            % angle, xyz hand position
            obj.data( 1, obj.currentIteration ) = obj.currentIteration;
            obj.data( 2, obj.currentIteration ) = obj.currentPeriod;
            obj.data( 3:5, obj.currentIteration ) = robot.endEffectorPosition;
            obj.data( 6:8, obj.currentIteration ) = robot.endEffectorVelocity;
            obj.data( 9:11, obj.currentIteration ) = robot.endEffectorForce;
            obj.data( 20:22, obj.currentIteration ) = robot.endEffectorTorque; % Added NH 1/17/16
            obj.data( 12, obj.currentIteration ) = display.shoulderFlexionAngle;    % do i use IK or end effector rotation from robot?
            obj.data( 13, obj.currentIteration ) = display.elbowAngle;
            obj.data( 14, obj.currentIteration ) = display.shoulderAbductionAngle;
            obj.data( 15, obj.currentIteration ) = robot.endEffectorRotation(1);
            obj.data( 16:18, obj.currentIteration ) = display.fingerTipPosition;
            %obj.data( 22:24, obj.currentIteration ) = display.shoulderPosition;
            obj.data( 19, obj.currentIteration ) = obj.isArmOnTable;
            
        end
        
        
        %% on experiment end
        %%%function obj = Terminate( obj, mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp)
        function obj = Terminate( obj, mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp, addDisplay )
            %addDisplay circle change should go back to blue (or whatever
            %color we decide). In order to do that, need to add
            %'addDisplay' as an input to the Terminate function
            trialConditionsPanel = mainWindow.trialConditionsPanel;
            statusPanel = mainWindow.statusPanel;
            daqParametersPanel = mainWindow.daqParametersPanel;            
            isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
            isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');
            
            %set(display.planeHandle,'FaceColor',[0.00, 0.66, 0.60]); % turn table back to blue
			% send 'table color blue'
			
            if obj.periodId ~= 0
                unusedVariable = toc(obj.periodId);
            end

            % isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
            % if isTtlChecked
            %     ttl.Toggle([0 0 1 0]);
            % end

            %set( display.fingerTipPositionTraceHandle, 'Visible','off' );
            % turn off the trace of the finger tip
            judp.Write('trace visible off');
            
            display.fingerTipPositionTrace = zeros(3,300);
            
            %set( display.targetSphereHandle, 'Visible', 'off' ); 
            %set( display.homeSphereHandle, 'Visible', 'off' ); 
            
            % turn off the target and home spheres in the display
            if mod(obj.condition,2) == 0
                judp.Write('target visible off');
            end
            judp.Write('home visible off');
            
            set(addDisplay.homeCircle,'Visible','off');
            
			%judp.Write('table color blue');
            judp.Write('table color gray');
			           
            % discard unused iterations
            if obj.currentIteration < obj.totalIterations
                try
                    obj.data( :, obj.currentIteration+1 : obj.totalIterations ) = [];
                catch
                end
            end
            
            % folder data is saved to
            folder = get( statusPanel.secondColumn(11), 'String');
            if iscell(folder)
                folder = folder{1};
            end
            
            % get filename
            filename = get( daqParametersPanel.filenameEditBox, 'String' );
            %filename = [ filename ];
            
            % Write haptic master data to file
            trialData = obj.data;
            rowLabels = {'current iteration'; 'current period'; 
                'end effector position x'; 'end effector position y'; 'end effector position z';...
                'end effector velocity x'; 'end effector velocity y'; 'end effector velocity z';... 
                'end effector force x'; 'end effector force y'; 'end effector force z';...
                'shoulder flexion angle'; 'elbow flexion angle'; 'shoulder abduction angle';...
                'end effector rotation';...
                'finger tip position x'; 'finger tip position y'; 'finger tip position z';...
                'is arm on table';'end effector torque x';'end effector torque y';'end effector torque z'};
                
            
            trialData = [rowLabels num2cell(trialData)];
            
            save([folder '\' filename],'trialData');
            
            % save target information
            chairPosition = str2double( get( statusPanel.secondColumn(12), 'String' ) );
            obj.SaveTargetData(display, chairPosition, folder, filename );
			
            isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
            pause(0.1);
                if isTtlChecked == 1
                    ttl.Toggle([0 0 0 0]);
                end

            % display EMG trial data in EMG channels window
            if isNidaqChecked == 1
                daqDeviceSelected = 'NI-DAQ';
            else
				daqDeviceSelected = 'Quanser';
            end
            
            
            trialNumber = str2double( get(statusPanel.secondColumn(5),'String') );
            
            %obj.DisplayEmgTrialData( daqDeviceSelected, nidaq, ttl, quanser, mainWindow, filename, emgChannels, trialNumber );
			isDaqSwitchChecked = get( mainWindow.daqParametersPanel.daqSwitchCheckBox, 'Value' );
            if isDaqSwitchChecked == 1 
                obj.DisplayEmgTrialData( daqDeviceSelected, nidaq, ttl, quanser, mainWindow, filename, emgChannels, trialNumber);
                      
            end
            
            newTrialNumber = obj.IncrementTrialNumber( trialNumber, statusPanel.secondColumn(5) );
            
			% compute and display the distance the subject reached (in %) from the home sphere to the target sphere
            % look in the analysis file
            [obj.maxDistance, reachPercentageValue] = obj.ComputeDistanceReached( display.home.position(chairPosition,:), display.target.position(chairPosition,:), obj.data(16:18,:) );
            reachPercentageString = num2str( reachPercentageValue, '%.2f' );
            set( statusPanel.secondColumn(3), 'String', reachPercentageString );
            
            % compute and display max reach distance
            obj.distance = [obj.distance,obj.maxDistance];
            obj.minSetDistance = min(obj.distance);
            obj.maxSetDistance = max(obj.distance);
            obj.meanSetDistance = mean(obj.distance);
            figure(32);
            subplot(1,2,1)
            plot([0,2],[obj.minSetDistance,obj.minSetDistance],'r', 'LineWidth',3); hold on
            plot([0,2],[obj.maxSetDistance,obj.maxSetDistance],'g', 'LineWidth',3);
            plot([0,2],[obj.meanSetDistance,obj.meanSetDistance],'k')
            plot(1,obj.maxDistance,'d',...
                                    'MarkerSize',15, ...
                                    'MarkerEdgeColor','c',...
                                    'MarkerFaceColor','c'); hold off
            axis([0,2,obj.minSetDistance-.05,obj.maxSetDistance+.05])
            %legend('Shortest','Longest','Average','Current')
            title(['Distance | Trial #: ',get(statusPanel.secondColumn(5),'String')])
            text(1.2,obj.maxDistance,[num2str(obj.maxDistance(1)),' cm'])
            
            % compute and display the peak velocity
            obj.peakVelocity = obj.ComputeVelocity(obj.data(2,:), obj.data(16:18,:) );
            obj.velocity = [obj.velocity,obj.peakVelocity];
            obj.minSetVelocity = min(obj.velocity);
            obj.maxSetVelocity = max(obj.velocity);
            obj.meanSetVelocity = mean(obj.velocity);
            figure(32);
            subplot(1,2,2)
            plot([0,2],[obj.minSetVelocity,obj.minSetVelocity],'r', 'LineWidth',3); hold on
            plot([0,2],[obj.maxSetVelocity,obj.maxSetVelocity],'g', 'LineWidth',3);
            plot([0,2],[obj.meanSetVelocity,obj.meanSetVelocity],'k')
            plot(1,obj.peakVelocity,'s',...
                                    'MarkerSize',15, ...
                                    'MarkerEdgeColor','b',...
                                    'MarkerFaceColor','b'); hold off
            axis([0,2,obj.minSetVelocity-.05,obj.maxSetVelocity+.05])
            %legend('Slowest','Fastest','Average','Current')
            title(['Speed | Trial #: ',get(statusPanel.secondColumn(5),'String')])
            text(1.2,obj.peakVelocity,[num2str(obj.peakVelocity(1)),' m/s'])
            
            % Performace Report
            
            if obj.peakVelocity >= obj.meanSetVelocity
               msgbox('Great speed!', 'Results','replace');
            end
            if obj.peakVelocity < obj.meanSetVelocity
               msgbox('Faster next time!', 'Results', 'replace');
            end
            
            
%             reachPercentageString = num2str( reachPercentageValue, '%.2f' );
%             set( statusPanel.secondColumn(3), 'String', reachPercentageString );
              disp(['Trial Number: ',get(statusPanel.secondColumn(5),'String')])
              disp(['Max Distance: ',num2str(obj.maxDistance(1)), ' cm'])
              disp(['Peak Velocity: ',num2str(obj.peakVelocity(1)), ' m/s'])
              disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
             
%               disp(['X Peak Velocity: ',num2str(obj.peakVelocity(1)), ' m/s'])
%               disp(['Y Peak Velocity: ',num2str(obj.peakVelocity(2)), ' m/s'])
              
            
            % Shutdown the trial and enable buttons on the interface
            obj.Shutdown(trialConditionsPanel, mainWindow.experimentMenubar, statusPanel.secondColumn(10) );
            
            % reset variables
            obj.data = zeros( obj.numberOfVariables, obj.totalIterations );
            obj.currentIteration = 0;
            obj.currentPeriod = 0;
            obj.isPreTrial = 0;
            obj.isRecordingData = 0;
            obj.currentTrialTime = 0;
            obj.isArmOnTable = 0;
            display.fingerTipPositionTraceIteration = 0;
            
            obj.isInHome = 0; 
            obj.leftHome = 0; 
            obj.reachedTarget = 0;
            obj.targetOnTime = 0;
            obj.leaveHome = 0;
            obj.targetReached = 0;
            obj.trialLength = 0;
            obj.shoulderABDMaxTrial = 0;

            
            maxPreTrialTime = str2double ( get( mainWindow.daqParametersPanel.maxPreTrialTimeEditBox, 'String' ) );
            maxTrialDuration = str2double( get(trialParameters.maxTrialDurationEditBox,'String') );
            remainingCollectionTime = maxPreTrialTime + maxTrialDuration - obj.trialLength;
            
            % ask to end experiment if trials completed equals total trials
            totalTrialsNumber = str2double( get(statusPanel.totalTrialsEditBox,'String') );
            if newTrialNumber >= totalTrialsNumber
				obj.RunMoreTrials( trialParameters.figureHandle, statusPanel.secondColumn(5), mainWindow.protocolPanel, folder );  
                obj.isStartSetSelected = 0;
                obj.velocity = [];
                obj.distance = [];
                
            else
                if obj.isStartSetSelected == 1
                    if isNidaqChecked == 1
                        %pause(10);
                        %obj.Start( mainWindow, display, setTargets, nidaq, ttl, quanser, judp );
                        
                        % Declare break time variable
                        obj.isBreakTime = 1;
                        obj.breakId = tic;
                        
                        %might not need this code anymore
%                         if  remainingCollectionTime >=10
%                             obj.Start( mainWindow, display, setTargets, nidaq, ttl, quanser, judp );
%                         else
%                             pause(10-remainingCollectionTime);
%                             obj.Start( mainWindow, display, setTargets, nidaq, ttl, quanser, judp );
%                         end
                    else
                        %pause(10);
                        %obj.Start( mainWindow, display, setTargets, nidaq, ttl, quanser, judp );
                        
                        % Declare break time variable
                        obj.isBreakTime = 1;
                        obj.breakId = tic;
                    end
                end
            end
        end
        
        
        
        function obj = SaveTargetData(obj, display, chairPosition, folder, filename )
            targetData{1,1} = 'home position';
            targetData{1,2} = 'home angles';
            targetData{1,3} = 'target position';
            targetData{1,4} = 'target angles';
            targetData{1,5} = 'shoulder position';
            targetData{1,6} = 'chair position';
            targetData{1,7} = 'target on time';
            targetData{1,8} = 'leave home time';
            targetData{1,9} = 'target reached time';
            targetData{1,10} = 'trialLength';
            targetData{1,11} = 'Peak Velocities';
            targetData{1,12} = 'Max Distances Reached';
            
            targetData{2,1} = display.home.position(chairPosition,1);
            targetData{3,1} = display.home.position(chairPosition,2);
            targetData{4,1} = display.home.position(chairPosition,3);
            
            targetData{2,2} = display.home.positionAngles(chairPosition,1);
            targetData{3,2} = display.home.positionAngles(chairPosition,2);
            targetData{4,2} = display.home.positionAngles(chairPosition,3);
            
            targetData{2,3} = display.target.position(chairPosition,1);
            targetData{3,3} = display.target.position(chairPosition,2);
            targetData{4,3} = display.target.position(chairPosition,3);
            
            targetData{2,4} = display.target.positionAngles(chairPosition,1);
            targetData{3,4} = display.target.positionAngles(chairPosition,2);
            targetData{4,4} = display.target.positionAngles(chairPosition,3);
            
            targetData{2,5} = display.shoulderPosition(chairPosition,1);
            targetData{3,5} = display.shoulderPosition(chairPosition,2);
            targetData{4,5} = display.shoulderPosition(chairPosition,3);
            
            targetData{2,6} = chairPosition;
            
            targetData{2,7} = obj.targetOnTime;
            targetData{2,8} = obj.leaveHome;
            targetData{2,9} = obj.targetReached;
            targetData{2,10} = obj.trialLength;
            
            targetData{2,11} = obj.peakVelocity(1);
            obj.peakVelocity = 0;
            targetData{2,12} = obj.maxDistance(1);                    
            obj.maxDistance = 0;
            
            save([folder '\' filename '_target'], 'targetData');
            
        end
        
        
		function obj = Abort(obj, mainWindow, display, trialParameters, emgChannels, setTargets, nidaq, ttl, quanser, judp, addDisplay )
            disp('aborted');
            trialConditionsPanel = mainWindow.trialConditionsPanel;
            statusPanel = mainWindow.statusPanel;
            daqParametersPanel = mainWindow.daqParametersPanel;
			isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
            isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');
            
            if obj.periodId ~= 0
                unusedVariable = toc(obj.periodId);
            end
            
            %set( display.fingerTipPositionTraceHandle, 'Visible','off' );
            % turn off the trace of the finger tip
            judp.Write('trace visible off');
            
            display.fingerTipPositionTrace = zeros(3,300);
            
            %set( display.targetSphereHandle, 'Visible', 'off' ); 
            %set( display.homeSphereHandle, 'Visible', 'off' ); 
            % turn off the target and home spheres in the display
%             judp.Write('target visible off');
%             judp.Write('home visible off');
% 			judp.Write('table color blue');
            
            %change table to gray at end of trial
            judp.Write('table color gray');
			           
            % discard unused iterations
            if obj.currentIteration < obj.totalIterations
                try
                    obj.data( :, obj.currentIteration+1 : obj.totalIterations ) = [];
                catch
                end
            end
            
            isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
            if isTtlChecked ==1
                ttl.Toggle([0 0 0 0]);
            end
            % Shutdown the trial and enable buttons on the interface
            obj.Shutdown(trialConditionsPanel, mainWindow.experimentMenubar, statusPanel.secondColumn(10) );
            
            % reset variables
            obj.data = zeros( obj.numberOfVariables, obj.totalIterations );
            obj.currentIteration = 0;
            obj.currentPeriod = 0;
            obj.isPreTrial = 0;
            obj.isRecordingData = 0;
            obj.currentTrialTime = 0;
            obj.isArmOnTable = 0;
            display.fingerTipPositionTraceIteration = 0;
			
            obj.isInHome = 0; 
            obj.leftHome = 0; 
            obj.reachedTarget = 0;
            obj.targetOnTime = 0;
            obj.leaveHome = 0;
            obj.trialLength = 0;
            obj.shoulderABDMaxTrial = 0;
            
			% stop DAQ
            isDaqSwitchChecked = get( mainWindow.daqParametersPanel.daqSwitchCheckBox, 'Value' );
            if isDaqSwitchChecked == 1 
                % If Quanser
                if isQuanserChecked == 1
                    quanser.Stop;
                end
                % If Nidaq
                if isNidaqChecked == 1
                    nidaq.Stop;
                end
            end
            
            obj.isStartSetSelected = 0;
            
            disp('Trial aborted');
        end
        
        
        function obj = Shutdown(obj, trialConditionsPanel, experimentMenubar, experimentStatus)
            set(trialConditionsPanel.startTrialPushButton,'Enable','on');
            set(trialConditionsPanel.startSetPushButton,'Enable','on');
            set(trialConditionsPanel.abortPushButton,'Enable','off');
            set(trialConditionsPanel.statePopUpMenu,'Enable','on');
            set(trialConditionsPanel.modePopUpMenu,'Enable','on');
            set(trialConditionsPanel.percentLimbSupportEditBox,'Enable','on');
            set(trialConditionsPanel.percentAbductionMaxEditBox,'Enable','on');
            set(trialConditionsPanel.horizontalToggleButton,'Enable','on');
            set(trialConditionsPanel.verticalToggleButton,'Enable','on');
            set(trialConditionsPanel.slantToggleButton,'Enable','on');
            set(trialConditionsPanel.loadToggleButton,'Enable','on');
            set(trialConditionsPanel.damperToggleButton,'Enable','on');
            set(trialConditionsPanel.coefficientEditBox,'Enable','on');
            
            set(experimentMenubar,'Enable','on');
            
            % "Trial complete" is displayed as the experiment status in the status panel in the main window
            set(experimentStatus,'String','Trial Complete');
        end
        
        
        %% save text document outlining the experimental protocol
        function obj = SaveProtocol(obj,protocolPanel, folder )
            
            experimentalVariables = get(protocolPanel.experimentalVariablesListbox,'String');
            values = get( protocolPanel.valuesEditBox, 'userData' );
            values = struct2cell(values);
            
            fid = fopen([folder '\experimental_protocol.txt'], 'a');
            
            for j = 1 : length(experimentalVariables)
                
                fprintf(fid, '%s:\r\n',experimentalVariables{j});
                switch experimentalVariables{j}
                    
                    case '% support'
                        limbSupportValues = values{1};
                        for k=1:length(limbSupportValues)
                            fprintf( fid, '%s\r\n', limbSupportValues{k} );
                        end
                        fprintf( fid, '\n' );
                        
                    case 'viscosity'
                        viscosityValues = values{2};
                        for k=1:length(viscosityValues)
                            fprintf( fid, '%s\n', viscosityValues{k} );
                        end
                        fprintf( fid, '\n' );
                        
                    case 'target (cm)'
                        targetValues = values{3};
                        for k=1:length(targetValues)
                            fprintf( fid, '%s\n', targetValues{k} );
                        end
                        fprintf( fid, '\n' );
                        
                    otherwise
                        disp('too many experimental variables');
                end
            end
            fprintf(fid, '-------------------------\r\n\r\n');
            fclose(fid);
            
        end
        
        function [ newTrialNumber, obj ] = IncrementTrialNumber( obj, trialNumber, trialStatus )
            % trials completed is incremented and replaced - precision
            % should always be two digits
            newTrialNumber = trialNumber + 1;
            newTrialNumberString = num2str( newTrialNumber, '%02.2d' );
            set( trialStatus, 'String', newTrialNumberString );
        end


		function [ maxValue, reachPercentage, obj ] = ComputeDistanceReached( obj, homePosition, targetPosition, fingerTipPosition )
            homeToTargetDistance = norm(targetPosition(1:2) - homePosition(1:2));

            iterations = length(fingerTipPosition(1,:));
            homePositionRepeated = [];
            homePositionRepeated(1,:) = repmat(homePosition(1),1,iterations);
            homePositionRepeated(2,:) = repmat(homePosition(2),1,iterations);
            distance_xy = fingerTipPosition(1:2,:) - homePositionRepeated(1:2,:);
            distanceMagnitude = zeros(iterations,1);
            for j = 1 : iterations
                distanceMagnitude(j) = norm( distance_xy(:,j) );
            end
            
            [maxValue, maxIteration] = max(distanceMagnitude);
            
            reachPercentage = maxValue / homeToTargetDistance * 100;
            maxValue = maxValue*100;
        end
        
        function [ peakVelocity, obj ] = ComputeVelocity( obj, deltaT, fingerTipPosition )
            
            tempTime = 0;
            index = 0;
              for i = 2:length(deltaT)
                  time(i-1) = tempTime + deltaT(i-1);
                  tempTime = time(i-1);
                  
                  if tempTime >= obj.targetOnTime && index == 0
                      index = i;
                  end
                      
                  velocityX = abs(fingerTipPosition(1,i)-fingerTipPosition(1,i-1))/deltaT(i);
                  velocityY = abs(fingerTipPosition(2,i)-fingerTipPosition(2,i-1))/deltaT(i);
                  velocityZ = abs(fingerTipPosition(3,i)-fingerTipPosition(3,i-1))/deltaT(i);
                  velocity(:,i-1) = norm([velocityX velocityY]);
              end
            
%             [xPeakVelocity, maxXIteration] = max(velocity(1,index:end));
%             [yPeakVelocity, maxYIteration] = max(velocity(2,index:end));
%             [zPeakVelocity, maxZIteration] = max(velocity(3,index:end));
            
            [peakVelocity, maxIteration] = max(velocity(1,index:end));
            
%             figure(30)
%             subplot(2,1,1)
%             plot(velocity(1,index:end))
%             hold on
%             plot(maxXIteration,xPeakVelocity,'r*')
%             title('X Peak Velocity')
%             hold off
%             
%             subplot(2,1,2)
%             plot(velocity(2,index:end))
%             hold on
%             plot(maxYIteration,yPeakVelocity,'r*')
%             title('Y Peak Velocity')
%             hold off
            
            figure(31)
            plot(velocity(1,index:end))
            hold on
            plot(maxIteration,peakVelocity,'r*')
            title('Peak Velocity')
            hold off
            
%             peakVelocity = [xPeakVelocity; yPeakVelocity; zPeakVelocity];
           
        end

		function obj = RunMoreTrials( obj, trialParametersFigure, trialStatus, protocolPanel, folder )
            
            % ask user if they want to run more trials
            default = 'No';
            answer = questdlg('You have completed the designated number of trials.  Would you like to run more trials for this condition?', ...
                'Trials are finished',...
                'Yes', 'No', default);
            if strcmp(answer,'No')
                
                % set trials completed to 0
                set( trialStatus, 'String','00' );
                obj = obj.SaveProtocol(protocolPanel, folder );
            else
                disp('Please increase the max trial number');
            end
            
        end

        
		function obj = DisplayEmgTrialData( obj, daqDeviceSelected, nidaq, ttl, quanser, mainWindow, filename, emgChannels, trialNumber )
            daqParametersPanel = mainWindow.daqParametersPanel;
            isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
            isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');
            if isQuanserChecked ==1;
            %if strcmp(daqDeviceSelected,'Quanser') %#ok<ALIGN>
			    quanser.Stop;
			    [ data, samples_read ] = quanser.ReadData;
			    data = data';
			    t = ( 1 : length(data(:,1)) ) / quanser.frequency;
			    
			    % save data
			    % folder
			    folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
			    if iscell(folder)
			        folder = folder{1};
			    end
			
			    save( [folder '\' filename '_emg' ], 'data' );
			
			else  % nidaq
			    nidaq.Stop;
                % added to determine how many samples have been acquired
                [data,t] = getdata(nidaq.analogInputObject,nidaq.analogInputObject.SamplesAcquired);
                %samplingRate = str2double( get( mainWindow.daqParametersPanel.samplingRateEditBox, 'String' ) );
               	%maxTrialDuration = str2double( get( trialParameters.maxTrialDurationEditBox, 'String' ) );
                %[data,t] = getdata(nidaq.analogInputObject,maxTrialDuration*samplingRate);
                
                
                %data=[];
                
                % save data
			    % folder
                folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
			    if iscell(folder)
			        folder = folder{1};
			    end
			
			    save( [folder '\' filename '_nidaq_emg.mat' ], 'data' );
            end
            
            samplingRate = str2double( get( mainWindow.daqParametersPanel.samplingRateEditBox, 'String' ) );
            meandata = obj.meanfilt( abs(data), 0.25*samplingRate );
            % meandata=data;
            
            for i=1:size(data,2)
                
                % clear selected axes
                cla(emgChannels.axis(i));
                
                % plot emg data on axes using line
                axes(emgChannels.axis(i));
                line(t,data(:,i));
                hold on

                % label axes with max of emg data and max of filtered emg data
                maxRawData = max(abs(data(:,i)));
                maxFilteredData = max(meandata(:,i));
                plot(obj.leaveHome,-maxRawData:.01:maxRawData,'r');
                x = length(data(:,1))/samplingRate*0.4;
                y = maxRawData;
                text( x,y, num2str(maxRawData,'%6.4f') );
                x = length(data(:,1))/samplingRate*0.8;
                text( x,y, num2str(maxFilteredData,'%6.4f') );
            end
            drawnow
            
            % if emg maxes is selected
           %{
            isSelected = get( emgMaxesCheckBox, 'Value' );
            if isSelected == 1

                rowString = num2str(trialNumber+1);
                % try to write
                try
                    rc=ddepoke(obj.emgMaxesExcelHandle,['r1c' rowString ':r1c' rowString],['trial' rowString]);
                    crange=['r2c' rowString ':r' num2str(size(data,2)+1) 'c' rowString];
                    rc=ddepoke(obj.emgMaxesExcelHandle,crange,max(abs(data))');
                % if failed, uncheck emg maxes box
                catch
                    set( emgMaxesCheckBox, 'Value',0 );
                end
               
            end
             %}
            
        end
        
        
        function [y,obj] = meanfilt(obj,x,n)
            
            %MEANFILT  One dimensional mean filter.
            %   Y = MEANFILT(X,N) returns the output of the order N, one dimensional
            %   moving average 2-sided filtering of vector X.  Y is the same length
            %   as X;
            %
            %   If you do not specify N, MEANFILT uses a default of N = 3.
            
            %   Author(s): Ana Maria Acosta, 2-26-01
            
            if nargin < 2
                n=3;
            end
            if all(size(x) > 1)
                y = zeros(size(x));
                for i = 1:size(x,2)
                    y(:,i) = obj.meanfilt(x(:,i),n);
                end
                return
            end
            
            % Two-sided filtering to avoid phase shifts in the output
            y=obj.filter22(ones(n,1)/n,x,2);
            
            % transpose if necessary
            if size(x,1) == 1  % if x is a row vector ...
                y = y.';
            end
            
        end
    end
    methods (Static)
        function y = filter22(fil,x,numsides)
            %
            %	THIS FUNCTION PERFORMS 2-SIDED AS WELL AS ONE SIDED
            % 	FILTERING.  NOTE THAT FOR A ONE-SIDED FILTER, THE
            %	FIRST length(fil) POINTS ARE GARBAGE, AND FOR A TWO
            %	SIDED FILTER, THE FIRST AND LAST length(fil)/2
            %	POINTS ARE USELESS.
            %
            %	USAGE	: y = filter22(fil,x,numsides)
            %
            % EJP Jan 1991
            %
            [ri,ci]= size(x);
            if (ci > 1)
                x = x';
            end
            numpts = length(x);
            halflen = ceil(length(fil)/2);
            if numsides == 2
                xxx=zeros(size(1:halflen))';
                x = [x ; xxx];
                y = filter(fil,1,x);
                y = y(halflen:numpts + halflen - 1);
            else
                y=filter(fil,1,x);
            end
            if (ci > 1)
                y = y';
            end
            
        end
    end
end
    




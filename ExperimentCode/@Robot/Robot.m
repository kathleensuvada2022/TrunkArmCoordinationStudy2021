%% Robot class to access the HapticMaster
%{
% function call prototypes
className = Robot;
className.Connect()         % robot connects when class is created
className.Disconnect()      % robot disconnects when class is deleted
className.SetForceGetInfo( [ 0 0 0] ) OR className.SetForceGetInfo()
className.SwitchState('off')
className.SetExternalForce([0 0 0])
className.SetInertia( 8.0 )
%}

%% class definition
classdef Robot < handle
    
    %% class variables
    properties ( Access = public )   % Used outside class. Listeners update the displayed values.
        deviceId = 0;
%         act3d = 'ACT3D36'; % default device but this gets set when robot class is created by passing IP address as argument
        % Revise code to remove condition from actions below
        externalForce = [0, 0, 0];
        currentState = 'off';
        inertia = 6;
        endEffectorPosition = [0, 0, 0];
        endEffectorVelocity = [0, 0, 0];
        endEffectorForce = [0, 0, 0];
        endEffectorTorque = [0, 0, 0];
        endEffectorRotation = [0, 0, 0];
        
        isBiasForceCreated = 0;
        isSpringCreated = 0;
        isDamperCreated = 0;
        springPosition = [0,0,0];
        id
        ipAddress
        hapticlib
%         room = 'MC Lab/10.30.203.36';
        CreateStruct = struct('Interpreter','tex','WindowStyle','modal');
    end
    %% events
    events
        DeviceIdChange      % when device id changes, give new value to haptic table class
    end
    %% class functions
    methods
        % constructor
        function obj = Robot(id)
            
            % AMA - Assume in NI lab
            % define ip address and which library version to load based on which room we are in
            obj.id = id;

            if strcmp(obj.id,'ACT3D26')
%                 obj.ipAddress = '10.30.203.26'; 26 is currently in the Biodex lab
%                 obj.ipAddress=ipaddress;
%                 obj.id=['ACT3D' obj.ipAddress(end-1:end)];disp(obj.id)
                addpath HapticAPI2pt5
                obj.ipAddress = '10.30.203.26';  % default IP address. Other device is 10.30.203.26
                obj.hapticlib='HapticAPI';
                if ( libisloaded('HapticAPI') ), unloadlibrary('HapticAPI'); end
                loadlibrary( 'HapticAPI' , 'HapticAPI.h' );
                % load functions to communicate to the hapticMaster in from the library
            else  % MC Lab/10.30.203.36 36 is currently in NI lab
%                 obj.ipAddress = '10.30.203.36';
                addpath HapticAPI2
                obj.ipAddress = '10.30.203.36';  % default IP address. Other device is 10.30.203.26
                obj.hapticlib='HapticAPI2';
                if ( libisloaded('HapticAPI2') ), unloadlibrary('HapticAPI2'); end
                loadlibrary( 'HapticAPI2' , 'HapticAPI2.h' );

            end
%             if libisloaded(obj.hapticlib), unloadlibrary([obj.hapticlib '.h']); end
%             loadlibrary( obj.hapticlib , [obj.hapticlib '.h'] );
%             
        
            % connect to the HapticMaster
            obj.Connect();
            
            % switch to off - AMA - This doesn't do anything. Don't call
            % SwitchState
%             obj.SwitchState('off');
            
        end
        
        
        % destructor
        function delete(obj)
            obj.RemoveAllHapticEffects;
%             obj.SwitchState('off');
            obj.Disconnect;
            unloadlibrary(obj.hapticlib);
%             if strcmp( obj.room, 'MC Lab/10.30.203.36' )
%                 unloadlibrary('HapticAPI2');
%             else
%                 unloadlibrary('HapticAPI');
%             end
        end
        
        
        % Connect to HapticMaster
        function obj = Connect(obj)
                if obj.deviceId > 0
                    warndlg(['\fontsize{12}Already connected to HapticMaster ',num2str(obj.deviceId),' at ',obj.ipAddress],'ACT3D-TACS',obj.CreateStruct);
                else
                    if strcmp(obj.id,'ACT3D36')
                        [obj.deviceId, obj.ipAddress] = calllib( obj.hapticlib, 'haOpenDevice', obj.ipAddress );
                    else
                        [obj.deviceId, obj.ipAddress] = calllib( obj.hapticlib, 'haDeviceOpen', obj.ipAddress );
                    end    
                end
                if (obj.deviceId ~= -1)
%                     fprintf('Connected to HapticMaster [%d] at %s \n', obj.deviceId, obj.ipAddress));
                    msgbox({'\fontsize{12}Connected to HapticMaster';['Device ID: ', num2str(obj.deviceId)];['IP Address: ', obj.ipAddress]},'ACT3D-TACS',obj.CreateStruct)
                else
                    errordlg('\fontsize{12}Robot.Connect: Unable to connect to device','ACT3D-TACS',obj.CreateStruct);
                end
        end
        
        
        % Disconnect from HapticMaster
        function obj = Disconnect( obj )
            if obj.deviceId > 0
                % AMA - REVISE TO ACCOUNT FOR THE OTHER ACT3D (IP ENDING IN
                % 26)
                if strcmp(obj.id,'ACT3D36')
                    isClosed = calllib( obj.hapticlib, 'haCloseDevice', obj.deviceId );
                else
                    isClosed = calllib( obj.hapticlib, 'haDeviceClose', obj.deviceId );
                end                    
                notify(obj,'DeviceIdChange');   % give new device id to haptic table class
                if isClosed, warndlg('\fontsize{12}Robot.Disconnect: Disconnected from HapticMaster','ACT3D-TACS',obj.CreateStruct);
                else msgbox(['\fontsize{12}Robot.Disconnect: Not cleanly disconnected from HapticMaster ', num2str(obj.deviceId)],'ACT3D-TACS',obj.CreateStruct);
                end
                obj.deviceId=0;
            else
                warndlg('\fontsize{12}Robot.Disconnect: Already disconnected from HapticMaster','ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        % remove all haptic effects of the device
        function obj = RemoveAllHapticEffects(obj)
            if obj.deviceId > 0
                [retVal, response] = haSendCommand( obj.deviceId, 'remove all' );
%                 if (retVal == 0)
%                     disp (response);
%                 else
                if retVal
                    errmsg (['\fontsize{12}Robot.RemoveAllHapticEffects: ' response],'ACT3D-TACS',obj.CreateStruct);
                end
            end
        end

        
        % Get current state, inertia, and end effector
        % position, velocity, force, torque, and rotation 
        function obj = SetForceGetInfo( obj, arm )
            [retVal, response] = haSendCommand( obj.deviceId, 'get state' );
            if strcmp(obj.id,'ACT3D26') 
                response=obj.ParseResponse(response);
            end
            if (retVal == 0)
%                 if strcmp(response,'stop') % could switch to position (stop disables everything)
%                     obj.currentState = 'fixed';
%                 elseif strcmp(response,'init')
%                     obj.currentState = 'initialized';
%                 elseif strcmp(response,'force');
%                     obj.currentState = 'normal';
%                 else
%                     obj.currentState = response;
%                 end
                switch response
                    case 'stop'
                        obj.currentState = 'fixed';
                    case 'init'
                        obj.currentState = 'initialized';
                    case 'force'
                        obj.currentState = 'normal';
                    otherwise
                        obj.currentState = response;
                end
            else
                errordlg(['\fontsize{12}Robot.SetForceGetInfo: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get inertia
            [retVal, response] = haSendCommand( obj.deviceId, 'get inertia' );
            %disp('Robot inertia')
            if strcmp(obj.id,'ACT3D26') 
                response=obj.ParseResponse(response);
            end
            if (retVal == 0)
                obj.inertia = eval(response);
            else
                errordlg(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get end effector position
            [retVal, response] = haSendCommand( obj.deviceId, 'get measpos' );
            %disp('Robot pos')
            if (retVal == 0)
                obj.endEffectorPosition = eval(response);
            else
                msgbox(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get end effector velocity
            [retVal, response] = haSendCommand( obj.deviceId, 'get modelvel' );
            %disp('Robot velocity')
            if (retVal == 0)
                obj.endEffectorVelocity = eval(response);
            else
                msgbox(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get force being applied on the haptic master
            [retVal, response] = haSendCommand( obj.deviceId, 'get measforce' );
            %disp('Robot force')
            if (retVal == 0)
                obj.endEffectorForce = eval(response);
            else
                msgbox(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get end effector torque
            
            [retVal, response] = haSendCommand( obj.deviceId, 'get meastorque' );
            %disp('Robot torque')
            if (retVal == 0)
                obj.endEffectorTorque = eval(response);
            else
                msgbox(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % get end effector rotation in the plane parallel to the floor
            [retVal, response] = haSendCommand( obj.deviceId, 'get pot1dir' );
            %disp('Robot rotation')
            if (retVal == 0)
                tempEndEffectorRotation = eval(response);
            else
                msgbox(['\fontsize{12}Robot.SetForceGetInfo): ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            % TEMP - if the robot is ACT3D36, convert from
            % degrees to radians.  After converting the real time software,
            % you will have to convert to rads no matter which ACT3D you are using.
            if strcmp(obj.id,'ACT3D26') 
                tempEndEffectorRotation = tempEndEffectorRotation * pi/180; % Make sure this is in the code for ACT3D36
            end
            
            % temporary for angled planes - since you have to rotate the
            % gimbal when using a different arm, you must define the end
            % effector rotation correctly
            % AMA 11/23/20 Commented this out, it was not doing anything.
            % Arm is included in the hand position calculation and the
            % angle here is continuous.
%             if strcmp(arm,'Right')
%                 obj.endEffectorRotation = -tempEndEffectorRotation;
%             else
             obj.endEffectorRotation = tempEndEffectorRotation;
%             end
        end
        
        
        % switch and return state of the HapticMaster
        function obj = SwitchState( obj, newState )
            % state names have changed between API versions
%             if strcmp(newState,'fixed')
%                 newState = 'stop'; % could switch to position (stop disables everything)
%             elseif strcmp(newState,'initialized')
%                 newState = 'init';
%             elseif strcmp(newState,'normal')
%                 newState = 'force';
%             end
            obj.currentState = newState;
            switch obj.currentState
                case 'fixed'
                    [retVal, response] = haSendCommand( obj.deviceId, 'set state stop' );
                    % bug fix: re-enable myBiasForce
                    [retVal2, response2] = haSendCommand( obj.deviceId, 'set myBiasForce enable' );
%                     disp(response2)
%                     if (retVal2 == 0), disp (response2);
                    if retVal2
                        msgbox(['\fontsize{12}Robot.SwitchState: ' response2],'ACT3D-TACS',obj.CreateStruct);
%                         disp(response2);
                    end
                case 'initialized'
                    [retVal, response] = haSendCommand( obj.deviceId, 'set state init' );
                case 'normal'
                    [retVal, response] = haSendCommand( obj.deviceId, 'set state force' );
            end
%             disp('Robot set state')
            if strcmp(obj.id,'ACT3D26') 
                response=obj.ParseResponse(response);
            end
            if (retVal ~= 0), msgbox(['\fontsize{12}Robot.SwitchState: ' response],'ACT3D-TACS',obj.CreateStruct); end
            
        end
        
        
        % Set the external force on the end effector
        function obj = SetExternalForce( obj, externalForce )
            [retVal, response] = haSendCommand( obj.deviceId,...
                ['set myBiasForce force [' num2str(externalForce(1)) ',' num2str(externalForce(2)) ',' num2str(externalForce(3)) ']'] );
%             if (retVal == 0)
% %                 disp(response);
%             else
            if retVal
                msgbox(['\fontsize{12}Robot.SetExternalForce: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        % Set inertia of the HapticMaster
        function obj = SetInertia( obj, inertia )
            [retVal, response] = haSendCommand( obj.deviceId, ['set inertia ' num2str(inertia)] );
%             if (retVal == 0)
% %                 fprintf( 'Inertia is now %4.2f kg*m^2 \n', inertia );
%             else
            if retVal
                msgbox(['\fontsize{12}Robot.SetInertia: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        function obj = CreateBiasForce(obj)
            % create biased force and initialize it to 0
            [retVal, response] = haSendCommand( obj.deviceId, 'create biasforce myBiasForce' );
            if (retVal ~= 0)
                msgbox(['\fontsize{12}Robot.CreateBiasForce: ' response],'ACT3D-TACS',obj.CreateStruct);
            else
                obj.isBiasForceCreated = 1;
%                 disp(response);
            end
            
            pause(1);
            
            [retVal, response] = haSendCommand( obj.deviceId, 'set myBiasForce enable' );
            if (retVal ~= 0), msgbox(['\fontsize{12}Robot.CreateBiasForce: ' response],'ACT3D-TACS',obj.CreateStruct); end
            
            pause(1);
            
            [retVal, response] = haSendCommand( obj.deviceId, 'set myBiasForce force [0,0,0]' );
            if (retVal ~= 0)
                msgbox(['\fontsize{12}Robot.CreateBiasForce: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
            
            
        end
        
        
        %% spring functions
        function obj = CreateSpring(obj)
            % create
            [retVal, response] = haSendCommand( obj.deviceId, 'create spring mySpring' );
            if (retVal == 0)
                disp('spring created');
                obj.isSpringCreated = 1;
            else
                disp (['--- ERROR: ' response]);
            end
            
            % set stiffness
            [retVal, response] = haSendCommand( obj.deviceId, 'set mySpring stiffness 20000.0' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
            
            % set deadband - pulls to a range of 1 mm
            [retVal, response] = haSendCommand( obj.deviceId, 'set mySpring deadband 0.001' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
            
            % set damping factor - no overshoot
            [retVal, response] = haSendCommand( obj.deviceId, 'set mySpring dampfactor 1.0' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        
        % Set Spring Position
        function obj = SetSpringPosition(obj,springPosition)
            [retVal, response] = haSendCommand( obj.deviceId,...
                ['set mySpring pos [' num2str(springPosition(1)) ',' num2str(springPosition(2)) ',' num2str(springPosition(3)) ']'] );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        
        % set max force of spring
        function obj = SetSpringMaxForce(obj,maxForce)
            [retVal, response] = haSendCommand( obj.deviceId, ['set mySpring maxforce ' num2str(maxForce)] );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        
        % enable spring
        function obj = EnableSpring(obj)
            % enable
            [retVal, response] = haSendCommand( obj.deviceId, 'set mySpring enable' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        
        % disable spring
        function obj = DisableSpring(obj)
            [retVal, response] = haSendCommand( obj.deviceId, 'set mySpring disable' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        %% damper functions
        function obj = CreateDamper(obj)
            [retVal, response] = haSendCommand( obj.deviceId, 'create damper myDamper' );
            if (retVal == 0)
                disp('spring created');
                obj.isDamperCreated = 1;
                disp(response);
            else
                disp (['--- ERROR: ' response]);
            end
        end
        
        function obj = EnableDamper(obj)
            [retVal, response] = haSendCommand( obj.deviceId, 'set myDamper enable' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
            
        function obj = SetDamperCoefficient(obj,damperCoefficient)
            [retVal, response] = haSendCommand( obj.deviceId,...
                ['set myDamper dampcoef [' num2str(damperCoefficient(1)) ',' num2str(damperCoefficient(2)) ',' num2str(damperCoefficient(3)) ']'] );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        function obj = DisableDamper(obj)
            [retVal, response] = haSendCommand( obj.deviceId, 'set myDamper disable' );
            if (retVal ~= 0), disp (['--- ERROR: ' response]); end
        end
        
        function [newResponse, obj] = ParseResponse(obj, response)
            responseEnd=find(response==';');
            newResponse=response(1:responseEnd-1);
        end
    end
    
    
end

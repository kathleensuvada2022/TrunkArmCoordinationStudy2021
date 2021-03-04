% class for haptic effect
%{

% function prototypes
className = Haptic;
className.Create() OR className.Create( position, size )     % Effect is created when class is created
className.delete()
className.Enable()
className.Disable()

%}
% AMA 3/11/20 - Changed disp to msgbox and errodlg

classdef Haptic < handle  %make robot a parent
    properties
        isHorizontalCreated = 0;
        isHorizontalEnabled = 0;
        horizontalName = 'horizontalEffect';
        horizontalPosition = [ 0.0, 0.0, -0.1 ];
        horizontalSize = [ 2, 2, 0.1 ];
        
        isVerticalCreated = 0;
        isVerticalEnabled = 0;
        verticalName = 'verticalEffect';
        verticalPosition = [0 0.4 0];
        verticalSize = [0.5,0.05,0.5];
        
        horizontalAngle = 0;        % in degrees
        blockStiffness = 20000;     % Block stiffness
        deviceId = 0;
        deviceIdListenerHandle;
        room;
        CreateStruct = struct('Interpreter','tex','WindowStyle','modal');
    end
    
    methods
        function obj = Haptic( robot, obj )
%             obj.room=robot.room;
            obj.deviceId = robot.deviceId;
            obj.deviceIdListenerHandle = addlistener( robot, 'DeviceIdChange', @Haptic.UpdateDeviceId );
        end
        
        function delete(obj)
            delete(obj.deviceIdListenerHandle);
            
            % remove both haptic effects
            if obj.isHorizontalCreated == 1
                obj.isHorizontalCreated = obj.Remove(obj.horizontalName, obj.isHorizontalCreated);
            end
            if obj.isVerticalCreated == 1
                obj.isVerticalCreated = obj.Remove(obj.verticalName, obj.isHorizontalCreated);
            end
        end
        
        function [isCreated, obj] = Create( obj, name, isCreated, position, size )
            if obj.deviceId > 0
                if isCreated == 0
                    [retVal, response] = haSendCommand( obj.deviceId, ['create block ' name]  );
                    if (retVal == 0)
%                         disp(response);
                        isCreated = 1;
                    else
                        msgbox(['\fontsize{12}Haptic.Create: ' response],'ACT3D-TACS',obj.CreateStruct);
                        return;
                    end
                    
                    [retVal, response] = haSendCommand( obj.deviceId,...
                        ['set ' name ' stiffness ' num2str(obj.blockStiffness)] );
                    if (retVal ~= 0)
                        msgbox(['\fontsize{12}Haptic.Create: ' response],'ACT3D-TACS',obj.CreateStruct);
                    end
                    
                    [retVal, response] = haSendCommand( obj.deviceId,...
                        ['set ' name ' size [' num2str(size(1)) ',' num2str(size(2)) ',' num2str(size(3)) ']'] );
                    if (retVal ~= 0)
                        msgbox(['\fontsize{12}Haptic.Create: ' response],'ACT3D-TACS',obj.CreateStruct);
                    end
                    
                    [retVal, response] = haSendCommand( obj.deviceId,...
                        ['set ' name ' pos [' num2str(position(1)) ',' num2str(position(2)) ',' num2str(position(3)) ']'] );
                    if (retVal ~= 0)
                        msgbox(['\fontsize{12}Haptic.Create: ' response],'ACT3D-TACS',obj.CreateStruct);
                    end
                    
                else
                    msgbox('\fontsize{12}Haptic.Create: Haptic effect was already created','ACT3D-TACS',obj.CreateStruct);
                end
            else
                msgbox('\fontsize{12}Haptic.Create: Device not connected','ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        function obj = UpdateDeviceId(obj, robot)   % set deviceId in Haptic class equal to deviceId in Robot class
            obj.deviceId = robot.deviceId;
        end
        
        function [isEnabled, obj] = Enable( obj, isCreated, isEnabled, name )
            if isCreated == 1
                if isEnabled == 0
                    [retVal, response] = haSendCommand( obj.deviceId, ['set ' name ' enable'] );
                    if (retVal == 0)
                        msgbox('\fontsize{12}Haptic effect enabled','ACT3D-TACS',obj.CreateStruct);
                        isEnabled = 1;
                    else
                        msgbox(['\fontsize{12}Haptic.Enable: ' response],'ACT3D-TACS',obj.CreateStruct);
                    end
                else
                    msgbox('\fontsize{12}Haptic.Enable: Haptic effect is already enabled','ACT3D-TACS',obj.CreateStruct);
                end
            else
                msgbox('\fontsize{12}Haptic.Enable: Haptic effect has not been created','ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        function [ isEnabled, obj ] = Disable( obj, isCreated, isEnabled, name )
            if isCreated == 1
               if isEnabled == 1
                    
                    [retVal, response] = haSendCommand( obj.deviceId, ['set ' name ' disable'] );
                    if (retVal == 0)
                        msgbox('\fontsize{12}Haptic.Disable: Haptic effect disabled','ACT3D-TACS',obj.CreateStruct);
                        isEnabled = 0;
                    else
                        msgbox(['\fontsize{12}Haptic.Disable: ' response],'ACT3D-TACS',obj.CreateStruct);
                    end
                    
                else
                    msgbox('\fontsize{12}Haptic.Disable: Haptic effect is already disabled','ACT3D-TACS',obj.CreateStruct);
                end
                
            else
                msgbox('\fontsize{12}Haptic.Disable: Haptic effect has not been created','ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        function [ isCreated, obj ] = Remove( obj, name, isCreated )
            if isCreated == 1
                [retVal, response] = haSendCommand( obj.deviceId, ['remove ' name] );
                if (retVal == 0)
                    msgbox(['\fontsize{12}Haptic.SetPosition: Removed ' name],'ACT3D-TACS',obj.CreateStruct);
                    isCreated = 0;
                else
                    msgbox(['\fontsize{12}Haptic.SetPosition: ' response],'ACT3D-TACS',obj.CreateStruct);
                end
            end
        end
        
        
        function obj = SetPosition(obj,position,name)
            [retVal, response] = haSendCommand( obj.deviceId, ['set ' name ' pos [' num2str(position(1)) ',' num2str(position(2)) ',' num2str(position(3)) ']'] );
            if (retVal == 0)
                msgbox(['\fontsize{12}Haptic.SetPosition: Changed position of ' name],'ACT3D-TACS',obj.CreateStruct);
            else
                msgbox(['\fontsize{12}Haptic.SetPosition: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        function obj = SetSize(obj,size,name)
            [retVal, response] = haSendCommand( obj.deviceId, ['set ' name ' size [' num2str(size(1)) ',' num2str(size(2)) ',' num2str(size(3)) ']'] );
            if (retVal == 0)
                msgbox(['\fontsize{12}Haptic.SetSize: Changed size of ' name],'ACT3D-TACS',obj.CreateStruct);
            else
                msgbox(['\fontsize{12}Haptic.SetSize: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
        end
        
        
        function obj = SetPlaneAngle(obj,planeAngle,name,arm)
            
            obj.horizontalAngle = planeAngle;
            
            planeAngle = planeAngle *pi/180;
            
            % for the left arm the plane angle is negative
            if strcmp(arm,'Left')
                planeAngle = -planeAngle;
            end
            
            % convert from euler angles to quaternion
            w =cos(planeAngle/2);
            x =sin(planeAngle/2);
            y =0;
            z =0;
            
            [retVal, response] = haSendCommand( obj.deviceId,...
                ['set ' name ' att [' num2str(x) ',' num2str(y) ',' num2str(z) ',' num2str(w) ']'] );
            if (retVal == 0)
                msgbox('\fontsize{12}Haptic.SetPlaneAngle: Changed rotation of horizontal','ACT3D-TACS',obj.CreateStruct);
            else
                msgbox(['\fontsize{12}Haptic.SetPlaneAngle: ' response],'ACT3D-TACS',obj.CreateStruct);
            end
        end
        
    end
end


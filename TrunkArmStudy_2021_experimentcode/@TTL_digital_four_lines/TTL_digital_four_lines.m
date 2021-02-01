%% class to send a TTL pulse out of digital ports 6-9 of NI DAQ to 
%% communicate with external devices.  [ 0 1 0 1] would send a high +5V 
%% signal to channels 7 and 9.
%{

% function call prototypes
className = Robot;
className.()         % robot connects when class is created
className.Disconnect()      % robot disconnects when class is deleted
className.SetForceGetInfo( [ 0 0 0] ) OR className.SetForceGetInfo()
className.SwitchState('off')
className.SetExternalForce([0 0 0])
className.SetInertia( 8.0 )

%}

%% class definition
classdef TTL_digital_four_lines < handle
    
    properties ( Access = public )
        digitalOutputObject=[];
        channelObject=[];
        isInitialized=0;
    end
    
    
    methods
        function obj = TTL_digital_four_lines()
            % delete any remaining objects if they exist
            obj.digitalOutputObject = [];
        end
        
        
        function delete(obj)
            if ~isempty(obj.digitalOutputObject)
                delete(obj.digitalOutputObject);
                obj.digitalOutputObject = [];
            end
        end
        
        
        function obj = Initialize(obj, daqParametersPanel, samplingRate, samplingTime )
            % Set acquisition parameters
            %obj.digitalOutputObject = digitalio('nidaq','Dev1');
            obj.digitalOutputObject = digitalio('nidaq','Dev5');
        end
        
        
        function obj = AddChannels( obj, totalEmgChannels, emgChannels )
            %hline = addline(obj.digitalOutputObject, 0:3, 1, 'out');
            hline = addline(obj.digitalOutputObject, 0:3, 0, 'out'); % Changed to port 0 for iso tower DAQ (dev 6)
        end
        
        
        function obj = Toggle( obj, data )
            % toggle digital outputs on channels 6-9
            putvalue( obj.digitalOutputObject.Line(1:4), data );
        end
        
        %{
        function obj = Stop(obj)
            % put a 0 on channel 9
            putvalue( obj.digitalOutputObject.Line(1:4), [0 0 0 0] );        
        end
        %}
    end
    
end

%% class to use the National Insturments data acquisition device
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
classdef Nidaq < handle
    
    properties ( Access = public )
        analogInputObject=[];
        channelObject=[];
        isInitialized=0;
    end
    
    
    methods
        function obj = Nidaq()
            % delete any current analog input objects if they exist
            if ~isempty(obj.analogInputObject)
                delete(obj.analogInputObject);
                obj.analogInputObject = [];
            end

        end
        
        
        function delete(obj)
            if ~isempty(obj.analogInputObject)
                delete(obj.analogInputObject);
                obj.analogInputObject = [];
            end
        end
        
        
        function obj = Initialize(obj, daqParametersPanel, samplingRate, samplingTime )
            % Set acquisition parameters
            %obj.analogInputObject = analoginput('nidaq', 'Dev1'); %  these calls are in targetDAQ.m
            obj.analogInputObject = analoginput('nidaq', 'Dev5');
            set( obj.analogInputObject, 'SampleRate',samplingRate );
            actualSamplingRate = get(obj.analogInputObject,'SampleRate');
            
            %edited 4/29/14 to allow infinite data collection
            set(obj.analogInputObject, 'SamplesPerTrigger',inf,...
                'TriggerType','Manual',...%'ManualTriggerHwOn','Trigger',...
                'TimeOut',360,...   %msec
                'LogToDiskMode', 'Index',...
                'LoggingMode', 'Disk&Memory') %,...
            
%             set(obj.analogInputObject, 'SamplesPerTrigger',samplingTime*actualSamplingRate,...
%                 'TriggerType','Manual',...%'ManualTriggerHwOn','Trigger',...
%                 'TimeOut',360,...   %msec
%                 'LogToDiskMode', 'Index',...
%                 'LoggingMode', 'Disk&Memory') %,...
            
        end
        
        
        function obj = AddChannels( obj, totalEmgChannels, emgChannels )
%             if totalEmgChannels == 18
% %                 channelsVector = 0:7;
% %                 channelsVector = cat(2,channelsVector,16:23);
% %                 channelsVector = cat(2,channelsVector,32:33);
%                 channelsVector = [0:7,16:23,32:39];
%                 % analogInputChannels -> match the AI hardware ID
%                 analogInputChannels = channelsVector;
%                 % channelsVector -> must be sequential indices
%                 channelsVector = 0:totalEmgChannels-1;
%                 %channelsVector = floor(channelsVector/12)*4 + rem(channelsVector,12);
%                 %channelsVector = floor(channelsVector/14) + rem(channelsVector,14);
%             else
                channelsVector = 0:(totalEmgChannels)-1;
                analogInputChannels = floor(channelsVector/8)*16 + rem(channelsVector,8);
%             end
            for i=1:length( analogInputChannels )
                emgChannelLabels(i) = get( emgChannels.labels(i), 'String' );
            end

            obj.channelObject = addchannel( obj.analogInputObject, analogInputChannels, channelsVector+1, { emgChannelLabels{channelsVector+1} } );

        end
        
        %{
        function obj = SetFilename(obj, filename)
            set(obj.analogInputObject, 'LogFileName', filename );
        end
        %}
        function obj = Start(obj)
            start(obj.analogInputObject);
            trigger(obj.analogInputObject);
        end
        
        % added 12/11/13
        function obj = Stop(obj)
            stop(obj.analogInputObject);
        end
        %{
        function [ y, x, obj ] = LoadEmgData( obj )
            [y,x] = getdata(obj.analogInputObject);
        end
        %}
    end
    
end

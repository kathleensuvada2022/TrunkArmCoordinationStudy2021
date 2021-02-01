%% class to use the PPS TactArray data acquisition device

% Updated by Nayo Hill 5/22/18 to implement a baseline correction at
% initialization of pressure mat

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
classdef PPS1 < handle
    
    properties ( Access = public )
        
        Filename;
        BufferSize = 10000;
        ReadDuration   = 5000;             % in milliseconds
        ReadInterval   = 1000;               % in milliseconds
        time = libpointer('ulongPtr');
        data = libpointer('singlePtr');
        time_out = libpointer('ulongPtr');
        data_out = libpointer('singlePtr');
        FrameSize = 0;
        pressure;
        maxPressure;
        maxTime;
        avgPressure;
        isInitialized = 0;
        %cfgFile = 'D:\Nayo_Folder\Nayo_HandArmExperiment_Current\setup\T4500-Northwestern-2018-11-09.cfg'; %Updated 11/14/18
        cfgFile = 'D:\Nayo_Folder\Nayo_HandArmExperiment_Current\setup\T4500-Northwestern.cfg';
        %cfgFile = 'C:\Users\Yiyun\program_DAQ_6210\setup\T4500-Northwestern.cfg';
        %cfgFile = 'C:\Users\DewaldLab\Desktop\Nayo_HandArmExperiment_Current\setup\T4500-Northwestern.cfg';
    end
    
    
    methods
        
        function obj = PPS1( obj )
            % load TactArray library
            if ( libisloaded('PPSDaqAPI') )
                unloadlibrary('PPSDaqAPI');
            end
            loadlibrary( 'PPSDaqAPI','PPSDaq.h' );
            calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0);
            disp('PPS system Initialized');
            obj.FrameSize = calllib('PPSDaqAPI','ppsGetRecordSize');
            str = sprintf('Recording is %d elements', obj.FrameSize);
            disp(str);
            obj.time = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
            obj.data = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
            obj.time_out = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
            obj.data_out = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
            
            % test if data is calibrated (CreateDaqParametersPanelCallback.m)
            IsCalibrated = calllib('PPSDaqAPI', 'ppsIsCalibrated');
            if IsCalibrated
                disp('Data is calibrated')
            else
                disp('Data is not calibrated');
            end
            
        end
        
        function delete(obj)
            % unload TactArray library 
            unloadlibrary('PPSDaqAPI');
        end
        
        function obj = Initialize(obj)


            % Added by NH 5/22/18
            calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0);
            disp('PPS system Initialized');
            
            calllib('PPSDaqAPI','ppsStart');
            disp('Start data recording.')
            
            n = obj.ReadDuration / obj.ReadInterval;
            for i = 1:n
                if (ceil(n / 2) == i) %<= Resets baseline halfway through initial data collection
                    disp('Resetting baseline with current values.');
                    calllib('PPSDaqAPI', 'ppsSetBaseline')
                end
                pause(obj.ReadInterval/1000);
                
                nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
                if  (nReady < 0)
                    exit;
                end
                
                if(mod(i,2) ~= 0)
                    nRead = nReady;
                else
                    nRead = obj.BufferSize;
                end
                
                if(nReady < 0)
                    exit;
                end
                
                if nReady < obj.BufferSize
                    str = sprintf('Trying to read %d frames', nReady);
                    disp(str);
                    [nRead, obj.time_out, obj.data_out] = calllib('PPSDaqAPI', 'ppsGetData', nRead, obj.time, obj.data);
                end
                
                if nReady >= obj.BufferSize
                    disp('Oversized Data');
                    [nRead, obj.time_out, obj.data_out] = calllib('PPSDaqAPI', 'ppsGetData', obj.BufferSize, obj.time, obj.data);
                end
                
                disp(['Saving ', num2str(nRead), ' frames to file...']);
                rawData = obj.data.Value(1:nRead*obj.FrameSize);
                toWrite = [single(obj.time.Value(1:nRead)')' reshape(rawData,obj.FrameSize,nRead)'];
                folder = pwd;
                OutputFile = [folder,'\pps_Initialization.csv']; % <= saves file from baseline correction
                if i == 1
                    dlmwrite(OutputFile, toWrite);
                else
                    dlmwrite(OutputFile, toWrite, '-append');
                end
                disp('done.');
            end
            calllib('PPSDaqAPI','ppsStop');
            disp('Data recording stopped.')
            disp('Baseline correction complete.');
         end
        
        function obj = StartPPS(obj)
            
            % start data acquisition
            calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0);
            obj.isInitialized = calllib('PPSDaqAPI','ppsStart');
            
        end
        
        function obj = ReadData(obj, experiment)
            
            nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
            
            if  nReady <= 0 
                calllib('PPSDaqAPI','ppsStop');
                disp('Time out: no data available');
            end
            
            if nReady < obj.BufferSize && nReady > 0
                str = sprintf('Trying to read %d frames', nReady);
                disp(str);
                nRead = nReady;
                [nRead, obj.time_out, obj.data_out]=calllib('PPSDaqAPI', 'ppsGetData', nRead, obj.time, obj.data);
                %                 obj.pressure{1,experiment.currentIteration + 1} = obj.time_out;
                %                 obj.pressure{2,experiment.currentIteration + 1} = obj.data_out;
                %                 % max of each frame
                %                 obj.maxPressure{1,experiment.currentIteration + 1} = max(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),[],1);
                %                 obj.maxTime{1,experiment.currentIteration + 1} = obj.pressure{1,experiment.currentIteration + 1}(1:nRead);
                %                 % average of each frame
                %                 obj.avgPressure{1,experiment.currentIteration + 1} = mean(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),1);
                obj.time = libpointer('ulongPtr',zeros(obj.BufferSize,1));
                obj.data = libpointer('singlePtr',zeros(obj.FrameSize, obj.BufferSize));
            end
            
            if nReady >= obj.BufferSize
                disp('Oversized Data');
                [nRead, obj.time_out, obj.data_out]=calllib('PPSDaqAPI', 'ppsGetData', obj.BufferSize, obj.time, obj.data);
%                 obj.pressure{1,experiment.currentIteration + 1} = obj.time_out;
%                 obj.pressure{2,experiment.currentIteration + 1} = obj.data_out;
%                 % max of each frame
%                 obj.maxPressure{1,experiment.currentIteration + 1} = max(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),[],1);
%                 obj.maxTime{1,experiment.currentIteration + 1} = obj.pressure{1,experiment.currentIteration + 1}(1:nRead);
%                 % average of each frame
%                 obj.avgPressure{1,experiment.currentIteration + 1} = mean(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),1);
                % clear variables
                obj.time = libpointer('ulongPtr',zeros(obj.BufferSize,1));
                obj.data = libpointer('singlePtr',zeros(obj.FrameSize, obj.BufferSize));
            end
            
%             if experiment.currentIteration == 0
%                 calllib('PPSDaqAPI','ppsSetBaseline');
%                 disp('PPS Baseline Set');
%             end
        end
        
        function obj = StopPPS(obj)
            calllib('PPSDaqAPI','ppsStop'); 
            obj.isInitialized = 0;
        end
    end
end


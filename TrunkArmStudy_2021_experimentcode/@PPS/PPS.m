%% class to use the PPS TactArray data acquisition device
% Class requires the PPS API and header file as well as the config files
% for the pressure sensor and the HwPlugins and ProcPlugins folders in the
% same folder as the dll

% Updated by KACEY SUVADA 10.23.20 to implement a baseline correction at
% initialization of pressure mat

%{
% function call prototypes
className = PPS;

classname.PPS()               % Load in PPS API Library and test to see if
                               data is calibrated
className.Initialize()         % Initialize PPS System 
className.StartPPS()           % Start PPS System
className.ReadData()           % Read in PPS API library
className.StopPPS()            % Stop PPS system
className.delete()             % Unload TactArray API Library when done
%}

%% class definition
classdef PPS < handle
    
    properties ( Access = public )
        
        Name; % 'TactArray_Trunk' or 'TactArray_Hand'
        Filename;
        BufferSize = 10000;
        ReadDuration   = 5000;             % in milliseconds
        ReadInterval   = 1000;               % in milliseconds
        time = libpointer('ulongPtr');
        data = libpointer('singlePtr');
%          time_out = libpointer('ulongPtr');
%          data_out = libpointer('singlePtr'); 
%         time_out;
%         data_out;
        FrameSize = 0;
        pressure;
        maxPressure;
        maxTime;
        avgPressure;
        isInitialized = 0;
% Updated to show Kacey's file path with .cfg CHANGED FILE
% PATH 10.28.20
        % PPS files needed are in 'C:\ProgramData\PPS\Chameleon2018\1.13.8.49'
        handcfg = 'D:\Kacey\TrunkArmStudy\setup\T4500-Northwestern.cfg';
        trunkcfg = 'D:\Kacey\TrunkArmStudy\setup\PN7931R1-STA-NorthwesternDual.cfg';
        cfgFile;
        CreateStruct = struct('Interpreter','tex','WindowStyle','modal');
        datafpath;
    end
    
    
    methods
        % Modify input variables so that it's a structure with all the
        % info: name, datafpath, ReadDuration, Read
        function obj = PPS(name,datafpath)
%             disp(obj)
            obj.Name=name;
            switch obj.Name
                case 'TactArray_Trunk'
                    obj.cfgFile=obj.trunkcfg;
                case 'TactArray_Hand'
                    obj.cfgFile=obj.handcfg;
            end                    
            obj.datafpath=datafpath;
            % load TactArray library
            if ( libisloaded('PPSDaqAPI') )
                unloadlibrary('PPSDaqAPI');
            end
            [~,~]=loadlibrary( 'PPSDaqAPI','PPSDaq.h' );
            obj.isInitialized = calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,5);
%             disp('Line 56')
            msgbox('\fontsize{12}PPS system Initialized','ACT3D-TACS',obj.CreateStruct)
%             disp('Line 58')
% 
%             % disp('PPS system Initialized');          
            obj.FrameSize = calllib('PPSDaqAPI','ppsGetRecordSize');
%             disp('Line 62')
%             msgbox(['\fontsize{12}Recording is %d elements',num2str(obj.FrameSize)],'ACT3D-TACS',obj.CreateStruct)

%             str = sprintf('Recording is %d elements', obj.FrameSize);
%             disp(str);
%             obj.time = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
%             obj.data = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
%             obj.time_out = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
%             obj.data_out = libpointer('singlePtr', zeros(obj.BufferSize, obj.FrameSize));
            
            % test if data is calibrated (CreateDaqParametersPanelCallback.m)
            IsCalibrated = calllib('PPSDaqAPI', 'ppsIsCalibrated');
            if IsCalibrated
                msgbox('\fontsize{12}Data is calibrated','ACT3D-TACS',obj.CreateStruct)
%               disp('Data is calibrated')
            else
                warndlg('\fontsize{12}Data is not calibrated','ACT3D-TACS',obj.CreateStruct);
                %disp('Data is not calibrated');
            end
            
        end
        
        function delete(obj)
            % unload TactArray library 
            unloadlibrary('PPSDaqAPI');
        end
        
        function obj = Initialize(obj,datadir)
            % Added by NH 5/22/18
            if ~obj.isInitialized, calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0); end
            msgbox('\fontsize{12}PPS System Initializing','ACT3D-TACS',obj.CreateStruct)
            disp('PPS system Initialized'); %uncommented KCS 5.5.21
            
            calllib('PPSDaqAPI','ppsStart');
            tic
            while toc<=3, end
            obj.ReadData;
            calllib('PPSDaqAPI','ppsSetBaseline') %uncommented KCS 5.5.21

            [~,t,data]=obj.ReadData;
            calllib('PPSDaqAPI','ppsStop');
%             calllib('PPSDaqAPI','ppsSetBaseline') % If the readings show drift at the beginning, reset baseline
%             t=double(data_out)';
%             time_out=double(time_out(:));
%             t=double(t(:));
%             data=double(data)';
            save(fullfile(datadir,'pps_baseline'),'t','data')
%             msgbox('\fontsize{12}Data recording stopped','ACT3D-TACS',obj.CreateStruct)
%            disp('Data recording stopped.')
            msgbox('\fontsize{12}Baseline correction complete','ACT3D-TACS',obj.CreateStruct)
%            disp('Baseline correction complete.');
%             msgbox({'\fontsize{12}Start data recording'},'ACT3D-TACS',obj.CreateStruct)
%             disp('Start data recording.')
            
%             n = obj.ReadDuration / obj.ReadInterval;
%             for i = 1:n
%                 if (ceil(n / 2) == i) %<= Resets baseline halfway through initial data collection
% %                     msgbox({'\fontsize{12}Resetting baseline with current values'},'ACT3D-TACS',obj.CreateStruct)
% %                     disp('Resetting baseline with current values.');
%                   
                  %line from Gordon
%                   calllib('PPSDaqAPI', 'ppsSetBaseline')
%                 end
%                 pause(obj.ReadInterval/1000);
%                 
%                 nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
% %                 if  (nReady < 0)
% %                     exit;
% %                 end
% %                  if(mod(i,2) ~= 0)
% %                     nRead = nReady;
% %                 else
% %                     nRead = obj.BufferSize;
% %                 end
%                 
%                 if nReady < 0
%                     exit;
% %                 elseif nReady < obj.BufferSize
% % %                     str = sprintf('Trying to read %d frames', nReady);
% % %                     msgbox({'\fontsize{12}Trying to read %d frame',nReady},'ACT3D-TACS',obj.CreateStruct)
% %                     
% % %                     disp(str);
% %                     [nRead, obj.time_out, temp] = calllib('PPSDaqAPI', 'ppsGetData', nRead, obj.time, obj.data);
%                 else
% %                       msgbox({'\fontsize{12}Oversized Data'},'ACT3D-TACS',obj.CreateStruct)
% %                     disp('Oversized Data');
%                 obj.time = libpointer('ulongPtr', zeros(nReady, 1));
%                 obj.data = libpointer('singlePtr', zeros(obj.FrameSize, nReady));
%                 obj.time_out = libpointer('ulongPtr', zeros(nReady, 1));
%                 obj.data_out = libpointer('singlePtr', zeros(nReady, obj.FrameSize));
% 
% %                 [nRead, obj.time_out, temp] = calllib('PPSDaqAPI', 'ppsGetData', obj.BufferSize, obj.time, obj.data);
%                 [nRead, obj.time_out, temp] = calllib('PPSDaqAPI', 'ppsGetData', nReady, obj.time, obj.data);
%                 obj.data_out = temp';
%                 end
%                 
%                 obj.data_out = temp';
%                 
% %                 msgbox(['\fontsize{12}Saving ', num2str(nRead), ' frames to file...'],'ACT3D-TACS',obj.CreateStruct)
% %               disp(['Saving ', num2str(nRead), ' frames to file...']);
%                 rawData = obj.data.Value(1:nRead*obj.FrameSize);
%                 toWrite = [single(obj.time.Value(1:nRead)')' reshape(rawData,obj.FrameSize,nRead)'];
% %                 folder = pwd;
%                 OutputFile = [obj.datafpath,'\pps_baseline.csv']; % <= saves file from baseline correction
%                 if i == 1
%                     dlmwrite(OutputFile, toWrite);
%                 else
%                     dlmwrite(OutputFile, toWrite, '-append');
%                 end
% %                 msgbox({'\fontsize{12}DONE'},'ACT3D-TACS',obj.CreateStruct) 
% %                 disp('done.');
%             end
         end
        
        function obj = StartPPS(obj)
            % start data acquisition
            calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0); 
      
            calllib('PPSDaqAPI','ppsStart');
            
        end
        
        function [obj,t,data] = ReadData(obj)
%             disp('In ReadData')
            nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
%             disp(nReady) 
%             if  nReady <= 0 
%                 calllib('PPSDaqAPI','ppsStop');
%                 warndlg('\fontsize{12}PPS Time out: no data available','ACT3D-TACS',obj.CreateStruct);  %TODO: Error when running with Nayo's Hand PPS happens here in PPS.m and on line 1055 in ACT3D_TACS.m
%               disp('Time out: no data available');
            if nReady>0
                obj.time = libpointer('ulongPtr', zeros(nReady, 1));
                obj.data = libpointer('singlePtr', zeros(obj.FrameSize, nReady));
                [~, t, data] = calllib('PPSDaqAPI', 'ppsGetData', nReady, obj.time, obj.data);
                data=double(data)';
                t=double(t);
            else
               obj=[];t=[];data=[];

            end
%             elseif nReady < obj.BufferSize && nReady > 0
% %                 str = sprintf('Trying to read %d frames', nReady);
%                 msgbox(['\fontsize{12}Reading ' num2str(nReady) ' frames'],'ACT3D-TACS',obj.CreateStruct)
% 
% %                 disp(str);
%                 [nRead, obj.time_out, temp]=calllib('PPSDaqAPI', 'ppsGetData', nReady, obj.time, obj.data);
%                 obj.data_out =temp';
%                 %                 obj.pressure{1,experiment.currentIteration + 1} = obj.time_out;
%                 %                 obj.pressure{2,experiment.currentIteration + 1} = obj.data_out;
%                 %                 % max of each frame
%                 %                 obj.maxPressure{1,experiment.currentIteration + 1} = max(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),[],1);
%                 %                 obj.maxTime{1,experiment.currentIteration + 1} = obj.pressure{1,experiment.currentIteration + 1}(1:nRead);
%                 %                 % average of each frame
%                 %                 obj.avgPressure{1,experiment.currentIteration + 1} = mean(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),1);
%                 obj.time = libpointer('ulongPtr',zeros(obj.BufferSize,1));
%                 obj.data = libpointer('singlePtr',zeros(obj.FrameSize, obj.BufferSize));
%                
%             end
%             
%             if nReady >= obj.BufferSize
%                
%                 msgbox('\fontsize{12}Oversized Data','ACT3D-TACS',obj.CreateStruct)
% 
% %                 disp('Oversized Data');
%                 [nRead, obj.time_out, temp]=calllib('PPSDaqAPI', 'ppsGetData', obj.BufferSize, obj.time, obj.data);
%                 obj.data_out=temp';
% %                 obj.pressure{1,experiment.currentIteration + 1} = obj.time_out;
% %                 obj.pressure{2,experiment.currentIteration + 1} = obj.data_out;
% %                 % max of each frame
% %                 obj.maxPressure{1,experiment.currentIteration + 1} = max(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),[],1);
% %                 obj.maxTime{1,experiment.currentIteration + 1} = obj.pressure{1,experiment.currentIteration + 1}(1:nRead);
% %                 % average of each frame
% %                 obj.avgPressure{1,experiment.currentIteration + 1} = mean(obj.pressure{2,experiment.currentIteration + 1}(:,1:nRead),1);
%                 % clear variables
%                 obj.time = libpointer('ulongPtr',zeros(obj.BufferSize,1));
%                 obj.data = libpointer('singlePtr',zeros(obj.FrameSize, obj.BufferSize));
%             end
            
%             if experiment.currentIteration == 0
%                 calllib('PPSDaqAPI','ppsSetBaseline');
%                 disp('PPS Baseline Set');
%             end
        end
        
        function obj = StopPPS(obj)
            calllib('PPSDaqAPI','ppsStop'); 
%             obj.isInitialized = 0;
        end
    end
end


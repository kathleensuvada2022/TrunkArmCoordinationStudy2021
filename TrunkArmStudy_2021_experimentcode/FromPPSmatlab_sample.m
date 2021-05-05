%---------------------------------------------------------------------------
%
% Pressure Profile Systems API Demo Matlab Application
%
% Copyright (c) 2017 by Pressure Profile Systems, Inc.
%
%---------------------------------------------------------------------------
clear; close all; clc;

%% Import PPS Library
% if not(libisloaded('../bin/x64/PPSDaqAPI'))
%     loadlibrary('../bin/x64/PPSDaqAPI', '../inc/PPSDaq_Matlab.h')
% end

%For Kacey
[~,~]=loadlibrary( 'PPSDaqAPI','PPSDaq.h' );

%creating variable list of functionality 
list = libfunctions('PPSDaqAPI','-full');


%% Standard configuration options that must always be specified
ConfigFileDef  = '16x16_emulator.cfg';
LogLevel       = 2;                 % 0 to disable

%% Settings specific to our demo application
OutputFile     = 'pps_output_matlab.csv';
BufferSize     = 500;               % max frames we can read
ReadDuration   = 10000;             % in milliseconds
ReadInterval   = 500;               % in milliseconds
StartupTimeout = 60000;             % max to wait for daq to start (ms)

disp('Pressure Profile Systems API Demo Application');
disp('Copyright (c) 2012-2014 by Pressure Profile Systems, Inc.');

%% Print our current directory
disp(['Working directory is ', pwd]);

%% Read config file as argument if specified
configFile = ConfigFileDef;

%% Setup PPS Hardware
disp(['Using configuration file ' , configFile]);
disp('Initializing connection to API...');


if (~calllib('PPSDaqAPI','ppsInitialize', uint16(configFile), LogLevel))
    disp('Could not initialise PPS API, please see the log file in the working directory'); 
    return;
end;


%% Allocate storage for incoming data
frameSize = calllib('PPSDaqAPI', 'ppsGetRecordSize');
data      = zeros(1, BufferSize * frameSize);
times      = zeros(1, BufferSize);
ptimes = libpointer('ulongPtr',  times);
pdata  = libpointer('singlePtr', data); 

disp(['RecordSize is ', num2str(frameSize), ' elements.']);
if(calllib('PPSDaqAPI', 'ppsIsCalibrated'))
    IsCalibrated = ' ';
else
    IsCalibrated = 'not ';
end
disp(['Output values are ', IsCalibrated, 'calibrated.']);


%% Create our output file and start data acquisition
disp(['Creating output file ', OutputFile]);
headerline = 'Time [ms]';
for i = 1:frameSize
    headerline = [headerline [',Elem',num2str(i-1)]];
end
fid = fopen(OutputFile, 'w');
fprintf(fid, [headerline,'\n']);
fclose(fid)


try
    disp('Starting acquisition...');
    if(~calllib('PPSDaqAPI', 'ppsStart'))
        return;
    end
    disp('done.');
    
    %% Wait for acquisition to actually get going (ie. there's data in the buffer)
    disp('Waiting for data...');   
    n = StartupTimeout / ReadInterval;
    i = 1;
    while i < n  && calllib('PPSDaqAPI', 'ppsFramesReady') == 0
        pause(ReadInterval/1000);
        disp('Waiting for data...')
        i = i + 1;
    end
    
    %% If there's still no data, then something is wrong
    if (0 == calllib('PPSDaqAPI', 'ppsFramesReady'))
        disp('Timeout waiting for data. Shutting down...');
        calllib('PPSDaqAPI', 'ppsStop')
        return;
    elseif (calllib('PPSDaqAPI', 'ppsFramesReady') < 0)
         return
    else
        disp('done.');
    end        
    
    
    %% Reset the baseline
    calllib('PPSDaqAPI', 'ppsSetBaseline');
    nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
    calllib('PPSDaqAPI', 'ppsGetData', nReady, ptimes, pdata); %Remove junk data
    
    
    %% Read chunks of data and output to our file
    n = ReadDuration / ReadInterval;
    for i = 1:n
        % Keep things running at a reasonable pace
        pause(ReadInterval/1000);
               
        nReady = calllib('PPSDaqAPI', 'ppsFramesReady');
        if(nReady < 0)
            return;
        end
        
        disp(['Trying to read ', num2str(nReady),  ' frames of data; ']);
        
        % This function only reads what is available, so we can safely 
        % request more data if required.        
        ptimes = libpointer('ulongPtr',  times);
        pdata  = libpointer('singlePtr', data);        
        nRead = calllib('PPSDaqAPI', 'ppsGetData', nReady, ptimes, pdata);
      
        disp(['Saving ', num2str(nRead), ' frames to file...']);
        rawData = pdata.Value(1:nRead*frameSize);
        toWrite = [single(ptimes.Value(1:nRead)') reshape(rawData,frameSize,nRead)'];
        dlmwrite(OutputFile, toWrite, '-append');
        
    end
    
catch e
    disp('ERROR');
end

%% Clean up

clear ptimes;
clear pdata;
if(calllib('PPSDaqAPI', 'ppsStop'))
    disp('Acquisition Stopped')
else
    disp('Problem stopping sensor');
end
unloadlibrary PPSDaqAPI
disp('Library Unloaded.');






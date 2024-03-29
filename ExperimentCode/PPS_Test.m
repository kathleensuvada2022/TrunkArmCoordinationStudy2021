%% Script to test PPS

% obj = PPS(name,datafpath)
dir=pwd;
ppsmat = PPS('TactArray_Trunk',dir);


% Initialize
ppsmat.Initialize(dir);


% Start data collection
ppsmat.StartPPS; 
 pause(3)
 %to flush out bad data 
[~,ppst,ppsdata]=ppsmat.ReadData;


pause(5)
%good data
[~,ppst,ppsdata]=ppsmat.ReadData;

ppsmat.StopPPS;

% Correct the time vector by removing the start time
ppst=ppst-ppst(1);

data.pps={ppst,ppsdata};

%% Delete object at the end
ppsmat.delete;

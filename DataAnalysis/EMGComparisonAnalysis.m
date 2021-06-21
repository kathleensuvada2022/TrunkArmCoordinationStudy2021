%% NOTES FROM AMA
% Use fullfile to create the filename with the full path so you don't have
% to include "\" in partid. For example:
% maxes = load(fullfile(filepath,partid,maxe,'maxEMG.mat'));
% emgbaseline = load(fullfile(filepath,partid,['restingemg' num2str(baselinetrials(1))]));

%% Plots EMGS  May 2021
% Runs through baseline data,maxes, and trial data unrectified and raw EMG
% Main Script that calls : PlotAllEMGsBaseline, Comp (baseline data, ComputeReach Start_NRSA (plots dist and vel),
% GetMaxMusAct4 (plot maxes), PlotAllEMGs (trial emg data)


% Chage to your CD with data: 
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data';
%% RTIS1003 (JB) 

% NOTE: comment the baseline plots for EMGS and PSDs since no baseline data
% for participant 
partid = '/RTIS1003';
maxes = load([filepath partid '/' 'maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS1003_setup.mat']); %loading set up 


%% RTIS 1002 (AMA) 
partid = '/RTIS1002'
maxes = load([filepath partid '/' 'maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS1002_setup.mat']); %loading set up 
baselinetrials = 1:4;
emgbaseline = load([filepath '/' partid '/' 'restingemg' num2str(baselinetrials(1))]); % can change this to confirm consistency
tbaseline = emgbaseline.t;
emgbaseline = detrend(emgbaseline.data);

%% RTIS2003
% partid = '/RTIS2003/Left42321';

%%%%% NON PARETIC%%%%%%%%%%%
partid = '/RTIS2003/Right51221'; 
maxes = load([filepath partid '/' 'Maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS2003_setup_Final_TR.mat']); %loading set up 
baselinetrials = 97:99;
emgbaseline = load([filepath '/' partid '/' 'trial' num2str(baselinetrials(1))]); % can change this to confirm consistency
tbaseline = emgbaseline.data.daq{1,1} ;
emgbaseline = emgbaseline.data.daq{1,2};
emgbaseline = detrend(emgbaseline(:,1:15));

%% Main Code that Creates Plots of Distance, Velocity, EMGS, and PSDS
% 1-TRtable 2-TR 25%  3-TR 50% 4-TUtable 5-TU 25% 6-TU 50% 
  ExpCond = 1;
% 
  trials = setup.trial{1,ExpCond};

% trials = 30;

for i = 1:length(trials)

    load([filepath '/' partid '/' 'trials' num2str(trials(i))])
    
    trials(i) %showing trial we are on
    
    pause

    emg = data.daq{1,2};
    emg = detrend(emg(:,1:15)); % centers data at 0 
    
    
    %emg = emg./maxes; %normalizing
    
    
    t = data.daq{1,1}; %loading in the time vector
      
    actdata=data.act;
    
    metdata= data.met;
    
    for j = 15
        
        
    %Plotting Distance and Velocity Using ACT3D Data
    [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_NRSA(actdata,j) 
    
    %Using Metria data
%     [dist,vel,timestart,timevelmax,timeend,timedistmax,distold]=ComputeReachStart_2021(actdata,metdata,setup,j) 

    %Comparing the metria data and the resampled data
%     figure(2)
%     plot(distold)
%     hold on
%     plot(dist)
%     legend('Metria Data', 'Resampled Data')
%     xlabel('Samples')
%     ylabel('Distance')
%     xlim([0 3000])
%     
    
    %EMG DATA DURING TRIAL
    PlotAllEMGs(emg(:,j),t,timestart,timevelmax,timeend,timedistmax)
    
    
    %Plotting the Maxes
    flpath = ([filepath  '/' partid '/' 'maxes']);
    basename = 'maxes';
    setfname = ([partid '_' 'Setup.mat']) ;
   
    plotflag = 1;
    [maxEMG newemg]= GetMaxMusAct4(flpath,basename,setfname,partid,plotflag,j)

% Plotting the Baseline EMGS

 PlotAllEMGsBaseline(emgbaseline(:,j),tbaseline)

%%%%%%%%%%%%%%%%%%%%%%%For PSD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Baseline

fs = 1000;
[pxx,f] = pwelch(emgbaseline(:,j),2000,500,500,fs);



subplot(3,3,7)
plot(f,pxx)
xlabel('Frequency')


% During Trial 

fs = 1000;
[pxx,f] = pwelch(emg(:,j),2000,500,500,fs);



subplot(3,3,8)
plot(f,pxx)
xlabel('Frequency')


% Maxes 
fs = 1000;
[pxx,f] = pwelch(newemg(:,j),2000,500,500,fs);

subplot(3,3,9)
plot(f,pxx)
xlabel('Frequency')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 pause 
    end 
  
   
    pause 
    
end 
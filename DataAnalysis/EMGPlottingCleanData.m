%July 2021
%Script to go through EMGs and plot distance and velocity for given trials and participants 

%% RTIS 1002 (AMA) 
partid = '/RTIS1002';
maxes = load([filepath partid '/' 'maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS1002_setup.mat']); %loading set up 
ExpCond = 1;
setupf= 'RTIS1002_setup.mat';
%% RTIS1003 (JB) 

% NOTE: comment the baseline plots for EMGS and PSDs since no baseline data
% for participant 
partid = '/RTIS1003';
maxes = load([filepath partid '/' 'maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS1003_setup.mat']); %loading set up 

%% RTIS2001
partid = '/RTIS2001/Left';
filepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data' partid];
maxes = load([filepath '/' 'Maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath '/' 'RTIS2001_setup.mat']); %loading set up 
expcond = 1;

%% Main Code: run this for everyone

 trials = setup.trial{1,ExpCond};
 %trials = 30;
%%
 for i = 1:length(trials)
 %loading in cleaned up EMG data
 load([filepath '/' 'clean_data_trial_' num2str(trials(i))]) 
 %loading in cleaned up ACT3D data
 load([filepath '/' 'trial' num2str(trials(i))])

 %loading in act data
 actdata=data.act;
 
 %Plotting distance and velocity traces
 [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_NRSA(actdata,i)
 
 %Plotting normalized clean EMG data  
 PlotEMGsClean(cleandata,maxes,timestart,timevelmax,timeend,timedistmax,i)
 

PlotKinematicData6(partid,'trial','trial',setup,i);
 
%pause between trials 
 pause
 end 
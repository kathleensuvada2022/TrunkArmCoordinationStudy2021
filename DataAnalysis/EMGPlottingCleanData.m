%June 2021
%Script to go through EMGs and plot distance and velocity for given trials and participants 

%% Run this for given file path  
% Chage to your CD with data: 
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data';


%% RTIS 1002 (AMA) 
partid = '/RTIS1002';
maxes = load([filepath partid '/' 'maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS1002_setup.mat']); %loading set up 
ExpCond = 1;
%% Main Code: run this for everyone

 trials = setup.trial{1,ExpCond};
 %trials = 30;

 for i = 1:length(trials)
 %loading in cleaned up EMG data
 load([filepath '/' partid '/' 'clean_trial_trial_' num2str(trials(i))]) 
 %loading in cleaned up ACT3D data
 load([filepath '/' partid '/' 'trials' num2str(trials(i))])

 %loading in act data
 actdata=data.act;
 %Plotting normalized clean EMG data  
 PlotEMGs(clean_trial,maxes)
 

 %Plotting distance and velocity traces
 ComputeReachStart_NRSA(actdata,i)
 
 pause
 end 
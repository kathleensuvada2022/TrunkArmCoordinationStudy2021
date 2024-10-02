% K. Suvada 
% 2024

% Function to organize muscle activation values that will be used for
% computations of muscle modules. Saves as a matrix that is m muscles by n
% trials for all conditions of a given participant. Extracting the average
% activation during the reach. Confirm visually with plots from
% 'PlotEMGsCleanV2'


% function NMFMatrix_trial_updated = Suvada_NMF_2024(emg,timestart,timedistmax,timevelmax,ntrials,filename,expcond,i)
function NMFMatrix_trial_updated = Suvada_NMF_2024(emg,timestart,timedistmax,timevelmax,ntrials,filename,expcond,i,NMFMatrix_trial)


emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};


ArmMusc = {'Arm Mus','UT','MT','LD','PM','BIC','TRI','IDEL'};
emgArm = 9:15; 
emgTrunk = 1:8;

% Start and End index for EMG data (Fs= 1000 Hz)
Reachstart_idx_emg = timestart*1000;
MaxReach_idx_emg = timedistmax* 1000;
MaxVel_idx_emg = timevelmax*1000;


% For Arm Muscles extracting the mean value during the reach

% Can alter to interval of interest 

%During Reach
% emgvalsNMF = mean(emg(Reachstart_idx_emg:MaxReach_idx_emg,emgArm))';

% Start of Reach to the Max Vel (acceleration phase of the movement)
if Reachstart_idx_emg == MaxVel_idx_emg
    % Midpoint between start and end bc for some very severe stroke, the max vel is the start of
    % the reach and they continue to slow.
    emgvalsNMF = emg(median(Reachstart_idx_emg:MaxReach_idx_emg),emgArm)';

elseif MaxVel_idx_emg>length(emg)
    emgvalsNMF = mean(emg(Reachstart_idx_emg:length(emg),emgArm))';

else
    emgvalsNMF = mean(emg(Reachstart_idx_emg:MaxVel_idx_emg,emgArm))';
end

% NMF Matrix
if i ==1 && expcond ==1 
NMFMatrix_trial= num2cell(zeros(8,ntrials));
NMFMatrix_trial = [ArmMusc' NMFMatrix_trial];
end 

% if i ==1 && expcond ==4
% if i ==1 
% NMFMatrix_trial= num2cell(zeros(8,ntrials));
% NMFMatrix_trial = [ArmMusc' NMFMatrix_trial];
% end 

RunningCols = size(NMFMatrix_trial,2);

    if expcond ==1 
    NMFMatrix_trial{1,i+1} = [filename '_' 'COND' num2str(expcond)];
    
    NMFMatrix_trial{2,i+1} = emgvalsNMF(1);
    NMFMatrix_trial{3,i+1} = emgvalsNMF(2);
    NMFMatrix_trial{4,i+1} = emgvalsNMF(3);
    NMFMatrix_trial{5,i+1} = emgvalsNMF(4);
    NMFMatrix_trial{6,i+1} = emgvalsNMF(5);
    NMFMatrix_trial{7,i+1} = emgvalsNMF(6);
    NMFMatrix_trial{8,i+1} = emgvalsNMF(7);
    
    NMFMatrix_trial_updated = NMFMatrix_trial;

    else

    NMFMatrix_trial_updated = NMFMatrix_trial;

    NMFMatrix_trial_updated{1,RunningCols+1} = [filename '_' 'COND' num2str(expcond)];
    
    NMFMatrix_trial_updated{2,RunningCols+1} = emgvalsNMF(1);
    NMFMatrix_trial_updated{3,RunningCols+1} = emgvalsNMF(2);
    NMFMatrix_trial_updated{4,RunningCols+1} = emgvalsNMF(3);
    NMFMatrix_trial_updated{5,RunningCols+1} = emgvalsNMF(4);
    NMFMatrix_trial_updated{6,RunningCols+1} = emgvalsNMF(5);
    NMFMatrix_trial_updated{7,RunningCols+1} = emgvalsNMF(6);
    NMFMatrix_trial_updated{8,RunningCols+1} = emgvalsNMF(7);
    
    end 


end
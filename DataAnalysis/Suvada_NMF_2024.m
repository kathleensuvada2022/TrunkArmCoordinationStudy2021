% K. Suvada 
% 2024

% Function to compute motor modules given a matrix input V of collected
% data to estimate weighting matrix "W" and time coefficient matrix "C."
% Data collected for Trunk and reaching arm. Feed in trial by trial such
% that columns are each trial data.


function NMFMatrix_FULL = Suvada_NMF_2024(NMFMatrix_FULL,emg,timestart,timedistmax,ntrials,filename,i)


emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};


ArmMusc = {'Arm Mus','UT','MT','LD','PM','BIC','TRI','IDEL'};
emgArm = 9:15; 
emgTrunk = 1:8;

% Start and End index for EMG data (Fs= 1000 Hz)
Reachstart_idx_emg = timestart*1000;
MaxReach_idx_emg = timedistmax* 1000;


% For Arm Muscles 
emgvalsNMF = mean(emg(Reachstart_idx_emg:MaxReach_idx_emg,emgArm))';

% NMF Matrix
NMFMatrix_COND1= num2cell(zeros(8,ntrials)); 

NMFMatrix_COND1 = [ArmMusc' NMFMatrix_COND1];

NMFMatrix_COND1{1,i+1} = filename;

NMFMatrix_COND1{2,2} = emgvalsNMF(1);
NMFMatrix_COND1{3,2} = emgvalsNMF(2);
NMFMatrix_COND1{4,2} = emgvalsNMF(3);
NMFMatrix_COND1{5,2} = emgvalsNMF(4);
NMFMatrix_COND1{6,2} = emgvalsNMF(5);
NMFMatrix_COND1{7,2} = emgvalsNMF(6);
NMFMatrix_COND1{8,2} = emgvalsNMF(7);

NMFMatrix_FULL = 

end
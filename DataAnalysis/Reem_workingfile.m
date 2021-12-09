%% Creating the matrix for NMF EMG input

For each EMG recording, we're going to need to select a time window. 
That time window will depend on the designations that we make earlier.

timestart
timedistmax

These variables will indicate the time window that we're looking at the
    EMGs through.


xlim([1.9101,3.1573])
%%%%%%%%%%%%%%%%%%%%%%

'This is the way that we can call the EMG file directly''

load('/Users/Abi1/Documents/GitHub/TrunkArmCoordinationStudy2021/DataAnalysis/RTIS2011/Right/Maxes/clean_data_trial_1.mat')


'create a list of time starts'

'create a list of time ends'





%% TESTING-- HOW DO I EXTRACT THE TIME REGION OF INTEREST?
%trying to extract this value...
'is this it?'
reachingtime= timestart*1000:timedistmax*1000;
% emgLES = meanEMG(round(reachingtime),idx1(1))
% size(meanEMG(1.9101:3.1573,idx1(1))) %it doesnt like the fact that 
                                    % these aren't integers--solution: floor(

'all EMG values for our time window of interest for all muscles!'
emg_timewindow = emg(round(reachingtime),:);  

% EXTRACT AND PUT INTO BASE WORKSPACE.  
size(emg_timewindow)
assignin("base","emg_timewindow",emg_timewindow);


% size(emgLES) %checks
% size(emg)
% size(emg,1)
% size(emg(round(reachingtime),:))


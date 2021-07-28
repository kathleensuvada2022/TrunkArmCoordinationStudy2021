% July 2021: Script to edit EMG data and move columns. Hopefully won't be
% used too much 

%% RTIS2006 Left Paretic

%%%%%%%% Fixing Maxes%%%%%%%%%%%%
filepathmaxes = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2006/Left/Maxes';

% Trial 24 onward, column 10 in column 3
trials = 24:38;


for i = 1:length(trials)
emgdata =  [filepathmaxes,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 
cleandata(:,3)= cleandata(:,10);
cleandata(:,10)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'emgdata');
    
end 

%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2006/Left';
trials = 1:68;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,3)= cleandata(:,10);
cleandata(:,10)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'emgdata');
    
end 
%% RTIS 2008 Paretic Right

%%%%%%%% Fixing Maxes%%%%%%%%%%%%
filepathmaxes = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2008/Right/Maxes';


% Trial 24 onward, column 10 in column 3
trials = 34:36;


for i = 1:length(trials)
emgdata =  [filepathmaxes,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 
cleandata(:,2)= cleandata(:,9);
cleandata(:,9)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'emgdata');
    
end 

%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2008/Right';
trials = 1:49;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,15)= cleandata(:,16);
cleandata(:,16)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'emgdata');
    
end 
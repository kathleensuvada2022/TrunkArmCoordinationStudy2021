% July 2021: Script to edit EMG data and move columns. Hopefully won't be
% used too much 
%% RTIS1006
% Just remove Middle Trap for all trials (put 0 there)
%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right';
trials = 1:102;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,10)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'cleandata');
end   
%% RTIS2002
% Just remove Middle Trap and LD for all trials (put 0 there)
%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2002/Left';
trials = 1:66;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,10)= zeros(5000,1); % Ommitting Column 10 Mt
cleandata(:,11)= zeros(5000,1); % Ommitting Column 11 LD

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'cleandata');
end   
%% RTIS2006 Left Non-Paretic

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
save(filename1, 'cleandata');
    
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
save(filename1, 'cleandata');
    
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
save(filename1, 'cleandata');
    
end 

%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2008/Right';
trials = 1:49;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,2)= cleandata(:,16);
cleandata(:,16)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'cleandata');
    
end 
%% RTIS 2009 Paretic Left 

%%%%%%%% Fixing Maxes%%%%%%%%%%%%
filepathmaxes = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2009/Left/Maxes';


% Trial 38:43 cut 15 and paste into 7
trials1 = 38:43;
trials2 = 44:46;

for i = 1:length(trials1)
emgdata =  [filepathmaxes,'/' 'clean_data_trial_' num2str(trials1(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 
cleandata(:,7)= cleandata(:,15);
cleandata(:,15)= zeros(5000,1); 

filename1=sprintf('clean_data_trial_%d',trials1(i));  
save(filename1, 'cleandata');
    
end 

for i = 1:length(trials2)
emgdata =  [filepathmaxes,'/' 'clean_data_trial_' num2str(trials2(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 
cleandata(:,2)= cleandata(:,10);
cleandata(:,10)= zeros(5000,1); % Ommitting Column 10 Mt

filename1=sprintf('clean_data_trial_%d',trials2(i));  
save(filename1, 'cleandata');
    
end 

%%


%%%%%%%% Fixing Trials%%%%%%%%%%%%
filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2009/Left';
trials = 1:63;

for i = 1:length(trials)
emgdata =  [filepath,'/' 'clean_data_trial_' num2str(trials(i)) '.mat']; %loading cleaned up EMG data
load(fullfile(emgdata)); %load setup file 

cleandata(:,7)= cleandata(:,15);
cleandata(:,15)=cleandata(:,9);

cleandata(:,9)= zeros(5000,1); % Ommitting Column 9 UT
cleandata(:,10)= zeros(5000,1); %ommitting middle trap

filename1=sprintf('clean_data_trial_%d',trials(i));  
save(filename1, 'cleandata');
    
end 

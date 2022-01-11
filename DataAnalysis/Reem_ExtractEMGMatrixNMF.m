function[emg_timevel emg_timestart]= Reem_ExtractEMGMatrixNMF(emg,timestart,timevelmax,timedistmax,i)


%% start of original code
%% note: replacing all emg with emg_timewindow?

cleandata= KaceyNotchfilter(emg);

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
assignin("base","Muscle_LST", char(emgchan)); %data name list structure

%clf
figure(2)
%subplot(2,1,2)
%emg=emg./maxes; %normalizing
sampRate=1000;
avgwindow=0.25; ds=sampRate*avgwindow;
nEMG=size(emg,2);
t=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=0.25; ds=sampRate*avgwindow;
emg=abs(detrend(emg));

%% use this value
meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

emg_idxstart= round(timestart*1000);
emg_idxvel = round(timevelmax*1000);
emg_timestart = emg(emg_idxstart,:);
emg_timevel = emg(emg_idxvel,:);

% Reem: what is idx1? 
% These values indicate which muscle we're looking at
idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);








%% Extracting values for NMF analysis

reachingtime= (timestart-0.15)*1000:(timestart+0.05)*1000;
size(reachingtime)

% (timestart*1000)-150 (or 0.15 w/ 1000)
% looking at the movement itself (preporatory phase)
% biomechanics--time points are dependent
% (timestart*1000)

'all EMG values for our time window of interest for all muscles!'
cleandata= KaceyNotchfilter(emg); %use MEANEMG instead of emg or cleandata

emg_timewindow = abs(cleandata(round(reachingtime),:)); %test--looking at cleandata for NMF
size(emg_timewindow)

meanEMG_timewindow_mini = meanEMG(round(reachingtime),:); %final--looking at meanEMG for NMF (201x15)
meanEMG_timewindow_mini = mean(meanEMG_timewindow_mini); %finding the average over that one time window (1x15)

meanEMG_timewindow = transpose(meanEMG_timewindow_mini);  %transpose--data structure needs to be muscles x time/window (15x1)
size(meanEMG_timewindow)



% EXTRACT AND PUT INTO BASE WORKSPACE.  
% basically what I'm trying to do is for each trial extract my variable
% of interest for each trial seperately. Once theyre all in the workspace,
% I highlight them all and save them as a given file (refer to
% Reem_mockwalking_test.mat)

'which trial are we on?:'

counter = 0 

for u = 1:6
    counter = counter+1

% trialEMG = 

['emg_timewindow' + counter] = evalin('base', meanEMG_timewindow)

% assignin("base",'emg_timewindow_1', meanEMG_timewindow);
% assignin("base","emg_timewindow_2", meanEMG_timewindow);
% assignin("base","emg_timewindow_3",meanEMG_timewindow);
% assignin("base","emg_timewindow_4",meanEMG_timewindow);
assignin('base',['emg_timewindow'],meanEMG_timewindow);

%% copypaste this and change to indicate # of control
% list_Control2 = cat(2, emg_timewindow_1, emg_timewindow_2, emg_timewindow_3, emg_timewindow_4, emg_timewindow_5)
pause
end


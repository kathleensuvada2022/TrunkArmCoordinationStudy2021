%% Loads in EMGS, normalizes and rectifies 


filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data';

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
emgbaseline = emgbaseline(:,1:15);

%% Setting the experimental condition
% 1-TRtable 2-TR 25%  3-TR 50% 4-TUtable 5-TU 25% 6-TU 50% 
 ExpCond = 1;

 trials = setup.trial{1,ExpCond};

for i = 1:length(trials)

    load([filepath partid '/' 'trial' num2str(trials(i))])
    
    trials(i) %showing trial we are on
    
    pause

    emg = data.daq{1,2};
    emg = emg(:,1:15);
    %emg = emg./maxes; %normalizing
    
    
    t = data.daq{1,1}; %loading in the time vector
    
%%    
    actdata=data.act;
    
    for j = 1: length(emg)
    %Plotting Distance and Velocity of Trial 
    [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_NRSA(actdata) 
    
    %Plot in the call for plot all EMGS
    PlotAllEMGs(emg(:,j),t)
    
    
    %Plotting the Maxes
    flpath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2003/Right51221/Maxes';
    basename = 'maxesRTIS2003';
    setfname = 'rtis2003_Setup.mat';
    partid = 'RTIS2003';
    plotflag = 1;
    [maxEMG newemg]= GetMaxMusAct2(flpath,basename,setfname,partid,plotflag,j)
    
   % hold on
%% Plotting the Baseline EMGS

 PlotAllEMGsBaseline(emgbaseline(:,j),tbaseline)

%% For PSD 

% Baseline

fs = 1000;
Fnyq=fs/2;
N = length(emg(:,j));
freqs=0:1000/N:Fnyq;

data_fft_bl = fft(emgbaseline(:,j)-mean(emgbaseline(:,j)));

Px_data_bl = data_fft_bl.*conj(data_fft_bl);

figure(1)
subplot(3,3,7)
plot(freqs,abs(data_fft_bl(1:N/2+1)))
xlabel('Frequency')


% During Trial 

data_fft = fft(emg(:,j)-mean(emg(:,j)));

Px_data = data_fft.*conj(data_fft);

figure(1)
subplot(3,3,8)
plot(freqs,abs(data_fft(1:N/2+1)))
xlabel('Frequency')


% Maxes 
data_fft_maxes = fft(newemg(:,j)-mean(newemg(:,j)));

Px_data_maxes = data_fft_maxes.*conj(data_fft_maxes);

figure(1)
subplot(3,3,9)
plot(freqs,abs(data_fft_maxes(1:N/2+1)))
xlabel('Frequency')


 pause 
    end 
  
   
    pause 
    
end 
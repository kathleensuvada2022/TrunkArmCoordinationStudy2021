%% Loads in EMGS, normalizes and rectifies 
% For RTIS2003 


filepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data';
% partid = '/RTIS2003/Left42321';

 partid = '/RTIS2003/Right51221'; % NON PARETIC


maxes = load([filepath partid '/' 'Maxes' '/' 'maxEMG.mat']);
maxes = maxes.maxEMG;
load([filepath partid '/' 'RTIS2003_setup_Final_TR.mat']); %loading set up 

% 1-TRtable 2-TR 25%  3-TR 50% 4-TUtable 5-TU 25% 6-TU 50% 
 ExpCond = 1;

 trials = setup.trial{1,ExpCond};

 
%  trials = 97;
for i = 1:length(trials)

    load([filepath partid '/' 'trial' num2str(trials(i))])
    
    trials(i) %showing trial we are on
    
    pause

    emg = data.daq{1,2};
    emg = emg(:,1:15);
    %emg = emg./maxes; %normalizing
    
    
    t = data.daq{1,1}; %loading in the time vector
    
    
    actdata=data.act;
    
    %Plotting Distance and Velocity of Trial 
    [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_NRSA(actdata) 
    
    %Plot in the call for plot all EMGS
    PlotAllEMGs(emg,t,timestart,timevelmax,timeend,timedistmax)
    
    %PlotAllEMGs(emg,t)
   
% For PSD   
[pxx,f] = pwelch(emg);
figure
plot(f,log10(pxx(:,1))*10,'m')
xlabel('frequency (Hz)')
ylabel ('Power/Frequency')

    
    pause 
    
end 
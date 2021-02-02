%% running through max EMG trials

basename = 'MAXES';
flpath = '/Users/kcs762/Box/KACEY/Data/RTIS1001/maxes';

trials=dir([flpath '/*' basename '*.mat']);

for i = 1:length(trials) 
    load([flpath '/' trials(i).name]); % loading in Max EMG and time vector
    PlotAllEMGs(data,t)
    i                       %printing out i to see the current  maxes trial 
    pause
    
end 
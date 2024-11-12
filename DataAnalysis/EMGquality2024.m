%% Quality of EMG data
% K. Suvada November 2024



% Load in raw EMG data for given participant



%% Organizing by Condition

Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};



%% Plotting Raw Trial Data for Given Condition

%% Cond 1

for i = 1:length(Cond1)
    for j = 1:size(Cond1(i).emgRAW,2)

        figure(1) % Plot Raw EMG
        subplot(4,4,j)
        plot(Cond1(i).emgtimevec,Cond1(i).emgRAW(:,j))
        title(emgchan(j))
        xlim([0 5])

        figure(2) % Plot PSD for each trace
        subplot(4,4,j)
  
        %  PSD original data
        Fs = 1000;
        [pxx,f] = pwelch(Cond1(i).emgRAW(:,j),2000,500,500,Fs);
        figure(2)
        subplot(4,4,j)
        plot(f,10*log10(pxx))
%         plot(f,pxx)
        title(emgchan(j))
    end

end

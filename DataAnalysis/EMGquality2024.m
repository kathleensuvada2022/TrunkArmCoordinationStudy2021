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

%% Cond2

% set j = 12 for PM
% set j = 9 for UT (high baseline in loading conditions)
% set j = 11 for LD

% PM high baseline activity prior to activation or just noise?

for i = 1:length(Cond2) % All trials in given cond
    for j = 1:15 % size(Cond2(i).emgRAW,2) %going through all muscles

        %% Creating Notch Filter at 60hz
        fs = 1000;

        notchFreq = 60;
        Q = 35; % Quality factor (determines bandwidth of the notch filter)
        notchFilter = designfilt('bandstopiir', 'FilterOrder', 2, ...
            'HalfPowerFrequency1', notchFreq - notchFreq/Q, ...
            'HalfPowerFrequency2', notchFreq + notchFreq/Q, ...
            'SampleRate', fs);

        % Apply the notch filter
        filteredSignal = filtfilt(notchFilter, Cond2(i).emgRAW(:,j));
%%



        figure(1) % Plot Raw EMG unrectified
        subplot(4,4,j)
%         size(Cond2(i).emgRAW(:,j))
        plot(Cond2(i).emgtimevec,detrend(Cond2(i).emgRAW(:,j)))
        hold on
        plot(Cond2(i).emgtimevec,detrend(filteredSignal))
        legend('Original','Filtered')
        title(emgchan(j))
        xlim([0 5])

        figure(2) % Plot PSD for each muscle
        subplot(4,4,j)

        % 2000 window length % 500 overlap length % 500 FFT length % 1000 Fs
        [pxx,f] = pwelch(detrend(Cond2(i).emgRAW(:,j)),2000,500,500,1000);
        % Adjusting the FFT length
         %       [pxx,f] =  pwelch(Cond2(i).emgRAW(:,j), 2000, 1000, 500, 1000);

%         figure(2);
%         subplot(4,4,j);
        %         plot(f, log10(pxx), 'b'); % Plot the log10 of pxx for better visualization

        plot(f, pxx), 'b'; %
        hold on;

        xlabel('F (Hz)');
        ylabel('PSD');
        title(['Trial ' num2str(i) 'Muscle ' emgchan(j)])
        title(emgchan(j))



        %% Plotting Filtered Data

%         figure(3)
%         % EMG Filtered Data
%         subplot(4,4,j)
% 
%         plot(Cond2(i).emgtimevec,detrend(filteredSignal))
%         title(emgchan(j))
%         xlim([0 5])
%         figure(4)
        % PSD of Filtered Data
%         subplot(4,4,j)
%         [pxx2,f2] = pwelch(filteredSignal,2000,500,500,1000);
%         plot(f2, pxx2), 'b'; %
%         hold on;
% 
%         xlabel('F (Hz)');
%         ylabel('PSD');
%         title(['Trial ' num2str(i) 'Muscle ' emgchan(j)])
%         title(emgchan(j))


    end
    Cond1(i).trialname
    pause %Stopping at each trial
    close all

end





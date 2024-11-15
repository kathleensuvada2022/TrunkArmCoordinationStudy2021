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

Cond = Cond5; % Set desired Condition

filteredSignal = zeros(5000,15);

for i = 1:length(Cond) % All trials in given cond
    for j = 1:15 % size(Cond2(i).emgRAW,2) %going through all muscles

        %% Filtering Data

        % Notch filter at 60,120,180

        fs = 1000;

        % Apply notch filters sequentially (60 Hz, 120 Hz, 180 Hz)
        filteredSignal(:,j) = detrend(Cond(i).emgRAW(:,j));

        notchFreqs = [60, 120, 180];
        Q = 35;  % Quality factor for the notch filter

        for k = 1:length(notchFreqs)
            % Design the notch filter for the current frequency
            notchFilter = designfilt('bandstopiir', ...
                'FilterOrder', 4, ...  % 4,8 not much difference. Also not much difference when doing 120 and 180
                'HalfPowerFrequency1', notchFreqs(k) - notchFreqs(k)/Q, ...
                'HalfPowerFrequency2', notchFreqs(k) + notchFreqs(k)/Q, ...
                'SampleRate', fs);

            % Apply the notch filter
            filteredSignal(:,j) = filter(notchFilter, filteredSignal(:,j));
        end
        %% Running Notch Filtered Data through Lowpass Filter

        [filteredSignal(:,j) d] = lowpass(filteredSignal(:,j),200,1000);

        
        %%

        figure(1) % Plot Raw EMG unrectified
        subplot(4,4,j)
        plot(Cond(i).emgtimevec,detrend(Cond(i).emgRAW(:,j)))
        hold on
        plot(Cond(i).emgtimevec,filteredSignal(:,j))
        legend('Original','Filtered','FontSize',16)
        title(emgchan(j))
        xlim([0 5])

        figure(2) % Plot PSD for each muscle
        subplot(4,4,j)

        % 2000 window length % 500 overlap length % 500 FFT length % 1000 Fs
        [pxx,f] = pwelch(detrend(Cond(i).emgRAW(:,j)),2000,500,500,1000);
       
        [pxx2,f2] = pwelch(filteredSignal(:,j),2000,500,500,1000);



        plot(f, pxx), 'b'; % original data
        hold on;
        plot(f2, pxx2, '--', 'Color', 'r'); %filtered data

        legend('Original','Filtered','FontSize',16)

        xlabel('F (Hz)');
        ylabel('PSD');
        title(['Trial ' num2str(i) 'Muscle ' emgchan(j)])
        title(emgchan(j))




    end

     Cond(i).trialname
     Cond(i).FiltEMG = filteredSignal; % saving filtered EMG for each trial in a given condition
  
     pause %Stopping at each trial


    close all

end

%% Concatonating all Conditions with filtered EMG

% Run after updating all the Conditions with the cleaned up EMG 


NNMF_allConds_Filtered = [Cond1 Cond2 Cond3 Cond4 Cond5 Cond6]


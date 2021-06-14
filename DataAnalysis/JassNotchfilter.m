%load('trials15.mat')
Fs = 1000;
%emg_trial = data(1).daq{:,2};
%emg_time = data(1).daq{:,1};
  

% use 11 and 12 for actual trials
% numfiles = 47; % CHANGE NUM FILES 
% mydata = cell(1, numfiles);

numfiles = 2;
mydata = cell(1, numfiles);

for k = 1:numfiles
 % myfilename = sprintf('restingemg%d.mat', k);
% myfilename = sprintf('maxes%d.mat', k); % for maxes everything else same
 %as resting
   
  myfilename = sprintf('trials%d.mat', k); % CHANGE FILENAME 
   load(myfilename);
   emg_trial = data.daq{1,2} ;   % CHANGE FORMAT (same for resting and
%   maxes)


% emg_trial = detrend(data(:,1:15)); 

%Replace line 22 for actual trials
%emg_trial = detrend(data(1).daq{:,2});
emg_trial = detrend(emg_trial);
emg_time = 0:1/Fs:(length(emg_trial)-1)/Fs;

% Original signal unfiltered for that column (muscle)
% figure()
% plot(emg_time,emg_trial(:,2))


d60 = designfilt('bandstopiir','FilterOrder',4, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
           
d120 = designfilt('bandstopiir','FilterOrder',4, ...
               'HalfPowerFrequency1',119,'HalfPowerFrequency2',121, ...
               'DesignMethod','butter','SampleRate',Fs);
d180 = designfilt('bandstopiir','FilterOrder',4, ...
              'HalfPowerFrequency1',179,'HalfPowerFrequency2',181, ...
              'DesignMethod','butter','SampleRate',Fs);
           
% %Plot the frequency response of the filter.
% fvtool(d60,'Fs',Fs)
% fvtool(d180,'Fs',Fs)
           
%compensate for filter delay.

% Make sure to change for given muscle
% butt_trial60 = filtfilt(d60,emg_trial); %doing butterworth on 60hz
%butt_trial180 = filtfilt(d180,butt_trial60); %using this for 180 -- taking new trial without 60hz (need filtered data) 
%%
%saving filtered data for all filtered muscle data
for i = 1:15
butt_trial60(:,i) = filtfilt(d60,emg_trial(:,i)); 
butt_trial120(:,i) = filtfilt(d120,butt_trial60(:,i)); 
butt_trial180(:,i) = filtfilt(d180,butt_trial120(:,i)); 
fpass=240;
clean_trial = lowpass(butt_trial180,fpass,Fs);  
filename1=sprintf('clean_trial_trialHB_%d',k);  % FILENAME CHANGE!!!
save(filename1, 'clean_trial');
% filename2=sprintf('butt_trial180_%d',k);
% save(filename2, 'butt_trial180');
end 
end
%%
%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%
% Plotting clean trial data
figure()
plot(emg_time,emg_trial(:,i))
ylabel('volts')
xlabel('time')
title('Unfiltered RRA Data')
grid

% PSD original data
Fs = 1000;
[pxx,f] = pwelch(emg_trial(:,i),2000,500,500,Fs);
figure()
%plot(f,10*log10(pxx))
plot(f,pxx)
title('RRA - Unfiltered')

%Filtered data
figure()
plot(emg_time,clean_trial(:,i))
ylabel('volts')
xlabel('time')
title('Filtered RRA Data')
grid

% PSD filtered 
Fs = 1000;
[pxx,f] = pwelch(clean_trial(:,i),2000,500,500,Fs);
figure()
%plot(f,10*log10(pxx))
plot(f,pxx)
title('RRA - Filtered')
  

% figure(5)
% plot(detrend(data(:,15)))
% hold on
% plot(butt_trial180(:,15))
% ylabel('Voltage (V)')
% xlabel('Time (s)')
% title('EMG signal IDEL')
% legend('Unfiltered','Filtered 180 HZ')
% grid

%%
% %see that the "spike" at 60 Hz has been eliminated.
% [ptrial,ftrial] = periodogram(emg_trial(:,2),[],[],Fs);
% [pbutt,fbutt] = periodogram(butt_trial60(:,2),[],[],Fs);
% 
% plot(ftrial,(abs(ptrial)),fbutt,(abs(pbutt)),'--')
% ylabel('Power/frequency (dB/Hz)')
% xlabel('Frequency (Hz)')
% title('Power Spectrum')
% legend('Unfiltered','Filtered')
% grid

 

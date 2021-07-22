%load('trials15.mat')
Fs = 1000;
fc=240;
%emg_trial = data(1).daq{:,2};
%emg_time = data(1).daq{:,1};
  

% use 11 and 12 for actual trials
% numfiles = 47; % CHANGE NUM FILES 
% mydata = cell(1, numfiles);

numfiles = 37;
mydata = cell(1, numfiles);
%%
for k = 1:numfiles
 % myfilename = sprintf('restingemg%d.mat', k);
% myfilename = sprintf('maxes%d.mat', k); % for maxes everything else same
 %as resting
   
  myfilename = sprintf('trial%d.mat', k); % CHANGE FILENAME 
   load(myfilename);
%    emg_trial = data.daq{1,2} ;   % CHANGE FORMAT (same for resting and
%   maxes)


 emg_trial = detrend(data(:,1:15)); 

%Replace line 22 for actual trials
%emg_trial = detrend(data(1).daq{:,2});
emg_trial = detrend(emg_trial);

emg_time = 0:1/Fs:(length(emg_trial)-1)/Fs;
xc=length(emg_time);



% Original signal unfiltered for that column (muscle)
% figure()
% plot(emg_time,emg_trial(:,2))

%Changed to 8th order 

d60 = designfilt('bandstopiir','FilterOrder',8, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
           
d120 = designfilt('bandstopiir','FilterOrder',8, ...
               'HalfPowerFrequency1',119,'HalfPowerFrequency2',121, ...
               'DesignMethod','butter','SampleRate',Fs);
d180 = designfilt('bandstopiir','FilterOrder',8, ...
              'HalfPowerFrequency1',179,'HalfPowerFrequency2',181, ...
              'DesignMethod','butter','SampleRate',Fs);
           
% %Plot the frequency response of the filter.
% fvtool(d60,'Fs',Fs)
% fvtool(d180,'Fs',Fs)
           
%compensate for filter delay.

% Make sure to change for given muscle
%butt_trial60 = filtfilt(d60,emg_trial); %doing butterworth on 60hz
%butt_trial180 = filtfilt(d180,butt_trial60); %using this for 180 -- taking new trial without 60hz (need filtered data) 
%%
%saving filtered data for all filtered muscle data
for i = 1:15
butt_trial60(:,i) = filtfilt(d60,emg_trial(:,i)); 
butt_trial120(:,i) = filtfilt(d120,butt_trial60(:,i)); 
butt_trial180(:,i) = filtfilt(d180,butt_trial120(:,i)); 

%Low pass filter 240 HZ
% fpass=240;
% clean_trial = lowpass(butt_trial180,fpass,Fs);
n=size(butt_trial180,1);
f=(transpose(((0:n-1)*(Fs/n)))); %Frequency 
v=fft(butt_trial180,n); %Discrete Fourier Transform


Wn=2*fc/Fs; % the normalized cutoff frequency for butter function
nn=8; % the order

%butter returns the transfer function coefficients of an 8th-order lowpass digital Butterworth filter with normalized cutoff frequency Wn.
[b,a] = butter(nn,Wn,'low');
%filter is 1-D digital filter which filters the input data butt_trial180 defined by the transfer function coefficients obtained from butter
%d240=filter(b,a,butt_trial180);

cleandata(:,i) = filtfilt(b,a,butt_trial180(:,i)); 
filename1=sprintf('clean_data_trial_%d',k);  % FILENAME CHANGE!!!
save(filename1, 'cleandata');
% vv=fft(cleandata);

% subplot(2,1,1)
% plot(f,abs(vv(:,2)))
% subplot(2,1,2)
% plot(t,real(cleandata(:,2)),'r')


% filename2=sprintf('butt_trial180_%d',k);
% save(filename2, 'butt_trial180');
end 
end
%%
%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%
% Plotting original data
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
plot(emg_time,cleandata(:,i))
ylabel('volts')
xlabel('time')
title('Filtered RRA Data')
grid

% PSD filtered 
Fs = 1000;
[pxx,f] = pwelch(cleandata(:,i),2000,500,500,Fs);
figure()
%plot(f,10*log10(pxx))
plot(f,pxx)
title('Filtered Data PSD')
  

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

 



load('restingemg1.mat')
x = detrend(data(:,1:15)); 
fs=1000; % samping frequency    
fc=240; % cutoff frequecny
t = 0:1/fs:(length(emg_trial)-1)/fs;

xc=length(t);
% f1=100; % frequency for composing my data
% f2=300; % frequency for composing my data
% x=cos(2*pi*f1*t)+cos(2*pi*f2*t); % raw data
n=size(x,1);
f=(transpose(((0:n-1)*(fs/n)))); %Frequency 
v=fft(x,n); %Discrete Fourier Transform 

plot(f,abs(v),'r');
grid on
Wn=2*fc/fs; % the normalized cutoff frequency for butter function
nn=8; % the order
[b,a] = butter(nn,Wn,'low');
nv=filter(b,a,x);
vv=fft(nv);

subplot(2,1,1)
plot(f,abs(vv(:,2)))
subplot(2,1,2)
plot(t,real(nv(:,2)),'r')
%%
[pxx,f] = pwelch(x(:,2),2000,500,500,Fs);
figure(2)
%plot(f,10*log10(pxx))
plot(f,pxx)
ylabel('Power/frequency (dB/Hz)')
xlabel('Frequency (Hz)')
title('Power Spectrum')

[pxx,f] = pwelch(nv(:,2),2000,500,500,Fs);
figure(3)
%plot(f,10*log10(pxx))
plot(f,pxx)
ylabel('Power/frequency (dB/Hz)')
xlabel('Frequency (Hz)')
title('Clean Power Spectrum')
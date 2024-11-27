%% Plotting Filtered EMG Data with Time Points for One Person





%%
% Separating the Structure by Condition

NNMFstruc= NNMF_allConds_Filtered;

Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};



%% Load in the file with the FILTERED EMG DATA - November 2024***********

% Trial by Trial 

SelectedCond = Cond6; % REPLACE WITH THE CHOSEN CONDITION YOU WANT TO PLOT



NumTrials = length(SelectedCond);

% Plot EMG Data for a given condition for the TRUNK and ARM

for k = 1:NumTrials

emg = SelectedCond(k).FiltEMG;
vel = SelectedCond(k).vel;
tmet = SelectedCond(k).tmet;
t = SelectedCond(k).emgtimevec;
timestart = SelectedCond(k).TimestartTimeVelTimeEnd(1);
timevelmax = SelectedCond(k).TimestartTimeVelTimeEnd(2);
timedistmax = SelectedCond(k).TimestartTimeVelTimeEnd(3);

sampRate=1000;
avgwindow=0.25; ds=sampRate*avgwindow;
nEMG=size(emg,2);
t=(0:size(emg,1)-1)/sampRate; 
avgwindow=0.25; ds=sampRate*avgwindow;
emgrect= abs(emg);
meanEMG=movmean(emgrect,ds);

idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
yrange = 0:1;

cleandata=emg;
%% Trunk 

figure(4)

subplot(5,2,1)
%plotting velocity
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])


% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist

subplot(5,2,2)
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])


% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
% legend('Velocity (m/s)','Start','Max Vel','End','FontSize',18)

subplot(5,2,3)
line(t,(cleandata(:,idx1(1))))
hold on
% plot(t,meanEMG(:,idx1(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(1)),'Fontsize',18)
% ylim([0 1])

% pause

subplot(5,2,4)
line(t,(cleandata(:,idx2(1))))
hold on
% plot(t,meanEMG(:,idx2(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(1)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,5)
line(t,(cleandata(:,idx1(2))))
hold on
% plot(t,meanEMG(:,idx1(2)),'LineWidth',1,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(2)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,6)
line(t,(cleandata(:,idx2(2))))
hold on
% plot(t,meanEMG(:,idx2(2)),'LineWidth',1,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(2)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,7)
line(t,(cleandata(:,idx1(3))))
hold on
% plot(t,meanEMG(:,idx1(3)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(3)),'Fontsize',18)
% ylim([0 1])

subplot(5,2,8)
line(t,(cleandata(:,idx2(3))))
hold on
% plot(t,meanEMG(:,idx2(3)),'LineWidth',2,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(3)),'Fontsize',18)
% ylim([0 1])

% pause

subplot(5,2,9)
line(t,(cleandata(:,idx1(4))))
hold on
% plot(t,meanEMG(:,idx1(4)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
 title(emgchan(idx1(4)),'Fontsize',18)
% ylim([0 1])

% pause

subplot(5,2,10)
line(t,(cleandata(:,idx2(4))))
hold on
% plot(t,meanEMG(:,idx2(4)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(4)))
% ylim([0 1])


% PSDS - trunk 
%%
figure(6)

subplot(5,2,1)
%plotting velocity
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])

% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist

subplot(5,2,2)
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])

% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
% legend('Velocity (m/s)','Start','Max Vel','End','FontSize',18)

subplot(5,2,3)
 
[pxx2,f2] = pwelch(cleandata(:,idx1(1)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(1)),'Fontsize',18)

subplot(5,2,4)
[pxx2,f2] = pwelch(cleandata(:,idx2(1)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(1)),'Fontsize',18)


subplot(5,2,5)
[pxx2,f2] = pwelch(cleandata(:,idx1(2)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(2)),'Fontsize',18)


subplot(5,2,6)
[pxx2,f2] = pwelch(cleandata(:,idx2(2)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(2)),'Fontsize',18)



subplot(5,2,7)
[pxx2,f2] = pwelch(cleandata(:,idx1(3)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(3)),'Fontsize',18)


subplot(5,2,8)
[pxx2,f2] = pwelch(cleandata(:,idx2(3)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(3)),'Fontsize',18)


subplot(5,2,9)
[pxx2,f2] = pwelch(cleandata(:,idx1(4)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
 title(emgchan(idx1(4)),'Fontsize',18)

% pause

subplot(5,2,10)
[pxx2,f2] = pwelch(cleandata(:,idx2(4)),2000,500,500,1000);
plot(f2, pxx2, 'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(4)))

%% ARM MUSCLES
figure(3)
subplot(5,2,1)
%plotting velocity
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])


% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist

subplot(5,2,2)
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])
hold on

% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
% legend('Velocity (m/s)','Start','Max Vel','End','FontSize',18)
% pause


subplot(5,2,3)
line(t,(cleandata(:,idx1(5))))
hold on
% plot(t,meanEMG(:,idx1(5)),'LineWidth',2.5,'Color','k')

%plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(5))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(5))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(5))),'*')

 yl=ylim;
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
title(emgchan(idx1(5)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,4)
line(t,(cleandata(:,idx2(5))))
hold on
% plot(t,meanEMG(:,idx2(5)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(5))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(5))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(5))),'*')

yl=ylim;
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
title(emgchan(idx2(5)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,5)
line(t,(cleandata(:,idx1(6))))
hold on
% plot(t,meanEMG(:,idx1(6)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(6))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(6))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(6))),'*')

yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(6)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,6)
line(t,(cleandata(:,idx2(6))))
hold on
% plot(t,meanEMG(:,idx2(6)),'LineWidth',2.5,'Color','k')
% plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(6))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(6))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(6))),'*')

yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx2(6)),'Fontsize',18)
% ylim([0 1])

% pause

subplot(5,2,7)
line(t,(cleandata(:,idx1(7))))
hold on
% plot(t,meanEMG(:,idx1(7)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(7))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(7))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(7))),'*')

yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(7)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,8)
line(t,(cleandata(:,idx2(7))))
hold on
% plot(t,meanEMG(:,idx2(7)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(7))),'*')
 %plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(7))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(7))),'*')

yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx2(7)),'Fontsize',18)
% ylim([0 1])


subplot(5,2,9)
line(t,(cleandata(:,idx1(8))))
hold on
% plot(t,meanEMG(:,idx1(8)),'LineWidth',2.5,'Color','k')
%plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(8))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(8))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(8))),'*')

yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(8)),'Fontsize',18)
% ylim([0 1])



%% PSDs - Arm 


figure(7)
subplot(5,2,1)
%plotting velocity
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])


% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist

subplot(5,2,2)
plot(tmet,smoothdata(vel)/1000,'b','LineWidth',2)
xlim([0 5])
hold on

% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
% legend('Velocity (m/s)','Start','Max Vel','End','FontSize',18)
% pause


subplot(5,2,3)
[pxx2,f2] = pwelch(cleandata(:,idx1(5)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(5)),'Fontsize',18)


subplot(5,2,4)
[pxx2,f2] = pwelch(cleandata(:,idx2(5)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(5)),'Fontsize',18)

subplot(5,2,5)
[pxx2,f2] = pwelch(cleandata(:,idx1(6)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(6)),'Fontsize',18)


subplot(5,2,6)
[pxx2,f2] = pwelch(cleandata(:,idx2(6)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(6)),'Fontsize',18)

subplot(5,2,7)
[pxx2,f2] = pwelch(cleandata(:,idx1(7)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(7)),'Fontsize',18)


subplot(5,2,8)
[pxx2,f2] = pwelch(cleandata(:,idx2(7)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx2(7)),'Fontsize',18)


subplot(5,2,9)
[pxx2,f2] = pwelch(cleandata(:,idx1(8)),2000,500,500,1000);
plot(f2, pxx2,'Color', 'r'); %filtered data
xlabel('F (Hz)');
ylabel('PSD');
title(emgchan(idx1(8)),'Fontsize',18)


pause
close all
end 


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 

% _________________________________________________________________________________________%




%% Plotting the Averages and Errors for Muscle Activations

%% UN CUT RAW EMG WITHOUT ALIGNING IN TIME OR ANYTHING. Shows the entire 5 seconds of trial data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Condition 1: 7 trials total - with average activations and standard deviations 

UT_alltrials_Cond1 = [Cond1(1).FiltEMG(:,9) Cond1(2).FiltEMG(:,9) Cond1(3).FiltEMG(:,9) Cond1(4).FiltEMG(:,9) Cond1(5).FiltEMG(:,9) Cond1(6).FiltEMG(:,9) Cond1(7).FiltEMG(:,9)];
UT_Cond1_Avg = mean(UT_alltrials_Cond1,2); % average across all trials 
UT_Cond1_STD = std(UT_alltrials_Cond1,0,2);
MT_alltrials_Cond1 = [Cond1(1).FiltEMG(:,10) Cond1(2).FiltEMG(:,10) Cond1(3).FiltEMG(:,10) Cond1(4).FiltEMG(:,10) Cond1(5).FiltEMG(:,10) Cond1(6).FiltEMG(:,10) Cond1(7).FiltEMG(:,10)];
MT_Cond1_Avg = mean(MT_alltrials_Cond1,2);
MT_Cond1_STD = std(MT_alltrials_Cond1,0,2);
LD_alltrials_Cond1 = [Cond1(1).FiltEMG(:,11) Cond1(2).FiltEMG(:,11) Cond1(3).FiltEMG(:,11) Cond1(4).FiltEMG(:,11) Cond1(5).FiltEMG(:,11) Cond1(6).FiltEMG(:,11) Cond1(7).FiltEMG(:,11)];
LD_Cond1_Avg = mean(LD_alltrials_Cond1,2);
LD_Cond1_STD = std(LD_alltrials_Cond1,0,2);
PM_alltrials_Cond1 = [Cond1(1).FiltEMG(:,12) Cond1(2).FiltEMG(:,12) Cond1(3).FiltEMG(:,12) Cond1(4).FiltEMG(:,12) Cond1(5).FiltEMG(:,12) Cond1(6).FiltEMG(:,12) Cond1(7).FiltEMG(:,12)];
PM_Cond1_Avg = mean(PM_alltrials_Cond1,2);
PM_Cond1_STD = std(PM_alltrials_Cond1,0,2);
BIC_alltrials_Cond1 = [Cond1(1).FiltEMG(:,13) Cond1(2).FiltEMG(:,13) Cond1(3).FiltEMG(:,13) Cond1(4).FiltEMG(:,13) Cond1(5).FiltEMG(:,13) Cond1(6).FiltEMG(:,13) Cond1(7).FiltEMG(:,13)];
BIC_Cond1_Avg = mean(BIC_alltrials_Cond1,2);
BIC_Cond1_STD = std(BIC_alltrials_Cond1,0,2);
TRI_alltrials_Cond1 = [Cond1(1).FiltEMG(:,14) Cond1(2).FiltEMG(:,14) Cond1(3).FiltEMG(:,14) Cond1(4).FiltEMG(:,14) Cond1(5).FiltEMG(:,14) Cond1(6).FiltEMG(:,14) Cond1(7).FiltEMG(:,14)];
TRI_Cond1_Avg = mean(TRI_alltrials_Cond1,2);
TRI_Cond1_STD = std(TRI_alltrials_Cond1,0,2);
IDL_alltrials_Cond1 = [Cond1(1).FiltEMG(:,15) Cond1(2).FiltEMG(:,15) Cond1(3).FiltEMG(:,15) Cond1(4).FiltEMG(:,15) Cond1(5).FiltEMG(:,15) Cond1(6).FiltEMG(:,15) Cond1(7).FiltEMG(:,15)];
IDL_Cond1_Avg = mean(IDL_alltrials_Cond1,2);
IDL_Cond1_STD = std(IDL_alltrials_Cond1,0,2);


% Metria: 500 samples = 5 seconds

% Avg time max vel occurs 

 MeanMaxVel_Cond1 = mean([Cond1(1).TimestartTimeVelTimeEnd(2),Cond1(2).TimestartTimeVelTimeEnd(2),Cond1(3).TimestartTimeVelTimeEnd(2),Cond1(4).TimestartTimeVelTimeEnd(2),Cond1(5).TimestartTimeVelTimeEnd(2),Cond1(6).TimestartTimeVelTimeEnd(2),Cond1(7).TimestartTimeVelTimeEnd(2)])
 MeanStart_Cond1 = mean([Cond1(1).TimestartTimeVelTimeEnd(1),Cond1(2).TimestartTimeVelTimeEnd(1),Cond1(3).TimestartTimeVelTimeEnd(1),Cond1(4).TimestartTimeVelTimeEnd(1),Cond1(5).TimestartTimeVelTimeEnd(1),Cond1(6).TimestartTimeVelTimeEnd(1),Cond1(7).TimestartTimeVelTimeEnd(1)])

 %% Condition 2: 10 trials total 
UT_alltrials_Cond2 = [Cond2(1).FiltEMG(:,9) Cond2(2).FiltEMG(:,9) Cond2(3).FiltEMG(:,9) Cond2(4).FiltEMG(:,9) Cond2(5).FiltEMG(:,9) Cond2(6).FiltEMG(:,9) Cond2(7).FiltEMG(:,9)  Cond2(8).FiltEMG(:,9) Cond2(9).FiltEMG(:,9) Cond2(10).FiltEMG(:,9)];
UT_Cond2_Avg = mean(UT_alltrials_Cond2,2);
UT_Cond2_STD = std(UT_alltrials_Cond2,0,2);
MT_alltrials_Cond2 = [Cond2(1).FiltEMG(:,10) Cond2(2).FiltEMG(:,10) Cond2(3).FiltEMG(:,10) Cond2(4).FiltEMG(:,10) Cond2(5).FiltEMG(:,10) Cond2(6).FiltEMG(:,10) Cond2(7).FiltEMG(:,10) Cond2(8).FiltEMG(:,10) Cond2(9).FiltEMG(:,10) Cond2(10).FiltEMG(:,10)];
MT_Cond2_Avg = mean(MT_alltrials_Cond2,2);
MT_Cond2_STD = std(MT_alltrials_Cond2,0,2);
LD_alltrials_Cond2 = [Cond2(1).FiltEMG(:,11) Cond2(2).FiltEMG(:,11) Cond2(3).FiltEMG(:,11) Cond2(4).FiltEMG(:,11) Cond2(5).FiltEMG(:,11) Cond2(6).FiltEMG(:,11) Cond2(7).FiltEMG(:,11) Cond2(8).FiltEMG(:,11) Cond2(9).FiltEMG(:,11) Cond2(10).FiltEMG(:,11)];
LD_Cond2_Avg = mean(LD_alltrials_Cond2,2);
LD_Cond2_STD = std(LD_alltrials_Cond2,0,2);
PM_alltrials_Cond2 = [Cond2(1).FiltEMG(:,12) Cond2(2).FiltEMG(:,12) Cond2(3).FiltEMG(:,12) Cond2(4).FiltEMG(:,12) Cond2(5).FiltEMG(:,12) Cond2(6).FiltEMG(:,12) Cond2(7).FiltEMG(:,12) Cond2(8).FiltEMG(:,12) Cond2(9).FiltEMG(:,12) Cond2(10).FiltEMG(:,12)];
PM_Cond2_Avg = mean(PM_alltrials_Cond2,2);
PM_Cond2_STD = std(PM_alltrials_Cond2,0,2);
BIC_alltrials_Cond2 = [Cond2(1).FiltEMG(:,13) Cond2(2).FiltEMG(:,13) Cond2(3).FiltEMG(:,13) Cond2(4).FiltEMG(:,13) Cond2(5).FiltEMG(:,13) Cond2(6).FiltEMG(:,13) Cond2(7).FiltEMG(:,13) Cond2(8).FiltEMG(:,13) Cond2(9).FiltEMG(:,13) Cond2(10).FiltEMG(:,13)];
BIC_Cond2_Avg = mean(BIC_alltrials_Cond2,2);
BIC_Cond2_STD = std(BIC_alltrials_Cond2,0,2);
TRI_alltrials_Cond2 = [Cond2(1).FiltEMG(:,14) Cond2(2).FiltEMG(:,14) Cond2(3).FiltEMG(:,14) Cond2(4).FiltEMG(:,14) Cond2(5).FiltEMG(:,14) Cond2(6).FiltEMG(:,14) Cond2(7).FiltEMG(:,14) Cond2(8).FiltEMG(:,14) Cond2(9).FiltEMG(:,14) Cond2(10).FiltEMG(:,14)];
TRI_Cond2_Avg = mean(TRI_alltrials_Cond2,2);
TRI_Cond2_STD = std(TRI_alltrials_Cond2,0,2);
IDL_alltrials_Cond2 = [Cond2(1).FiltEMG(:,15) Cond2(2).FiltEMG(:,15) Cond2(3).FiltEMG(:,15) Cond2(4).FiltEMG(:,15) Cond2(5).FiltEMG(:,15) Cond2(6).FiltEMG(:,15) Cond2(7).FiltEMG(:,15) Cond2(8).FiltEMG(:,15) Cond2(9).FiltEMG(:,15) Cond2(10).FiltEMG(:,15)];
IDL_Cond2_Avg = mean(IDL_alltrials_Cond2,2);
IDL_Cond2_STD = std(IDL_alltrials_Cond2,0,2);

% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 

 MeanMaxVel_Cond2 = mean([Cond2(1).TimestartTimeVelTimeEnd(2),Cond2(2).TimestartTimeVelTimeEnd(2),Cond2(3).TimestartTimeVelTimeEnd(2),Cond2(4).TimestartTimeVelTimeEnd(2),Cond2(5).TimestartTimeVelTimeEnd(2),Cond2(6).TimestartTimeVelTimeEnd(2),Cond2(7).TimestartTimeVelTimeEnd(2),Cond2(8).TimestartTimeVelTimeEnd(2),Cond2(9).TimestartTimeVelTimeEnd(2),Cond2(10).TimestartTimeVelTimeEnd(2)])
 MeanStart_Cond2 = mean([Cond2(1).TimestartTimeVelTimeEnd(1),Cond2(2).TimestartTimeVelTimeEnd(1),Cond2(3).TimestartTimeVelTimeEnd(1),Cond2(4).TimestartTimeVelTimeEnd(1),Cond2(5).TimestartTimeVelTimeEnd(1),Cond2(6).TimestartTimeVelTimeEnd(1),Cond2(7).TimestartTimeVelTimeEnd(1),Cond2(8).TimestartTimeVelTimeEnd(1),Cond2(9).TimestartTimeVelTimeEnd(1),Cond2(10).TimestartTimeVelTimeEnd(1)])

 %% %% Condition 3: 10 trials total 

UT_alltrials_Cond3 = [Cond3(1).FiltEMG(:,9) Cond3(2).FiltEMG(:,9) Cond3(3).FiltEMG(:,9) Cond3(4).FiltEMG(:,9) Cond3(5).FiltEMG(:,9) Cond3(6).FiltEMG(:,9) Cond3(7).FiltEMG(:,9)  Cond3(8).FiltEMG(:,9) Cond3(9).FiltEMG(:,9) Cond3(10).FiltEMG(:,9)];
UT_Cond3_Avg = mean(UT_alltrials_Cond3,2);
UT_Cond3_STD = std(UT_alltrials_Cond3,0,2);
MT_alltrials_Cond3 = [Cond3(1).FiltEMG(:,10) Cond3(2).FiltEMG(:,10) Cond3(3).FiltEMG(:,10) Cond3(4).FiltEMG(:,10) Cond3(5).FiltEMG(:,10) Cond3(6).FiltEMG(:,10) Cond3(7).FiltEMG(:,10) Cond3(8).FiltEMG(:,10) Cond3(9).FiltEMG(:,10) Cond3(10).FiltEMG(:,10)];
MT_Cond3_Avg = mean(MT_alltrials_Cond3,2);
MT_Cond3_STD = std(MT_alltrials_Cond3,0,2);
LD_alltrials_Cond3 = [Cond3(1).FiltEMG(:,11) Cond3(2).FiltEMG(:,11) Cond3(3).FiltEMG(:,11) Cond3(4).FiltEMG(:,11) Cond3(5).FiltEMG(:,11) Cond3(6).FiltEMG(:,11) Cond3(7).FiltEMG(:,11) Cond3(8).FiltEMG(:,11) Cond3(9).FiltEMG(:,11) Cond3(10).FiltEMG(:,11)];
LD_Cond3_Avg = mean(LD_alltrials_Cond3,2);
LD_Cond3_STD = std(LD_alltrials_Cond3,0,2);
PM_alltrials_Cond3 = [Cond3(1).FiltEMG(:,12) Cond3(2).FiltEMG(:,12) Cond3(3).FiltEMG(:,12) Cond3(4).FiltEMG(:,12) Cond3(5).FiltEMG(:,12) Cond3(6).FiltEMG(:,12) Cond3(7).FiltEMG(:,12) Cond3(8).FiltEMG(:,12) Cond3(9).FiltEMG(:,12) Cond3(10).FiltEMG(:,12)];
PM_Cond3_Avg = mean(PM_alltrials_Cond3,2);
PM_Cond3_STD = std(PM_alltrials_Cond3,0,2);
BIC_alltrials_Cond3 = [Cond3(1).FiltEMG(:,13) Cond3(2).FiltEMG(:,13) Cond3(3).FiltEMG(:,13) Cond3(4).FiltEMG(:,13) Cond3(5).FiltEMG(:,13) Cond3(6).FiltEMG(:,13) Cond3(7).FiltEMG(:,13) Cond3(8).FiltEMG(:,13) Cond3(9).FiltEMG(:,13) Cond3(10).FiltEMG(:,13)];
BIC_Cond3_Avg = mean(BIC_alltrials_Cond3,2);
BIC_Cond3_STD = std(BIC_alltrials_Cond3,0,2);
TRI_alltrials_Cond3 = [Cond3(1).FiltEMG(:,14) Cond3(2).FiltEMG(:,14) Cond3(3).FiltEMG(:,14) Cond3(4).FiltEMG(:,14) Cond3(5).FiltEMG(:,14) Cond3(6).FiltEMG(:,14) Cond3(7).FiltEMG(:,14) Cond3(8).FiltEMG(:,14) Cond3(9).FiltEMG(:,14) Cond3(10).FiltEMG(:,14)];
TRI_Cond3_Avg= mean(TRI_alltrials_Cond3,2);
TRI_Cond3_STD = std(TRI_alltrials_Cond3,0,2);
IDL_alltrials_Cond3 = [Cond3(1).FiltEMG(:,15) Cond3(2).FiltEMG(:,15) Cond3(3).FiltEMG(:,15) Cond3(4).FiltEMG(:,15) Cond3(5).FiltEMG(:,15) Cond3(6).FiltEMG(:,15) Cond3(7).FiltEMG(:,15) Cond3(8).FiltEMG(:,15) Cond3(9).FiltEMG(:,15) Cond3(10).FiltEMG(:,15)];
IDL_Cond3_Avg = mean(IDL_alltrials_Cond3,2);
IDL_Cond3_STD = std(IDL_alltrials_Cond3,0,2);


% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 


 MeanMaxVel_Cond3 = mean([Cond3(1).TimestartTimeVelTimeEnd(2),Cond3(2).TimestartTimeVelTimeEnd(2),Cond3(3).TimestartTimeVelTimeEnd(2),Cond3(4).TimestartTimeVelTimeEnd(2),Cond3(5).TimestartTimeVelTimeEnd(2),Cond3(6).TimestartTimeVelTimeEnd(2),Cond3(7).TimestartTimeVelTimeEnd(2),Cond3(8).TimestartTimeVelTimeEnd(2),Cond3(9).TimestartTimeVelTimeEnd(2),Cond3(10).TimestartTimeVelTimeEnd(2)])
 MeanStart_Cond3 = mean([Cond3(1).TimestartTimeVelTimeEnd(1),Cond3(2).TimestartTimeVelTimeEnd(1),Cond3(3).TimestartTimeVelTimeEnd(1),Cond3(4).TimestartTimeVelTimeEnd(1),Cond3(5).TimestartTimeVelTimeEnd(1),Cond3(6).TimestartTimeVelTimeEnd(1),Cond3(7).TimestartTimeVelTimeEnd(1),Cond3(8).TimestartTimeVelTimeEnd(1),Cond3(9).TimestartTimeVelTimeEnd(1),Cond3(10).TimestartTimeVelTimeEnd(1)])

 %% Condition 4: 5 trials total 
 UT_alltrials_Cond4 = [Cond4(1).FiltEMG(:,9) Cond4(2).FiltEMG(:,9) Cond4(3).FiltEMG(:,9) Cond4(4).FiltEMG(:,9) Cond4(5).FiltEMG(:,9)];
 UT_Cond4_Avg =  mean(UT_alltrials_Cond4,2);
 UT_Cond4_STD = std(UT_alltrials_Cond4,0,2);
MT_alltrials_Cond4 = [Cond4(1).FiltEMG(:,10) Cond4(2).FiltEMG(:,10) Cond4(3).FiltEMG(:,10) Cond4(4).FiltEMG(:,10) Cond4(5).FiltEMG(:,10)];
MT_Cond4_Avg = mean(MT_alltrials_Cond4,2);
 MT_Cond4_STD = std(MT_alltrials_Cond4,0,2);
LD_alltrials_Cond4 = [Cond4(1).FiltEMG(:,11) Cond4(2).FiltEMG(:,11) Cond4(3).FiltEMG(:,11) Cond4(4).FiltEMG(:,11) Cond4(5).FiltEMG(:,11)];
LD_Cond4_Avg = mean(LD_alltrials_Cond4,2);
LD_Cond4_STD = std(LD_alltrials_Cond4,0,2);
PM_alltrials_Cond4 = [Cond4(1).FiltEMG(:,12) Cond4(2).FiltEMG(:,12) Cond4(3).FiltEMG(:,12) Cond4(4).FiltEMG(:,12) Cond4(5).FiltEMG(:,12)];
PM_Cond4_Avg = mean(PM_alltrials_Cond4,2);
PM_Cond4_STD = std(PM_alltrials_Cond4,0,2);
BIC_alltrials_Cond4 = [Cond4(1).FiltEMG(:,13) Cond4(2).FiltEMG(:,13) Cond4(3).FiltEMG(:,13) Cond4(4).FiltEMG(:,13) Cond4(5).FiltEMG(:,13)];
BIC_Cond4_Avg = mean(BIC_alltrials_Cond4,2);
BIC_Cond4_STD = std(BIC_alltrials_Cond4,0,2);
TRI_alltrials_Cond4 = [Cond4(1).FiltEMG(:,14) Cond4(2).FiltEMG(:,14) Cond4(3).FiltEMG(:,14) Cond4(4).FiltEMG(:,14) Cond4(5).FiltEMG(:,14)];
TRI_Cond4_Avg = mean(TRI_alltrials_Cond4,2);
TRI_Cond4_STD = std(TRI_alltrials_Cond4,0,2);
IDL_alltrials_Cond4 = [Cond4(1).FiltEMG(:,15) Cond4(2).FiltEMG(:,15) Cond4(3).FiltEMG(:,15) Cond4(4).FiltEMG(:,15) Cond4(5).FiltEMG(:,15)];
IDL_Cond4_Avg = mean(IDL_alltrials_Cond4,2);
IDL_Cond4_STD = std(IDL_alltrials_Cond4,0,2);


% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 
 MeanStart_Cond4 = mean([Cond4(1).TimestartTimeVelTimeEnd(1),Cond4(2).TimestartTimeVelTimeEnd(1),Cond4(3).TimestartTimeVelTimeEnd(1),Cond4(4).TimestartTimeVelTimeEnd(1),Cond4(5).TimestartTimeVelTimeEnd(1)])
 MeanMaxVel_Cond4 = mean([Cond4(1).TimestartTimeVelTimeEnd(2),Cond4(2).TimestartTimeVelTimeEnd(2),Cond4(3).TimestartTimeVelTimeEnd(2),Cond4(4).TimestartTimeVelTimeEnd(2),Cond4(5).TimestartTimeVelTimeEnd(2)])
 %% Condition 5: 10 trials total 
UT_alltrials_Cond5 = [Cond5(1).FiltEMG(:,9) Cond5(2).FiltEMG(:,9) Cond5(3).FiltEMG(:,9) Cond5(4).FiltEMG(:,9) Cond5(5).FiltEMG(:,9) Cond5(6).FiltEMG(:,9) Cond5(7).FiltEMG(:,9)  Cond5(8).FiltEMG(:,9) Cond5(9).FiltEMG(:,9) Cond5(10).FiltEMG(:,9)];
UT_Cond5_Avg = mean(UT_alltrials_Cond5,2);
UT_Cond5_STD = std(UT_alltrials_Cond5,0,2);
MT_alltrials_Cond5 = [Cond5(1).FiltEMG(:,10) Cond5(2).FiltEMG(:,10) Cond5(3).FiltEMG(:,10) Cond5(4).FiltEMG(:,10) Cond5(5).FiltEMG(:,10) Cond5(6).FiltEMG(:,10) Cond5(7).FiltEMG(:,10) Cond5(8).FiltEMG(:,10) Cond5(9).FiltEMG(:,10) Cond5(10).FiltEMG(:,10)];
MT_Cond5_Avg = mean(MT_alltrials_Cond5,2);
MT_Cond5_STD = std(MT_alltrials_Cond5,0,2);
LD_alltrials_Cond5 = [Cond5(1).FiltEMG(:,11) Cond5(2).FiltEMG(:,11) Cond5(3).FiltEMG(:,11) Cond5(4).FiltEMG(:,11) Cond5(5).FiltEMG(:,11) Cond5(6).FiltEMG(:,11) Cond5(7).FiltEMG(:,11) Cond5(8).FiltEMG(:,11) Cond5(9).FiltEMG(:,11) Cond5(10).FiltEMG(:,11)];
LD_Cond5_Avg = mean(LD_alltrials_Cond5,2);
LD_Cond5_STD = std(LD_alltrials_Cond5,0,2);
PM_alltrials_Cond5 = [Cond5(1).FiltEMG(:,12) Cond5(2).FiltEMG(:,12) Cond5(3).FiltEMG(:,12) Cond5(4).FiltEMG(:,12) Cond5(5).FiltEMG(:,12) Cond5(6).FiltEMG(:,12) Cond5(7).FiltEMG(:,12) Cond5(8).FiltEMG(:,12) Cond5(9).FiltEMG(:,12) Cond5(10).FiltEMG(:,12)];
PM_Cond5_Avg = mean(PM_alltrials_Cond5,2);
PM_Cond5_STD = std(PM_alltrials_Cond5,0,2);
BIC_alltrials_Cond5 = [Cond5(1).FiltEMG(:,13) Cond5(2).FiltEMG(:,13) Cond5(3).FiltEMG(:,13) Cond5(4).FiltEMG(:,13) Cond5(5).FiltEMG(:,13) Cond5(6).FiltEMG(:,13) Cond5(7).FiltEMG(:,13) Cond5(8).FiltEMG(:,13) Cond5(9).FiltEMG(:,13) Cond5(10).FiltEMG(:,13)];
BIC_Cond5_Avg = mean(BIC_alltrials_Cond5,2);
BIC_Cond5_STD = std(BIC_alltrials_Cond5,0,2);
TRI_alltrials_Cond5 = [Cond5(1).FiltEMG(:,14) Cond5(2).FiltEMG(:,14) Cond5(3).FiltEMG(:,14) Cond5(4).FiltEMG(:,14) Cond5(5).FiltEMG(:,14) Cond5(6).FiltEMG(:,14) Cond5(7).FiltEMG(:,14) Cond5(8).FiltEMG(:,14) Cond5(9).FiltEMG(:,14) Cond5(10).FiltEMG(:,14)];
TRI_Cond5_Avg = mean(TRI_alltrials_Cond5,2);
TRI_Cond5_STD = std(TRI_alltrials_Cond5,0,2);
IDL_alltrials_Cond5 = [Cond5(1).FiltEMG(:,15) Cond5(2).FiltEMG(:,15) Cond5(3).FiltEMG(:,15) Cond5(4).FiltEMG(:,15) Cond5(5).FiltEMG(:,15) Cond5(6).FiltEMG(:,15) Cond5(7).FiltEMG(:,15) Cond5(8).FiltEMG(:,15) Cond5(9).FiltEMG(:,15) Cond5(10).FiltEMG(:,15)];
IDL_Cond5_Avg = mean(IDL_alltrials_Cond5,2);
IDL_Cond5_STD = std(IDL_alltrials_Cond5,0,2);


% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 
 MeanStart_Cond5 = mean([Cond5(1).TimestartTimeVelTimeEnd(1),Cond5(2).TimestartTimeVelTimeEnd(1),Cond5(3).TimestartTimeVelTimeEnd(1),Cond5(4).TimestartTimeVelTimeEnd(1),Cond5(5).TimestartTimeVelTimeEnd(1),Cond5(6).TimestartTimeVelTimeEnd(1),Cond5(7).TimestartTimeVelTimeEnd(1),Cond5(8).TimestartTimeVelTimeEnd(1),Cond5(9).TimestartTimeVelTimeEnd(1),Cond5(10).TimestartTimeVelTimeEnd(1)])
 MeanMaxVel_Cond5 = mean([Cond5(1).TimestartTimeVelTimeEnd(2),Cond5(2).TimestartTimeVelTimeEnd(2),Cond5(3).TimestartTimeVelTimeEnd(2),Cond5(4).TimestartTimeVelTimeEnd(2),Cond5(5).TimestartTimeVelTimeEnd(2),Cond5(6).TimestartTimeVelTimeEnd(2),Cond5(7).TimestartTimeVelTimeEnd(2),Cond5(8).TimestartTimeVelTimeEnd(2),Cond5(9).TimestartTimeVelTimeEnd(2),Cond5(10).TimestartTimeVelTimeEnd(2)])
 %% Condition 6: 9 trials total 
UT_alltrials_Cond6 = [Cond6(1).FiltEMG(:,9) Cond6(2).FiltEMG(:,9) Cond6(3).FiltEMG(:,9) Cond6(4).FiltEMG(:,9) Cond6(5).FiltEMG(:,9) Cond6(6).FiltEMG(:,9) Cond6(7).FiltEMG(:,9)  Cond6(8).FiltEMG(:,9) Cond6(9).FiltEMG(:,9)];
UT_Cond6_Avg = mean(UT_alltrials_Cond6,2);
UT_Cond6_STD = std(UT_alltrials_Cond6,0,2);
MT_alltrials_Cond6 = [Cond6(1).FiltEMG(:,10) Cond6(2).FiltEMG(:,10) Cond6(3).FiltEMG(:,10) Cond6(4).FiltEMG(:,10) Cond6(5).FiltEMG(:,10) Cond6(6).FiltEMG(:,10) Cond6(7).FiltEMG(:,10) Cond6(8).FiltEMG(:,10) Cond6(9).FiltEMG(:,10)];
MT_Cond6_Avg = mean(MT_alltrials_Cond6,2);
MT_Cond6_STD = std(MT_alltrials_Cond6,0,2);
LD_alltrials_Cond6 = [Cond6(1).FiltEMG(:,11) Cond6(2).FiltEMG(:,11) Cond6(3).FiltEMG(:,11) Cond6(4).FiltEMG(:,11) Cond6(5).FiltEMG(:,11) Cond6(6).FiltEMG(:,11) Cond6(7).FiltEMG(:,11) Cond6(8).FiltEMG(:,11) Cond6(9).FiltEMG(:,11)];
LD_Cond6_Avg = mean(LD_alltrials_Cond6,2);
LD_Cond6_STD = std(LD_alltrials_Cond6,0,2);
PM_alltrials_Cond6 = [Cond6(1).FiltEMG(:,12) Cond6(2).FiltEMG(:,12) Cond6(3).FiltEMG(:,12) Cond6(4).FiltEMG(:,12) Cond6(5).FiltEMG(:,12) Cond6(6).FiltEMG(:,12) Cond6(7).FiltEMG(:,12) Cond6(8).FiltEMG(:,12) Cond6(9).FiltEMG(:,12)];
PM_Cond6_Avg = mean(PM_alltrials_Cond6,2);
PM_Cond6_STD = std(PM_alltrials_Cond6,0,2);
BIC_alltrials_Cond6 = [Cond6(1).FiltEMG(:,13) Cond6(2).FiltEMG(:,13) Cond6(3).FiltEMG(:,13) Cond6(4).FiltEMG(:,13) Cond6(5).FiltEMG(:,13) Cond6(6).FiltEMG(:,13) Cond6(7).FiltEMG(:,13) Cond6(8).FiltEMG(:,13) Cond6(9).FiltEMG(:,13)];
BIC_Cond6_Avg = mean(BIC_alltrials_Cond6,2);
BIC_Cond6_STD = std(BIC_alltrials_Cond6,0,2);
TRI_alltrials_Cond6 = [Cond6(1).FiltEMG(:,14) Cond6(2).FiltEMG(:,14) Cond6(3).FiltEMG(:,14) Cond6(4).FiltEMG(:,14) Cond6(5).FiltEMG(:,14) Cond6(6).FiltEMG(:,14) Cond6(7).FiltEMG(:,14) Cond6(8).FiltEMG(:,14) Cond6(9).FiltEMG(:,14)];
TRI_Cond6_Avg = mean(TRI_alltrials_Cond6,2);
TRI_Cond6_STD = std(TRI_alltrials_Cond6,0,2);
IDL_alltrials_Cond6 = [Cond6(1).FiltEMG(:,15) Cond6(2).FiltEMG(:,15) Cond6(3).FiltEMG(:,15) Cond6(4).FiltEMG(:,15) Cond6(5).FiltEMG(:,15) Cond6(6).FiltEMG(:,15) Cond6(7).FiltEMG(:,15) Cond6(8).FiltEMG(:,15) Cond6(9).FiltEMG(:,15)];
IDL_Cond6_Avg = mean(IDL_alltrials_Cond6,2);
IDL_Cond6_STD = std(IDL_alltrials_Cond6,0,2);


% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 
 MeanStart_Cond6 = mean([Cond6(1).TimestartTimeVelTimeEnd(1),Cond6(2).TimestartTimeVelTimeEnd(1),Cond6(3).TimestartTimeVelTimeEnd(1),Cond6(4).TimestartTimeVelTimeEnd(1),Cond6(5).TimestartTimeVelTimeEnd(1),Cond6(6).TimestartTimeVelTimeEnd(1),Cond6(7).TimestartTimeVelTimeEnd(1),Cond6(8).TimestartTimeVelTimeEnd(1),Cond6(9).TimestartTimeVelTimeEnd(1)])

 MeanMaxVel_Cond6 = mean([Cond6(1).TimestartTimeVelTimeEnd(2),Cond6(2).TimestartTimeVelTimeEnd(2),Cond6(3).TimestartTimeVelTimeEnd(2),Cond6(4).TimestartTimeVelTimeEnd(2),Cond6(5).TimestartTimeVelTimeEnd(2),Cond6(6).TimestartTimeVelTimeEnd(2),Cond6(7).TimestartTimeVelTimeEnd(2),Cond6(8).TimestartTimeVelTimeEnd(2),Cond6(9).TimestartTimeVelTimeEnd(2)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mass Plot Conditions 1-3 (Restrained) USE!!!!!!!! Nov 2024 - All Trials


% All Conditions and trials velocities and arm activations with averages
% per condition plotted too. 

fig = figure(1);
orient(fig,'portrait')
for m = 1:7 % 7 trials in Condition 1
subplot(8,6,1) % Condition 1 Velocity Plot All Trials
plot(Cond1(m).tmet,smoothdata(Cond1(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond1(m).tmet(1:500),smoothdata(AllTrialsVel_Cond1_AVG)/1000,'LineWidth',5) %Average for all trials in condition 1
end
title('Restrained-T','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,7)
plot(Cond1(m).emgtimevec,smoothdata(UT_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(UT_Cond1_Avg),'LineWidth',5)
end 
ylabel('UT','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,13)
plot(Cond1(m).emgtimevec,smoothdata(MT_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(MT_Cond1_Avg),'LineWidth',5)
end 
ylabel('MT','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,19)
plot(Cond1(m).emgtimevec,smoothdata(LD_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(LD_Cond1_Avg),'LineWidth',5)
end 
ylabel('LD','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,43)
plot(Cond1(m).emgtimevec,smoothdata(PM_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(PM_Cond1_Avg),'LineWidth',5)
end 
ylabel('PM','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,31) 
plot(Cond1(m).emgtimevec,smoothdata(BIC_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(BIC_Cond1_Avg),'LineWidth',5)
end 
ylabel('BIC','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,37)
plot(Cond1(m).emgtimevec,smoothdata(TRI_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(TRI_Cond1_Avg),'LineWidth',5)
end 
ylabel('TRI','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,25) 
plot(Cond1(m).emgtimevec,smoothdata(IDL_alltrials_Cond1(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond1(m).emgtimevec,smoothdata(IDL_Cond1_Avg),'LineWidth',5)
end 
ylabel('IDL','FontSize',16)
ylim([0 1])
xlim([0 5])
end

figure(1)
for m = 1:5 % 5 trials in Condition 4
subplot(8,6,2) % Condition 4 Velocity Plot All Trials
plot(Cond4(m).tmet,smoothdata(Cond4(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond4(m).tmet(1:500),smoothdata(AllTrialsVel_Cond4_AVG)/1000,'LineWidth',5) %Average for all trials in condition 1
end
title('Unrestrained-T','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,8)
plot(Cond4(m).emgtimevec,smoothdata(UT_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(UT_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,14)
plot(Cond4(m).emgtimevec,smoothdata(MT_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(MT_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,20)
plot(Cond4(m).emgtimevec,smoothdata(LD_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(LD_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,44)
plot(Cond4(m).emgtimevec,smoothdata(PM_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(PM_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,32) 
plot(Cond4(m).emgtimevec,smoothdata(BIC_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(BIC_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,38)
plot(Cond4(m).emgtimevec,smoothdata(TRI_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(TRI_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,26) 
plot(Cond4(m).emgtimevec,smoothdata(IDL_alltrials_Cond4(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond4(m).emgtimevec,smoothdata(IDL_Cond4_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
end

figure(1)
for m = 1:10 % 10 trials in Condition 2
subplot(8,6,3) % Condition 2 Velocity Plot All Trials
plot(Cond2(m).tmet,smoothdata(Cond2(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond2(m).tmet(1:500),smoothdata(AllTrialsVel_Cond2_AVG)/1000,'LineWidth',5) %Average for all trials in condition 1
end
title('Restrained-25','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,9)
plot(Cond2(m).emgtimevec,smoothdata(UT_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(UT_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,15)
plot(Cond2(m).emgtimevec,smoothdata(MT_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(MT_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,21)
plot(Cond2(m).emgtimevec,smoothdata(LD_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(LD_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,45)
plot(Cond2(m).emgtimevec,smoothdata(PM_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(PM_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,33) 
plot(Cond2(m).emgtimevec,smoothdata(BIC_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(BIC_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,39)
plot(Cond2(m).emgtimevec,smoothdata(TRI_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(TRI_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,27) 
plot(Cond2(m).emgtimevec,smoothdata(IDL_alltrials_Cond2(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond2(m).emgtimevec,smoothdata(IDL_Cond2_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
end



% Mass Plot Conditions 4-6 (Unrestrained) USE!!!!!!!! Nov 2024


%Conditions 4-6
figure(1)
for m = 1:10 % 10 trials in Condition 5
subplot(8,6,4) % Condition 5 Velocity Plot All Trials
plot(Cond5(m).tmet,smoothdata(Cond5(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond5(m).tmet(1:500),smoothdata(AllTrialsVel_Cond5_AVG)/1000,'LineWidth',5) %Average for all trials in condition 5
end
title('Unrestrained-25','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,10)
plot(Cond5(m).emgtimevec,smoothdata(UT_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(UT_Cond5_Avg),'LineWidth',5)
end 
%ylabel('UT','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,16)
plot(Cond5(m).emgtimevec,smoothdata(MT_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(MT_Cond5_Avg),'LineWidth',5)
end 
%ylabel('MT','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,22)
plot(Cond5(m).emgtimevec,smoothdata(LD_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(LD_Cond5_Avg),'LineWidth',5)
end 
%ylabel('LD','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,46)
plot(Cond5(m).emgtimevec,smoothdata(PM_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(PM_Cond5_Avg),'LineWidth',5)
end 
%ylabel('PM','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,34) 
plot(Cond5(m).emgtimevec,smoothdata(BIC_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(BIC_Cond5_Avg),'LineWidth',5)
end 
%ylabel('BIC','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,40)
plot(Cond5(m).emgtimevec,smoothdata(TRI_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(TRI_Cond5_Avg),'LineWidth',5)
end 
% ylabel('TRI','FontSize',16)
ylim([0 1])
xlim([0 5])
subplot(8,6,28) 
plot(Cond5(m).emgtimevec,smoothdata(IDL_alltrials_Cond5(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond5(m).emgtimevec,smoothdata(IDL_Cond5_Avg),'LineWidth',5)
end 
%ylabel('IDL','FontSize',16)
ylim([0 1])
xlim([0 5])
end

figure(1)
for m = 1:10 % 10 trials in Condition 3
subplot(8,6,5) % Condition 2 Velocity Plot All Trials
plot(Cond3(m).tmet,smoothdata(Cond3(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond3(m).tmet(1:500),smoothdata(AllTrialsVel_Cond3_AVG)/1000,'LineWidth',5) %Average for all trials in condition 3
end
title('Restrained-50','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,11)
plot(Cond3(m).emgtimevec,smoothdata(UT_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(UT_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,17)
plot(Cond3(m).emgtimevec,smoothdata(MT_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(MT_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,23)
plot(Cond3(m).emgtimevec,smoothdata(LD_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(LD_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,47)
plot(Cond3(m).emgtimevec,smoothdata(PM_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(PM_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,35) 
plot(Cond3(m).emgtimevec,smoothdata(BIC_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(BIC_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,41)
plot(Cond3(m).emgtimevec,smoothdata(TRI_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(TRI_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,29) 
plot(Cond3(m).emgtimevec,smoothdata(IDL_alltrials_Cond3(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond3(m).emgtimevec,smoothdata(IDL_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
end

figure(1)
for m = 1:9 % 9 trials in Condition 6
subplot(8,6,6) % Condition 6 Velocity Plot All Trials
plot(Cond6(m).tmet,smoothdata(Cond6(m).vel)/1000,'LineWidth',2)
hold on
if m==1
plot(Cond6(m).tmet(1:500),smoothdata(AllTrialsVel_Cond6_AVG)/1000,'LineWidth',5) %Average for all trials in condition 6
end
title('Unrestrained-50','FontSize',18)
xlim([0 5])
ylim([-5 5])
hold on
subplot(8,6,12)
plot(Cond6(m).emgtimevec,smoothdata(UT_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(UT_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,18)
plot(Cond6(m).emgtimevec,smoothdata(MT_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(MT_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,24)
plot(Cond6(m).emgtimevec,smoothdata(LD_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(LD_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,48)
plot(Cond6(m).emgtimevec,smoothdata(PM_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(PM_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,36) 
plot(Cond6(m).emgtimevec,smoothdata(BIC_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(BIC_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,42)
plot(Cond6(m).emgtimevec,smoothdata(TRI_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(TRI_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
subplot(8,6,30) 
plot(Cond6(m).emgtimevec,smoothdata(IDL_alltrials_Cond6(:,:)),'LineWidth',1)
hold on
if m ==1 
plot(Cond6(m).emgtimevec,smoothdata(IDL_Cond3_Avg),'LineWidth',5)
end 
ylim([0 1])
xlim([0 5])
end


%% Average Traces of Velocities 

% Condition 1 Across all Trials - 7 trials for first 5 seconds
AllTrialsVel_Cond1_AVG = [Cond1(1).vel(1:500) Cond1(2).vel(1:500) Cond1(3).vel(1:500) Cond1(4).vel(1:500) Cond1(5).vel(1:500) Cond1(6).vel(1:500) Cond1(7).vel(1:500)]
AllTrialsVel_Cond1_AVG = mean(AllTrialsVel_Cond1_AVG,2);
AllTrialsVel_Cond2_AVG = [Cond2(1).vel(1:500) Cond2(2).vel(1:500) Cond2(3).vel(1:500) Cond2(4).vel(1:500) Cond2(5).vel(1:500) Cond2(6).vel(1:500) Cond2(7).vel(1:500) Cond2(8).vel(1:500) Cond2(9).vel(1:500) Cond2(10).vel(1:500)]
AllTrialsVel_Cond2_AVG = mean(AllTrialsVel_Cond2_AVG,2);
AllTrialsVel_Cond3_AVG = [Cond3(1).vel(1:500) Cond3(2).vel(1:500) Cond3(3).vel(1:500) Cond3(4).vel(1:500) Cond3(5).vel(1:500) Cond3(6).vel(1:500) Cond3(7).vel(1:500) Cond3(8).vel(1:500) Cond3(9).vel(1:500) Cond3(10).vel(1:500)]
AllTrialsVel_Cond3_AVG = mean(AllTrialsVel_Cond3_AVG,2);
AllTrialsVel_Cond4_AVG = [Cond4(1).vel(1:500) Cond4(2).vel(1:500) Cond4(3).vel(1:500) Cond4(4).vel(1:500) Cond4(5).vel(1:500)]
AllTrialsVel_Cond4_AVG = mean(AllTrialsVel_Cond4_AVG,2);
AllTrialsVel_Cond5_AVG = [Cond5(1).vel(1:500) Cond5(2).vel(1:500) Cond5(3).vel(1:500) Cond5(4).vel(1:500) Cond5(5).vel(1:500) Cond5(6).vel(1:500) Cond5(7).vel(1:500) Cond5(8).vel(1:500) Cond5(9).vel(1:500) Cond5(10).vel(1:500)]
AllTrialsVel_Cond5_AVG= mean(AllTrialsVel_Cond5_AVG,2);
AllTrialsVel_Cond6_AVG = [Cond6(1).vel(1:500) Cond6(2).vel(1:500) Cond6(3).vel(1:500) Cond6(4).vel(1:500) Cond6(5).vel(1:500) Cond6(6).vel(1:500) Cond6(7).vel(1:500) Cond6(8).vel(1:500) Cond6(9).vel(1:500)]
AllTrialsVel_Cond5_AVG = mean(AllTrialsVel_Cond6_AVG,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
figure()
subplot(1,2,1)
plot(Cond6(1).tmet,smoothdata(Cond6(1).vel)/1000,'k','LineWidth',2)
hold on
 xline(MeanMaxVel,'m','LineWidth',2)

plot(Cond6(2).tmet,smoothdata(Cond6(2).vel)/1000,'k','LineWidth',2)
plot(Cond6(3).tmet,smoothdata(Cond6(3).vel)/1000,'k','LineWidth',2)
plot(Cond6(4).tmet,smoothdata(Cond6(4).vel)/1000,'k', 'LineWidth',2)
plot(Cond6(5).tmet,smoothdata(Cond6(5).vel)/1000,'k','LineWidth',2)
plot(Cond6(6).tmet,smoothdata(Cond6(6).vel)/1000,'k','LineWidth',2)
plot(Cond6(7).tmet,smoothdata(Cond6(7).vel)/1000,'k','LineWidth',2)
plot(Cond6(8).tmet,smoothdata(Cond6(8).vel)/1000,'k','LineWidth',2)
plot(Cond6(9).tmet,smoothdata(Cond6(9).vel)/1000,'k','LineWidth',2)
% plot(Cond6(10).tmet,smoothdata(Cond6(10).vel)/1000,'k','LineWidth',2)

ylabel('Velocity (m/s)','FontSize',18)
yyaxis right
plot(Cond6(1).tmet,smoothdata(Cond6(1).dist)/1000,'b-','LineWidth',.75)
hold on
plot(Cond6(2).tmet,smoothdata(Cond6(2).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(3).tmet,smoothdata(Cond6(3).dist)/1000,'b-', 'LineWidth',.75)
plot(Cond6(4).tmet,smoothdata(Cond6(4).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(5).tmet,smoothdata(Cond6(5).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(6).tmet,smoothdata(Cond6(6).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(7).tmet,smoothdata(Cond6(7).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(8).tmet,smoothdata(Cond6(8).dist)/1000,'b-','LineWidth',.75)
plot(Cond6(9).tmet,smoothdata(Cond6(9).dist)/1000,'b-','LineWidth',.75)
% plot(Cond6(10).tmet,smoothdata(Cond6(10).dist)/1000,'b-','LineWidth',.75)

ylabel('Distance (m)','FontSize',18)
xlim([0 5])
xlabel('Time (seconds)','FontSize',18)
title('Condition 6','FontSize',25)


subplot(1,2,2)

plot(Cond6(1).emgtimevec,smoothdata(UT_alltrials_Cond6(:,:)),'b','LineWidth',1)
plot(Cond6(1).emgtimevec,smoothdata(MT_alltrials_Cond6(:,:)),'b','LineWidth',1)
plot(Cond6(1).emgtimevec,smoothdata(LD_alltrials_Cond6(:,:)),'b','LineWidth',1)
plot(Cond6(1).emgtimevec,smoothdata(PM_alltrials_Cond6(:,:)),'b','LineWidth',1)
 plot(Cond6(1).emgtimevec,smoothdata(BIC_alltrials_Cond6(:,:)),'b','LineWidth',1)
plot(Cond6(1).emgtimevec,smoothdata(TRI_alltrials_Cond6(:,:)),'b','LineWidth',1)
plot(Cond6(1).emgtimevec,smoothdata(IDL_alltrials_Cond6(:,:)),'b','LineWidth',1)

 xline(MeanMaxVel,'m','LineWidth',2)
% xline(Cond6(2).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond6(3).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond6(4).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond6(5).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond6(6).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond6(7).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
xlabel('Time (seconds)','FontSize',18)
ylabel('Muscle Activation','FontSize',18)
title('Condition 6- IDL','FontSize',25)
%%
% Mean trace for all trials in condition 1 : size is 3000x1
meanUT_Cond1 = mean(UT_alltrials_Cond1,2); 
meanMT_Cond1 = mean(MT_alltrials_Cond1,2); 
meanLD_Cond1 = mean(LD_alltrials_Cond1,2); 
meanPM_Cond1 = mean(PM_alltrials_Cond1,2); 
meanBIC_Cond1 = mean(BIC_alltrials_Cond1,2); 
meanTRI_Cond1 = mean(TRI_alltrials_Cond1,2); 
meanIDL_Cond1 = mean(IDL_alltrials_Cond1,2); 


%% Condition 1: 7 trials total 

UT_alltrials_Cond1 = [Cond1(1).emgcut(:,9) Cond1(2).emgcut(:,9) Cond1(3).emgcut(:,9) Cond1(4).emgcut(:,9) Cond1(5).emgcut(:,9) Cond1(6).emgcut(:,9) Cond1(7).emgcut(:,9)];
MT_alltrials_Cond1 = [Cond1(1).emgcut(:,10) Cond1(2).emgcut(:,10) Cond1(3).emgcut(:,10) Cond1(4).emgcut(:,10) Cond1(5).emgcut(:,10) Cond1(6).emgcut(:,10) Cond1(7).emgcut(:,10)];
LD_alltrials_Cond1 = [Cond1(1).emgcut(:,11) Cond1(2).emgcut(:,11) Cond1(3).emgcut(:,11) Cond1(4).emgcut(:,11) Cond1(5).emgcut(:,11) Cond1(6).emgcut(:,11) Cond1(7).emgcut(:,11)];
PM_alltrials_Cond1 = [Cond1(1).emgcut(:,12) Cond1(2).emgcut(:,12) Cond1(3).emgcut(:,12) Cond1(4).emgcut(:,12) Cond1(5).emgcut(:,12) Cond1(6).emgcut(:,12) Cond1(7).emgcut(:,12)];
BIC_alltrials_Cond1 = [Cond1(1).emgcut(:,13) Cond1(2).emgcut(:,13) Cond1(3).emgcut(:,13) Cond1(4).emgcut(:,13) Cond1(5).emgcut(:,13) Cond1(6).emgcut(:,13) Cond1(7).emgcut(:,13)];
TRI_alltrials_Cond1 = [Cond1(1).emgcut(:,14) Cond1(2).emgcut(:,14) Cond1(3).emgcut(:,14) Cond1(4).emgcut(:,14) Cond1(5).emgcut(:,14) Cond1(6).emgcut(:,14) Cond1(7).emgcut(:,14)];
IDL_alltrials_Cond1 = [Cond1(1).emgcut(:,15) Cond1(2).emgcut(:,15) Cond1(3).emgcut(:,15) Cond1(4).emgcut(:,15) Cond1(5).emgcut(:,15) Cond1(6).emgcut(:,15) Cond1(7).emgcut(:,15)];

% Mean trace for all trials in condition 1 : size is 3000x1
meanUT_Cond1 = mean(UT_alltrials_Cond1,2); 
meanMT_Cond1 = mean(MT_alltrials_Cond1,2); 
meanLD_Cond1 = mean(LD_alltrials_Cond1,2); 
meanPM_Cond1 = mean(PM_alltrials_Cond1,2); 
meanBIC_Cond1 = mean(BIC_alltrials_Cond1,2); 
meanTRI_Cond1 = mean(TRI_alltrials_Cond1,2); 
meanIDL_Cond1 = mean(IDL_alltrials_Cond1,2); 

% Velocity




%%

% Condition 2 - 9 trials  (Kacey ommitted 5 bc issue FIX later)
UT_alltrials_Cond2 = [Cond2(1).emgcut(:,9) Cond2(2).emgcut(:,9) Cond2(3).emgcut(:,9) Cond2(4).emgcut(:,9) Cond2(6).emgcut(:,9) Cond2(7).emgcut(:,9) Cond2(8).emgcut(:,9) Cond2(9).emgcut(:,9) Cond2(10).emgcut(:,9)];
MT_alltrials_Cond2 = [Cond2(1).emgcut(:,10) Cond2(2).emgcut(:,10) Cond2(3).emgcut(:,10) Cond2(4).emgcut(:,10) Cond2(6).emgcut(:,10) Cond2(7).emgcut(:,10) Cond2(8).emgcut(:,10) Cond2(9).emgcut(:,10) Cond2(10).emgcut(:,10)];
LD_alltrials_Cond2= [Cond2(1).emgcut(:,11) Cond2(2).emgcut(:,11) Cond2(3).emgcut(:,11) Cond2(4).emgcut(:,11) Cond2(6).emgcut(:,11) Cond2(7).emgcut(:,11) Cond2(8).emgcut(:,11) Cond2(9).emgcut(:,11) Cond2(10).emgcut(:,11)];
PM_alltrials_Cond2 = [Cond2(1).emgcut(:,12) Cond2(2).emgcut(:,12) Cond2(3).emgcut(:,12) Cond2(4).emgcut(:,12) Cond2(6).emgcut(:,12) Cond2(7).emgcut(:,12) Cond2(8).emgcut(:,12) Cond2(9).emgcut(:,12) Cond2(10).emgcut(:,12)];
BIC_alltrials_Cond2 = [Cond2(1).emgcut(:,13) Cond2(2).emgcut(:,13) Cond2(3).emgcut(:,13) Cond2(4).emgcut(:,13) Cond2(6).emgcut(:,13) Cond2(7).emgcut(:,13) Cond2(8).emgcut(:,13) Cond2(9).emgcut(:,13) Cond2(10).emgcut(:,13)];
TRI_alltrials_Cond2  = [Cond2(1).emgcut(:,14) Cond2(2).emgcut(:,14) Cond2(3).emgcut(:,14) Cond2(4).emgcut(:,14) Cond2(6).emgcut(:,14) Cond2(7).emgcut(:,14) Cond2(8).emgcut(:,14) Cond2(9).emgcut(:,14) Cond2(10).emgcut(:,14)];
IDL_alltrials_Cond2 = [Cond2(1).emgcut(:,15) Cond2(2).emgcut(:,15) Cond2(3).emgcut(:,15) Cond2(4).emgcut(:,15) Cond2(6).emgcut(:,15) Cond2(7).emgcut(:,15) Cond2(8).emgcut(:,15) Cond2(9).emgcut(:,15) Cond2(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 2
meanUT_Cond2 = mean(UT_alltrials_Cond2,2); 
meanMT_Cond2 = mean(UT_alltrials_Cond2,2); 
meanLD_Cond2 = mean(UT_alltrials_Cond2,2); 
meanPM_Cond2 = mean(UT_alltrials_Cond2,2); 
meanBIC_Cond2 = mean(UT_alltrials_Cond2,2); 
meanTRI_Cond2 = mean(UT_alltrials_Cond2,2); 
meanIDL_Cond2 = mean(UT_alltrials_Cond2,2); 





%% Condition 3
%  10 trials
UT_alltrials_Cond3 = [Cond3(1).emgcut(:,9) Cond3(2).emgcut(:,9) Cond3(3).emgcut(:,9) Cond3(4).emgcut(:,9) Cond3(5).emgcut(:,9) Cond3(6).emgcut(:,9) Cond3(7).emgcut(:,9) Cond3(8).emgcut(:,9) Cond3(9).emgcut(:,9) Cond3(10).emgcut(:,9)];
MT_alltrials_Cond3 = [Cond3(1).emgcut(:,10) Cond3(2).emgcut(:,10) Cond3(3).emgcut(:,10) Cond3(4).emgcut(:,10) Cond3(5).emgcut(:,10) Cond3(6).emgcut(:,10) Cond3(7).emgcut(:,10) Cond3(8).emgcut(:,10) Cond3(9).emgcut(:,10) Cond3(10).emgcut(:,10)];
LD_alltrials_Cond3= [Cond3(1).emgcut(:,11) Cond3(2).emgcut(:,11) Cond3(3).emgcut(:,11) Cond3(4).emgcut(:,11) Cond3(5).emgcut(:,11) Cond3(6).emgcut(:,11) Cond3(7).emgcut(:,11) Cond3(8).emgcut(:,11) Cond3(9).emgcut(:,11) Cond3(10).emgcut(:,11)];
PM_alltrials_Cond3 = [Cond3(1).emgcut(:,12) Cond3(2).emgcut(:,12) Cond3(3).emgcut(:,12) Cond3(4).emgcut(:,12) Cond3(5).emgcut(:,12) Cond3(6).emgcut(:,12) Cond3(7).emgcut(:,12) Cond3(8).emgcut(:,12) Cond3(9).emgcut(:,12) Cond3(10).emgcut(:,12)];
BIC_alltrials_Cond3 = [Cond3(1).emgcut(:,13) Cond3(2).emgcut(:,13) Cond3(3).emgcut(:,13) Cond3(4).emgcut(:,13) Cond3(5).emgcut(:,13) Cond3(6).emgcut(:,13) Cond3(7).emgcut(:,13) Cond3(8).emgcut(:,13) Cond3(9).emgcut(:,13) Cond3(10).emgcut(:,13)];
TRI_alltrials_Cond3  = [Cond3(1).emgcut(:,14) Cond3(2).emgcut(:,14) Cond3(3).emgcut(:,14) Cond3(4).emgcut(:,14) Cond3(5).emgcut(:,14) Cond3(6).emgcut(:,14) Cond3(7).emgcut(:,14) Cond3(8).emgcut(:,14) Cond3(9).emgcut(:,14) Cond3(10).emgcut(:,14)];
IDL_alltrials_Cond3 = [Cond3(1).emgcut(:,15) Cond3(2).emgcut(:,15) Cond3(3).emgcut(:,15) Cond3(4).emgcut(:,15) Cond3(5).emgcut(:,15) Cond3(6).emgcut(:,15) Cond3(7).emgcut(:,15) Cond3(8).emgcut(:,15) Cond3(9).emgcut(:,15) Cond3(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond3 = mean(UT_alltrials_Cond3,2); 
meanMT_Cond3 = mean(UT_alltrials_Cond3,2); 
meanLD_Cond3 = mean(UT_alltrials_Cond3,2); 
meanPM_Cond3 = mean(UT_alltrials_Cond3,2); 
meanBIC_Cond3 = mean(UT_alltrials_Cond3,2); 
meanTRI_Cond3 = mean(UT_alltrials_Cond3,2); 
meanIDL_Cond3 = mean(UT_alltrials_Cond3,2); 




%% Condition 4
% 5 trials
UT_alltrials_Cond4 = [Cond4(1).emgcut(:,9) Cond4(2).emgcut(:,9) Cond4(3).emgcut(:,9) Cond4(4).emgcut(:,9) Cond4(5).emgcut(:,9)];
MT_alltrials_Cond4 = [Cond4(1).emgcut(:,10) Cond4(2).emgcut(:,10) Cond4(3).emgcut(:,10) Cond4(4).emgcut(:,10) Cond4(5).emgcut(:,10)];
LD_alltrials_Cond4= [Cond4(1).emgcut(:,11) Cond4(2).emgcut(:,11) Cond4(3).emgcut(:,11) Cond4(4).emgcut(:,11) Cond4(5).emgcut(:,11)];
PM_alltrials_Cond4 = [Cond4(1).emgcut(:,12) Cond4(2).emgcut(:,12) Cond4(3).emgcut(:,12) Cond4(4).emgcut(:,12) Cond4(5).emgcut(:,12)];
BIC_alltrials_Cond4 = [Cond4(1).emgcut(:,13) Cond4(2).emgcut(:,13) Cond4(3).emgcut(:,13) Cond4(4).emgcut(:,13) Cond4(5).emgcut(:,13)];
TRI_alltrials_Cond4  = [Cond4(1).emgcut(:,14) Cond4(2).emgcut(:,14) Cond4(3).emgcut(:,14) Cond4(4).emgcut(:,14) Cond4(5).emgcut(:,14)];
IDL_alltrials_Cond4 = [Cond4(1).emgcut(:,15) Cond4(2).emgcut(:,15) Cond4(3).emgcut(:,15) Cond4(4).emgcut(:,15) Cond4(5).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond4 = mean(UT_alltrials_Cond4,2); 
meanMT_Cond4 = mean(UT_alltrials_Cond4,2); 
meanLD_Cond4 = mean(UT_alltrials_Cond4,2); 
meanPM_Cond4 = mean(UT_alltrials_Cond4,2); 
meanBIC_Cond4 = mean(UT_alltrials_Cond4,2); 
meanTRI_Cond4 = mean(UT_alltrials_Cond4,2); 
meanIDL_Cond4 = mean(UT_alltrials_Cond4,2); 




%% Condition 5

%  10 trials
UT_alltrials_Cond5 = [Cond5(1).emgcut(:,9) Cond5(2).emgcut(:,9) Cond5(3).emgcut(:,9) Cond5(4).emgcut(:,9) Cond5(5).emgcut(:,9) Cond5(6).emgcut(:,9) Cond5(7).emgcut(:,9) Cond5(8).emgcut(:,9) Cond5(9).emgcut(:,9) Cond5(10).emgcut(:,9)];
MT_alltrials_Cond5 = [Cond5(1).emgcut(:,10) Cond5(2).emgcut(:,10) Cond5(3).emgcut(:,10) Cond5(4).emgcut(:,10) Cond5(5).emgcut(:,10) Cond5(6).emgcut(:,10) Cond5(7).emgcut(:,10) Cond5(8).emgcut(:,10) Cond5(9).emgcut(:,10) Cond5(10).emgcut(:,10)];
LD_alltrials_Cond5= [Cond5(1).emgcut(:,11) Cond5(2).emgcut(:,11) Cond5(3).emgcut(:,11) Cond5(4).emgcut(:,11) Cond5(5).emgcut(:,11) Cond5(6).emgcut(:,11) Cond5(7).emgcut(:,11) Cond5(8).emgcut(:,11) Cond5(9).emgcut(:,11) Cond5(10).emgcut(:,11)];
PM_alltrials_Cond5 = [Cond5(1).emgcut(:,12) Cond5(2).emgcut(:,12) Cond5(3).emgcut(:,12) Cond5(4).emgcut(:,12) Cond5(5).emgcut(:,12) Cond5(6).emgcut(:,12) Cond5(7).emgcut(:,12) Cond5(8).emgcut(:,12) Cond5(9).emgcut(:,12) Cond5(10).emgcut(:,12)];
BIC_alltrials_Cond5 = [Cond5(1).emgcut(:,13) Cond5(2).emgcut(:,13) Cond5(3).emgcut(:,13) Cond5(4).emgcut(:,13) Cond5(5).emgcut(:,13) Cond5(6).emgcut(:,13) Cond5(7).emgcut(:,13) Cond5(8).emgcut(:,13) Cond5(9).emgcut(:,13) Cond5(10).emgcut(:,13)];
TRI_alltrials_Cond5  = [Cond5(1).emgcut(:,14) Cond5(2).emgcut(:,14) Cond5(3).emgcut(:,14) Cond5(4).emgcut(:,14) Cond5(5).emgcut(:,14) Cond5(6).emgcut(:,14) Cond5(7).emgcut(:,14) Cond5(8).emgcut(:,14) Cond5(9).emgcut(:,14) Cond5(10).emgcut(:,14)];
IDL_alltrials_Cond5 = [Cond5(1).emgcut(:,15) Cond5(2).emgcut(:,15) Cond5(3).emgcut(:,15) Cond5(4).emgcut(:,15) Cond5(5).emgcut(:,15) Cond5(6).emgcut(:,15) Cond5(7).emgcut(:,15) Cond5(8).emgcut(:,15) Cond5(9).emgcut(:,15) Cond5(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond5 = mean(UT_alltrials_Cond5,2); 
meanMT_Cond5 = mean(UT_alltrials_Cond5,2); 
meanLD_Cond5 = mean(UT_alltrials_Cond5,2); 
meanPM_Cond5 = mean(UT_alltrials_Cond5,2); 
meanBIC_Cond5 = mean(UT_alltrials_Cond5,2); 
meanTRI_Cond5 = mean(UT_alltrials_Cond5,2); 
meanIDL_Cond5 = mean(UT_alltrials_Cond5,2); 





%% Condition 6 
%  9 trials
UT_alltrials_Cond6 = [Cond6(1).emgcut(:,9) Cond6(2).emgcut(:,9) Cond6(3).emgcut(:,9) Cond6(4).emgcut(:,9) Cond6(5).emgcut(:,9) Cond6(6).emgcut(:,9) Cond6(7).emgcut(:,9) Cond6(8).emgcut(:,9) Cond6(9).emgcut(:,9)];
MT_alltrials_Cond6 = [Cond6(1).emgcut(:,10) Cond6(2).emgcut(:,10) Cond6(3).emgcut(:,10) Cond6(4).emgcut(:,10) Cond6(5).emgcut(:,10) Cond6(6).emgcut(:,10) Cond6(7).emgcut(:,10) Cond6(8).emgcut(:,10) Cond6(9).emgcut(:,10)];
LD_alltrials_Cond6= [Cond6(1).emgcut(:,11) Cond6(2).emgcut(:,11) Cond6(3).emgcut(:,11) Cond6(4).emgcut(:,11) Cond6(5).emgcut(:,11) Cond6(6).emgcut(:,11) Cond6(7).emgcut(:,11) Cond6(8).emgcut(:,11) Cond6(9).emgcut(:,11)];
PM_alltrials_Cond6 = [Cond6(1).emgcut(:,12) Cond6(2).emgcut(:,12) Cond6(3).emgcut(:,12) Cond6(4).emgcut(:,12) Cond6(5).emgcut(:,12) Cond6(6).emgcut(:,12) Cond6(7).emgcut(:,12) Cond6(8).emgcut(:,12) Cond6(9).emgcut(:,12)];
BIC_alltrials_Cond6 = [Cond6(1).emgcut(:,13) Cond6(2).emgcut(:,13) Cond6(3).emgcut(:,13) Cond6(4).emgcut(:,13) Cond6(5).emgcut(:,13) Cond6(6).emgcut(:,13) Cond6(7).emgcut(:,13) Cond6(8).emgcut(:,13) Cond6(9).emgcut(:,13)];
TRI_alltrials_Cond6  = [Cond6(1).emgcut(:,14) Cond6(2).emgcut(:,14) Cond6(3).emgcut(:,14) Cond6(4).emgcut(:,14) Cond6(5).emgcut(:,14) Cond6(6).emgcut(:,14) Cond6(7).emgcut(:,14) Cond6(8).emgcut(:,14) Cond6(9).emgcut(:,14)];
IDL_alltrials_Cond6 = [Cond6(1).emgcut(:,15) Cond6(2).emgcut(:,15) Cond6(3).emgcut(:,15) Cond6(4).emgcut(:,15) Cond6(5).emgcut(:,15) Cond6(6).emgcut(:,15) Cond6(7).emgcut(:,15) Cond6(8).emgcut(:,15) Cond6(9).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond6 = mean(UT_alltrials_Cond6,2); 
meanMT_Cond6 = mean(UT_alltrials_Cond6,2); 
meanLD_Cond6 = mean(UT_alltrials_Cond6,2); 
meanPM_Cond6 = mean(UT_alltrials_Cond6,2); 
meanBIC_Cond6 = mean(UT_alltrials_Cond6,2); 
meanTRI_Cond6 = mean(UT_alltrials_Cond6,2); 
meanIDL_Cond6 = mean(UT_alltrials_Cond6,2); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting%


% NOT ALIGNED to BEHAVIOR
% Velocity - get this after the meeting with Hongchul and Ana Maria
VelCond1 = [Cond1(1).vel(1:1000) Cond1(2).vel(1:1000) Cond1(3).vel(1:1000) Cond1(4).vel(1:1000) Cond1(5).vel(1:1000) Cond1(6).vel(1:1000) Cond1(7).vel(1:1000)]

AVGVelCond1 = mean

%% Plotting Mean Muscle Activity for all Conditions
%% UT
figure()
plot(smooth(meanUT_Cond1),'g','LineWidth',4)
hold on
plot(smooth(meanUT_Cond2),'c','LineWidth',4)
plot(smooth(meanUT_Cond3),'m','LineWidth',4)
plot(smooth(meanUT_Cond4),'b','LineWidth',4)
plot(smooth(meanUT_Cond5),'Color','#D95319','LineWidth',4)
plot(smooth(meanUT_Cond6),'r','LineWidth',4)
xline(1500,'Color','k','LineWidth',1)
legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('Upper Trap','FontSize',25)
%%
for i = 1:7
plot(smooth(UT_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(UT_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(UT_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(UT_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(UT_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(UT_alltrials_Cond6(:,i)),'r','LineWidth',1)
end


%%
% MT


figure()
plot(smooth(meanMT_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanMT_Cond2),'c','LineWidth',2)
plot(smooth(meanMT_Cond3),'m','LineWidth',2)
plot(smooth(meanMT_Cond4),'b','LineWidth',2)
plot(smooth(meanMT_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanMT_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('Mid Trap','FontSize',25)

%%
for i = 1:7
plot(smooth(MT_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(MT_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(MT_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(MT_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(MT_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(MT_alltrials_Cond6(:,i)),'r','LineWidth',1)
end

%% LD

figure()
plot(smooth(meanLD_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanLD_Cond2),'c','LineWidth',2)
plot(smooth(meanLD_Cond3),'m','LineWidth',2)
plot(smooth(meanLD_Cond4),'b','LineWidth',2)
plot(smooth(meanLD_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanLD_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('LD','FontSize',25)
%%
% 
for i = 1:7
plot(smooth(LD_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(LD_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(LD_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(LD_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(LD_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(LD_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% PM
figure()
plot(smooth(meanPM_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanPM_Cond2),'c','LineWidth',2)
plot(smooth(meanPM_Cond3),'m','LineWidth',2)
plot(smooth(meanPM_Cond4),'b','LineWidth',2)
plot(smooth(meanPM_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanPM_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('PM','FontSize',25)

%%
for i = 1:7
plot(smooth(PM_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(PM_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(PM_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(PM_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(PM_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(PM_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% BIC
figure()
plot(smooth(meanBIC_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanBIC_Cond2),'c','LineWidth',2)
plot(smooth(meanBIC_Cond3),'m','LineWidth',2)
plot(smooth(meanBIC_Cond4),'b','LineWidth',2)
plot(smooth(meanBIC_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanBIC_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)

%%
for i = 1:7
plot(smooth(BIC_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(BIC_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(BIC_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(BIC_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(BIC_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(BIC_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% TRI
figure()
plot(smooth(meanTRI_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanTRI_Cond2),'c','LineWidth',2)
plot(smooth(meanTRI_Cond3),'m','LineWidth',2)
plot(smooth(meanTRI_Cond4),'b','LineWidth',2)
plot(smooth(meanTRI_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanTRI_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('TRI','FontSize',25)

%%
for i = 1:7
plot(smooth(TRI_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(TRI_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(TRI_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(TRI_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(TRI_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(TRI_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% IDL
figure()
plot(smooth(meanIDL_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanIDL_Cond2),'c','LineWidth',2)
plot(smooth(meanIDL_Cond3),'m','LineWidth',2)
plot(smooth(meanIDL_Cond4),'b','LineWidth',2)
plot(smooth(meanIDL_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanIDL_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('IDL','FontSize',25)
%%
for i = 1:7
plot(smooth(IDL_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(IDL_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(IDL_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(IDL_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(IDL_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(IDL_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% Code Below Plots Time Traces of all Trials in a Given Condition
%% Cond 1

DesiredCond = Cond1; %replace with condition want to see 
%%
for i = 1:length(DesiredCond) %Number of trials 

    if i==1
    figure
    end
    figure(1)
    plot(DesiredCond(i).emgTrace(:,9))
   
    % Determine the shift
%     shift = 2500 - DesiredCond(i).velidx; % Centering around the middle of the samples
%     
%     % Align the data
%     if shift >= 0
%         % If shift is positive, pad the left side
%         aligned_data(shift+1:shift+5000,i) = DesiredCond(i).emgTrace(:,9);
% %                 aligned_data(trial, shift+1:shift+5000) = data(trial, :);
% 
%     else
%         % If shift is negative, pad the right side
%         aligned_data(1:5000 + shift,i) = DesiredCond(i).emgTrace(:,9);
%     end
    title(MUSC(1),'FontSize',24)
    hold on
%%
    if i==1
    figure
    end
    figure(2)
    plot(DesiredCond(i).emgTrace(:,10))
    title(MUSC(2),'FontSize',24)
    hold on

    if i==1
    figure
    end
    figure(3)
    plot(DesiredCond(i).emgTrace(:,11))
    title(MUSC(3),'FontSize',24)
    hold on

    if i==1
    figure
    end
    figure(4)
    plot(DesiredCond(i).emgTrace(:,12))
    title(MUSC(4),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(5)
    plot(DesiredCond(i).emgTrace(:,13))
    title(MUSC(5),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(6)
    plot(DesiredCond(i).emgTrace(:,14))
    title(MUSC(6),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(7)
    plot(DesiredCond(i).emgTrace(:,15))
    title(MUSC(7),'FontSize',24)
    hold on
end 






%%
% UT
figure()
plot(NNMFstruc(1).emgTrace(:,9))
hold on
plot(NNMFstruc(2).emgTrace(:,9))
plot(NNMFstruc(3).emgTrace(:,9))
plot(NNMFstruc(4).emgTrace(:,9))
plot(NNMFstruc(5).emgTrace(:,9))
plot(NNMFstruc(6).emgTrace(:,9))
plot(NNMFstruc(7).emgTrace(:,9))
title('UpperTrap Condition 1')

% MT
figure
plot(NNMFstruc(1).emgTrace(:,10))
hold on
plot(NNMFstruc(2).emgTrace(:,10))
plot(NNMFstruc(3).emgTrace(:,10))
plot(NNMFstruc(4).emgTrace(:,10))
plot(NNMFstruc(5).emgTrace(:,10))
plot(NNMFstruc(6).emgTrace(:,10))
plot(NNMFstruc(7).emgTrace(:,10))


% LD
figure
plot(NNMFstruc(1).emgTrace(:,11))
hold on
plot(NNMFstruc(2).emgTrace(:,11))
plot(NNMFstruc(3).emgTrace(:,11))
plot(NNMFstruc(4).emgTrace(:,11))
plot(NNMFstruc(5).emgTrace(:,11))
plot(NNMFstruc(6).emgTrace(:,11))
plot(NNMFstruc(7).emgTrace(:,11))


% PM
figure
plot(NNMFstruc(1).emgTrace(:,12))
hold on
plot(NNMFstruc(2).emgTrace(:,12))
plot(NNMFstruc(3).emgTrace(:,12))
plot(NNMFstruc(4).emgTrace(:,12))
plot(NNMFstruc(5).emgTrace(:,12))
plot(NNMFstruc(6).emgTrace(:,12))
plot(NNMFstruc(7).emgTrace(:,12))

% BIC
figure
plot(NNMFstruc(1).emgTrace(:,13))
hold on
plot(NNMFstruc(2).emgTrace(:,13))
plot(NNMFstruc(3).emgTrace(:,13))
plot(NNMFstruc(4).emgTrace(:,13))
plot(NNMFstruc(5).emgTrace(:,13))
plot(NNMFstruc(6).emgTrace(:,13))
plot(NNMFstruc(7).emgTrace(:,13))


% TRI
figure
plot(NNMFstruc(1).emgTrace(:,14))
hold on
plot(NNMFstruc(2).emgTrace(:,14))
plot(NNMFstruc(3).emgTrace(:,14))
plot(NNMFstruc(4).emgTrace(:,14))
plot(NNMFstruc(5).emgTrace(:,14))
plot(NNMFstruc(6).emgTrace(:,14))
plot(NNMFstruc(7).emgTrace(:,14))

% IDL
figure
plot(NNMFstruc(1).emgTrace(:,15))
hold on
plot(NNMFstruc(2).emgTrace(:,15))
plot(NNMFstruc(3).emgTrace(:,15))
plot(NNMFstruc(4).emgTrace(:,15))
plot(NNMFstruc(5).emgTrace(:,15))
plot(NNMFstruc(6).emgTrace(:,15))
plot(NNMFstruc(7).emgTrace(:,15))

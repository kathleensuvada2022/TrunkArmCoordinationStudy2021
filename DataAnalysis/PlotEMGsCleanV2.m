function meanEMG  =  PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)

% cleandata=KaceyNotchfilter(emg);

% Using Raw EMG Data
cleandata = emg; 

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
%clf
figure(2)
%subplot(2,1,2)
%emg=emg./maxes; %normalizing
sampRate=1000;
avgwindow=0.25; ds=sampRate*avgwindow;
nEMG=size(emg,2);
t=(0:size(emg,1)-1)/sampRate; 
avgwindow=0.25; ds=sampRate*avgwindow;
meanEMG=movmean(emg,ds);

%% Shifting Time Points Back 50 Milliseconds to due EMD

timestart = timestart-.05;
timevelmax = timevelmax-.05;
timedistmax = timedistmax -.05;


%% Creating Subplots 

% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

emg_idxstart= round(timestart*1000);
emg_idxvel = round(timevelmax*1000);
emg_idx_distmax = round(timedistmax*1000);
% emg_timestart = emg(emg_idxstart,:);
% emg_timevel = emg(emg_idxvel,:);


idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
yrange = 0:1;
%% Trunk 


subplot(5,2,3)
line(t,emg(:,idx1(1)))
title(emgchan(idx1(1)))

cla
subplot(5,2,3)
line(t,(cleandata(:,idx1(1))))
yl=yrange;
hold on
plot(t,meanEMG(:,idx1(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(1)))
ylim([0 1])

% pause
subplot(5,2,4)
line(t,emg(:,idx2(1)))
title(emgchan(idx2(1)))

cla
subplot(5,2,4)
line(t,(cleandata(:,idx2(1))))
hold on
plot(t,meanEMG(:,idx2(1)),'LineWidth',1,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(1)))
ylim([0 1])

% pause
subplot(5,2,5)
line(t,emg(:,idx1(2)))
title(emgchan(idx1(2)))

cla
subplot(5,2,5)
line(t,(cleandata(:,idx1(2))))
hold on
plot(t,meanEMG(:,idx1(2)),'LineWidth',1,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(2)))
ylim([0 1])

% pause
subplot(5,2,6)
line(t,emg(:,idx2(2)))
title(emgchan(idx2(2)))

cla
subplot(5,2,6)
line(t,(cleandata(:,idx2(2))))
hold on
plot(t,meanEMG(:,idx2(2)),'LineWidth',1,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(2)))
ylim([0 1])

% pause
subplot(5,2,7)
line(t,emg(:,idx1(3)))
title(emgchan(idx1(3)))

cla
subplot(5,2,7)
line(t,(cleandata(:,idx1(3))))
hold on
plot(t,meanEMG(:,idx1(3)),'LineWidth',2,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(3)))
ylim([0 1])
% pause
subplot(5,2,8)
line(t,emg(:,idx2(3)))
title(emgchan(idx2(3)))

cla
subplot(5,2,8)
line(t,(cleandata(:,idx2(3))))
hold on
plot(t,meanEMG(:,idx2(3)),'LineWidth',2,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(3)))
ylim([0 1])

% pause
subplot(5,2,9)
line(t,emg(:,idx1(4)))
title(emgchan(idx1(4)))
cla
subplot(5,2,9)
line(t,(cleandata(:,idx1(4))))
hold on
plot(t,meanEMG(:,idx1(4)),'LineWidth',2,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(4)))
ylim([0 1])

% pause
subplot(5,2,10)
line(t,emg(:,idx2(4)))
title(emgchan(idx2(4)))
cla
subplot(5,2,10)
line(t,(cleandata(:,idx2(4))))
hold on
plot(t,meanEMG(:,idx2(4)),'LineWidth',2,'Color','g')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(4)))
ylim([0 1])

%% ARM MUSCLES
figure(3)
% pause
subplot(5,2,3)
line(t,emg(:,idx1(5)))
title(emgchan(idx1(5)))

cla
subplot(5,2,3)
line(t,abs((cleandata(:,idx1(5)))))
hold on
plot(t,meanEMG(:,idx1(5)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(5))),'*')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(5)))
ylim([0 1])

% pause
subplot(5,2,4)
line(t,emg(:,idx2(5)))
title(emgchan(idx2(5)))

cla
subplot(5,2,4)
line(t,(cleandata(:,idx2(5))))
hold on
plot(t,meanEMG(:,idx2(5)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(5))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(5)))
ylim([0 1])

% pause
subplot(5,2,5)
line(t,emg(:,idx1(6)))
title(emgchan(idx1(6)))

cla
subplot(5,2,5)
line(t,(cleandata(:,idx1(6))))
hold on
plot(t,meanEMG(:,idx1(6)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(6))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(6)))
ylim([0 1])

% pause
subplot(5,2,6)
line(t,emg(:,idx2(6)))
title(emgchan(idx2(6)))

cla
subplot(5,2,6)
line(t,(cleandata(:,idx2(6))))
hold on
plot(t,meanEMG(:,idx2(6)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(6))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(6)))
ylim([0 1])

% pause
subplot(5,2,7)
line(t,emg(:,idx1(7)))
title(emgchan(idx1(7)))
cla
subplot(5,2,7)
line(t,(cleandata(:,idx1(7))))
hold on
plot(t,meanEMG(:,idx1(7)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(7))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(7)))
ylim([0 1])

% pause
subplot(5,2,8)
line(t,emg(:,idx2(7)))
title(emgchan(idx2(7)))

cla
subplot(5,2,8)
line(t,(cleandata(:,idx2(7))))
hold on
plot(t,meanEMG(:,idx2(7)),'LineWidth',2,'Color','g')
 plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(7))),'*')
yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(7)))
ylim([0 1])

% pause
subplot(5,2,9)
line(t,emg(:,idx1(8)))
title(emgchan(idx1(8)))
cla
subplot(5,2,9)
line(t,(cleandata(:,idx1(8))))
hold on
plot(t,meanEMG(:,idx1(8)),'LineWidth',2,'Color','g')
plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(8))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(8)))
ylim([0 1])
end
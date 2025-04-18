% function meanEMG  =  PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)

function [meanEMG, emg_idxstart, emg_idxvel,emg_idx_distmax,emg_idx_ppa,t] = PlotEMGsCleanV2(emg, timestart, timevelmax, timedistmax,vel,dist,tmet, i);


% cleandata=KaceyNotchfilter(emg);


% plot(vel)
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
timeppa = timestart-.250;
timevelmax = timevelmax-.05;
timedistmax = timedistmax -.05;


%% Creating Subplots 

% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

emg_idxstart= round(timestart*1000);
emg_idxvel = round(timevelmax*1000);
emg_idx_distmax = round(timedistmax*1000);
emg_idx_ppa = round(timeppa*1000);

if emg_idxvel > length(emg)
emg_idxvel = length(emg)
elseif emg_idx_distmax >length(emg)
    emg_idx_distmax = length(emg)
end 



% emg_timestart = emg(emg_idxstart,:);
% emg_timevel = emg(emg_idxvel,:);


idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
yrange = 0:1;
%% Trunk 
figure(4)

subplot(5,2,1:2)
%plotting velocity
plot(tmet,smooth(vel)/1000,'b','LineWidth',2)
hold on
plot(tmet,dist/1000,'r','LineWidth',2)
xlim([0 5])


% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
legend('Velocity (m/s)','Dist(m)','Start','Max Vel','End','FontSize',18)

subplot(5,2,3)
line(t,(cleandata(:,idx1(1))))
hold on
plot(t,meanEMG(:,idx1(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(1)),'Fontsize',18)
ylim([0 1])

% pause

subplot(5,2,4)
line(t,(cleandata(:,idx2(1))))
hold on
plot(t,meanEMG(:,idx2(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(1)),'Fontsize',18)
ylim([0 1])


subplot(5,2,5)
line(t,(cleandata(:,idx1(2))))
hold on
plot(t,meanEMG(:,idx1(2)),'LineWidth',1,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(2)),'Fontsize',18)
ylim([0 1])


subplot(5,2,6)
line(t,(cleandata(:,idx2(2))))
hold on
plot(t,meanEMG(:,idx2(2)),'LineWidth',1,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(2)),'Fontsize',18)
ylim([0 1])


subplot(5,2,7)
line(t,(cleandata(:,idx1(3))))
hold on
plot(t,meanEMG(:,idx1(3)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(3)),'Fontsize',18)
ylim([0 1])

subplot(5,2,8)
line(t,(cleandata(:,idx2(3))))
hold on
plot(t,meanEMG(:,idx2(3)),'LineWidth',2,'Color','g')

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(3)),'Fontsize',18)
ylim([0 1])

% pause

subplot(5,2,9)
line(t,(cleandata(:,idx1(4))))
hold on
plot(t,meanEMG(:,idx1(4)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx1(4)),'Fontsize',18)
ylim([0 1])

% pause

subplot(5,2,10)
line(t,(cleandata(:,idx2(4))))
hold on
plot(t,meanEMG(:,idx2(4)),'LineWidth',2,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title(emgchan(idx2(4)))
ylim([0 1])

%% ARM MUSCLES
figure(3)
subplot(5,2,1:2)
%plotting velocity
plot(tmet,smooth(vel)/1000,'b','LineWidth',2)
hold on
plot(tmet,dist/1000,'r','LineWidth',2)
xlim([0 5])

% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
legend('Velocity (m/s)','Dist(m)','Start','Max Vel','End','FontSize',18)

% pause
subplot(5,2,3)
line(t,emg(:,idx1(5)))
title(emgchan(idx1(5)),'Fontsize',18)

cla
subplot(5,2,3)
line(t,abs((cleandata(:,idx1(5)))))
hold on
plot(t,meanEMG(:,idx1(5)),'LineWidth',2.5,'Color','k')

%plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(5))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(5))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(5))),'*')

yl=yrange;
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
title(emgchan(idx1(5)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,4)
line(t,emg(:,idx2(5)))
title(emgchan(idx2(5)),'Fontsize',18)

cla
subplot(5,2,4)
line(t,(cleandata(:,idx2(5))))
hold on
plot(t,meanEMG(:,idx2(5)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(5))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(5))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(5))),'*')

yl=yrange;
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
title(emgchan(idx2(5)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,5)
line(t,emg(:,idx1(6)))
title(emgchan(idx1(6)),'Fontsize',18)

cla
subplot(5,2,5)
line(t,(cleandata(:,idx1(6))))
hold on
plot(t,meanEMG(:,idx1(6)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(6))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(6))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(6))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(6)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,6)
line(t,emg(:,idx2(6)))
title(emgchan(idx2(6)))

cla
subplot(5,2,6)
line(t,(cleandata(:,idx2(6))))
hold on
plot(t,meanEMG(:,idx2(6)),'LineWidth',2.5,'Color','k')
% plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(6))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(6))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(6))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx2(6)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,7)
line(t,emg(:,idx1(7)))
title(emgchan(idx1(7)))
cla
subplot(5,2,7)
line(t,(cleandata(:,idx1(7))))
hold on
plot(t,meanEMG(:,idx1(7)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(7))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(7))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(7))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(7)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,8)
line(t,emg(:,idx2(7)))
title(emgchan(idx2(7)))

cla
subplot(5,2,8)
line(t,(cleandata(:,idx2(7))))
hold on
plot(t,meanEMG(:,idx2(7)),'LineWidth',2.5,'Color','k')
 %plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx2(7))),'*')
 %plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx2(7))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx2(7))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx2(7)),'Fontsize',18)
ylim([0 1])

% pause
subplot(5,2,9)
line(t,emg(:,idx1(8)))
title(emgchan(idx1(8)))
cla
subplot(5,2,9)
line(t,(cleandata(:,idx1(8))))
hold on
plot(t,meanEMG(:,idx1(8)),'LineWidth',2.5,'Color','k')
%plot(mean([timestart timedistmax]),mean(meanEMG(emg_idxstart:emg_idx_distmax,idx1(8))),'*')
%plot(mean([timestart timevelmax]),mean(meanEMG(emg_idxstart:emg_idxvel,idx1(8))),'*')
% plot(mean([timeppa timestart]),mean(meanEMG(emg_idx_ppa:emg_idxstart,idx1(8))),'*')

yl=yrange;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',2.5); %max, dist
% line('Color','c','Xdata',[timeppa timeppa],'Ydata',[yl(1) yl(2)], 'LineWidth',2.5); % ppa time

title(emgchan(idx1(8)),'Fontsize',18)
ylim([0 1])
end
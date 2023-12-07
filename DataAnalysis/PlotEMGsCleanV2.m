function PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)

cleandata=KaceyNotchfilter(emg);
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
emg=abs(detrend(emg));
meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

emg_idxstart= round(timestart*1000);
emg_idxvel = round(timevelmax*1000);
emg_timestart = emg(emg_idxstart,:);
emg_timevel = emg(emg_idxvel,:);


idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
%% Trunk muscles - Edited 2023

subplot(5,2,3)
line(t,emg(:,idx1(1)))
title(emgchan(idx1(1)))
% pause
cla
subplot(5,2,3)
line(t,abs(cleandata(:,idx1(1))))
yl=ylim;
hold on
plot(t,meanEMG(:,idx1(1)),'LineWidth',1,'Color','g')
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(1)))

subplot(5,2,4)
line(t,emg(:,idx2(1)))
title(emgchan(idx2(1)))

cla
subplot(5,2,4)
line(t,abs(cleandata(:,idx2(1))))
hold on
plot(t,meanEMG(:,idx2(1)),'LineWidth',1,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(1)))

subplot(5,2,5)
line(t,emg(:,idx1(2)))
title(emgchan(idx1(2)))
%pause
cla
subplot(5,2,5)
line(t,abs(cleandata(:,idx1(2))))
hold on
plot(t,meanEMG(:,idx1(2)),'LineWidth',1,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(2)))

subplot(5,2,6)
line(t,emg(:,idx2(2)))
title(emgchan(idx2(2)))
%pause
cla
subplot(5,2,6)
line(t,abs(cleandata(:,idx2(2))))
hold on
plot(t,meanEMG(:,idx2(2)),'LineWidth',1,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(2)))

subplot(5,2,7)
line(t,emg(:,idx1(3)))
title(emgchan(idx1(3)))
% pause
cla
subplot(5,2,7)
line(t,abs(cleandata(:,idx1(3))))
hold on
plot(t,meanEMG(:,idx1(3)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(3)))

subplot(5,2,8)
line(t,emg(:,idx2(3)))
title(emgchan(idx2(3)))
% pause
cla
subplot(5,2,8)
line(t,abs(cleandata(:,idx2(3))))
hold on
plot(t,meanEMG(:,idx2(3)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(3)))

subplot(5,2,9)
line(t,emg(:,idx1(4)))
title(emgchan(idx1(4)))
% pause
cla
subplot(5,2,9)
line(t,abs(cleandata(:,idx1(4))))
hold on
plot(t,meanEMG(:,idx1(4)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(4)))

subplot(5,2,10)
line(t,emg(:,idx2(4)))
title(emgchan(idx2(4)))
% pause
cla
subplot(5,2,10)
line(t,abs(cleandata(:,idx2(4))))
hold on
plot(t,meanEMG(:,idx2(4)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(4)))

% 
figure(3)
% Arm Muscle 
subplot(5,2,3)
line(t,emg(:,idx1(5)))
title(emgchan(idx1(5)))
% pause
cla
subplot(5,2,3)
line(t,abs(cleandata(:,idx1(5))))
hold on
plot(t,meanEMG(:,idx1(5)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(5)))

subplot(5,2,4)
line(t,emg(:,idx2(5)))
title(emgchan(idx2(5)))
% pause
cla
subplot(5,2,4)
line(t,abs(cleandata(:,idx2(5))))
hold on
plot(t,meanEMG(:,idx2(5)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(5)))

subplot(5,2,5)
line(t,emg(:,idx1(6)))
title(emgchan(idx1(6)))
%pause
cla
subplot(5,2,5)
line(t,abs(cleandata(:,idx1(6))))
hold on
plot(t,meanEMG(:,idx1(6)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(6)))

subplot(5,2,6)
line(t,emg(:,idx2(6)))
title(emgchan(idx2(6)))
% pause
cla
subplot(5,2,6)
line(t,abs(cleandata(:,idx2(6))))
hold on
plot(t,meanEMG(:,idx2(6)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(6)))

subplot(5,2,7)
line(t,emg(:,idx1(7)))
title(emgchan(idx1(7)))
cla
subplot(5,2,7)
line(t,abs(cleandata(:,idx1(7))))
hold on
plot(t,meanEMG(:,idx1(7)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(7)))

subplot(5,2,8)
line(t,emg(:,idx2(7)))
title(emgchan(idx2(7)))

cla
subplot(5,2,8)
line(t,abs(cleandata(:,idx2(7))))
hold on
plot(t,meanEMG(:,idx2(7)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx2(7)))

subplot(5,2,9)
line(t,emg(:,idx1(8)))
title(emgchan(idx1(8)))
cla
subplot(5,2,9)
line(t,abs(cleandata(:,idx1(8))))
hold on
plot(t,meanEMG(:,idx1(8)),'LineWidth',2,'Color','g')
yl=ylim;
line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
title(emgchan(idx1(8)))




% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))
% line(lax1,t,meanEMG(:,idx1)-yspacing(ones(length(t),1),:),'LineWidth',2)
% 
% lax2 = axes('position',[0.55,0.05,0.4,0.6]);
% yl2=ylim; %getting the ylimits to plot vertical line
% line(lax2,'Color','b','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line(lax2,'Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line(lax2,'Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line(lax2,'Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% set(lax2,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
% set(lax2,'YTick',fliplr(-yspacing(1:7)),'YTickLabel',fliplr(emgchan(idx2)),...
%     'YLim',[-yspacing(end) memg(1)])%,'XTick',[],'XTickLabel',[],'FontSize',14)
% line(lax2,t,emg(:,idx2)-yspacing(ones(length(t),1),1:7))
% set(lax2,'ColorOrder',co(end-1:-1:1,:))
% line(lax2,t,meanEMG(:,idx2)-yspacing(ones(length(t),1),1:7),'LineWidth',2)



% print('-f1','-djpeg',[flpath '\MaxEMGs2'])
% print('-f2','-djpeg',[flpath '\MaxEMGs'])
%%
end
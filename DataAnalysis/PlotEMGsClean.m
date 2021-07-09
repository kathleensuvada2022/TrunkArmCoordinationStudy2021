function PlotEMGsClean(emg,maxes,timestart,timevelmax,timeend,timedistmax,i)
emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
%clf
figure(i)
emg=emg./maxes; %normalizing
sampRate=1000;
nEMG=size(emg,2);
t=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=0.25; ds=sampRate*avgwindow;
emg=abs(detrend(emg));
meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL
idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];
nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
lax1 = axes('position',[0.07,0.05,0.4,0.6]);
set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
    'YLim',[-yspacing(end) memg(1)])%'XTick',[],'XTickLabel',[],'FontSize',14)
line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
hold on
yl=ylim; %getting the ylimits to plot vertical line
line(lax1,'Color','b','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line(lax1,'Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line(lax1,'Color','c','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
line(lax1,'Color','g','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
line(lax1,t,meanEMG(:,idx1)-yspacing(ones(length(t),1),:),'LineWidth',2)

lax2 = axes('position',[0.55,0.05,0.4,0.6]);
yl2=ylim; %getting the ylimits to plot vertical line
line(lax2,'Color','b','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
line(lax2,'Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
line(lax2,'Color','c','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
line(lax2,'Color','g','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
set(lax2,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax2,'YTick',fliplr(-yspacing(1:7)),'YTickLabel',fliplr(emgchan(idx2)),...
    'YLim',[-yspacing(end) memg(1)])%,'XTick',[],'XTickLabel',[],'FontSize',14)
line(lax2,t,emg(:,idx2)-yspacing(ones(length(t),1),1:7))
set(lax2,'ColorOrder',co(end-1:-1:1,:))
line(lax2,t,meanEMG(:,idx2)-yspacing(ones(length(t),1),1:7),'LineWidth',2)


% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f1','-djpeg',[flpath '\MaxEMGs2'])
% print('-f2','-djpeg',[flpath '\MaxEMGs'])
end
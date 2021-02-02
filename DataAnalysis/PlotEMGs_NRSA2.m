%% AMA 5/1/20 Script to plot EMGs in two conditions (RT and UT) for RTIS2001
%% RT plot
figure(4), clf
load emgsRT
t0=t0-1.5;
yspacing=cumsum(memg*1.001); 
temg=temg-1.5;
idx1=[1 2 3 4 5 6];
lax1 = axes('position',[0.07,0.1,0.4,0.85]); title('Trunk Restrained')
% set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax1,'YTick',fliplr(-yspacing(1:length(idx1))),'YTickLabel',fliplr(emgchan(idx1)),...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14) %'XTick',[],'XTickLabel',[],
line(lax1,temg,emg(:,idx1)-yspacing(ones(length(temg),1),1:length(idx1)))
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
line(lax1,temg,meanEMG(:,idx1)-yspacing(ones(length(temg),1),1:length(idx1)),'LineWidth',2)
line(lax1,'Color','b','Xdata',[t0(2) t0(2)],'Ydata',lax1.YLim,'LineWidth',1);
line(lax1,'Color','m','Xdata',[t0(3) t0(3)],'Ydata',lax1.YLim,'LineWidth',1);
xlabel('time (s)')

%% UT plot
load emgsUT
t0=t0-1.5;
temg=temg-1.5;
idx2=[1 2 3 4 5 6];
lax2 = axes('position',[0.55,0.1,.4,0.85]); title('Trunk Unrestrained')
% set(lax2,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
% set(lax2,'YTick',fliplr(-yspacing(1:length(idx2))),'YTickLabel',fliplr(emgchan(idx2)),...
%     'YLim',[-yspacing(end) memg(1)],'FontSize',14); %,'XTick',[],'XTickLabel'[],
set(lax2,'YTick',[],'YTickLabel',[],...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14); %,'XTick',[],'XTickLabel'[],
line(lax2,temg,emg(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)))
set(lax2,'ColorOrder',co(end-1:-1:1,:))
line(lax2,temg,meanEMG(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)),'LineWidth',2)
line(lax2,'Color','b','Xdata',[t0(2) t0(2)],'Ydata',lax2.YLim,'LineWidth',1);
line(lax2,'Color','m','Xdata',[t0(3) t0(3)],'Ydata',lax2.YLim,'LineWidth',1);

%%
% set(lax1,'XLim',[1.5 3]); 
% set(lax2,'XLim',[1.5 3]); 
set(lax1,'XLim',[0 1.5]); 
set(lax2,'XLim',[0 1.5]); 
set(lax1,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])
set(lax2,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])

xlabel('time (s)')

print('-f4','-djpeg','EMGPLOT_NRSA')



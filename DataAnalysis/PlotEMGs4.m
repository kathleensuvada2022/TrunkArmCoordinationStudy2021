function vdax=PlotEMGs4(emg,dist,vel,t0,t,fname)
% AMA 5/1/20 - Modified for KCS NRSA
% GetMaxMusAct2(flpath,sename,setfname,partid,plotflag)

clf

if nargin >1 
    
% totaltime = (length(dist)-1)/50; % sampling f of act 3d is 50 hz 
% t = (0:.02:totaltime);
 %% Plot for distance and velocity
lax1 = axes('position',[0.07,0.8,0.84,0.15]);
set(lax1,'FontSize',12);
%set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none','XTick',[],'XTickLabel',[])
% set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
 %   'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
%line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
vdax=lax1;    
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
% added in 2.27.20 for vertical line in EMG plots
%set(lax1,'XLim',[.5 5])


%line(lax1,'Color','r','Xdata',[t0(1) t0(1)],'Ydata',lax1.YLim,'LineWidth',1);  
line(lax1,'Color','b','Xdata',[t0(2) t0(2)],'Ydata',lax1.YLim,'LineWidth',1);  
line(lax1,'Color','m','Xdata',[t0(4) t0(4)],'Ydata',lax1.YLim,'LineWidth',1);
%line(lax1,'Color','k','Xdata',[t0(4) t0(4)],'Ydata',lax1.YLim,'LineWidth',1);
%line(lax1,'Color','b','Xdata',[maxreachtime maxreachtime],'Ydata',lax1.YLim,'LineWidth',1);
% legend(g,'Time Start','LineWidth',1);
yyaxis right 
line(lax1,t,dist,'LineWidth',2,'Color','b'); % add in distance variablea
ylabel('Distance (m)')
yyaxis left
line(lax1,t,vel,'LineWidth',2)
ylabel('Velocity (m/s)')
legend('Max Velocity','Max Distance','Velocity','Distance','FontSize',14)
set(lax1,'XLim',[0 3])
xlabel('time (s)')
    
end
 
 %% EMG Plot

  
 emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','ADEL'}; %

 sampRate=1024;
%  nEMG=size(emg,2);
temg=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=.25; ds=sampRate*avgwindow;
emg=abs(detrend(emg));
meanEMG=movmean(emg,ds);


% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL, ADEL
% 
idx1=[1:2:8]; idx2=[2:2:8]; % how occupying the figure of the emg plots
% idx1=[1:2:8 9:12]; idx2=[2:2:8 13:15]; % how occupying the figure of the emg plots
% idx1=[1:2:7]; idx2=[2:2:8]; % how occupying the figure of the emg plots
%Right erector spinae (RES), left external oblique (LEO) and right external oblique (REO) having UT and RT
% idx1=[1 2 3 4 5 6]; idx2=[7:]; % how occupying the figure of the emg plots
%  idx2=[1:8]; % how occupying the figure of the emg plots
nEMG=length(idx1); % 8 rows of the column on the left for plot

% memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]); 

memg = max([max(emg(:,idx1));max(emg(:,idx2))]); % replaced with this

 
 
yspacing=cumsum(memg*1.05); 

lax1 = axes('position',[0.07,0.08,0.38,0.7]);
set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax1,'YTick',fliplr(-yspacing(1:length(idx1))),'YTickLabel',fliplr(emgchan(idx1)),...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14) %,'XTick',[],'XTickLabel',[])
line(lax1,temg,emg(:,idx1)-yspacing(ones(length(temg),1),1:length(idx1)))
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
line(lax1,temg,meanEMG(:,idx1)-yspacing(ones(length(temg),1),1:length(idx1)),'LineWidth',2)

lax2 = axes('position',[0.53,0.08,.38,0.7]);
 set(lax2,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax2,'YTick',fliplr(-yspacing(1:length(idx2))),'YTickLabel',fliplr(emgchan(idx2)),...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14) %,'XTick',[],'XTickLabel',[]);
line(lax2,temg,emg(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)))
set(lax2,'ColorOrder',co(end-1:-1:1,:))
line(lax2,temg,meanEMG(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)),'LineWidth',2)

t0=t0-0.05;
% if nargin >1 
      line(lax1,'Color','b','Xdata',[t0(2) t0(2)],'Ydata',lax1.YLim,'LineWidth',1);
      line(lax1,'Color','m','Xdata',[t0(3) t0(3)],'Ydata',lax1.YLim,'LineWidth',1);

      line(lax2,'Color','b','Xdata',[t0(2) t0(2)],'Ydata',lax2.YLim,'LineWidth',1);
      line(lax2,'Color','m','Xdata',[t0(3) t0(3)],'Ydata',lax2.YLim,'LineWidth',1);
%       %line(lax2,'Color','r','Xdata',[t0(1) t0(1)],'Ydata',lax2.YLim,'LineWidth',1);
%      % line(lax2,'Color','k','Xdata',[t0(4) t0(4)],'Ydata',lax2.YLim,'LineWidth',1);
%      % line(lax2,'Color','b','Xdata',[maxreachtime maxreachtime],'Ydata',lax2.YLim,'LineWidth',1);
% end
% set(lax1,'XLim',[0 4])
% set(lax2,'XLim',[0 4])
set(lax1,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])
set(lax2,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])
xlabel(lax1,'time (s)')
xlabel(lax2,'time (s)')

% xlabel('Time (s)') 

% Change the file name 'emgUT'
% save(fname,'temg','emg','meanEMG','memg','emgchan','co','t0','t','dist','vel')

% if nargin>1,
%   line(lax1,[t0 t0],lax1.YLim,'r')
% end
% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f3','-djpeg',[partID ')

end
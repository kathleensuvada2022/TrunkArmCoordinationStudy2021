function PlotEMGs_NRSA(emg,dist,vel,t0)

% GetMaxMusAct2(flpath,sename,setfname,partid,plotflag)

clf
 %% Plot for distance and velocity
if nargin >1 
    
totaltime = (length(dist)-1)/50; % sampling f of act 3d is 50 hz 
t = (0:.02:totaltime);
lax1 = axes('position',[0.04,0.8,0.9,0.15]);
set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none','XTick',[],'XTickLabel',[])
% set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
 %   'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
%line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
% added in 2.27.20 for vertical line in EMG plots
set(lax1,'XLim',[.5 5])



g(1) =line(lax1,'Color','r','Xdata',[t0 t0],'Ydata',lax1.YLim,'LineWidth',1);    
% legend(g,'Time Start','LineWidth',1);
yyaxis right 
line(lax1,t,dist,'LineWidth',2,'Color','m'); % add in distance variablea
ylabel('Distance (m)')
yyaxis left
line(lax1,t,vel,'LineWidth',2)
ylabel('Velocity (m/s)')
% legend('TimeStart','Velocity','Distance','FontSize',14)
    
    
 end
 
 %% EMG Plot

 emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'}; %

 sampRate=1000;
 nEMG=size(emg,2);
 temg=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
 avgwindow=.25; ds=sampRate*avgwindow;
 memg=max(emg);
 emg=abs(detrend(emg));
 meanEMG=movmean(emg,ds);

 
 
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL
% 
%  idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15]; % how occupying the figure of the emg plots


 idx2=[1:8]; % how occupying the figure of the emg plots
 %nEMG=length(idx2); % 8 rows of the column on the left for plot
 
 %memg= max(emg(:,idx2)); % *** WHAT DOES THIS DO
yspacing=cumsum(memg(idx2)*1.001); 
% yspacing(6:end)=yspacing(6:end)+0.5;

lax2 = axes('position',[0.05,0.05,.9,0.7]);
 set(lax2,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
 set(lax2,'YTick',fliplr(-yspacing(1:length(idx2))),'YTickLabel',fliplr(emgchan(idx2))) %,...
line(lax2,temg,emg(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)))
 set(lax2,'ColorOrder',co(end-1:-1:1,:))
% added in 2.27.20 for vertical line in EMG plots
line(lax2,temg,meanEMG(:,idx2)-yspacing(ones(length(temg),1),1:length(idx2)),'LineWidth',3.5);
if nargin >1 
   h(1)= line(lax2,'Color','r','Xdata',[t0 t0],'Ydata',lax2.YLim,'LineWidth',1);
end
set(lax2,'XLim',[.5 5])
set(lax2,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])

xlabel('Time (s)') 

% if nargin>1,
%   line(lax1,[t0 t0],lax1.YLim,'r')
% end
% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f1','-djpeg',[flpath '\MaxEMGs'])

end
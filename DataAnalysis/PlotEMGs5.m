function emgs_maxvel=PlotEMGs5(emg,dist,vel,t0,t,fname)
% AMA 5/1/20 - Modified for KCS NRSA
% GetMaxMusAct2(flpath,sename,setfname,partid,plotflag)

figure(1), clf
% if nargin >1 
    
% totaltime = (length(dist)-1)/50; % sampling f of act 3d is 50 hz 
% t = (0:.02:totaltime);
 %% Plot for distance and velocity
dist = dist(1:50,:);
vel = vel(1:50,:);
t = t(1:50); 
lax1 = axes('position',[0.05,0.8,0.88,0.15]);
set(lax1,'FontSize',12);
%set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none','XTick',[],'XTickLabel',[])
% set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
 %   'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
% line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
vdax=lax1;    
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
% added in 2.27.20 for vertical line in EMG plots
%set(lax1,'XLim',[.5 5])

%t0 time start t0(2) max vel t0(4) max distance


%line(lax1,'Color','r','Xdata',[t0(1) t0(1)],'Ydata',lax1.YLim,'LineWidth',1);  
line(lax1,'Color','b','Xdata',[t0(1) t0(1)],'Ydata',lax1.YLim,'LineWidth',1);  %REACH START
line(lax1,'Color','m','Xdata',[t0(2) t0(2)],'Ydata',lax1.YLim,'LineWidth',1); %MAX VEL
 line(lax1,'Color','k','Xdata',[t0(4) t0(4)],'Ydata',lax1.YLim,'LineWidth',1); % Max distance  % CUT OFF PLOT AT MAX DISTANCE
%line(lax1,'Color','b','Xdata',[maxreachtime maxreachtime],'Ydata',lax1.YLim,'LineWidth',1);
% legend(g,'Time Start','LineWidth',1);
yyaxis right 
line(lax1,t,dist,'LineWidth',2,'Color','b');
line(lax1,t,dist,'LineWidth',2,'Color','b');% add in distance variablea
ylabel('Distance (m)')
yyaxis left
% line(lax1,t,vel,'LineWidth',2)
line(lax1,t,vel,'LineWidth',2)
ylabel('Velocity (m/s)')
legend('Reach Start',' Max Velocity','Max Distance','Velocity','Distance','FontSize',14)
% end
 
 %% EMG Plot

  
 emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO'};



%  emg = emg(1:1000,:);

 sampRate=1000;
%  nEMG=size(emg,2);
temg=(0:size(emg,1)-1)/sampRate;% Assuming sampling rate is 1000 Hz


temg=temg';
% avgwindow=.25; ds=sampRate*avgwindow;

avgwindow=.05; ds=sampRate*avgwindow; % KCS changed 3/25/21
% emg=abs(detrend(emg));

meanEMG=movmean(emg,ds);


% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL, ADEL
% 
idx1=[1:2:8]; idx2=[2:2:8];



% idx1=[1:2:7]; idx2=[2:2:8]; % how occupying the figure of the emg plots
%Right erector spinae (RES), left external oblique (LEO) and right external oblique (REO) having UT and RT
% idx1=[1 2 3 4 5 6]; idx2=[7:]; % how occupying the figure of the emg plots
% idx2=[2 4 6]; % how occupying the figure of the emg plots
  

nEMG=length(idx1); % 8 rows of the column on the left for plot

%   memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]); 
%11.28.20 

memg = max([max(emg(:,idx1));max(emg(:,idx2))]); % replaced with this for spacing 
yspacing=cumsum(memg*1.05); 


t0_emgs = abs(t0-.15);  % converting the times for emg data 

t0_emgs_idx =round(t0_emgs*1000); %emg indices where certain max vel etc occur

maxdist_idx = t0_emgs_idx(3); %index where the max distance occurs for EMGS -- use to cut the EMGS


%COLUMN 1
lax1 = axes('position',[0.07,0.05,0.4,0.7]);
set(lax1,'color','none','xgrid','off','ygrid','off')%,'box','off','TickLabelInterpreter','none')
set(lax1,'YTick',fliplr(-yspacing(1:length(idx1))),'YTickLabel',fliplr(emgchan(idx1)),...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14)%,'XTick',[],'XTickLabel',[])

%cuts off EMGS AT MAX DIst
%  line(lax1,temg(1:maxdist_idx),emg(1:maxdist_idx,idx1)-yspacing(ones(length(temg(1:maxdist_idx)),1),1:length(idx1)),'LineWidth',2)

%plots whole trial
 line(lax1,temg(1:end),emg(1:end,idx1)-yspacing(ones(length(temg(1:end)),1),1:length(idx1)),'LineWidth',2)


co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
%plots whole trial 
 line(lax1,temg(1:end),meanEMG(1:end,idx1)-yspacing(ones(length(temg(1:end)),1),1:length(idx1)),'LineWidth',2)
%  line(lax1,temg(1:maxdist_idx),meanEMG(1:maxdist_idx,idx1)-yspacing(ones(length(temg(1:maxdist_idx)),1),1:length(idx1)),'LineWidth',2)

%COLUMN 2
lax2 = axes('position',[0.55,0.05,.4,0.7]);
 set(lax2,'color','none','xgrid','off','ygrid','off')%,'box','off','TickLabelInterpreter','none')
set(lax2,'YTick',fliplr(-yspacing(1:length(idx2))),'YTickLabel',fliplr(emgchan(idx2)),...
    'YLim',[-yspacing(end) memg(1)],'FontSize',14)%,'XTick',[],'XTickLabel',[],'FontSize',14);

%plots whole trial
 line(lax2,temg(1:end),emg(1:end,idx2)-yspacing(ones(length(temg(1:end)),1),1:length(idx2)),'LineWidth',2)

 %cuts off at max
% line(lax2,temg(1:maxdist_idx),emg(1:maxdist_idx,idx2)-yspacing(ones(length(temg(1:maxdist_idx)),1),1:length(idx2)),'LineWidth',2)

%set(lax2,'ColorOrder',co(end-1:-1:1,:))

co=get(lax2,'ColorOrder');
set(lax2,'ColorOrder',co(end-1:-1:1,:))

%cuts off at max dist
%line(lax2,temg(1:maxdist_idx),meanEMG(1:maxdist_idx,idx2)-yspacing(ones(length(temg(1:maxdist_idx)),1),1:length(idx2)),'LineWidth',2)

line(lax2,temg(1:end),meanEMG(1:end,idx1)-yspacing(ones(length(temg(1:end)),1),1:length(idx2)),'LineWidth',2)



%  if nargin >1 
%        line(lax1,'Color','b','Xdata',[t0_emgs(1) t0_emgs(1)],'Ydata',lax1.YLim,'LineWidth',1); % start reach
%        line(lax1,'Color','m','Xdata',[t0_emgs(2) t0_emgs(2)],'Ydata',lax1.YLim,'LineWidth',1); % max vel
%       line(lax2,'Color','b','Xdata',[t0_emgs(1) t0_emgs(1)],'Ydata',lax2.YLim,'LineWidth',1);
%        line(lax2,'Color','m','Xdata',[t0_emgs(2) t0_emgs(2)],'Ydata',lax2.YLim,'LineWidth',1);
%       %line(lax2,'Color','r','Xdata',[t0(1) t0(1)],'Ydata',lax2.YLim,'LineWidth',1);
%      % line(lax2,'Color','k','Xdata',[t0(4) t0(4)],'Ydata',lax2.YLim,'LineWidth',1);
%      % line(lax2,'Color','b','Xdata',[maxreachtime maxreachtime],'Ydata',lax2.YLim,'LineWidth',1);
%  end
set(lax1,'XLim',[0 .5])
set(lax2,'XLim',[0 .5])
set(lax1,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])
set(lax2,'YLim',[-yspacing(end) 0]) %memg(idx2(1))])
 xlabel('Time (s)') 

 emgs_maxvel = emg(t0_emgs_idx(2),:)
 
% Change the file name 'emgUT'
% save(fname,'temg','emg','meanEMG','memg','emgchan','co','t0','t','dist','vel')

% if nargin>1,
%   line(lax1,[t0 t0],lax1.YLim,'r')
% end
% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f3','-djpeg',[partID ')

end
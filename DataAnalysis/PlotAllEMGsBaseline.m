% function PlotAllEMGs(emg,t)

%function PlotAllEMGs(emg,t,timestart,timevelmax,timeend,timedistmax)
function PlotAllEMGsBaseline(emg,t,j)

% % for testing kacey
% emg = emg(:,j);

%emg = emg(:, [1:2 5:16]);
 emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
% emgchan = {'LES','RES','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','ADEL'};
% figure(1) 
% hold on
sampRate=1000;
nEMG=size(emg,2);
% t=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=0.25; ds=sampRate*avgwindow;
% emg=abs(detrend(emg));
 meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

 idx1 = [1];
 %idx1= [1:14]; 
nEMG=length(idx1);
memg=max(emg(:,idx1));
yspacing=cumsum([0 memg(2:nEMG)+.05]);
% lax1 = axes('position',[0.05,0.03,0.25,0.7]);
figure(1)
subplot(3,3,4)
% hold on
% set(lax1,'color','none','xgrid','on','ygrid','off','box','off','TickLabelInterpreter','none')
% set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
%     'YLim',[-yspacing(end) memg(1)])%,'XTick',[],'XTickLabel',[],'FontSize',14)
% line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
line(t,emg(:,idx1)-yspacing(ones(length(t),1),:))
%        line(lax1,'Color','b','Xdata',[t0_emgs(1) t0_emgs(1)],'Ydata',lax1.YLim,'LineWidth',1); % start reach
% p1 = line(lax1,'Color','b','Xdata',[timestart timestart],'Ydata',lax1.YLim,'LineWidth',1); % start reach
% p2= line(lax1,'Color','m','Xdata',[timevelmax timevelmax],'Ydata',lax1.YLim,'LineWidth',1); % max vel
% p3= line(lax1,'Color','c','Xdata',[timedistmax timedistmax],'Ydata',lax1.YLim,'LineWidth',1); %max dist
% p4= line(lax1,'Color','g','Xdata',[timeend timeend],'Ydata',lax1.YLim,'LineWidth',1); %endreach
 title ('BaselineData')
% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))
% % line(lax1,t,meanEMG(:,idx1)-yspacing(ones(length(t),1),:),'LineWidth',2)
% legend([p1 p2 p3 p4], 'Start Reach','Max Vel','Max Dist','End Reach')

end
function PlotAllEMGs(emg,t)

% for testing kacey
emg = emg(:,1:15);

%emg = emg(:, [1:2 5:16]);
 emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
% emgchan = {'LES','RES','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','ADEL'};
figure(1) 
clf
sampRate=1000;
nEMG=size(emg,2);
% t=(0:size(emg,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=0.25; ds=sampRate*avgwindow;
emg=abs(detrend(emg));
meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

 idx1 = [1:15];
 %idx1= [1:14]; 
nEMG=length(idx1);
memg=max(emg(:,idx1));
yspacing=cumsum([0 memg(2:nEMG)+.05]);
lax1 = axes('position',[0.08,0.05,0.84,0.9]);
set(lax1,'color','none','xgrid','off','ygrid','off','box','off','TickLabelInterpreter','none')
set(lax1,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(emgchan(idx1)),...
    'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[],'FontSize',14)
line(lax1,t,emg(:,idx1)-yspacing(ones(length(t),1),:))
co=get(lax1,'ColorOrder');
set(lax1,'ColorOrder',co(end-1:-1:1,:))
line(lax1,t,meanEMG(:,idx1)-yspacing(ones(length(t),1),:),'LineWidth',2)

% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f1','-djpeg',[flpath '\MaxEMGs2'])
% print('-f2','-djpeg',[flpath '\MaxEMGs'])
end
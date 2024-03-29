function[emg_timevel emg_timestart]= PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)


% % notes: These values indicate which muscle we're looking at
% idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];
% 
% % look at this next-- if you want to find the specific muscle
% % use the *:, idx_(_), trunk(1) v arm (2)
% line(t,emg(:,idx1(1)))
% title(emgchan(idx1(1)))
% 
% % size(emgLES) %checks
% % size(emg)
% % size(emg,1)
% % size(emg(round(reachingtime),:))

%% start of original code
%% note: replacing all emg with emg_timewindow?

cleandata= KaceyNotchfilter(emg);

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
assignin("base","Muscle_LST", char(emgchan)); %data name list structure

% pause
%clf
figure(2)
%subplot(2,1,2)
%emg=emg./maxes; %normalizing
sampRate=1000;
avgwindow=0.25; ds=sampRate*avgwindow;
nEMG=size(cleandata,2);
t=(0:size(cleandata,1)-1)/sampRate; % Assuming sampling rate is 1000 Hz
avgwindow=0.25; ds=sampRate*avgwindow;
emg=abs(detrend(cleandata));

% Kacey changed Jan 2022 emg to cleandata so using filtered EMG data
% without 60hz room noise. 
%% use this value
meanEMG=movmean(emg,ds);
% memg=max(emg);
% Subplot1 - LES,LRA,LEO,LIO,UT,MT,LD,PM
% Subplot2 - RES,RRA,REO,RIO,BIC,TRI,IDEL

emg_idxstart= round(timestart*1000);
emg_idxvel = round(timevelmax*1000);
emg_timestart = emg(emg_idxstart,:);
emg_timevel = emg(emg_idxvel,:);

% Reem: what is idx1? 
% These values indicate which muscle we're looking at
idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);








%% Extracting values for NMF analysis

% creating DATAsrc: muscles x (trials * conditions), 60x15

'all EMG values for our time window of interest for all muscles!'

%% plot the clean data
% 
% figure
% plot(cleandata(:, 1)) % has negative values, raw data filtered through
% size(cleandata) % 5000x 15
% 
% figure
% plot(emg(:, 1)) % abs function done, all nonnegative values
% size(emg) % 5000x 15
% 
% figure
% plot(meanEMG(:, 1)) % abs function done, all nonnegative values
% size(meanEMG) % 5000x 15
% pause

%% time window
%this is sampling rate, *******reaching time in samples*****
reachingtime= (timestart-0.15)*1000:(timestart+0.05)*1000; %interval at start of the reach (-150ms--> 50ms)
                % this is by samples--trial 5 seconds, collect 1000 data
                % points every second. (sampling rate)
size(reachingtime) %time in seconds
% reachingtime
% pause

% (timestart*1000)-150 (or 0.15 w/ 1000)
% looking at the movement itself (preporatory phase)
% biomechanics--time points are dependent
% (timestart*1000)

%% creating EMG with time window of interest for all 15 muscles

meanEMG_timewindow_mini = meanEMG(round(reachingtime),:); %final--looking at meanEMG for NMF (201x15)
meanEMG_timewindow_mini = mean(meanEMG_timewindow_mini); %finding the average over that one time window (1x15)
size(meanEMG_timewindow_mini)

meanEMG_timewindow = transpose(meanEMG_timewindow_mini);  %transpose--data structure needs to be muscles x time/window (15x1)
size(meanEMG_timewindow)
% plot(meanEMG_timewindow)



% EXTRACT AND PUT INTO BASE WORKSPACE.  
% basically what I'm trying to do is for each trial extract my variable
% of interest for each trial seperately. Once theyre all in the workspace,
% I highlight them all and save them as a given file (refer to
% Reem_mockwalking_test.mat)

'which trial are we on?:'
close all

% assignin("base",'emg_timewindow_1', meanEMG_timewindow);
% assignin("base","emg_timewindow_2", meanEMG_timewindow);
% assignin("base","emg_timewindow_3",meanEMG_timewindow);
% assignin("base","emg_timewindow_4",meanEMG_timewindow);
% assignin("base","emg_timewindow_5",meanEMG_timewindow);
% assignin("base","emg_timewindow_6", meanEMG_timewindow);
% assignin("base","emg_timewindow_7",meanEMG_timewindow);
% assignin("base","emg_timewindow_8",meanEMG_timewindow);
% assignin("base","emg_timewindow_9",meanEMG_timewindow);
assignin("base","emg_timewindow_10",meanEMG_timewindow);


% %% copypaste this and change to indicate # of control
% list_Control2 = cat(2, emg_timewindow_1, emg_timewindow_2, emg_timewindow_3, emg_timewindow_4, emg_timewindow_5, ...
%     emg_timewindow_6, emg_timewindow_7, emg_timewindow_8, emg_timewindow_9)
pause







%% Trunk muscles

% % ***** NOTE **** Shift EMG muscles back by 50 ms because they occur earlier than the
% % movement itself.. Move back 
% subplot(5,2,3)
% line(t,emg(:,idx1(1)))
% title(emgchan(idx1(1)))
% 
% 
% 
% 
% 
% 
% 
% pause
% cla
% subplot(5,2,3)
% line(t,abs(cleandata(:,idx1(1))))
% yl=ylim;
% hold on
% plot(t,meanEMG(:,idx1(1)),'LineWidth',2,'Color','g')
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(1)))
% 
% subplot(5,2,4)
% line(t,emg(:,idx2(1)))
% title(emgchan(idx2(1)))
% pause
% cla
% subplot(5,2,4)
% line(t,abs(cleandata(:,idx2(1))))
% hold on
% plot(t,meanEMG(:,idx2(1)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(1)))
% 
% subplot(5,2,5)
% line(t,emg(:,idx1(2)))
% title(emgchan(idx1(2)))
% pause
% cla
% subplot(5,2,5)
% line(t,abs(cleandata(:,idx1(2))))
% hold on
% plot(t,meanEMG(:,idx1(2)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(2)))
% 
% subplot(5,2,6)
% line(t,emg(:,idx2(2)))
% title(emgchan(idx2(2)))
% pause
% cla
% subplot(5,2,6)
% line(t,abs(cleandata(:,idx2(2))))
% hold on
% plot(t,meanEMG(:,idx2(2)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(2)))
% 
% subplot(5,2,7)
% line(t,emg(:,idx1(3)))
% title(emgchan(idx1(3)))
% pause
% cla
% subplot(5,2,7)
% line(t,abs(cleandata(:,idx1(3))))
% hold on
% plot(t,meanEMG(:,idx1(3)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(3)))
% 
% subplot(5,2,8)
% line(t,emg(:,idx2(3)))
% title(emgchan(idx2(3)))
% pause
% cla
% subplot(5,2,8)
% line(t,abs(cleandata(:,idx2(3))))
% hold on
% plot(t,meanEMG(:,idx2(3)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(3)))
% 
% subplot(5,2,9)
% line(t,emg(:,idx1(4)))
% title(emgchan(idx1(4)))
% pause
% cla
% subplot(5,2,9)
% line(t,abs(cleandata(:,idx1(4))))
% hold on
% plot(t,meanEMG(:,idx1(4)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(4)))
% 
% subplot(5,2,10)
% line(t,emg(:,idx2(4)))
% title(emgchan(idx2(4)))
% pause
% cla
% subplot(5,2,10)
% line(t,abs(cleandata(:,idx2(4))))
% hold on
% plot(t,meanEMG(:,idx2(4)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(4)))


% 
% figure(3)
%% Arm Muscle 
% subplot(5,2,3)
% line(t,emg(:,idx1(5)))
% title(emgchan(idx1(5)))
% pause
% cla
% subplot(5,2,3)
% line(t,abs(cleandata(:,idx1(5))))
% hold on
% plot(t,meanEMG(:,idx1(5)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(5)))
% 
% subplot(5,2,4)
% line(t,emg(:,idx2(5)))
% title(emgchan(idx2(5)))
% pause
% cla
% subplot(5,2,4)
% line(t,abs(cleandata(:,idx2(5))))
% hold on
% plot(t,meanEMG(:,idx2(5)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(5)))
% 
% subplot(5,2,5)
% line(t,emg(:,idx1(6)))
% title(emgchan(idx1(6)))
% pause
% cla
% subplot(5,2,5)
% line(t,abs(cleandata(:,idx1(6))))
% hold on
% plot(t,meanEMG(:,idx1(6)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(6)))
% 
% subplot(5,2,6)
% line(t,emg(:,idx2(6)))
% title(emgchan(idx2(6)))
% pause
% cla
% subplot(5,2,6)
% line(t,abs(cleandata(:,idx2(6))))
% hold on
% plot(t,meanEMG(:,idx2(6)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(6)))
% 
% subplot(5,2,7)
% line(t,emg(:,idx1(7)))
% title(emgchan(idx1(7)))
% pause
% cla
% subplot(5,2,7)
% line(t,abs(cleandata(:,idx1(7))))
% hold on
% plot(t,meanEMG(:,idx1(7)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(7)))
% 
% subplot(5,2,8)
% line(t,emg(:,idx2(7)))
% title(emgchan(idx2(7)))
% pause
% cla
% subplot(5,2,8)
% line(t,abs(cleandata(:,idx2(7))))
% hold on
% plot(t,meanEMG(:,idx2(7)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx2(7)))
% 
% subplot(5,2,9)
% line(t,emg(:,idx1(8)))
% title(emgchan(idx1(8)))
% pause
% cla
% subplot(5,2,9)
% line(t,abs(cleandata(:,idx1(8))))
% hold on
% plot(t,meanEMG(:,idx1(8)),'LineWidth',2,'Color','g')
% yl=ylim;
% line('Color','g','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% %line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% title(emgchan(idx1(8)))
% %
% hold on
% yl=ylim; %getting the ylimits to plot vertical line
% 
% timevelmax
% timedistmax
% line('Color','b','Xdata',[timestart timestart],'Ydata',[yl(1) yl(2)], 'LineWidth',.7); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); % max vel
% line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %max, dist
% % line('Color','r','Xdata',[timeend timeend],'Ydata',[yl(1) yl(2)],'LineWidth',.7); %endreach
% 
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
% 
% 
% ylabel 'V'
% title(['EMGs - ' flpath(1:end)],'Interpreter','none')
% print('-f1','-djpeg',[flpath '\MaxEMGs2'])
% print('-f2','-djpeg',[flpath '\MaxEMGs'])
%%
end

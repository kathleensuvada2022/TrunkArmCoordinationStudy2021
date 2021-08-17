function [avgshouldertrunk std_shldtr  avgmaxreach std_maxreach] = PlotKinematicData6(partid,hand,metriafname,act3dfname,expcond,flag)
% File path and loading setupfile
datafilepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data','/',partid,'/',hand];
load(fullfile(datafilepath,[partid '_setup.mat'])); %load setup file 

%% Loading in Max EMGS
     load([datafilepath '/Maxes/maxEMG.mat']);
%% Loading and setting file name and condition
expcondname={'RT','R25','R50','UT','U25','U50'};

% all the same file path now
afilepath = datafilepath;
afilepath2 = afilepath;
mfilepath = afilepath2;


%updated for new data structure 1.28.21
 mtrials=setup.trial{expcond};
 atrials=setup.trial{expcond};
 ntrials=length(mtrials);

%% Initializing Variables

maxreach=zeros(ntrials,1);
emgstart = zeros(ntrials,15); % changed to 16 because 16 EMGS


emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1);
maxreach=zeros(ntrials,1);
emgstart = zeros(ntrials,15); % changed to 16 because 16 EMGS

emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1);

maxreach_current_trial =zeros(ntrials,1);
maxTrunk_current_trial=zeros(ntrials,1);
emgsmaxvel_vals = zeros(ntrials,15);


maxreach_current_trial =zeros(ntrials,1);
shtrdisp_current_trial=zeros(ntrials,2);
%% Main loop that grabs Metria data and plots 
for i=1:length(mtrials)
mfname = ['/' metriafname num2str(mtrials(i)) '.mat'];
afname =  mfname;
afname2 = mfname;
      

% 
% % Kacey added to call new function to plot in GCS
% bl = load('/Users/kcs762/Box/KACEY/Data/RTIS1002/BLs/BL.mat');
% datafile =load([mfilepath '/' mfname]);
% PlotGCS(datafile,bl,setup)
%     
%     figure(2),clf
%     if strcmp(partid,'RTIS2001') && (mtrials(i)==8)
%         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
%     else
% 
%

%%%%%%%%%%% Getting Metria Data %%%%%%%%%%%%%%%%%%%

[t,mridx,rdist,xhand,xshoulder,xtrunk,xshldr,xjug,maxreach,shtrdisp]=GetHandShoulderTrunkPosition8(mfilepath,mfname,partid,setup,flag);
   
 %% Metria Trial by Trial Kinematic Data (computed BLS)
 
 if flag
 figure(1),clf
 subplot(2,1,1)
 plot([xhand(:,1) xshldr(:,1) xjug(:,1)],[xhand(:,2) xshldr(:,2) xjug(:,2)],'LineWidth',2);
 hold on
plot(xhand(mridx,1),xhand(mridx,2),'o','MarkerSize',10,'MarkerFaceColor','r');
% % p1=plot(-[xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2); hold on
% hold on
% p2=plot(gca,nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1) xfore(1:10,1) xarm(1:10,1)]),nanmean([xhand(1:10,2) xshoulder(1:10,2) xtrunk(1:10,2) xfore(1:10,2) xarm(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% % p3 = plot([xee*1000 xhnd*1000],[yee*1000 yhnd*1000],'LineWidth',4);  % added to add act 3d data
% % p3 = plot([xactee(:,1) xactha(:,1)],[xactee(:,2) xactha(:,2)],'LineWidth',4);  % added to add act 3d data
% %p3 = plot([xactee(:,1) p(:,1)],[xactee(:,2) p(:,2)],'LineWidth',4);  % added to add act 3d data
% p4=plot(gca,[setup.exp.hometar(1) setup.exp.shpos(1)]*1000,[setup.exp.hometar(2) setup.exp.shpos(2)]*1000,'o','MarkerSize',10,'MarkerFaceColor','r');
% 
% 
% %p5=quiver(gca,xfore([1 1 40 40],1),xfore([1 1 40 40],2),lcsfore([1 2 79 80],1),lcsfore([1 2 79 80],2),'LineWidth',2);
% % p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');

% % phandles=[p1' p2 p3];
 axis 'equal'
  legend('Hand','Shoulder','Trunk')
xlabel('x (mm)')
ylabel('y (mm)')
title(mfname)

%Metria Distance Plot with Max Distance Marked
subplot(2,1,2)
plot(t,rdist)
hold on
p1 = line('Color','b','Xdata',[t(mridx) t(mridx)],'Ydata',[400 650], 'LineWidth',.5); % start reach
% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))
xlabel('Time')
ylabel('Distance') 
legend('Distance','Max Dist')
% 
 pause
 end
 
%% 
% maxreach_seconds = maxreachtime;
 maxreach_current_trial(i) =maxreach; % reaching distance in mM
 shtrdisp_current_trial(i,:) = shtrdisp;  % shoulder and trunk displacement in mM
% maxreachtime;


%% Loading in EMGS 

% Normalized EMGS
load([afilepath afname])
emg= data.daq{1,2};
emg=abs(detrend(emg(:,1:15)))./maxEMG(ones(length(emg(:,1:15)),1),:); % Detrend and rectify EMG 
    
%% Computing the start of the reach
%actdata=data.act;
load([mfilepath mfname])
metdata=data.met;

[dist,vel,timestart,timevelmax,timeend,timedistmax]= ComputeReachStart_2021(metdata,setup,mridx);
%%    
% Clean this up? Is any of this neccessary anymore?
%     switch partid
%         case 'RTIS2001'
%             if expcond==3 && i==1
%                 time(3)=t0(108);
%             end
%     end
    
%      index = ceil(time/.001);
      
     
%     ibefore = timebefore/.001;
%     ibefore = int32(ibefore);
%     ivelmax = timevelmax/.001;
    
%      emgval(i,:,:) = emg(index,1:16); % CHANGE to 16 from 15  COMMENTED
%     OUT DON't think need for EMGS? comment back in but was erroring
     % emgstart(i,:)= emg(ivelmax,1:15);
    
    
    
%   emgbefore = emg(ibefore,1:15)
%     emgmaxvel = emg(ivelmax,1:15)
    

%     Lines 175-178?? Why here?? 
%     emg=emg(1001:end,:);
%     t=t-1;
%     time=time-1;


%% Plotting EMGS
% PlotEMGsCleanV2(emg,timestart,timevelmax,timeend,timedistmax,i)% disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])

%% Main Cumulative Metria Figure
 figure(4)
        p1=plot([xhand(:,1) xshldr(:,1) xjug(:,1)],[xhand(:,2) xshldr(:,2) xjug(:,2)],'LineWidth',2);
        hold on
       
        idxvelmax = find(t==timevelmax,1);
       c1= viscircles([xhand(idxvelmax,1),xhand(idxvelmax,2)],5,'Color','m');
        
        idxreachstart = find(t==timestart,1);
       c2= viscircles([xhand(idxreachstart,1),xhand(idxreachstart,2)],5,'Color','g');

      
        idxdistmax = length(xhand);
       c3= viscircles([xhand(idxdistmax,1),xhand(idxdistmax,2)],5,'Color','r');

   %    p2=plot(nanmean([xhand(1:10,1) xshldr(1:10,1) xjug(1:10,1)]),nanmean([xhand(1:10,2) xshldr(1:10,2) xjug(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%       p2=plot([xhand(10,2) xshoulder(10,2) xtrunk(10,2)],[xhand(10,2) xshoulder(10,2) xtrunk(10,2)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
  %     p3=plot([xhand(end,1) xshldr(end,1) xjug(end,1)],[xhand(end,2) xshldr(end,2) xjug(end,2)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');

        set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
  %     viscircles([nanmean(xhand(1:10,1)),nanmean(xhand(1:10,2))],10,'Color','g')


%legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
legend([p1' c1 c2 c3],'Hand','Shoulder','Trunk','Max Vel','Reach Start','Max Distance','Location','northwest','FontSize',16)
axis 'equal'
xlabel('X (mm)','FontSize',16)
ylabel('Y (mm)','FontSize',16)

if expcond== 1 
title('Trunk Restrained Table','FontSize',18)
end

if expcond== 2 
title('Trunk Restrained 25%','FontSize',18)
end

if expcond== 3 
title('Trunk Restrained 50%','FontSize',18)
end

if expcond== 4
title('Trunk Unrestrained Table','FontSize',18)
end

if expcond== 5
title('Trunk Unrestrained 25%','FontSize',18)
end

if expcond== 6
title('Trunk Unrestrained 50%','FontSize',18)
end
% 
%% Calling COP Function
%  ppsdata =data.pps;

%  [CoP1]= ComputeCOP(ppsdata);

pause
end
%% Printing out the max reach, std, shoulder and trunk displacement and std
avgmaxreach =nanmean(maxreach_current_trial)
std_maxreach = nanstd(maxreach_current_trial)
avgshouldertrunk = nanmean(shtrdisp_current_trial)
std_shldtr = nanstd(shtrdisp_current_trial)
end   
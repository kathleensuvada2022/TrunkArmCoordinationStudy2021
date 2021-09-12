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
emgstart = zeros(ntrials,15); 


emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1);
maxreach=zeros(ntrials,1);
emgstart = zeros(ntrials,15); 

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
      
mfname
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

[t,xhand,xshoulder,xtrunk,xshldr,xjug]=GetHandShoulderTrunkPosition8(mfilepath,mfname,partid,setup,flag);
   

 %% Metria Trial by Trial Kinematic Data (computed BLS)
 
 if flag
 figure(1),clf
 subplot(2,1,1)
 plot([(xhand(:,1)-xjug(1,1)) (xshldr(:,1)-xjug(1,1)) (xjug(:,1)-xjug(1,1))],[(xhand(:,2)-xjug(1,2)) (xshldr(:,2)-xjug(1,2)) (xjug(:,2)-xjug(1,2))],'LineWidth',1);
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
 

%% Loading in EMGS 

% Normalized EMGS
load([afilepath afname])
emg= data.daq{1,2};
emg=abs(detrend(emg(:,1:15)))./maxEMG(ones(length(emg(:,1:15)),1),:); % Detrend and rectify EMG 
    
%% Computing the start of the reach
%actdata=data.act;
load([mfilepath mfname])
metdata=data.met;

[dist,vel,distmax,idx]= ComputeReachStart_2021(t,xhand,setup,expcond,partid,mfname,hand);
%% Compute reaching distance (between shoulder and hand from hand marker)
%maxreach=sqrt(sum((xhand(idx(3),1:2)-xshldr(idx(3),1:2)).^2,2));
maxreach = sqrt((xhand(idx(3),1)-xshldr(idx(3),1))^2+(xhand(idx(3),2)-xshldr(idx(3),2))^2);

%% Max Hand Excursion

%using original data
Xo_sh= nanmean(xshldr(1:5,1));
Yo_sh = nanmean(xshldr(1:5,2)); 

maxhandexcrsn = sqrt((xhand(idx(3),1)-Xo_sh)^2 +(xhand(idx(3),2)-Yo_sh)^2);


%% Compute shoulder and trunk displacement at maximum reach - using BLS

  shtrdisp=sqrt(sum(([xshldr(idx(3),1:2);xjug(idx(3),1:2)]-[nanmean(xshldr(1:5,1:2));nanmean(xjug(1:5,1:2))]).^2,2))';
  
  sh_exc = shtrdisp(1) -shtrdisp(2);
  
  trunk_exc = shtrdisp(2);


%% Getting Trunk, Shoulder, Hand Excursion, and reaching distance for the current trial
maxhandexcrsn_current_trial(i) = maxhandexcrsn; %hand excursion defined as difference between hand at every point and inital shoudler position
 
maxreach_current_trial(i) =maxreach; % reaching distance in mm difference hand and shoudler
 
shex_current_trial(i) = sh_exc;  

trex_current_trial(i) = trunk_exc;


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
 figure(4),clf
%        p1=plot([xhand(idx(1):idx(3),1) xshldr(idx(1):idx(3),1) xjug(idx(1):idx(3),1)],[xhand(idx(1):idx(3),2) xshldr(idx(1):idx(3),2) xjug(idx(1):idx(3),2)],'LineWidth',2);
       p1=plot([xhand(:,1) xshldr(:,1) xjug(:,1)],[xhand(:,2) xshldr(:,2) xjug(:,2)],'LineWidth',2);
%         p1= plot([(xhand(:,1)-xjug(1,1)) (xshldr(:,1)-xjug(1,1)) (xjug(:,1)-xjug(1,1))],[(xhand(:,2)-xjug(1,2)) (xshldr(:,2)-xjug(1,2)) (xjug(:,2)-xjug(1,2))],'LineWidth',1);
     Newreachx = (xhand(:,1)-xjug(1,1));
     Newreachy = (xhand(:,2)-xjug(1,2));
        hold on
       
%         idxvelmax = find(t==timevelmax,1);
%        c1= viscircles([Newreachx(idxvelmax),Newreachy(idxvelmax)],5,'Color','m');
             
%        c2= viscircles([xhand(idxvelmax,1),xhand(idxvelmax,2)],5,'Color','m');
   %  c2=  plot(xhand(idxvelmax,1),xhand(idxvelmax,2),'o','MarkerEdgeColor','m','MarkerSize',10);


        
%      idxreachstart = find(t==timestart,1);
 %      c2= viscircles([Newreachx(idxreachstart),Newreachy(idxreachstart)],5,'Color','g');
  % c1= viscircles([xhand(idxreachstart,1),xhand(idxreachstart,2)],5,'Color','g');
    c1= plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10);
        
    plot(xshldr(idx(1),1),xshldr(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
    plot(xshldr(idx(3),1),xshldr(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); % marking shoulder end
   
    plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking trunk start
    plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); % marking trnk end

    
      
       idxdistmax = length(xhand);
%        c3= viscircles([Newreachx(idxdistmax),Newreachy(idxdistmax)],5,'Color','r');
 %c3= viscircles([xhand(idx(3),1),xhand(idx(3),2)],5,'Color','r');
 c3= plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10);


   %    p2=plot(nanmean([xhand(1:10,1) xshldr(1:10,1) xjug(1:10,1)]),nanmean([xhand(1:10,2) xshldr(1:10,2) xjug(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%       p2=plot([xhand(10,2) xshoulder(10,2) xtrunk(10,2)],[xhand(10,2) xshoulder(10,2) xtrunk(10,2)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
  %     p3=plot([xhand(end,1) xshldr(end,1) xjug(end,1)],[xhand(end,2) xshldr(end,2) xjug(end,2)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');

        set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
  %     viscircles([nanmean(xhand(1:10,1)),nanmean(xhand(1:10,2))],10,'Color','g')

  armlength = (setup.exp.armLength+setup.exp.e2hLength)*10
  y1= yline( armlength,'LineWidth',2,'Color','b');% Line where the arm length is 
 


%legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
%legend([p1' c1 c3 y1],'Hand','Shoulder','Trunk','Reach Start','Max Distance',' Arm Length','Location','northwest','FontSize',16)
%axis 'equal'
xlabel('X (mm)','FontSize',16)
ylabel('Y (mm)','FontSize',16)
axis equal
% xlim([-500 100])
% ylim([-100 800])
if mtrials== 1 
title('Restrained Table','FontSize',18)
end

if expcond== 2 
title('Restrained 25%','FontSize',18)
end

if expcond== 3 
title('Restrained 50%','FontSize',18)
end

if expcond== 4
title('Unrestrained Table','FontSize',18)
end

if expcond== 5
title('Unrestrained 25%','FontSize',18)
end

if expcond== 6
title('Unrestrained 50%','FontSize',18)
end

%% Calling COP Function
%   ppsdata =data.pps;
%   tpps = data.pps{1,1};
%   ppsdata= ppsdata{1,2};
%   ppsdata = ppsdata(1:mridx,:); % cutting off at max reach
%  [CoP2]= ComputeCOP(ppsdata,tpps);

pause
end
%% Printing out the max reach, std, shoulder and trunk displacement and std
avgmaxreach =nanmean(maxreach_current_trial)
std_maxreach = nanstd(maxreach_current_trial)

avgmaxhand = nanmean(maxhandexcrsn_current_trial)
std_maxhand= nanstd(maxhandexcrsn_current_trial)

avgshldr = nanmean(shex_current_trial)
stdshldr = nanstd(shex_current_trial)

avgtrunk = nanmean(trex_current_trial)
stdtrunk = nanstd(trex_current_trial)

end   
% function [avg_emg_maxvel avgmaxreach] = PlotKinematicData6(partid,fname,expcond)

% RT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkrestrained\','RTIS2001_000000',4:5);
% UT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 9 10])
% UL - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])

% datafilepath ='/Users/kcs762/Box/KACEY/Data/';
% datafilepath='/Users/kcs762/Northwestern University/Anamaria Acosta - TACS/Data';
filepath='F:\usr\Ana Maria\OneDrive - Northwestern University\Data\TACS\Data\MetriaPPSDataJass4821\test4821';

% if exist([datafilepath partid '/maxes/maxEMG.mat'])==2, 
%     load([datafilepath partid '/maxes/maxEMG.mat']);
%     %disp(maxEMG)
% else
%     disp('Computing Maximum Muscle EMGs. Make sure you check them')
% %     maxEMG=GetMaxMusAct2(flpath,basename,setfname,partid,plotflag)
%     [maxEMG]=GetMaxMusAct2([partid '/maxes'],'maxes','savedsetupKacey','Control',0);
% end


expcondname={'RT','R25','R50','UT','U25','U50'};

load(fullfile(filepath,[partid '_setup']))

%updated for new data structure 1.28.21
%  trials=setup.trial{expcond};
trials=1:7;
ntrials=length(trials);


% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);

maxreach=zeros(ntrials,1);
% emgstart = zeros(ntrials,15); % changed to 16 because 16 EMGS
% emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1); % How is this different from maxreach?

%initializing all the variables we are saving EMG data/and Max reach 
% maxreach_current_trial =zeros(ntrials,1);
% maxTrunk_current_trial=zeros(ntrials,1);
% emgsmaxvel_vals = zeros(ntrials,15);
%%
for i=1:1 %ntrials
% fname = ['/' fname num2str(mtrials(i)) '.mat'];      
disp([fname num2str(trials(i))]) % displays trial 
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

[xaa,xxp,maxreach,trdisp,maxreachtime]=GetHandShoulderTrunkPosition8(filepath,[fname num2str(trials(i))],partid);

% [xaa,xxp,maxreach,trdisp,maxreachtime]=GetHandShoulderTrunkPosition8(filepath,[fname num2str(trials(i))],partid);

 maxreach_seconds = maxreachtime;
 maxreach_current_trial(i) =maxreach/10 % reaching distance in CM
%  maxTrunk_current_trial(i) = trdisp/10   % trunk displacement in CM
 maxreachtime;
%  end
%     figure(1)
%     if i==1
%         p1=plot([xhand(:,1) xshoulder(:,1) xtrunk(:,1)],-[xhand(:,3) xshoulder(:,3) xtrunk(:,3)],'LineWidth',2);
%         hold on
% %         p2=plot(nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshoulder(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%         p2=plot([xhand(1,1) xshoulder(1,1) xtrunk(1,1)],-[xhand(1,3) xshoulder(1,3) xtrunk(1,3)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%         p3=plot([xhand(end,1) xshoulder(end,1) xtrunk(end,1)],-[xhand(end,3) xshoulder(end,3) xtrunk(end,3)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     else
%         p1=plot([xhand(:,1) xshoulder(:,1) xtrunk(:,1)],-[xhand(:,3) xshoulder(:,3) xtrunk(:,3)],'LineWidth',2);
% %         hold on
% %         p2=plot(nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshoulder(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%         p2=plot([xhand(1,1) xshoulder(1,1) xtrunk(1,1)],-[xhand(1,3) xshoulder(1,3) xtrunk(1,3)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%         p3=plot([xhand(end,1) xshoulder(end,1) xtrunk(end,1)],-[xhand(end,3) xshoulder(end,3) xtrunk(end,3)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
%     end
%      set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
 
    
    % Plot EMGs
     load([afilepath afname])
    emg=abs(detrend(data.daq{1,2}(:,1:15)))./maxEMG(ones(length(data.daq{1,2}(:,1:15)),1),:); % Detrend and rectify EMG % Changed based on new data structure 

   
    
    % Computing the start of the reach
    [dist,vel,time,rdist,t]= ComputeReachStart5(afilepath,afname);
    
%     switch partid
%         case 'RTIS2001'
%             if expcond==3 && i==1
%                 time(3)=t0(108);
%             end
%     end
    
       index = ceil(time/.001);
%     ibefore = timebefore/.001;
%     ibefore = int32(ibefore);
%     ivelmax = timevelmax/.001;
    
%      emgval(i,:,:) = emg(index,1:16); % CHANGE to 16 from 15  COMMENTED
%     OUT DON't think need for EMGS? comment back in but was erroring
     % emgstart(i,:)= emg(ivelmax,1:15);
    
    
    
%   emgbefore = emg(ibefore,1:15)
%     emgmaxvel = emg(ivelmax,1:15)
    
    figure(2)
%     Lines 175-178?? Why here?? 
%     emg=emg(1001:end,:);
%     t=t-1;
%     time=time-1;
%     dist=dist(

   emgs_maxvel=PlotEMGs5(emg,dist,vel,time,t,[partid '_EMG' expcondname{expcond} num2str(i)]);%,title([partid '-' afname],'Interpreter','none','Position',[-2,1,0])
%     disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])
%     title(ax,[partid ' ' expcondname{expcond} ' trial ' num2str(i)])
%     print('-f3','-djpeg',[partid '_EMG' num2str(expcond) num2str(i)])

emgsmaxvel_vals(i,:)=emgs_maxvel; %saving each emg value at max vel to maxtrix for all trials
    


%% 

%     figure
% %legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
% plot([x3mcp(:,1) xxp(:,1)],[x3mcp(:,2)  xxp(:,2)],'LineWidth',2);
% axis 'equal'
% % axis([-0.3 0.2 -1.05 -0.15])
% xlabel('x(m)'),ylabel('y(m)')
% title(mfname)

% 
% title('Reaching with trunk unrestrained - 5% Max SABD')
% title('Reaching with trunk unrestrained - table')
%  title('Reaching with trunk restrained - table')

% text(-0.1,-0.25,['TR DISP= ', num2str((trdisp/10))])
% text(-0.28,-0.55,['MAX REACH = ', num2str((maxreach/10))])
% text(-.28,-.45,['MFNAME = ', num2str((mfname))])

% text(-0.28,-0.3,['STD of Max reach = ', num2str(std(maxreach))])
% print('-f3','-djpeg',[partid '_RT'])
disp(maxreach/10)



% % Calling COP Function
% 
% ppsdata =data.pps;
% [CoP1,CoP2,stdMat1,stdMat2]= ComputeCOP(ppsdata,maxreach_seconds);
% 
% stdMat1
% stdMat2
     pause   %pausing between each trial
    


end
%%
avg_emg_maxvel =mean(emgsmaxvel_vals); % gives the EMG values at the maximum velocity across trials
avgmaxreach =mean(maxreach_current_trial);

% end   
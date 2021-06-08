function [avg_emg_maxvel avgmaxreach] = PlotKinematicData6(partid,metriafname,act3dfname,setupf,expcond)

% partid,'2001tf_final_000000','Target_',3
% partid = 'RTIS2001';
% metriafname = '2001tf_final_000000';
% act3dfname = 'Target_';
 %expcond =2;
% expcond=1-RT, 2-RL, 3-UT, 4-UL

% filepath='RTIS2001\metria\trunkfree\';
% filename='2001tf_final_000000'; %01.hts';
% partid='RTIS2002';
% trials=1:11;
% 
% RT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkrestrained\','RTIS2001_000000',4:5);
% UT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 9 10])
% UL - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])

% datafilepath ='/Users/kcs762/Box/KACEY/Data/';
datafilepath = '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/';

% datafilepath='/Users/kcs762/Northwestern University/Anamaria Acosta - TACS/Data';
% 
% if exist([datafilepath partid '/Maxes/maxEMG.mat'])==2, 
%     load([datafilepath partid '/Maxes/maxEMG.mat']);
%     %disp(maxEMG)
% else
%     disp('Computing Maximum Muscle EMGs. Make sure you check them')
% %     maxEMG=GetMaxMusAct2(flpath,basename,setfname,partid,plotflag)
%     [maxEMG]=GetMaxMusAct2([partid '/maxes'],'maxes','savedsetupKacey','Control',0);
% end

expcondname={'RT','R25','R50','UT','U25','U50'};

%load setup in manually for the different shoulder positions if using ACT3D
%data
% load([datafilepath '/' partid '/' partid '_setup'])

%Now can specify the setup file using
load([datafilepath '/' partid '/' setupf])

%load('/Users/kcs762/Box/KACEY/Data/RTIS2003/42321/RTIS2003_setup_Final_TU.mat')


% switch expcond - uncomment when running participants with MOCAP changed
% 1.19.20
%     case {1,2} % Restrained
% %         mfilepath='/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkrestrained/';          
% %         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkrestrained/';
%         mfilepath=[partid '/metria/trunkrestrained/'];
%         afilepath=[partid '/act3d/trunkrestrained/'];
%         afilepath2 =[partid '/act3d/trunkrestrained/AllData']; % this is for the ACT 3D find reach start
%     otherwise
% %         mfilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkfree/';
% %         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkfree/';
%         mfilepath=[partid '/metria/trunkfree/'];
%         afilepath=[partid '/act3d/trunkfree/'];
%         afilepath2 =[partid '/act3d/trunkfree/AllData'];
% end
% afilepath =[partid '/act3d/']; % this is for the ACT 3D find reach start

% all the same file path now
afilepath = [datafilepath '/' partid];
afilepath2 = afilepath;
mfilepath = afilepath2;

% mtrials=setup.mtrial{expcond}; atrials=setup.atrial{expcond};
% ntrials=length(mtrials);


%updated for new data structure 1.28.21
 mtrials=setup.trial{expcond}; atrials=setup.trial{expcond};
 ntrials=length(mtrials);


% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);

maxreach=zeros(ntrials,1);
emgstart = zeros(ntrials,15); % changed to 16 because 16 EMGS



emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1);
maxreach=zeros(ntrials,1);
emgstart = zeros(ntrials,15); % changed to 16 because 16 EMGS



emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
rdist = zeros(ntrials,1);


 
%initializing all the variables we are saving EMG data/and Max reach 
maxreach_current_trial =zeros(ntrials,1);
maxTrunk_current_trial=zeros(ntrials,1);
emgsmaxvel_vals = zeros(ntrials,15);


 
%initializing all the variables we are saving EMG data/and Max reach 
maxreach_current_trial =zeros(ntrials,1);
maxTrunk_current_trial=zeros(ntrials,1);
emgsmaxvel_vals = zeros(ntrials,15);
%%
for i=1:length(mtrials)
mfname = ['/' metriafname num2str(mtrials(i)) '.mat'];
afname = mfname;
afname2 = mfname;
      
%disp(mfname); % displays trial 
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


%% Getting Metria Data 
[xhand,xshoulder,xtrunk,maxreach]=GetHandShoulderTrunkPosition8(mfilepath,mfname,partid,setupf);
   
% maxreach_seconds = maxreachtime;
 maxreach_current_trial(i) =maxreach/10; % reaching distance in CM
%  maxTrunk_current_trial(i) = trdisp/10   % trunk displacement in CM
% maxreachtime;


    
%% Loading in EMGS 
   %load([afilepath afname])
  % emg=abs(detrend(data.daq{1,2}(:,1:15)))./maxEMG(ones(length(data.daq{1,2}(:,1:15)),1),:); % Detrend and rectify EMG % Changed based on new data structure 

   
    
 %% Computing the start of the reach

% [dist,vel,time,rdist,t]= ComputeReachStart5(afilepath,afname);
    
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
    
%    figure(2)
%     Lines 175-178?? Why here?? 
%     emg=emg(1001:end,:);
%     t=t-1;
%     time=time-1;
%     dist=dist(

%% Plotting EMGS


% emgs_maxvel=PlotEMGs5(emg,dist,vel,time,t,[partid '_EMG' expcondname{expcond} num2str(i)]);%,title([partid '-' afname],'Interpreter','none','Position',[-2,1,0])
% disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])
%  %   title(ax,[partid ' ' expcondname{expcond} ' trial ' num2str(i)])
%     print('-f3','-djpeg',[partid '_EMG' num2str(expcond) num2str(i)])

%emgsmaxvel_vals(i,:)=emgs_maxvel; %saving each emg value at max vel to
%% Main Cumulative Metria Figure


        p1=plot([xhand(:,1) xshoulder(:,1) xtrunk(:,1)],[xhand(:,2) xshoulder(:,2) xtrunk(:,2)],'LineWidth',2);
        hold on
         p2=plot(nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1)]),nanmean([xhand(1:10,2) xshoulder(1:10,2) xtrunk(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
%        p2=plot([xhand(10,2) xshoulder(10,2) xtrunk(10,2)],[xhand(10,2) xshoulder(10,2) xtrunk(10,2)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
        p3=plot([xhand(end,1) xshoulder(end,1) xtrunk(end,1)],[xhand(end,2) xshoulder(end,2) xtrunk(end,2)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');

        set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);


legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
axis 'equal'
xlabel('X'),ylabel('Y')
title([mfname expcond])

%% Calling COP Function
% ppsdata =data.pps;
% 
% [CoP1]= ComputeCOP(ppsdata);
%%
   %  pause   %pausing between each trial
    


end

hold off
%%
%avg_emg_maxvel =mean(emgsmaxvel_vals); % gives the EMG values at the maximum velocity across trials
avgmaxreach =mean(maxreach_current_trial)

end   
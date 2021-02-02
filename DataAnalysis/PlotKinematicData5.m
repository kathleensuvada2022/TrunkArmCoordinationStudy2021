function [emgval,allrdist] = PlotKinematicData5(partid,fname,expcond)
% KCS 11.29.20 changed inputs to function since no longer need separate
% files for metria and act3d

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


if exist([partid '/maxes/maxEMG.mat'])==2, 
    load([partid '/maxes/maxEMG']);
    %disp(maxEMG)
else
    disp('Computing Maximum Muscle EMGs. Make sure you check them')
    [maxEMG]=GetMaxMusAct2([partid '/maxes'],'MAXES','savedsetupKacey',0);
end


expcondname={'RT','R25','R50','UT','U25','U50'}; % KCS 11.29.20 Added conditions

load([partid '/' partid '_setup'])
% switch expcond
%     case {1,2,3} % Restrained
%         mfilepath='/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkrestrained/';          
%         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkrestrained/';
        filepath=[partid '/trials'];   % KCS 11.29.20 changes don't need separate folders now
%        
%         afilepath2 =[partid '/act3d/trunkrestrained/AllData']; % this is for the ACT 3D find reach start
%     otherwise
%         mfilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkfree/';
%         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkfree/';
%         filepath=[partid '/trials'];
    
%         afilepath2 =[partid '/act3d/trunkfree/AllData'];
% end
mtrials=setup.trial{expcond}; atrials=setup.trial{expcond};  % changes KCS 11.29.20
ntrials=length(mtrials);


% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);
 maxreach=zeros(ntrials,1); 
 emgstart = zeros(ntrials,14); 
% 
 figure(1),clf
% 
 emgval = zeros(ntrials,6);
allrdist = zeros(ntrials,1);


for i=1:length(mtrials)
    
%     if mtrials(i)<10
        %       000000                  % number that goes after 0s
        mfname=[fname  num2str(mtrials(i)) '.mat']; 
%     else
%         mfname=[fname num2str(mtrials(i)) '.hts'];
%     end
%     if atrials(i)<10
%         if (expcond==1 || expcond==2) && atrials(i)>6
            afname=[fname num2str(atrials(i)) '.mat'];
%             afname2=[act3dfname '0' num2str(atrials(i)) '_1_table']; % to make file name of the ACT 3D reaching file
%         else
%             afname=[act3dfname '0' num2str(atrials(i)) '_2_table_nidaq_emg.mat']; 
%             afname2=[act3dfname '0' num2str(atrials(i)) '_2_table.mat'];
%         end
%     else
%         if (expcond==1 || expcond==2)
%             afname=[act3dfname num2str(atrials(i)) '_1_table_nidaq_emg.mat'];
%             afname2=[act3dfname num2str(atrials(i)) '_1_table.mat'];
%         else
%             afname=[act3dfname num2str(atrials(i)) '_2_table_nidaq_emg.mat'];
%             afname2=[act3dfname num2str(atrials(i)) '_2_table.mat'];
%         end
%     end
    
      
    disp([mfname ' / ' afname])
    figure(2),clf
%     if strcmp(partid,'RTIS2001') && (mtrials(i)==8)
%         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
%     else
% 
% 
% % COMMENTED OUT BECAUSE NO BL DATA ( UNCOMMENT FOR RTIS2001) 3.13.20
% [xhand,xshoulder,xtrunk,maxreach,shtrdisp,maxreachtime]=GetHandShoulderTrunkPosition4(mfilepath,mfname,partid);
%     
%  maxreachtime
%end
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
%     set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
   
    % Plot EMGs
    load([filepath '/' afname]) % loading in the whole data file with EMGs
 

dat = data.daq{2};  % adding the line to load in EMG data via new data strctres for stroke 
% t =  data.daq{1};
    
%     % For Jules
%     dat = daqdata;
%     t = daqt;
    
emg=abs(detrend(dat(:,[1:16])))./maxEMG(ones(length(dat(:,[1:16])),1),:); % Detrend and rectify EMG
emg= emg(:,[1:2 5:8]); % for J leaving out ARM AND RAS
%     Computing the start of the reach 
    
%[dist,vel,ivel,time,t]=ComputeReachStart5(flpath,filename)
[dist,vel,time,rdist,t]= ComputeReachStart5(filepath,afname); 
    

    
%     switch partid
%         case 'RTIS2001'
%             if expcond==3 && i==1
%                 time(3)=t0(108);
%             end
%     end
 
%       index = ceil((time-.15)/.001);   % finding EMG time since different from ACT
% %     ibefore = timebefore/.001;
% %     ibefore = int32(ibefore);
% %     ivelmax = timevelmax/.001;
%     
% ivelmax = ivel;

time_emg_idx = time/.001;  %converting from time to indices of emgs

% emgstart(i,:) = emg(round(time_emg_idx(1)/.001),[1:14]); % KCS 11.30.20 . % emg val at start reach
     emgval(i,:)= emg(round(time_emg_idx(2)),[1:6]); %emg value at max vel
     allrdist(i)= rdist;  
% %   emgbefore = emg(ibefore,1:15)
%     emgmaxvel = emg(ivelmax,[1:2 5:16])
%     
    figure(3)
    %vdax=PlotEMGs5(emg,dist,vel,t0,t,fname)
    ax=PlotEMGs5(emg,dist,vel,time,t,afname);%,title([partid '-' afname],'Interpreter','none','Position',[-2,1,0 Commented out for Jules

%    ax = PlotAllEMGs(emg,t) KCS 11/29/20

%     PlotAllEMGs(emg,t)
%         disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])
    title(ax,[partid ' ' expcondname{expcond} ' trial ' num2str(i)])

    print('-f3','-djpeg',[partid '_EMG' num2str(expcond) num2str(i)])
    pause
end





% COMMENTED OUT FOR CONTROL BECAUSE NO HAND NOR GOOD BL DATA 
% figure(1)
% legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
% axis 'equal'
% axis([-0.3 0.2 -1.05 -0.15])
% xlabel('x(m)'),ylabel('y(m)')
% title(filepath)
%

% title('Reaching with trunk unrestrained - 5% Max SABD')
% title('Reaching with trunk unrestrained - table')
%  title('Reaching with trunk restrained - table')

% text(-0.28,-0.25,['SH TR DISP= ', num2str((shtrdisp))])
% text(-0.28,-0.35,['MAX REACH = ', num2str(max(maxreach))])
% text(-.28,-.45,['MFNAME = ', num2str((mfname))])
% 
% text(-0.28,-0.3,['STD of Max reach = ', num2str(std(maxreach))])
% print('-f3','-djpeg',[partid '_RT'])
% disp(maxreach)

end   
function [emgstart]= PlotKinematicData3(partid,metriafname,act3dfname,expcond)


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


if exist([partid '/maxes/maxEMG.mat'])==2, load([partid '/maxes/maxEMG']);disp(maxEMG)
else
    disp('Computing Maximum Muscle EMGs. Make sure you check them')
    [maxEMG]=GetMaxMusAct2([partid '/maxes'],'MAXES','savedsetupKacey',0);
end



load([partid '/' partid '_setup'])
switch expcond
    case {1,2} % Restrained
%         mfilepath='/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkrestrained/';          
%         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkrestrained/';
        mfilepath=[partid '/metria/trunkrestrained/'];
        afilepath=[partid '/act3d/trunkrestrained/'];
        afilepath2 =[partid '/act3d/trunkrestrained/AllData']; % this is for the ACT 3D find reach start
    otherwise
%         mfilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/metria/trunkfree/';
%         afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/act3d/trunkfree/';
        mfilepath=[partid '/metria/trunkfree/'];
        afilepath=[partid '/act3d/trunkfree/'];
        afilepath2 =[partid '/act3d/trunkfree/AllData'];
end
mtrials=setup.mtrial{expcond}; atrials=setup.atrial{expcond};
ntrials=length(mtrials);


% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);
maxreach=zeros(ntrials,1);

figure(1),clf




for i=1:length(mtrials)
    
    if mtrials(i)<10
        %       000000                  % number that goes after 0s
        mfname=[metriafname '0' num2str(mtrials(i)) '.hts']; 
    else
        mfname=[metriafname num2str(mtrials(i)) '.hts'];
    end
    if atrials(i)<10
        if (expcond==1 || expcond==2) && atrials(i)>6
            afname=[act3dfname '0' num2str(atrials(i)) '_1_table_nidaq_emg.mat'];
            afname2=[act3dfname '0' num2str(atrials(i)) '_1_table']; % to make file name of the ACT 3D reaching file
        else
            afname=[act3dfname '0' num2str(atrials(i)) '_2_table_nidaq_emg.mat']; 
            afname2=[act3dfname '0' num2str(atrials(i)) '_2_table.mat'];
        end
    else
        if (expcond==1 || expcond==2)
            afname=[act3dfname num2str(atrials(i)) '_1_table_nidaq_emg.mat'];
            afname2=[act3dfname num2str(atrials(i)) '_1_table.mat'];
        else
            afname=[act3dfname num2str(atrials(i)) '_2_table_nidaq_emg.mat'];
            afname2=[act3dfname num2str(atrials(i)) '_2_table.mat'];
        end
    end
    
      
    disp([mfname ' / ' afname])
    figure(2),clf
%     if strcmp(partid,'RTIS2001') && (mtrials(i)==8)
%         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
%     else


% COMMENTED OUT BECAUSE NO BL DATA ( UNCOMMENT FOR RTIS2001) 3.13.20
%         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderTrunkPosition(mfilepath,mfname,partid);
% %     end
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
%    
    % Plot EMGs
    load([afilepath afname])
    % adding the line below 11.12.19
    emg=abs(detrend(data(:,1:15)))./maxEMG(ones(length(data(:,1:15)),1),:); % Detrend and rectify EMG

    % Computing the start of the reach 
    [dist,vel,timestart]= ComputeReachStart(afilepath2,afname2)
    
    
    istart = ceil(timestart/.001);
%     ibefore = timebefore/.001;
%     ibefore = int32(ibefore);
%     ivelmax = timevelmax/.001;
    
      emgstart = zeros(ntrials,15);
      emgstart(i,:)= emg(istart,1:15);
    
    
    
%   emgbefore = emg(ibefore,1:15)
%     emgmaxvel = emg(ivelmax,1:15)
    
    figure(3)
    PlotEMGs(emg,dist,vel,timestart)%,title([partid '-' afname],'Interpreter','none','Position',[-2,1,0])
   
    % pause
end

end

%% COMMENTED OUT FOR CONTROL BECAUSE NO HAND NOR GOOD BL DATA 
% figure(1)
% legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
% axis 'equal'
% axis([-0.3 0.2 -1.05 -0.15])
% xlabel('x(m)'),ylabel('y(m)')
% % title(filepath)
%%

% title('Reaching with trunk unrestrained - 5% Max SABD')
%title('Reaching with trunk unrestrained - table')
 %title('Reaching with trunk restrained - table')
% 
% text(-0.28,-0.25,['Max reach = ', num2str(max(maxreach))])
% text(-0.28,-0.3,['STD of Max reach = ', num2str(std(maxreach))])
% print('-f3','-djpeg',[partid '_RT'])
%disp(maxreach)
   
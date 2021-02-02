function PlotKinematicData2(partid,metriafname,act3dfname,expcond)
% Function to plot Kacey's trunk and arm kinematic and EMG data during
% reaching at various load and trunk support conditions
% Usage:
% PlotKinematicData2(partid,metriafname,act3dfname,expcond)
% Inputs: partid: participant ID. Note that data should be saved in a folder named partid
%         metriafname: Metria file name before the trial # (e.g. 'RTIS2001_000000')
%         act3dfname: ACT-3D file name before the trial # (e.g. '2001tf_final_000000')
%         expcond: experimental condition (1-RT, 2-RL, 3-UT, 4-UL)
%         Data folder structure is hardcoded (metria/trunkrestrained,
%         metria/trunkfree, act3d/trunkrestrained, act3d/trunkfree)
% Outputs: * individual plots of reaching trajectories if pause is enabled
%          * overall plot of reaching trajectories for all trials in expcond
% 
% Examples:
% RT - PlotKinematicData2new(partid,'RTIS2001_000000','Target_',1)
% UT - PlotKinematicData2(partid,'2001tf_final_000000','Target_',3)
% UL - PlotKinematicData2(partid,'2001tf_final_000000','Target_',4)
%
if exist([partid '/maxes/maxEMG.mat'])==2
    load([partid '/maxes/maxEMG']); disp(maxEMG)
else
    disp('Computing Maximum Muscle EMGs. Make sure you check them')
%     maxEMG=GetMaxMusAct2([partid '/maxes'],'MAXES','savedsetupKacey','RTIS2001',0);
    maxEMG=GetMaxMusAct2([partid '/maxes'],'MAXES','savedsetupKacey',partid,1);
end

load([partid '/' partid '_setup'])

switch expcond
    case {1,2} % Restrained
        mfilepath=[partid '/metria/trunkrestrained/'];
        afilepath=[partid '/act3d/trunkrestrained/'];
    otherwise
        mfilepath=[partid '/metria/trunkfree/'];
        afilepath=[partid '/act3d/trunkfree/'];
end
mtrials=setup.mtrial{expcond}; atrials=setup.atrial{expcond};
ntrials=length(mtrials);
% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);
maxreach=zeros(ntrials,1);
shtrdisp=zeros(ntrials,2);
figure(1),clf
for i=1:length(mtrials)
    if mtrials(i)<10
        mfname=[metriafname '0' num2str(mtrials(i)) '.hts']; 
    else
        mfname=[metriafname num2str(mtrials(i)) '.hts'];
    end
    if strcmp(partid,'RTIS2001')
%         if atrials(i)<10
%             if (i==1 || i==2) && atrials(i)>6
%                 afname=[act3dfname '0' num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
%             else
%                 afname=[act3dfname '0' num2str(atrials(i)) '_2_table']; %_nidaq_emg.mat'];
%             end
%         else
%             if (i==1 || i==2)
%                 afname=[act3dfname num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
%             else
%                 afname=[act3dfname num2str(atrials(i)) '_2_table']; %_nidaq_emg.mat'];
%             end
%         end
        if any(atrials(i)==[0 1 2 3]),
            afname=[act3dfname '0' num2str(atrials(i)) '_2_table']; %_nidaq_emg.mat'];
        elseif atrials(i)<10
            afname=[act3dfname '0' num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
        else
            afname=[act3dfname num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
        end
    else
        if expcond==1 || expcond==2
            if atrials(i)<10
                afname=[act3dfname '0' num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
            else
                afname=[act3dfname num2str(atrials(i)) '_1_table']; %_nidaq_emg.mat'];
            end
        else
            if atrials(i)<10
                afname=[act3dfname '0' num2str(atrials(i)) '_2_table']; %_nidaq_emg.mat'];
            else
                afname=[act3dfname num2str(atrials(i)) '_2_table']; %_nidaq_emg.mat'];
            end
        end
    end
    disp([mfname ' / ' afname])
    figure(2),clf
    [xhand,xshoulder,xtrunk,maxreach(i),shtrdisp(i,:)]=GetHandShoulderPosition2(mfilepath,mfname,partid);
    figure(1)
    if i==1
        p1=plot([xhand(:,1) xshoulder(:,1) xtrunk(:,1)],-[xhand(:,3) xshoulder(:,3) xtrunk(:,3)],'LineWidth',2);
        hold on
%         p2=plot(nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshoulder(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
        p2=plot([xhand(1,1) xshoulder(1,1) xtrunk(1,1)],-[xhand(1,3) xshoulder(1,3) xtrunk(1,3)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
        p3=plot([xhand(end,1) xshoulder(end,1) xtrunk(end,1)],-[xhand(end,3) xshoulder(end,3) xtrunk(end,3)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
    else
        p1=plot([xhand(:,1) xshoulder(:,1) xtrunk(:,1)],-[xhand(:,3) xshoulder(:,3) xtrunk(:,3)],'LineWidth',2);
%         hold on
%         p2=plot(nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshoulder(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
        p2=plot([xhand(1,1) xshoulder(1,1) xtrunk(1,1)],-[xhand(1,3) xshoulder(1,3) xtrunk(1,3)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
        p3=plot([xhand(end,1) xshoulder(end,1) xtrunk(end,1)],-[xhand(end,3) xshoulder(end,3) xtrunk(end,3)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
    end
    set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
    % Plot EMGs
    load([afilepath afname '_nidaq_emg.mat'])
    figure(3),PlotEMGs(data(:,1:15)),title([partid '-' afname],'Interpreter','none','Position',[-2,0.01,0])
    load([afilepath afname])
    xahand=cell2mat(trialData(16:17,2:end))'; %end effector - 3:4, fingertip - 16:17
    figure(4),plot(-xahand(:,1),-xahand(:,2),'LineWidth',2);
%     pause
end
figure(1)
legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southwest')
axis 'equal'
axis([-0.3 0.2 -1.05 -0.2])
xlabel('x(m)'),ylabel('y(m)')
% title(filepath)
% title('Reaching with trunk unrestrained - 5% Max SABD')
% title('Reaching with trunk unrestrained - table')
% title('Reaching with trunk restrained - table')
text(-0.28,-0.25,['Max reach = ', num2str(max(maxreach))])
disp([maxreach shtrdisp]*100)
disp([max(maxreach) std(maxreach)])
% disp(['Shoulder and trunk displacement = ', num2str(shtrdisp)])
% print('-f3','-djpeg',[partid '_RT'])
   
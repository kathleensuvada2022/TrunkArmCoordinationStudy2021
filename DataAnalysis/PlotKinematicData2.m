function PlotKinematicData2(partid,metriafname,act3dfname,expcond)
% expcond=1-RT, 2-RL, 3-UT, 4-UL
% 

% if exist([partid '/MAXES.mat'])==2, load([flpathmaxes '/MAXES']);disp(maxEMG)
% else
    disp('Computing Maximum Muscle EMGs. Make sure you check them')
%     maxEMG=GetMaxMusAct2(flpath,basename,setfname,partid,plotflag)
    [maxEMG]=GetMaxMusAct2([partid '/maxes'],'MAXES','savedsetupKacey','RTIS2001',0);
% end

load([partid '/' partid '_setup'])
switch expcond
    case {1,2} % Restrained
        mfilepath='/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002/metria/trunkrestrained/'; 
        
        afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002/act3d/trunkrestrained/';
    otherwise
        mfilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002/metria/trunkfree/';
        afilepath= '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002/act3d/trunkfree/';
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
        mfname=[metriafname '0' num2str(mtrials(i)) '.hts']; 
    else
        mfname=[metriafname num2str(mtrials(i)) '.hts'];
    end
    if atrials(i)<10
        if (expcond==1 || expcond==2) && atrials(i)>6
            afname=[act3dfname '0' num2str(atrials(i)) '_1_table_nidaq_emg.mat'];
        else
            afname=[act3dfname '0' num2str(atrials(i)) '_2_table_nidaq_emg.mat']; 
        end
    else
        if (expcond==1 || expcond==2)
            afname=[act3dfname num2str(atrials(i)) '_1_table_nidaq_emg.mat'];
        else
            afname=[act3dfname num2str(atrials(i)) '_2_table_nidaq_emg.mat'];
        end
    end
    disp([mfname ' / ' afname])
    figure(2),clf
    if strcmp(partid,'RTIS2002') && (mtrials(i)==8)
        [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
    else
        [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition2(mfilepath,mfname,partid);
    end
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
    load([afilepath afname])
    
    emgs = abs(detrend(data(:,1:15)))./maxEMG(ones(length(data(:,1:15)),1),:); % Detrend and rectify EMG

    figure(3),PlotEMGs(emgs),title([partid '-' afname],'Interpreter','none','Position',[-2,0.01,0])
    pause
end
figure(1)
legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
axis 'equal'
axis([-0.3 0.2 -1.05 -0.2])
xlabel('x(m)'),ylabel('y(m)')
% title(filepath)
% title('Reaching with trunk unrestrained - 5% Max SABD')
% title('Reaching with trunk unrestrained - table')
% title('Reaching with trunk restrained - table')
text(-0.28,-0.25,['Max reach = ', num2str(max(maxreach))])
text(-0.28,-0.3,['STD of Max reach = ', num2str(std(maxreach))])
% print('-f3','-djpeg',[partid '_RT'])
   
function PlotKinematicData(partid,filepath,filename,trials)
% filepath='RTIS2001\metria\trunkfree\';
% filename='2001tf_final_000000'; %01.hts';
% partid='RTIS2001';
% trials=1:11;
% 
% RT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkrestrained\','RTIS2001_000000',4:5);
% UT - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 9 10])
% UL - PlotKinematicData('RTIS2001','RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
%%
ntrials=length(trials);
% xhand=zeros(1000,ntrials*3);
% xshoulder=zeros(1000,ntrials*3);
% xtrunk=zeros(1000,ntrials*3);
maxreach=zeros(ntrials,1);
figure(3),clf
for i=1:length(trials)
    if trials(i)<10, fname=[filename '0' num2str(trials(i)) '.hts']; else fname=[filename num2str(trials(i)) '.hts'];end
    disp(fname)
    [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition2(filepath,fname,partid);
    figure(3)
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
    
%     pause
end
legend([p1' p2 p3],'Hand','Shoulder','Trunk','Home','Max Reach','Location','southeast')
axis 'equal'
axis([-0.3 0.2 -1.05 -0.2])
xlabel('x(m)'),ylabel('y(m)')
% title(filepath)
% title('Reaching with trunk unrestrained - 5% Max SABD')
% title('Reaching with trunk unrestrained - table')
% title('Reaching with trunk restrained - table')
text(-0.28,-0.25,['Max reach = ', num2str(max(maxreach))])
% print('-f3','-djpeg',[partid '_RT'])
   

% For Plotting Trunk Angle
function BarPlotandErr_3(RTANG,errRT,R25ANG,errR25,R50ANG,errR50,UTANG,errUT,U25ANG,errU25,U50ANG,errU50)

figure(1)
%%
p1 =errorbar([RTANG],[1],[errRT],'m','horizontal','LineWidth',2);
hold on
plot(RTANG, 1,'ro-')
p2 =errorbar([R25ANG],[3],[errR25],'c','horizontal','LineWidth',2);
plot(R25ANG, 3,'ro-')
p3 =errorbar([R50ANG],[5],[errR50],'g','horizontal','LineWidth',2);
plot(R50ANG, 5,'ro-')

p4 =errorbar([UTANG],[2],[errUT],'m','horizontal','LineWidth',2);
hold on
plot(UTANG, 2,'ro-')

p5 =errorbar([U25ANG],[4],[errU25],'c','horizontal','LineWidth',2);
plot(U25ANG, 4,'ro-')

p6 =errorbar([U50ANG],[6],[errU50],'g','horizontal','LineWidth',2);
plot(U50ANG, 6,'ro-')




ylim([0 6.2])
xlim([-15 15])
ax=gca;
 yticklabels({'', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;

xline(0,'k','Linewidth',1.5)
xlabel('Forward Flexion (deg)                          Back Extension (deg)')

 title('Trunk Sagittal Plane Angle: N = 4 Control Participants','FontSize',20)

 % ylabel('Trunk Displacement (%LL)','FontSize',16)
 legend( [p1 p2 p3],'Table','25%','50%','FontSize',16)
%%


end

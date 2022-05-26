function BarPlotandErr_3(RTANG,errRT,R25ANG,errR25,R50ANG,errR50,UTANG,errUT,U25ANG,errU25,U50ANG,errU50)

figure(1)
hold on
%%
p1 =errorbar([1 2],[RTTD,UTTD],[errRT errUT],'m','LineWidth',2);
hold on
p2=errorbar([3 4],[R25TD,U25TD],[errR25 errU25],'c','LineWidth',2);
p3=errorbar([5 6],[R50TD,U50TD],[errR50 errU50],'g','LineWidth',2);

xlim([0 6.25])
ax=gca;
xticklabels({' ', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;
ylim([-.2 35])
title('Trunk Displacement: N = 4 Control Participants','FontSize',20)
ylabel('Trunk Displacement (%LL)','FontSize',16)
legend( [p1 p2 p3],'Trunk Displacement Table','Trunk Displacement 25%','Trunk Displacement 50%','FontSize',16)
%%


end

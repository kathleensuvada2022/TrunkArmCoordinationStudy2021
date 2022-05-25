

function BarPlotandErr_1(RTRD,errRT,R25RD,errR25,R50RD,errR50,UTRD,errUT,U25RD,errU25,U50RD,errU50)

figure(1)
hold on
%%
p1 =errorbar([1 2],[RTRD,UTRD],[errRT errUT],'m','LineWidth',2);
hold on
p2=errorbar([3 4],[R25RD,U25RD],[errR25 errU25],'c','LineWidth',2);
p3=errorbar([5 6],[R50RD,U50RD],[errR50 errU50],'g','LineWidth',2);

xlim([0 6])
ax=gca;
xticklabels({' ', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;
ylim([0 101])
title('REACHING DISTANCE: N = 9 Stroke Participants','FontSize',20)
ylabel('Reaching Distance (%LL)','FontSize',16)
legend( [p1 p2 p3],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
%%


end


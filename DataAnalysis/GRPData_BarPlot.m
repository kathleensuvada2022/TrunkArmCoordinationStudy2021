

function GRPData_BarPlot()

figure(1)
hold on
%%
p1 =errorbar([1 2],[RTRD_total_mean,UTRD_total_mean],[RTRD_total_err UTRD_total_err],'m','LineWidth',2);
hold on
p2=errorbar([3 4],[R25RD_total_mean,U25RD_total_mean],[R25RD_total_err U25RD_total_err],'c','LineWidth',2);

p3=errorbar([5 6],[R50RD_total_mean,U50RD_total_mean],[R50RD_total_err U50RD_total_err],'g','LineWidth',2);
p1 = [1 RTRD];
p2 = [2 UTRD];
plot([ p1(1) p2(1)], [p1(2) p2(2)],'k','Linewidth',2);
hold on
p3 = [3 R25RD];
p4 = [4 U25RD];
plot([ p3(1) p4(1)], [p3(2) p4(2)],'k','Linewidth',2);

p5 = [5 R50RD];
p6 = [6 U50RD];
plot([ p5(1) p6(1)], [p5(2) p6(2)],'k','Linewidth',2);


xlim([0 6])
ax=gca;
xticklabels({' ', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;
ylim([0 105])
title('REACHING DISTANCE: N = 4 Controls','FontSize',20)
ylabel('Reaching Distance (%LL)','FontSize',16)
% legend( 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
%%


end


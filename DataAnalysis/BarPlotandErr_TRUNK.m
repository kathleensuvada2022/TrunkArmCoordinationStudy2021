

function BarPlotandErr_TRUNK(RTTD,R25TD,R50TD,UTTD,U25TD,U50TD,RTTD_total_mean,RTTD_total_err,UTTD_total_mean,UTTD_total_err,R25TD_total_mean,R25TD_total_err,U25TD_total_mean,U25TD_total_err,R50TD_total_mean,R50TD_total_err,U50TD_total_mean,U50TD_total_err)

figure(1)
hold on
%%
p1 =errorbar([1 2],[RTTD_total_mean,UTTD_total_mean],[RTTD_total_err UTTD_total_err],'m','LineWidth',2);
hold on
p2=errorbar([3 4],[R25TD_total_mean,U25TD_total_mean],[R25TD_total_err U25TD_total_err],'c','LineWidth',2);

p3=errorbar([5 6],[R50TD_total_mean,U50TD_total_mean],[R50TD_total_err U50TD_total_err],'g','LineWidth',2);
p1 = [1 RTTD];
p2 = [2 UTTD];
plot([ p1(1) p2(1)], [p1(2) p2(2)],'k','Linewidth',2);
hold on
p3 = [3 R25TD];
p4 = [4 U25TD];
plot([ p3(1) p4(1)], [p3(2) p4(2)],'k','Linewidth',2);

p5 = [5 R50TD];
p6 = [6 U50TD];
plot([ p5(1) p6(1)], [p5(2) p6(2)],'k','Linewidth',2);


xlim([0 6])
ax=gca;
xticklabels({' ', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;
ylim([0 10])
title('Trunk Displacement: N = 4 Controls','FontSize',20)
ylabel('Trunk Displacement(%LL)','FontSize',16)
% legend( 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
%%


end


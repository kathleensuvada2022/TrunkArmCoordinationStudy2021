
function BarPlotandErr_TrnkANG(RT_ANG,R25_ANG,R50_ANG,UT_ANG,U25_ANG,U50_ANG,RTANG_total_mean,RTANG_total_err,UTANG_total_mean,UTANG_total_err,R25ANG_total_mean,R25ANG_total_err,U25ANG_total_mean,U25ANG_total_err,R50ANG_total_mean,R50ANG_total_err,U50ANG_total_mean,U50ANG_total_err)

figure(1)
hold on
%%
p1 =errorbar([1 2],[RTANG_total_mean,UTANG_total_mean],[RTANG_total_err UTANG_total_err],'m','LineWidth',2);
hold on
p2=errorbar([3 4],[R25ANG_total_mean,U25ANG_total_mean],[R25ANG_total_err U25ANG_total_err],'c','LineWidth',2);

p3=errorbar([5 6],[R50ANG_total_mean,U50ANG_total_mean],[R50ANG_total_err U50ANG_total_err],'g','LineWidth',2);

p1 = [1 RT_ANG];
p2 = [2 UT_ANG];
plot([ p1(1) p2(1)], [p1(2) p2(2)],'k','Linewidth',2);
hold on
p3 = [3 R25_ANG];
p4 = [4 U25_ANG];
plot([ p3(1) p4(1)], [p3(2) p4(2)],'k','Linewidth',2);

p5 = [5 R50_ANG];
p6 = [6 U50_ANG];
plot([ p5(1) p6(1)], [p5(2) p6(2)],'k','Linewidth',2);

yline(0,'Color','r')
xlim([0 6])
ax=gca;
xticklabels({' ', 'Table- Restrained', 'Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained' ,'50%- Unrestrained'})
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 15;
ylim([-15 15])
title('Change in Trunk Angle: N = 9  Stroke (Non-Paretic)','FontSize',20)
ylabel('Flexion                      Extension','FontSize',20)

% legend( 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
%%


end
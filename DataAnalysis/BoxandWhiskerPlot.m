%% Box and Whisker plot 

%% Stroke Data
RT = [1.018 .819 .984 .843 .820 .988 .872 1.010];
R25 = [.911 .724 .946 .811 .748 .981 .846 .939];
R50 = [.896 .716 .953 .805 .746 .975 .851 .923];

UT = [.983 .821 .947 .851 .818 .977 .843 1.004];
U25= [.822 .708 .946 .777 .755 .908 .804 .918];
U50 = [.823 .730 .930 .785 .749 1.006 .806 .906];
%% Trunk Restrained
R = [ RT; R25 ; R50]';
boxchart(R)
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25% MVT','50% MVT'})
hold on
U = [ UT; U25 ; U50]';
boxchart(U)
title('Effect of Trunk Restraint and Limb Loading - Stroke', 'FontSize',24);
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25% MVT','50% MVT'})
legend('Trunk Restrained', 'Trunk Unrestrained','FontSize',16)
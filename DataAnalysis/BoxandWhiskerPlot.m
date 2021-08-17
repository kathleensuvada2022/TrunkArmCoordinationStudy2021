%% Box and Whisker plot 

%KINEMATIC DATA
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

%% Kinetic Data RTIS2002

%RT
 Deltax = [-0.0051  -0.0142 -0.0119 -0.0057 -0.0136 -0.0081 -0.0114  -0.0100 -0.0112  -0.0119];
 
 Deltay=[ -0.0011 0.0014 -3.6781e-04 -4.5565e-04 -7.0958e-04 -0.0021 -0.0021   3.9281e-04  -0.0023  -0.0016];
 
 Delta = [Deltax; Deltay]';
 
 %UT
 Deltax_2 = [-0.0017   -0.0013  -0.0010  -0.0027 -8.2474e-04   -0.0014 -0.0023  -0.0043  1.4471e-04 -0.0011  -0.0020  -0.0059   -0.0049];
 Deltay_2 = [-0.0095 -0.0013 -9.2311e-04  -9.1233e-04   -0.0014 -8.9894e-04 -0.0017 -0.0028   -0.0029 -0.0016    0.0013   0.0166  0.0081];
 Delta_2 = [Deltax_2;Deltay_2]';
 
 boxchart(Delta)
 hold on
 boxchart(Delta_2)
 legend('Trunk Restrained','Trunk Unrestrained','FontSize',16)
 ylabel('Position (cm)','FontSize',16)

xlabel('$\Delta$ COP','Interpreter','latex','FontSize',16)
xticklabels({'X',' Y'})
title('COP Tracking- Stroke (severe)', 'FontSize',24)

 
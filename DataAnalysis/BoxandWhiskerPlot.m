%% Box and Whisker plot 

%KINEMATIC DATA
%% Stroke Data
RTP = [1.018 .819 .984 .843 .820 .988 .872 1.010];
R25P = [.911 .724 .946 .811 .748 .981 .846 .939];
R50P = [.896 .716 .953 .805 .746 .975 .851 .923];

UTP = [.983 .821 .947 .851 .818 .977 .843 1.004];
U25P= [.822 .708 .946 .777 .755 .908 .804 .918];
U50P = [.823 .730 .930 .785 .749 1.006 .806 .906];

M = [ RT;UT; R25 ;U25; R50;U50]';
boxchart(M)
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
%U = [ UT; U25 ; U50]';
%boxchart(U)
title('Effect of Trunk Restraint and Limb Loading - Stroke', 'FontSize',24);
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Restrained Table','Unrestrained Table','Restrained 25%','Unrestrained 25%','Restrained 50%','Unrestrained 50%'})
%legend('Trunk Restrained', 'Trunk Unrestrained','FontSize',16)
%% Stroke Non Paretic 

RT = [.926 .969 .926];
R25= [.909 .970 .916];
R50= [.916 .970 .914];

UT = [.913 .963 .921];
U25 = [.927 .956 .910];
U50= [.930 .951 .910];


M1 = [RTP; UTP; R25P; U25P; R50P; U50P]'; %Paretic arm matrix

M2 = [RT; UT; R25; U25; R50; U50]' ; % non-paretic arm matrix 

boxchart(M1)
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
%U = [ UT; U25 ; U50]';
%boxchart(U)
title('Effect of Trunk Restraint and Limb Loading - Stroke', 'FontSize',24);
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Restrained Table','Unrestrained Table','Restrained 25%','Unrestrained 25%','Restrained 50%','Unrestrained 50%'})
legend('Paretic', 'Non-Paretic','FontSize',16)
hold on
boxchart(M2)
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
%U = [ UT; U25 ; U50]';
%boxchart(U)
% title('Effect of Trunk Restraint and Limb Loading - Non-Paretic', 'FontSize',24);
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Restrained Table','Unrestrained Table','Restrained 25%','Unrestrained 25%','Restrained 50%','Unrestrained 50%'})
%legend('Trunk Restrained', 'Trunk Unrestrained','FontSize',16)




%% Controls
RT = [.896 1.010];
R25 = [.920 .994];
R50 = [.918 .982];

UT = [.851 .955];
U25 = [.911 .949];
U50 = [.902 .957];
M2 = [ RT;UT; R25 ;U25; R50;U50]';

boxchart(M2)
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Restrained Table','Unrestrained Table','Restrained 25%','Unrestrained 25%','Restrained 50%','Unrestrained 50%'})
title('Effect of Trunk Restraint and Limb Loading - Controls', 'FontSize',24);





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

 
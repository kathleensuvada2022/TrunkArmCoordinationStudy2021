%% Box and Whisker plots 
% For stroke participants 2021. Used MRS training day 2021 %updated for
% NRSA 2021
%% Stroke Data - updated for AHA RTIS2002 RITS2003 RTIS2006

% Reaching Distance
figure(1)
RTP = [.74 0.94 0.78];
R25P = [0.69 0.92 0.75];
R50P = [0.67 0.92 0.74];

UTP = [0.80 0.89 0.79];
U25P= [0.66 0.91 0.71];
U50P = [0.66 0.90 0.72];

R = [ RTP; R25P ; R50P;]';
MedR = median(R);
h1= boxchart(R)
hold on
plot(MedR,'ro-')
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
U = [ UTP; U25P ; U50P]';
MedU=median(U);
h2= boxchart(U)
plot(MedU,'ro-')
ylim([.5 1])
title('Effect of Trunk Restraint and Limb Loading - Paretic Limb (N=3)', 'FontSize',18);
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25%','50%'})
legend([h1 h2],'Trunk Restrained','Trunk Unrestrained','FontSize',16)

%% Shoudler Displacement NRSA 2021

%RTIS 2002, RTIS 2003, RTIS2006
LL_02 =595;
LL_03 = 601;
LL_06= 639;

figure(1)
RTP = [39.29/LL_02*100 67.80/LL_03*100 45.37/LL_06*100];
R25P = [22.72/LL_02*100 32.60/LL_03*100 19.03/LL_06*100];
R50P = [26.48/LL_02*100 38.11/LL_03*100 10.72/LL_06*100];

UTP = [62.47/LL_02*100 69.15/LL_03*100 78.03/LL_06*100];
U25P= [46.71/LL_02*100 40.08/LL_03*100 48.63/LL_06*100];
U50P = [37.80/LL_02*100 44.88/LL_03*100 37.90/LL_06*100];

R = [ RTP; R25P ; R50P;]';
MedR = median(R);
h1= boxchart(R)
hold on
plot(MedR,'ro-')
ylabel('Shoulder Displacement (% Limb Length)', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
U = [ UTP; U25P ; U50P]';
MedU=median(U);
h2= boxchart(U)
plot(MedU,'ro-')
 ylim([0 20])
title('Effect of Trunk Restraint and Limb Loading - Shoulder Disp. (N=3)', 'FontSize',18);
ylabel('Shoulder Disp', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25%','50%'})
legend([h1 h2],'Trunk Restrained','Trunk Unrestrained','FontSize',16)




%  AHA RTIS2002 RITS2003 RTIS2006
%% Reaching Excursion
figure(2)
RTP = [0.842245042 1.01166072 0.911637559];
R25P = [0.687868571 0.927038028 0.829162285];
R50P = [0.684690588 1.011335275 0.804487324];

UTP = [0.891698151 1.028576539 0.959637559];
U25P= [0.707986891 0.993236273 0.859069327];
U50P = [0.716777143 1.001235441 0.846680282];

R = [ RTP; R25P ; R50P;]';
MedR = median(R);
h1= boxchart(R)
hold on
plot(MedR,'ro-')
ylabel('Reaching Excursion', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
U = [ UTP; U25P ; U50P]';
MedU=median(U);
h2= boxchart(U)
plot(MedU,'ro-')
ylim([.5 1.1])
title('Effect of Trunk Restraint and Limb Loading - Paretic Limb (N=3)', 'FontSize',18);
ylabel('Reaching Excursion', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25%','50%'})
legend([h1 h2],'Trunk Restrained','Trunk Unrestrained','FontSize',16)
%%

% Stroke Non Paretic 
%Reaching Distance

figure(3)
RT = [0.920611597 0.960898502 0.910636463];
R25= [0.909067059 0.969225458 0.913200782];
R50= [0.915677647 0.969527953 0.907053678];

UT = [0.900563361 0.954872379 0.90760579];
U25 = [0.925333445 0.953401498 0.907899374];
U50= [0.92486605 0.949664559 0.903702504];

R = [ RT; R25 ; R50;]';
MedR = median(R);
h1=boxchart(R);
hold on
h2=boxchart(U);
legend([h1 h2],'Trunk Restrained','Trunk Unrestrained','FontSize',16)
plot(MedR,'ro-')
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
U = [ UT; U25 ; U50]';
MedU=median(U);
plot(MedU,'ro-')
title('Effect of Trunk Restraint and Limb Loading - Non-Paretic Limb (N=3)', 'FontSize',24);
ylim([.5 1.1])
ylabel('Reaching Distance', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25%','50%'})
%%
%Hand Excursion

figure(4)
RT = [1.010042185 1.116254077 1.013588889];
R25= [0.959835294 1.107375541 0.984997653];
R50= [0.968695126 1.075560067 0.98908169];

UT = [1.040585042 1.056542928 0.999543349];
U25 = [1.074074622 1.071574043 0.960309233];
U50= [1.062279496 1.065437604 0.954253052];

R = [ RT; R25 ; R50;]';
MedR = median(R);
h1=boxchart(R);
hold on
h2=boxchart(U);
legend([h1 h2],'Trunk Restrained','Trunk Unrestrained','FontSize',16)
plot(MedR,'ro-')
ylabel('Hand Excursion', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
U = [ UT; U25 ; U50]';
MedU=median(U);
plot(MedU,'ro-')
title('Effect of Trunk Restraint and Limb Loading - Non-Paretic Limb (N=3)', 'FontSize',24);
ylim([.5 1.1])
ylabel('Hand Excursion', 'FontSize' , 16);
xlabel('Limb Loading', 'FontSize' , 16);
xticklabels({'Table','25%','50%'})

%%
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
% RT = [.896 1.010];
% R25 = [.920 .994];
% R50 = [.918 .982];
% 
% UT = [.851 .955];
% U25 = [.911 .949];
% U50 = [.902 .957];
% M2 = [ RT;UT; R25 ;U25; R50;U50]';
% 
% boxchart(M2)
% ylabel('Reaching Distance', 'FontSize' , 16);
% xlabel('Limb Loading', 'FontSize' , 16);
% xticklabels({'Restrained Table','Unrestrained Table','Restrained 25%','Unrestrained 25%','Restrained 50%','Unrestrained 50%'})
% title('Effect of Trunk Restraint and Limb Loading - Controls', 'FontSize',24);
% 
% 
% 
% 
% 
% %% Kinetic Data RTIS2002
% 
% %RT
%  Deltax = [-0.0051  -0.0142 -0.0119 -0.0057 -0.0136 -0.0081 -0.0114  -0.0100 -0.0112  -0.0119];
%  
%  Deltay=[ -0.0011 0.0014 -3.6781e-04 -4.5565e-04 -7.0958e-04 -0.0021 -0.0021   3.9281e-04  -0.0023  -0.0016];
%  
%  Delta = [Deltax; Deltay]';
%  
%  %UT
%  Deltax_2 = [-0.0017   -0.0013  -0.0010  -0.0027 -8.2474e-04   -0.0014 -0.0023  -0.0043  1.4471e-04 -0.0011  -0.0020  -0.0059   -0.0049];
%  Deltay_2 = [-0.0095 -0.0013 -9.2311e-04  -9.1233e-04   -0.0014 -8.9894e-04 -0.0017 -0.0028   -0.0029 -0.0016    0.0013   0.0166  0.0081];
%  Delta_2 = [Deltax_2;Deltay_2]';
%  
%  boxchart(Delta)
%  hold on
%  boxchart(Delta_2)
%  legend('Trunk Restrained','Trunk Unrestrained','FontSize',16)
%  ylabel('Position (cm)','FontSize',16)
% 
% xlabel('$\Delta$ COP','Interpreter','latex','FontSize',16)
% xticklabels({'X',' Y'})
% title('COP Tracking- Stroke (severe)', 'FontSize',24)
% 
%  
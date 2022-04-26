%% Stacked Bar Plots / Composition of Reach: Stroke

% K. SUVADA April 2022

%% RTIS 2001 - PARETIC

% RTIS2001 Averages - Paretic Arm
% TR,25R, 50R, TU, 25U, 50U
% Trunk, hand, Shoulder
RT = [38.23 2.62 7.12]; % Hand Trunk Shoulder
R25 = [16.89 2.76 2.07];
R50  =[ 17.70 2.69 2.42];
UT = [39.80 4.59 5.12]; 
U25 = [23.77 6.22 1.68];
U50 = [ 23.66 6.94 1.81];

y = [RT; UT; R25; U25;R50;U50];
%y = [38.22 2.62 7.12;16.89 2.76 2.07; 17.70 17 3.8; 5.9 24 3.8; 4.2 18 2.7; 5.26 24 3.8];
b1 = bar(y,'stacked')
hold on
plot(1,95,'ro-')
plot(2,89,'ro-')
p1 = plot([1 2],[95,89],'m','LineWidth',2)
plot(3,74,'ro-')
plot(4,67,'ro-')
p2= plot([3 4],[74,67],'c','LineWidth',2)
plot(5,72,'ro-')
plot(6,67,'ro-')
p3= plot([5 6],[72,67],'g','LineWidth',2)
hold on
horizontal = yline(50,'--') ; 

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1 horizontal],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2001-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])


%% RTIS 2002  PARETIC

% Trunk, hand, Shoulder
RT = [16.97 1.27 4.21]; % Hand Trunk Shoulder
R25 = [7.40 .79 1];
R50  =[7.42 .68 1.27];


UT = [16.68 4.60 3.83]; 
U25 = [4.63 3.39 1.12];
U50 = [4.02 2.07 .66];
RTRD = 72.55;
R25RD = 66.55;
R50RD = 65.56;
UTRD = 77.90;
U25RD = 64.02;
U50RD = 65.24;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2002-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])

%% RTIS2003 Paretic

% Trunk, hand, Shoulder
RT = [37.07 2.88 7.26]; % Hand Trunk Shoulder
R25 = [32.15 2.41 5.42];
R50  =[32.84 3.11 6.00];


UT = [37.37 1.35 8.66]; 
U25 = [34.58 3.77 5.84];
U50 = [36.14 3.46 5.71];
RTRD = 94.35;
R25RD = 90.92;
R50RD =92.00 ;
UTRD = 87.13;
U25RD = 89.02 ;
U50RD =87.54 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2003-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])


%% RTIS 2006 PARETIC


% Trunk, hand, Shoulder
RT = [16.99 2.05 6.23]; % Hand Trunk Shoulder
R25 = [13.23 1.35 2.46];
R50  =[10.33 .84 1.33];


UT = [17.80 4.93 6.47]; 
U25 = [12.72 4.31 3.34];
U50 = [11.71 3.28 3.28];
RTRD = 78.06;
R25RD = 74.93;
R50RD = 73.77;
UTRD = 79.59;
U25RD = 71.14 ;
U50RD = 71.59;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2006-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])


%% RTIS 2007 PARETIC
% Trunk, hand, Shoulder
RT = [15.99 2.50 6.94]; % Hand Trunk Shoulder
R25 = [3.85 .36 .84];
R50  =[3.26 .58 .73];


UT = [15.21 2.76 4.89]; 
U25 = [6.01 2.92 2.86];
U50 = [2.92 2.32 1.93];
RTRD = 82.71;
R25RD = 65.93 ;
R50RD = 65.82;
UTRD = 82.85;
U25RD = 67.68 ;
U50RD =65.21 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2007-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])
%% RTIS 2008 PARETIC
% Trunk, hand, Shoulder
RT = [29.48 .83 4.53]; % Hand Trunk Shoulder
R25 = [38 2.56 6.02];
R50  =[34.79 2.05 5.84];


UT = [35.39 3.87 5.95]; 
U25 = [37.86 4.86 7.35];
U50 = [39.17 4.62 5.12];
RTRD =99.20;
R25RD = 99.30 ;
R50RD = 99.52;
UTRD = 95.45;
U25RD = 93.56 ;
U50RD =94.19 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2008-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])

%% RTIS2009- Paretic
% Trunk, hand, Shoulder
RT = [34.88 1.62 7.58]; % Hand Trunk Shoulder
R25 = [24.20 .95 3.92];
R50  =[24.05 1.20 3.52];


UT = [33.59 2.58 6.78]; 
U25 = [26.97 3.12 5.46];
U50 = [24.14 2.95 5.47];
RTRD =82.89;
R25RD = 78.28 ;
R50RD = 78.36 ;
UTRD = 79.49;
U25RD = 74.81 ;
U50RD = 75.19 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2009-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])

%% RTIS2010 - Paretic 
% THink measured arm length might be off 2 cm  so just normalized so
% largest was 100% Limb Length

RT = [29.18/1.0389 1.01/1.0389 4.79/1.0389]; % Hand Trunk Shoulder
R25 = [26.81/1.0389 .84/1.0389 2.69/1.0389];
R50  =[25.57/1.0389 .50/1.0389 2.26/1.0389];


UT = [26.90/1.0389 .81/1.0389 4.26/1.0389]; 
U25 = [20.55/1.0389 2.32/1.0389 2.32/1.0389];
U50 = [25.79/1.0389 1.58/1.0389 2.57/1.0389];
RTRD =103.83/1.0389;
R25RD =  95.40/1.0389;
R50RD = 93.51/1.0389 ;
UTRD =103.89/1.0389;
U25RD =  89.90/1.0389;
U50RD =  91.48/1.0389;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2010-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 105])

%% RTIS2011 - Paretic

RT = [9.07 .21 .47]; % Hand Trunk Shoulder
R25 = [2.79 .28 .50];
R50  =[3.28 .26 .34];


UT = [7.80 1.22 .41]; 
U25 = [2.20 .84 .32];
U50 = [2.57 .84 .92];
RTRD =57.19;
R25RD = 50.17 ;
R50RD =45.39;
UTRD =53.41;
U25RD = 43.57 ;
U50RD =  42.81;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2011-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 60])
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RTIS2001 NonParetic


RT = [38.71 2.18 5.56]; % Hand Trunk Shoulder
R25 = [41.94 1.25 6];
R50  =[41.52 1.33 6.10];


UT = [41.43 3.23 6.70]; 
U25 = [46.15 2.64 9.31];
U50 = [45.70 3.53 8.86];

RTRD =93.42;
R25RD =95.73  ;
R50RD =95.37;
UTRD =91.72;
U25RD = 89.09 ;
U50RD = 88.46 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2001:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])
%% RTIS 2002 NonParetic

RT = [25.43 1.52 6.93]; % Hand Trunk Shoulder
R25 = [24.61 .63 4.89];
R50  =[24.40 .57 4.47];


UT = [19.76 3.13 9.35]; 
U25 = [24.39 2.78 11.55];
U50 = [23.33 2.43 11.44];

RTRD =94.15;
R25RD =94.94  ;
R50RD =93.50;
UTRD =93.08;
U25RD = 94.84 ;
U50RD =95.01 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2002:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])

%% RTIS 2003 Non-Paretic
RT = [43.64 1.93 13.53]; % Hand Trunk Shoulder
R25 = [44.70 1.54 11.59];
R50  =[41.85 1.61 10.46];


UT = [36.18 2.65 10.64]; 
U25 = [37.47 3.16 8.69];
U50 = [34.82 3.17 8.43];

RTRD =97.39;
R25RD = 98.69 ;
R50RD =96.85;
UTRD =96.03;
U25RD = 97.29 ;
U50RD =96.45 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2003:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])

%% RTIS2006 Non-Paretic
RT = [59.22 2.18 9.64]; % Hand Trunk Shoulder
R25 = [48.83 1.66 7.23];
R50  =[52.45 1.59 7.51];


UT = [64.79 1.03 8.55]; 
U25 = [54.05 1.53 5.08];
U50 = [54.74 1.73 5.29];

RTRD =100.64;
R25RD = 100.61 ;
R50RD =99.85;
UTRD =100.36;
U25RD =99.20  ;
U50RD =99.72 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2006:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 105])

%% RTIS2007 Non-Paretic
RT = [40.18 1.51 8.52]; % Hand Trunk Shoulder
R25 = [34.81 .79 5.13];
R50  =[35.54 .98 5.51];


UT = [38.18 1.61 5.90]; 
U25 = [32.50 3.11 6.25];
U50 = [33.69 3.61 6.50];

RTRD =90.28;
R25RD = 88.26  ;
R50RD =88.88;
UTRD =89.04;
U25RD = 88.40;
U50RD =88.28 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2007:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 105])

%% RTIS2008 Non-Paretic
RT = [33.28 1.43 4.76]; % Hand Trunk Shoulder
R25 = [40.42 2.56 5.11];
R50  =[35.16 1.70 3.18];


UT = [33.66 .88 2.21]; 
U25 = [37.64 3.76 2.42];
U50 = [43.52 3.72 2.49];

RTRD =97.25;
R25RD = 100.08 ;
R50RD =99.63;
UTRD =93.04;
U25RD =97.98 ;
U50RD =96.47 ;


y = [RT; UT; R25; U25;R50;U50];
b1 = bar(y,'stacked')
hold on
yline(50,'--')

plot(1,RTRD,'ro-')
plot(2,UTRD,'ro-')
p1 = plot([1 2],[RTRD,UTRD],'m','LineWidth',2)
plot(3,R25RD,'ro-')
plot(4,U25RD,'ro-')
p2= plot([3 4],[R25RD,U25RD],'c','LineWidth',2)
plot(5,R50RD,'ro-')
plot(6,U50RD,'ro-')
p3= plot([5 6],[R50RD,U50RD],'g','LineWidth',2)

%legend('Hand Contribution','Trunk Contribution','Shoulder Contribution',[p1 p2 p3], 'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','FontSize',16)
legend( [p1 p2 p3 b1],'Reaching Distance Table','Reaching Distance 25%','Reaching Distance 50%','Hand Contribution','Trunk Contribution','Shoulder Contribution','50% Limb Length','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach: RTIS2008:Non-Paretic Limb','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 105])
%% Stacked Bar plots 

% K. SUVADA April 2022

% Playing with idea of composition of reach.

%% RTIS 2001

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


%% RTIS 2002 

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


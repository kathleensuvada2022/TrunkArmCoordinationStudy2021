%% Stacked Bar plots 

% K. SUVADA April 2022

% Playing with idea of composition of reach. Based on RTIS2001 Paretic
% results.


% RTIS2001 Averages - Paretic Arm
% TR,25R, 50R, TU, 25U, 50U
% Trunk, hand, Shoulder
%y = [2.7 38 7.5; 5.8 17 3.8; 4.2 18 2.7; 4.8 40 5.4; 5.9 24 3.8; 5.26 24 3.8];

y = [2.7 38 7.5;4.8 40 5.4; 5.8 17 3.8; 5.9 24 3.8; 4.2 18 2.7; 5.26 24 3.8];
bar(y,'stacked')
hold on
plot(1,95,'ro-')
plot(2,89,'ro-')
plot([1 2],[95,89],'m','LineWidth',2)
plot(3,74,'ro-')
plot(4,67,'ro-')
plot([3 4],[74,67],'c','LineWidth',2)
plot(5,72,'ro-')
plot(6,67,'ro-')
plot([5 6],[72,67],'g','LineWidth',2)

legend('Trunk Contribution','Hand Contribution','Shoulder Contribution','FontSize',16)
ylabel('% Limb Length','FontSize',14)
title('Composition of Reach','FontSize',24)
xticklabels({'Table- Restrained','Table- Unrestrained','25%- Restrained','25%- Unrestrained','50%- Restrained','50%- Unrestrained','FontSize',16})
ylim([0 100])
%% ACT 3D Reaching Distance trunk restrained

%LOADING
%trials 23,24,25,29,32

%shoulder position for all trials
 shoulderx = 0.0869251009589711;
 shouldery = 0.404403749533378;
 shoulderz = -0.0828616048932728;

%trial 23
load('Target_23_1_table.mat')

x23 = cell2mat(trialData(3,2:353))*1000;
y23 = cell2mat(trialData(4,2:353))*1000;

%Reaching distance
reach23 = sqrt((x23-shoulderx).^2+(y23-shouldery).^2);

%Finding Max distance
maxdist23 = max(reach23); % same as end index 

%trial24 
load('Target_24_1_table.mat')

x24 = cell2mat(trialData(3,2:353))*1000;
y24 = cell2mat(trialData(4,2:353))*1000;

%trial25
load('Target_25_1_table.mat')

x25 = cell2mat(trialData(3,2:353))*1000;
y25 = cell2mat(trialData(4,2:353))*1000;

%trial29 
load('Target_29_1_table.mat')

x29 = cell2mat(trialData(3,2:353))*1000;
y29 = cell2mat(trialData(4,2:353))*1000;

%trial32
load('Target_32_1_table.mat')

x32 = cell2mat(trialData(3,2:353))*1000;
y32 = cell2mat(trialData(4,2:353))*1000;

figure(1)
plot(x23,-y23,'r','LineWidth',2)
hold on
plot(x24,-y24,'c','LineWidth',2)
plot(x25,-y25,'b','LineWidth',2)
plot(x29,-y29,'k','LineWidth',2)
plot(x32,-y32,'m','LineWidth',2)
title('Reaching Distance Weighted Trunk Restrained')
xlabel('Position in mm')
ylabel('Position in mm')


% Finding the max reaching distance












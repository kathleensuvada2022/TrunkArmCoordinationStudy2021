 % K. Suvada. Sept 2024. December 2025

% Script to run NMF analysis and remove zeros from matrix using internal
% Matlab function.

NMFMatrix_trial_updated= RTIS2001_COMBINEDPPAANDACCEL;
% Concatonate by hand the nonzero columns (zero columns are trials that
% were skipped with the kinematic data)

NumCols = size(NMFMatrix_trial_updated,2);

Zerocols = find(cell2mat(NMFMatrix_trial_updated(3,2:end)) == 0)+1; %Omit first col bc names of muscles

%% Removing the Columns of the Matrix that are 0 (skipped trials) and concatonating 

for i = 1: NumCols
    if i == 1

    NMFMatrix_trial_FINAL = NMFMatrix_trial_updated(:,i);
        
    elseif cell2mat(NMFMatrix_trial_updated(3,i)) == 0 

    else

    NMFMatrix_trial_FINAL = [NMFMatrix_trial_FINAL NMFMatrix_trial_updated(:,i)];

    end 
end

% Need to Omit the Names of the muscles and Trial Nums 
NNMF_Mat = cell2mat(NMFMatrix_trial_FINAL(3:end,2:end));



%% Running NMF on Reformatted Matrix

% From Matlab Help
% [W,H] = nnmf(A,K) factors the N-by-M matrix A into non-negative factors
% W (N-by-K) and H (K-by-M).

% W is the muscle weighting matrix and C is the Coefficient Matrix with how
% each module varies in time.Mods is the input of number of motor modules
% that we pick. 

Mods = 4;

[W,C] = nnmf(NNMF_Mat,Mods);


% Adding back the Muscle Names 

MuscleWeightingMatrix = [NMFMatrix_trial_FINAL(2:end,1) num2cell(W)];

% MuscleWeightingMatrix = [{'Mus'} {'Mod 1'} {'Mod 2'} ; MuscleWeightingMatrix];
MuscleWeightingMatrix = [{'Mus'} {'Mod 1'} {'Mod 2'} {'Mod 3'} {'Mod 4'}; MuscleWeightingMatrix];
%% Plotting Muscle Weighting with the given Modules 


Muscles = {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};
Mus = {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};
Mod1 = cell2mat(MuscleWeightingMatrix(2:end,2));
Mod2 = cell2mat(MuscleWeightingMatrix(2:end,3));
Mod3 = cell2mat(MuscleWeightingMatrix(2:end,4));
Mod4 = cell2mat(MuscleWeightingMatrix(2:end,5));
% Mod5 = cell2mat(MuscleWeightingMatrix(2:end,6));
%% 
figure()
x = 1:length(Muscles);

% Create bar plot for Mod1
subplot(1,4,1); 
bar(x, Mod1, 'FaceColor', [0 0.5 0.5]); 
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45); 
title('Module 1', 'FontSize', 20); 
xlabel('Muscles', 'FontSize', 16); 
ylabel('Module 1 Weightings', 'FontSize', 16); 
ylim([0 5])

% Create bar plot for Mod2
subplot(1,4,2); 
bar(x, Mod2, 'FaceColor', [0.5 0 0.5]); 
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45); 
title('Module 2', 'FontSize', 20);
xlabel('Muscles', 'FontSize', 16); 
ylabel('Module 2 Weightings', 'FontSize', 16); 
ylim([0 5])

% Create bar plot for Mod3
subplot(1,4,3); 
bar(x, Mod3, 'FaceColor', [0.6 0.8 0.2]); 
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
title('Module 3', 'FontSize', 20);
xlabel('Muscles', 'FontSize', 16); 
ylabel('Module 3 Weightings', 'FontSize', 16); 
ylim([0 5])

% Create bar plot for Mod4
subplot(1,4,4); 
bar(x, Mod4, 'FaceColor', [0.3 0.6 0.9]); 
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
title('Module 4', 'FontSize', 20);
xlabel('Muscles', 'FontSize', 16); 
ylabel('Module 4 Weightings', 'FontSize', 16); 
ylim([0 5])

% % Create bar plot for Mod5
% subplot(1,5,5); 
% bar(x, Mod5, 'FaceColor', [1 0.6 0.2]); 
% set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
% xtickangle(45);
% title('Module 5', 'FontSize', 20);
% xlabel('Muscles', 'FontSize', 16); 
% ylabel('Module 5 Weightings', 'FontSize', 16); 
% ylim([0 5])


%% Computing the Total VAF - Kacey's Old Version Don't USE

% Difference in the computed signal (W*C) from the input Data (NNMF_Mat)

% EMG_est = W*C; 
% 
%                   % Actual     % ESTimated
% DiffActualfromEst = NNMF_Mat - EMG_est;
% 
% VarDiff = var(DiffActualfromEst);
% 
% VarOriginalSig = var(NNMF_Mat);
% 
% VarRatio = VarDiff/VarOriginalSig;
% 
% % CHECK THIS DEFINITION 
% VAF_total = (1-VarRatio)*100

%% Computing VAF From Code From Hongchul *** USE!!!****
data = [];
data = NNMF_Mat;
nmus = size(data,1);

for s=1:nmus
nmf(s).nsyn=s; %The number of synergies
[nmf(s).W,nmf(s).C,nmf(s).err,nmf(s).stdev] = NNMF_stacie_May2013(data,s,1);
[nmf(s).VAFcond, nmf(s).VAFmus, nmf(s).VAF]=funur(data,nmf(s).W,nmf(s).C); %calculate VAF of reconstruction
nmf(s).RECON = nmf(s).W*nmf(s).C;
end

%% VAF as a function of the number of modules 


% Total VAF with error bars
figure(1)
% plot([nmf.VAF], 'Color', [0 0.5 0], 'LineWidth', 4) % Dark green color
errorbar(1:7,[nmf.VAF],[nmf.err],'Color', '#31a354','LineWidth',4)
% title(', 'FontSize', 45);
xlabel('Number of Modules', 'FontSize', 16); 
ylabel('% VAF', 'FontSize', 16); 
xlim([1 7])
ylim([80 100])
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20


% VAF Plot with Error Bars per muscle

VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end

figure(3)
errorbar(1:7,mean(VAFmus),std(VAFmus),'Color', '#dd1c77','LineWidth',3)
hold on
errorbar(1:7, mean(VAFmus), std(VAFmus), 'o', 'Color', '#c994c7' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
ylim([80 105])

%% Plotting the Modules for n = 3 modules and the Time Component

Mus= {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};
x = 1:length(Mus);


figure
% Weightings per Module
subplot(3,2,1)
title('Module 1','Fontsize',16)
hold on
bar(nmf(3).W(:,1))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
subplot(3,2,3)
hold on
bar(nmf(3).W(:,2))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
title('Module 2','Fontsize',16)
subplot(3,2,5)
bar(nmf(3).W(:,end))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
hold on
title('Module 3','Fontsize',16)


%Time Component Per Module
% subplot(3,2,2)
% plot(nmf(3).C(1,:),'Linewidth',2)
% xlabel('Trials','FontSize',16)
% ylabel('Contribution to Module 1','FontSize',16)
% subplot(3,2,4)
% plot(nmf(3).C(2,:),'Linewidth',2)
% xlabel('Trials','FontSize',16)
% ylabel('Contribution to Module 2','FontSize',16)
% subplot(3,2,6)
% plot(nmf(3).C(end,:),'Linewidth',2)
% xlabel('Trials','FontSize',16)
% ylabel('Contribution to Module 3','FontSize',16)


plot(nmf(4).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 4','FontSize',16)


%Time Component Per Module- box plots
subplot(3,2,2)
plot(nmf(4).C(1,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 1','FontSize',16)
subplot(3,2,4)
plot(nmf(3).C(2,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 2','FontSize',16)
subplot(3,2,6)
plot(nmf(3).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 3','FontSize',16)


%% Separating by Condition

%% RTIS2001_P : for all conditions ( autmate this so you can search for the
% conditions and it does it on it's own for all participants)

% For Combined Matrix with 2 time points 
% columns 1-51 are the accel phase 

% Choosing for when 4 Modules 
Modules_CMatrices_4Modules = nmf(4).C;

%For accel phase

Mod1_TR_A= Modules_CMatrices_4Modules(1,1:7)'; % 7x1
Mod1_25R_A = Modules_CMatrices_4Modules(1,8:17)'; % 10x1
Mod1_50R_A = Modules_CMatrices_4Modules(1,18:27)';% 10x1

Mod1_TU_A= Modules_CMatrices_4Modules(1,28:32)'; % 5x1
Mod1_25U_A = Modules_CMatrices_4Modules(1,33:42)'; % 10x1
Mod1_50U_A = Modules_CMatrices_4Modules(1,43:51)'; %9x1


% For RTIS2001_P - NEED TO ADD BACK IN NANS

% !!!!!! KACEY- YOU NEED TO ADD THIS BACK IN AND AGAIN YOU NEED TO AUTOMATE THIS
% SO IT'S NOT ALL MANUAL !!!!!!!!!!!!!!!!!

Mod1_TR_A = [Mod1_TR_A;NaN;NaN;NaN]; 
Mod1_TU_A = [Mod1_TU_A;NaN;NaN;NaN;NaN;NaN]; 
Mod1_50U_A = [Mod1_50U_A;NaN]; 

%% For ppa phase
Mod1_TR_P= Modules_CMatrices_4Modules(1,52:58)'; % 7x1
Mod1_25R_P = Modules_CMatrices_4Modules(1,59:68)'; % 10x1
Mod1_50R_P= Modules_CMatrices_4Modules(1,69:78)';% 10x1

Mod1_TU_P= Modules_CMatrices_4Modules(1,79:83)'; % 5x1
Mod1_25U_P = Modules_CMatrices_4Modules(1,84:93)'; % 10x1
Mod1_50U_P = Modules_CMatrices_4Modules(1,94:102)'; %9x1


% For RTIS2001_P - NEED TO ADD BACK IN NANS

% !!!!!! KACEY- YOU NEED TO ADD THIS BACK IN AND AGAIN YOU NEED TO AUTOMATE THIS
% SO IT'S NOT ALL MANUAL !!!!!!!!!!!!!!!!!

Mod1_TR_P = [Mod1_TR_P;NaN;NaN;NaN]; 
Mod1_TU_P = [Mod1_TU_P;NaN;NaN;NaN;NaN;NaN]; 
Mod1_50U_P = [Mod1_50U_P;NaN]; 

%% RTIS2011
% Choosing for when 2 Modules 
Modules_CMatrices_2Modules = nmf(2).C;


Mod1_TR= Modules_CMatrices_2Modules(1,1:12)'; % 12x1
Mod1_25R = Modules_CMatrices_2Modules(1,13:24)'; % 12x1
Mod1_50R = Modules_CMatrices_2Modules(1,25:31)';% 7x1

Mod1_TU= Modules_CMatrices_2Modules(1,32:39)'; % 8x1
Mod1_25U = Modules_CMatrices_2Modules(1,40:49)'; % 10x1
Mod1_50U = Modules_CMatrices_2Modules(1,50:60)'; %11x1


Mod1_50R = [Mod1_50R;NaN;NaN;NaN;NaN;NaN]; 
Mod1_TU = [Mod1_TU;NaN;NaN;NaN;NaN]; 
Mod1_25U = [Mod1_25U;NaN;NaN]; 
Mod1_50U = [Mod1_50U;NaN]; 


%% RTIS1003 : 
% for all conditions ( autmate this so you can search for the
% conditions and it does it on it's own for all participants)

% Choosing for when 4 Modules 
Modules_CMatrices_4Modules = nmf(4).C;


Mod1_TR= Modules_CMatrices_4Modules(1,1:4)';% 4x1
Mod1_25R = Modules_CMatrices_4Modules(1,5:7)'; %3x1
Mod1_50R = Modules_CMatrices_4Modules(1,8:12)'; %5x1

Mod1_TU= Modules_CMatrices_4Modules(1,13:15)'; % 3x1
Mod1_25U = Modules_CMatrices_4Modules(1,16:18)'; %3x1
Mod1_50U = Modules_CMatrices_4Modules(1,19:21)'; %3x1

% Get Sizes of all Conditions so can Concatonate 


% For RTIS1003

Mod1_TR = [Mod1_TR;NaN]; 
Mod1_25R = [Mod1_25R;NaN;NaN]; 
Mod1_TU = [Mod1_TU;NaN;NaN]; 
Mod1_25U = [Mod1_25U;NaN;NaN]; 
Mod1_50U = [Mod1_50U;NaN;NaN]; 

%% RTIS1005
Modules_CMatrices_4Modules = nmf(4).C;

Mod1_TR= Modules_CMatrices_4Modules(1,1:6)'; 
size(Mod1_TR)
Mod1_25R = Modules_CMatrices_4Modules(1,7:15)';
size(Mod1_25R)
Mod1_50R = Modules_CMatrices_4Modules(1,16:24)'; 
size(Mod1_50R)
Mod1_TU= Modules_CMatrices_4Modules(1,25:30)'; 
size(Mod1_TU)
Mod1_25U = Modules_CMatrices_4Modules(1,31:37)'; 
size(Mod1_25U)
Mod1_50U = Modules_CMatrices_4Modules(1,38:43)'; 
size(Mod1_50U)

% Get Sizes of all Conditions so can Concatonate 


% For RTIS1005

Mod1_TR = [Mod1_TR;NaN;NaN;NaN]; 
Mod1_TU = [Mod1_TU;NaN;NaN;NaN]; 
Mod1_25U = [Mod1_25U;NaN;NaN]; 
Mod1_50U = [Mod1_50U;NaN;NaN;NaN]; 
%% Combined Accel and PPA
Mod1_colsasConditions = [Mod1_TR_A Mod1_25R_A Mod1_50R_A Mod1_TU_A Mod1_25U_A Mod1_50U_A Mod1_TR_P Mod1_25R_P Mod1_50R_P Mod1_TU_P Mod1_25U_P Mod1_50U_P];

%% Just accel
Mod1_colsasConditions = [Mod1_TR_A Mod1_25R_A Mod1_50R_A Mod1_TU_A Mod1_25U_A Mod1_50U_A];

%% Module2


%% RTIS2001
% Choosing for when 4 Modules 
Modules_CMatrices_4Modules = nmf(4).C;

%For accel phase

Mod2_TR_A= Modules_CMatrices_4Modules(2,1:7)'; % 7x1
Mod2_25R_A = Modules_CMatrices_4Modules(2,8:17)'; % 10x1
Mod2_50R_A = Modules_CMatrices_4Modules(2,18:27)';% 10x1

Mod2_TU_A= Modules_CMatrices_4Modules(2,28:32)'; % 5x1
Mod2_25U_A = Modules_CMatrices_4Modules(2,33:42)'; % 10x1
Mod2_50U_A = Modules_CMatrices_4Modules(2,43:51)'; %9x1


% For RTIS2001_P - NEED TO ADD BACK IN NANS


Mod2_TR_A = [Mod2_TR_A;NaN;NaN;NaN]; 
Mod2_TU_A = [Mod2_TU_A;NaN;NaN;NaN;NaN;NaN]; 
Mod2_50U_A = [Mod2_50U_A;NaN]; 

% For ppa phase
Mod2_TR_P= Modules_CMatrices_4Modules(2,52:58)'; % 7x1
Mod2_25R_P = Modules_CMatrices_4Modules(2,59:68)'; % 10x1
Mod2_50R_P= Modules_CMatrices_4Modules(2,69:78)';% 10x1

Mod2_TU_P= Modules_CMatrices_4Modules(2,79:83)'; % 5x1
Mod2_25U_P = Modules_CMatrices_4Modules(2,84:93)'; % 10x1
Mod2_50U_P = Modules_CMatrices_4Modules(2,94:102)'; %9x1


Mod2_TR_P = [Mod2_TR_P;NaN;NaN;NaN]; 
Mod2_TU_P = [Mod2_TU_P;NaN;NaN;NaN;NaN;NaN]; 
Mod2_50U_P = [Mod2_50U_P;NaN]; 
%% RTIS2011

Mod2_TR= Modules_CMatrices_2Modules(2,1:12)'; % 12x1
Mod2_25R = Modules_CMatrices_2Modules(2,13:24)'; % 12x1
Mod2_50R = Modules_CMatrices_2Modules(2,25:31)';% 7x1

Mod2_TU= Modules_CMatrices_2Modules(2,32:39)'; % 8x1
Mod2_25U = Modules_CMatrices_2Modules(2,40:49)'; % 10x1
Mod2_50U = Modules_CMatrices_2Modules(2,50:60)'; %11x1


Mod2_50R = [Mod2_50R;NaN;NaN;NaN;NaN;NaN]; 
Mod2_TU = [Mod2_TU;NaN;NaN;NaN;NaN]; 
Mod2_25U = [Mod2_25U;NaN;NaN]; 
Mod2_50U = [Mod2_50U;NaN]; 

%% RTIS1003
Mod2_TR= Modules_CMatrices_4Modules(2,1:4)';% 4x1
Mod2_25R = Modules_CMatrices_4Modules(2,5:7)'; %3x1
Mod2_50R = Modules_CMatrices_4Modules(2,8:12)'; %5x1

Mod2_TU= Modules_CMatrices_4Modules(2,13:15)'; % 3x1
Mod2_25U = Modules_CMatrices_4Modules(2,16:18)'; %3x1
Mod2_50U = Modules_CMatrices_4Modules(2,19:21)'; %3x1


Mod2_TR = [Mod2_TR;NaN]; 
Mod2_25R = [Mod2_25R;NaN;NaN]; 
Mod2_TU = [Mod2_TU;NaN;NaN]; 
Mod2_25U = [Mod2_25U;NaN;NaN]; 
Mod2_50U = [Mod2_50U;NaN;NaN]; 
%% RTIS1005

Mod2_TR= Modules_CMatrices_4Modules(2,1:6)'; 
Mod2_25R = Modules_CMatrices_4Modules(2,7:15)';
Mod2_50R = Modules_CMatrices_4Modules(2,16:24)'; 
Mod2_TU= Modules_CMatrices_4Modules(2,25:30)'; 
Mod2_25U = Modules_CMatrices_4Modules(2,31:37)'; 
Mod2_50U = Modules_CMatrices_4Modules(2,38:43)'; 

% Get Sizes of all Conditions so can Concatonate 


% For RTIS1005

Mod2_TR = [Mod2_TR;NaN;NaN;NaN]; 
Mod2_TU = [Mod2_TU;NaN;NaN;NaN]; 
Mod2_25U = [Mod2_25U;NaN;NaN]; 
Mod2_50U = [Mod2_50U;NaN;NaN;NaN]; 

%%
Mod2_colsasConditions = [Mod2_TR_A Mod2_25R_A Mod2_50R_A Mod2_TU_A Mod2_25U_A Mod2_50U_A Mod2_TR_P Mod2_25R_P Mod2_50R_P Mod2_TU_P Mod2_25U_P Mod2_50U_P];

%% Just accel
Mod2_colsasConditions = [Mod2_TR_A Mod2_25R_A Mod2_50R_A Mod2_TU_A Mod2_25U_A Mod2_50U_A];

%% Module3


%% RTIS2001 
%For accel phase

Mod3_TR_A= Modules_CMatrices_4Modules(3,1:7)'; % 7x1
Mod3_25R_A = Modules_CMatrices_4Modules(3,8:17)'; % 10x1
Mod3_50R_A = Modules_CMatrices_4Modules(3,18:27)';% 10x1

Mod3_TU_A= Modules_CMatrices_4Modules(3,28:32)'; % 5x1
Mod3_25U_A = Modules_CMatrices_4Modules(3,33:42)'; % 10x1
Mod3_50U_A = Modules_CMatrices_4Modules(3,43:51)'; %9x1


% For RTIS2001_P - NEED TO ADD BACK IN NANS


Mod3_TR_A = [Mod3_TR_A;NaN;NaN;NaN]; 
Mod3_TU_A = [Mod3_TU_A;NaN;NaN;NaN;NaN;NaN]; 
Mod3_50U_A = [Mod3_50U_A;NaN]; 

% For ppa phase
Mod3_TR_P= Modules_CMatrices_4Modules(3,52:58)'; % 7x1
Mod3_25R_P = Modules_CMatrices_4Modules(3,59:68)'; % 10x1
Mod3_50R_P= Modules_CMatrices_4Modules(3,69:78)';% 10x1

Mod3_TU_P= Modules_CMatrices_4Modules(3,79:83)'; % 5x1
Mod3_25U_P = Modules_CMatrices_4Modules(3,84:93)'; % 10x1
Mod3_50U_P = Modules_CMatrices_4Modules(3,94:102)'; %9x1


Mod3_TR_P = [Mod3_TR_P;NaN;NaN;NaN]; 
Mod3_TU_P = [Mod3_TU_P;NaN;NaN;NaN;NaN;NaN]; 
Mod3_50U_P = [Mod3_50U_P;NaN]; 

%% RTIS1003
Mod3_TR= Modules_CMatrices_4Modules(3,1:4)';% 4x1
Mod3_25R = Modules_CMatrices_4Modules(3,5:7)'; %3x1
Mod3_50R = Modules_CMatrices_4Modules(3,8:12)'; %5x1

Mod3_TU= Modules_CMatrices_4Modules(3,13:15)'; % 3x1
Mod3_25U = Modules_CMatrices_4Modules(3,16:18)'; %3x1
Mod3_50U = Modules_CMatrices_4Modules(3,19:21)'; %3x1



Mod3_TR = [Mod3_TR;NaN]; 
Mod3_25R = [Mod3_25R;NaN;NaN]; 
Mod3_TU = [Mod3_TU;NaN;NaN]; 
Mod3_25U = [Mod3_25U;NaN;NaN]; 
Mod3_50U = [Mod3_50U;NaN;NaN]; 


%% RTIS1005

Mod3_TR= Modules_CMatrices_4Modules(3,1:6)'; 
Mod3_25R = Modules_CMatrices_4Modules(3,7:15)';
Mod3_50R = Modules_CMatrices_4Modules(3,16:24)'; 
Mod3_TU= Modules_CMatrices_4Modules(3,25:30)'; 
Mod3_25U = Modules_CMatrices_4Modules(3,31:37)'; 
Mod3_50U = Modules_CMatrices_4Modules(3,38:43)'; 

% Get Sizes of all Conditions so can Concatonate 


% For RTIS1005

Mod3_TR = [Mod3_TR;NaN;NaN;NaN]; 
Mod3_TU = [Mod3_TU;NaN;NaN;NaN]; 
Mod3_25U = [Mod3_25U;NaN;NaN]; 
Mod3_50U = [Mod3_50U;NaN;NaN;NaN]; 
%%

Mod3_colsasConditions = [Mod3_TR_A Mod3_25R_A Mod3_50R_A Mod3_TU_A Mod3_25U_A Mod3_50U_A Mod3_TR_P Mod3_25R_P Mod3_50R_P Mod3_TU_P Mod3_25U_P Mod3_50U_P];
   %% Just accel
Mod3_colsasConditions = [Mod3_TR_A Mod3_25R_A Mod3_50R_A Mod3_TU_A Mod3_25U_A Mod3_50U_A];
%% Module4

%% RTIS1003
Mod4_TR= Modules_CMatrices_4Modules(4,1:4)';% 4x1
Mod4_25R = Modules_CMatrices_4Modules(4,5:7)'; %3x1
Mod4_50R = Modules_CMatrices_4Modules(4,8:12)'; %5x1

Mod4_TU= Modules_CMatrices_4Modules(4,13:15)'; % 3x1
Mod4_25U = Modules_CMatrices_4Modules(4,16:18)'; %3x1
Mod4_50U = Modules_CMatrices_4Modules(4,19:21)'; %3x1



Mod4_TR = [Mod4_TR;NaN]; 
Mod4_25R = [Mod4_25R;NaN;NaN]; 
Mod4_TU = [Mod4_TU;NaN;NaN]; 
Mod4_25U = [Mod4_25U;NaN;NaN]; 
Mod4_50U = [Mod4_50U;NaN;NaN]; 

%% RTIS1005
Mod4_TR= Modules_CMatrices_4Modules(4,1:6)'; 
Mod4_25R = Modules_CMatrices_4Modules(4,7:15)';
Mod4_50R = Modules_CMatrices_4Modules(4,16:24)'; 
Mod4_TU= Modules_CMatrices_4Modules(4,25:30)'; 
Mod4_25U = Modules_CMatrices_4Modules(4,31:37)'; 
Mod4_50U = Modules_CMatrices_4Modules(4,38:43)'; 

% Get Sizes of all Conditions so can Concatonate 


% For RTIS1005

Mod4_TR = [Mod4_TR;NaN;NaN;NaN]; 
Mod4_TU = [Mod4_TU;NaN;NaN;NaN]; 
Mod4_25U = [Mod4_25U;NaN;NaN]; 
Mod4_50U = [Mod4_50U;NaN;NaN;NaN]; 
%% RTIS2001

%For accel phase

Mod4_TR_A= Modules_CMatrices_4Modules(4,1:7)'; % 7x1
Mod4_25R_A = Modules_CMatrices_4Modules(4,8:17)'; % 10x1
Mod4_50R_A = Modules_CMatrices_4Modules(4,18:27)';% 10x1

Mod4_TU_A= Modules_CMatrices_4Modules(4,28:32)'; % 5x1
Mod4_25U_A = Modules_CMatrices_4Modules(4,33:42)'; % 10x1
Mod4_50U_A = Modules_CMatrices_4Modules(4,43:51)'; %9x1


Mod4_TR_A = [Mod4_TR_A;NaN;NaN;NaN]; 
Mod4_TU_A = [Mod4_TU_A;NaN;NaN;NaN;NaN;NaN]; 
Mod4_50U_A = [Mod4_50U_A;NaN]; 

% For ppa phase
Mod4_TR_P= Modules_CMatrices_4Modules(4,52:58)'; % 7x1
Mod4_25R_P = Modules_CMatrices_4Modules(4,59:68)'; % 10x1
Mod4_50R_P= Modules_CMatrices_4Modules(4,69:78)';% 10x1

Mod4_TU_P= Modules_CMatrices_4Modules(4,79:83)'; % 5x1
Mod4_25U_P = Modules_CMatrices_4Modules(4,84:93)'; % 10x1
Mod4_50U_P = Modules_CMatrices_4Modules(4,94:102)'; %9x1


Mod4_TR_P = [Mod4_TR_P;NaN;NaN;NaN]; 
Mod4_TU_P = [Mod4_TU_P;NaN;NaN;NaN;NaN;NaN]; 
Mod4_50U_P = [Mod4_50U_P;NaN]; 

%%
Mod4_colsasConditions = [Mod4_TR_A Mod4_25R_A Mod4_50R_A Mod4_TU_A Mod4_25U_A Mod4_50U_A Mod4_TR_P Mod4_25R_P Mod4_50R_P Mod4_TU_P Mod4_25U_P Mod4_50U_P];
%% Just accel
Mod4_colsasConditions = [Mod4_TR_A Mod4_25R_A Mod4_50R_A Mod4_TU_A Mod4_25U_A Mod4_50U_A];

%% MODULE 1-  Weightings and Box Plots with Time Component * USE ME* 

% Weightings per Module
figure()
subplot(1,2,1)
% title('S1: Mod 1 Composition','Fontsize',35)
hold on
bar(nmf(4).W(:,1), 'FaceColor', [0.5 0 0.5]) % Dark purple color
% set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
% xtickangle(45);
xlim([.5 7.5])
 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod1_colsasConditions); % Create box plot
% title('S1: Mod 1 Across Conditions','FontSize',35)
%xticks(1:12); % Set x-tick positions
% xticks(1:6); % Set x-tick positions
% xticklabels({'TR-A', '25R-A', '50R-A','TU-A', '25U-A', '50U-A'}); % Set x-tick labels
% xticklabels({'TR-A', '25R-A', '50R-A','TU-A', '25U-A', '50U-A','TR-P','25R-P', '50R-P','TU-P', '25U-P', '50U-P'}); % Set x-tick labels

ylim([0 1])
 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels
% Set box plot colors to dark purple and adjust line width
h = findobj(gca, 'Tag', 'Box'); % Find box objects
for k = 1:length(h)
    set(h(k), 'Color', [0.5 0 0.5]); % Set the color of the box plots to dark purple
    set(h(k), 'LineWidth', 2); % Adjust line width to make it thicker
end

% Adjust line width for median lines
hMedian = findobj(gca, 'Tag', 'Median');
set(hMedian, 'LineWidth', 2); % Set median line width



%% Module 2: Weightings and Box Plots with Time Component * USE ME* 
% Weightings per Module
figure()
subplot(1,2,1)
hold on
bar(nmf(4).W(:,2), 'FaceColor', [0.5 0 0.5]) % Dark purple color
% set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
% xtickangle(45);
% title('S1: Mod 2 Composition','Fontsize',35)
xlim([.5 7.5])
 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod2_colsasConditions); % Create box plot
% title('S1: Mod 2 Across Conditions','FontSize',35)
% xticks(1:6); % Set x-tick positions
% xticklabels({'Table-RA', '25% MVT-RA', '50% MVT-RA','Table-UA', '25% MVT-UA', '50% MVT-UA','Table-RP', '25% MVT-RP', '50% MVT-RP','Table-UP', '25% MVT-UP', '50% MVT-UP'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels
% Set box plot colors to dark purple and adjust line width
h = findobj(gca, 'Tag', 'Box'); % Find box objects
for k = 1:length(h)
    set(h(k), 'Color', [0.5 0 0.5]); % Set the color of the box plots to dark purple
    set(h(k), 'LineWidth', 2); % Adjust line width to make it thicker
end

% Adjust line width for median lines
hMedian = findobj(gca, 'Tag', 'Median');
set(hMedian, 'LineWidth', 2); % Set median line width


%% MODULE 3: Weightings and Box Plots with Time Component * USE ME* 

figure
subplot(1,2,1)
bar(nmf(4).W(:,3), 'FaceColor', [0.5 0 0.5]) % Dark purple color
% set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
% xtickangle(45);
hold on
% title('S1: Mod 3 Composition','Fontsize',35)
xlim([.5 7.5])
 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod3_colsasConditions); % Create box plot
% title('S1: Mod 3 Across Conditions','FontSize',35)
% xticks(1:12); % Set x-tick positions
% xticklabels({'Table-RA', '25% MVT-RA', '50% MVT-RA','Table-UA', '25% MVT-UA', '50% MVT-UA','Table-RP', '25% MVT-RP', '50% MVT-RP','Table-UP', '25% MVT-UP', '50% MVT-UP'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels
% Set box plot colors to dark purple and adjust line width
h = findobj(gca, 'Tag', 'Box'); % Find box objects
for k = 1:length(h)
    set(h(k), 'Color', [0.5 0 0.5]); % Set the color of the box plots to dark purple
    set(h(k), 'LineWidth', 2); % Adjust line width to make it thicker
end

% Adjust line width for median lines
hMedian = findobj(gca, 'Tag', 'Median');
set(hMedian, 'LineWidth', 2); % Set median line width


%% MODULE 4: Weightings and Box Plots with Time Component * USE ME* 
figure
subplot(1,2,1)
bar(nmf(4).W(:,4), 'FaceColor', [0.5 0 0.5]) % Dark purple color
% set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
% xtickangle(45);
% hold on
% title('S1: Mod 4 Composition','Fontsize',35)
xlim([.5 7.5])
 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels

subplot(1,2,2) % Time Component as Box Plots  
boxplot(Mod4_colsasConditions); % Create box plot
% title('S1: Mod 4 Across Conditions','FontSize',35)
% xticks(1:12); % Set x-tick positions
% xticklabels({'Table-RA', '25% MVT-RA', '50% MVT-RA','Table-UA', '25% MVT-UA', '50% MVT-UA','Table-RP', '25% MVT-RP', '50% MVT-RP','Table-UP', '25% MVT-UP', '50% MVT-UP'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes

 set(gca, 'FontSize', 35); % Set font size for axes
set(gca, 'XTick', []);  % Remove x-ticks
set(gca, 'XTickLabel', []);  % Remove x-tick labels
% Set box plot colors to dark purple and adjust line width
h = findobj(gca, 'Tag', 'Box'); % Find box objects
for k = 1:length(h)
    set(h(k), 'Color', [0.5 0 0.5]); % Set the color of the box plots to dark purple
    set(h(k), 'LineWidth', 2); % Adjust line width to make it thicker
end

% Adjust line width for median lines
hMedian = findobj(gca, 'Tag', 'Median');
set(hMedian, 'LineWidth', 2); % Set median line width

%% Module 1 Box Plot 
figure()
%subplot(3,1,1)
boxplot(Mod1_colsasLoads)
title('Module 1 Across Loading Conditions','FontSize',20)
xticks(1:3); % Set x-tick positions
xticklabels({'Table', '25% MVT', '50% MVT'}); % Set x-tick labels
ylabel('Expression of Module 1')
ylim([0 1])
set(gca, 'FontSize', 18); % Set font size for axes


% Module 2 Box Plot 
figure()
%subplot(3,1,2)
boxplot(Mod2_colsasLoads)
title('Module 2 Across Loading Conditions','FontSize',20)
xticks(1:3); % Set x-tick positions
xticklabels({'Table', '25% MVT', '50% MVT'}); % Set x-tick labels
ylabel('Expression of Module 2')
ylim([0 1])
set(gca, 'FontSize', 18); % Set font size for axes

% Module 3 Box Plot 
figure()
%subplot(3,1,3)
boxplot(Mod3_colsasLoads)
title('Module 3 Across Loading Conditions','FontSize',20)
xticks(1:3); % Set x-tick positions
xticklabels({'Table', '25% MVT', '50% MVT'}); % Set x-tick labels
ylabel('Expression of Module 3')
ylim([0 1])
set(gca, 'FontSize', 18); % Set font size for axes



%% Hongchul October 3 - Code for Playing Around with Determining the Appropriate Number of Synergies

%% Plotting Orignal Input Data with Reconstructed Data

% Observe effect of increasing the number of synergies with how closely the
% original data and recon data align
for mm=1:7
% subplot(4,2,mm)
plot(NNMF_Mat(mm,:),'k','LineWidth',2.5)
if mm ==1
    title('UT')
elseif mm==2
    title('MT')
elseif mm==3
    title('LD')
elseif mm== 4
    title('PM')
elseif mm ==5
    title('BIC')
elseif mm == 6
    title('TRI')
else
    title('IDL','FontSize',30)
    % Set the axes font size
ax = gca; % Get current axes
ax.FontSize = 20; % Set font size to 20
xlabel('Trials','FontSize',25)
ylabel('EMG Activation (Normalized)','FontSize',25)

end


hold on
for ss=1:4
plot(nmf(ss).RECON(mm,:),'Linewidth',1)
'Synergies'
ss
% pause

end
if mm <7
   
close
end 
end

%% Plotting Individual Muscle VAFS as a function of Number of synergies

for mm = 1:7
    plot(VAFmus(mm,:))
    hold on
    
 if mm ==1
    title('UT')
elseif mm==2
    title('MT')
elseif mm==3
    title('LD')
elseif mm== 4
    title('PM')
elseif mm ==5
    title('BIC')
elseif mm == 6
    title('TRI')
else
    title('IDL')
end

end

ylabel('VAF per muscle','Fontsize',16)
xlabel('Number of Synergies','Fontsize',16)



%%
% For plotting the mean VAF per muscle as a function of the number of 
% Synergies along with the std of each vaf per muscle

VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end

figure; errorbar(1:7,mean(VAFmus),std(VAFmus))



%% Plotting the VAF for each trial as a function of the number of synergies
figure;
plot(1:102,VAFcond)
xlabel('Trial','Fontsize',20)
ylabel('VAF','Fontsize',20)
legend('1 Synergies','2 Synergies','3 Synergies','4 Synergies','5 Synergies','6 Synergies','7 Synergies','Fontsize',20)


%% Plotting Each Synergy Composition and the Expression of Each over Time 

figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
bar(nmf(4).W(:,ww))
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:102,nmf(4).C(ww,:))
end

%%



% Way of showing how much the data aligns for that muscle as a function of
% synergy number 
figure;
for ww=1:4
plot(1:102,nmf(4).W(4,ww)*nmf(4).C(ww,:))
hold on
title('Pec Major')
end
plot(1:102,NNMF_Mat(4,:),'k','LineWidth',1.5)
legend('1 Synergy','2 Synergies','3 Synergies','4 Synergies','Original Data')

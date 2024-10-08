 % K. Suvada. Sept 2024

% Script to run NMF analysis and remove zeros from matrix using internal
% Matlab function.


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

% Red is 2011

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
plot(nmf(3).C(1,:),'Linewidth',2)
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

% For ppa phase
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
%%
Mod1_colsasConditions = [Mod1_TR_A Mod1_25R_A Mod1_50R_A Mod1_TU_A Mod1_25U_A Mod1_50U_A Mod1_TR_P Mod1_25R_P Mod1_50R_P Mod1_TU_P Mod1_25U_P Mod1_50U_P];


%% Module2


%% RTIS2001
Mod2_TR= Modules_CMatrices_4Modules(2,1:7)'; % 7x1
Mod2_25R = Modules_CMatrices_4Modules(2,8:17)'; % 10x1
Mod2_50R = Modules_CMatrices_4Modules(2,18:27)';% 10x1

Mod2_TU= Modules_CMatrices_4Modules(2,28:32)'; % 5x1
Mod2_25U = Modules_CMatrices_4Modules(2,33:42)'; % 10x1
Mod2_50U = Modules_CMatrices_4Modules(2,43:51)'; %9x1



Mod2_TR = [Mod2_TR;NaN;NaN;NaN]; 
Mod2_TU = [Mod2_TU;NaN;NaN;NaN;NaN;NaN]; 
Mod2_50U = [Mod2_50U;NaN]; 

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
Mod2_colsasConditions = [Mod2_TR Mod2_25R Mod2_50R Mod2_TU Mod2_25U Mod2_50U];


%% Module3


%% RTIS2001 
Mod3_TR= Modules_CMatrices_4Modules(3,1:7)'; % 7x1
Mod3_25R = Modules_CMatrices_4Modules(3,8:17)'; % 10x1
Mod3_50R = Modules_CMatrices_4Modules(3,18:27)';% 10x1

Mod3_TU= Modules_CMatrices_4Modules(3,28:32)'; % 5x1
Mod3_25U = Modules_CMatrices_4Modules(3,33:42)'; % 10x1
Mod3_50U = Modules_CMatrices_4Modules(3,43:51)'; %9x1



Mod3_TR = [Mod3_TR;NaN;NaN;NaN]; 
Mod3_TU = [Mod3_TU;NaN;NaN;NaN;NaN;NaN]; 
Mod3_50U = [Mod3_50U;NaN]; 



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

Mod3_colsasConditions = [Mod3_TR Mod3_25R Mod3_50R Mod3_TU Mod3_25U Mod3_50U];

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

Mod4_TR= Modules_CMatrices_4Modules(4,1:7)'; % 7x1
Mod4_25R = Modules_CMatrices_4Modules(4,8:17)'; % 10x1
Mod4_50R = Modules_CMatrices_4Modules(4,18:27)';% 10x1

Mod4_TU= Modules_CMatrices_4Modules(4,28:32)'; % 5x1
Mod4_25U = Modules_CMatrices_4Modules(4,33:42)'; % 10x1
Mod4_50U = Modules_CMatrices_4Modules(4,43:51)'; %9x1

Mod4_TR = [Mod4_TR;NaN;NaN;NaN]; 
Mod4_TU = [Mod4_TU;NaN;NaN;NaN;NaN;NaN]; 
Mod4_50U = [Mod4_50U;NaN]; 


%%
Mod4_colsasConditions = [Mod4_TR Mod4_25R Mod4_50R Mod4_TU Mod4_25U Mod4_50U];


%% MODULE 1-  Weightings and Box Plots with Time Component * USE ME* 

% Weightings per Module
subplot(1,2,1)
title('S1: Mod 1 Composition','Fontsize',35)
hold on
bar(nmf(4).W(:,1), 'FaceColor', [0.5 0 0.5]) % Dark purple color
set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
xtickangle(45);

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod1_colsasConditions); % Create box plot
title('S1: Mod 1 Across Conditions','FontSize',35)
xticks(1:12); % Set x-tick positions
xticklabels({'Table-RA', '25% MVT-RA', '50% MVT-RA','Table-UA', '25% MVT-UA', '50% MVT-UA','Table-RP', '25% MVT-RP', '50% MVT-RP','Table-UP', '25% MVT-UP', '50% MVT-UP'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes

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
subplot(1,2,1)
hold on
bar(nmf(4).W(:,2), 'FaceColor', [0.5 0 0.5]) % Dark purple color
set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
xtickangle(45);
title('S1: Mod 2 Composition','Fontsize',35)

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod2_colsasConditions); % Create box plot
title('S1: Mod 2 Across Conditions','FontSize',35)
xticks(1:6); % Set x-tick positions
xticklabels({'Table-R', '25% MVT-R', '50% MVT-R','Table-U', '25% MVT-U', '50% MVT-U'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes

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
set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
xtickangle(45);
hold on
title('S1: Mod 3 Composition','Fontsize',35)

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod3_colsasConditions); % Create box plot
title('S1: Mod 3 Across Conditions','FontSize',35)
xticks(1:6); % Set x-tick positions
xticklabels({'Table-R', '25% MVT-R', '50% MVT-R','Table-U', '25% MVT-U', '50% MVT-U'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes

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
set(gca, 'XTick', 1:7, 'XTickLabel', {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'}, 'FontSize', 35); 
xtickangle(45);
hold on
title('S1: Mod 4 Composition','Fontsize',35)

subplot(1,2,2) % Time Component as Box Plots 
boxplot(Mod4_colsasConditions); % Create box plot
title('S1: Mod 4 Across Conditions','FontSize',35)
xticks(1:6); % Set x-tick positions
xticklabels({'Table-R', '25% MVT-R', '50% MVT-R','Table-U', '25% MVT-U', '50% MVT-U'}); % Set x-tick labels
ylim([0 1])
set(gca, 'FontSize', 35); % Set font size for axes

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

%% Saved VAFS from given number of modules - OLD VAF DEF - DON'T USE 

% Plotting the Number of Modules vs the VAF
% x1 =2;
% x2=3;
% x3=4;
% x4 = 5;
% 
% ModulesVAF_2 = 74.7773;
% ModulesVAF_3 = 88.7685 ; 
% ModulesVAF_4 =  89.9994 ; 
% ModulesVAF_5 = 98.1836;
% 
% % Kacey: where is the plateau? Once you get to 80/90% VAF it's okay?
% 
% figure()
% plot(x1, ModulesVAF_2, 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
% hold on
% plot(x2, ModulesVAF_3, 'o', 'MarkerSize', 12, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
% plot(x3, ModulesVAF_4, 'o', 'MarkerSize', 14, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
% plot(x4, ModulesVAF_5, 'o', 'MarkerSize', 16, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
% xlim([1 6])
% ylabel('Variance Accounted For','FontSize',20)
% xlabel('Number of Modules','FontSize',20)
% title('Variance Accounted for as a Function of Modules','FontSize',25)
% set(gca, 'FontSize', 14); % Set font size for tick labels


%% Hongchul October 3
plot(NNMF_Mat(1,:))
hold on
plot(nmf(1).RECON(1,:))
plot(cell2mat(NMFMatrix_trial_FINAL(4,2:end)))
for mm=1:7
plot(NNMF_Mat(mm,:))
hold on
end
clear all
for mm=1:7
plot(NNMF_Mat(mm,:))
hold on
end
close all
for mm=1:7
plot(NNMF_Mat(mm,:))
hold on
end
for mm=1:7
subplot(4,2,mm)
for ss=1:4
plot(NNMF_Mat(mm,:))
hold on
plot(nmf(ss).RECON(mm,:))
end
end
for mm=1:7
subplot(4,2,mm)
plot(NNMF_Mat(mm,:),'k','LineWidth',2)
hold on
for ss=1:4
plot(nmf(ss).RECON(mm,:))
end
end
VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus; nmf(ss).VAFmus];
VAFcond = [VAFcond; VAFcond];'
end
VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus; nmf(ss).VAFmus];
VAFcond = [VAFcond; VAFcond];
end
VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus; nmf(ss).VAFmus];
VAFcond = [VAFcond; nmf(ss).VAFcond];
end
VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, VAFcond];
end
VAFmus = []; VAFcond = [];
for ss=1:7
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end
figure;
plot(1:51,VAFcond)
plot(1:7,VAFmus)
figure; plot(1:7,VAFmus)
figure; plot(1:7,VAFmus')
figure; errorbar(1:7,mean(VAFmus'),std(VAFmus'))
figure; errorbar(1:7,mean(VAFmus),std(VAFmus))
figure;
plot(1:51,VAFcond)
figure; plot(1:51,nmf(4).C)
figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
barplot(nmf(4).W(:,ww)
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:51,nmf(4).C(ww,:))
end
figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
barplot(nmf(4).W(:,ww)
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:51,nmf(4).C(ww,:)))
end
figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
barplot(nmf(4).W(:,ww))
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:51,nmf(4).C(ww,:))
end
figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
bar(nmf(4).W(:,ww))
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:51,nmf(4).C(ww,:))
end
figure;
for ww=1:4
subplot(4,1,ww)
plot(1:7,nmf(4).W(:,ww)*C(ww,:))
end
figure;
for ww=1:4
subplot(4,1,ww)
plot(1:7,nmf(4).W(:,ww)*nmf(4).C(ww,:))
end
nmf(4).W(:,ww)*nmf(4).C(ww,:);
figure;
for ww=1:4
subplot(4,1,ww)
plot(1:51,nmf(4).W(:,ww)*nmf(4).C(ww,:))
end
figure;
plot(1:51,NNMF_Mat(4,:),'k','LineWidth',1.5)
hold on
for ww=1:4
plot(1:51,nmf(4).W(4,ww)*nmf(4).C(ww,4))
end
nmf(4).W(4,ww)*nmf(4).C(ww,4);
figure;
plot(1:51,NNMF_Mat(4,:),'k','LineWidth',1.5)
hold on
for ww=1:4
plot(1:51,nmf(4).W(4,ww)*nmf(4).C(ww,:))
end
figure;
for ww=1:4
plot(1:51,nmf(4).W(4,ww)*nmf(4).C(ww,:))
hold on
end
plot(1:51,NNMF_Mat(4,:),'k','LineWidth',1.5)
close all

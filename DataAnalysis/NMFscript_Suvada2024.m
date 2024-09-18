% K. Suvada. Sept 2024

% Script to run NMF analysis and remove zeros from matrix using internal
% Matlab function.


% Concatonate by hand the nonzero columns (zero columns are trials that
% were skipped with the kinematic data)

NumCols = size(NMFMatrix_trial_updated,2);

Zerocols = find(cell2mat(NMFMatrix_trial_updated(2,2:end)) == 0)+1; %Omit first col bc names of muscles

%% Removing the Columns of the Matrix that are 0 (skipped trials) and concatonating 

for i = 1: NumCols
    if i == 1

    NMFMatrix_trial_FINAL = NMFMatrix_trial_updated(:,i);
        
  
    elseif cell2mat(NMFMatrix_trial_updated(2,i)) == 0 

    else

    NMFMatrix_trial_FINAL = [NMFMatrix_trial_FINAL NMFMatrix_trial_updated(:,i)];

    end 
end

% Need to Omit the Names of the muscles and Trial Nums 
NNMF_Mat = cell2mat(NMFMatrix_trial_FINAL(2:end,2:end));



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


%% Computing the Total VAF

% Difference in the computed signal (W*C) from the input Data (NNMF_Mat)

EMG_est = W*C; 

                  % Actual     % ESTimated
DiffActualfromEst = NNMF_Mat - EMG_est;

VarDiff = var(DiffActualfromEst);

VarOriginalSig = var(NNMF_Mat);

VarRatio = VarDiff/VarOriginalSig;

% CHECK THIS DEFINITION 
VAF_total = (1-VarRatio)*100

%% Computing VAF From Code From Hongchul
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

figure()
plot([nmf.VAF],'Linewidth',3)
title('Motor Modules vs VAF', 'FontSize', 20);
xlabel('Modules', 'FontSize', 16); 
ylabel('% VAF', 'FontSize', 16); 
y = 99; % y-coordinate
x = xlim; % Get current x-axis limits
line(x, [y y], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1);
xline(3,'r','Linewidth',2)

%% Plotting the Modules for n = 3 modules and the Time Component

Mus = {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};
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


%% Saved VAFS from given number of modules 

% Plotting the Number of Modules vs the VAF
x1 =2;
x2=3;
x3=4;
x4 = 5;

ModulesVAF_2 = 74.7773;
ModulesVAF_3 = 88.7685 ; 
ModulesVAF_4 =  89.9994 ; 
ModulesVAF_5 = 98.1836;

% Kacey: where is the plateau? Once you get to 80/90% VAF it's okay?

figure()
plot(x1, ModulesVAF_2, 'o', 'MarkerSize', 10, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
hold on
plot(x2, ModulesVAF_3, 'o', 'MarkerSize', 12, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
plot(x3, ModulesVAF_4, 'o', 'MarkerSize', 14, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
plot(x4, ModulesVAF_5, 'o', 'MarkerSize', 16, 'MarkerEdgeColor', [0.13 0.55 0.13], 'MarkerFaceColor', [0.13 0.55 0.13]);
xlim([1 6])
ylabel('Variance Accounted For','FontSize',20)
xlabel('Number of Modules','FontSize',20)
title('Variance Accounted for as a Function of Modules','FontSize',25)
set(gca, 'FontSize', 14); % Set font size for tick labels



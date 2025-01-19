%% NMF Script
% 
% K. Suvada 2025

% Replace with desired file: (APA trunk,APA arm,APA trunk+arm,ACC trunk,ACC
% arm,ACC trunk+arm)

data2 = readcell('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/FinalExcelSheets_CLEANEDANDCUT/TRUNK_APA.xlsx');


% Find all rows where 'RTIS1003'

desiredpart = 'RTIS1003';

matchingRows = strcmp(data2(2:end, 1),desiredpart);

% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :); % Add `true` to include the header row

RTIS1003_MAT_APA_Trunk = result';

muscnames= {'CLES','ILES','CLRA','ILRA','CLEO', 'ILEO','CLIO','ILIO'};


% Grabbing just EMG values to input into NNMF

NMFMAT = RTIS1003_MAT_APA_Trunk(10:17,2:end);

%% Running NMF Analysis with code from Hongchul *** USE*****

data = cell2mat(NMFMAT);
nmus = size(data,1);
%%
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
errorbar(1:8,[nmf.VAF],[nmf.err],'Color', '#31a354','LineWidth',4)
% title(', 'FontSize', 45);
xlabel('Number of Modules', 'FontSize', 16); 
ylabel('Composite % VAF and Error ', 'FontSize', 16); 
xlim([1 8])
ylim([0 105])
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20


% VAF Plot with Error Bars per muscle

VAFmus = []; VAFcond = [];
for ss=1:8
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end

figure(3)
errorbar(1:8,mean(VAFmus),std(VAFmus),'Color', '#dd1c77','LineWidth',3)
hold on
errorbar(1:8, mean(VAFmus), std(VAFmus), 'o', 'Color', '#c994c7' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
ylabel('Mean % VAF and Error per Muscle', 'FontSize', 35); 

ylim([0 105])

%%
%% Plotting the Modules for n = 4 modules and the Time Component

Mus={'CLES','ILES','CLRA','ILRA','CLEO', 'ILEO','CLIO','ILIO'};


x = 1:length(Mus);


figure
% Weightings per Module
subplot(4,1,1)
title('Module 1','Fontsize',16)
hold on
bar(nmf(3).W(:,1))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
subplot(4,1,2)
hold on
bar(nmf(3).W(:,2))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
title('Module 2','Fontsize',16)
subplot(4,1,3)
bar(nmf(3).W(:,end))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
hold on
title('Module 4','Fontsize',16)
subplot(4,1,4)
bar(nmf(4).W(:,end))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
hold on
title('Module 4','Fontsize',16)


%% All Trials and Contribution per Modules

%Time Component Per Module- box plots
subplot(4,1,1)
plot(nmf(3).C(1,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 1','FontSize',16)
subplot(4,1,2)
plot(nmf(3).C(2,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 2','FontSize',16)
subplot(4,1,3)
plot(nmf(3).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 3','FontSize',16)
subplot(4,1,4)
plot(nmf(4).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 4','FontSize',16)


%% Separating by Condition 

NNMFstruc= NNMF_allConds_Filtered;
 
Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);

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

NMFMAT = RTIS1003_MAT_APA_Trunk;



%% Running NMF Analysis with code from Hongchul *** USE*****

data = cell2mat(NMFMAT(10:17,2:end));
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

%% Additional Checks for the NumSyn

% Observe effect of increasing the number of synergies with how closely the
% original data and recon data align


for mm=1:8
 subplot(4,2,mm)
plot(data(mm,:),'k','LineWidth',4)
if mm ==1
    title('CLES')
elseif mm==2
    title('ILES')
elseif mm==3
    title('CLRA')
elseif mm== 4
    title('ILRA')
elseif mm ==5
    title('CLEO')
elseif mm == 6
    title('ILEO')
elseif mm == 7
    title('CLIO')
elseif mm == 8
    title('ILIO')


% ax = gca; % Get current axes
% ax.FontSize = 20; % Set font size to 20
xlabel('Trials','FontSize',25)
% ylabel('EMG Activation (Normalized)','FontSize',25)

end


hold on
for ss=1:4
plot(nmf(ss).RECON(mm,:),'Linewidth',1)

if ss == 4
plot(nmf(ss).RECON(mm, :), 'r', 'LineWidth', 3, 'LineStyle', '--');
else 
end


'Synergies'
ss
% pause

end

end


%% Plotting Individual Muscle VAFS as a function of Number of synergies

for mm = 1:8
    plot(VAFmus(mm,:),'LineWidth',2)
    hold on
    
if mm ==1
%     title('CLES')
elseif mm==2
%     title('ILES')
elseif mm==3
%     title('CLRA')
elseif mm== 4
%     title('ILRA')
elseif mm ==5
%     title('CLEO')
elseif mm == 6
%     title('ILEO')
elseif mm == 7
%     title('CLIO')
elseif mm == 8
%     title('ILIO')
end

legend('CLES','ILES','CLRA','ILRA','CLEO','ILEO','CLIO','ILIO','FontSize',18)
ylabel('VAF per muscle','Fontsize',16)
xlabel('Number of Synergies','Fontsize',16)

end




%% Plotting the VAF for each trial as a function of the number of synergies
figure;
plot(1:20,VAFcond)
xlabel('Trial','Fontsize',20)
ylabel('VAF','Fontsize',20)
legend('1 Synergies','2 Synergies','3 Synergies','4 Synergies','5 Synergies','6 Synergies','7 Synergies','Fontsize',20)


%% Plotting Each Synergy Composition and the Expression of Each over Time 

figure;
for ww=1:4
subplot(4,3,1+3*(ww-1))
bar(nmf(4).W(:,ww))
subplot(4,3,[2 3] + 3*(ww-1))
plot(1:20,nmf(4).C(ww,:))
end

%%



%%
%% Plotting the Modules for n = 4 modules and the Time Component

Mus={'CLES','ILES','CLRA','ILRA','CLEO', 'ILEO','CLIO','ILIO'};


x = 1:length(Mus);


figure
% Weightings per Module
subplot(4,1,1)
title('Module 1','Fontsize',16)
hold on
bar(nmf(4).W(:,1))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
subplot(4,1,2)
hold on
bar(nmf(4).W(:,2))
set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 16); 
xtickangle(45);
title('Module 2','Fontsize',16)
subplot(4,1,3)
bar(nmf(4).W(:,end))
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
plot(nmf(4).C(1,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 1','FontSize',16)
subplot(4,1,2)
plot(nmf(4).C(2,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 2','FontSize',16)
subplot(4,1,3)
plot(nmf(4).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 3','FontSize',16)
subplot(4,1,4)
plot(nmf(4).C(end,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel('Contribution to Module 4','FontSize',16)


%% Separating Time Component by Condition 

% Row of Cell Array where the conditions are indicated
CONDSLOC =  strcmp(NMFMAT(:,1),'COND');

Cond1_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==1); 
Cond2_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==2); 
Cond3_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==3); 
Cond4_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==4); 
Cond5_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==5); 
Cond6_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==6); 

%%
% For Number of Modules go through and separate by condition 


MChosenMods = 4; % set this to desired number of modules 

for i = 1:MChosenMods
Mod_TR(1:length(Cond1_cols),i)= nmf(MChosenMods).C(i,Cond1_cols)';
Mod_25R(1:length(Cond2_cols),i) = nmf(MChosenMods).C(i,Cond2_cols)'; 
Mod_50R(1:length(Cond3_cols),i) = nmf(MChosenMods).C(i,Cond3_cols)';

Mod_TU(1:length(Cond4_cols),i)= nmf(MChosenMods).C(i,Cond4_cols)'; 
Mod_25U(1:length(Cond5_cols),i) = nmf(MChosenMods).C(i,Cond5_cols)';
Mod_50U(1:length(Cond6_cols),i) = nmf(MChosenMods).C(i,Cond6_cols)';
end


%%
% Rows are trials and the columns are the expression of each module

% Create a cell array to hold all the arrays
arrays_Mod1 = {Mod_TR(:,1), Mod_25R(:,1), Mod_50R(:,1), Mod_TU(:,1), Mod_25U(:,1), Mod_50U(:,1)};
arrays_Mod2 = {Mod_TR(:,2), Mod_25R(:,2), Mod_50R(:,2), Mod_TU(:,2), Mod_25U(:,2), Mod_50U(:,2)};
arrays_Mod3 = {Mod_TR(:,3), Mod_25R(:,3), Mod_50R(:,3), Mod_TU(:,3), Mod_25U(:,3), Mod_50U(:,3)};
arrays_Mod4 = {Mod_TR(:,4), Mod_25R(:,4), Mod_50R(:,4), Mod_TU(:,4), Mod_25U(:,4), Mod_50U(:,4)};


% Find the maximum length among all arrays
maxLength_mod1 = max(cellfun(@length, arrays_Mod1));
maxLength_mod2 = max(cellfun(@length, arrays_Mod2));
maxLength_mod3 = max(cellfun(@length, arrays_Mod3));
maxLength_mod4 = max(cellfun(@length, arrays_Mod4));

% Mod1 
% Amend each array to match the maximum length by appending NaNs
for i = 1:length(arrays_Mod1)
    arrays_Mod1{i}(end+1:maxLength, 1) = NaN; % Append NaNs to match maxLength
end

Mod1_MAT = horzcat(arrays_Mod1{:}); % N trials x 6 conditions

% Mod2
% Amend each array to match the maximum length by appending NaNs
for i = 1:length(arrays_Mod2)
    arrays_Mod2{i}(end+1:maxLength_mod2, 1) = NaN; % Append NaNs to match maxLength
end

Mod2_MAT = horzcat(arrays_Mod2{:}); % N trials x 6 conditions

% Mod3
% Amend each array to match the maximum length by appending NaNs
for i = 1:length(arrays_Mod3)
    arrays_Mod3{i}(end+1:maxLength_mod3, 1) = NaN; % Append NaNs to match maxLength
end

Mod3_MAT = horzcat(arrays_Mod3{:}); % N trials x 6 conditions


% Mod4
% Amend each array to match the maximum length by appending NaNs
for i = 1:length(arrays_Mod4)
    arrays_Mod4{i}(end+1:maxLength_mod4, 1) = NaN; % Append NaNs to match maxLength
end

Mod4_MAT = horzcat(arrays_Mod4{:}); % N trials x 6 conditions







%% BOX PLOTS

figure()
boxplot(Mod1_MAT)
set(gca, 'XTick', x, ...
         'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
         'FontSize', 16);
title('Module 1 Expression','FontSize',20)
ylim([0 1])

figure()
boxplot(Mod2_MAT)
set(gca, 'XTick', x, ...
         'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
         'FontSize', 16);
title('Module 2 Expression','FontSize',20)
ylim([0 1])

figure()
boxplot(Mod3_MAT)
set(gca, 'XTick', x, ...
         'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
         'FontSize', 16);
title('Module 3 Expression','FontSize',20)
ylim([0 1])

figure()
boxplot(Mod4_MAT)
set(gca, 'XTick', x, ...
         'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
         'FontSize', 16);
title('Module 4 Expression','FontSize',20)
ylim([0 1])




% Function to visualize results of NMF once set desired number of synergies
% Combining acceleration and preparatory phases 
% K. Suvada 2025. 


%%
function  SuvadaNMF2025_ARM_Func3(desiredpart,desiredhand,filename,nmf,mmods,partid,arm)


data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);

matchingRows = strcmp(data2(2:end, 1),desiredpart) &  strcmp(data2(2:end, 4),desiredhand);

% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MAT_APA = result';

% Grabbing just EMG values to input into NNMF

NMFMAT = MAT_APA;

NMFMAT = [NMFMAT(1:10,:); NMFMAT(19:25,:)]; % Grabbing just arm
%%
% Finding missing muscles to create selected rows and musnames variables in
% code 

MissingMus = cell(1,7);
MissingRows = cell(1,7);
musnames = cell(1,7);
selectedrowsmat = cell(1,7);

for p = 1:7
  if  ismissing(NMFMAT{p+10,2}) ==1
      MissingMus{1,p} = NMFMAT{p+10,1};
      MissingRows{1,p} = p+10;

  else 
      musnames{1,p} =  NMFMAT{p+10,1};
      selectedrowsmat{1,p} = p+10;
  end 
end 

% Identify non-empty elements
musnames = musnames(~cellfun('isempty', musnames));
selectedrowsmat = selectedrowsmat(~cellfun('isempty', selectedrowsmat));



%% Capping the expression of a module at 1


  nmf(mmods).C(find(nmf(mmods).C >1))=1;


%% Each module expresion across all trials 



for i = 1 : mmods 
subplot(mmods,1,i)
plot(nmf(mmods).C(i,:),'Linewidth',2)
xlabel('Trials','FontSize',16)
ylabel(['Contribution to Module' num2str(i)],'FontSize',16)
end 


%% Separating Time Component by Condition 

% Row of Cell Array where the conditions are indicated
CONDSLOC =  strcmp(NMFMAT(:,1),'COND');

Cond1_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==1); 
Cond2_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==2); 
Cond3_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==3); 
Cond4_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==4);
Cond5_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==5);
Cond6_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==6);

%% Separating the Preparation Phase and the Acceleration Phase
 Cond1_Prep_cols = find(strcmp(NMFMAT(8,Cond1_cols+1),'Prep'));
 Cond1_Prep_cols = Cond1_cols(Cond1_Prep_cols);
 Cond1_Acc_cols = find(strcmp(NMFMAT(8,Cond1_cols+1),'Acc'));
 Cond1_Acc_cols = Cond1_cols(Cond1_Acc_cols); % indices shifted back one bc in C matrix no column for labels

 Cond2_Prep_cols = strcmp(NMFMAT(8,Cond2_cols+1),'Prep');
 Cond2_Prep_cols = Cond2_cols(Cond2_Prep_cols);
 Cond2_Acc_cols = strcmp(NMFMAT(8,Cond2_cols+1),'Acc');
 Cond2_Acc_cols = Cond2_cols(Cond2_Acc_cols);

  
 Cond3_Prep_cols = strcmp(NMFMAT(8,Cond3_cols+1),'Prep');
 Cond3_Prep_cols = Cond3_cols(Cond3_Prep_cols);
 Cond3_Acc_cols = strcmp(NMFMAT(8,Cond3_cols+1),'Acc');
 Cond3_Acc_cols = Cond3_cols(Cond3_Acc_cols);

  
 Cond4_Prep_cols = strcmp(NMFMAT(8,Cond4_cols+1),'Prep');
 Cond4_Prep_cols = Cond4_cols(Cond4_Prep_cols);
 Cond4_Acc_cols = strcmp(NMFMAT(8,Cond4_cols+1),'Acc');
 Cond4_Acc_cols = Cond4_cols(Cond4_Acc_cols);


 Cond5_Prep_cols = strcmp(NMFMAT(8,Cond5_cols+1),'Prep');
 Cond5_Prep_cols = Cond5_cols(Cond5_Prep_cols);
 Cond5_Acc_cols = strcmp(NMFMAT(8,Cond5_cols+1),'Acc');
 Cond5_Acc_cols = Cond5_cols(Cond5_Acc_cols);

 Cond6_Prep_cols = strcmp(NMFMAT(8,Cond6_cols+1),'Prep');
 Cond6_Prep_cols = Cond6_cols(Cond6_Prep_cols);
 Cond6_Acc_cols = strcmp(NMFMAT(8,Cond6_cols+1),'Acc');
 Cond6_Acc_cols = Cond6_cols(Cond6_Acc_cols);

%% For Number of Modules go through and separate by condition


MChosenMods = mmods; % set this to desired number of modules

for i = 1:MChosenMods

  % For each condition (both prep and acceleration)

  % Trunk Restrained Table
  Mod_TR_Prep(1:length(Cond1_Prep_cols),i)= nmf(MChosenMods).C(i,Cond1_Prep_cols)';  % Prep Phase
  Mod_TR_Acc(1:length(Cond1_Acc_cols),i)= nmf(MChosenMods).C(i,Cond1_Acc_cols)'; % Acceleration Phase

  % Trunk Restrained 25
  Mod_25R_Prep(1:length(Cond2_Prep_cols),i) = nmf(MChosenMods).C(i,Cond2_Prep_cols)';
  Mod_25R_Acc(1:length(Cond2_Acc_cols),i) = nmf(MChosenMods).C(i,Cond2_Acc_cols)';

  % Trunk Restrained 50 
  Mod_50R_Prep(1:length(Cond3_Prep_cols),i) = nmf(MChosenMods).C(i,Cond3_Prep_cols)';
  Mod_50R_Acc(1:length(Cond3_Acc_cols),i) = nmf(MChosenMods).C(i,Cond3_Acc_cols)';


  % Trunk Unrestrained Table
  Mod_TU_Prep(1:length(Cond4_Prep_cols),i)= nmf(MChosenMods).C(i,Cond4_Prep_cols)';
  Mod_TU_Acc(1:length(Cond4_Acc_cols),i)= nmf(MChosenMods).C(i,Cond4_Acc_cols)';

  % Trunk Unrestrained 25%
  Mod_25U_Prep(1:length(Cond5_Prep_cols),i) = nmf(MChosenMods).C(i,Cond5_Prep_cols)';
  Mod_25U_Acc(1:length(Cond5_Acc_cols),i) = nmf(MChosenMods).C(i,Cond5_Acc_cols)';

  % Trunk Unrestrained 50%
  Mod_50U_Prep(1:length(Cond6_Prep_cols),i) = nmf(MChosenMods).C(i,Cond6_Prep_cols)';
  Mod_50U_Acc(1:length(Cond6_Acc_cols),i) = nmf(MChosenMods).C(i,Cond6_Acc_cols)';

end





%%
% Create a cell array to hold all the arrays and amend st there are NANs 
% in conditions where not even number of trials
for j = 1: mmods

    if j == 1

        arrays_Mod1= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};


        maxLength_mod1 = max(cellfun(@length, arrays_Mod1(:))); %finding the maximum length
        % Amend each array to match the maximum length by appending NaNs
       
        for i = 1:length(arrays_Mod1)
            arrays_Mod1{i}(end+1:maxLength_mod1, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod1_MAT = horzcat(arrays_Mod1{:}); % N trials x 12 conditions : 6 Conditions with 2 timepoints each

    elseif j == 2
        arrays_Mod2= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod2 = max(cellfun(@length, arrays_Mod2));

        for i = 1:length(arrays_Mod2)
            arrays_Mod2{i}(end+1:maxLength_mod2, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod2_MAT = horzcat(arrays_Mod2{:}); 

    elseif j ==3
        arrays_Mod3= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
       
        maxLength_mod3 = max(cellfun(@length, arrays_Mod3));

        for i = 1:length(arrays_Mod3)
            arrays_Mod3{i}(end+1:maxLength_mod3, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod3_MAT = horzcat(arrays_Mod3{:}); 

    elseif j ==4
        arrays_Mod4= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod4 = max(cellfun(@length, arrays_Mod4));

        for i = 1:length(arrays_Mod4)
            arrays_Mod4{i}(end+1:maxLength_mod4, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod4_MAT = horzcat(arrays_Mod4{:}); 

    elseif j ==5
        arrays_Mod5= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod5 = max(cellfun(@length, arrays_Mod5));

        for i = 1:length(arrays_Mod5)
            arrays_Mod5{i}(end+1:maxLength_mod5, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod5_MAT = horzcat(arrays_Mod5{:}); % N trials x 6 conditions

    elseif j ==6
        arrays_Mod6= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod6 = max(cellfun(@length, arrays_Mod6));


        for i = 1:length(arrays_Mod6)
            arrays_Mod6{i}(end+1:maxLength_mod6, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod6_MAT = horzcat(arrays_Mod6{:}); % N trials x 6 conditions

    elseif j ==7
        arrays_Mod7= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod7 = max(cellfun(@length, arrays_Mod7));


        for i = 1:length(arrays_Mod7)
            arrays_Mod7{i}(end+1:maxLength_mod7, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod7_MAT = horzcat(arrays_Mod7{:}); % N trials x 6 conditions

    elseif j ==8
        arrays_Mod8= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod8 = max(cellfun(@length, arrays_Mod8));


        for i = 1:length(arrays_Mod8)
            arrays_Mod8{i}(end+1:maxLength_mod8, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod8_MAT = horzcat(arrays_Mod8{:}); % N trials x 6 conditions

    elseif j ==9
        arrays_Mod9= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod9 = max(cellfun(@length, arrays_Mod9));

        for i = 1:length(arrays_Mod9)
            arrays_Mod9{i}(end+1:maxLength_mod9, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod9_MAT = horzcat(arrays_Mod9{:}); % N trials x 6 conditions

    elseif j ==10
        arrays_Mod10= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod10 = max(cellfun(@length, arrays_Mod10));

        for i = 1:length(arrays_Mod10)
            arrays_Mod10{i}(end+1:maxLength_mod10, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod10_MAT = horzcat(arrays_Mod10{:}); % N trials x 6 conditions

    elseif j ==11
        arrays_Mod11= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod11 = max(cellfun(@length, arrays_Mod11(:,j)));

        for i = 1:length(arrays_Mod11)
            arrays_Mod11{i}(end+1:maxLength_mod11, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod11_MAT = horzcat(arrays_Mod11{:}); % N trials x 6 conditions

    elseif j ==12
        arrays_Mod12= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod12 = max(cellfun(@length, arrays_Mod12));

        for i = 1:length(arrays_Mod12)
            arrays_Mod12{i}(end+1:maxLength_mod12, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod12_MAT = horzcat(arrays_Mod12{:}); % N trials x 6 conditions

    elseif j ==13
        arrays_Mod13= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod13 = max(cellfun(@length, arrays_Mod13));

        for i = 1:length(arrays_Mod13)
            arrays_Mod13{i}(end+1:maxLength_mod13, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod13_MAT = horzcat(arrays_Mod13{:}); % N trials x 6 conditions

    elseif j ==14
        arrays_Mod14= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod14 = max(cellfun(@length, arrays_Mod14));
       
        for i = 1:length(arrays_Mod14)
            arrays_Mod14{i}(end+1:maxLength_mod14, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod14_MAT = horzcat(arrays_Mod14{:}); % N trials x 6 conditions

    elseif j ==15
        arrays_Mod15= {Mod_TR_Prep(:,j),Mod_TR_Acc(:,j), Mod_25R_Prep(:,j),Mod_25R_Acc(:,j), Mod_50R_Prep(:,j),Mod_50R_Acc(:,j), Mod_TU_Prep(:,j),Mod_TU_Acc(:,j), Mod_25U_Prep(:,j),Mod_25U_Acc(:,j), Mod_50U_Prep(:,j),Mod_50U_Acc(:,j)};
        maxLength_mod15 = max(cellfun(@length, arrays_Mod15));


        for i = 1:length(arrays_Mod15)
            arrays_Mod15{i}(end+1:maxLength_mod15, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod15_MAT = horzcat(arrays_Mod15{:}); % N trials x 6 conditions

    end
end

%% Plotting Mass Figure 

x = 1:length(musnames);
Mus = musnames;
figure;

% Define the number of rows and columns
rows = mmods;
cols = 2;

% Set the margin and spacing
margin = 0.05; % Margin around the figure
h_spacing = 0.065; % Horizontal spacing between plots
v_spacing = 0.05; % Vertical spacing between plots

% Calculate width and height for each plot
plot_width = (1 - (cols + 1) * h_spacing) / cols;
plot_height = (1 - (rows + 1) * v_spacing) / rows;

for i = 1:rows
    for j = 1:cols
        % Calculate position for each plot
        left = margin + (j - 1) * (plot_width + h_spacing);
        bottom = 1 - margin - i * plot_height - (i - 1) * v_spacing;

        % Create the axes
        ax = axes('Position', [left, bottom, plot_width, plot_height]);

        % Example plot in each axes
        if i == 1
            if j ==1
                bar(nmf(mmods).W(:,1))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
             %   title('RTIS 1003 Module 1 (W)','FontSize',20)
            title([partid '/' arm '/' 'Module 1 (W)'], 'FontSize', 12)

            else
                boxplot(Mod1_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 1 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end

        if i ==2
            if j ==1
                bar(nmf(mmods).W(:,2))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 2 (W)'], 'FontSize', 12)

            else
                boxplot(Mod2_MAT)
                 set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 2 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end

        if i ==3
            if j ==1
                bar(nmf(mmods).W(:,3))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 3 (W)'], 'FontSize', 12)

            else
                boxplot(Mod3_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 3 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end


        if i ==4
            if j ==1
                bar(nmf(mmods).W(:,4))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
               title([partid '/' arm '/' 'Module 4 (W)'], 'FontSize', 12)

            else
                boxplot(Mod4_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 4 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end

        if i ==5
            if j ==1
                bar(nmf(mmods).W(:,5))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 5 (W)'], 'FontSize', 12)

            else
                boxplot(Mod5_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 5 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end

        if i ==6
            if j ==1
                bar(nmf(mmods).W(:,6))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 6 (W)'], 'FontSize', 12)

            else
                boxplot(Mod6_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 6 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end

        if i ==7
            if j ==1
                bar(nmf(mmods).W(:,7))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 7 (W)'], 'FontSize', 12)

            else
                boxplot(Mod7_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 7 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end



    end
end




end
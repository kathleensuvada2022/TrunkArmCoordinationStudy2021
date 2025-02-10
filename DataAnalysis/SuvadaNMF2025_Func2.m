


% Function to visualize results of NMF once set desired number of synergies
%
% K. Suvada 2025. 


%%
function  SuvadaNMF2025_Func2(desiredpart,desiredhand,filename,selectedrowsmat,musnames,nmf,mmods,partid,arm)


data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);

matchingRows = strcmp(data2(2:end, 1),desiredpart) &  strcmp(data2(2:end, 4),desiredhand);

% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MAT_APA = result';



% Grabbing just EMG values to input into NNMF

NMFMAT = MAT_APA;


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


%% For Number of Modules go through and separate by condition


MChosenMods = mmods; % set this to desired number of modules

for i = 1:MChosenMods
    Mod_TR(1:length(Cond1_cols),i)= nmf(MChosenMods).C(i,Cond1_cols)'; % condition 1 expression (rows) across all m modules (columns)
    Mod_25R(1:length(Cond2_cols),i) = nmf(MChosenMods).C(i,Cond2_cols)';
    Mod_50R(1:length(Cond3_cols),i) = nmf(MChosenMods).C(i,Cond3_cols)';

    Mod_TU(1:length(Cond4_cols),i)= nmf(MChosenMods).C(i,Cond4_cols)';
    Mod_25U(1:length(Cond5_cols),i) = nmf(MChosenMods).C(i,Cond5_cols)';
    Mod_50U(1:length(Cond6_cols),i) = nmf(MChosenMods).C(i,Cond6_cols)';
end
%%
% Create a cell array to hold all the arrays and amend st there are NANs 
% in conditions where not even number of trials
for j = 1: mmods

    if j == 1
        arrays_Mod1= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod1 = max(cellfun(@length, arrays_Mod1(:))); %finding the maximum length
        % Amend each array to match the maximum length by appending NaNs
       
        for i = 1:length(arrays_Mod1)
            arrays_Mod1{i}(end+1:maxLength_mod1, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod1_MAT = horzcat(arrays_Mod1{:}); % N trials x 6 conditions

    elseif j == 2
        arrays_Mod2= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod2 = max(cellfun(@length, arrays_Mod2));

        for i = 1:length(arrays_Mod2)
            arrays_Mod2{i}(end+1:maxLength_mod2, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod2_MAT = horzcat(arrays_Mod2{:}); % N trials x 6 conditions

    elseif j ==3
        arrays_Mod3= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod3 = max(cellfun(@length, arrays_Mod3));

        for i = 1:length(arrays_Mod3)
            arrays_Mod3{i}(end+1:maxLength_mod3, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod3_MAT = horzcat(arrays_Mod3{:}); % N trials x 6 conditions

    elseif j ==4
        arrays_Mod4= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod4 = max(cellfun(@length, arrays_Mod4));

        for i = 1:length(arrays_Mod4)
            arrays_Mod4{i}(end+1:maxLength_mod4, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod4_MAT = horzcat(arrays_Mod4{:}); % N trials x 6 conditions

    elseif j ==5
        arrays_Mod5= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod5 = max(cellfun(@length, arrays_Mod5));

        for i = 1:length(arrays_Mod5)
            arrays_Mod5{i}(end+1:maxLength_mod5, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod5_MAT = horzcat(arrays_Mod5{:}); % N trials x 6 conditions

    elseif j ==6
        arrays_Mod6= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod6 = max(cellfun(@length, arrays_Mod6));


        for i = 1:length(arrays_Mod6)
            arrays_Mod6{i}(end+1:maxLength_mod6, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod6_MAT = horzcat(arrays_Mod6{:}); % N trials x 6 conditions

    elseif j ==7
        arrays_Mod7= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod7 = max(cellfun(@length, arrays_Mod7));


        for i = 1:length(arrays_Mod7)
            arrays_Mod7{i}(end+1:maxLength_mod7, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod7_MAT = horzcat(arrays_Mod7{:}); % N trials x 6 conditions

    elseif j ==8
        arrays_Mod8= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod8 = max(cellfun(@length, arrays_Mod8));


        for i = 1:length(arrays_Mod8)
            arrays_Mod8{i}(end+1:maxLength_mod8, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod8_MAT = horzcat(arrays_Mod8{:}); % N trials x 6 conditions

    elseif j ==9
        arrays_Mod9= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod9 = max(cellfun(@length, arrays_Mod9));

        for i = 1:length(arrays_Mod9)
            arrays_Mod9{i}(end+1:maxLength_mod9, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod9_MAT = horzcat(arrays_Mod9{:}); % N trials x 6 conditions

    elseif j ==10
        arrays_Mod10= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod10 = max(cellfun(@length, arrays_Mod10));

        for i = 1:length(arrays_Mod10)
            arrays_Mod10{i}(end+1:maxLength_mod10, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod10_MAT = horzcat(arrays_Mod10{:}); % N trials x 6 conditions

    elseif j ==11
        arrays_Mod11= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod11 = max(cellfun(@length, arrays_Mod11(:,j)));

        for i = 1:length(arrays_Mod11)
            arrays_Mod11{i}(end+1:maxLength_mod11, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod11_MAT = horzcat(arrays_Mod11{:}); % N trials x 6 conditions

    elseif j ==12
        arrays_Mod12= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod12 = max(cellfun(@length, arrays_Mod12));

        for i = 1:length(arrays_Mod12)
            arrays_Mod12{i}(end+1:maxLength_mod12, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod12_MAT = horzcat(arrays_Mod12{:}); % N trials x 6 conditions

    elseif j ==13
        arrays_Mod13= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod13 = max(cellfun(@length, arrays_Mod13));

        for i = 1:length(arrays_Mod13)
            arrays_Mod13{i}(end+1:maxLength_mod13, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod13_MAT = horzcat(arrays_Mod13{:}); % N trials x 6 conditions

    elseif j ==14
        arrays_Mod14= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod14 = max(cellfun(@length, arrays_Mod14));
       
        for i = 1:length(arrays_Mod14)
            arrays_Mod14{i}(end+1:maxLength_mod14, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod14_MAT = horzcat(arrays_Mod14{:}); % N trials x 6 conditions

    elseif j ==15
        arrays_Mod15= {Mod_TR(:,j), Mod_25R(:,j), Mod_50R(:,j), Mod_TU(:,j), Mod_25U(:,j), Mod_50U(:,j)};
        maxLength_mod15 = max(cellfun(@length, arrays_Mod15));


        for i = 1:length(arrays_Mod15)
            arrays_Mod15{i}(end+1:maxLength_mod15, 1) = NaN; % Append NaNs to match maxLength
        end

        Mod15_MAT = horzcat(arrays_Mod15{:}); % N trials x 6 conditions

    end
end

%% Plotting Mass Figure 

x = 1:length(musnames);
Mus  = {'CLES',	'ILES',	'CLRA',	'ILRA',	'CLEO',	'ILEO',	'CLIO',	'ILIO',	'UT',	'MT',	'PM',	'BIC',	'TRI',	'IDEL'};

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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
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
                set(gca, 'XTick', x, ...
                    'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, ...
                    'FontSize', 16);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 7 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end



    end
end




end
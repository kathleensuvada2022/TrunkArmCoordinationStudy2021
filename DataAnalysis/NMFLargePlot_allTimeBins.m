% Script to Make Large Plot of Modules for Accel,Prep,and combined Accel+Prep


desiredpart = 'RTIS1004';
desiredhand = 'C' ;
mmods =3;  % CHANGE BASED ON THE TIME BIN!!!!

partid = desiredpart;
arm = desiredhand;

%% PRE
  filename = 'TrunkandArmAPA.xlsx';
 rowoffset = 9;

 rowoffset2 = 18:24;
%%

%% ACC
 filename= 'TrunkandArmACC_FINALFINAL.xlsx';
 rowoffset = 9;

 rowoffset2 = 18:24;
%% COMBINED
% filename ='CombinedPrepandAccelTrunkandArm.xlsx';
%  rowoffset = 10 ;% for combined

%  rowoffset2 = 19:25; % For combined


%%
%%
data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);

% Indicate 'Prep' vs 'Acc' or omit for both !! Change
% matchingRows = strcmp(data2(2:end, 1), desiredpart) & ...
%                strcmp(data2(2:end, 4), desiredhand) & ...
%                (strcmp(data2(2:end, 8), 'Acc') );

% CHANGE COMBINED!
matchingRows = strcmp(data2(2:end, 1), desiredpart) & ...
               strcmp(data2(2:end, 4), desiredhand) ;
% 


% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MAT_APA = result';

% Grabbing just EMG values to input into NNMF

NMFMAT = MAT_APA;

NMFMAT = [NMFMAT(1:rowoffset,:); NMFMAT(rowoffset2,:)]; % Grabbing just arm



% Finding missing muscles to create selected rows and musnames variables in
% code 

MissingMus = cell(1,7);
MissingRows = cell(1,7);
musnames = cell(1,7);
selectedrowsmat = cell(1,7);
for p = 1:7
  if  ismissing(NMFMAT{p+rowoffset,2}) ==1
      MissingMus{1,p} = NMFMAT{p+rowoffset,1};
      MissingRows{1,p} = p+rowoffset;

  else 
      musnames{1,p} =  NMFMAT{p+rowoffset,1};
      selectedrowsmat{1,p} = p+rowoffset;
  end 
end 

% Identify non-empty elements
musnames = musnames(~cellfun('isempty', musnames));
selectedrowsmat = selectedrowsmat(~cellfun('isempty', selectedrowsmat));



% Capping the expression of a module at 1


   nmf(mmods).C(find(nmf(mmods).C >1))=1;



% Separating Time Component by Condition 

% Row of Cell Array where the conditions are indicated
CONDSLOC =  find(strcmp(NMFMAT(:,1),'COND'));

Cond1_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==1); 
Cond2_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==2); 
Cond3_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==3); 
Cond4_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==4);
Cond5_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==5);
Cond6_cols = find(cell2mat(NMFMAT(CONDSLOC,2:end)) ==6);



%%%% For Number of Modules go through and separate by condition


MChosenMods = mmods; % set this to desired number of modules

for i = 1:MChosenMods
    Mod_TR(1:length(Cond1_cols),i)= nmf(MChosenMods).C(i,Cond1_cols)'; % condition 1 expression (rows) across all m modules (columns)
    Mod_25R(1:length(Cond2_cols),i) = nmf(MChosenMods).C(i,Cond2_cols)';
    Mod_50R(1:length(Cond3_cols),i) = nmf(MChosenMods).C(i,Cond3_cols)';

    Mod_TU(1:length(Cond4_cols),i)= nmf(MChosenMods).C(i,Cond4_cols)';
    Mod_25U(1:length(Cond5_cols),i) = nmf(MChosenMods).C(i,Cond5_cols)';
    Mod_50U(1:length(Cond6_cols),i) = nmf(MChosenMods).C(i,Cond6_cols)';
end


%% For when Acceleration and Prep are Separate 
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


%% Separating the Preparation Phase and the Acceleration Phase - skip if doing individual time bin analysis 
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

% For Number of Modules go through and separate by condition


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





%
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
%% Plotting Prep Period  - Quad I
x = 1:length(musnames);
Mus = musnames;
figure(1);

% Define the number of rows and columns
rows = mmods;  % Number of rows (modules)
cols = 2;  % 2 columns (Bar plot on the left, Box plot on the right)

% Set the margin and spacing
margin = 0.05; % Margin around the figure
h_spacing = 0.05; % Horizontal spacing between plots
v_spacing = 0.05; % Vertical spacing between plots

% Calculate width and height for each plot
plot_width = (1/2 - (cols + 1) * h_spacing) / cols;  % Width for the top-left quadrant
plot_height = (1/2 - (rows + 1) * v_spacing) / rows;  % Height for the top-left quadrant

% Get the screen size (in pixels)
screen_size = get(0, 'ScreenSize');

% Set the figure to only occupy the top-left quadrant (quadrant 1)
fig_width = screen_size(3) / 2;  % 50% of screen width (left side)
fig_height = screen_size(4) / 2; % 50% of screen height (top side)

% Position the figure in the top-left quadrant of the screen
fig_pos = [0, screen_size(4) - fig_height, fig_width, fig_height];

% Set the figure position and size
set(gcf, 'Position', fig_pos);

for i = 1:rows
    for j = 1:cols
        % Calculate position for each plot in quadrant 1
        left = margin + (j - 1) * (plot_width + h_spacing);  % Left position
        bottom = 1 - margin - i * plot_height - (i - 1) * v_spacing;  % Bottom position in quadrant 1

        % Create the axes for each plot
        ax = axes('Position', [left, bottom, plot_width, plot_height]);

        % Plot Bar and Box plots
        if i == 1
            if j == 1
                % Bar plot for Module 1 (W)
                bar(nmf(mmods).W(:,1))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 1 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 1 (C)
                boxplot(Mod1_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 1 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 2
            if j == 1
                % Bar plot for Module 2 (W)
                bar(nmf(mmods).W(:,2))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 2 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 2 (C)
                boxplot(Mod2_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 2 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 3
            if j == 1
                % Bar plot for Module 3 (W)
                bar(nmf(mmods).W(:,3))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 3 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 3 (C)
                boxplot(Mod3_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 3 (C)'], 'FontSize', 14)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 4
            if j == 1
                % Bar plot for Module 4 (W)
                bar(nmf(mmods).W(:,4))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 4 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 4 (C)
                boxplot(Mod4_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 4 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        end
    end
end
hold on
%% Plotting Accel Period - Quad 3
x = 1:length(musnames);
Mus = musnames;
figure(1);

% Define the number of rows and columns
rows = mmods;  % Number of rows (modules)
cols = 2;  % 2 columns (Bar plot on the left, Box plot on the right)

% Set the margin and spacing
margin = 0.05; % Margin around the figure
h_spacing = 0.05; % Horizontal spacing between plots
v_spacing = 0.05; % Vertical spacing between plots

% Calculate width and height for each plot
plot_width = (1/2 - (cols + 1) * h_spacing) / cols;  % Width for the bottom-left quadrant
plot_height = (1/2 - (rows + 1) * v_spacing) / rows;  % Height for the bottom-left quadrant

% Get the screen size (in pixels)
screen_size = get(0, 'ScreenSize');

% Set the figure to only occupy the bottom-left quadrant (quadrant 3)
fig_width = screen_size(3) / 2;  % 50% of screen width (left side)
fig_height = screen_size(4) / 2; % 50% of screen height (bottom side)

% Position the figure in the bottom-left quadrant of the screen
fig_pos = [0, 0, fig_width, fig_height];

% Set the figure position and size
set(gcf, 'Position', fig_pos);

for i = 1:rows
    for j = 1:cols
        % Calculate position for each plot in quadrant 3
        left = margin + (j - 1) * (plot_width + h_spacing);  % Left position
        bottom = 1/2 - i * plot_height - (i - 1) * v_spacing;  % Bottom position in quadrant 3

        % Create the axes for each plot
        ax = axes('Position', [left, bottom, plot_width, plot_height]);

        % Plot Bar and Box plots
        if i == 1
            if j == 1
                % Bar plot for Module 1 (W)
                bar(nmf(mmods).W(:,1))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 1 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 1 (C)
                boxplot(Mod1_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 1 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 2
            if j == 1
                % Bar plot for Module 2 (W)
                bar(nmf(mmods).W(:,2))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 2 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 2 (C)
                boxplot(Mod2_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 2 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 3
            if j == 1
                % Bar plot for Module 3 (W)
                bar(nmf(mmods).W(:,3))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 3 (W)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 3 (C)
                boxplot(Mod3_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 3 (C)'], 'FontSize', 14)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        elseif i == 4
            if j == 1
                % Bar plot for Module 4 (W)
                bar(nmf(mmods).W(:,4))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
                title([partid '/' arm '/' 'Module 4 (W)'], 'FontSize', 12)
                ylim([0, 2])  % Adjust y-axis scaling for visibility
            elseif j == 2
                % Box plot for Module 4 (C)
                boxplot(Mod4_MAT)
                set(gca, 'XTick', x, 'XTickLabel', {'RT', 'R25', 'R50', 'UT', 'U25', 'U50'}, 'FontSize', 16);
                title([partid '/' arm '/' 'Module 4 (C)'], 'FontSize', 12)
                ylim([0, 1])  % Adjust y-axis scaling for visibility
            end
        end
    end
end

%% Combined Acceleration and Preparatory Phase
x = 1:length(musnames);
Mus = musnames;
figure(1);

% Define the number of rows and columns
rows = mmods;  % Number of rows (modules)
cols = 2;  % 2 columns (Bar plot on the left, Box plot on the right)

for i = 1:rows
    for j = 1:cols


        % Example plot in each axes
        if i == 1
            if j ==1

                % Define the position and size of the axis
                left = 0.5;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(1/mmods)+.025;  % Distance from the bottom edge (20% of the figure height)
                width = 0.2;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                bar(nmf(mmods).W(:,1))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
             %   title('RTIS 1003 Module 1 (W)','FontSize',20)
            title([partid '/' arm '/' 'Module 1 (W)'], 'FontSize', 12)

            else

                left = 0.72;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(1/mmods)+.025;  % Distance from the bottom edge (20% of the figure height)
                width = 0.27;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
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
                                % Define the position and size of the axis
                left = 0.5;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;  % Distance from the bottom edge (20% of the figure height)
                width = 0.2;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                bar(nmf(mmods).W(:,2))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 2 (W)'], 'FontSize', 12)

            else
                                                % Define the position and size of the axis
                left = 0.72;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                
                width = 0.27;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
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
                
                left = 0.5;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                
                width = 0.2;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                bar(nmf(mmods).W(:,3))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 3 (W)'], 'FontSize', 12)

            else
               
                left = 0.72;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                
                width = 0.27;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)
                ax = axes('Position', [left, bottom, width, height]);

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
               
                left = 0.5;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                   
                width = 0.2;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                bar(nmf(mmods).W(:,4))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
               title([partid '/' arm '/' 'Module 4 (W)'], 'FontSize', 12)

            else
                left = 0.72;    % Distance from the left edge (10% of the figure width)

                bottom = 1-(i/mmods)+.025;                  
                width = 0.27;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
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
                left = 0.5;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                   
                width = 0.2;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                bar(nmf(mmods).W(:,5))
                set(gca, 'XTick', x, 'XTickLabel', Mus, 'FontSize', 10);
%                 xtickangle(45);
            title([partid '/' arm '/' 'Module 5 (W)'], 'FontSize', 12)

            else
                left = 0.72;    % Distance from the left edge (10% of the figure width)
                bottom = 1-(i/mmods)+.025;                  
                width = 0.27;   % Width of the axis (40% of the figure width)
                height = 1/mmods-.05;  % Height of the axis (30% of the figure height)

                % Set the position of the axis
                ax = axes('Position', [left, bottom, width, height]);
                boxplot(Mod5_MAT)
                set(gca, 'XTick', 1:12, ...
                    'XTickLabel', {'RT_Prep','RT_Acc', 'R25_Prep','R25_Acc','R50_Prep','R50_Acc', 'UT_Prep','UT_Acc', 'U25_Prep','U25_Acc','U50_Prep','U50_Acc'}, ...
                    'FontSize', 16);
            title([partid '/' arm '/' 'Module 5 (C)'], 'FontSize', 14)
                ylim([0 1])
            end
        end
    end
end 

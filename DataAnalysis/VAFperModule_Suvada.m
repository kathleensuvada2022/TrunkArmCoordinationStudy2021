%% Computing VAF Per Module
% Kathleen Carolyn Suvada
% March 2025 

desiredpart = 'RTIS2011';
desiredhand = 'NP' ;
filename = 'CombinedPrepandAccelTrunkandArm.xlsx';
mmods =2;  % CHANGE BASED ON THE TIME BIN!!!!

partid = desiredpart;
arm = desiredhand;

%% Finding the VAF of Each Module 


for i = 1:mmods
% Module 1
if i ==1
W_Mod1 = nmf(mmods).W(:,i);

C_Mod1 = nmf(mmods).C(i,:); 

ReconMod1 = W_Mod1*C_Mod1;

% Module 2
elseif i ==2
W_Mod2 = nmf(mmods).W(:,i);

C_Mod2 = nmf(mmods).C(i,:); 

ReconMod2 = W_Mod2*C_Mod2;

% Module 3
elseif i ==3
W_Mod3 = nmf(mmods).W(:,i);

C_Mod3 = nmf(mmods).C(i,:); 

ReconMod3 = W_Mod3*C_Mod3;

%Module 4
elseif i ==4
W_Mod4 = nmf(mmods).W(:,i);

C_Mod4 = nmf(mmods).C(i,:); 

ReconMod4 = W_Mod4*C_Mod4;

% Module 5
elseif i ==5
W_Mod5 = nmf(mmods).W(:,i);

C_Mod5 = nmf(mmods).C(i,:); 

ReconMod5 = W_Mod5*C_Mod5;
end

end
%% Loading in the Original EMG Input Data

data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);

%Indicate 'Prep' vs 'Acc' or omit for both !! Change
matchingRows = strcmp(data2(2:end, 1), desiredpart) & ...
               strcmp(data2(2:end, 4), desiredhand) & ...
               (strcmp(data2(2:end, 8), 'Acc') );

% CHANGE COMBINED!
% matchingRows = strcmp(data2(2:end, 1), desiredpart) & ...
%                strcmp(data2(2:end, 4), desiredhand) ;
% 


% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MatData = result';

% Grabbing just EMG values to input into NNMF

MatDataFinal = MatData;

% Finding missing muscles to create selected rows and musnames variables in
% code 

MissingMus = cell(1,15);
MissingRows = cell(1,15);
musnames = cell(1,15);
selectedrowsmat = cell(1,15);
for p = 1:15
  if  ismissing(MatDataFinal{p+10,2}) ==1
      MissingMus{1,p} = MatDataFinal{p+10,1};
      MissingRows{1,p} = p+10;

  else 
      musnames{1,p} =  MatDataFinal{p+10,1};
      selectedrowsmat{1,p} = p+10;
  end 
end 

% Identify non-empty elements
musnames = musnames(~cellfun('isempty', musnames));
selectedrowsmat = selectedrowsmat(~cellfun('isempty', selectedrowsmat));


%% Omitting the Missing Muscles - Original EMG Data 

MatDataFinal_Clean = MatDataFinal(cell2mat(selectedrowsmat),2:end);

EMG = cell2mat(MatDataFinal_Clean);


%% Computing the Individual VAFs
VAF_Global = nmf(mmods).VAF;

for i = 1:mmods
    if i ==1
        err1 = EMG - ReconMod1;
        VAF1 = (1-sum(sum(err1.^2))/sum(sum(EMG.^2)))*100;
        VAF_Mod1_Final = (VAF1/VAF_Global)*100;
    elseif i ==2
        err2 = EMG-ReconMod2;
        VAF2 = (1-sum(sum(err2.^2))/sum(sum(EMG.^2)))*100;
        VAF_Mod2_Final = (VAF2/VAF_Global)*100;
    elseif i ==3
        err3 = EMG-ReconMod3;
        VAF3 = (1-sum(sum(err3.^2))/sum(sum(EMG.^2)))*100;
        VAF_Mod3_Final = (VAF3/VAF_Global)*100;

    elseif i ==4
        err4 = EMG-ReconMod4;
        VAF4 = (1-sum(sum(err4.^2))/sum(sum(EMG.^2)))*100;
        VAF_Mod4_Final = (VAF4/VAF_Global)*100;

    elseif i ==5
        err5 = EMG-ReconMod5;
        VAF5 = (1-sum(sum(err5.^2))/sum(sum(EMG.^2)))*100;
        VAF_Mod5_Final = (VAF5/VAF_Global)*100;

    end

end




%% 1
VafsPerMod_ACC = [VAF_Mod1_Final]
%% 2
VafsPerMod_ACC = [VAF_Mod1_Final;VAF_Mod2_Final]

%% 3
VafsPerMod_ACC = [VAF_Mod1_Final;VAF_Mod2_Final;VAF_Mod3_Final]



%% 4 
VafsPerMod_ACC = [VAF_Mod1_Final;VAF_Mod2_Final;VAF_Mod3_Final;VAF_Mod4_Final]


%% 5

VafsPerMod_ACC = [VAF_Mod1_Final;VAF_Mod2_Final;VAF_Mod3_Final;VAF_Mod4_Final;VAF_Mod5_Final;]

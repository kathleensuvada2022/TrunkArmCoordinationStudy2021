%% April 2025
%  K. Suvada

% Script used to grab muscle weightings,muscles recorded from,
% VAF per module, and number of modules needed for each time period

% Calls 'GrabMusWeighings.m' function 


% NOTE TO KACEY TO CHANGE THE GRABMUSWEIGHTINGS FILEPATH IF FOR JUST
% ARM!!!!!!!!!!!
%%
 VAFPERMOD_EXCEL= VAFPERMODTRUNKANDARM; % Update if doing Trunk 

%% Part Type
PartCategory = 'Paretic';
%  PartCategory = 'NonParetic';
%%
% PartCategory = 'Controls';
% 

%% PARTID
 partid = 'RTIS2011';
% 

%% ARM
 Arm = 'P';

%% PERIOD
 Period_PostNMF = 'PREP';
 Period_PreNMF= {'Prep'};
% 
%%
Period_PostNMF = 'ACCEL';
Period_PreNMF = {'Acc'};
%%
 Period_PostNMF = 'COMB';
 Period_PreNMF= {'Prep','Acc'};


%% OFFSETS BASED ON ARM OR TRUNK AND ARM 

 rowoffset2 = 11:25  ;  %19:25; % For trunk and arm

 MuscleIterations = 15; %7 for trunk and arm

% ALWAYS RUN ME 

  rowoffset = 10 ;% for combined file KEEP BC ALWAYS USING COMBINED FILE

%% Running the Separate Time Phases 

%% For Preparation Phase

[Weightings_Prep,TotalNumMods_Prep,VAFsPERMOD_Prep,musnames_Prep] = GrabMusWeightings(VAFPERMOD_EXCEL,PartCategory,partid,Arm,Period_PostNMF,Period_PreNMF,rowoffset,rowoffset2,MuscleIterations)

%% For the Accel Phase

[Weightings_Accel,TotalNumMods_Accel,VAFsPERMOD_Accel,musnames_Accel] = GrabMusWeightings(VAFPERMOD_EXCEL,PartCategory,partid,Arm,Period_PostNMF,Period_PreNMF,rowoffset,rowoffset2,MuscleIterations)

%% For the Combined 
[Weightings_Combined,TotalNumMods_Combined,VAFsPERMOD_Combined,musnames_Combined] = GrabMusWeightings(VAFPERMOD_EXCEL,PartCategory,partid,Arm,Period_PostNMF,Period_PreNMF,rowoffset,rowoffset2,MuscleIterations)

%% Finding the Minimum Number of Modules between the 3 time bins 

NumModsMin = min([TotalNumMods_Prep,TotalNumMods_Accel,TotalNumMods_Combined]);

%% Prep
% Initialize the list to store indices and values of the max values
maxValues = zeros(NumModsMin, 1);
maxIndices = zeros(NumModsMin, 1);

% Start with all rows
remainingRows = 1:length(VAFsPERMOD_Prep);

% Loop to find the maximum values and their indices
for i = 1:NumModsMin
    % Extract the remaining values for comparison
    remainingValues = cell2mat(VAFsPERMOD_Prep(remainingRows));
    
    % Find the index of the maximum value
    [maxValue, maxIndexInRemaining] = max(remainingValues);
    
    % Translate this index to the index of the original array
    maxIndex = remainingRows(maxIndexInRemaining);
    
    % Store the maximum value and its index
    maxValues(i) = maxValue;
    maxIndices(i) = maxIndex;
    
    % Exclude the row where this maximum occurred from further consideration
    remainingRows(remainingRows == maxIndex) = []; % Remove the row
end

MaxValues_Prep = maxValues % not in right order sorted greatest to least
maxIndices_Prep = maxIndices % Also the Mod Number IN RIGHT ORDER

%% Accel Phase
maxValues = zeros(NumModsMin, 1);
maxIndices = zeros(NumModsMin, 1);

% Start with all rows
remainingRows = 1:length(VAFsPERMOD_Accel);

% Loop to find the maximum values and their indices
for i = 1:NumModsMin
    % Extract the remaining values for comparison
    remainingValues = cell2mat(VAFsPERMOD_Accel(remainingRows));
    
    % Find the index of the maximum value
    [maxValue, maxIndexInRemaining] = max(remainingValues);
    
    % Translate this index to the index of the original array
    maxIndex = remainingRows(maxIndexInRemaining);
    
    % Store the maximum value and its index
    maxValues(i) = maxValue;
    maxIndices(i) = maxIndex;
    
    % Exclude the row where this maximum occurred from further consideration
    remainingRows(remainingRows == maxIndex) = []; % Remove the row
end

MaxValues_Accel = maxValues
maxIndices_Accel = maxIndices % Also the Mod Number

%% Combined Phase
maxValues = zeros(NumModsMin, 1);
maxIndices = zeros(NumModsMin, 1);

% Start with all rows
remainingRows = 1:length(VAFsPERMOD_Combined);

% Loop to find the maximum values and their indices
for i = 1:NumModsMin
    % Extract the remaining values for comparison
    remainingValues = cell2mat(VAFsPERMOD_Combined(remainingRows));
    
    % Find the index of the maximum value
    [maxValue, maxIndexInRemaining] = max(remainingValues);
    
    % Translate this index to the index of the original array
    maxIndex = remainingRows(maxIndexInRemaining);
    
    % Store the maximum value and its index
    maxValues(i) = maxValue;
    maxIndices(i) = maxIndex;
    
    % Exclude the row where this maximum occurred from further consideration
    remainingRows(remainingRows == maxIndex) = []; % Remove the row
end

MaxValues_Combined = maxValues
maxIndices_Combined= maxIndices % Also the Mod Number

%% Need to Grab the Weightings for the Modules that are the Top VAF 
% Prep
PrepWeightsFinal = Weightings_Prep(:,maxIndices_Prep);

% Accel
AccelWeightsFinal = Weightings_Accel(:,maxIndices_Accel);

% Combined
CombinedWeightsFinal = Weightings_Combined(:,maxIndices_Combined);





%% Make unit vectors so dot product is between -1 and 1


% Need to update so that making the missing muscle weighting 0 for all
% phases !!!
 
for i = 1:NumModsMin

% Making unit vectors
UnitVect_PrepWeight(:,i) = PrepWeightsFinal(:,i)/norm(PrepWeightsFinal(:,i));
UnitVect_AccelWeight(:,i) = AccelWeightsFinal(:,i)/norm(AccelWeightsFinal(:,i));
UnitVect_CombinedWeight(:,i) = CombinedWeightsFinal(:,i)/norm(CombinedWeightsFinal(:,i));
end

%% Comparing the Muscle Names to Make Sure Across All Phases There are the same muscles 

if length(musnames_Prep) == 15 & length(musnames_Accel) ==15
    if length(musnames_Combined) ==15
       'All Time Bins Have Same Number of Muscles'
    end
elseif length(musnames_Combined) ~=15 & length(musnames_Accel) ~=15 
    'Combined Time Bin and Accel Missing Muscle'
elseif length(musnames_Combined) ~=15 & length(musnames_Prep) ~=15
    'Combined Time Bin and Prep Missing Muscle'
end



%% Kacey you need to do some manual work here to see what muscle is missing add in when this happens 
musnames_Prep
musnames_Combined
musnames_Accel
%% Dot Product Computations of Unit Vector Weightings For Primary Modules (MinModsNum) which is based on the VAFs and the bin that has the least number of modules 
size(UnitVect_PrepWeight)
UnitVect_AccelWeight
UnitVect_CombinedWeight


%% FIXING FOR DIFFERENT MUSCLES WITHIN PARTICIPANT ACROSS TIME BIN

%% RTIS2006_NP
% To account for Missing CLES 
UnitVect_AccelWeight(1)=0;
UnitVect_PrepWeight = [0 ; UnitVect_PrepWeight];
UnitVect_CombinedWeight = [0 ; UnitVect_CombinedWeight];

% Delete CLRA From Acceleration and Add CLES to the names for Combined and
% Prep
UnitVect_AccelWeight = UnitVect_AccelWeight([1:2 4:end])
% musnames_Accel = musnames_Accel([1:2 4:end]);
% musnames_Combined = {'CLES' musnames_Combined};
% musnames_Prep = ['CLES'; musnames_Prep];

%% RTIS2002_P

% Send CLES to 0 during Accel and Append Prep and Combined to Add 0
UnitVect_AccelWeight(1)=0;
UnitVect_PrepWeight = [[0 0]; UnitVect_PrepWeight];
UnitVect_CombinedWeight = [[0 0] ; UnitVect_CombinedWeight];

% Missing Internal Oblique From Prep and Combined (Omit from Accel)
UnitVect_AccelWeight = UnitVect_AccelWeight([1:7 9:end],:);

%% RTIS2008_P

% OMIT CLIO FROM ACCEL
UnitVect_AccelWeight = UnitVect_AccelWeight([1:5 7:end],:);

%% RTIS2009_P

% Omit {'ILEO'}    {'CLIO'}    {'ILIO'} from ACCEL 6:8
UnitVect_AccelWeight = UnitVect_AccelWeight([1:5 9:end],:);

%% 


if NumModsMin ==4
% Dot Product of Prep and Combined 
% Module 1
Module1_dotPrepandComb = dot(UnitVect_PrepWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotPrepandComb= dot(UnitVect_PrepWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotPrepandComb= dot(UnitVect_PrepWeight(:,3),UnitVect_CombinedWeight(:,3));

% Module 4
Module4_dotPrepandComb= dot(UnitVect_PrepWeight(:,4),UnitVect_CombinedWeight(:,4));


% Dot Product of Accel and Combined 
% Module 1
Module1_dotAccelandComb = dot(UnitVect_AccelWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotAccelandComb= dot(UnitVect_AccelWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotAccelandComb= dot(UnitVect_AccelWeight(:,3),UnitVect_CombinedWeight(:,3));

% Module 4
Module4_dotAccelandComb= dot(UnitVect_AccelWeight(:,4),UnitVect_CombinedWeight(:,4));

% Dot Product of Combined and Combined  (sanity check) 

% Module 1
Module1_dotCombandComb = dot(UnitVect_CombinedWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotCombandComb= dot(UnitVect_CombinedWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotCombandComb= dot(UnitVect_CombinedWeight(:,3),UnitVect_CombinedWeight(:,3));

% Module 4
Module4_dotCombandComb= dot(UnitVect_CombinedWeight(:,4),UnitVect_CombinedWeight(:,4));

% Define the strings for the first row
row1 = {'PdotC','ModOrderPrep', 'AdotC','ModOrderAccel','CdotC','ModOrderComb'};

% Define the numbers for the next two rows
row2 = [Module1_dotPrepandComb,maxIndices_Prep(1), Module1_dotAccelandComb,maxIndices_Accel(1), Module1_dotCombandComb,maxIndices_Combined(1)]; 
row3 = [Module2_dotPrepandComb,maxIndices_Prep(2), Module2_dotAccelandComb,maxIndices_Accel(2), Module2_dotCombandComb,maxIndices_Combined(2)]; 
row4 = [Module3_dotPrepandComb,maxIndices_Prep(3), Module3_dotAccelandComb,maxIndices_Accel(3), Module3_dotCombandComb,maxIndices_Combined(3)]; 
row5 = [Module4_dotPrepandComb,maxIndices_Prep(4), Module4_dotAccelandComb,maxIndices_Accel(4), Module4_dotCombandComb,maxIndices_Combined(4)]; 



DotProdsCell = {row1(1), row1(2), row1(3),row1(4), row1(5), row1(6); row2(1), row2(2), row2(3),row2(4), row2(5), row2(6); row3(1), row3(2), row3(3), row3(4), row3(5), row3(6);row4(1), row4(2), row4(3),row4(4), row4(5), row4(6);row5(1), row5(2), row5(3),row5(4), row5(5), row5(6)};


elseif NumModsMin ==3
% Dot Product of Prep and Combined 
% Module 1
Module1_dotPrepandComb = dot(UnitVect_PrepWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotPrepandComb= dot(UnitVect_PrepWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotPrepandComb= dot(UnitVect_PrepWeight(:,3),UnitVect_CombinedWeight(:,3));


% Dot Product of Accel and Combined 
% Module 1
Module1_dotAccelandComb = dot(UnitVect_AccelWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotAccelandComb= dot(UnitVect_AccelWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotAccelandComb= dot(UnitVect_AccelWeight(:,3),UnitVect_CombinedWeight(:,3));

% Dot Product of Combined and Combined  (sanity check) 

% Module 1
Module1_dotCombandComb = dot(UnitVect_CombinedWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotCombandComb= dot(UnitVect_CombinedWeight(:,2),UnitVect_CombinedWeight(:,2));

% Module 3
Module3_dotCombandComb= dot(UnitVect_CombinedWeight(:,3),UnitVect_CombinedWeight(:,3));

% Define the strings for the first row
row1 = {'PdotC','ModOrderPrep', 'AdotC','ModOrderAccel','CdotC','ModOrderComb'};

% Define the numbers for the next two rows
row2 = [Module1_dotPrepandComb,maxIndices_Prep(1), Module1_dotAccelandComb,maxIndices_Accel(1), Module1_dotCombandComb,maxIndices_Combined(1)]; 
row3 = [Module2_dotPrepandComb,maxIndices_Prep(2), Module2_dotAccelandComb,maxIndices_Accel(2), Module2_dotCombandComb,maxIndices_Combined(2)]; 
row4 = [Module3_dotPrepandComb,maxIndices_Prep(3), Module3_dotAccelandComb,maxIndices_Accel(3), Module3_dotCombandComb,maxIndices_Combined(3)]; 


% Create the 3x3 cell array
DotProdsCell = {row1{1}, row1{2}, row1{3},row1{4}, row1{5}, row1{6}; row2(1), row2(2), row2(3),row2(4), row2(5), row2(6); row3(1), row3(2), row3(3), row3(4), row3(5), row3(6);row4(1), row4(2), row4(3),row4(4), row4(5), row4(6)};

elseif NumModsMin ==2

% Module 1
Module1_dotPrepandComb = dot(UnitVect_PrepWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotPrepandComb= dot(UnitVect_PrepWeight(:,2),UnitVect_CombinedWeight(:,2));

% Dot Product of Accel and Combined 
% Module 1
Module1_dotAccelandComb = dot(UnitVect_AccelWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotAccelandComb= dot(UnitVect_AccelWeight(:,2),UnitVect_CombinedWeight(:,2));

% Dot Product of Combined and Combined  (sanity check) 

% Module 1
Module1_dotCombandComb = dot(UnitVect_CombinedWeight(:,1),UnitVect_CombinedWeight(:,1));

% Module 2
Module2_dotCombandComb= dot(UnitVect_CombinedWeight(:,2),UnitVect_CombinedWeight(:,2));


% Define the strings for the first row
row1 = {'PdotC','ModOrderPrep', 'AdotC','ModOrderAccel','CdotC','ModOrderComb'};

% Define the numbers for the next two rows
row2 = [Module1_dotPrepandComb,maxIndices_Prep(1), Module1_dotAccelandComb,maxIndices_Accel(1), Module1_dotCombandComb,maxIndices_Combined(1)]; 
row3 = [Module2_dotPrepandComb,maxIndices_Prep(2), Module2_dotAccelandComb,maxIndices_Accel(2), Module2_dotCombandComb,maxIndices_Combined(2)]; 


% Create the 3x3 cell array
DotProdsCell = {row1{1}, row1{2}, row1{3},row1{4}, row1{5}, row1{6}; row2(1), row2(2), row2(3),row2(4), row2(5), row2(6); row3(1), row3(2), row3(3), row3(4), row3(5), row3(6)};


elseif NumModsMin ==1

 % Prep and Combined
 
 Module1_dotPrepandComb = dot(UnitVect_PrepWeight(:,1),UnitVect_CombinedWeight(:,1));
 Module1_dotAccelandComb = dot(UnitVect_AccelWeight(:,1),UnitVect_CombinedWeight(:,1));

% Dot Product of Combined and Combined  (sanity check) 

Module1_dotCombandComb = dot(UnitVect_CombinedWeight(:,1),UnitVect_CombinedWeight(:,1));

% Define the strings for the first row
row1 = {'PdotC','ModOrderPrep', 'AdotC','ModOrderAccel','CdotC','ModOrderComb'};

% Define the numbers for the next two rows
row2 = [Module1_dotPrepandComb,maxIndices_Prep(1), Module1_dotAccelandComb,maxIndices_Accel(1), Module1_dotCombandComb,maxIndices_Combined(1)]; 


% Create the 3x3 cell array
DotProdsCell = {row1{1}, row1{2}, row1{3},row1{4}, row1{5}, row1{6}; row2(1), row2(2), row2(3),row2(4), row2(5), row2(6)};


end




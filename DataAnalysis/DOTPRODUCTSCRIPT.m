%% April 2025
%  K. Suvada

% Script used to grab muscle weightings,muscles recorded from,
% VAF per module, and number of modules needed for each time period

% Calls 'GrabMusWeighings.m' function 

%%
% VAFPERMOD_EXCEL= VAFPERMODULEARM; % Update if doing Trunk 

%% Part Type
% PartCategory = 'Paretic';
% PartCategory = 'NonParetic';
% PartCategory = 'Controls';
% 

%% PARTID
 partid = 'RTIS1003';
% 

%% ARM
 Arm = 'C';

%% PERIOD
 Period_PostNMF = 'PREP';
 Period_PreNMF= {'Prep'};
% 

% Period_PostNMF = 'ACCEL';
% Period_PreNMF = {'Acc'};

 Period_PostNMF = 'COMB';
 Period_PreNMF= {'Prep','Acc'};


%% OFFSETS BASED ON ARM OR TRUNK AND ARM 

 rowoffset2 = 19:25  ;  %11:25; % For trunk and arm

 MuscleIterations = 7; %15 for trunk and arm

%% ALWAYS RUN ME 

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

MaxValues_Prep = maxValues;
maxIndices_Prep = maxIndices; % Also the Mod Number

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

MaxValues_Accel = maxValues;
maxIndices_Accel = maxIndices; % Also the Mod Number

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

MaxValues_Combined = maxValues;
maxIndices_Combined= maxIndices; % Also the Mod Number

%% Need to Grab the Weightings for the Modules that are the Top VAF 
% Prep
PrepWeightsFinal = Weightings_Prep(:,maxIndices_Prep);

% Accel
AccelWeightsFinal = Weightings_Accel(:,maxIndices_Accel);

% Combined
CombinedWeightsFinal = Weightings_Combined(:,maxIndices_Combined);

%% Computing Dot Products 

% Make unit vectors so dot product is between -1 and 1
for i = 1:size(PrepWeightsFinal,2)

% Making unit vectors
UnitVect_PrepWeight(:,i) = PrepWeightsFinal(:,i)/norm(PrepWeightsFinal(:,i));
UnitVect_AccelWeight(:,i) = AccelWeightsFinal(:,i)/norm(AccelWeightsFinal(:,i));
UnitVect_CombinedWeight(:,i) = CombinedWeightsFinal(:,i)/norm(CombinedWeightsFinal(:,i));
end


% Dot Product of Prep and Combined 
dot(UnitVect_AccelWeight(:,1),UnitVect_CombinedWeight(:,1))







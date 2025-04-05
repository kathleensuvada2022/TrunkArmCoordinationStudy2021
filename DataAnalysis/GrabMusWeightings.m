
%% APRIL 2025 
%  K. Suvada

% Function For Importing VAFs per Module and then grabbing the NMF structure
% with the Muscle Weightings 

% Output is the muscle weightings for a given participant for a given time
% bin (can choose if arm or trunk and arm) 

% Use DotProduct Script to compare similarity of modules from the different
% time bins and then when combined (Pre and Accel) phases


function [Weightings,TotalNumMods,VAFsPERMOD,musnames] = GrabMusWeightings(VAFPERMOD_EXCEL,PartCategory,partid,Arm,Period_PostNMF,Period_PreNMF,rowoffset,rowoffset2,MuscleIterations)

% Identifying the Missing Muscles for the given time period/participant/arm

filename ='CombinedPrepandAccelTrunkandArm.xlsx';


data2 = readcell(['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/2025_EXCEL_CLEANEDANDCUT/FINAL/' filename]);


if length(Period_PreNMF) ==1 
matchingRows = strcmp(data2(2:end, 1), partid) & ...
               strcmp(data2(2:end, 4), Arm) & ...
               (strcmp(data2(2:end, 8), Period_PreNMF) );

else 
% For combined we need to grab everything (both prep and accel) 

    matchingRows = (strcmp(data2(2:end, 1), partid) & ...
               strcmp(data2(2:end, 4), Arm) & ...
               strcmp(data2(2:end, 8), cell2mat(Period_PreNMF(1)))) | (...
               strcmp(data2(2:end, 1), partid) & ...
               strcmp(data2(2:end, 4), Arm) & ...
               strcmp(data2(2:end, 8),cell2mat(Period_PreNMF(2)))); 

end

% Extract matching rows (include the header if desired)
result = data2([true; matchingRows], :);

MAT_APA = result';

% Grabbing just EMG values to input into NNMF

NMFMAT = MAT_APA;


NMFMAT = [NMFMAT(1:rowoffset,:); NMFMAT(rowoffset2,:)]; %Grabbing arm or arm and trunk mus


% Finding missing muscles to create selected rows and musnames variables in
% code 

MissingMus = cell(1,MuscleIterations);
MissingRows = cell(1,MuscleIterations);
musnames = cell(1,MuscleIterations);
selectedrowsmat = cell(1,MuscleIterations);
for p = 1:MuscleIterations
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


%%
% FilePath For NMF Data 


if strcmp(Period_PostNMF, "PREP")
filepathfinal = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/NMF_ANALYSIS_DATA_2025/ArmAnalysis/Prep' '/' PartCategory];

elseif strcmp(Period_PostNMF, "ACCEL")
filepathfinal = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/NMF_ANALYSIS_DATA_2025/ArmAnalysis/Accel' '/' PartCategory];

else
filepathfinal = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/NMFData/NMF_ANALYSIS_DATA_2025/ArmAnalysis/Combined' '/' PartCategory];
end


%% Loading in the NMF File - Post Analysis To See Module

% Specify the directory and search pattern
files = dir(fullfile(filepathfinal, [partid '*.mat']));

% Check if any files were found
if ~isempty(files)
    % Load the first .mat file
    file_to_load = fullfile(filepathfinal, files(1).name);
    
    % Load the .mat file
    load(file_to_load);
    
    % Display a message indicating the file was loaded
    disp(['Loaded file: ', files(1).name]);
else
    % Display a message if no .mat files were found
    disp('No .mat files found');
end


%% Finding the Number of Modules During the Desired Phase 


% Find the rows of the Excel Sheet for the given participant,Arm,and phase

for k = 1:length(VAFPERMOD_EXCEL)
SelectedRowsExcel(k) = strcmp(VAFPERMOD_EXCEL{k,1},partid) & strcmp(VAFPERMOD_EXCEL{k,2},Arm) & strcmp(VAFPERMOD_EXCEL{k,3},Period_PostNMF); 
end

SelectedRowsFinal = find(SelectedRowsExcel ==1);

TotalNumMods = VAFPERMOD_EXCEL(SelectedRowsFinal(1),6);

TotalNumMods = cell2mat(TotalNumMods); % Total Number of Modules needed for the given participant in the given phase 


VAFsPERMOD = VAFPERMOD_EXCEL(SelectedRowsFinal,5);

%% Loading in the Right Part of NMF Structure For Number of Modules 

NmfFullMat_forGivenMod= nmf(TotalNumMods);

Weightings = NmfFullMat_forGivenMod.W;

end
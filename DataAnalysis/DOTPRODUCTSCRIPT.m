%% April 2025
%  K. Suvada

% Script used to grab muscle weightings,muscles recorded from,
% VAF per module, and number of modules needed for each time period

% Calls 'GrabMusWeighings.m' function 



[Weightings,TotalNumMods,VAFsPERMOD,musnames] = GrabMusWeightings(VAFPERMOD_EXCEL,PartCategory,partid,Arm,Period_PostNMF,Period_PreNMF,rowoffset,rowoffset2,MuscleIterations)

%% April 2025

% K. Suvada - needed to create separate function bc the nmf data files are
% all saved as nmf and can't use that in function GrabMusWeightings bc
% conflict with internal matlab nmf function.

function nmfDataCell = GrabNMFMAT(filepathfinal,partid)

files = dir(fullfile(filepathfinal, [partid '*']));

if ~isempty(files)
    file_to_load = fullfile(filepathfinal, files(1).name);
    
    load(file_to_load);
    
    disp(['Loaded file: ', files(1).name]);
else
    disp('No files found');
    
end

nmfDataCell= nmf;


end
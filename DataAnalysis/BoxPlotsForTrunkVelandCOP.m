% BoxPlots For all Participants 

% Generating For Velocity, Trunk Excursion, and Delta COP 

% Use to make each box plot a different color 

% Import EXCEL sheet with all participants and import as column vectors -
% AllData2024 has COP and TD,RD,SD,RDLL,TDLL,SDLL but need to open
% different worksheet for Velocities 

IndicesP = find(ARM == 'P');
IndicesNP = find(ARM == 'NP');
IndicesC = find(ARM == 'D');

%Controls_R
RTIS1003_R = find(ID == 'RTIS1003'& Restraint ==1);
RTIS1004_R = find(ID == 'RTIS1004'& Restraint ==1);
RTIS1005_R = find(ID == 'RTIS1005'& Restraint ==1);
RTIS1006_R = find(ID == 'RTIS1006'& Restraint ==1);

%Controls_U
RTIS1003_U = find(ID == 'RTIS1003'& Restraint ==0);
RTIS1004_U = find(ID == 'RTIS1004'& Restraint ==0);
RTIS1005_U = find(ID == 'RTIS1005'& Restraint ==0);
RTIS1006_U = find(ID == 'RTIS1006'& Restraint ==0);


Controls_R = [RTIS1003_R' RTIS1004_R' RTIS1005_R' RTIS1006_R'];
Controls_U = [RTIS1003_U' RTIS1004_U' RTIS1005_U' RTIS1006_U'];
%%

% Stroke_P_Restrained 
RTIS2001_P_R = find(ID == 'RTIS2001' & ARM == 'P' & Restraint ==1);
RTIS2002_P_R = find(ID == 'RTIS2002' & ARM =='P'& Restraint ==1);
RTIS2003_P_R = find(ID == 'RTIS2003' & ARM =='P'& Restraint ==1);
RTIS2006_P_R = find(ID == 'RTIS2006' & ARM =='P'& Restraint ==1);
RTIS2007_P_R = find(ID == 'RTIS2007' & ARM =='P'& Restraint ==1);
RTIS2008_P_R = find(ID == 'RTIS2008' & ARM =='P'& Restraint ==1);
RTIS2009_P_R = find(ID == 'RTIS2009' & ARM =='P'& Restraint ==1);
RTIS2010_P_R = find(ID == 'RTIS2010' & ARM =='P'& Restraint ==1);
RTIS2011_P_R = find(ID == 'RTIS2011' & ARM =='P'& Restraint ==1);

% Stroke_NP_Restained
RTIS2001_NP_R = find(ID == 'RTIS2001' & ARM == 'NP'& Restraint ==1);
RTIS2002_NP_R = find(ID == 'RTIS2002' & ARM =='NP'& Restraint ==1);
RTIS2003_NP_R = find(ID == 'RTIS2003' & ARM =='NP'& Restraint ==1);
RTIS2006_NP_R = find(ID == 'RTIS2006' & ARM =='NP'& Restraint ==1);
RTIS2007_NP_R = find(ID == 'RTIS2007' & ARM =='NP'& Restraint ==1);
RTIS2008_NP_R = find(ID == 'RTIS2008' & ARM =='NP'& Restraint ==1);
RTIS2009_NP_R = find(ID == 'RTIS2009' & ARM =='NP'& Restraint ==1);
RTIS2010_NP_R = find(ID == 'RTIS2010' & ARM =='NP'& Restraint ==1);
RTIS2011_NP_R = find(ID == 'RTIS2011' & ARM =='NP'& Restraint ==1);

%%

% Paretic_Unrestrained
RTIS2001_P_U = find(ID == 'RTIS2001' & ARM == 'P' & Restraint ==0);
RTIS2002_P_U = find(ID == 'RTIS2002' & ARM =='P'& Restraint ==0);
RTIS2003_P_U = find(ID == 'RTIS2003' & ARM =='P'& Restraint ==0);
RTIS2006_P_U = find(ID == 'RTIS2006' & ARM =='P'& Restraint ==0);
RTIS2007_P_U = find(ID == 'RTIS2007' & ARM =='P'& Restraint ==0);
RTIS2008_P_U = find(ID == 'RTIS2008' & ARM =='P'& Restraint ==0);
RTIS2009_P_U = find(ID == 'RTIS2009' & ARM =='P'& Restraint ==0);
RTIS2010_P_U = find(ID == 'RTIS2010' & ARM =='P'& Restraint ==0);
RTIS2011_P_U = find(ID == 'RTIS2011' & ARM =='P'& Restraint ==0);

% Stroke_NP_UnRestained
RTIS2001_NP_U = find(ID == 'RTIS2001' & ARM == 'NP'& Restraint ==0);
RTIS2002_NP_U = find(ID == 'RTIS2002' & ARM =='NP'& Restraint ==0);
RTIS2003_NP_U = find(ID == 'RTIS2003' & ARM =='NP'& Restraint ==0);
RTIS2006_NP_U = find(ID == 'RTIS2006' & ARM =='NP'& Restraint ==0);
RTIS2007_NP_U = find(ID == 'RTIS2007' & ARM =='NP'& Restraint ==0);
RTIS2008_NP_U = find(ID == 'RTIS2008' & ARM =='NP'& Restraint ==0);
RTIS2009_NP_U = find(ID == 'RTIS2009' & ARM =='NP'& Restraint ==0);
RTIS2010_NP_U = find(ID == 'RTIS2010' & ARM =='NP'& Restraint ==0);
RTIS2011_NP_U = find(ID == 'RTIS2011' & ARM =='NP'& Restraint ==0);

%%

% Selecting Designated Indicies

Paretic_Restrained = [RTIS2001_P_R' RTIS2002_P_R' RTIS2003_P_R' RTIS2006_P_R' RTIS2007_P_R'  RTIS2008_P_R' RTIS2009_P_R' RTIS2010_P_R' RTIS2011_P_R'];
%%
Paretic_Unrestrained = [RTIS2001_P_U' RTIS2002_P_U' RTIS2003_P_U' RTIS2006_P_U' RTIS2007_P_U' RTIS2008_P_U' RTIS2009_P_U' RTIS2010_P_U' RTIS2011_P_U'];
%%
NonParetic_Unrestrained = [RTIS2001_NP_U' RTIS2002_NP_U' RTIS2003_NP_U' RTIS2006_NP_U' RTIS2007_NP_U' RTIS2008_NP_U' RTIS2009_NP_U' RTIS2010_NP_U' RTIS2011_NP_U'];
 
NonParetic_Restrained = [RTIS2001_NP_R' RTIS2002_NP_R' RTIS2003_NP_R' RTIS2006_NP_R' RTIS2007_NP_R' RTIS2008_NP_R' RTIS2009_NP_R' RTIS2010_NP_R' RTIS2011_NP_R'];
%% Controls

TD_Controls_R = TD(Controls_R);
TD_Controls_U = TD(Controls_U);

COP_Controls_R = DeltaCOPMat2_whole(Controls_R);
COP_Controls_U = DeltaCOPMat2_whole(Controls_U);


%% Paretic

TD_Paretic_R = TD(Paretic_Restrained);
TD_Paretic_U = TD(Paretic_Unrestrained);

COP_Paretic_R = DeltaCOPMat2_whole(Paretic_Restrained);
COP_Paretic_U = DeltaCOPMat2_whole(Paretic_Unrestrained);


%% Non-Paretic 

TD_NonParetic_R = TD(NonParetic_Restrained);
TD_NonParetic_U = TD(NonParetic_Unrestrained);

COP_NonParetic_R = DeltaCOPMat2_whole(NonParetic_Restrained);
COP_NonParetic_U = DeltaCOPMat2_whole(NonParetic_Unrestrained);


%% 
% Define categorical x-axis labels for all groups
% xLabels = categorical({'Controls-R', 'Controls-U', 'NonParetic-R', 'NonParetic-U', 'Paretic-R', 'Paretic-U'});
% xLabels = reordercats(xLabels, {'Controls-R', 'Controls-U', 'NonParetic-R', 'NonParetic-U', 'Paretic-R', 'Paretic-U'}); % Ensure correct order

% Example average values for RD, TD, and SHD across all groups
avgValues = [mean(TD_Controls_R); % Controls-R
             mean(TD_Controls_U);  % Controls-U
             mean(TD_NonParetic_R);  % NonParetic-R
            
             mean(TD_NonParetic_U);  % NonParetic-U
             mean(TD_Paretic_R);  % Paretic-R
             mean(TD_Paretic_U)]; % Paretic-U

% Example standard errors (only for RD)
rdErrors = [std(TD_Controls_R); 
            std(TD_Controls_U);
            std(TD_NonParetic_R);
            std(TD_NonParetic_U);
            std(TD_Paretic_R);
            std(TD_Paretic_U)];  % Error bars for RD (first column only)

%%
% Combine all data points into one vector for plotting
allData = [TD_Controls_R/10; TD_Controls_U/10; TD_NonParetic_R/10; TD_NonParetic_U/10; TD_Paretic_R/10; TD_Paretic_U/10];
% Create a group identifier for plotting
groups = [ones(length(TD_Controls_R),1); ones(length(TD_Controls_U),1)*2; ones(length(TD_NonParetic_R),1)*3; ones(length(TD_NonParetic_U),1)*4; ones(length(TD_Paretic_R),1)*5; ones(length(TD_Paretic_U),1)*6];
%%
% Define the group colors


% Create a figure for the plot
figure;

% Plot all data points as black dots
hold on;
for i = 1:6
    scatter(ones(size(allData(groups == i))) * i, allData(groups == i), 'k'); % Plot each group's data points in black
end
%%

% Plot the box plots for each group
h = boxplot(allData, groups, 'Colors', 'k', 'Whisker', 1.5, 'Widths', 0.5, 'OutlierSize', 3);
hold on;

% Customize the box plot colors based on group
% Extract the box patch handles (these are in the 5th row of the h matrix)
boxHandles = h(5, :);  % Get all the box patches (boxes are in row 5 of the h array)

for i = 1:6
    if i == 1 || i == 2
        % Set the color to dark red for groups 1 and 2
        patch(get(boxHandles(i), 'XData'), get(boxHandles(i), 'YData'), 'g', 'FaceAlpha', 0.5);
    elseif i == 3 || i == 4
        % Set the color to orange for groups 3 and 4
        patch(get(boxHandles(i), 'XData'), get(boxHandles(i), 'YData'), [1, 0.647, 0], 'FaceAlpha', 0.5);
    elseif i == 5 || i == 6
        % Set the color to green for groups 5 and 6
        patch(get(boxHandles(i), 'XData'), get(boxHandles(i), 'YData'), 'r', 'FaceAlpha', 0.5);
    end
end


ylabel('Trunk Excursion (cm)');
xticks(1:6);
xticklabels({'Controls-R', 'Controls-U', 'NonParetic-R', 'NonParetic-U', 'Paretic-R', 'Paretic-U'});

% Display the plot
hold off;

%%

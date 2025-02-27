%% Script to Create Stacked Bar Plot with Error Bars (on RD) for all participants 

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
%%
% Kinematic Variables Normalized to LL

RD_Controls_R = RDLL(Controls_R);
RD_Controls_U = RDLL(Controls_U);

TD_Controls_R = TD_LL(Controls_R);
TD_Controls_U = TD_LL(Controls_U);

SHD_Controls_R = SHD_LL(Controls_R);
SHD_Controls_U = SHD_LL(Controls_U);
%%
RD_Paretic_R = RDLL(Paretic_Restrained);
RD_Paretic_U = RDLL(Paretic_Unrestrained);

TD_Paretic_R = TD_LL(Paretic_Restrained);
TD_Paretic_U = TD_LL(Paretic_Unrestrained);

SHD_Paretic_R = SHD_LL(Paretic_Restrained);
SHD_Paretic_U = SHD_LL(Paretic_Unrestrained);
%%
RD_NonParetic_R = RDLL(NonParetic_Restrained);
RD_NonParetic_U = RDLL(NonParetic_Unrestrained);

TD_NonParetic_R = TD_LL(NonParetic_Restrained);
TD_NonParetic_U = TD_LL(NonParetic_Unrestrained);

SHD_NonParetic_R = SHD_LL(NonParetic_Restrained);
SHD_NonParetic_U = SHD_LL(NonParetic_Unrestrained);
% Define categorical x-axis labels for all groups
% xLabels = categorical({'Controls-R', 'Controls-U', 'NonParetic-R', 'NonParetic-U', 'Paretic-R', 'Paretic-U'});
% xLabels = reordercats(xLabels, {'Controls-R', 'Controls-U', 'NonParetic-R', 'NonParetic-U', 'Paretic-R', 'Paretic-U'}); % Ensure correct order

% Example average values for RD, TD, and SHD across all groups
avgValues = [mean(RD_Controls_R), mean(TD_Controls_R), mean(SHD_Controls_R);  % Controls-R
             mean(RD_Controls_U), mean(TD_Controls_U), mean(SHD_Controls_U);  % Controls-U
             mean(RD_NonParetic_R), mean(TD_NonParetic_R), mean(SHD_NonParetic_R);  % NonParetic-R
             mean(RD_NonParetic_U), mean(TD_NonParetic_U), mean(SHD_NonParetic_U);  % NonParetic-U
             mean(RD_Paretic_R), mean(TD_Paretic_R), mean(SHD_Paretic_R);  % Paretic-R
             mean(RD_Paretic_U), mean(TD_Paretic_U), mean(SHD_Paretic_U)]; % Paretic-U

% Example standard errors (only for RD)
rdErrors = [std(RD_Controls_R); 
            std(RD_Controls_U);
            std(RD_NonParetic_R);
            std(RD_NonParetic_U);
            std(RD_Paretic_R);
            std(RD_Paretic_U)];  % Error bars for RD (first column only)

% FINAL STACKED BAR PLOT
figure;
barHandle = bar(avgValues, 'stacked');
hold on;

% Set specific colors for each stacked component
% RD = Medium Green, TD = Lighter Blue, SHD = Darker Orange
barHandle(1).FaceColor = [0.0, 0.5, 0.0];  % RD - Medium Green
barHandle(2).FaceColor = [0.0, 0.0, 0.8];  % TD - Lighter Blue
barHandle(3).FaceColor = [1.0, 0.549, 0.0];  % SHD - Darker Orange

% Extract x positions for error bars
xPos = barHandle(1).XEndPoints;  % X positions of bars

% Add error bars only for RD (first stacked component)
errorbar(xPos, avgValues(:,1), rdErrors, 'k', 'linestyle', 'none', 'linewidth', 3.5, 'CapSize', 10);

% Connect the error bars with lines
for i = 1:length(xPos)
    plot([xPos(i), xPos(i)], [avgValues(i,1) - rdErrors(i), avgValues(i,1) + rdErrors(i)], 'k-', 'LineWidth', 2);
end

% Add dividing lines to separate Controls, NonParetic, and Paretic groups
yLimits = ylim; % Get y-axis limits
xline(2.5, '--k', 'LineWidth', 2); % Line between Controls and NonParetic
xline(4.5, '--k', 'LineWidth', 2); % Line between NonParetic and Paretic

% % Add group labels above each group of bars
% text(1.5, yLimits(2) * 0.97, 'Controls', 'HorizontalAlignment', 'center', 'FontSize', 50, 'FontWeight', 'bold');
% text(3.5, yLimits(2) * 0.97, 'Non-Paretic', 'HorizontalAlignment', 'center', 'FontSize', 50, 'FontWeight', 'bold');
% text(5.5, yLimits(2) * 0.97, 'Paretic', 'HorizontalAlignment', 'center', 'FontSize', 50, 'FontWeight', 'bold');

% Customize plot
% ylabel('Reach (%LL)', 'FontSize', 75);
%legend({'Arm', 'Trunk', 'Shoulder'}, 'Location', 'Best', 'FontSize', 30);
% title('Composition of Reach', 'FontSize', 110);

% Adjust font size for axes
ax = gca;
 ax.FontSize = 50;  % Set font size for the entire axis

% Adjust x-axis labels to just 'R' and 'U'
% xticklabels({'R', 'U', 'R', 'U', 'R', 'U'});  % Set the labels as R, U, R, U, R, U

hold off;


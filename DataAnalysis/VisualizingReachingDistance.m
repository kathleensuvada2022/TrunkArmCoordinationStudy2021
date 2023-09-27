%% Reaching Distance Distribution

% Plotting all trials for reaching distance for both the paretic and
% non-paretic limb.

%% K. Suvada September 2023

% Loading in Excel File- Full Data Paretic and Non-Paretic Limb
uiopen('/Users/kcs762/Desktop/AllTrialsAugust2023/AllData_Stroke.xlsx',1)
% Important as cell array !

%  Participant ID
ID = string(AllDataStrokeParetic(:, 1));

% All Reaching Distances in mm - 
ReachingDistancesArray = cell2mat(AllDataStrokeParetic(:, 13));
ReachingDistancesArray = cell2mat(NonPareticEditedAUG2023(:, 14));

%Reaching Distance %LL 
RDLLArray= cell2mat(AllDataStrokeParetic(:, 14));
RDLLArray= cell2mat(NonPareticEditedAUG2023(:, 15));
%% Plotting Reaching Distances for all Participants and All Trials  

%Normalized to LL
figure()
plot(RDLLArray,'o')
ylim([0 100])
title('Reaching Distance Normalized- Non-Paretic','FontSize',24)
xlabel('Trial','FontSize',16)
ylabel('Reaching Distance % LL','FontSize',24)


% Raw Reaching Distance 
figure()
plot(ReachingDistancesArray,'o')
title('Reaching Distance Raw','FontSize',20)
xlabel('Trial','FontSize',16)
ylabel('Reaching Distance (mm)','FontSize',24)

%% Plotting Normal Distribution 
%Plotting Histogram of Data
figure()
data = zscore(RDLLArray);
histogram(data, 'Normalization', 'pdf');
hold on;

% Computing the PDF of the Normal Distribution
mu = mean(data);
sigma = std(data);
x = linspace(min(data), max(data), 100);
pdf_values = normpdf(x, mu, sigma);

% Plotting the Normal Distribution
plot(x, pdf_values, 'LineWidth',3);


title('Non-Paretic Limb','FontSize',24);
xlabel( ' Z Scored Reaching Distance %LL','FontSize',24);
ylabel('Probability Density','FontSize',24);
% legend('Data', 'Normal Distribution','FontSize',16);
grid on;

%% Plotting Individual Data 

participant = 'RTIS2001';
limb = 0 ; % paretic
cond = 1; 

RTIS2001Trials = find(PartIDArray == participant); %1:51
Trials_P = find(ARM ==0); % 1:430
Condition = find(Condition ==1);


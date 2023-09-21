%% Reaching Distance Distribution

% Plotting all trials for reaching distance for both the paretic and
% non-paretic limb.

% K. Suvada September 2023

% Loading in Excel File- Full Data
uiopen('/Users/kcs762/Desktop/AllTrialsAugust2023/AllData_Stroke.xlsx',1) 


% All Reaching Distances in mm
ReachingDistancesArray = table2array(AllDataStroke(:, 'ReachingDistance'));

%Reaching Distance %LL 
RDLLArray= table2array(AllDataStroke(:, 'RDLL'));

% Plotting Reaching Distances for all Trials 

%Normalized to LL
figure()
plot(RDLLArray,'o')
ylim([0 100])
title('Reaching Distance Normalized','FontSize',20)
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
data = RDLLArray;
histogram(data, 'Normalization', 'pdf');
hold on;

% Computing the PDF of the Normal Distribution
mu = mean(data);
sigma = std(data);
x = linspace(min(data), max(data), 100);
pdf_values = normpdf(x, mu, sigma);

% Plotting the Normal Distribution
plot(x, pdf_values, 'LineWidth', 2);


title('RDLL and Superimposed Normal Distribution','FontSize',24);
xlabel('Reaching Distance %LL','FontSize',24);
ylabel('Probability Density','FontSize',24);
legend('Data', 'Normal Distribution','FontSize',16);
grid on;







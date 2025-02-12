% Plotting VAFs (Mean Across Muscles)

% February 2025

% All Muscles (Trunk and Arm) Preparatory Period 


nmus = size(nmf,2);

%% VAF per Muscle with Error Bars 

figure(2)
VAFmus = []; VAFcond = [];
for ss=1:nmus
VAFmus = [VAFmus, nmf(ss).VAFmus];
VAFcond = [VAFcond, nmf(ss).VAFcond];
end


errorbar(1:nmus,mean(VAFmus),std(VAFmus),'Color', 'r','LineWidth',3)
hold on
 errorbar(1:nmus, mean(VAFmus), std(VAFmus), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
ylabel('Mean % VAF and Error per Muscle', 'FontSize', 35); 
yline(80)
xline(1)

ylim([50 105])


%% Plotting Average VAF for Controls, StrokeP, and Stroke NP

figure()
% Controls
errorbar(1,mean(MeanVAFControlsPrepAandT.VAFMod1(1:4)),std(MeanVAFControlsPrepAandT.VAFMod1(1:4)),'Color', 'g','LineWidth',3) % Mod 1
hold on
errorbar(1, mean(MeanVAFControlsPrepAandT.VAFMod1(1:4)), std(MeanVAFControlsPrepAandT.VAFMod1(1:4)), 'o', 'Color', 'g' , 'LineWidth', 4.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(2,mean(MeanVAFControlsPrepAandT.VAFMod2(1:4)),std(MeanVAFControlsPrepAandT.VAFMod2(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(2, mean(MeanVAFControlsPrepAandT.VAFMod2(1:4)), std(MeanVAFControlsPrepAandT.VAFMod2(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(3,mean(MeanVAFControlsPrepAandT.VAFMod3(1:4)),std(MeanVAFControlsPrepAandT.VAFMod3(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(3, mean(MeanVAFControlsPrepAandT.VAFMod3(1:4)), std(MeanVAFControlsPrepAandT.VAFMod3(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(4,mean(MeanVAFControlsPrepAandT.VAFMod4(1:4)),std(MeanVAFControlsPrepAandT.VAFMod4(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(4, mean(MeanVAFControlsPrepAandT.VAFMod4(1:4)), std(MeanVAFControlsPrepAandT.VAFMod4(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(5,mean(MeanVAFControlsPrepAandT.VAFMod5(1:4)),std(MeanVAFControlsPrepAandT.VAFMod5(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(5, mean(MeanVAFControlsPrepAandT.VAFMod5(1:4)), std(MeanVAFControlsPrepAandT.VAFMod5(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(6,mean(MeanVAFControlsPrepAandT.VAFMod6(1:4)),std(MeanVAFControlsPrepAandT.VAFMod6(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(6, mean(MeanVAFControlsPrepAandT.VAFMod6(1:4)), std(MeanVAFControlsPrepAandT.VAFMod6(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(7,mean(MeanVAFControlsPrepAandT.VAFMod7(1:4)),std(MeanVAFControlsPrepAandT.VAFMod7(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(7, mean(MeanVAFControlsPrepAandT.VAFMod7(1:4)), std(MeanVAFControlsPrepAandT.VAFMod7(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(8,mean(MeanVAFControlsPrepAandT.VAFMod8(1:4)),std(MeanVAFControlsPrepAandT.VAFMod8(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(8, mean(MeanVAFControlsPrepAandT.VAFMod8(1:4)), std(MeanVAFControlsPrepAandT.VAFMod8(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(9,mean(MeanVAFControlsPrepAandT.VAFMod9(1:4)),std(MeanVAFControlsPrepAandT.VAFMod9(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(9, mean(MeanVAFControlsPrepAandT.VAFMod9(1:4)), std(MeanVAFControlsPrepAandT.VAFMod9(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(10,mean(MeanVAFControlsPrepAandT.VAFMod10(1:4)),std(MeanVAFControlsPrepAandT.VAFMod10(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(10, mean(MeanVAFControlsPrepAandT.VAFMod10(1:4)), std(MeanVAFControlsPrepAandT.VAFMod10(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(11,mean(MeanVAFControlsPrepAandT.VAFMod11(1:4)),std(MeanVAFControlsPrepAandT.VAFMod11(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(11, mean(MeanVAFControlsPrepAandT.VAFMod11(1:4)), std(MeanVAFControlsPrepAandT.VAFMod11(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(12,mean(MeanVAFControlsPrepAandT.VAFMod12(1:4)),std(MeanVAFControlsPrepAandT.VAFMod12(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(12, mean(MeanVAFControlsPrepAandT.VAFMod12(1:4)), std(MeanVAFControlsPrepAandT.VAFMod12(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(13,mean(MeanVAFControlsPrepAandT.VAFMod13(1:4)),std(MeanVAFControlsPrepAandT.VAFMod13(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(13, mean(MeanVAFControlsPrepAandT.VAFMod13(1:4)), std(MeanVAFControlsPrepAandT.VAFMod13(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(14,mean(MeanVAFControlsPrepAandT.VAFMod14(1:4)),std(MeanVAFControlsPrepAandT.VAFMod14(1:4)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(15, mean(MeanVAFControlsPrepAandT.VAFMod15(1:4)), std(MeanVAFControlsPrepAandT.VAFMod15(1:4)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(15,mean(MeanVAFControlsPrepAandT.VAFMod15(1:4)),std(MeanVAFControlsPrepAandT.VAFMod15(1:4)),'Color', 'g','LineWidth',3) % Mod 1




% Stroke NP
errorbar(1,mean(MeanVAFControlsPrepAandT.VAFMod1(5:13)),std(MeanVAFControlsPrepAandT.VAFMod1(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
hold on
errorbar(1, mean(MeanVAFControlsPrepAandT.VAFMod1(5:13)), std(MeanVAFControlsPrepAandT.VAFMod1(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(2,mean(MeanVAFControlsPrepAandT.VAFMod2(5:13)),std(MeanVAFControlsPrepAandT.VAFMod2(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(2, mean(MeanVAFControlsPrepAandT.VAFMod2(5:13)), std(MeanVAFControlsPrepAandT.VAFMod2(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(3,mean(MeanVAFControlsPrepAandT.VAFMod3(5:13)),std(MeanVAFControlsPrepAandT.VAFMod3(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(3, mean(MeanVAFControlsPrepAandT.VAFMod3(5:13)), std(MeanVAFControlsPrepAandT.VAFMod3(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(4,mean(MeanVAFControlsPrepAandT.VAFMod4(5:13)),std(MeanVAFControlsPrepAandT.VAFMod4(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(4, mean(MeanVAFControlsPrepAandT.VAFMod4(5:13)), std(MeanVAFControlsPrepAandT.VAFMod4(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(5,mean(MeanVAFControlsPrepAandT.VAFMod5(5:13)),std(MeanVAFControlsPrepAandT.VAFMod5(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(5, mean(MeanVAFControlsPrepAandT.VAFMod5(5:13)), std(MeanVAFControlsPrepAandT.VAFMod5(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(6,mean(MeanVAFControlsPrepAandT.VAFMod6(5:13)),std(MeanVAFControlsPrepAandT.VAFMod6(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(6, mean(MeanVAFControlsPrepAandT.VAFMod6(5:13)), std(MeanVAFControlsPrepAandT.VAFMod6(5:13)), 'o', 'Color', '#FFA500', 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(7,mean(MeanVAFControlsPrepAandT.VAFMod7(5:13)),std(MeanVAFControlsPrepAandT.VAFMod7(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(7, mean(MeanVAFControlsPrepAandT.VAFMod7(5:13)), std(MeanVAFControlsPrepAandT.VAFMod7(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(8,mean(MeanVAFControlsPrepAandT.VAFMod8(5:13)),std(MeanVAFControlsPrepAandT.VAFMod8(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(8, mean(MeanVAFControlsPrepAandT.VAFMod8(5:13)), std(MeanVAFControlsPrepAandT.VAFMod8(5:13)), 'o', 'Color', 'g' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(9,mean(MeanVAFControlsPrepAandT.VAFMod9(5:13)),std(MeanVAFControlsPrepAandT.VAFMod9(5:13)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(9, mean(MeanVAFControlsPrepAandT.VAFMod9(5:13)), std(MeanVAFControlsPrepAandT.VAFMod9(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(10,mean(MeanVAFControlsPrepAandT.VAFMod10(5:13)),std(MeanVAFControlsPrepAandT.VAFMod10(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(10, mean(MeanVAFControlsPrepAandT.VAFMod10(5:13)), std(MeanVAFControlsPrepAandT.VAFMod10(5:13)), 'o', 'Color','#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(11,mean(MeanVAFControlsPrepAandT.VAFMod11(5:13)),std(MeanVAFControlsPrepAandT.VAFMod11(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(11, mean(MeanVAFControlsPrepAandT.VAFMod11(5:13)), std(MeanVAFControlsPrepAandT.VAFMod11(5:13)), 'o', 'Color','#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(12,mean(MeanVAFControlsPrepAandT.VAFMod12(5:13)),std(MeanVAFControlsPrepAandT.VAFMod12(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(12, mean(MeanVAFControlsPrepAandT.VAFMod12(5:13)), std(MeanVAFControlsPrepAandT.VAFMod12(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(13,mean(MeanVAFControlsPrepAandT.VAFMod13(5:13)),std(MeanVAFControlsPrepAandT.VAFMod13(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(13, mean(MeanVAFControlsPrepAandT.VAFMod13(5:13)), std(MeanVAFControlsPrepAandT.VAFMod13(5:13)), 'o', 'Color','#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(14,mean(MeanVAFControlsPrepAandT.VAFMod14(5:13)),std(MeanVAFControlsPrepAandT.VAFMod14(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1
errorbar(15, mean(MeanVAFControlsPrepAandT.VAFMod15(5:13)), std(MeanVAFControlsPrepAandT.VAFMod15(5:13)), 'o', 'Color', '#FFA500' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(15,mean(MeanVAFControlsPrepAandT.VAFMod15(5:13)),std(MeanVAFControlsPrepAandT.VAFMod15(5:13)),'Color', '#FFA500','LineWidth',3) % Mod 1

% Stroke P
errorbar(1,mean(MeanVAFControlsPrepAandT.VAFMod1(14:end)),std(MeanVAFControlsPrepAandT.VAFMod1(14:end)),'Color', 'r','LineWidth',3) % Mod 1
hold on
errorbar(1, mean(MeanVAFControlsPrepAandT.VAFMod1(14:end)), std(MeanVAFControlsPrepAandT.VAFMod1(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(2,mean(MeanVAFControlsPrepAandT.VAFMod2(14:end)),std(MeanVAFControlsPrepAandT.VAFMod2(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(2, mean(MeanVAFControlsPrepAandT.VAFMod2(14:end)), std(MeanVAFControlsPrepAandT.VAFMod2(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(3,mean(MeanVAFControlsPrepAandT.VAFMod3(14:end)),std(MeanVAFControlsPrepAandT.VAFMod3(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(3, mean(MeanVAFControlsPrepAandT.VAFMod3(14:end)), std(MeanVAFControlsPrepAandT.VAFMod3(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(4,mean(MeanVAFControlsPrepAandT.VAFMod4(14:end)),std(MeanVAFControlsPrepAandT.VAFMod4(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(4, mean(MeanVAFControlsPrepAandT.VAFMod4(14:end)), std(MeanVAFControlsPrepAandT.VAFMod4(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(5,mean(MeanVAFControlsPrepAandT.VAFMod5(14:end)),std(MeanVAFControlsPrepAandT.VAFMod5(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(5, mean(MeanVAFControlsPrepAandT.VAFMod5(14:end)), std(MeanVAFControlsPrepAandT.VAFMod5(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(6,mean(MeanVAFControlsPrepAandT.VAFMod6(14:end)),std(MeanVAFControlsPrepAandT.VAFMod6(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(6, mean(MeanVAFControlsPrepAandT.VAFMod6(14:end)), std(MeanVAFControlsPrepAandT.VAFMod6(14:end)), 'o', 'Color', 'r', 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(7,mean(MeanVAFControlsPrepAandT.VAFMod7(14:end)),std(MeanVAFControlsPrepAandT.VAFMod7(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(7, mean(MeanVAFControlsPrepAandT.VAFMod7(14:end)), std(MeanVAFControlsPrepAandT.VAFMod7(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(8,mean(MeanVAFControlsPrepAandT.VAFMod8(14:end)),std(MeanVAFControlsPrepAandT.VAFMod8(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(8, mean(MeanVAFControlsPrepAandT.VAFMod8(14:end)), std(MeanVAFControlsPrepAandT.VAFMod8(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(9,mean(MeanVAFControlsPrepAandT.VAFMod9(14:end)),std(MeanVAFControlsPrepAandT.VAFMod9(14:end)),'Color', 'g','LineWidth',3) % Mod 1
errorbar(9, mean(MeanVAFControlsPrepAandT.VAFMod9(14:end)), std(MeanVAFControlsPrepAandT.VAFMod9(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(10,mean(MeanVAFControlsPrepAandT.VAFMod10(14:end)),std(MeanVAFControlsPrepAandT.VAFMod10(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(10, mean(MeanVAFControlsPrepAandT.VAFMod10(14:end)), std(MeanVAFControlsPrepAandT.VAFMod10(14:end)), 'o', 'Color','r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(11,mean(MeanVAFControlsPrepAandT.VAFMod11(14:end)),std(MeanVAFControlsPrepAandT.VAFMod11(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(11, mean(MeanVAFControlsPrepAandT.VAFMod11(14:end)), std(MeanVAFControlsPrepAandT.VAFMod11(14:end)), 'o', 'Color','r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(12,mean(MeanVAFControlsPrepAandT.VAFMod12(14:end)),std(MeanVAFControlsPrepAandT.VAFMod12(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(12, mean(MeanVAFControlsPrepAandT.VAFMod12(14:end)), std(MeanVAFControlsPrepAandT.VAFMod12(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(13,mean(MeanVAFControlsPrepAandT.VAFMod13(14:end)),std(MeanVAFControlsPrepAandT.VAFMod13(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(13, mean(MeanVAFControlsPrepAandT.VAFMod13(14:end)), std(MeanVAFControlsPrepAandT.VAFMod13(14:end)), 'o', 'Color','r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(14,mean(MeanVAFControlsPrepAandT.VAFMod14(14:end)),std(MeanVAFControlsPrepAandT.VAFMod14(14:end)),'Color', 'r','LineWidth',3) % Mod 1
errorbar(15, mean(MeanVAFControlsPrepAandT.VAFMod15(14:end)), std(MeanVAFControlsPrepAandT.VAFMod15(14:end)), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
errorbar(15,mean(MeanVAFControlsPrepAandT.VAFMod15(14:end)),std(MeanVAFControlsPrepAandT.VAFMod15(14:end)),'Color', 'r','LineWidth',3) % Mod 1

title('AVG VAF vs Module Number (C,P,NP)','FontSize',50)
yline(80)
ylim([70 100])
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20
%%
 errorbar(1:15, mean(VAFmus), std(VAFmus), 'o', 'Color', 'r' , 'LineWidth', 2.5, 'MarkerSize', 8); % Dark green color, thicker line
ax = gca; % Get current axes


%% Chat GPT 
% Extract means for Controls
x = 1:15;
y_controls = [
    mean(MeanVAFControlsPrepAandT.VAFMod1(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod2(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod3(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod4(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod5(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod6(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod7(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod8(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod9(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod10(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod11(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod12(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod13(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod14(1:4)), 
    mean(MeanVAFControlsPrepAandT.VAFMod15(1:4))
];

% Extract means for Stroke NP
y_stroke_np = [
    mean(MeanVAFControlsPrepAandT.VAFMod1(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod2(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod3(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod4(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod5(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod6(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod7(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod8(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod9(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod10(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod11(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod12(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod13(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod14(5:13)), 
    mean(MeanVAFControlsPrepAandT.VAFMod15(5:13))
];

% Extract means for Stroke P
y_stroke_p = [
    mean(MeanVAFControlsPrepAandT.VAFMod1(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod2(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod3(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod4(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod5(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod6(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod7(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod8(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod9(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod10(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod11(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod12(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod13(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod14(14:end)), 
    mean(MeanVAFControlsPrepAandT.VAFMod15(14:end))
];

% Standard deviations for error bars
err_controls = [
    std(MeanVAFControlsPrepAandT.VAFMod1(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod2(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod3(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod4(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod5(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod6(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod7(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod8(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod9(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod10(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod11(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod12(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod13(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod14(1:4)), 
    std(MeanVAFControlsPrepAandT.VAFMod15(1:4))
];

err_stroke_np = [
    std(MeanVAFControlsPrepAandT.VAFMod1(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod2(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod3(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod4(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod5(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod6(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod7(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod8(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod9(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod10(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod11(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod12(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod13(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod14(5:13)), 
    std(MeanVAFControlsPrepAandT.VAFMod15(5:13))
];

err_stroke_p = [
    std(MeanVAFControlsPrepAandT.VAFMod1(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod2(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod3(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod4(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod5(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod6(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod7(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod8(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod9(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod10(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod11(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod12(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod13(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod14(14:end)), 
    std(MeanVAFControlsPrepAandT.VAFMod15(14:end))
];


figure; hold on;
% Plot lines connecting error bar points
plot(x, y_controls, '-g', 'LineWidth', 4);
plot(x, y_stroke_np, '-','Color', '#FFA500', 'LineWidth', 4);
plot(x, y_stroke_p, '-','Color', 'r', 'LineWidth', 4);

% Plot error bars
errorbar(x, y_controls, err_controls, 'g', 'LineWidth', 4);
errorbar(x, y_stroke_np, err_stroke_np, 'Color', '#FFA500', 'LineWidth', 4);
errorbar(x, y_stroke_p, err_stroke_p, 'Color', 'r', 'LineWidth', 4);

% Customize the figure
xlabel('Module Number','FontSize',25);
ylabel('%VAF Across Individual Muscles','FontSize',25);
title('Mean VAF Across Participants (C,P,NP)','FontSize',35);
legend({'Controls', 'Stroke NP','Stroke P'}, 'Location', 'Best','FontSize',25);
grid on;
hold off;
% yline(80)
ylim([70 100])
ax = gca; % Get current axes
ax.FontSize = 35; % Set axes font size to 20

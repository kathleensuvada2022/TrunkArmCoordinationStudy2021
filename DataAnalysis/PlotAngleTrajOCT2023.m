%% October 2023

% Function to plot the average Angle/Angle (Shoudler Flexion/Extension
% Angle vs Elbow Flexion/Extension) trajectory from every condition. Have X
% values(Shoulder) and Y values (Elbow) x 6 Conditions that is the average
% for all participants.

% Need to Add Filepath etc loading in here: 

function  PlotAngleTrajOCT2023(AVGXCOND1_FINAL,AVGXCOND2_FINAL,AVGXCOND3_FINAL,AVGXCOND4_FINAL,AVGXCOND5_FINAL,AVGXCOND6_FINAL,AVGYCOND1_FINAL,AVGYCOND2_FINAL,AVGYCOND3_FINAL,AVGYCOND4_FINAL,AVGYCOND5_FINAL,AVGYCOND6_FINAL)

% Restrained -Red
plot(AVGXCOND1_FINAL+30,AVGYCOND1_FINAL+90,'Linewidth', 3,'Color','r')

hold on
plot(AVGXCOND2_FINAL+30,AVGYCOND2_FINAL+90,'Linewidth', 9,'Color','r')
plot(AVGXCOND3_FINAL+30,AVGYCOND3_FINAL+90,'Linewidth', 10.5,'Color','r')

% Unrestrained- Green
plot(AVGXCOND4_FINAL+30,AVGYCOND4_FINAL+90, 'Linewidth', 3,'Color','b')
plot(AVGXCOND5_FINAL+30,AVGYCOND5_FINAL+90,'Linewidth', 9,'Color','b')
plot(AVGXCOND6_FINAL+30,AVGYCOND6_FINAL+90,'Linewidth', 10.5,'Color','b')

% legend('Trunk Restrained Table','Trunk Restrained 25','Trunk Restrained 50','Trunk Unrestrained Table','Trunk Unrestrained 25','Trunk Unrestrained 50','FontSize',20)
xlabel('← Shoulder Extension | Flexion → (°)','FontSize',24)
ylabel('← Elbow Flexion | Extension → (°)','FontSize',24)
% title('Elbow Flexion/Extension vs Shoulder Flexion/Extension: Controls (N=4)','FontSize',32)
axis equal

% Define the center and radius of the circle
 center = [30, 90];  % Center coordinates [x, y]
 radius = 5;       % Radius of the circle
% % Plot the circle using viscircles
 viscircles(center, radius, 'EdgeColor', [0.4660 0.6740 0.1880]);

 xlim([0 80])
 ylim([85 150])


%% Computing Slope of Lines 


%Slope Cond 1
slope1 = (AVGYCOND1_FINAL(end)-AVGYCOND1_FINAL(1))/(AVGXCOND1_FINAL(end)-AVGXCOND1_FINAL(1));

%Slope Cond 2
slope2 = (AVGYCOND2_FINAL(end)-AVGYCOND2_FINAL(1))/(AVGXCOND2_FINAL(end)-AVGXCOND2_FINAL(1));

%Slope Cond 3
slope3 = (AVGYCOND3_FINAL(end)-AVGYCOND3_FINAL(1))/(AVGXCOND3_FINAL(end)-AVGXCOND3_FINAL(1));

%Slope Cond 4
slope4 = (AVGYCOND4_FINAL(end)-AVGYCOND4_FINAL(1))/(AVGXCOND4_FINAL(end)-AVGXCOND4_FINAL(1));

%Slope Cond 5
slope5 = (AVGYCOND5_FINAL(end)-AVGYCOND5_FINAL(1))/(AVGXCOND5_FINAL(end)-AVGXCOND5_FINAL(1));

%Slope Cond 6
slope6 = (AVGYCOND6_FINAL(end)-AVGYCOND6_FINAL(1))/(AVGXCOND6_FINAL(end)-AVGXCOND6_FINAL(1));



% text(60, 120, sprintf('Slope 1: %.2f', slope1), 'FontSize', 16, 'Color', 'black');
% text(60, 115, sprintf('Slope 2: %.2f', slope2), 'FontSize', 16, 'Color', 'black');
% text(60, 110, sprintf('Slope 3: %.2f', slope3), 'FontSize', 16, 'Color', 'black');
% text(60, 105, sprintf('Slope 4: %.2f', slope4), 'FontSize', 16, 'Color', 'black');
% text(60, 100, sprintf('Slope 5: %.2f', slope5), 'FontSize', 16, 'Color', 'black');
% text(60, 95, sprintf('Slope 6: %.2f', slope6), 'FontSize', 16, 'Color', 'black');


end
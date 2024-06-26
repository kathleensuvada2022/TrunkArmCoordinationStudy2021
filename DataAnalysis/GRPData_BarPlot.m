% June 2022 K. Suvada

% Bar plot to plot individual means, group means, and SE for group for
% condition. Pass in vector with each participants avg RD for a condition.
% Then pass in each group mean and SE for the whole group. 

% Plot for one loading condition (stroke and controls)



function GRPData_BarPlot(Individ_Means_1,Individ_Means_2,Individ_Means_3,Individ_Means_4,Individ_Means_5,Individ_Means_6,RD_Cond1,SE_Cond1,RD_Cond2,SE_Cond2,RD_Cond3,SE_Cond3,RD_Cond4,SE_Cond4,RD_Cond5,SE_Cond5,RD_Cond6,SE_Cond6)

figure(1)
hold on

NParticipants = length(Individ_Means_1); %Gives Number of Participants 
%% Controls
p1 =errorbar([5 6],[RD_Cond2 RD_Cond5],[SE_Cond2 SE_Cond5],'k','LineWidth',2); % Table restrained vs unrestrained Controls
p2 = plot(5,Individ_Means_2,'s','Color','b','Linewidth',2);
p3 = plot(6,Individ_Means_5,'s','Color','b','Linewidth',2);
%% Stroke - Paretic
p4 =errorbar([1 2],[RD_Cond2 RD_Cond5],[SE_Cond2 SE_Cond5],'k','LineWidth',2); %  restrained vs unrestrained 
p5 = plot(1,Individ_Means_2,'s','Color',[0.4940 0.1840 0.5560],'Linewidth',2);
p6 = plot(2,Individ_Means_5,'s','Color',[0.4940 0.1840 0.5560],'Linewidth',2);
 %% Stroke - Non Paretic
p7 =errorbar([3 4],[RD_Cond3 RD_Cond6],[SE_Cond3 SE_Cond6],'k','LineWidth',2); %  restrained vs unrestrained 
p8 = plot(3,Individ_Means_3,'s','Color',[0.9290 0.6940 0.1250],'Linewidth',2);
p9 = plot(4,Individ_Means_6,'s','Color',[0.9290 0.6940 0.1250],'Linewidth',2);




%% Axis Setting 
xlim([0 7])
ax=gca;
xticklabels({' ', 'Stroke (P)-REST', 'Stroke (P)-UNREST','Stroke (NP)-REST', 'Stroke (NP)-UNREST','Controls-REST' ,'Controls-UNREST'})
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([0 105])
title('Reaching Distance-25% MVT ','FontSize',28)
ylabel('Reaching Distance (%LL)','FontSize',20)



%% Wait until have Controls,Stroke P and Stroke NP
h = [p2(1);p5(1);p8(1)];
% legend(p5(1), 'Stroke-Paretic','FontSize',16)
legend(h,'Controls','Stroke:Paretic','Stroke:Non-Paretic','FontSize',24)

end


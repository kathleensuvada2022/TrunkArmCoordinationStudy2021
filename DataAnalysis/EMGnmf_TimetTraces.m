%% October 2024

% Plotting the Raw EMG Data and comparing the traces across trials and
% conditions

MUSC = {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};

 IDL = 15;
 TRI = 14 ;
 BIC = 13 ; 
 PM  = 12 ;
 LD =  11 ;
 MT = 10;
 UT = 9;


%% Cut the EMG Data 
% Aligning the data st you are grabbing 1500 samples prior to max velocity
% through 1500 samples post the max velocity.

% Doing this within a given condition for all trials. 

Newindicies = zeros(51,3001);
NewMaxVelLocs = zeros(1,51);

% Looping through all Trials and saving cut EMG data such that they are now
% aligned at the max velocity 
for j = 1:length(NNMFstruc)
Newindicies(j,:) = NNMFstruc(j).velidx_EMG-1500:NNMFstruc(j).velidx_EMG+1500;
NewMaxVelLocs(j) = find(Newindicies(j,:) == NNMFstruc(j).velidx_EMG);

if NNMFstruc(j).velidx_EMG+1500 > 5000
   EndidxCut = 5000;
else 
    EndidxCut = NNMFstruc(j).velidx_EMG+1500;
end 

if NNMFstruc(j).velidx_EMG-1500 < 1
   StartidxCut = 1;
else 
    StartidxCut = NNMFstruc(j).velidx_EMG-1500;
end 

NNMFstruc(j).emgcut = NNMFstruc(j).emgTrace(StartidxCut:EndidxCut,:);
end

%% Aligning the velocity data

% Doing this within a given condition for all trials. 

% Newindicies_vel = zeros(51,3001);
% NewMaxVelLocs_vel = zeros(1,51);
% 
% % Looping through all Trials and saving cut EMG data such that they are now
% % aligned at the max velocity 
% for j = 1:length(NNMFstruc)
% Newindicies_vel(j,:) = NNMFstruc(j).velidx_EMG-1500:NNMFstruc(j).velidx_EMG+1500;
% NewMaxVelLocs(j) = find(Newindicies(j,:) == NNMFstruc(j).velidx_EMG);
% 
% if NNMFstruc(j).velidx_EMG+1500 > 5000
%    EndidxCut = 5000;
% else 
%     EndidxCut = NNMFstruc(j).velidx_EMG+1500;
% end 
% 
% if NNMFstruc(j).velidx_EMG-1500 < 1
%    StartidxCut = 1;
% else 
%     StartidxCut = NNMFstruc(j).velidx_EMG-1500;
% end 
% 
% NNMFstruc(j).emgcut = NNMFstruc(j).emgTrace(StartidxCut:EndidxCut,:);
% end
% 


%%
% Separating the Structure by Condition

Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);

 IDL = 15;
 TRI = 14 ;
 BIC = 13 ; 
 PM  = 12 ;
 LD =  11 ;
 MT = 10;
 UT = 9;



%% Plotting the Averages and Errors for Muscle Activations

%% UN CUT RAW EMG WITHOUT ALIGNING IN TIME OR ANYTHING. Shows the entire 5 seconds of trial data %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Condition 1: 7 trials total 

UT_alltrials_Cond1 = [Cond1(1).emgTrace(:,9) Cond1(2).emgTrace(:,9) Cond1(3).emgTrace(:,9) Cond1(4).emgTrace(:,9) Cond1(5).emgTrace(:,9) Cond1(6).emgTrace(:,9) Cond1(7).emgTrace(:,9)];
MT_alltrials_Cond1 = [Cond1(1).emgTrace(:,10) Cond1(2).emgTrace(:,10) Cond1(3).emgTrace(:,10) Cond1(4).emgTrace(:,10) Cond1(5).emgTrace(:,10) Cond1(6).emgTrace(:,10) Cond1(7).emgTrace(:,10)];
LD_alltrials_Cond1 = [Cond1(1).emgTrace(:,11) Cond1(2).emgTrace(:,11) Cond1(3).emgTrace(:,11) Cond1(4).emgTrace(:,11) Cond1(5).emgTrace(:,11) Cond1(6).emgTrace(:,11) Cond1(7).emgTrace(:,11)];
PM_alltrials_Cond1 = [Cond1(1).emgTrace(:,12) Cond1(2).emgTrace(:,12) Cond1(3).emgTrace(:,12) Cond1(4).emgTrace(:,12) Cond1(5).emgTrace(:,12) Cond1(6).emgTrace(:,12) Cond1(7).emgTrace(:,12)];
BIC_alltrials_Cond1 = [Cond1(1).emgTrace(:,13) Cond1(2).emgTrace(:,13) Cond1(3).emgTrace(:,13) Cond1(4).emgTrace(:,13) Cond1(5).emgTrace(:,13) Cond1(6).emgTrace(:,13) Cond1(7).emgTrace(:,13)];
TRI_alltrials_Cond1 = [Cond1(1).emgTrace(:,14) Cond1(2).emgTrace(:,14) Cond1(3).emgTrace(:,14) Cond1(4).emgTrace(:,14) Cond1(5).emgTrace(:,14) Cond1(6).emgTrace(:,14) Cond1(7).emgTrace(:,14)];
IDL_alltrials_Cond1 = [Cond1(1).emgTrace(:,15) Cond1(2).emgTrace(:,15) Cond1(3).emgTrace(:,15) Cond1(4).emgTrace(:,15) Cond1(5).emgTrace(:,15) Cond1(6).emgTrace(:,15) Cond1(7).emgTrace(:,15)];


% Metria: 500 samples = 5 seconds

 % Avg time max vel occurs 

 MeanMaxVel = mean([Cond1(1).TimestartTimeVelTimeEnd(2),Cond1(2).TimestartTimeVelTimeEnd(2),Cond1(3).TimestartTimeVelTimeEnd(2),Cond1(4).TimestartTimeVelTimeEnd(2),Cond1(5).TimestartTimeVelTimeEnd(2),Cond1(6).TimestartTimeVelTimeEnd(2),Cond1(7).TimestartTimeVelTimeEnd(2)])

%Velocity 
figure()
subplot(1,2,1)
plot(Cond1(1).tmet,smooth(Cond1(1).vel)/1000,'k','LineWidth',2)
hold on
 xline(MeanMaxVel,'m','LineWidth',2)

plot(Cond1(2).tmet,smooth(Cond1(2).vel)/1000,'k','LineWidth',2)
plot(Cond1(3).tmet,smooth(Cond1(3).vel)/1000,'k','LineWidth',2)
plot(Cond1(4).tmet,smooth(Cond1(4).vel)/1000,'k', 'LineWidth',2)
plot(Cond1(5).tmet,smooth(Cond1(5).vel)/1000,'k','LineWidth',2)
plot(Cond1(6).tmet,smooth(Cond1(6).vel)/1000,'k','LineWidth',2)
plot(Cond1(7).tmet,smooth(Cond1(7).vel)/1000,'k','LineWidth',2)
ylabel('Velocity (m/s)','FontSize',18)
yyaxis right
plot(Cond1(1).tmet,Cond1(1).dist/1000,'b-','LineWidth',.75)
hold on
plot(Cond1(2).tmet,Cond1(2).dist/1000,'b-','LineWidth',.75)
plot(Cond1(3).tmet,Cond1(3).dist/1000,'b-', 'LineWidth',.75)
plot(Cond1(4).tmet,Cond1(4).dist/1000,'b-','LineWidth',.75)
plot(Cond1(5).tmet,Cond1(5).dist/1000,'b-','LineWidth',.75)
plot(Cond1(6).tmet,Cond1(6).dist/1000,'b-','LineWidth',.75)
plot(Cond1(7).tmet,Cond1(7).dist/1000,'b-','LineWidth',.75)
ylabel('Distance (m)','FontSize',18)
xlim([0 5])
xlabel('Time (seconds)','FontSize',18)
title('Condition 1','FontSize',25)


subplot(1,2,2)

%  plot(Cond1(1).emgtimevec,(UT_alltrials_Cond1(:,:)),'b','LineWidth',1)
% plot(Cond1(1).emgtimevec,(MT_alltrials_Cond1(:,:)),'b','LineWidth',1)
plot(Cond1(1).emgtimevec,smoothdata(LD_alltrials_Cond1(:,:)),'b','LineWidth',1)
% plot(Cond1(1).emgtimevec,(PM_alltrials_Cond1(:,:)),'b','LineWidth',1)
% plot(Cond1(1).emgtimevec,(BIC_alltrials_Cond1(:,:)),'b','LineWidth',1)
%plot(Cond1(1).emgtimevec,(TRI_alltrials_Cond1(:,:)),'b','LineWidth',1)
% plot(Cond1(1).emgtimevec,(IDL_alltrials_Cond1(:,:)),'b','LineWidth',1)

 xline(MeanMaxVel,'m','LineWidth',2)
% xline(Cond1(2).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond1(3).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond1(4).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond1(5).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond1(6).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
% xline(Cond1(7).TimestartTimeVelTimeEnd(2),'m','LineWidth',2)
xlabel('Time (seconds)','FontSize',18)
ylabel('Muscle Activation (mv)','FontSize',18)
title('Condition 1- LD','FontSize',25)
%%
% Mean trace for all trials in condition 1 : size is 3000x1
meanUT_Cond1 = mean(UT_alltrials_Cond1,2); 
meanMT_Cond1 = mean(MT_alltrials_Cond1,2); 
meanLD_Cond1 = mean(LD_alltrials_Cond1,2); 
meanPM_Cond1 = mean(PM_alltrials_Cond1,2); 
meanBIC_Cond1 = mean(BIC_alltrials_Cond1,2); 
meanTRI_Cond1 = mean(TRI_alltrials_Cond1,2); 
meanIDL_Cond1 = mean(IDL_alltrials_Cond1,2); 


%% Condition 1: 7 trials total 

UT_alltrials_Cond1 = [Cond1(1).emgcut(:,9) Cond1(2).emgcut(:,9) Cond1(3).emgcut(:,9) Cond1(4).emgcut(:,9) Cond1(5).emgcut(:,9) Cond1(6).emgcut(:,9) Cond1(7).emgcut(:,9)];
MT_alltrials_Cond1 = [Cond1(1).emgcut(:,10) Cond1(2).emgcut(:,10) Cond1(3).emgcut(:,10) Cond1(4).emgcut(:,10) Cond1(5).emgcut(:,10) Cond1(6).emgcut(:,10) Cond1(7).emgcut(:,10)];
LD_alltrials_Cond1 = [Cond1(1).emgcut(:,11) Cond1(2).emgcut(:,11) Cond1(3).emgcut(:,11) Cond1(4).emgcut(:,11) Cond1(5).emgcut(:,11) Cond1(6).emgcut(:,11) Cond1(7).emgcut(:,11)];
PM_alltrials_Cond1 = [Cond1(1).emgcut(:,12) Cond1(2).emgcut(:,12) Cond1(3).emgcut(:,12) Cond1(4).emgcut(:,12) Cond1(5).emgcut(:,12) Cond1(6).emgcut(:,12) Cond1(7).emgcut(:,12)];
BIC_alltrials_Cond1 = [Cond1(1).emgcut(:,13) Cond1(2).emgcut(:,13) Cond1(3).emgcut(:,13) Cond1(4).emgcut(:,13) Cond1(5).emgcut(:,13) Cond1(6).emgcut(:,13) Cond1(7).emgcut(:,13)];
TRI_alltrials_Cond1 = [Cond1(1).emgcut(:,14) Cond1(2).emgcut(:,14) Cond1(3).emgcut(:,14) Cond1(4).emgcut(:,14) Cond1(5).emgcut(:,14) Cond1(6).emgcut(:,14) Cond1(7).emgcut(:,14)];
IDL_alltrials_Cond1 = [Cond1(1).emgcut(:,15) Cond1(2).emgcut(:,15) Cond1(3).emgcut(:,15) Cond1(4).emgcut(:,15) Cond1(5).emgcut(:,15) Cond1(6).emgcut(:,15) Cond1(7).emgcut(:,15)];

% Mean trace for all trials in condition 1 : size is 3000x1
meanUT_Cond1 = mean(UT_alltrials_Cond1,2); 
meanMT_Cond1 = mean(MT_alltrials_Cond1,2); 
meanLD_Cond1 = mean(LD_alltrials_Cond1,2); 
meanPM_Cond1 = mean(PM_alltrials_Cond1,2); 
meanBIC_Cond1 = mean(BIC_alltrials_Cond1,2); 
meanTRI_Cond1 = mean(TRI_alltrials_Cond1,2); 
meanIDL_Cond1 = mean(IDL_alltrials_Cond1,2); 

% Velocity




%%

% Condition 2 - 9 trials  (Kacey ommitted 5 bc issue FIX later)
UT_alltrials_Cond2 = [Cond2(1).emgcut(:,9) Cond2(2).emgcut(:,9) Cond2(3).emgcut(:,9) Cond2(4).emgcut(:,9) Cond2(6).emgcut(:,9) Cond2(7).emgcut(:,9) Cond2(8).emgcut(:,9) Cond2(9).emgcut(:,9) Cond2(10).emgcut(:,9)];
MT_alltrials_Cond2 = [Cond2(1).emgcut(:,10) Cond2(2).emgcut(:,10) Cond2(3).emgcut(:,10) Cond2(4).emgcut(:,10) Cond2(6).emgcut(:,10) Cond2(7).emgcut(:,10) Cond2(8).emgcut(:,10) Cond2(9).emgcut(:,10) Cond2(10).emgcut(:,10)];
LD_alltrials_Cond2= [Cond2(1).emgcut(:,11) Cond2(2).emgcut(:,11) Cond2(3).emgcut(:,11) Cond2(4).emgcut(:,11) Cond2(6).emgcut(:,11) Cond2(7).emgcut(:,11) Cond2(8).emgcut(:,11) Cond2(9).emgcut(:,11) Cond2(10).emgcut(:,11)];
PM_alltrials_Cond2 = [Cond2(1).emgcut(:,12) Cond2(2).emgcut(:,12) Cond2(3).emgcut(:,12) Cond2(4).emgcut(:,12) Cond2(6).emgcut(:,12) Cond2(7).emgcut(:,12) Cond2(8).emgcut(:,12) Cond2(9).emgcut(:,12) Cond2(10).emgcut(:,12)];
BIC_alltrials_Cond2 = [Cond2(1).emgcut(:,13) Cond2(2).emgcut(:,13) Cond2(3).emgcut(:,13) Cond2(4).emgcut(:,13) Cond2(6).emgcut(:,13) Cond2(7).emgcut(:,13) Cond2(8).emgcut(:,13) Cond2(9).emgcut(:,13) Cond2(10).emgcut(:,13)];
TRI_alltrials_Cond2  = [Cond2(1).emgcut(:,14) Cond2(2).emgcut(:,14) Cond2(3).emgcut(:,14) Cond2(4).emgcut(:,14) Cond2(6).emgcut(:,14) Cond2(7).emgcut(:,14) Cond2(8).emgcut(:,14) Cond2(9).emgcut(:,14) Cond2(10).emgcut(:,14)];
IDL_alltrials_Cond2 = [Cond2(1).emgcut(:,15) Cond2(2).emgcut(:,15) Cond2(3).emgcut(:,15) Cond2(4).emgcut(:,15) Cond2(6).emgcut(:,15) Cond2(7).emgcut(:,15) Cond2(8).emgcut(:,15) Cond2(9).emgcut(:,15) Cond2(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 2
meanUT_Cond2 = mean(UT_alltrials_Cond2,2); 
meanMT_Cond2 = mean(UT_alltrials_Cond2,2); 
meanLD_Cond2 = mean(UT_alltrials_Cond2,2); 
meanPM_Cond2 = mean(UT_alltrials_Cond2,2); 
meanBIC_Cond2 = mean(UT_alltrials_Cond2,2); 
meanTRI_Cond2 = mean(UT_alltrials_Cond2,2); 
meanIDL_Cond2 = mean(UT_alltrials_Cond2,2); 





%% Condition 3
%  10 trials
UT_alltrials_Cond3 = [Cond3(1).emgcut(:,9) Cond3(2).emgcut(:,9) Cond3(3).emgcut(:,9) Cond3(4).emgcut(:,9) Cond3(5).emgcut(:,9) Cond3(6).emgcut(:,9) Cond3(7).emgcut(:,9) Cond3(8).emgcut(:,9) Cond3(9).emgcut(:,9) Cond3(10).emgcut(:,9)];
MT_alltrials_Cond3 = [Cond3(1).emgcut(:,10) Cond3(2).emgcut(:,10) Cond3(3).emgcut(:,10) Cond3(4).emgcut(:,10) Cond3(5).emgcut(:,10) Cond3(6).emgcut(:,10) Cond3(7).emgcut(:,10) Cond3(8).emgcut(:,10) Cond3(9).emgcut(:,10) Cond3(10).emgcut(:,10)];
LD_alltrials_Cond3= [Cond3(1).emgcut(:,11) Cond3(2).emgcut(:,11) Cond3(3).emgcut(:,11) Cond3(4).emgcut(:,11) Cond3(5).emgcut(:,11) Cond3(6).emgcut(:,11) Cond3(7).emgcut(:,11) Cond3(8).emgcut(:,11) Cond3(9).emgcut(:,11) Cond3(10).emgcut(:,11)];
PM_alltrials_Cond3 = [Cond3(1).emgcut(:,12) Cond3(2).emgcut(:,12) Cond3(3).emgcut(:,12) Cond3(4).emgcut(:,12) Cond3(5).emgcut(:,12) Cond3(6).emgcut(:,12) Cond3(7).emgcut(:,12) Cond3(8).emgcut(:,12) Cond3(9).emgcut(:,12) Cond3(10).emgcut(:,12)];
BIC_alltrials_Cond3 = [Cond3(1).emgcut(:,13) Cond3(2).emgcut(:,13) Cond3(3).emgcut(:,13) Cond3(4).emgcut(:,13) Cond3(5).emgcut(:,13) Cond3(6).emgcut(:,13) Cond3(7).emgcut(:,13) Cond3(8).emgcut(:,13) Cond3(9).emgcut(:,13) Cond3(10).emgcut(:,13)];
TRI_alltrials_Cond3  = [Cond3(1).emgcut(:,14) Cond3(2).emgcut(:,14) Cond3(3).emgcut(:,14) Cond3(4).emgcut(:,14) Cond3(5).emgcut(:,14) Cond3(6).emgcut(:,14) Cond3(7).emgcut(:,14) Cond3(8).emgcut(:,14) Cond3(9).emgcut(:,14) Cond3(10).emgcut(:,14)];
IDL_alltrials_Cond3 = [Cond3(1).emgcut(:,15) Cond3(2).emgcut(:,15) Cond3(3).emgcut(:,15) Cond3(4).emgcut(:,15) Cond3(5).emgcut(:,15) Cond3(6).emgcut(:,15) Cond3(7).emgcut(:,15) Cond3(8).emgcut(:,15) Cond3(9).emgcut(:,15) Cond3(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond3 = mean(UT_alltrials_Cond3,2); 
meanMT_Cond3 = mean(UT_alltrials_Cond3,2); 
meanLD_Cond3 = mean(UT_alltrials_Cond3,2); 
meanPM_Cond3 = mean(UT_alltrials_Cond3,2); 
meanBIC_Cond3 = mean(UT_alltrials_Cond3,2); 
meanTRI_Cond3 = mean(UT_alltrials_Cond3,2); 
meanIDL_Cond3 = mean(UT_alltrials_Cond3,2); 




%% Condition 4
% 5 trials
UT_alltrials_Cond4 = [Cond4(1).emgcut(:,9) Cond4(2).emgcut(:,9) Cond4(3).emgcut(:,9) Cond4(4).emgcut(:,9) Cond4(5).emgcut(:,9)];
MT_alltrials_Cond4 = [Cond4(1).emgcut(:,10) Cond4(2).emgcut(:,10) Cond4(3).emgcut(:,10) Cond4(4).emgcut(:,10) Cond4(5).emgcut(:,10)];
LD_alltrials_Cond4= [Cond4(1).emgcut(:,11) Cond4(2).emgcut(:,11) Cond4(3).emgcut(:,11) Cond4(4).emgcut(:,11) Cond4(5).emgcut(:,11)];
PM_alltrials_Cond4 = [Cond4(1).emgcut(:,12) Cond4(2).emgcut(:,12) Cond4(3).emgcut(:,12) Cond4(4).emgcut(:,12) Cond4(5).emgcut(:,12)];
BIC_alltrials_Cond4 = [Cond4(1).emgcut(:,13) Cond4(2).emgcut(:,13) Cond4(3).emgcut(:,13) Cond4(4).emgcut(:,13) Cond4(5).emgcut(:,13)];
TRI_alltrials_Cond4  = [Cond4(1).emgcut(:,14) Cond4(2).emgcut(:,14) Cond4(3).emgcut(:,14) Cond4(4).emgcut(:,14) Cond4(5).emgcut(:,14)];
IDL_alltrials_Cond4 = [Cond4(1).emgcut(:,15) Cond4(2).emgcut(:,15) Cond4(3).emgcut(:,15) Cond4(4).emgcut(:,15) Cond4(5).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond4 = mean(UT_alltrials_Cond4,2); 
meanMT_Cond4 = mean(UT_alltrials_Cond4,2); 
meanLD_Cond4 = mean(UT_alltrials_Cond4,2); 
meanPM_Cond4 = mean(UT_alltrials_Cond4,2); 
meanBIC_Cond4 = mean(UT_alltrials_Cond4,2); 
meanTRI_Cond4 = mean(UT_alltrials_Cond4,2); 
meanIDL_Cond4 = mean(UT_alltrials_Cond4,2); 




%% Condition 5

%  10 trials
UT_alltrials_Cond5 = [Cond5(1).emgcut(:,9) Cond5(2).emgcut(:,9) Cond5(3).emgcut(:,9) Cond5(4).emgcut(:,9) Cond5(5).emgcut(:,9) Cond5(6).emgcut(:,9) Cond5(7).emgcut(:,9) Cond5(8).emgcut(:,9) Cond5(9).emgcut(:,9) Cond5(10).emgcut(:,9)];
MT_alltrials_Cond5 = [Cond5(1).emgcut(:,10) Cond5(2).emgcut(:,10) Cond5(3).emgcut(:,10) Cond5(4).emgcut(:,10) Cond5(5).emgcut(:,10) Cond5(6).emgcut(:,10) Cond5(7).emgcut(:,10) Cond5(8).emgcut(:,10) Cond5(9).emgcut(:,10) Cond5(10).emgcut(:,10)];
LD_alltrials_Cond5= [Cond5(1).emgcut(:,11) Cond5(2).emgcut(:,11) Cond5(3).emgcut(:,11) Cond5(4).emgcut(:,11) Cond5(5).emgcut(:,11) Cond5(6).emgcut(:,11) Cond5(7).emgcut(:,11) Cond5(8).emgcut(:,11) Cond5(9).emgcut(:,11) Cond5(10).emgcut(:,11)];
PM_alltrials_Cond5 = [Cond5(1).emgcut(:,12) Cond5(2).emgcut(:,12) Cond5(3).emgcut(:,12) Cond5(4).emgcut(:,12) Cond5(5).emgcut(:,12) Cond5(6).emgcut(:,12) Cond5(7).emgcut(:,12) Cond5(8).emgcut(:,12) Cond5(9).emgcut(:,12) Cond5(10).emgcut(:,12)];
BIC_alltrials_Cond5 = [Cond5(1).emgcut(:,13) Cond5(2).emgcut(:,13) Cond5(3).emgcut(:,13) Cond5(4).emgcut(:,13) Cond5(5).emgcut(:,13) Cond5(6).emgcut(:,13) Cond5(7).emgcut(:,13) Cond5(8).emgcut(:,13) Cond5(9).emgcut(:,13) Cond5(10).emgcut(:,13)];
TRI_alltrials_Cond5  = [Cond5(1).emgcut(:,14) Cond5(2).emgcut(:,14) Cond5(3).emgcut(:,14) Cond5(4).emgcut(:,14) Cond5(5).emgcut(:,14) Cond5(6).emgcut(:,14) Cond5(7).emgcut(:,14) Cond5(8).emgcut(:,14) Cond5(9).emgcut(:,14) Cond5(10).emgcut(:,14)];
IDL_alltrials_Cond5 = [Cond5(1).emgcut(:,15) Cond5(2).emgcut(:,15) Cond5(3).emgcut(:,15) Cond5(4).emgcut(:,15) Cond5(5).emgcut(:,15) Cond5(6).emgcut(:,15) Cond5(7).emgcut(:,15) Cond5(8).emgcut(:,15) Cond5(9).emgcut(:,15) Cond5(10).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond5 = mean(UT_alltrials_Cond5,2); 
meanMT_Cond5 = mean(UT_alltrials_Cond5,2); 
meanLD_Cond5 = mean(UT_alltrials_Cond5,2); 
meanPM_Cond5 = mean(UT_alltrials_Cond5,2); 
meanBIC_Cond5 = mean(UT_alltrials_Cond5,2); 
meanTRI_Cond5 = mean(UT_alltrials_Cond5,2); 
meanIDL_Cond5 = mean(UT_alltrials_Cond5,2); 





%% Condition 6 
%  9 trials
UT_alltrials_Cond6 = [Cond6(1).emgcut(:,9) Cond6(2).emgcut(:,9) Cond6(3).emgcut(:,9) Cond6(4).emgcut(:,9) Cond6(5).emgcut(:,9) Cond6(6).emgcut(:,9) Cond6(7).emgcut(:,9) Cond6(8).emgcut(:,9) Cond6(9).emgcut(:,9)];
MT_alltrials_Cond6 = [Cond6(1).emgcut(:,10) Cond6(2).emgcut(:,10) Cond6(3).emgcut(:,10) Cond6(4).emgcut(:,10) Cond6(5).emgcut(:,10) Cond6(6).emgcut(:,10) Cond6(7).emgcut(:,10) Cond6(8).emgcut(:,10) Cond6(9).emgcut(:,10)];
LD_alltrials_Cond6= [Cond6(1).emgcut(:,11) Cond6(2).emgcut(:,11) Cond6(3).emgcut(:,11) Cond6(4).emgcut(:,11) Cond6(5).emgcut(:,11) Cond6(6).emgcut(:,11) Cond6(7).emgcut(:,11) Cond6(8).emgcut(:,11) Cond6(9).emgcut(:,11)];
PM_alltrials_Cond6 = [Cond6(1).emgcut(:,12) Cond6(2).emgcut(:,12) Cond6(3).emgcut(:,12) Cond6(4).emgcut(:,12) Cond6(5).emgcut(:,12) Cond6(6).emgcut(:,12) Cond6(7).emgcut(:,12) Cond6(8).emgcut(:,12) Cond6(9).emgcut(:,12)];
BIC_alltrials_Cond6 = [Cond6(1).emgcut(:,13) Cond6(2).emgcut(:,13) Cond6(3).emgcut(:,13) Cond6(4).emgcut(:,13) Cond6(5).emgcut(:,13) Cond6(6).emgcut(:,13) Cond6(7).emgcut(:,13) Cond6(8).emgcut(:,13) Cond6(9).emgcut(:,13)];
TRI_alltrials_Cond6  = [Cond6(1).emgcut(:,14) Cond6(2).emgcut(:,14) Cond6(3).emgcut(:,14) Cond6(4).emgcut(:,14) Cond6(5).emgcut(:,14) Cond6(6).emgcut(:,14) Cond6(7).emgcut(:,14) Cond6(8).emgcut(:,14) Cond6(9).emgcut(:,14)];
IDL_alltrials_Cond6 = [Cond6(1).emgcut(:,15) Cond6(2).emgcut(:,15) Cond6(3).emgcut(:,15) Cond6(4).emgcut(:,15) Cond6(5).emgcut(:,15) Cond6(6).emgcut(:,15) Cond6(7).emgcut(:,15) Cond6(8).emgcut(:,15) Cond6(9).emgcut(:,15)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond6 = mean(UT_alltrials_Cond6,2); 
meanMT_Cond6 = mean(UT_alltrials_Cond6,2); 
meanLD_Cond6 = mean(UT_alltrials_Cond6,2); 
meanPM_Cond6 = mean(UT_alltrials_Cond6,2); 
meanBIC_Cond6 = mean(UT_alltrials_Cond6,2); 
meanTRI_Cond6 = mean(UT_alltrials_Cond6,2); 
meanIDL_Cond6 = mean(UT_alltrials_Cond6,2); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plotting%


% NOT ALIGNED to BEHAVIOR
% Velocity - get this after the meeting with Hongchul and Ana Maria
VelCond1 = [Cond1(1).vel(1:1000) Cond1(2).vel(1:1000) Cond1(3).vel(1:1000) Cond1(4).vel(1:1000) Cond1(5).vel(1:1000) Cond1(6).vel(1:1000) Cond1(7).vel(1:1000)]

AVGVelCond1 = mean

%% Plotting Mean Muscle Activity for all Conditions
%% UT
figure()
plot(smooth(meanUT_Cond1),'g','LineWidth',4)
hold on
plot(smooth(meanUT_Cond2),'c','LineWidth',4)
plot(smooth(meanUT_Cond3),'m','LineWidth',4)
plot(smooth(meanUT_Cond4),'b','LineWidth',4)
plot(smooth(meanUT_Cond5),'Color','#D95319','LineWidth',4)
plot(smooth(meanUT_Cond6),'r','LineWidth',4)
xline(1500,'Color','k','LineWidth',1)
legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('Upper Trap','FontSize',25)
%%
for i = 1:7
plot(smooth(UT_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(UT_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(UT_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(UT_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(UT_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(UT_alltrials_Cond6(:,i)),'r','LineWidth',1)
end


%%
% MT


figure()
plot(smooth(meanMT_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanMT_Cond2),'c','LineWidth',2)
plot(smooth(meanMT_Cond3),'m','LineWidth',2)
plot(smooth(meanMT_Cond4),'b','LineWidth',2)
plot(smooth(meanMT_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanMT_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('Mid Trap','FontSize',25)

%%
for i = 1:7
plot(smooth(MT_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(MT_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(MT_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(MT_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(MT_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(MT_alltrials_Cond6(:,i)),'r','LineWidth',1)
end

%% LD

figure()
plot(smooth(meanLD_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanLD_Cond2),'c','LineWidth',2)
plot(smooth(meanLD_Cond3),'m','LineWidth',2)
plot(smooth(meanLD_Cond4),'b','LineWidth',2)
plot(smooth(meanLD_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanLD_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('LD','FontSize',25)
%%
% 
for i = 1:7
plot(smooth(LD_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(LD_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(LD_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(LD_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(LD_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(LD_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% PM
figure()
plot(smooth(meanPM_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanPM_Cond2),'c','LineWidth',2)
plot(smooth(meanPM_Cond3),'m','LineWidth',2)
plot(smooth(meanPM_Cond4),'b','LineWidth',2)
plot(smooth(meanPM_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanPM_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('PM','FontSize',25)

%%
for i = 1:7
plot(smooth(PM_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(PM_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(PM_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(PM_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(PM_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(PM_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% BIC
figure()
plot(smooth(meanBIC_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanBIC_Cond2),'c','LineWidth',2)
plot(smooth(meanBIC_Cond3),'m','LineWidth',2)
plot(smooth(meanBIC_Cond4),'b','LineWidth',2)
plot(smooth(meanBIC_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanBIC_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)

%%
for i = 1:7
plot(smooth(BIC_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(BIC_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(BIC_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(BIC_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(BIC_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(BIC_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% TRI
figure()
plot(smooth(meanTRI_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanTRI_Cond2),'c','LineWidth',2)
plot(smooth(meanTRI_Cond3),'m','LineWidth',2)
plot(smooth(meanTRI_Cond4),'b','LineWidth',2)
plot(smooth(meanTRI_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanTRI_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('TRI','FontSize',25)

%%
for i = 1:7
plot(smooth(TRI_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(TRI_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(TRI_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(TRI_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(TRI_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(TRI_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% IDL
figure()
plot(smooth(meanIDL_Cond1),'g','LineWidth',2)
hold on
plot(smooth(meanIDL_Cond2),'c','LineWidth',2)
plot(smooth(meanIDL_Cond3),'m','LineWidth',2)
plot(smooth(meanIDL_Cond4),'b','LineWidth',2)
plot(smooth(meanIDL_Cond5),'Color','#D95319','LineWidth',2)
plot(smooth(meanIDL_Cond6),'r','LineWidth',2)
xline(1500,'Color','k','LineWidth',1)

legend('RT','R25','R50','UT','U25','U50','Max Vel','FontSize',16)
title('IDL','FontSize',25)
%%
for i = 1:7
plot(smooth(IDL_alltrials_Cond1(:,i)),'g','LineWidth',1)
end
for i = 1:9
plot(smooth(IDL_alltrials_Cond2(:,i)),'c','LineWidth',1)
end

for i = 1:10
plot(smooth(IDL_alltrials_Cond3(:,i)),'m','LineWidth',1)
end 

for i = 1:5
plot(smooth(IDL_alltrials_Cond4(:,i)),'b','LineWidth',1)
end

for i = 1:10
plot(smooth(IDL_alltrials_Cond5(:,i)),'Color','#D95319','LineWidth',1)
end

for i = 1:9
plot(smooth(IDL_alltrials_Cond6(:,i)),'r','LineWidth',1)
end
%% Code Below Plots Time Traces of all Trials in a Given Condition
%% Cond 1

DesiredCond = Cond1; %replace with condition want to see 
%%
for i = 1:length(DesiredCond) %Number of trials 

    if i==1
    figure
    end
    figure(1)
    plot(DesiredCond(i).emgTrace(:,9))
   
    % Determine the shift
%     shift = 2500 - DesiredCond(i).velidx; % Centering around the middle of the samples
%     
%     % Align the data
%     if shift >= 0
%         % If shift is positive, pad the left side
%         aligned_data(shift+1:shift+5000,i) = DesiredCond(i).emgTrace(:,9);
% %                 aligned_data(trial, shift+1:shift+5000) = data(trial, :);
% 
%     else
%         % If shift is negative, pad the right side
%         aligned_data(1:5000 + shift,i) = DesiredCond(i).emgTrace(:,9);
%     end
    title(MUSC(1),'FontSize',24)
    hold on
%%
    if i==1
    figure
    end
    figure(2)
    plot(DesiredCond(i).emgTrace(:,10))
    title(MUSC(2),'FontSize',24)
    hold on

    if i==1
    figure
    end
    figure(3)
    plot(DesiredCond(i).emgTrace(:,11))
    title(MUSC(3),'FontSize',24)
    hold on

    if i==1
    figure
    end
    figure(4)
    plot(DesiredCond(i).emgTrace(:,12))
    title(MUSC(4),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(5)
    plot(DesiredCond(i).emgTrace(:,13))
    title(MUSC(5),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(6)
    plot(DesiredCond(i).emgTrace(:,14))
    title(MUSC(6),'FontSize',24)
    hold on
    
    if i==1
    figure
    end
    figure(7)
    plot(DesiredCond(i).emgTrace(:,15))
    title(MUSC(7),'FontSize',24)
    hold on
end 






%%
% UT
figure()
plot(NNMFstruc(1).emgTrace(:,9))
hold on
plot(NNMFstruc(2).emgTrace(:,9))
plot(NNMFstruc(3).emgTrace(:,9))
plot(NNMFstruc(4).emgTrace(:,9))
plot(NNMFstruc(5).emgTrace(:,9))
plot(NNMFstruc(6).emgTrace(:,9))
plot(NNMFstruc(7).emgTrace(:,9))
title('UpperTrap Condition 1')

% MT
figure
plot(NNMFstruc(1).emgTrace(:,10))
hold on
plot(NNMFstruc(2).emgTrace(:,10))
plot(NNMFstruc(3).emgTrace(:,10))
plot(NNMFstruc(4).emgTrace(:,10))
plot(NNMFstruc(5).emgTrace(:,10))
plot(NNMFstruc(6).emgTrace(:,10))
plot(NNMFstruc(7).emgTrace(:,10))


% LD
figure
plot(NNMFstruc(1).emgTrace(:,11))
hold on
plot(NNMFstruc(2).emgTrace(:,11))
plot(NNMFstruc(3).emgTrace(:,11))
plot(NNMFstruc(4).emgTrace(:,11))
plot(NNMFstruc(5).emgTrace(:,11))
plot(NNMFstruc(6).emgTrace(:,11))
plot(NNMFstruc(7).emgTrace(:,11))


% PM
figure
plot(NNMFstruc(1).emgTrace(:,12))
hold on
plot(NNMFstruc(2).emgTrace(:,12))
plot(NNMFstruc(3).emgTrace(:,12))
plot(NNMFstruc(4).emgTrace(:,12))
plot(NNMFstruc(5).emgTrace(:,12))
plot(NNMFstruc(6).emgTrace(:,12))
plot(NNMFstruc(7).emgTrace(:,12))

% BIC
figure
plot(NNMFstruc(1).emgTrace(:,13))
hold on
plot(NNMFstruc(2).emgTrace(:,13))
plot(NNMFstruc(3).emgTrace(:,13))
plot(NNMFstruc(4).emgTrace(:,13))
plot(NNMFstruc(5).emgTrace(:,13))
plot(NNMFstruc(6).emgTrace(:,13))
plot(NNMFstruc(7).emgTrace(:,13))


% TRI
figure
plot(NNMFstruc(1).emgTrace(:,14))
hold on
plot(NNMFstruc(2).emgTrace(:,14))
plot(NNMFstruc(3).emgTrace(:,14))
plot(NNMFstruc(4).emgTrace(:,14))
plot(NNMFstruc(5).emgTrace(:,14))
plot(NNMFstruc(6).emgTrace(:,14))
plot(NNMFstruc(7).emgTrace(:,14))

% IDL
figure
plot(NNMFstruc(1).emgTrace(:,15))
hold on
plot(NNMFstruc(2).emgTrace(:,15))
plot(NNMFstruc(3).emgTrace(:,15))
plot(NNMFstruc(4).emgTrace(:,15))
plot(NNMFstruc(5).emgTrace(:,15))
plot(NNMFstruc(6).emgTrace(:,15))
plot(NNMFstruc(7).emgTrace(:,15))

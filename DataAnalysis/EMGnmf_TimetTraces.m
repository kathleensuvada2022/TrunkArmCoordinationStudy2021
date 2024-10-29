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


%%
% Separating the Structure by Condition

Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);



%% Plotting the Averages and Errors for Muscle Activations

% Condition 1

UT_alltrials_Cond = [Cond1(1).emgcut(:,9) Cond1(2).emgcut(:,9) Cond1(3).emgcut(:,9) Cond1(4).emgcut(:,9) Cond1(5).emgcut(:,9) Cond1(6).emgcut(:,9) Cond1(7).emgcut(:,9)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond1 = mean(UT_alltrials,2); 


% Condition 2 
UT_alltrials = [Cond2(1).emgcut(:,9) Cond1(2).emgcut(:,9) Cond1(3).emgcut(:,9) Cond1(4).emgcut(:,9) Cond1(5).emgcut(:,9) Cond1(6).emgcut(:,9) Cond1(7).emgcut(:,9)];

% taking the average across all columns to give an average trace that is
% 3001x1 

% Mean for all trials in condition 1 
meanUT_Cond1 = mean(UT_alltrials,2); 



% Condition 3




% Condition 4




% Condition 5





% Condition 6 





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

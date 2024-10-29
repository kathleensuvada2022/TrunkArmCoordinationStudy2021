%% October 2024

% Plotting the Raw EMG Data and comparing the traces across trials and
% conditions

MUSC = {'UT', 'MT', 'LD', 'PM', 'BIC', 'TRI', 'IDEL'};

% IDL: 15
% TRI: 14
% BIC: 13
% PM : 12
% LD : 11
% MT : 10
% UT : 09
%%
% Separating the Structure by Condition

Cond1 = NNMFstruc([NNMFstruc.cond] == 1);
Cond2 = NNMFstruc([NNMFstruc.cond] == 2);
Cond3 = NNMFstruc([NNMFstruc.cond] == 3);
Cond4 = NNMFstruc([NNMFstruc.cond] == 4);
Cond5 = NNMFstruc([NNMFstruc.cond] == 5);
Cond6 = NNMFstruc([NNMFstruc.cond] == 6);

%% Sample data
data = rand(7, 5000); % Replace this with your actual data
max_vel = randi([1, 5000], 7, 1); % Example max_vel indices for each trial

% Initialize an array to hold the aligned data
aligned_data = zeros(7, 5000); 

% Align each trial
for trial = 1:7
    max_index = max_vel(trial); % Get the max_vel index for the current trial
    
    % Determine the shift
    shift = 2500 - max_index; % Centering around the middle of the samples
    
    % Align the data
    if shift >= 0
        % If shift is positive, pad the left side
        aligned_data(trial, shift+1:shift+5000) = data(trial, :);
    else
        % If shift is negative, pad the right side
        aligned_data(trial, 1:5000 + shift) = data(trial, :);
    end
end

% aligned_data now contains the aligned trials

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

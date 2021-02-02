%% Test Code: Metria Analysis

% Written by: Nayo Hill on 8/22/19
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Select and load the HTS file to analyze
[filename, pathname] = uigetfile('*.hts', 'Select HTS file to analyze', cd);
file = [pathname,filename];
load(file)

disp(['Loaded file: ',file])
% Extract markerIDs and data from HTS file
[markerIDs, data] = ParseHTS_nmhRev(file);

% Extract XYZ positions of each marker
for i = 1:length(markerIDs) % Iterate over the number of markers acquired
    
    currentMarkerID = ['marker',num2str(markerIDs(i))];
    
    for j = 1:length(data) % Iterate over the number of images acquired
        
        t_data(j,i) = data(j).time2; % time 
        x_data(j,i) = data(j).markers.(char(currentMarkerID)).HTS(1,4)*1000; % X position in mm
        y_data(j,i) = data(j).markers.(char(currentMarkerID)).HTS(2,4)*1000; % Y position in mm
        z_data(j,i) = data(j).markers.(char(currentMarkerID)).HTS(3,4)*1000; % Z position in mm
        
    end
end

% Remove all 0 values from position dataset 
x_data(x_data(:) == 0) = NaN;
y_data(y_data(:) == 0) = NaN;
z_data(z_data(:) == 0) = NaN;







% 
% % Plotting x vs y for each marker 
% subplot(2,2,1)
% plot(-x_data(:,1),-y_data(:,1))
% title('Marker 1')
% subplot(2,2,2)
% plot(-x_data(:,2),-y_data(:,2))
% title('Marker 2')
% subplot(2,2,3)
% plot(-x_data(:,3),-y_data(:,3))
% title('Marker 3')
% subplot(2,2,4)
% plot(-x_data(:,4),-y_data(:,4))
% title('Marker 4')
% 
% 
% % Plot XYZ positions for each marker
% for k = 1:length(markerIDs)
%     figure(k)
%     subplot(2,2,1)
%     plot(x_data(:,k), 'r') % plot X data
%     title('X')
%     xlabel('image #')
%     ylabel('Position (mm)')
%     
%     subplot(2,2,2)
%     plot(y_data(:,k), 'g') % plot Y data
%     title('Y')
%     xlabel('image #')
%     ylabel('Position (mm)')
%     
%     subplot(2,2,3)
%     plot(z_data(:,k), 'b') % plot Z data
%     title('Z')
%     xlabel('image #')
%     ylabel('Position (mm)')
%     
%     subplot(2,2,4)
%     % plot all XYZ data
%     plot(x_data(:,k))
%     hold on
%     plot(y_data(:,k))
%     plot(z_data(:,k))
%     title(['Marker',num2str(markerIDs(k)),' | XYZ'])
%     xlabel('image #')
%     ylabel('Position (mm)')
%     hold off
   

%% For stroke subject RTIS 2001

%table data trials 2,5,7,10,11.. run the above for each trial and save
%RUN ONE BY ONE
% %trial X
% trialX_x = x_data;
% trialX_y = y_data;
% trialX_z = z_data;


%SHOULDER

%X DATA

%trials 2,5,7,10,11 Columns data for shoulder rows time for x data 

x_data_shoulder = [trial2_x(:,1), trial5_x(:,1), trial7_x(:,1), trial10_x(:,1), trial11_x(:,1)] %THIS OK

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_shoulder_x = mean(x_data_shoulder,2,'omitnan');


% Y DATA
%trials 2,5,7,10,11 Columns data for shoulder rows time for y data 
y_data_shoulder = [trial2_y(:,1), trial5_y(:,1), trial7_y(:,1), trial10_y(:,1), trial11_y(:,1)] 

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_shoulder_y = mean(y_data_shoulder,2,'omitnan');


% Z DATA
%trials 2,5,7,10,11 Columns data for shoulder rows time for y data 
z_data_shoulder = [trial2_z(:,1), trial5_z(:,1), trial7_z(:,1), trial10_z(:,1), trial11_z(:,1)] 

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_shoulder_z = mean(z_data_shoulder,2,'omitnan');



%Hand Data

%trials 2,5,7,10,11 Columns data for shoulder rows time for x data 

x_data_hand = [trial2_x(:,2), trial5_x(:,2), trial7_x(:,2), trial10_x(:,2), trial11_x(:,2)] %THIS OK

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_hand_x = mean(x_data_hand,2,'omitnan');


% Y DATA
%trials 2,5,7,10,11 Columns data for shoulder rows time for y data 
y_data_hand = [trial2_y(:,2), trial5_y(:,2), trial7_y(:,2), trial10_y(:,2), trial11_y(:,2)] ;

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_hand_y = mean(y_data_hand,2,'omitnan');


% Z DATA
%trials 2,5,7,10,11 Columns data for shoulder rows time for y data 
z_data_hand = [trial2_z(:,2), trial5_z(:,2), trial7_z(:,2), trial10_z(:,2), trial11_z(:,2)] ;

%average across rows so we have a master X position for all trials across
% 1000 frames 
avg_hand_z = mean(z_data_shoulder,2,'omitnan');

%now have 1000 frames x,y,z for hand and shoulder that's across all table
%trials

% (subtracting shoulder and hand position x and y)

reaching_x = abs(avg_hand_x-avg_shoulder_x);

reaching_y = abs(avg_hand_y -avg_shoulder_y);

%plotting the x and y trajectory 

plot(avg_hand_x,avg_hand_y)
xlabel('Position in mm')
ylabel('Position in mm')
title('Table Reach Trunk Free Average Trajectory Across 5 Trials')



plot(trial11_x(:,1),trial11_y(:,1))


%% Test Code: Metria Analysis

% Original code written by: Nayo Hill on 8/22/19
% Modified by: Kristina Zvolanek 
    % See revision history at:
    % https://github.com/kristinazvolanek/metria 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Features to add:
% -Loop to generate figures for all/some trials in folder (maybe a function
%  to identify the ones you're interested in with matrix of #s)
% -Summary statistics

%% Select and load the HTS file to analyze
[filename, pathname] = uigetfile('*.hts', 'Select HTS file to analyze', cd);
file = [pathname,filename];
load(file)

disp(['Loaded file: ',file])

%% Extract markerIDs and data from HTS file

[markerIDs, data] = ParseHTS_nmhRev(file);

%% Extract XYZ positions of each marker
for i = 1:length(markerIDs) % Iterate over the number of markers acquired
    
    currentMarkerID = ['marker',num2str(markerIDs(i))];
    
    % Pre-allocate matrices to save space
    t_data = zeros(length(data),length(markerIDs));
    x_data = zeros(length(data),length(markerIDs));
    y_data = zeros(length(data),length(markerIDs));
    z_data = zeros(length(data),length(markerIDs));
    
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

%% Plot XYZ positions for each marker
for k = 1:length(markerIDs)
    figure(k)
    subplot(2,2,1)
    plot(x_data(:,k), 'r') % plot X data
    title('X')
    xlabel('image #')
    ylabel('Position (mm)')
    
    subplot(2,2,2)
    plot(y_data(:,k), 'g') % plot Y data
    title('Y')
    xlabel('image #')
    ylabel('Position (mm)')
    
    subplot(2,2,3)
    plot(z_data(:,k), 'b') % plot Z data
    title('Z')
    xlabel('image #')
    ylabel('Position (mm)')
    
    subplot(2,2,4)
    % plot all XYZ data
    plot(x_data(:,k))
    hold on
    plot(y_data(:,k))
    plot(z_data(:,k))
    title(['Marker',num2str(markerIDs(k)),' | XYZ'])
    xlabel('image #')
    ylabel('Position (mm)')
    hold off
   
end

%% Extract pitch, roll, yaw for each marker
for i = 1:length(markerIDs) % Iterate over the number of markers acquired
   
    % Pre-allocate matrices to save space
    beta = zeros(length(data),length(markerIDs));
    pitch_data = zeros(length(data),length(markerIDs));
    gamma = zeros(length(data),length(markerIDs));
    roll_data = zeros(length(data),length(markerIDs));
    alpha = zeros(length(data),length(markerIDs));
    yaw_data = zeros(length(data),length(markerIDs));
    
    for j = 1:length(data) % Iterate over the number of images acquired
        
        % See http://planning.cs.uiuc.edu/node104.html#eqn:3dhomog for
        % reference on calculating pitch, roll, yaw, from homogeneous
        % transformation matrix
        
        % Pitch in deg
        beta(j,i) = -asin(data(j).markers.(char(currentMarkerID)).HTS(3,1));
        pitch_data(j,i) = rad2deg(beta(j,i)); 
        % Roll in deg
        gamma(j,i) = asin(data(j).markers.(char(currentMarkerID)).HTS(3,2)/cos(beta(j,i)));
        roll_data(j,i) = rad2deg(gamma(j,i));
        % Yaw in deg
        alpha(j,i) = asin(data(j).markers.(char(currentMarkerID)).HTS(1,2)/cos(beta(j,i)));
        yaw_data(j,i) = rad2deg(alpha(j,i));
    end
end

% Remove all 0 values from rotational dataset
pitch_data(pitch_data(:) == 0) = NaN;
roll_data(roll_data(:) == 0) = NaN;
yaw_data(yaw_data(:) == 0) = NaN;

%% Plot pitch, roll, yaw for each marker
for kk = 1:length(markerIDs)
    
    figure(kk+length(markerIDs))
    subplot(2,2,1)
    plot(pitch_data(:,kk), 'r') % plot pitch data
    title('Pitch')
    xlabel('Image #')
    ylabel('Rotation (deg)')
    
    subplot(2,2,2)
    plot(roll_data(:,kk), 'g') % plot roll data
    title('Roll')
    xlabel('Image #')
    ylabel('Rotation (deg)')
    
    subplot(2,2,3)
    plot(yaw_data(:,kk), 'b') % plot yaw data
    title('Yaw')
    xlabel('Image #')
    ylabel('Rotation (deg)')
    
    subplot(2,2,4) % plot all XYZ data
    plot(pitch_data(:,kk))
    hold on
    plot(roll_data(:,kk))
    plot(yaw_data(:,kk))
    title(['Marker',num2str(markerIDs(k)),' | PitchRollYaw'])
    xlabel('Image #')
    ylabel('Angle (deg)')
    hold off
   
end

%% New plots for Quals proposal

for k = 1:length(markerIDs)
    
    figure;
    subplot(211)
%     plot(detrend(x_data(:,k),'constant'), 'Color',[57/256,97/256,143/256],'Linewidth',1.5); hold on
%     plot(detrend(y_data(:,k),'constan'), 'Color',[64/256,184/256,225/256],'Linewidth',1.5); hold on
%     plot(detrend(z_data(:,k),'constant'), 'Color',[75/256, 53/256, 150/256],'Linewidth',1.5); hold on 
    plot(detrend(x_data(:,k),'constant'), 'Color',[0/255,119/255,255/255],'Linewidth',1.5); hold on
    plot(detrend(y_data(:,k),'constan'), 'Color',[109/255,50/255,176/255],'Linewidth',1.5); hold on
    plot(detrend(z_data(:,k),'constant'), 'Color',[255/255, 0/255, 4/255],'Linewidth',1.5); hold on 
    xlabel('Image #','FontSize',14)
    ylabel('Position (mm)','FontSize',14)
    legend('X','Y','Z','FontSize',14)
    XTickLabels.FontSize=14;
    YTickLabels.FontSize=14;
    title('Translational Motion','FontSize',16)
    xlim([0 length(data)])
   
    subplot(212)
%     plot(detrend(x_data(:,k),'constant'), 'Color',[57/256,97/256,143/256],'Linewidth',1.5); hold on
%     plot(detrend(y_data(:,k),'constan'), 'Color',[64/256,184/256,225/256],'Linewidth',1.5); hold on
%     plot(detrend(z_data(:,k),'constant'), 'Color',[75/256, 53/256, 150/256],'Linewidth',1.5); hold on 
    plot(detrend(x_data(:,k),'constant'), 'Color',[0/255,119/255,255/255],'Linewidth',1.5); hold on
    plot(detrend(y_data(:,k),'constan'), 'Color',[109/255,50/255,176/255],'Linewidth',1.5); hold on
    plot(detrend(z_data(:,k),'constant'), 'Color',[255/255, 0/255, 4/255],'Linewidth',1.5); hold on 
    xlabel('Image #','FontSize',14)
    ylabel('Rotation (deg)','FontSize',14)
    legend('Pitch','Roll','Yaw','FontSize',14)
    XTickLabels.FontSize=14;
    YTickLabels.FontSize=14;
    title('Rotational Motion','FontSize',16)
    xlim([0 length(data)])

   
end
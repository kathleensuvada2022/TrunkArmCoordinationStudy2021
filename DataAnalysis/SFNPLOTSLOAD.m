%% SCRIPT FOR SFN METRIA PLOTS 

%RTIS 2001

% Load CONDITIONS RTIS2001 trials 1,3,4,6,8


figure(1)
%trunk
plot(xdata1(1:264,4),-zdata1(1:264,4),'m')%trial1 
hold on
plot(xdata1(1,4),-zdata1(1,4),'-go')
plot(xdata1(264,4),-zdata1(264,4),'-ro') %labeled point where the max reach is

plot(xdata3(1:287,4),-zdata3(1:287,4),'c')%trial3
plot(xdata3(1,4),-zdata3(1,4),'-go')
plot(xdata3(287,4),-zdata3(287,4),'-ro') 

plot(xdata4(1:338,4),-zdata4(1:338,4),'k')%trial4
plot(xdata4(1,4),-zdata4(1,4),'-go')
plot(xdata4(338,4),-zdata4(338,4),'-ro') 

plot(xdata6(1:296,4),-zdata6(1:296,4),'r')%trial6
plot(xdata6(1,4),-zdata6(1,4),'-go')
plot(xdata6(296,4),-zdata6(296,4),'-ro') 

plot(xdata8(1:492,4),-zdata8(1:492,4),'b')%trial8
plot(xdata8(1,4),-zdata8(1,4),'-go')
plot(xdata8(492,4),-zdata3(492,4),'-ro') 
%shoulder
plot(xdata1(1:264,1),-zdata1(1:264,1),'m')%trial1 
plot(xdata3(1:287,1),-zdata3(1:287,1),'c')%trial3 
plot(xdata4(1:338,1),-zdata4(1:338,1),'k')%trial4
plot(xdata6(1:296,1),-zdata6(1:296,1),'r')%trial6
plot(xdata8(1:492,1),-zdata8(1:492,1),'b')%trial8
%hand
plot(newhandx1(1:264),-newhandz1(1:264),'m','LineWidth',2) %trial1
plot(newhandx1(1),-newhandz1(1),'-go') 
plot(newhandx1(264),-newhandz1(264),'-ro') 

plot(newhandx3(1:287),-newhandz3(1:287),'c','LineWidth',2) %trial3
plot(newhandx3(1),-newhandz3(1),'-go') 
plot(newhandx3(287),-newhandz3(287),'-ro') 

plot(newhandx4(1:338),-newhandz4(1:338),'k','LineWidth',2) %trial4
plot(newhandx4(1),-newhandz4(1),'-go') 
plot(newhandx4(338),-newhandz4(338),'-ro') 

plot(newhandx6(1:296),-newhandz6(1:296),'r','LineWidth',2) %trial6
plot(newhandx6(1),-newhandz6(1),'-go')
plot(newhandx6(296),-newhandz6(296),'-ro') %MAX 491.9053 at trial 6 at296

plot(newhandx8(1:492),-newhandz8(1:492),'b','LineWidth',2)%trial8
plot(newhandx8(1),-newhandz8(1),'-go')
plot(newhandx8(492),-newhandz8(492),'-ro') 

hold off
xlabel('x (mm)')
ylabel('z (mm)')
title('Loaded Reach with Paretic Right Arm and Trunk Unrestrained')

%took distance between hand and metria marker on forearm will not change in
%y plane(up down for metria)

%calculating hand position

xdiff = abs(xdata2(1,5) -xdata2(1,2)); 89.4
zdiff = abs(zdata2(1,5)-zdata2(1,2)); 113.70

%new hand position

newhandx = xdataTRIAL(:,5) -xdiff;
newhandz = xdataTRIAL(:,5) -xdiff;


newhandx = x_data2(:,5) - 89.40;
newhandz = z_data2(:,5) -113.69;

%Calculating max reach'


%subtracting shoulder and hand markers
%trial 1
reach_tf_load1 = sqrt((newhandx1-xdata1(:,1)).^2+ (newhandz1-zdata1(:,1)).^2);
%trial 3
reach_tf_load3 = sqrt((newhandx3-xdata3(:,1)).^2+ (newhandz3-zdata3(:,1)).^2);
%trial 4
reach_tf_load4 = sqrt((newhandx4-xdata4(:,1)).^2+ (newhandz4-zdata4(:,1)).^2);
%trial 6
reach_tf_load6 = sqrt((newhandx6-xdata6(:,1)).^2+ (newhandz6-zdata6(:,1)).^2);
%trial 8
reach_tf_load8 = sqrt((newhandx8-xdata8(:,1)).^2+ (newhandz8-zdata8(:,1)).^2);


%Finding max distance for each trial 
maxreach1 = max(reach_tf_load1); %at index 264
maxreach3 = max(reach_tf_load3); %287
maxreach4 = max(reach_tf_load4);%338
maxreach6 = max(reach_tf_load6); % at index 296
maxreach8 = max(reach_tf_load8); %492

%combining all the reaches

reaches = [reach_tf_table1 reach_tf_table3 reach_tf_table4 reach_tf_table6 reach_tf_table8];

%finding the absolute max reach for all trials in this condition
maxreach =   max(reaches,[],'all');

%Finding the trunk distance from 1:max reach index

trunkdis1 = sqrt((xdata1(1,4)-xdata1(264,1)).^2+(zdata1(1,4)-zdata1(264,4)).^2);

trunkdis3 = sqrt((xdata3(1,4)-xdata3(287,1)).^2+(zdata3(1,4)-zdata3(287,4)).^2);

trunkdis4 = sqrt((xdata4(1,4)-xdata(338,1)).^2+(zdata4(1,4)-zdata4(338,1)).^2);

trunkdis6 = sqrt((xdata6(1,4)-xdata6(296,1)).^2+(zdata6(1,4)-zdata6(296,1)).^2);

trunkdis8 = sqrt((xdata8(1,4)-xdata8(492,1)).^2+(zdata8(1,4)-zdata8(492,1)).^2);


%% figure(1) NOT FOR SFN SEPARATE
%subplot(1,3,2)
plot(x_data(:,4),z_data(:,4))
hold on
plot(x_data(1,4),z_data(1,4),'-go')
plot(x_data(end,4),z_data(end,4),'-ro')
hold off
xlabel('x (mm)')
ylabel('z (mm)')
title(['Marker ', num2str(markerIDs(5)),' | Forearm'])

subplot(1,3,1)
plot(x_data(:,2),z_data(:,2))
hold on
plot(x_data(1,2),z_data(1,2),'-go')
plot(x_data(end,2),z_data(end,2),'-ro')
hold off
xlabel('x (mm)')
ylabel('z (mm)')
title(['Marker ', num2str(markerIDs(2)),' | Hand'])

subplot(1,3,3)
plot(cell2mat(trialData(3,2:end)),cell2mat(trialData(4,2:end)))
hold on
plot(cell2mat(trialData(3,2)),cell2mat(trialData(4,2)),'-go')
plot(cell2mat(trialData(3,end)),cell2mat(trialData(4,end)),'-ro')
hold off
xlabel('x (m)')
ylabel('y (m)')
title('ACT3D')

figure(2)
plot(x_data(:,4),z_data(:,4))
hold on
plot(x_data(1,4),z_data(1,4),'-go')
plot(x_data(end,4),z_data(end,4),'-ro')

plot(x_data(:,2),z_data(:,2))
plot(x_data(1,2),z_data(1,2),'-g*')
plot(x_data(end,2),z_data(end,2),'-r*')
hold off

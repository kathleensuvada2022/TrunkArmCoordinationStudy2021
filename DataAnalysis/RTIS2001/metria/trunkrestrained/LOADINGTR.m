%% SCRIPT FOR SFN METRIA PLOTS 

%RTIS 2001

%Trunk restrained LOAD conditions 1,2,3,7,10
% Throwing out trial 1 and 10 , because trunk marker not detected

figure(1)
%trunk
% plot(xdata1(:,4),-zdata1(:,4),'m')%trial1
% hold on
% %plot(xdata1(1,4),-zdata1(1,4),'-go')
%plot(xdata1(,4),-zdata1(,4),'-ro') %labeled point where the max reach is

plot(xdata2(:,4),-zdata2(:,4),'c')%trial2
% plot(xdata2(1,4),-zdata2(1,4),'-go')
plot(xdata2(10,4),-zdata2(10,4),'-ro') 

plot(xdata3(:,4),-zdata3(:,4),'k')%trial3
% plot(xdata3(1,4),-zdata3(1,4),'-go')
% plot(xdata3(,4),-zdata3(,4),'-ro') 

plot(xdata7(:,4),-zdata7(:,4),'r')%trial 7
% plot(xdata7(1,4),-zdata7(1,4),'-go')
% plot(xdata7(201,4),-zdata7(201,4),'-ro') 

% plot(xdata10(:,4),-zdata10(:,4),'b')%trial10 
% % plot(xdata10(1,4),-zdata10(1,4),'-go')
% % plot(xdata10(445,4),-zdata10(445,4),'-ro') 
% % 

%shoulder
% plot(xdata1(:,1),-zdata1(:,1),'m')%trial1
hold on
plot(xdata2(:,1),-zdata2(:,1),'c')%trial2 
plot(xdata3(:,1),-zdata3(:,1),'k')%trial3
plot(xdata7(:,1),-zdata7(:,1),'r')%trial7
% plot(xdata10(:,1),-zdata10(:,1),'b')%trial10

%hand 
% 
% plot(xdata2(:,2),-zdata2(:,2),'c','LineWidth', 2)
% plot(xdata3(:,2),-zdata3(:,2),'k','LineWidth', 2)
% plot(xdata7(:,2),-zdata7(:,2),'r','LineWidth', 2)

% from Trunk free (not working with restrained) 
% plot(newhandx1(:),-newhandz1(:),'m','LineWidth',2) %trial1 . 
% % plot(newhandx2(1),-newhandz2(1),'-go') 
% % plot(newhandx2(308),-newhandz2(308),'-ro') 

plot(newhandx2(:),-newhandz2(:),'c','LineWidth',2) %trial2 % 
% plot(newhandx5(1),-newhandz5(1),'-go') 
% plot(newhandx5(344),-newhandz5(344),'-ro') 

plot(newhandx3(:),-newhandz3(:),'k','LineWidth',2) %trial3  
% plot(newhandx7(1),-newhandz7(1),'-go') 
% plot(newhandx7(314),-newhandz7(314),'-ro') 

plot(newhandx7(:),-newhandz7(:),'r','LineWidth',2) %trial7 
% plot(newhandx10(1),-newhandz10(1),'-go')
% plot(newhandx10(201),-newhandz10(201),'-ro') 

% plot(newhandx10(:),-newhandz10(:),'b','LineWidth',2)%trial10 
% % plot(newhandx11(1),-newhandz11(1),'-go')
% % plot(newhandx11(445),-newhandz11(445),'-ro') 


xlabel('x (mm)')
ylabel('z (mm)')
title('Weighted Reach with Paretic Right Arm and Trunk Restrained')

%%
%took distance between hand and metria marker on forearm will not change in
%y plane(up down for metria)

%calculating hand position

xdiff = abs(xdata2(1,5) -xdata2(1,2)); 89.4
zdiff = abs(zdata2(1,5)-zdata2(1,2)); 113.70

%new hand position

newhandx = xdataTRIAL(:,5) -xdiff;
newhandz = xdataTRIAL(:,5) -xdiff;

%below is correct making more negative "adding" humerous +diff between hand
%and humerous marker
newhandx = x_data2(:,5) - 89.40;
newhandz = z_data2(:,5) -113.69;

%Calculating max reach'


%subtracting shoulder and hand markers
%trial 2
reach_tf_table2 = sqrt((newhandx2-xdata2(:,1)).^2+ (newhandz2-zdata2(:,1)).^2);
%trial 3
reach_tf_table3 = sqrt((newhandx3-xdata3(:,1)).^2+ (newhandz3-zdata3(:,1)).^2);
%trial 7
reach_tf_table7 = sqrt((newhandx7-xdata7(:,1)).^2+ (newhandz7-zdata7(:,1)).^2);


%Finding max distance for each trial 
maxreach2 = max(reach_tf_table2); 
maxreach3 = max(reach_tf_table3); 
maxreach7 = max(reach_tf_table7);


%Finding the trunk distance from 1:max reach index for the given trial

trunkdis2 = sqrt((xdata2(1,4)-xdata2(,1)).^2+(zdata2(1,4)-zdata2(,4)).^2);

trunkdis3 = sqrt((xdata3(1,4)-xdata3(,1)).^2+(zdata3(1,4)-zdata3(,4)).^2);

trunkdis7 = sqrt((xdata7(1,4)-xdata7(,1)).^2+(zdata7(1,4)-zdata7(,1)).^2);




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

%October 2021

%Function for plotting bony landmarks and bone CS in global CF

%BLnames:string array of the names of the bony landmarks
%CS: coordinate system for given bone. 
%%
% % %%%%%%%%%TESTING at frame 1%%% 
% BL = BLs_G{1,4};  %forearm BLS in global
% BLnames = BL_names_all{4,1};
% CS = CS_G{1,4}; %global CS 
%%
%%%%%%%%%%%%%%%%%%
% azimuth = 0 
%view(0,90)  to change the view of the plot so can see view from above 
%subplots 
% Make plot with all CS together with not all BLS
%PMCP in hum and output

% How to show trunk, shoulder, and elbow into the reaching distance?

% in stroke maybe more of trunk compared to controls? 


% What trying to measure? and get out of data--> what are outcome measures
% that will capture this
function  plotCoord_Global(BLs_G,BL_names_all,CS_G)
%%
for k=1:50 %Number of frames of trial

% TRUNK    
CS_t = CS_G{1,1};
BLnames_t = BL_names_all{1,1};
BL_t = BLs_G{1,1}; 

% Plotting bone CS and BLS in global cf
CS_frame_t = CS_t(:,:,k);
BL_frame_t = BL_t(:,:,k);
figure(1)
title('Sternum Coordinate System with Corresponding Bony Landmarks')
%subplot(1,4,1)
quiver3(CS_frame_t([1 1 1],4)',CS_frame_t([2 2 2],4)',CS_frame_t([3 3 3],4)',20*CS_frame_t(1,1:3),20*CS_frame_t(2,1:3),20*CS_frame_t(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
text(CS_frame_t(1,4)+20*CS_frame_t(1,1:3),CS_frame_t(2,4)+20*CS_frame_t(2,1:3),CS_frame_t(3,4)+20*CS_frame_t(3,1:3),{'x','y','z'})

hold on
for i = 1:size(BL_frame_t,2)
figure(1)
plot3(BL_frame_t(1,i),BL_frame_t(2,i),BL_frame_t(3,i),'-o','Color','b','MarkerSize',5,...
'MarkerFaceColor','#D9FFFF')
if k ==1
text(BL_frame_t(1,i),BL_frame_t(2,i),BL_frame_t(3,i),BLnames_t(i))
end 
hold on
end




% Shoulder 

CS_s = CS_G{1,2};
BLnames_s = BL_names_all{2,1};
BL_s = BLs_G{1,2}; 

% Plotting bone CS and BLS in global cf
CS_frame_s = CS_s(:,:,k);
BL_frame_s = BL_s(:,:,k);

figure(2)
title('Scapular Coordinate System with Corresponding Bony Landmarks')
%subplot(1,4,2)
quiver3(CS_frame_s([1 1 1],4)',CS_frame_s([2 2 2],4)',CS_frame_s([3 3 3],4)',20*CS_frame_s(1,1:3),20*CS_frame_s(2,1:3),20*CS_frame_s(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
text(CS_frame_s(1,4)+20*CS_frame_s(1,1:3),CS_frame_s(2,4)+20*CS_frame_s(2,1:3),CS_frame_s(3,4)+20*CS_frame_s(3,1:3),{'x','y','z'})

hold on
for i = 1:size(BL_frame_s,2)
figure(2)
plot3(BL_frame_s(1,i),BL_frame_s(2,i),BL_frame_s(3,i),'-o','Color','b','MarkerSize',5,...
'MarkerFaceColor','#D9FFFF')
if k ==1 
text(BL_frame_s(1,i),BL_frame_s(2,i),BL_frame_s(3,i),BLnames_s(i))
end
hold on
end

axis equal
% Humerus 

CS_h = CS_G{1,3};
BLnames_h = BL_names_all{3,1};
BL_h = BLs_G{1,3}; 

% Plotting bone CS and BLS in global cf
CS_frame_h = CS_h(:,:,k);
BL_frame_h = BL_h(:,:,k);

figure(3)
title('Humerus Coordinate System with Corresponding Bony Landmarks')
%subplot(1,4,3)
quiver3(CS_frame_h([1 1 1],4)',CS_frame_h([2 2 2],4)',CS_frame_h([3 3 3],4)',20*CS_frame_h(1,1:3),20*CS_frame_h(2,1:3),20*CS_frame_h(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
text(CS_frame_h(1,4)+20*CS_frame_h(1,1:3),CS_frame_h(2,4)+20*CS_frame_h(2,1:3),CS_frame_h(3,4)+20*CS_frame_h(3,1:3),{'x','y','z'})

hold on
for i = 1:size(BL_frame_h,2)
figure(3)
plot3(BL_frame_h(1,i),BL_frame_h(2,i),BL_frame_h(3,i),'-o','Color','b','MarkerSize',5,...
'MarkerFaceColor','#D9FFFF')
if k==1
text(BL_frame_h(1,i),BL_frame_h(2,i),BL_frame_h(3,i),BLnames_h(i))
end
hold on
end
axis equal
%Forearm

CS_f = CS_G{1,4};
BLnames_f = BL_names_all{4,1};
BL_f = BLs_G{1,4}; 

% Plotting bone CS and BLS in global cf
CS_frame_f = CS_f(:,:,k);
BL_frame_f = BL_f(:,:,k);

figure(4)
title('Forearm Coordinate System with Corresponding Bony Landmarks')
quiver3(CS_frame_f([1 1 1],4)',CS_frame_f([2 2 2],4)',CS_frame_f([3 3 3],4)',20*CS_frame_f(1,1:3),20*CS_frame_f(2,1:3),20*CS_frame_f(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
text(CS_frame_f(1,4)+20*CS_frame_f(1,1:3),CS_frame_f(2,4)+20*CS_frame_f(2,1:3),CS_frame_f(3,4)+20*CS_frame_f(3,1:3),{'x','y','z'})

hold on
for i = 1:size(BL_frame_f,2)
figure(4)
plot3(BL_frame_f(1,i),BL_frame_f(2,i),BL_frame_f(3,i),'-o','Color','b','MarkerSize',5,...
'MarkerFaceColor','#D9FFFF')
if k==1
text(BL_frame_f(1,i),BL_frame_f(2,i),BL_frame_f(3,i),BLnames_f(i))
end
hold on
end

axis equal

end


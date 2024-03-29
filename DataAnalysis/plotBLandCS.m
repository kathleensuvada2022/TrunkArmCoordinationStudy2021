    %October 2021

    %Function for plotting bony landmarks of give bone and the
    %coordinate system created of that bone. To be used for Metria Analysis
    %and this is used when the data is in the coordinate system of the
    %respective marker (LCS)

%Inputs: BL: cell array with N elements for N Bony Landmarks 
%BLnames:string array of the names of the bony landmarks
%CS: coordinate system created for given bone. 

function  plotBLandCS(BL,BLnames,CS,titleplot)
%% Plotting Bony Landmarks and BONE CS in MARKER frame 
figure()
quiver3(CS([1 1 1],4)',CS([2 2 2],4)',CS([3 3 3],4)',50*CS(1,1:3),50*CS(2,1:3),50*CS(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
text(CS(1,4)+50*CS(1,1:3),CS(2,4)+50*CS(2,1:3),CS(3,4)+50*CS(3,1:3),{'x','y','z'})

hold on
for k = 1:length(BL)
plot3(BL{1,k}(1),BL{1,k}(2),BL{1,k}(3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(BL{1,k}(1),BL{1,k}(2),BL{1,k}(3),BLnames(k),'FontSize',12)

% plot3(BL{1,2}(1),BL{1,2}(2),BL{1,2}(3),'-o','Color','r','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL{1,2}(1),BL{1,2}(2),BL{1,2}(3),BLnames(2),'FontSize',12)
% 
% 
% plot3(BL{1,3}(1),BL{1,3}(2),BL{1,3}(3),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL{1,3}(1),BL{1,3}(2),BL{1,3}(3),BLnames(3),'FontSize',12)
% 
% 
% plot3(BL{1,4}(1),BL{1,4}(2),BL{1,4}(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL{1,4}(1),BL{1,4}(2),BL{1,4}(3),BLnames(4),'FontSize',12)
title([titleplot '-(in LCS)'],'FontSize',14)
hold on
end
axis equal

%% Computing BLs in the Bone Coordinate Frame
for i = 1:length(BL)
BL_coords= (BL{1,i}(1:4));
BL_bone{i} = inv(CS)*BL_coords;
end

% Getting the Bone Coordinate Frame in it's own frame 
Bone_bone =CS*inv(CS); 
% This should be an identity matrix 

%% Plotting bone CS and BLS in bone cf
figure()
quiver3(Bone_bone([1 1 1],4)',Bone_bone([2 2 2],4)',Bone_bone([3 3 3],4)',50*Bone_bone(1,1:3),50*Bone_bone(2,1:3),50*Bone_bone(3,1:3))
%quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)


hold on
for p = 1:length(BL_bone)
plot3(BL_bone{1,p}(1),BL_bone{1,p}(2),BL_bone{1,p}(3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(BL_bone{1,p}(1),BL_bone{1,p}(2),BL_bone{1,p}(3),BLnames(p),'FontSize',12)
%title([titleplot '-(in Bone CS)'],'FontSize',14)
% plot3(BL_bone{1,2}(1),BL_bone{1,2}(2),BL_bone{1,2}(3),'-o','Color','r','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL_bone{1,2}(1),BL_bone{1,2}(2),BL_bone{1,2}(3),BLnames(2),'FontSize',12)
% 
% 
% plot3(BL_bone{1,3}(1),BL_bone{1,3}(2),BL_bone{1,3}(3),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL_bone{1,3}(1),BL_bone{1,3}(2),BL_bone{1,3}(3),BLnames(3),'FontSize',12)
% 
% 
% plot3(BL_bone{1,4}(1),BL_bone{1,4}(2),BL_bone{1,4}(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(BL_bone{1,4}(1),BL_bone{1,4}(2),BL_bone{1,4}(3),BLnames(4),'FontSize',12)
hold on
title('Global CS')
end
axis equal

end

%% 
%Gives XYZ of pointer tool tip in LCS ,quaterion of pointer marker in GCS, then the RGB marker in LCS (this should always be about 001), then quaternion for RGB marker in GCS


% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
% Load in BL file for participant 
%% 
function PlotBlsLCS(bl)
%Script for passing in BL matrix and plotting in LCS (of their respective
%RGB markers) 

%extracting the BLS from each rigid body 
Bl_forearm =bl{1,4};
Bl_trunk = bl{1,1};
Bl_shoulder = bl{1,2};
Bl_humerus = bl{1,3};

% Forearm
%BLs for forearm in LCS of the RGB marker
Forearm_points = Bl_forearm(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Forearm_marker = Bl_forearm(1,9:11); %only grabbing first row since all same (0,0,0)

%Trunk
%BLs for Trunk in LCS of the RGB marker
Trunk_points = Bl_trunk(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Trunk_marker = Bl_trunk(1,9:11);%only grabbing first row since all same (0,0,0)


%Shoulder
%BLs for shoulder in LCS of the RGB marker
Shoulder_points = Bl_shoulder(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Shoulder_marker = Bl_shoulder(1,9:11);%only grabbing first row since all same (0,0,0)


%Humerus
%BLs for shoulder in LCS of the RGB marker
Humerus_points = Bl_humerus(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Humerus_marker = Bl_humerus(1,9:11);%only grabbing first row since all same (0,0,0)
%% FOREARM -{'RS';'US';'OL';'MCP3'}};

figure
for i =  1:length(Forearm_points)
plot3(Forearm_points(i,1),Forearm_points(i,2),Forearm_points(i,3),'*');
hold on
if i==1
text(Forearm_points(i,1),Forearm_points(i,2),Forearm_points(i,3),'RADIAL STYLOID');
end

if i==2
text(Forearm_points(i,1),Forearm_points(i,2),Forearm_points(i,3),'ULNAR STYLOID');
end

if i==3
text(Forearm_points(i,1),Forearm_points(i,2),Forearm_points(i,3),'OLECRANON');
end
if i==4
text(Forearm_points(i,1),Forearm_points(i,2),Forearm_points(i,3),'3RD MCP');
end
plot3(Forearm_marker(1),Forearm_marker(2),Forearm_marker(3),'*');
text(Forearm_marker(1),Forearm_marker(2),Forearm_marker(3),'Forearm Marker');
xlabel('X Position in cm','FontSize', 14)
ylabel('Y Position in cm','FontSize', 14)
zlabel('Z Position in cm','FontSize', 14)
title('3D position of BLS for Forearm','FontSize', 16)
% pause
end

%% Trunk- {'SC';'IJ';'PX';'C7';'T8'}

figure
for i =  1:length(Trunk_points)
plot3(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'*');
hold on
if i==1
text(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'Sterno-Clavicular');
end
if i==2
text(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'Jugular Notch');
end
if i==3
text(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'Xiphoid Process');
end
if i==4
text(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'C7');
end
if i==5
text(Trunk_points(i,1),Trunk_points(i,2),Trunk_points(i,3),'T8');
end
plot3(Trunk_marker(1),Trunk_marker(2),Trunk_marker(3),'*');
text(Trunk_marker(1),Trunk_marker(2),Trunk_marker(3),'Trunk Marker');
xlabel('X Position in cm','FontSize', 14)
ylabel('Y Position in cm','FontSize', 14)
zlabel('Z Position in cm','FontSize', 14)
title('3D position of BLS for Trunk','FontSize', 16)
% pause
end

%% Scapula- {'AC';'AA';'TS';'AI';'PC'}
figure
for i =  1:length(Shoulder_points)
plot3(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'*');
hold on
if i==1
text(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'AcromioClavicular');
end
if i==2
text(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'Anterior Acromion');
end
if i==3
text(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'Spine of Scapula');
end
if i==4
text(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'Inferior Angle');
end
if i==5
text(Shoulder_points(i,1),Shoulder_points(i,2),Shoulder_points(i,3),'Coracoid Process');
end
plot3(Shoulder_marker(1),Shoulder_marker(2),Shoulder_marker(3),'*');
text(Shoulder_marker(1),Shoulder_marker(2),Shoulder_marker(3),'Shoulder Marker');
xlabel('X Position in cm','FontSize', 14)
ylabel('Y Position in cm','FontSize', 14)
zlabel('Z Position in cm','FontSize', 14)
title('3D position of BLS for Shoulder','FontSize', 16)
% pause
end

%%  Humerus {'EM';'EL';'GH'}
figure
for i =  1:length(Humerus_points)
plot3(Humerus_points(i,1),Humerus_points(i,2),Humerus_points(i,3),'*');
hold on
if i==1
text(Humerus_points(i,1),Humerus_points(i,2),Humerus_points(i,3),'Medial Epicondyle');
end
if i==2
text(Humerus_points(i,1),Humerus_points(i,2),Humerus_points(i,3),'Lateral Epicondyle');
end
if i==3
text(Humerus_points(i,1),Humerus_points(i,2),Humerus_points(i,3),'Glenohumeral');
end

plot3(Humerus_marker(1),Humerus_marker(2),Humerus_marker(3),'*');
text(Humerus_marker(1),Humerus_marker(2),Humerus_marker(3),'Humerus Marker','FontSize', 12);
xlabel('X Position in cm','FontSize', 14)
ylabel('Y Position in cm','FontSize', 14)
zlabel('Z Position in cm','FontSize', 14)
title('3D position of BLS for Humerus','FontSize', 16)
% pause
end


end


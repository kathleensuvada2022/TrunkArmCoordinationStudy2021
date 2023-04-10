%% Scapular CS 2022

% Function to create Scapular CS based on Kacey's Definition. 
% For the right arm, x is to the right, z is up and y is forwards. Using
% the Bls of the scapula in the marker cs, create a cs for the scapula in
% the marker frame. 

% Inputs: 
% - BLs: full bonylandmark data from participant's setup file. These are
% saved in the coordinate frame of the marker. 
% - Hand: Scapular CS has two different definitions depending on if we are
% looking at the right or the left hand. 

% Outputs:
% - ScapCS: created CS of the scapula for the participant. This is in
% MARKER frame. 

% K. Suvada - August/September 2022.

function ScapCoord = Asscap_K(BLs,hand,flag)

% Scapular BLS in Scapula Marker Frame
blmat= BLs{1,2}; 

BlNames = ["AC","AA","TS","AI","PC"];
BLs_marker = blmat;

% Creating Bl variables
ACidx = find(BlNames=='AC');
[AC,AA,TS,AI,PC]=deal(blmat(:,ACidx),blmat(:,ACidx+1),blmat(:,ACidx+2),blmat(:,ACidx+3),blmat(:,ACidx+4));

aa = AA(1:3);
pc= PC(1:3);
ai = AI(1:3);
ts = TS(1:3);
ac = AC(1:3);

%% Creating Scapular CS -Kacey's Definition


xs = (AC(1:3)-TS(1:3)) / norm(AC(1:3)-TS(1:3));
yhulp = cross((AC(1:3)-AI(1:3)),xs);
ys = yhulp/norm(yhulp);
zs = cross(xs,ys);

s = [xs,ys,zs];

if strcmp(hand,'Left')
s = rotz(180)*s;
end


s = [s;0 0 0];

Orig = AC(1:4);

%Scapular CS in Marker Frame with origin at AC
ScapCoord = [s Orig];


% else 
%     
%     
% xs = (AC(1:3)-TS(1:3)) / norm(AC(1:3)-TS(1:3));
% yhulp = cross(xs,(AC(1:3)-AI(1:3)));
% ys = yhulp/norm(yhulp);
% zs = cross(ys,xs);
% s = [xs,ys,zs];
% 
% s = [s;0 0 0];
% 
% Orig = AC(1:4);
% 
% %Scapular CS in Marker Frame with origin at AC
% ScapCoord = [s Orig];
% 
% end

%% Plotting Scapular CS and Bls in Marker Frame
if flag ==1
  figure(29)
%Plotting the BonyLandmarks and their Labels
for i = 1:length(BlNames)
    plot3(BLs_marker(1,i),BLs_marker(2,i),BLs_marker(3,i),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(BLs_marker(1,i),BLs_marker(2,i),BLs_marker(3,i),BlNames(i),'FontSize',14)
end

%Plotting the Scapular Polygon
plot3([BLs_marker(1,4) BLs_marker(1,3)],[BLs_marker(2,4) BLs_marker(2,3)],[BLs_marker(3,4) BLs_marker(3,3)],'r') % line between AI and TS
plot3([BLs_marker(1,4) BLs_marker(1,2)],[BLs_marker(2,4) BLs_marker(2,2)],[BLs_marker(3,4) BLs_marker(3,2)],'r') % line between AI and AA
plot3([BLs_marker(1,3) BLs_marker(1,1)],[BLs_marker(2,3) BLs_marker(2,1)],[BLs_marker(3,3) BLs_marker(3,1)],'r') % line between TS and AC
plot3([BLs_marker(1,1) BLs_marker(1,2)],[BLs_marker(2,1) BLs_marker(2,2)],[BLs_marker(3,1) BLs_marker(3,2)],'r') % line between AC and AA

% Plotting Desired Scapular CS
quiver3(ScapCoord([1 1 1],4)',ScapCoord([2 2 2],4)',ScapCoord([3 3 3],4)',50*ScapCoord(1,1:3),50*ScapCoord(2,1:3),50*ScapCoord(3,1:3))
text(ScapCoord(1,4)+50*ScapCoord(1,1:3),ScapCoord(2,4)+50*ScapCoord(2,1:3),ScapCoord(3,4)+50*ScapCoord(3,1:3),{'X_S','Y_S','Z_S'})

plot3(0,0,0,'o')
text(0,0,0,'Marker','FontSize',14)
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title('Scap CS Raw Data in Marker CS','FontSize',16)  
    
end




end


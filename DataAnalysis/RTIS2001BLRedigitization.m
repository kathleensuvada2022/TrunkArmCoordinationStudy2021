%% Testing BonyLandmarks Redigitzation 2023 
%% RTIS2001 - Right Arm (Paretic)

% Participant had incorrect Scapular AC JOINT Digitized. Needed to Bring
% them back to redigitize. 

blmat_Scap2023 =bl{1,2}';
blmat_Scap2023 = blmat_Scap2023(1:4,:);


BlNames = ["AC","AA","TS","AI","PC"];
BLs_marker = blmat_Scap2023;

% Creating Bl variables
ACidx = find(BlNames=='AC');
[AC,AA,TS,AI,PC]=deal(blmat_Scap2023(:,ACidx),blmat_Scap2023(:,ACidx+1),blmat_Scap2023(:,ACidx+2),blmat_Scap2023(:,ACidx+3),blmat_Scap2023(:,ACidx+4));

aa = AA(1:3);
pc= PC(1:3);
ai = AI(1:3);
ts = TS(1:3);
ac = AC(1:3);

%% Creating Scapular CS -Kacey's Definition with Origin at AA


xs = (AA(1:3)-TS(1:3)) / norm(AA(1:3)-TS(1:3));
yhulp = cross((AA(1:3)-AI(1:3)),xs);
ys = yhulp/norm(yhulp);
zs = cross(xs,ys);

s = [xs,ys,zs];

s = [s;0 0 0];

Orig = AA(1:4);

%Scapular CS in Marker Frame with origin at AA (for Redigitization) 
ScapCoord = [s Orig];


%% Plotting BonyLandmarks in Marker CS
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

title('Scap CS Raw Data in Marker CS- Origin at AC','FontSize',16)  
    
% K. Suvada July 2022

% Function to plot raw bony landmarks in their respective marker coordinate
% systems. This is the data that is saved at the time of experiment.
% (0,0,0) shoulder be where the segment marker is located. 

% Inputs: 
% - BLs_marker: 4x1 matrices of each Bony Landmark. X,Y,Z position

function BL_markerCS(BLs_marker,BlNames,titleplot)

figure()

%Plotting the BonyLandmarks and their Labels
for i = 1:length(BlNames)
    plot3(BLs_marker(1,i),BLs_marker(2,i),BLs_marker(3,i),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(BLs_marker(1,i),BLs_marker(2,i),BLs_marker(3,i),BlNames(i),'FontSize',14)
end

%Plotting the Scapular Triangle
plot3([BLs_marker(1,4) BLs_marker(1,3)],[BLs_marker(2,4) BLs_marker(2,3)],[BLs_marker(3,4) BLs_marker(3,3)],'r') % line between AI and TS
plot3([BLs_marker(1,4) BLs_marker(1,2)],[BLs_marker(2,4) BLs_marker(2,2)],[BLs_marker(3,4) BLs_marker(3,2)],'r') % line between AI and AA
plot3([BLs_marker(1,3) BLs_marker(1,2)],[BLs_marker(2,3) BLs_marker(2,2)],[BLs_marker(3,3) BLs_marker(3,2)],'r') % line between TS and AA
 

%% Plotting Scapula Coordinate system

% "AC" "AA" "TS" "AI"
ACidx = find(BlNames=='AC');
[AC,AA,TS,AI]=deal(BLs_marker(:,ACidx),BLs_marker(:,ACidx+1),BLs_marker(:,ACidx+2),BLs_marker(:,ACidx+3));

%% Creating X,Y,Z axes
xs = (AC(1:3)-TS(1:3))/norm(AC(1:3)-TS(1:3)); 
ys = cross(xs,(AC(1:3)-AI(1:3)));
ys = ys/norm(ys);
zs = cross(ys,xs);
zs= zs/norm(zs);

S = [xs ys zs];

S = [S;0 0 0];
Orig = AC(1:4);

%Scapular CS in Marker Frame
ScapCoord = [S Orig];




%%
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title([titleplot  ' ' 'in Marker CS'],'FontSize',16)
end


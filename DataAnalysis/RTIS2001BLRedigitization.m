%% RTIS2001 BL Redigitization - Right Arm (Paretic)

% Participant had incorrect Scapular AC JOINT Digitized. Needed to Bring
% them back to redigitize. 


% Run 'Asscap_K_OriginAA' for both 2023 and 2021 data. 


%Creating Variable for Bls in the Shoulder Marker CS
blmat =bl{1,2}';
blmat = blmat(1:4,:);
BLs2021 = blmat(1:4,:);
BLs2023 = blmat(1:4,:);

%Creating Variable for Scapular CS in Marker CS
ScapCoord_2021 = ScapCoord;
ScapCoord_2023 = ScapCoord;


BLs_Marker_2021 = BLs2021;
%% Computing BLs in Bone CS (2023 data)
BLs_Bone_2023 = inv(ScapCoord_2023)* BLs2023;

%% Computing AC in Original Marker Frame (2021 data)

AC_Marker_2021 = ScapCoord_2021* BLs_Bone_2023(:,1);

%% Plotting BLs from 2021 in Marker CS (from 2021) 
BlNames = ["AC","AA","TS","AI","PC"];

  figure(29)

  %Plotting the BonyLandmarks and their Labels
for i = 1:length(BlNames)
    plot3(BLs_Marker_2021(1,i),BLs_Marker_2021(2,i),BLs_Marker_2021(3,i),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(BLs_Marker_2021(1,i),BLs_Marker_2021(2,i),BLs_Marker_2021(3,i),BlNames(i),'FontSize',14)
end

% Plotting New AC from 2023 
 plot3(AC_Marker_2021(1),AC_Marker_2021(2),AC_Marker_2021(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(AC_Marker_2021(1),AC_Marker_2021(2),AC_Marker_2021(3),BlNames(1),'FontSize',14)

%Plotting the Scapular Polygon
plot3([BLs_Marker_2021(1,4) BLs_Marker_2021(1,3)],[BLs_Marker_2021(2,4) BLs_Marker_2021(2,3)],[BLs_Marker_2021(3,4) BLs_Marker_2021(3,3)],'r') % line between AI and TS
plot3([BLs_Marker_2021(1,4) BLs_Marker_2021(1,2)],[BLs_Marker_2021(2,4) BLs_Marker_2021(2,2)],[BLs_Marker_2021(3,4) BLs_Marker_2021(3,2)],'r') % line between AI and AA
  plot3([BLs_Marker_2021(1,3) AC_Marker_2021(1,1)],[BLs_Marker_2021(2,3) AC_Marker_2021(2,1)],[BLs_Marker_2021(3,3) AC_Marker_2021(3,1)],'r') % line between TS and AC
  plot3([AC_Marker_2021(1,1) BLs_Marker_2021(1,2)],[AC_Marker_2021(2,1) BLs_Marker_2021(2,2)],[AC_Marker_2021(3,1) BLs_Marker_2021(3,2)],'r') % line between AC and AA


plot3(0,0,0,'o')
text(0,0,0,'Marker','FontSize',14)
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title('Scapular BLs in Shoulder Marker CS (From 2021 Data Collection)','FontSize',16)  


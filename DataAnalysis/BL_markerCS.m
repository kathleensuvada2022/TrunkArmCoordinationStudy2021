% K. Suvada July 2022

% Function to plot raw bony landmarks in their respective marker coordinate
% systems. This is the data that is saved at the time of experiment.
% (0,0,0) shoulder be where the segment marker is located. 

% Inputs: 
% - BLs_marker: 4x1 matrices of each Bony Landmark. X,Y,Z position

function [ScapCoord TrunkCS] =  BL_markerCS(BLs_marker,BlNames,BLs_marker_t, BlNames_t,titleplot,k,partid,arm)


%%%%%%%%%%%%%%%%%%%%%Scapula BLs in MARKER CS%%%%%%%%%%%%%%%%%%%%%%%%%%
if k ==1 
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
%plot3([BLs_marker(1,3) BLs_marker(1,2)],[BLs_marker(2,3) BLs_marker(2,2)],[BLs_marker(3,3) BLs_marker(3,2)],'r') % line between TS and AA
plot3([BLs_marker(1,3) BLs_marker(1,1)],[BLs_marker(2,3) BLs_marker(2,1)],[BLs_marker(3,3) BLs_marker(3,1)],'r') % line between TS and AC
plot3([BLs_marker(1,1) BLs_marker(1,2)],[BLs_marker(2,1) BLs_marker(2,2)],[BLs_marker(3,1) BLs_marker(3,2)],'r') % line between AC and AA


axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title([titleplot  ' ' 'Raw Data in Marker CS during digitization'],'FontSize',16)

'Check raw Scapular BLS and created Scapular CS'

end

%%%%%%%%%%%%%%%%%%%%%Trunk BLs in MARKER CS%%%%%%%%%%%%%%%%%%%%%%%%%%
if k ==1 
figure(30)

%Plotting the BonyLandmarks and their Labels
for i = 1:length(BlNames_t)
    plot3(BLs_marker_t(1,i),BLs_marker_t(2,i),BLs_marker_t(3,i),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(BLs_marker_t(1,i),BLs_marker_t(2,i),BLs_marker_t(3,i),BlNames_t(i),'FontSize',14)
end


axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title('Trunk Raw Data in Marker CS during digitization','FontSize',16)

'Check raw Trunk BLS and created Trunk CS'

end
%% Trunk Coordinate System

IJidx = find(BlNames_t=='IJ');

[IJ,PX,C7,T8]=deal(BLs_marker_t(:,IJidx),BLs_marker_t(:,IJidx+1),BLs_marker_t(:,IJidx+2),BLs_marker_t(:,IJidx+3)); % in Marker Local CS
BLnames_t = ["IJ","PX","C7","T8"];
BLs_lcs_t ={IJ,PX,C7,T8};

%% Trunk CS
zt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
zt = zt/norm(zt);

blmat_th =[IJ(1:3);PX(1:3);C7(1:3);T8(1:3)]';


% [A,DATAa,nvector,e]=vlak(blmat);
% xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
% zt = cross(xhulp,yt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP
% % zt = cross(xhulp,yt);
% zt=zt/norm(zt);
% xt = cross(yt,zt); %SABEEN CHANGE: NEED DIM OF 3 FOR CP

[A,DATAa,nvector,e]=vlak(blmat_th); 


%xhulp is vector normal to the plane
xhulp = nvector  ;

if xhulp(1) <0
    if BLs_marker_t(1,1) <0
    else
        xhulp = -nvector;
    end
    
elseif xhulp(1) >0
    if BLs_marker_t(1,1)>0
    else
        xhulp = -nvector;
    end
    
end
% if xhulp(1)<0 xhulp = -nvector;end
% yt = cross(xhulp,zt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 

% Plotting Xhulp 
figure(30)
quiver3(xhulp(1),xhulp(2),xhulp(3),50*xhulp(1),50*xhulp(2),50*xhulp(3))
%Kacey 10.4.21 flipping order of cross product for Y into the page 
%  yt = cross(xhulp,zt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 
   
%  if strcmp(partid,'RTIS2007')
%      if strcmp(arm,'Right')
          yt = cross(zt(1:3),xhulp); % This should always be true for Right arm and left arm


% zt = cross(xhulp,yt);

yt=yt/norm(yt);

% if strcmp(arm,'Left')
%     
% yt = cross(zt(1:3),xhulp);  
% end

%xt = cross(yt(1:3),zt);

%Redefined for Kacey 10.4.21
xt = cross(yt,zt);

% t = [xt,yt,zt];
t = [xt,yt,zt]; 

% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);

t = [xt,yt,zt];

diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end

t = [t;0 0 0];
orign_trunk = [IJ(1:4)];

%Trunk Coordinate System in Marker CS
TrunkCS = [t orign_trunk];


%% Scapula Coordinate system

% "AC" "AA" "TS" "AI"
ACidx = find(BlNames=='AC');
[AC,AA,TS,AI]=deal(BLs_marker(:,ACidx),BLs_marker(:,ACidx+1),BLs_marker(:,ACidx+2),BLs_marker(:,ACidx+3));

%% Creating X,Y,Z axes
%xs = (AC(1:3)-TS(1:3))/norm(AC(1:3)-TS(1:3));  For Centered at AC
xs = (AA(1:3)-TS(1:3))/norm(AA(1:3)-TS(1:3)); 

%ys = cross(xs,(AI(1:3)-AC(1:3))); For centered at AC
ys = cross(xs,(AI(1:3)-AA(1:3)));
ys = ys/norm(ys);

zs = cross(xs,ys);
zs= zs/norm(zs);

S = [xs ys zs];

S = [S;0 0 0];
%Orig = AC(1:4); % For CS centered at AC
Orig = AA(1:4);

%Scapular CS in Marker Frame
ScapCoord = [S Orig];



%% Plotting Scap CS - in Marker CS

figure(29)
      quiver3(ScapCoord([1 1 1],4)',ScapCoord([2 2 2],4)',ScapCoord([3 3 3],4)',50*ScapCoord(1,1:3),50*ScapCoord(2,1:3),50*ScapCoord(3,1:3))
      text(ScapCoord(1,4)+50*ScapCoord(1,1:3),ScapCoord(2,4)+50*ScapCoord(2,1:3),ScapCoord(3,4)+50*ScapCoord(3,1:3),{'X_S','Y_S','Z_S'})
% %     


%% Plotting Trunk CS - in Marker CS
figure(30)
     quiver3(TrunkCS([1 1 1],4)',TrunkCS([2 2 2],4)',TrunkCS([3 3 3],4)',50*TrunkCS(1,1:3),50*TrunkCS(2,1:3),50*TrunkCS(3,1:3))
     text(TrunkCS(1,4)+50*TrunkCS(1,1:3),TrunkCS(2,4)+50*TrunkCS(2,1:3),TrunkCS(3,4)+50*TrunkCS(3,1:3),{'X_t','Y_t','Z_t'})
     
%      
%      
%     
 %%   %%%%%%%%%%%%%%%%%%%%% BONE CS%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converting BLs to BONE

% Bl_bone = inv(ScapCoord)*BLs_marker;
  

%% 
% figure()
% 
% %Plotting the BonyLandmarks and their Labels
% for i = 1:length(BlNames)
%     plot3(Bl_bone(1,i),Bl_bone(2,i),Bl_bone(3,i),'-o','Color','b','MarkerSize',10,...
%         'MarkerFaceColor','#D9FFFF')
%     hold on
%     text(Bl_bone(1,i),Bl_bone(2,i),Bl_bone(3,i),BlNames(i),'FontSize',14)
% end
% 
% %Plotting the Scapular Polygon
% plot3([Bl_bone(1,4) Bl_bone(1,3)],[Bl_bone(2,4) Bl_bone(2,3)],[Bl_bone(3,4) Bl_bone(3,3)],'r') % line between AI and TS
% plot3([Bl_bone(1,4) Bl_bone(1,2)],[Bl_bone(2,4) Bl_bone(2,2)],[Bl_bone(3,4) Bl_bone(3,2)],'r') % line between AI and AA
% plot3([Bl_bone(1,3) Bl_bone(1,1)],[Bl_bone(2,3) Bl_bone(2,1)],[Bl_bone(3,3) Bl_bone(3,1)],'r') % line between TS and AC
% plot3([Bl_bone(1,1) Bl_bone(1,2)],[Bl_bone(2,1) Bl_bone(2,2)],[Bl_bone(3,1) Bl_bone(3,2)],'r') % line between AC and AA
% 
% 
% axis equal
% xlabel('X axis (mm)')
% ylabel('Y axis (mm)')
% zlabel('Z axis (mm)')
% 
% title([titleplot  ' ' 'in Bone CS'],'FontSize',16)
% 

end


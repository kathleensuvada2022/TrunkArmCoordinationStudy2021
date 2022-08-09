
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to estimate the center of rotation of the GH joint
% based on a regression equation of the scapular bony landmarks
% (AC, AA, TS, AI)
% ADD REFERENCE AND CHECK THE REGRESSION MODEL TO MATCH THE CSs
%       input : bl=[ac aa ts ai] (3D coordinates of scapular bony landmarks in
%                              the scapular CS)
%               Rsca (scapula rotation matrix)
%       output: gh (3D coordinates of the center of rotation of the GH
%                   joint in scapular CS) -

% Kacey 
% want to add Computed GH to BL file 
% Output: GH in marker CS 
% Inputs: BLs in marker CS (raw data file) 
  %RSCA: Rotation matrix created via BLs in bone CS 
% Done one time at the beginning via BL data

%Kacey Winter 2021
% 1) INPUTS bl: BLs_lcs_s bony landmarks of scap in Marker and Rsca: ScapCoord in bone CS
% 2) Convert BLs and CS to Bone CS 



%Updates Summer 2022- this linear regression was not found in the
%literature. Not sure where it came from. Benefit is that is does not use
%Pc but can't find original source. If PC is good just use Meskers and the
%Meskers Modified linear regression.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function [TrunkCS_bone gh_markr]=ghest_KS(bl_mark_s,Rscap_mark,bl_mark_t,Rtrunk_mark,flag,partid,arm,j)
function gh_markr=ghest_KS_OLD(bl_mark_s,Rscap_mark,bl_mark_t,Rtrunk_mark,partid,arm)
%% Rsca=asscap(ac,ts,ai); % No longer necessary, Rscap is an input

%organizing BLS
% bl = zeros(4,4);
% for i =1:4
% bl(1:4,i) = bl_mark{1,i}(:,1);
% end

%% Scapular CS and BLs 

% ["AC","AA","TS","AI"] KACEY'S BL ORDER
% for j = 1:4
% bl(1:3,j) = Rscap_mark'*bl(1:3,j); %converting BLs to Scapular CS
% end

% row0 = [0 0 0 1];
% col0 = [0 0 0]';
% Rscap_mark= cat(2, Rscap_mark,col0);
% Rscap_mark = cat(1, Rscap_mark,row0);




%% BLS of Scapula and Convert to bone CS

% Bony Landmarks in BONE cs 
bl = bl_mark_s;
bl(:,:) = inv(Rscap_mark)*bl; %BL's now in Scapular CS (BONE CS) 

% Plotting BLS of Scapula and CS in BONE 
figure(24)

plot3(bl(1,1),bl(2,1),bl(3,1),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
hold on
text(bl(1,1),bl(2,1),bl(3,1),'AC','FontSize',14)
plot3(bl(1,2),bl(2,2),bl(3,2),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,2),bl(2,2),bl(3,2),'AA','FontSize',14)
plot3(bl(1,3),bl(2,3),bl(3,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,3),bl(2,3),bl(3,3),'TS','FontSize',14)
plot3(bl(1,4),bl(2,4),bl(3,4),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,4),bl(2,4),bl(3,4),'AI','FontSize',14)
plot3(bl(1,5),bl(2,5),bl(3,5),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,5),bl(2,5),bl(3,5),'PC','FontSize',14)

%Plotting the Scapular Polygon
plot3([bl(1,4) bl(1,3)],[bl(2,4) bl(2,3)],[bl(3,4) bl(3,3)],'r') % line between AI and TS
plot3([bl(1,4) bl(1,2)],[bl(2,4) bl(2,2)],[bl(3,4) bl(3,2)],'r') % line between AI and AA
%plot3([bl(1,3) bl(1,2)],[bl(2,3) bl(2,2)],[bl(3,3) bl(3,2)],'r') % line between TS and AA
plot3([bl(1,3) bl(1,1)],[bl(2,3) bl(2,1)],[bl(3,3) bl(3,1)],'r') % line between TS and AC
plot3([bl(1,1) bl(1,2)],[bl(2,1) bl(2,2)],[bl(3,1) bl(3,2)],'r') % line between AC and AA

title('Scapula CS and BLs in Bone CS')
axis equal
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
%% Trunk CS and BLs

%BLnames_t = ["SC","IJ","PX","C7","T8"]; Order of the trunk BLS

if bl_mark_t ~= 0
    bl_trunk = bl_mark_t; %Bony Landmarks of the trunk in Marker CS
    bl_trunk(:,:) = inv(Rtrunk_mark)*bl_trunk; %BL's now in Trunk CS (BONE CS)

else 
    'Trunk Data Empty'
    
   % bl_trunk = zeros(3,5);
end 

%% Rotating BLS 90 about x so aligned with original system
% bl =[rotx(-90) zeros(3,1); zeros(1,3) 1]*bl; %  - Shoulder 
% 
% if bl_mark_t ~= 0
% 
% bl_trunk =[rotx(90) zeros(3,1); zeros(1,3) 1]*bl_trunk; % -Trunk
% end

%% 
% Rotating 180 about Z 
% Rsca=Rsca*diag([-1 -1 1]); % Flips the x and y axes == 180 degree rotation about z % changing to that Scap Coord follows original definition

%% 
% Rscap =rotx(deg2rad(90))*Rscap_mark(1:3,1:3); % make sure consistent with paper description 
% Scap_org = bl(:,1);
% Rscap= cat(2, Rscap,Scap_org(1:3));
% Rscap= cat(1, Rscap,row0);
%  % Plotting rotated R and BLs
% 
%  figure()
% quiver3(Rscap([1 1 1],4)',Rscap([2 2 2],4)',Rscap([3 3 3],4)',50*Rscap(1,1:3),50*Rscap(2,1:3),50*Rscap(3,1:3))
% %quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
% text(50*Rscap(1,1:3),50*Rscap(2,1:3),50*Rscap(3,1:3),{'x','y','z'})
% hold on
% for p = 1:length(bl)
% plot3(bl(1,p),bl(2,p),bl(3,p),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,p),bl(2,p),bl(3,p),BLnames_s(p),'FontSize',12)
% end
% axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')
% 
% pause
 %%

% Osca=(bl(1:3,1)+bl(1:3,2))/2; % Osca=(ac+aa)/2; compute midpoint between AC and AA

% ac=Rsca'*(ac-Osca); No necessary because BLs are already in scapular CS
% aa=Rsca'*(aa-Osca);
% ts=Rsca'*(ts-Osca);
% ai=Rsca'*(ai-Osca);

% Change origin to midpoint between AC and AA
% bl(1:3)=bl(1:3)-repmat(Osca,1,4); % for 4 Bls

%%

% ["AC","AA","TS","AI","PC"]; K.Suvada Order of BLS Scap
lacaa=norm(bl(:,1)-bl(:,2));
lacts=norm(bl(:,1)-bl(:,3)); 
lacai=norm(bl(:,1)-bl(:,4)); 
ltsai=norm(bl(:,3)-bl(:,4)); 


lacaa=norm(ac-aa); % length from AC to AA
lacts=norm(ac-ts); % length from AC to TS
lacai=norm(ac-ai);  % length from AC to AI
ltsai=norm(ts-ai); % length from TS to AI
%%
% % TWO DIFFERENT REGRESSION EQUATIONS (2 AND 3 ARE THE SAME EXCEPT FOR THE NUMBER OF DECIMALS) WHICH ONE IS BEST????
% ghrel=[ ...
%   [  lacaa lacts       ltsai]*[     0.45 -0.28        0.18]';
%   [1       lacts lacai      ]*[-70        0.73 -0.28      ]';
%   [        lacts lacai ltsai]*[          -0.51  0.42 -0.38]'];
% 
%   ghrel=[ ...
%     [1       lacts lacai      ]*[  9.8       -0.399  0.223      ]';
%     [1       lacts lacai      ]*[-69.6        0.731 -0.277      ]';
%     [1       lacts lacai      ]*[ -2.7       -0.297  0.065      ]'];

% AMA changed ghrel to gh since the last rotation is not needed.
  gh=[ ...
    [1       lacts lacai      ]*[ 10       -0.40  0.22      ]'; % Xcoord
    [1       lacts lacai      ]*[-70        0.73 -0.28      ]';  % Y coord
    [1       lacts lacai      ]*[ -3       -0.30  0.06      ]']; % Z coord


% 1X3 * (1X3)' --> 1X3* 3X1 = 1X1 ( x coord) '

% Rotating 90 degrees to align with original Defintion of SCAP CS
% ScapCS_bone= [rotx(-90) zeros(3,1); zeros(1,3) 1]*ScapCS_bone;


%% Trunk CS in Bone
% if bl_mark_t ~= 0
% 
% TrunkCS_bone = inv(Rtrunk_mark)*Rtrunk_mark;
% 
% % Rotating 90 degrees to align with original Defintion of Trunk CS
% TrunkCS_bone= [rotx(90) zeros(3,1); zeros(1,3) 1]*TrunkCS_bone;
% end

%% Testing and plotting computed GH - still in rotated CS 

%flag = 1;

% %   if j==1
% % %     
% % % Plotting Scapular CS and BLS
% % % 
% figure(25)
% quiver3(ScapCS_bone([1 1 1],4)',ScapCS_bone([2 2 2],4)',ScapCS_bone([3 3 3],4)',50*ScapCS_bone(1,1:3),50*ScapCS_bone(2,1:3),50*ScapCS_bone(3,1:3))
% hold on
% text(ScapCS_bone(1,4)+50*ScapCS_bone(1,1:3),ScapCS_bone(2,4)+50*ScapCS_bone(2,1:3),ScapCS_bone(3,4)+50*ScapCS_bone(3,1:3),{'x','y','z'})
% 
% plot3(bl(1,1),bl(2,1),bl(3,1),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% hold on
% text(bl(1,1),bl(2,1),bl(3,1),'AC','FontSize',14)
% plot3(bl(1,2),bl(2,2),bl(3,2),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,2),bl(2,2),bl(3,2),'AA','FontSize',14)
% plot3(bl(1,3),bl(2,3),bl(3,3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,3),bl(2,3),bl(3,3),'TS','FontSize',14)
% plot3(bl(1,4),bl(2,4),bl(3,4),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,4),bl(2,4),bl(3,4),'AI','FontSize',14)
% plot3(bl(1,5),bl(2,5),bl(3,5),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,5),bl(2,5),bl(3,5),'PC','FontSize',14)
% 
% %Plotting the Scapular Polygon
% plot3([bl(1,4) bl(1,3)],[bl(2,4) bl(2,3)],[bl(3,4) bl(3,3)],'r') % line between AI and TS
% plot3([bl(1,4) bl(1,2)],[bl(2,4) bl(2,2)],[bl(3,4) bl(3,2)],'r') % line between AI and AA
% %plot3([bl(1,3) bl(1,2)],[bl(2,3) bl(2,2)],[bl(3,3) bl(3,2)],'r') % line between TS and AA
% plot3([bl(1,3) bl(1,1)],[bl(2,3) bl(2,1)],[bl(3,3) bl(3,1)],'r') % line between TS and AC
% plot3([bl(1,1) bl(1,2)],[bl(2,1) bl(2,2)],[bl(3,1) bl(3,2)],'r') % line between AC and AA
% 
% 
% axis equal
% xlabel('x axis')
% ylabel('y axis')
% zlabel('z axis')
% % 
%  title('Scapular CS and BLs in BONE CS- Rotated 90','FontSize',16)

figure(29)
 plot3(gh(1),gh(2),gh(3),'-o','Color','c','MarkerSize',10,...
     'MarkerFaceColor','#D9FFFF')
  text(gh(1),gh(2),gh(3),'GHComputed_M_a_r_k_e_r','FontSize',14) % ?????? seems like this computed GH is in marker 
  
  
  %% Kacey GH testing July 2022 - with old CS converting to Bone??? with original CS
  
  gh_marker = (Rscap_mark)*[gh;1];
  figure(24)
   plot3(gh_bone(1),gh_bone(2),gh_bone(3),'-o','Color','m','MarkerSize',10,...
     'MarkerFaceColor','#D9FFFF')
  text(gh_bone(1),gh_bone(2),gh_bone(3),'GHComputed_b_o_n_e','FontSize',14)
  %%
%  
% % Plotting Trunk CS and BLS
% 
% %BLnames_t = ["SC","IJ","PX","C7","T8"]; Order of the trunk BLS
% if bl_mark_t ~= 0
% 
% figure(17)
% quiver3(TrunkCS_bone([1 1 1],4)',TrunkCS_bone([2 2 2],4)',TrunkCS_bone([3 3 3],4)',50*TrunkCS_bone(1,1:3),50*TrunkCS_bone(2,1:3),50*TrunkCS_bone(3,1:3))
% hold on
% text(TrunkCS_bone(1,4)+50*TrunkCS_bone(1,1:3),TrunkCS_bone(2,4)+50*TrunkCS_bone(2,1:3),TrunkCS_bone(3,4)+50*TrunkCS_bone(3,1:3),{'x','y','z'})
% 
% plot3(bl_trunk(1,1),bl_trunk(2,1),bl_trunk(3,1),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl_trunk(1,1),bl_trunk(2,1),bl_trunk(3,1),'SC','FontSize',14)
% plot3(bl_trunk(1,2),bl_trunk(2,2),bl_trunk(3,2),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl_trunk(1,2),bl_trunk(2,2),bl_trunk(3,2),'IJ','FontSize',14)
% plot3(bl_trunk(1,3),bl_trunk(2,3),bl_trunk(3,3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl_trunk(1,3),bl_trunk(2,3),bl_trunk(3,3),'PX','FontSize',14)
% plot3(bl_trunk(1,4),bl_trunk(2,4),bl_trunk(3,4),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl_trunk(1,4),bl_trunk(2,4),bl_trunk(3,4),'C7','FontSize',14)
% plot3(bl_trunk(1,5),bl_trunk(2,5),bl_trunk(3,5),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl_trunk(1,5),bl_trunk(2,5),bl_trunk(3,5),'T8','FontSize',14)
% 
% axis equal
% xlabel('x axis')
% ylabel('y axis')
% zlabel('z axis')
% title('Trunk CS and BonyLandmarks in BONE Coordinate System','FontSize',16)

% end 
%  
%  
 

%%


% if strcmp(partid,'RTIS2002') && strcmp(arm,'Right')
%       gh(2) = -gh(2); %Based on figure make y neg
% elseif strcmp(partid,'RTIS2003') && strcmp(arm,'Right')   
%    gh(2) = -gh(2); %Based on figure make y neg
% elseif strcmp(partid,'RTIS2006') && strcmp(arm,'Right')   
%     gh(2) = -gh(2)/2; 
%     gh(1) = -gh(1); 
% %    
% 
% else 
%     
%   
% end
return
%% Rotate GH and BLs, and CS back to my Coordinate system definition

gh_rot = rotx(90)*gh; % Rotated GH back to Kacey's CS still in the Bone CS
ScapCS_bone= [rotx(90) zeros(3,1); zeros(1,3) 1]*ScapCS_bone;
bl =[rotx(90) zeros(3,1); zeros(1,3) 1]*bl; %  - Shoulder 


%Checking if trunk matrix empty and also rotating back to my
%definition
if bl_mark_t ~= 0

bl_trunk =[rotx(-90) zeros(3,1); zeros(1,3) 1]*bl_trunk; % -Trunk
end


if bl_mark_t ~= 0

TrunkCS_bone = inv(Rtrunk_mark)*Rtrunk_mark;

% % Rotating 90 degrees to align with original Defintion of Trunk CS
% TrunkCS_bone= [rotx(90) zeros(3,1); zeros(1,3) 1]*TrunkCS_bone;
end


%%

%% Testing and plotting computed GH -Kacey's Orientation
% Scapular Coordinate System in BONE frame with Respective BLs in BONE (AC and CS should be
% centered at (0,0,0)


 if j==1
    
% Plotting Scapular CS and BLS

%BLnames_s = ["AC","AA","TS","AI","PC"];


figure(16)
quiver3(ScapCS_bone([1 1 1],4)',ScapCS_bone([2 2 2],4)',ScapCS_bone([3 3 3],4)',50*ScapCS_bone(1,1:3),50*ScapCS_bone(2,1:3),50*ScapCS_bone(3,1:3))
hold on
text(ScapCS_bone(1,4)+50*ScapCS_bone(1,1:3),ScapCS_bone(2,4)+50*ScapCS_bone(2,1:3),ScapCS_bone(3,4)+50*ScapCS_bone(3,1:3),{'x','y','z'})

plot3(bl(1,1),bl(2,1),bl(3,1),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,1),bl(2,1),bl(3,1),'AC','FontSize',14)
plot3(bl(1,2),bl(2,2),bl(3,2),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,2),bl(2,2),bl(3,2),'AA','FontSize',14)
plot3(bl(1,3),bl(2,3),bl(3,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,3),bl(2,3),bl(3,3),'TS','FontSize',14)
plot3(bl(1,4),bl(2,4),bl(3,4),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,4),bl(2,4),bl(3,4),'AI','FontSize',14)

plot3(bl(1,5),bl(2,5),bl(3,5),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl(1,5),bl(2,5),bl(3,5),'PC','FontSize',14)
 
%Plotting the Scapular Polygon
plot3([bl(1,4) bl(1,3)],[bl(2,4) bl(2,3)],[bl(3,4) bl(3,3)],'r') % line between AI and TS
plot3([bl(1,4) bl(1,2)],[bl(2,4) bl(2,2)],[bl(3,4) bl(3,2)],'r') % line between AI and AA
plot3([bl(1,3) bl(1,1)],[bl(2,3) bl(2,1)],[bl(3,3) bl(3,1)],'r') % line between TS and AC
plot3([bl(1,1) bl(1,2)],[bl(2,1) bl(2,2)],[bl(3,1) bl(3,2)],'r') % line between AC and AA


axis equal
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')

title('Scapular CS and BLs in BONE CS during trial -Kacey Orientation during digitization','FontSize',16)
plot3(gh_rot(1),gh_rot(2),gh_rot(3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
 text(gh_rot(1),gh_rot(2),gh_rot(3),'GHComputed','FontSize',14) %Kacey saw making y and z neg may be correct
 
% % Plotting Trunk CS and BLS
% 
% %BLnames_t = ["SC","IJ","PX","C7","T8"]; Order of the trunk BLS
if bl_mark_t ~= 0

    

figure(17)
quiver3(TrunkCS_bone([1 1 1],4)',TrunkCS_bone([2 2 2],4)',TrunkCS_bone([3 3 3],4)',50*TrunkCS_bone(1,1:3),50*TrunkCS_bone(2,1:3),50*TrunkCS_bone(3,1:3))
hold on
text(TrunkCS_bone(1,4)+50*TrunkCS_bone(1,1:3),TrunkCS_bone(2,4)+50*TrunkCS_bone(2,1:3),TrunkCS_bone(3,4)+50*TrunkCS_bone(3,1:3),{'x','y','z'})

plot3(bl_trunk(1,1),bl_trunk(2,1),bl_trunk(3,1),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl_trunk(1,1),bl_trunk(2,1),bl_trunk(3,1),'SC','FontSize',14)
plot3(bl_trunk(1,2),bl_trunk(2,2),bl_trunk(3,2),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl_trunk(1,2),bl_trunk(2,2),bl_trunk(3,2),'IJ','FontSize',14)
plot3(bl_trunk(1,3),bl_trunk(2,3),bl_trunk(3,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl_trunk(1,3),bl_trunk(2,3),bl_trunk(3,3),'PX','FontSize',14)
plot3(bl_trunk(1,4),bl_trunk(2,4),bl_trunk(3,4),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl_trunk(1,4),bl_trunk(2,4),bl_trunk(3,4),'C7','FontSize',14)
plot3(bl_trunk(1,5),bl_trunk(2,5),bl_trunk(3,5),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(bl_trunk(1,5),bl_trunk(2,5),bl_trunk(3,5),'T8','FontSize',14)

axis equal
xlabel('x axis')
ylabel('y axis')
zlabel('z axis')
title('Trunk CS and BonyLandmarks in BONE Coordinate System during digitization','FontSize',16)

end 
 
 
pause
 end 
% 



%% Then Get GH computed back into marker CS 
%Rscap_mark2 = Rscap_mark(1:3,1:3); % Just the rotation matrix
gh_markr = Rscap_mark*[gh_rot;1]; %Rotated GH now converted to the Marker CS --> THIS IS MARKER OF SCAPULAR 


%%
%gh=Rsca*ghrel+Osca; Not needed because GH is in scapular CS


end

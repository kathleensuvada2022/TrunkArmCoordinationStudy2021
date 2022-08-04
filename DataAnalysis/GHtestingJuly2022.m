% August 2022 K.Suvada

% To help Kacey with Testing GH computation. 


%% Loading in Setup file
filepath = '/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data';
 partid = 'GHTesting812022'; % Skeleton Dataset 1
%  partid = 'GHTesting812022_dataset2'; % Skeleton Dataset 2

% partid = 'RTIS2002';
load(fullfile(filepath,partid,'Right',[partid '_setup.mat'])); %load setup file 

arm = 'Right';

%% Load in BLS for participant- raw data

BLs = setup.bl; % BLs in marker CS

blmat= BLs{1,2}; %Scapular BLs in MARKER CS

BlNames = ["AC","AA","TS","AI","PC","GH"];
BLs_marker = blmat;

ACidx = find(BlNames=='AC');
[AC,AA,TS,AI,PC,GH]=deal(blmat(:,ACidx),blmat(:,ACidx+1),blmat(:,ACidx+2),blmat(:,ACidx+3),blmat(:,ACidx+4),blmat(:,ACidx+5));


aa = AA(1:3);
pc= PC(1:3);
ai = AI(1:3);
ts = TS(1:3);
ac = AC(1:3);
gh_dig = GH(1:3);


%% Compute Distances - confirming PC 

Dist_PC_AC = norm(pc-ac)
Dist_PC_AA = norm(pc-aa);
%% Creating Scapular CS -MESKERS

xs = (AC(1:3)-TS(1:3)) / norm(AC(1:3)-TS(1:3));
zhulp = cross(xs,(AC(1:3)-AI(1:3)));
zs = zhulp/norm(zhulp);
ys = cross(zs,xs);
s = [xs,ys,zs];

s = [s;0 0 0];

Orig = AC(1:4);

%Scapular CS in Marker Frame with origin at AC
ScapCoord = [s Orig];

Rsca = ScapCoord(1:3,1:3);
%% Creating Scapular CS - NON PC flipped 180 about Z
% xs = (TS(1:3)-AC(1:3)) / norm(TS(1:3)-AC(1:3));
% zhulp = cross(xs,(AI(1:3)-AC(1:3)));
% zs = zhulp/norm(zhulp);
% ys = cross(zs,xs);
% s = [xs,ys,zs];
% 
% s = [s;0 0 0];
% 
% Orig = AC(1:4);
% 
% %Scapular CS in Marker Frame with origin at AC
% ScapCoord = [s Orig];
% 
% Rsca = ScapCoord(1:3,1:3);
%% Plotting BLs and Scap CS

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


%% Converting BLS to Bone CS 

Bls_bone_AC = inv(ScapCoord)* blmat;

%% Plotting BLs With origin at AC 

figure(31)
%Plotting the BonyLandmarks and their Labels
for i = 1:length(BlNames)
    plot3(Bls_bone_AC(1,i),Bls_bone_AC(2,i),Bls_bone_AC(3,i),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(Bls_bone_AC(1,i),Bls_bone_AC(2,i),Bls_bone_AC(3,i),BlNames(i),'FontSize',14)
end

%Plotting the Scapular Polygon
plot3([Bls_bone_AC(1,4) Bls_bone_AC(1,3)],[Bls_bone_AC(2,4) Bls_bone_AC(2,3)],[Bls_bone_AC(3,4) Bls_bone_AC(3,3)],'r') % line between AI and TS
plot3([Bls_bone_AC(1,4) Bls_bone_AC(1,2)],[Bls_bone_AC(2,4) Bls_bone_AC(2,2)],[Bls_bone_AC(3,4) Bls_bone_AC(3,2)],'r') % line between AI and AA
%plot3([Bls_bone_AC(1,3) Bls_bone_AC(1,2)],[Bls_bone_AC(2,3) Bls_bone_AC(2,2)],[Bls_bone_AC(3,3) Bls_bone_AC(3,2)],'r') % line between TS and AA
plot3([Bls_bone_AC(1,3) Bls_bone_AC(1,1)],[Bls_bone_AC(2,3) Bls_bone_AC(2,1)],[Bls_bone_AC(3,3) Bls_bone_AC(3,1)],'r') % line between TS and AC
plot3([Bls_bone_AC(1,1) Bls_bone_AC(1,2)],[Bls_bone_AC(2,1) Bls_bone_AC(2,2)],[Bls_bone_AC(3,1) Bls_bone_AC(3,2)],'r') % line between AC and AA


axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title('Bls in Bone CS during digitization- Origin AC','FontSize',16)

%% BLS in Bone with center at AC

%Order of BLs: ["AC","AA","TS","AI","PC"];

 
ac = Bls_bone_AC(:,1);
aa = Bls_bone_AC(:,2);
ts = Bls_bone_AC(:,3);
ai = Bls_bone_AC(:,4);
pc = Bls_bone_AC(:,5);
gh_dig = Bls_bone_AC(:,6);


%% Linear Regression - MESKERS with PC!! 

lacaa=norm(ac(1:3)-aa(1:3));
ltspc=norm(ts(1:3)-pc(1:3));
laiaa=norm(ai(1:3)-aa(1:3));
lacpc=norm(ac(1:3)-pc(1:3));
  
scx=[1 pc(1) ai(1) laiaa pc(2)]';
scy=[1 lacpc pc(2) lacaa ai(1) ]';
scz=[1 pc(2) pc(3) ltspc ]';

thx=[18.9743    0.2434    0.2341    0.1590    0.0558];
thy=[-3.8791   -0.1002    0.1732   -0.3940    0.1205];
thz=[ 9.2629   -0.2403    1.0255    0.1720];


GHx = thx*scx;
GHy = thy*scy;
GHz = thz*scz;

gh_b=[GHx;GHy;GHz]; %gh in bone
%% Linear Regression - Modified Meskers Model 

laipc=norm(ai(1:3)-pc(1:3));
laapc=norm(aa(1:3)-pc(1:3));
  
scx=[1 ts(1) laipc]';
scy=[1 ac(2) pc(3)]';
scz=[1 laapc ts(1)]';

thx=[26.896 .61 .295];
thy=[-16.307 .825 .293];
thz=[-1.740 -.899 -.229];


GHx = thx*scx;
GHy = thy*scy;
GHz = thz*scz;

gh_b=[GHx;GHy;GHz]; %gh in bone
%% Linear Regression - NO PC!!

lacaa=norm(ac(1:3)-aa(1:3)); % length from AC to AA
lacts=norm(ac(1:3)-ts(1:3)); % length from AC to TS
lacai=norm(ac(1:3)-ai(1:3));  % length from AC to AI
ltsai=norm(ts(1:3)-ai(1:3)); % length from TS to AI

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

gh_b2 = gh;
%% MESKERS
%
figure(31)
plot3(gh_b(1), gh_b(2),gh_b(3),'*')
text(gh_b(1), gh_b(2),gh_b(3),'GH PC_Modified')

%% NON PC MODEL
figure(31)
plot3(gh_b2(1), gh_b2(2),gh_b2(3),'*')
text(gh_b2(1), gh_b2(2),gh_b2(3),'GH NOPC')
hold on 
plot3(pc(1),pc(2),pc(3),'o')
text(pc(1),pc(2),pc(3),'PC')
hold on
plot3(aa(1),aa(2),aa(3),'o')
text(aa(1),aa(2),aa(3),'AA')
plot3(ai(1),ai(2),ai(3),'o')
text(ai(1),ai(2),ai(3),'AI')
plot3(ac(1),ac(2),ac(3),'o')
text(ac(1),ac(2),ac(3),'AC')
plot3(ts(1),ts(2),ts(3),'o')
text(ts(1),ts(2),ts(3),'TS')

%Plotting the Scapular Polygon
plot3([ai(1) ts(1)],[ai(2) ts(2)],[ai(3) ts(3)],'r') % line between AI and TS
plot3([ai(1) aa(1)],[ai(2) aa(2)],[ai(3) aa(3)],'r') % line between AI and AA
plot3([ts(1) ac(1)],[ts(2) ac(2)],[ts(3) ac(3)],'r') % line between TS and AC
% plot3([ac(1) aa(1)],[ac(2) aa(2)],[aa(3) ac(3)],'r') % line between AC and AA
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

%% Converting back to Marker CS

gh_b2=(Rsca*gh_b2(1:3))+Osca(1:3); 
ac=(Rsca*ac(1:3))+Osca(1:3); 
aa=(Rsca*aa(1:3))+Osca(1:3); 
ts=(Rsca*ts(1:3))+Osca(1:3); 
ai=(Rsca*ai(1:3))+Osca(1:3); 
pc=(Rsca*pc(1:3))+Osca(1:3);
  

%%  GH in Shoulder marker
 gh_m=(ScapCoord*[gh_b;1]); 
%gh_m=(ScapCoord*[gh_b2;1]); 
figure(29)
 plot3(gh_m(1),gh_m(2),gh_m(3),'o')
  text(gh_m(1),gh_m(2),gh_m(3),'GHPC_original')
%     text(gh_m(1),gh_m(2),gh_m(3),'GHMeskers')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Scapular CS - NON PC (OLD DON'T USE)
% 
% xs = (TS(1:3)-AC(1:3)) / norm(TS(1:3)-AC(1:3));
% zhulp = cross(xs,(AC(1:3)-AI(1:3)));
% zs = zhulp/norm(zhulp);
%  ys = cross(zs,xs);
% 
% s = [xs,ys,zs];
% 
% s = [s;0 0 0];
% 
% Orig = AC(1:4);
% 
% %Scapular CS in Marker Frame with origin at AC
% ScapCoord = [s Orig];
% 
% Rsca = ScapCoord(1:3,1:3);
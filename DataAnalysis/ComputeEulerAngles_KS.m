%% Created October 2021  K. Suvada

%% Works as of NOV 4th 2021
%%
% Kacey's Bone CSs are st: the Y is forwards, X is to the right and Z is up
% ( from behind)

% Function based off of "ComputeEulerAngles".  for
% Kacey's Project. Used to get Metria Data into Local Coordinate systems of
% markers and then to the global coordinate system. Creates bone coordinate
% systems for the 1)trunk 2)shoulder 3) Forearm 4) Humerus.

% Use Flag ==1 if want to plot local coordinate systems individually and
% BLs in the created Bone CS. 

% Use Flag ==0 if want all trial data in the global coordinate system. 


% Order the Coord. Sys are Output in:  TRUNK SHOULDER  HUM  FORE 
%Use Below for Testing 
%[BLs_G,BL_names_all,CS_G,PMCP_G,jANGLES,elbowangle,gANGLES] = ComputeEulerAngles_KS('trial10','Right','RTIS1005',1)

% For Humerus angle rel to trunk so then for ZYZa- it would be Z is polar angle, Y, is abduction, Za is internal external rotation

%function [BLs_G,BL_names_all,CS_G,PMCP_G,jANGLES,elbowangle,gANGLES] = ComputeEulerAngles_KS(filename,arm,partid,flag)
%%
filename = 'trial10';
arm = 'Right';
partid = 'RTIS1005';
flag =1;
% Function to process bony landmark data to compute bone and joint rotations (adapted from Dutch program CalcInputKinem).
% Right now we are inputting bldata as the global coordinates of the
% system, but I think we actually want the local coordinates and the data
% instead
% Use :	[gANGLES,jANGLES]=ComputeEulerAngles(bldata,arm,reffr)
%			bldata = bony landmark coordinates over nsamples for
%                    (1)trunk [4x5xnsamples] (SC,IJ,PX,C7,T8),
%                    (2)scapula [4x5xnsamples] (AC,AA,TS,AI,PC) and
%                    (3)humerus[4x3xnsamples] (EM,EL,GH)
%                    cell array {1x3}
% AMA 9/29/21 For Kacey's data, inputs can be BL in local CSs(bldata) + HT for each
% segment (marker)(HT_seg) over nsamples.
%           arm = right or left
%			reffr = trunk('T') or room ('R') frame of reference
%
%			gAngles = bone angles in global coordinates
%			jAngles = joint angles
%

% August 12, 1996, Frans van der Helm
% March 11, 1997 Ana Maria Acosta
% May 8, 1998	Ana Maria Acosta
% October 26, 2015 Ana Maria Acosta - adapted program to run with Amee
% Seitz's data acquisition program.
% June 22, 2016 Allie Johnson - Modified GH calculation to match the Helical Axes method.
% September 25, 2018 (v10) Ana Maria Acosta - added comments and cleaned up code
% based on Sabeen Admani's additions to the code over 2017-18.
% September 29, 2021 Kacey Suvada - edited code to match experimental
% protocol:
% 1) Modifying inputs: BL and HT
% 2) Modifying outputs: adding Pmcp in G, Trunk and Humerus CSs
% 3) Modifying Global and Local CS so that x is to the right, y is anterior
%    and z is up.
% 4) Ignore Clavicle for now



%if nargin<3, reffr='trunk'; end
%% Loading in the BL data (Digitization) and the BLs Names

datafilepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data','/',partid,'/',arm];
load([datafilepath '/' partid,'_','setup']);

%From Kacey's MetriaKinDAQ 10.2021
% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm'};
bonylmrks = ["SC" "IJ" "PX" "C7" "T8" "AC" "AA" "TS" "AI" "PC" "EM" "EL" "GH" "RS" "US" "OL" "MCP"]';  % IN THIS ORDER
%% Concatenate the bony landmarks into one cell array 
load([datafilepath '/BL.mat']) %loading in BL file 
bldata=bl;
blmat=cat(1,bldata{1},bldata{2},bldata{3},bldata{4}); %coordinates in the frame of the marker
nland=size(blmat,1);
% Using GH from Digitization %%%%%%%%%
GHIDX = find(bonylmrks=='GH');
GH = blmat(GHIDX ,1:3); %XYZ coordinate of GH from Digitization in meantime
GH = [GH 1];

%% Loading in trial Data 
load([datafilepath,'/', filename]) %loading in trial data 

x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

t = (x(:,2)-x(1,2))/89; 
%% Getting HT in marker to global (during trial data) 
%Organizing Trial Data by Marker Number/ Bone 
[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xhum=x(:,aidx:(aidx+6)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshoulder=x(:,sidx:(sidx+ 6)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1)+1;
xtrunk=x(:,tidx:(tidx+6)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end

Tftom = zeros(4,4,length(xfore));   

% Need to reshape 4X4XN

%Forearm
for i=1:length(xfore)
% forearm marker HT
Tftom(:,:,i) = quat2tform(circshift(xfore(i,4:7),1,2)); 
Tftom(1:3,4,i) = xfore(i,1:3)';  
end

%Shoulder
Tstom= zeros(4,4,length(xshoulder));
for i = 1:length(xshoulder)
Tstom(:,:,i)= quat2tform(circshift(xshoulder(i,4:7),1,2));
Tstom(1:3,4,i) = xshoulder(i,1:3)'; 
end 

%Trunk
Tttom=zeros(4,4,length(xtrunk));
for i =1:length(xtrunk)  
Tttom(:,:,i)= quat2tform(circshift(xtrunk(i,4:7),1,2));      
Tttom(1:3,4,i) = xtrunk(i,1:3)';    
end

%Humerus
Thtom=zeros(4,4,length(xhum));
for i =1:length(xtrunk)  
Thtom(:,:,i)= quat2tform(circshift(xhum(i,4:7),1,2));      
Thtom(1:3,4,i) = xhum(i,1:3)';    
end

%               TRUNK SHOULDER HUMERUS FOREARM
TmarkertoGlob = {Tttom Tstom Thtom Tftom}; % HT(marker) in GCS during trial ******
%%
%Swap out the definition for the GH joint center that we estimated earlier
%for the one calculated using the helical axes method
% BLlocal{13}

% BLlocal{3}(1:3,3) = GH;

% AMA - the data in BLglobal is already in the global coordinate system!
% Use the rotation matrix for each of the receivers to the transmitter CS
% to transform the locally defined bony landmark points to points in the
% transmitter CS
% bldata={zeros(4,5,nsamples),zeros(4,5,nsamples),zeros(4,3,nsamples)};
% 
% for i = 1:3
%     for j = 1:nsamples
%         bldata{i}(:,:,j)=data{i}(:,:,j)*BLlocal{i};
%     end
% end

% blmat=cat(2,bldata{3},bldata{1},bldata{2}); %coordinates in the global frame
%blmat3 = blmat;

% R=(rotx(pi/2)*roty(pi/2)*rotz(pi/2)); %fix so that the rotations already take the (-) sign into account
%use Amee's guide to determine rotation
    % 1) Transform data to the global coordinate system with IJ as the origin
    %    (X: left-right, Y: upwards, Z: backwards)
    %    Note that the data is in the transmitter coordinate system
    %    (X: forward, Y: left-right, Z: downwards)
    %     disp('entered the for loop');
% R = rotx(pi/2);
%R = [0 0 -1;1 0 0;0 -1 0];
% R=rotx(pi/2)*rotz(-pi/2); %should be correct
% R = -R; %double check that the (-) sign is actually needed

  
    % ****************************************************************************
%     pVectTot = blmat(1:3,5,i);
%     T=[[R;zeros(1,3)] [(R*pVectTot(1:3));1]]; % Transformation matrix to go from experimentally defined CS to DSEL CS 
%     blmat2 = T*blmat(:,:,i);
%     blmat3(:,:,i) = blmat2;
    
    % **************************************************************
    % 2) Calculate the local coordinate system for each bone
    %    Replaces [AS] = asfunc(X,datast(1).arm);
    % 	 BL = | IJ  SC  AC  EM  RS
    %         | PX  AC  AA  EL  US |
    %         | C7  0   TS  GH  OL |
    %         | T8  0   AI  0   0  |
    % 1  2  3  4  5  6  7  8  9  10 11 12 13
    % EM EL GH SC IJ PX C7 T8 AC AA TS AI PC

    
%% Creating Bone CS for Each Segment
%Trunk CS
[TrunkCS,BLnames_t,BLs_lcs_t ] = asthorho(blmat,bonylmrks);

%Do we need this??? Kacey 10.2021
%if strcmp(arm,'left'), TrunkCS=roty(pi)*TrunkCS; end

%Scapula CS
[ScapCoord,BLnames_s,BLs_lcs_s ] =  asscap(blmat,bonylmrks);

%Forearm CS
[ForeCS,BLs_lcs_f,BLnames_f] =  asfore(blmat,bonylmrks);

% Compute location of GH joint using Regression Function   
% GH=ghest(bl,Rscap); %need to do this!!! 
    
%Humerus CS

[Hum_CS,BLs_lcs_h,BLnames_h] =  ashum(blmat,GH,bonylmrks);


%% GH Computation Here 
% Pass in ScapCoord into ghest function

% save GH to BL file 
   
%%
% Coordinate system for each bone in LCS (marker) -- 1 frame because during
% digitzation 
B_CS_marker = {TrunkCS,ScapCoord,Hum_CS,ForeCS};

%Using FLAG==1 if wanting to plot local CS 
if flag ==1 
    plotBLandCS(BLs_lcs_t,BLnames_t,TrunkCS,'Trunk CS')
    plotBLandCS(BLs_lcs_f,BLnames_f,ForeCS,'Forearm CS')
    plotBLandCS(BLs_lcs_h,BLnames_h,Hum_CS,'Humerus CS')
    plotBLandCS(BLs_lcs_s,BLnames_s,ScapCoord,'Shoulder CS')
end 

%% Looping through all frames in trial for each HT (marker in global)   

for j = 1:length(xtrunk) %artibitrary choosing xtrunk just needs to go through frames 
  % TRUNK SHOULDER HUMERUS FOREARM
%Trunk
%Trunk_Global CS
TtoG(:,:,j)=TmarkertoGlob{1}(:,:,j).*B_CS_marker{1};

% Trunk Bonylandmarks in GCS
for k = 1:length(BLs_lcs_t)
BL_G_t(:,k,j) = TtoG(:,:,j)*inv(cell2mat(B_CS_marker(1)))*(BLs_lcs_t{1,k}(1:4)');
end


%Shoulder
StoG(:,:,j) = TmarkertoGlob{2}(:,:,j)*B_CS_marker{2};

% Shoulder Bonylandmarks in GCS
for k = 1:length(BLs_lcs_s)
BL_G_s(:,k,j) = StoG(:,:,j)*inv(cell2mat(B_CS_marker(2)))*(BLs_lcs_s{1,k}(1:4)');
end


%Humerus
HtoG(:,:,j) = TmarkertoGlob{3}(:,:,j)*B_CS_marker{3};

% Humerus Bonylandmarks in GCS
for k = 1:length(BLs_lcs_h)
BL_G_h(:,k,j) = HtoG(:,:,j)*inv(cell2mat(B_CS_marker(3)))*(BLs_lcs_h{1,k}(1:4)');
end

%Forearm
FtoG(:,:,j) = TmarkertoGlob{4}(:,:,j)*B_CS_marker{4};

% Forearm Bonylandmarks in GCS
for k = 1:length(BLs_lcs_f) 
BL_G_f(:,k,j) = FtoG(:,:,j)*inv(cell2mat(B_CS_marker(4)))*(BLs_lcs_f{1,k}(1:4)');
end

%% Creating matrix AS for a given time point j to get ELBOW ANGLE
%      TRUNK SHOULDER  HUM  FORE

% Need 3x3 rotation matrix for the bones 
AS =[TtoG(1:3,1:3,j) StoG(1:3,1:3,j) HtoG(1:3,1:3,j) FtoG(1:3,1:3,j)];

%Kacey need this? not for elbow angle but if want trunk disp?
%     if strcmp(reffr,'frame')
%         %Use the frame as reference- makes rotation matrix for trunk all
%         %ones, so it doesn't take into account rotations of trunk
%         AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
%         if strcmp(arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
%     end

% Absolute Global Angles
     gR(1:3,1:3) = AS(:,1:3); %trunk rotation matrix in global
     gR(1:3,4:6) = AS(:,7:9); %humerus rotatin matrix in global
% Angles relative to global CS 
    [gANGLES(:,1,j)]=CalcEulerAng(gR(:,1:3),'XZY',0); % Trunk
    [gANGLES(:,2,j)]=CalcEulerAng(gR(:,4:6),'ZYZ',0); % Humerus

     jR = rotjoint(AS); %relative angles

    %     [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ',0); % Trunk
    %     [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX',0);  % Clavicle
    %     [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX',0);  % Scapula
    %     [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY',0); % Humerus   

% Local angles relative to proximal segment
    [jANGLES(:,1,j)]=CalcEulerAng(jR(:,1:3),'XZY',0);    % Forearm in Hum
%     [jANGLES(:,2,j)]=CalcEulerAng(jR(:,4:6),'ZYZ',0);    % Humerus in Trunk 

    
    % **************************************************************
%     if strcmp(reffr,'trunk')
%         eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
%     elseif strcmp(reffr,'frame')
%         eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
%     end


%Moved this outside the for loop because the direction was changing after
% %every sample
% if strcmp(arm,'left')
%     %     if strcmp(datast(1).arm,'left'),
%     % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
%     %         gANGLES = gANGLES';
%     %         gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
%     gANGLES([1,3,4,6,7,9,10,12],:)=-gANGLES([1,3,4,6,7,9,10,12],:);
%     %         jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
% end


end
%% Calculating Elbow Angle
for k = 1:length(jANGLES)
elbowangle(k,1) = jANGLES(1,1,k);
end

%        TRUNK SHOULDER  HUM  FORE

BLs_G = {BL_G_t,BL_G_s,BL_G_h,BL_G_f}; % MAIN OUTPUT BLS in GLOBAL *******  

CS_G = {TtoG,StoG,HtoG,FtoG}; %%%% MAIN OUTPUT HTs of BONES IN GLOBAL At all points in time during trial 

BL_names_all = {BLnames_t;BLnames_s;BLnames_h;BLnames_f};
% ***THE CSs created above are BONE CS in Global CS every point in time ***********

% Want the PMCP to be output in GCS
PMCP_G_test = BL_G_f(:,4,:); % MCP3 in GCS for all time points in trial
PMCP_G = zeros(4,250);

%Reorganizing so that 4 rows by 250 columns
for i = 1:length(xtrunk)
PMCP_G(:,i) = cat(1,PMCP_G_test(:,1,i));
end

if flag==0 

% Calling Function to plot all the data in Global Coord. 
plotCoord_Global(BLs_G,BL_names_all,CS_G)
end 
%end

% FUNCTIONS BELOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TrunkCS,BLnames,BLs_lcs ] = asthorho(blmat,bonylmrks)
%% Edited based on shifted CS for K.Suvada's Experiments
IJidx = find(bonylmrks=='IJ');

[IJ,PX,C7,T8]=deal(blmat(IJidx,:),blmat(IJidx+1,:),blmat(IJidx+2,:),blmat(IJidx+3,:)); % in Marker Local CS
BLnames = ["IJ","PX","C7","T8"];
BLs_lcs ={IJ,PX,C7,T8};

%%
zt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
zt = zt/norm(zt);

blmat_th =[IJ(1:3);PX(1:3);C7(1:3);T8(1:3)];


% [A,DATAa,nvector,e]=vlak(blmat);
% xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
% zt = cross(xhulp,yt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP
% % zt = cross(xhulp,yt);
% zt=zt/norm(zt);
% xt = cross(yt,zt); %SABEEN CHANGE: NEED DIM OF 3 FOR CP

[A,DATAa,nvector,e]=vlak(blmat_th); 


%xhulp is vector normal to the plane
xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
% yt = cross(xhulp,zt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 

%Kacey 10.4.21 flipping order of cross product for Y into the page 
yt = cross(zt(1:3),xhulp); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 

% zt = cross(xhulp,yt);

yt=yt/norm(yt);

%xt = cross(yt(1:3),zt);

%Redefined for Kacey 10.4.21
xt = cross(zt,yt);

% t = [xt,yt,zt];
t = [xt,yt,zt]; 


% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);

t = [xt;yt;zt]';

diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end

t = [t;0 0 0];
orign_trunk = [IJ(1:3) 1]';

%Trunk Coordinate System in Marker CS
TrunkCS = [t orign_trunk];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the humerus in marker CS (local)
% Inputs: EM, EL
% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Y-axis : line between GH and mid-point between epicondyles.
% Local Z-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M

% KACEY 10.4.21
% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Z-axis : line between GH and mid-point between epicondyles.
% Local Y-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Hum_CS,BLs_lcs,BLnames] =  ashum(blmat,GH,bonylmrks)
%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
Emidx = find(bonylmrks=='EM');

[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
BLnames = ["EM","EL","GH"];
BLs_lcs ={EM,EL,GH};
% Kacey Redefining X,Y,Z axes 10.4.21 
H_mid=(EM(1:3)+EL(1:3))/2;
zh = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);
zh = zh; 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3)); %Vector through EL and EM
yh =cross(zh,x); %flipped order because z in opposite direction
yh=yh/norm(yh);


xh = cross (yh,zh);
xh = xh/norm(xh);

h = [xh;yh;zh]';

h = [h;0 0 0];

Origin = [GH(1:3) 1]';

%T of Humerus in marker CS
Hum_CS = [h Origin];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the Forearm local coordinate system.

%Inputs: RS,US,OL
% KACEY 10.4.21
% Local X-axis : defined by Y cross Z
% Local Z-axis : line between OL and mid-point between styloids.
% Local Y-axis : perpendicular to the plane defined by Z axis and line
% through styloids
% GH is determined using regression equations in GHEST.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ForeCS,BLs_lcs,BLnames] =  asfore(blmat,bonylmrks)

%Kacey 10.2021
rsidx = find(bonylmrks=='RS');
[RS,US,OL,MCP3,EM,EL]=deal(blmat(rsidx,:),blmat(rsidx+1,:),blmat(rsidx+2,:),blmat(rsidx+3,:),blmat(rsidx+4,:),blmat(rsidx+5,:));
%RS';'US';'OL';'MCP3';'EM';'EL'
BLnames = ["RS","US","OL","MCP3","EM","EL"];
BLs_lcs ={RS,US,OL,MCP3,EM,EL};


% Kacey Redefining X,Y,Z axes 10.6.21

H_mid=(RS(1:3)+US(1:3))/2;
zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);
%zf = zf; % flipping so vector points cranially 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); %Vector through EL and EM
yf =cross(zf,x); %flipped order because z in opposite direction
yf=-(yf/norm(yf));


xf = cross (zf,yf);
xf = xf/norm(xf);

f = [xf;yf;zf]';
f = [f;0 0 0];


%Creating New Origin Midpoint Between Epicondyles not OL
H_mid_2=(EL(1:3)+EM(1:3)).'/2;
org_fore = [H_mid_2;1];

%Forearm Coordinate System in Marker CF
ForeCS = [f org_fore];


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the scapula local coordinate system.               %
% Input : aa,ts & ai                                                       %
% Output : S = [Xs,Ys,Zs]                                                  %
%                                                                          %
% Origin   : AA-joint.                                                     %
% Local X-axis : axis from TS to AA.                                       %
% Local Z-axis : axis perpendicular to the X-axis and the plane (AA,TS,AI).

% KACEY 10.4.21
% Origin   : AC joint                                                    %
% Local X-axis : axis from TS to AC.                                       %
% Local Y-axis : axis perpendicular to the X-axis and the plane (AA,TS,AI).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ScapCoord,BLnames,BLs_lcs ] =  asscap(blmat,bonylmrks)
%% Old way of creating CS
ACidx = find(bonylmrks=='AC');
[AC,TS,AI]=deal(blmat(ACidx,:),blmat(ACidx+1,:),blmat(ACidx+2,:));
BLnames = ["AC","TS","AI"];
BLs_lcs ={AC,TS,AI};

%%
%Kacey 10.2021
ACidx = find(bonylmrks=='AC');
[AC,TS,AI]=deal(blmat(ACidx,:),blmat(ACidx+1,:),blmat(ACidx+2,:));
BLnames = ["AC","TS","AI"];
BLs_lcs ={AC,TS,AI};
% xs = (AA-TS) / norm(AA-TS);
% zs = cross(xs,(AA-AI/norm(AA-AI)));
% ys = cross(zs,xs);
% S = [xs,ys,zs];

% % AMA 9/29/21 SWITCH CS definition so that x is to the right, y is anterior
% % and z is up.
% xs = (AA-TS) / norm(AA-TS);
% zs = cross(xs,(AA-AI));
% zs = zs/norm(zs);
% ys = cross(zs,xs);

%10.4.21- Kacey Editing based on how want CS aligned 
xs = (AC(1:3)-TS(1:3))/norm(AC(1:3)-TS(1:3)); 
ys = cross(xs,(AC(1:3)-AI(1:3)));
ys = ys/norm(ys);
zs = cross(xs,ys);
zs= zs/norm(zs);
zs=-zs;

S = [xs;ys;zs]';
S = [S; 0 0 0];

Orig = [AC(1:3) 1]';

%Scapular CS in Marker Frame
ScapCoord = [S Orig];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the segment/joint Euler Angles based on the input
% rotation matrices for the segment/joints and the desired order.
% Note that angles are output in degrees.
% The rotation matrices are decomposed in the Euler angles around the global
% coordinate system
% alpha : first rotation elbow flexion extension
% beta  : second rotation 
% gamma : third rotation
%
% The possible order of rotations are:
% XYZ    (thor)
% XZY    (fore)
% YZX    (clav,scap)
% ZYX
% ZXY
% YZY    (hum)
% Based on rotbones.m, rotjoint.m and roteuler.m from the DESM.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function abg = CalcEulerAng(A,B,Rorder)
function ANGg = CalcEulerAng(R,Rorder,val)
% R: rotations from B to A LCS
%       B*R = A  -> R = B'*A
% A
% B
% R = B'*A;  % B to A

% Determine the Euler angles alpha, beta, gamma (abg).
switch Rorder
    case 'XYZ'
        [a,b,g] = rotxyz(R);  % For KACEY NEED XYZ NOW Rorder='XYZ'
    case 'XZY'
        [a,b,g] = rotxzy(R);
    case 'YZX'
        [a,b,g] = rotyzx(R);
    case 'ZYX'
        [a,b,g] = rotzyx(R);
    case 'ZXY'
        [a,b,g] = rotzxy(R);
    case 'YZY'
        [a,b,g] = rotyzy(R);
    case 'ZYZ'
        [a,b,g] = rotzyz(R);
end

ANGr = [a,b,g];
% ANGr = abg;
ANGg = ANGr*(180/pi);
ANGg = ANGg';

if val == 1
    disp('ANGg: ');
    disp(ANGg);
end

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Function to calculate the parameters of a plane in R3
% %              Ax + By + Cz + D = 0
% % using matrix notation [x y z 1]*[A B C D]' = 0
% % using the technique tlls
% % input: m x 3 matrix with points; output: A,B,C and D

% n vector: vector normal to the plane and describes desired plane
% KACEY 10.4.21 what is DATA? just desired BLS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,DATAa,nvector,e]=vlak(DATA)
% disp('just entered the vlak program');
[m,n]      = size(DATA);
[Ubef,Sbef,Vbef]    = svd(DATA);
Ubef*Sbef*Vbef';
DATA       = [DATA 1000000*ones(m,1)];
[U,S,V]    = svd(DATA);
S(n,n+1) = 0;
% S(n+1,n+1) = 0; %SABEEN CHANGED FIRST ONE FROM N+1 TO N, ASK AMA

DATAa = U*S*V';
A          = V(:,n+1)/V(n+1,n+1);
DATAa      = DATAa(:,1:3);
DATA       = DATA(:,1:3);
e          = sqrt(sum((DATA-DATAa)'.^2))';
A          = [A(1:3)/1000000;1];
nvector    = A(1:3)/norm(A(1:3));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the relative bone rotation matrices with respect
% to the previous segment.
%
% jR: 3x12 matrices
%     jR(:,1:3): rotations from global to thoracic LCS
%       G*Rti = Ti  -> Rti = G'*Ti = Ti
%
%     jR(:,4:6): rotations from thoracic to clavicular LCS
%       Ti*Rci = Ci  -> Rci = Ti'*Ci
%
%     jR(:,7:9): rotations from clavicular to scapular LCS
%       Ci*Rsi = Si  -> Rsi = Ci'*Si
%
%     jR(:,10:12): rotations from scapular to humeral LCS
%       Si*Rhi = Hi  -> Rhi = Si'*Hi
%
%     jR(:,13:15): rotations from humeral to forearm LCS
%       Hi*Rfi = Fi  -> Rfi = Hi'*Fi
%

% AS (#measurements x (3x12)) matrix: contains 4 local
    % coordinate systems (3x3 matrices) of thorax, clavicle, scapula and
    % humerus, respectively
    

function [jR]=rotjoint(AS)

% [n,m]=size(AS);nDATA = n/3;

%jR(1:n,1:3) = AS(:,1:3);
jR = zeros(3,6);

% for i=1:nDATA % don't need -- have this in the outer loop- and nData is time 
%     jR(3*i-2:3*i,4:6)=AS(3*i-2:3*i,1:3)'*AS(3*i-2:3*i,4:6);
%     jR(3*i-2:3*i,7:9)=AS(3*i-2:3*i,4:6)'*AS(3*i-2:3*i,7:9);
%     jR(3*i-2:3*i,10:12)=AS(3*i-2:3*i,7:9)'*AS(3*i-2:3*i,10:12);
%     jR(3*i-2:3*i,13:15)=AS(3*i-2:3*i,10:12)'*AS(3*i-2:3*i,13:15);
%     10:12 is hum 13:15 is forearm (OLD WAY)
  

% For KACEY Forearm (10:12) HUM (7:9) TO GET ELBOW ANGLE
   jR(1:3,1:3)=AS(:,7:9)'*AS(:,10:12);
    
   % To get humerus (columns 7:9) in trunk (columns 1:3) cs 
   jR(1:3,4:6)=AS(:,1:3)'*AS(:,7:9);  
% end
end


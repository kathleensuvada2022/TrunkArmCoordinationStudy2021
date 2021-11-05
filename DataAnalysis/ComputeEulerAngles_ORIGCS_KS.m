%function [gANGLES,jANGLES] = ComputeEulerAngles(bldata,arm,reffr)
%% NOV 2021- K.SUVADA
% This is with the original bone segment definitions



% Function to process bony landmark data to compute bone and joint rotations (adapted from Dutch program CalcInputKinem).
%
% Use :	[gANGLES,jANGLES]=ComputeEulerAngles(bldata,reffr)
%			bldata = bony landmark coordinates for 
%                    (1)trunk [4x5xnsamples] (SC,IJ,PX,C7,T8),
%                    (2)scapula [4x5xnsamples] (AC,AA,TS,AI,PC) and 
%                    (3)humerus[2x5xnsamples] (EM,EL)
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

% First reorganize the bony landmarks into a [3 x nland x nsamples] matrix with
% the bony landmarks in the following order (nland=12):
% 1  2  3  4  5  6  7  8  9  10 11 12
% EM EL SC IJ PX C7 T8 AC AA TS AI PC
% These are not included in the analysis because the forearm is not tracked
% RS US OL

% if nargin<3, reffr='trunk'; end
filename = 'trial10';
arm = 'Right';
partid = 'RTIS1005';
flag =1;
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

%               TRUNK SHOULDER HUMERUS FOREARM Marker in GLOBAL CS
TmarkertoGlob = {Tttom Tstom Thtom Tftom}; % HT(marker) in GCS during trial ******

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

    [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ'); % Trunk
    [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX');  % Clavicle
    [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX');  % Scapula
    [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY'); % Humerus
    
    [jANGLES(1:3,:,i)]=CalcEulerAng(jR(:,1:3),'XYZ'); % Trunk
    [jANGLES(4:6,:,i)]=CalcEulerAng(jR(:,4:6),'YZX');  % Clavicle
    [jANGLES(7:9,:,i)]=CalcEulerAng(jR(:,7:9),'YZX');  % Scapula
    [jANGLES(10:12,:,i)]=CalcEulerAng(jR(:,10:12),'YZY'); % Humerus
%     [jANGLES(13:15,:,i)]=CalcEulerAng(jR(:,13:15),2);    % Forearm



% Absolute Global Angles
     gR(1:3,1:3) = AS(:,1:3); %trunk rotation matrix in global
     gR(1:3,4:6) = AS(:,7:9); %humerus rotatin matrix in global
% Angles relative to global CS 
    [gANGLES(:,1,j)]=CalcEulerAng(gR(:,1:3),'XZY',0); % Trunk
    [gANGLES(:,2,j)]=CalcEulerAng(gR(:,4:6),'ZYZ',0); % Humerus

     jR = rotjoint(AS); %relative angles


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




%%% FUNCTIONS BELOW%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the center of rotation of the glenohumeral joint
% Copied from DSEL model, written by Meskers et al 1996
% REPLACE WITH HELICAL AXES METHOD (see Stokdijk, M et al)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gh=CalculateGH(blmat)

[ac,aa,ts,ai,pc]=deal(blmat(:,1),blmat(:,2),blmat(:,3),blmat(:,4),blmat(:,5));

Rsca=asscap(ac,ts,ai);
Osca=(ac);

pc=Rsca'*(pc-Osca);
ac=Rsca'*(ac-Osca);
aa=Rsca'*(aa-Osca);
ts=Rsca'*(ts-Osca);
ai=Rsca'*(ai-Osca);

lacaa=norm(ac-aa);
ltspc=norm(ts-pc);
laiaa=norm(ai-aa);
lacpc=norm(ac-pc);
  
scx=[1 pc(1) ai(1) laiaa pc(2)]';
scy=[1 lacpc pc(2) lacaa ai(1) ]';
scz=[1 pc(2) pc(3) ltspc ]';

thx=[18.9743    0.2434    0.2341    0.1590    0.0558];
thy=[-3.8791   -0.1002    0.1732   -0.3940    0.1205];
thz=[ 9.2629   -0.2403    1.0255    0.1720];


GHx = thx*scx;
GHy = thy*scy;
GHz = thz*scz;

gh=[GHx;GHy;GHz];

gh=(Rsca*gh)+Osca;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the thorax local coordinate system defined by:       %
% Origin   : IJ.                                                           %
% Y : from middle of T8-PX to middle of C7-IJ.                             %
% Z : perpendicular to X and normal to the plane containing (IJ,PX,C7,T8)  %
% X : perpendicular to Y and Z                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [TrunkCS,BLnames,BLs_lcs ] = asthorho(blmat,bonylmrks)

IJidx = find(bonylmrks=='IJ');
[IJ,PX,C7,T8]=deal(blmat(IJidx,:),blmat(IJidx+1,:),blmat(IJidx+2,:),blmat(IJidx+3,:)); % in Marker Local CS
BLnames = ["IJ","PX","C7","T8"];
BLs_lcs ={IJ,PX,C7,T8};


yt = (IJ+C7)/2 - (PX+T8)/2; yt = yt/norm(yt);
[A,DATAa,nvector,e]=vlak(blmat);
xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
zt = cross(xhulp,yt);zt=zt/norm(zt);
xt = cross(yt,zt);

%    xt,yt,zt,pause
t = [xt,yt,zt];
diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end

t = [xt;yt;zt]';

t = [t;0 0 0];
orign_trunk = [IJ(1:3) 1]';

%Trunk Coordinate System in Marker CS
TrunkCS = [t orign_trunk];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the parameters of a plane in R3
%              Ax + By + Cz + D = 0
% using matrix notation [x y z 1]*[A B C D]' = 0
% using the technique tlls
% input: m x 3 matrix with points; output: A,B,C and D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,DATAa,nvector,e]=vlak(DATA)

[m,n]      = size(DATA);
DATA       = [DATA 1000000*ones(m,1)];
[U,S,V]    = svd(DATA);
S(n+1,n+1) = 0;
DATAa      = U*S*V';
A          = V(:,n+1)/V(n+1,n+1);
DATAa      = DATAa(:,1:3);
DATA       = DATA(:,1:3);
e          = sqrt(sum((DATA-DATAa)'.^2))';
A          = [A(1:3)/1000000;1];
nvector    = A(1:3)/norm(A(1:3));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the clavicle local coordinate system.              %                                                                         %
% The output matrix contains the direction vectors.                        %
% Origin   : SC-joint.                                                     %
% Local X-axis : axis through the clavicle SC to AC.                       %
% Local Z-axis : axis perpendicular to the X-axis and the thoracic Y-axis. %
% Local Y-axis : axis perpendicular to the X-axis and Z-axis.              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c =  asclav(blmat,Yt)
[SC,AC]=deal(blmat(:,1),blmat(:,2));
oc = SC;
xc = (AC-SC)' / norm(AC-SC);
zc = cross(xc,Yt);
zc = zc / norm(zc);
yc = cross(zc,xc);
yc = yc / norm(yc);
c  = [xc yc zc];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the scapula local coordinate system.               %
% Input : aa,ts & ai                                                       %
% Output : S = [Xs,Ys,Zs]                                                  %
%                                                                          %
% Origin   : AA-joint.                                                     %
% Local X-axis : axis from TS to AA.                                       %
% Local Z-axis : axis perpendicular to the X-axis and the plane (AA,TS,AI).%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S =  asscap(blmat)
[AA,TS,AI]=deal(blmat(:,1),blmat(:,2),blmat(:,3));
xs = (AA-TS) / norm(AA-TS);
zhulp = cross(xs,(AA-AI));
zs = zhulp/norm(zhulp);
ys = cross(zs,xs);
s = [xs,ys,zs];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the humerus local coordinate system.
% Inputs: EM, EL
% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Y-axis : line between GH and mid-point between epicondyles.
% Local Z-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Hum_CS,BLs_lcs,BLnames] =  ashum(blmat,GH,bonylmrks)
%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
Emidx = find(bonylmrks=='EM');[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
BLnames = ["EM","EL","GH"];
BLs_lcs ={EM,EL,GH};
% 
% % Estimate GH joint location
% GH=CalculateGH(blmat(:,3:end));
% Compute the local axes
H_mid=(EM(1:3)+EL(1:3))/2;
y = (GH-H_mid) / norm(GH-H_mid);
xh= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3));
    
z =cross(xh,y);z=z/norm(z);
x =cross(y,z);
% h=[x,y,z];
h = [x;y;z]';

h = [h;0 0 0];

Origin = [GH(1:3) 1]';

%T of Humerus in marker CS
Hum_CS = [h Origin];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02-08-91 %%
% Function to estimate the axial rotation of the clavicle and compute
% the clavicle coordinate system
%       input : C (clavicle original coordinate system matrix)
%               S (scapula coordinate system matrix)
%       output: Cn (new clavicle coordinate system matrix)
%               rot (clavicle rotations about local axes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[Cn,ROTr,ROTg]=axclav(C,S)
% Ruststand van clavicula en scapula:
  Co = C(1:3,1:3); So = S(1:3,1:3);

% Relatie clavicula-scapula in ruststand:
  Mp = Co'*So;

% Bepalen van de rotaties van de clavicula rond de lokale assen t.o.v.
% thorax LCS:

[n,m]=size(C);nDATA = n/3;

r=[];
J=0;
for i=1:nDATA
  Rc=Co'*C(3*i-2:3*i,1:3);
  r = [r;Rc];
end  

% r = rot2a(C,0);

% Bepalen van de eulerrotaties (y,z,x):
  [ROTg]=roteuler(r,3);
  [ROTr]=ROTg*(pi/180);
  [rij,kolom]=size(ROTr);

  BETA = ROTr(:,1); GAMMA = ROTr(:,2); ALPHA = ROTr(:,3);

for I=1:rij
  beta=BETA(I);gamma=GAMMA(I);          % Benodigde hoeken
  RS  = S(I*3-2:I*3,1:3);                 % Scapula stand i
%____________________________________________________________________

% (Berekening van axiale rotatie volgens axrot (vd Helm))
 
    Ma = Co*roty(beta)*rotz(gamma);
    alpha=0;
    Sposd = Ma*rotx(alpha)*Mp;
    Spos=RS;
    Emat = Sposd'*Spos;
    E = acos(Emat(1,1)) + acos(Emat(2,2)) + acos(Emat(3,3));
    SSQ = E*E;
    SSQo = 0;
    while abs(SSQ-SSQo)>0.001,
      dalpha = max(0.1,alpha)*sqrt(eps);
      Sposdd = Ma*rotx(alpha + dalpha)*Mp;
      Ematd = Sposdd'*Spos;
      Ed = acos(Ematd(1,1)) + acos(Ematd(2,2)) + acos(Ematd(3,3));
      dEdalpha = (Ed - E)/dalpha;
      V = E/dEdalpha;
      d=2;
      alpha0=alpha;
      SSQo = SSQ;
      while (SSQo <= SSQ) & ((abs(SSQo - SSQ) > 0.001)|(d==2)),
	d = d/2;
	alpha1 = alpha0 - d*V;
	Sposd = Ma*rotx(alpha1)*Mp;
	Emat = Sposd'*Spos;
	E = acos(Emat(1,1)) + acos(Emat(2,2)) + acos(Emat(3,3));
	SSQ=E*E;
      end
      alpha=alpha1;

    end
%[I,alpha]
%pause
%____________________________________________________________________

    ALPHA(I) = alpha; 
    J = J+3;
  end

  ROTr(1:rij,3)=ALPHA;
  ROTg(1:rij,3)=ALPHA*180/pi;

% Berekenen van de nieuwe positiematrix van de clavicula :
% (volgens Ci = Co * R waarbij R = (roty*rotz*rotx)

J = 0;

for I=1:rij
  Ry = roty(BETA(I));
  Rz = rotz(GAMMA(I));
  Rx = rotx(ALPHA(I));
  Cn(I*3-2:I*3,1:3) = Co*Ry*Rz*Rx;

end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the segment/joint Euler Angles based on the input 
% rotation matrices for the segment/joints and the desired order.
% Note that angles are output in radians.
% The rotation matrices are decomposed in the Euler angles around the global
% coordinate system
% alpha : first rotation
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
function abg = CalcEulerAng(A,B,Rorder)

% R: rotations from B to A LCS
%       B*R = A  -> R = B'*A
R = B'*A;  % B to A

% Determine the Euler angles alpha, beta, gamma (abg).
switch Rorder
    case 'XYZ'
        abg = rotxyz(R);
    case 'XZY'
        abg = rotxzy(R);
    case 'YZX'
        abg = rotyzx(R);
    case 'ZYX'
        abg = rotzyx(R);
    case 'ZXY'
        abg = rotzxy(R);
    case 'YZY'
        abg = rotyzy(R);
end

ANGr = [ALPHA,BETA,GAMMA];
ANGg = ANGr*(180/pi);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the absolute bone rotation matrices with respect
% to the trunk.
% 
% gR: 3x12 matrices
%     gR(:,1:3): rotations from global to thoracic LCS
%       G*Rti = Ti  -> Rti = G'*Ti
% 
%     gR(:,4:6): rotations from thorax to clavicular LCS
%       Ti*Rci = Ci  -> Rci = Ti'*Ci 
%
%     gR(:,7:9): rotations from thorax to scapular LCS
%       Ti*Rsi = Si  -> Rsi = Ti'*Si 
%
%     gR(:,10:12): rotations from thorax to humeral LCS
%       Ti*Rhi = Hi  -> Rhi = Ti'*Hi  
%
%     gR(:,13:15): rotations from thorax to forearm LCS
%       Ti*Rfi = Fi  -> Rfi = Ti'*Fi  
%
% N.B. Rci, Rsi and Rhi are defined as rotations about the LOCAL
%      axes of the thoracic coordinate system
% November 1996, Frans van der Helm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   function [gR]=rotbones(AS)
%   function [gR]=rotbones(AS)
%

[n,m]=size(AS);nDATA = n/3;

T0 = AS(1:3,1:3); % initial thorax orientation
for i=1:nDATA
  gR(3*i-2:3*i,1:3)=AS(3*i-2:3*i,1:3);
  Ti = gR(3*i-2:3*i,1:3); %**
  gR(3*i-2:3*i,1:3)=T0'*AS(3*i-2:3*i,1:3);  % Global to Trunk
  Ti = T0*gR(3*i-2:3*i,1:3); %** These lines give the same result
  gR(3*i-2:3*i,4:6)=Ti'*AS(3*i-2:3*i,4:6);  % Trunk to Clavicle
  gR(3*i-2:3*i,7:9)=Ti'*AS(3*i-2:3*i,7:9);  % Trunk to Scapula
  gR(3*i-2:3*i,10:12)=Ti'*AS(3*i-2:3*i,10:12);  % Trunk to Humerus
  gR(3*i-2:3*i,13:15)=Ti'*AS(3*i-2:3*i,13:15);  % Trunk to Forearm
end
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
%  N.B. Rotations are defined with respect to the LOCAL axis of the
%  proximal coordinate system (or G in case of thorax rotations)
%
%  November 1996, Frans van der Helm
    
function [jR]=rotjoint(AS)


[n,m]=size(AS);nDATA = n/3;

jR(1:n,1:3) = AS(:,1:3);

for i=1:nDATA
  jR(3*i-2:3*i,4:6)=AS(3*i-2:3*i,1:3)'*AS(3*i-2:3*i,4:6);
  jR(3*i-2:3*i,7:9)=AS(3*i-2:3*i,4:6)'*AS(3*i-2:3*i,7:9);
  jR(3*i-2:3*i,10:12)=AS(3*i-2:3*i,7:9)'*AS(3*i-2:3*i,10:12);
  jR(3*i-2:3*i,13:15)=AS(3*i-2:3*i,10:12)'*AS(3*i-2:3*i,13:15);
end
    end



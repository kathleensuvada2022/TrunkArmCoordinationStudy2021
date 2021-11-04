%function [gANGLES,jANGLES] = ComputeEulerAngles(bldata,arm,reffr)
%
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

if nargin<3, reffr='trunk'; end

% The order in which the BL must be in the DATA matrix is:
BL={'EM', 'EL', 'SC', 'IJ', 'PX', 'C7', 'T8', 'AC', 'AA', 'TS', 'AI', 'PC'}; %, 'RS', 'US', 'OL'};

blmat=cat(2,bldata{1},bldata{2},bldata{3});
nland=size(blmat,2);
nsamples=size(blmat,3);

% npos=size(DATA,1);
% DATA=reshape(DATA',3,npos*nland)';

for i=1:nsamples
    % ****************************************************************************
    % 1) Transform data to the DSEL global coordinate system with IJ as the origin
    %    (X: left-right, Y: upwards, Z: backwards)
    %    Note that the data is in the transmitter coordinate system
    %    (X: forward, Y: left-right, Z: downwards)
    R=roty(pi)*rotz(pi/2);
    T=[[R;zeros(1,3)] -R*squeeze(blmat(:,4,i))];
    blmat2=T*blmat(:,:,i);
    
    % **************************************************************
    % 2) Calculate the local coordinate system for each bone
    %    Replaces [AS] = asfunc(X,datast(1).arm);
    % 	 BL = | IJ  SC  AC  EM  RS |
    %         | PX  AC  AA  EL  US |
    %         | C7  0   TS  GH  OL |
    %         | T8  0   AI  0   0  |
    % 1  2  3  4  5  6  7  8  9  10 11 12
    % EM EL SC IJ PX C7 T8 AC AA TS AI PC
    
    TrunkCS=asthorho(blmat2(:,4:7));
    
    if strcmp(arm,'left'), TrunkCS=roty(pi)*TrunkCS; end
    ClavCS=asclav(blmat(:,[3 8]),TrunkCS(:,2));  % SC,AC,Yt Yt: thorax local Y-axis
    ScapCS=asscap(blmat(:,9:11)); % AA,TS,AI
    [HumCS,GH]=ashum(blmat(:,[1:2 8:12])); % EM,EL,AC,AA,TS,AI,PC
    %     forearm=asfore(X(im1+1,13:15)',X(im1+2,13:15)',X(im1+3,13:15)'); % Using OL
    %     forearm=asfore2(X(im1+1,13:15)',X(im1+2,13:15)',X(im1+1,10:12)',X(im1+2,10:12)'); % Using mid Epi
    
    
    %     as=[t,c,s,h,f];
    %    if strcmp(arm,'left'), as(:,4:end)=roty(pi)*as(:,4:end); end
    % AS (#measurements x (3x12)) matrix: contains 4 local
    % coordinate systems (3x3 matrices) of thorax, clavicle, scapula and
    % humerus, respectively
    %     AS=[AS;as];
    
    % EXCLUDING GH TRANSLATION
    % Fix the 3D coordinates of the center of the head of the
    % humerus (GH) to those measured in the first position
    % X(3:4:28,10:12)=X(3*ones(7,1),10:12);
    % X(31:4:56,10:12)=X(31*ones(7,1),10:12);
    % X(59:4:120,10:12)=X(59*ones(16,1),10:12);
    % Indices for WRS
    % X(3:4:17*4,10:12)=X(3*ones(17,1),10:12);
    % X(17*4+3:4:39*4,10:12)=X((17*4+3)*ones(22,1),10:12);
    % X(39*4+3:4:54*4,10:12)=X((39*4+3)*ones(15,1),10:12);
    
    
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % AMA 11-25 Still have to update axclav. For now keep original
    % clavicle CS.
    % **************************************************************
    % 3) estimation of axial rotation of the clavicle
    %    Clavicle LCS corrected with estimated axial
    %    rotation
    % [Cn,ROTr,ROTg]=axclav(ClavCS,ScapCS);
    % ClavCS = Cn;
    
    % **************************************************************
    % 4) Calculate each segment/joint's Euler Angles. This involves a two step
    %    process:
    %    A) Calculation of rotation matrices either w.r.t. the thorax
    %       coordinate system (bone rotations) or the local coordinate system
    %       of the proximal bone (joint rotations).
    %       Joint rotations w.r.t. proximal bone (or G:global CS):
    %               G*Rti = Ti  -> Rti = G'*Ti
    %               Ti*Rci = Ci  -> Rci = Ti'*Ci
    %               Ti*Rsi = Si  -> Rsi = Ti'*Si
    %               Ti*Rhi = Hi  -> Rhi = Ti'*Hi
    %
    %       Joint rotations w.r.t. proximal bone (or G):
    %               G*Rti = Ti  -> Rti = G'*Ti
    %              Ti*Rci = Ci  -> Rci = Ti'*Ci
    %              Ci*Rsi = Si  -> Rsi = Ci'*Si
    %              Si*Rhi = Hi  -> Rhi = Si'*Hi
    %       Adapted from rotbones.m and rotjoint.m in DESM
    %
    %    B) Parameterization of rotation matrices into Euler angles (in rads)
    %       gANGLES ([nsegments/njoints x 3 x nsamples]): gR parameterized in
    %       Euler angles, order xyz (thorax), yzx (clavicle), yzx (scapula)
    %       and yzy (humerus)
    %
    %       jANGLES ([nsegments/njoints x 3 x nsamples]): jR parameterized in
    %       Euler angles, order xyz (thoracic movements), yzx (SC joint),
    %       yzx (AC joint) and yzy (GH joint)
    
    if strcmp(reffr,'frame')
        %Use the frame as reference
        AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
        if strcmp(datast(1).arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
    end
    
    switch reffr
        case 'T'
            
        case 'R'
    end
    
    [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ'); % Trunk
    [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX');  % Clavicle
    [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX');  % Scapula
    [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY'); % Humerus
    
    [jANGLES(1:3,:,i)]=CalcEulerAng(jR(:,1:3),'XYZ'); % Trunk
    [jANGLES(4:6,:,i)]=CalcEulerAng(jR(:,4:6),'YZX');  % Clavicle
    [jANGLES(7:9,:,i)]=CalcEulerAng(jR(:,7:9),'YZX');  % Scapula
    [jANGLES(10:12,:,i)]=CalcEulerAng(jR(:,10:12),'YZY'); % Humerus
%     [jANGLES(13:15,:,i)]=CalcEulerAng(jR(:,13:15),2);    % Forearm
    
    if strcmp(datast(1).arm,'left'),
        % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
        gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
        jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
    end
    
    % **************************************************************
    if strcmp(reffr,'trunk')
        eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
    elseif strcmp(reffr,'frame')
        eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
    end
    
end

%end

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
function t = asthorho(blmat)

[IJ,PX,C7,T8]=deal(bl(:,1),bl(:,2),bl(:,3),bl(:,4));
yt = (IJ+C7)/2 - (PX+T8)/2; yt = yt/norm(yt);
[A,DATAa,nvector,e]=vlak(blmat);
xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
zt = cross(xhulp,yt);zt=zt/norm(zt);
xt = cross(yt,zt);

%    xt,yt,zt,pause
t = [xt,yt,zt];
diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end
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
function [h,GH] =  ashum(blmat)
[EM,EL]=deal(blmat(:,1),blmat(:,2));

% Estimate GH joint location
GH=CalculateGH(blmat(:,3:end));
% Compute the local axes
H_mid=(EM+EL)/2;
y = (GH-H_mid) / norm(GH-H_mid);
xh= (EL-EM)/norm(EL-EM);
    
z =cross(xh,y);z=z/norm(z);
x =cross(y,z);
h=[x,y,z];
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



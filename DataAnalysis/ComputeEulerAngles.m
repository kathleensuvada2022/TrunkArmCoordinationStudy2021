function [gANGLES,jANGLES,Pmcp_H,Pmcp_T,Pmcp_G, T] = ComputeEulerAngles(bldata,filename,arm,reffr,partid)
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

if nargin<3, reffr='trunk'; end
%%
% The order in which the BL must be in the DATA matrix is:

datafilepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data','/',partid,'/',arm];
load([datafilepath '/' partid,'_','setup']);

%From Kacey's MetriaKinDAQ 10.2021
% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm'};
bonylmrks = ["SC" "IJ" "PX" "C7" "T8" "AC" "AA" "TS" "AI" "PC" "EM" "EL" "GH" "RS" "US" "OL" "MCP"]';
%% Concatenate the bony landmarks into one cell array and Trial Data [HT_Marker in GCS]
load([datafilepath '/BL.mat']) %loading in BL file 
load([datafilepath,'/', filename]) %loading in trial data 
bldata=bl;
blmat=cat(1,bldata{1},bldata{2},bldata{3},bldata{4}); %coordinates in the frame of the marker
blmat=cat(2,bonylmrks,blmat);
nland=size(blmat,1);
%%
x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

t = (x(:,2)-x(1,2))/89; 
%%
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

Tbtom = {Tttom Tstom Thtom Tftom}; % HT(marker) in GCS during trial ******
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
blmat3 = blmat;

% R=(rotx(pi/2)*roty(pi/2)*rotz(pi/2)); %fix so that the rotations already take the (-) sign into account
%use Amee's guide to determine rotation
    % 1) Transform data to the global coordinate system with IJ as the origin
    %    (X: left-right, Y: upwards, Z: backwards)
    %    Note that the data is in the transmitter coordinate system
    %    (X: forward, Y: left-right, Z: downwards)
    %     disp('entered the for loop');
% R = rotx(pi/2);
R = [0 0 -1;1 0 0;0 -1 0];
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
            
 %%   
%Trunk CS
%TrunkCS=asthorho(blmat2(:,5:8));
TrunkCS=asthorho(blmat);
 
if strcmp(arm,'left'), TrunkCS=roty(pi)*TrunkCS; end
    %     ClavCS=asclav(blmat(:,[3 8]),TrunkCS(:,2));  % SC,AC,Yt Yt: thorax local Y-axis
%     ClavCS=asclav(blmat2(1:3,[4 9]),TrunkCS(:,2)); %[SC,AC]  % SC,AC,Yt Yt: thorax local Y-axis
   
%Scapula CS
%ScapCS=asscap(blmat2(1:3,10:12)); % AA,TS,AI
ScapCS=asscap(blmat); % AA,TS,AI
    %     ScapCS=asscap(blmat(:,9:11)); % AA,TS,AI
    %     blmat(1:3,[1:2 8:12],:)
    %Transform points from global to scapula frame before calculating
  
%Forearm CS
[ForeCS] =  asfore(blmat); 
    
% Compute location of GH joint using Regression Function   
    GH=ghest(bl,Rscap); %need to do this!!! 
    
% Using GH from Digitization %%%%%%%%%
GHIDX = find(bonylmrks=='GH');
GH = blmat(GHIDX ,2:4); %XYZ coordinate of GH from Digitization in meantime
    
%Humerus CS
    %[HumCS,GH]=ashum(blmat2(1:3,[1:2]),GH);
%     [HumCS,GH]=ashum(blmat2(1:3,[1:2 8:12]),GH);
    [HumCS,GH]=ashum(blmat,GH);
%     [HumCS,GH]=ashum(blmat2(1:3,[1:2 8:12]),GH);
   

   % AS = [TrunkCS,ClavCS,ScapCS,HumCS]; % Coordinate system for each bone at ith time
  
   % Coordinate system for each bone in LCS (marker)
   B_CS = {TrunkCS,ScapCS,HumCS,ForeCS};
   
%% Looping through all frames in trial for each HT (marker in global)   
for j = 1:length(xtrunk) %artibitrary choosing xtrunk just needs to go through frames 

    Tbtom = {Tttom Tstom Thtom Tftom};
    
%Trunk
%Trunk_Global CS
TtoG(:,:,j)=Tbtom{1}(:,:,j).*B_CS{1};

%TESTING TRUNK
%%%%%%%%%%%%
% TtoG(:,:,j) = Tttom(:,:,j).*TrunkCS;
%%%%%%%%%%%%

%Shoulder
StoG(:,:,j) = Tbtom{2}(:,:,j)*AS{2};

%Humerus
HtoG(:,:,j) = Tbtom{3}(:,:,j)*AS{3};

%Forearm
FtoG(:,:,j) = Tbtom{4}(:,:,j)*AS{4};

  
end
% ***THE CSs created above are BONE CS in Global CS every point in time ***********
%%      
        
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
        %Use the frame as reference- makes rotation matrix for trunk all
        %ones, so it doesn't take into account rotations of trunk
        AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
        if strcmp(arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
    end
    
    gR = rotbones(AS); %absolute angles
    jR = rotjoint(AS); %relative angles
    
    %     blah = CalcEulerAng(TrunkCS,'XYZ')
    [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ',0); % Trunk
    [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX',0);  % Clavicle
    [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX',0);  % Scapula
    [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY',0); % Humerus
   
    [jANGLES(1:3,:,i)]=CalcEulerAng(jR(:,1:3),'XYZ',0); % Trunk
    [jANGLES(4:6,:,i)]=CalcEulerAng(jR(:,4:6),'YZX',0);  % Clavicle
    [jANGLES(7:9,:,i)]=CalcEulerAng(jR(:,7:9),'YZX',0);  % Scapula
    [jANGLES(10:12,:,i)]=CalcEulerAng(jR(:,10:12),'YZY',0); % Humerus
    %     [jANGLES(13:15,:,i)]=CalcEulerAng(jR(:,13:15),2);    % Forearm
    
    
    % **************************************************************
    if strcmp(reffr,'trunk')
        eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
    elseif strcmp(reffr,'frame')
        eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
    end


%Moved this outside the for loop because the direction was changing after
%every sample
if strcmp(arm,'left'),
    %     if strcmp(datast(1).arm,'left'),
    % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
    %         gANGLES = gANGLES';
    %         gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
    gANGLES([1,3,4,6,7,9,10,12],:)=-gANGLES([1,3,4,6,7,9,10,12],:);
    %         jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the center of rotation of the glenohumeral joint
% Copied from DSEL model, written by Meskers et al 1996
% REPLACED WITH HELICAL AXES METHOD (see Stokdijk, M et al) - ALJ 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [gh] = CalculateGH(blmat1,blmat2)
% % n = size(blmat1,2);
% % Q = zeros(3);
% 
% posEMEL1= blmat1(:,1:2,:);
% posEMEL2= blmat2(:,1:2,:);
% 
% [h,pos] = helicalaxis3v3(posEMEL1,posEMEL2);
% 
% gh = pos;
% % helax = h;
% % position = pos;
% 
% % p = pos;
% % ha = h;
% % calcQ = eye(3) - helax*helax';
% % Q = Q + calcQ;
% % % end
% %
% % QplusS = zeros(3,1);
% % possum = (eye(3) - ha*ha')*p;
% % QplusS = possum + QplusS;
% % gh2 = (inv(Q)/n)*QplusS
% 
% end

%OLD FUNCTION USING REGRESSION MODEL
% function gh=CalculateGH(blmat)
%
% [ac,aa,ts,ai,pc]=deal(blmat(:,1),blmat(:,2),blmat(:,3),blmat(:,4),blmat(:,5));
% Rsca=asscap(ac,ts,ai);
% Osca=(ac);
%
% pc=Rsca'*(pc-Osca);
% ac=Rsca'*(ac-Osca);
% aa=Rsca'*(aa-Osca);
% ts=Rsca'*(ts-Osca);
% ai=Rsca'*(ai-Osca);
%
% lacaa=norm(ac-aa);
% ltspc=norm(ts-pc);
% laiaa=norm(ai-aa);
% lacpc=norm(ac-pc);
%
% scx=[1 pc(1) ai(1) laiaa pc(2)]';
% scy=[1 lacpc pc(2) lacaa ai(1) ]';
% scz=[1 pc(2) pc(3) ltspc ]';
%
% thx=[18.9743    0.2434    0.2341    0.1590    0.0558];
% thy=[-3.8791   -0.1002    0.1732   -0.3940    0.1205];
% thz=[ 9.2629   -0.2403    1.0255    0.1720];
%
%
% GHx = thx*scx;
% GHy = thy*scy;
% GHz = thz*scz;
%
% gh=[GHx;GHy;GHz];
%
% gh=(Rsca*gh)+Osca;
% end

% ****
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Function to compute the thorax local coordinate system defined by:       %
% % Origin   : IJ.                                                           %
% % Y : from middle of T8-PX to middle of C7-IJ.                             %
% % Z : perpendicular to X and normal to the plane containing (IJ,PX,C7,T8)  %
% % X : perpendicular to Y and Z


% Kacey's Definitions 10.4.21
%Z : from middle of T8-PX to middle of C7-IJ.  
%Y : perpendicular to Z and normal to the plane containing (IJ,PX,C7,T8). Pointing right  %
%X : Z cross Y
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function t = asthorho(blmat)

%[IJ,PX,C7,T8]=deal(blmat(1:3,1),blmat(1:3,2),blmat(1:3,3),blmat(1:3,4));

%Kacey 10.2021
[IJ,PX,C7,T8]=deal(blmat(5,:),blmat(6,:),blmat(7,:),blmat(8,:));
% yt = (IJ+C7)/2 - (PX+T8)/2;
% yt = yt/norm(yt);

%Edited Kacey 10.5.21
zt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
zt = zt/norm(zt);


blmat_th =[blmat(5,1:3);blmat(6,1:3);blmat(7,1:3);blmat(8,1:3)];


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
t = [xt,yt(1:3),zt]; %SABEEN CHANGE: NEED DIM OF 3 FOR THEM ALL TO MATCH
diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end
% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);

t = [xt;yt;zt]';
t = [t;0 0 0];
orign_trunk = [IJ(1:3) 1]';

%Trunk Coordinate System in Marker CS
t = [t orign_trunk];

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
% Function to calculate the clavicle local coordinate system.              %                                                                         %
% The output matrix contains the direction vectors.                        %
% Origin   : SC-joint.                                                     %
% Local X-axis : axis through the clavicle SC to AC.                       %
% Local Z-axis : axis perpendicular to the X-axis and the thoracic Y-axis. %
% Local Y-axis : axis perpendicular to the X-axis and Z-axis. 

%KACEY 10.4.21 DON'T INCLUDE CLAVICLE. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function c =  asclav(blmat,Yt)
% [SC,AC]=deal(blmat(:,1),blmat(:,2));
% oc = SC;
% xc = (AC-SC)' / norm(AC-SC);
% 
% zc = cross(xc,Yt);
% zc = zc / norm(zc);
% yc = cross(zc,xc);
% yc = yc / norm(yc);
% % c  = [xc yc zc];
% c  = [xc;yc;zc];
% end

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
function S =  asscap(blmat)
% [AA,TS,AI]=deal(blmat(:,1),blmat(:,2),blmat(:,3));
%Edited to replace AA with AC Kacey 10.4.21

%Kacey 10.2021
[AC,TS,AI]=deal(blmat(9,:),blmat(11,:),blmat(12,:));

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

S = [xs;ys;zs]';
S = [S; 0 0 0];

Orig = [AC(1:3) 1]';

%Scapular CS in Marker Frame
S = [S Orig];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the humerus local coordinate system.
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
function [h,GH] =  ashum(blmat1,GH)

%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
[EM,EL]=deal(blmat1(1,:),blmat1(2,:));
% Estimate GH joint location

% Compute the local axes

% y = (GH-H_mid) / norm(GH-H_mid);
% xh= (EL-EM)/norm(EL-EM);
% z =cross(xh,y);
% z=z/norm(z);
% x =cross(y,z);
% h=[x,y,z];

% yh = (GH-H_mid) / norm(GH-H_mid);
% zh =  cross(EL-EM,yh); zh = zh/norm(zh);
% xh = cross(yh,zh);
% h = [xh,yh,zh];

% Kacey Redefining X,Y,Z axes 10.4.21
H_mid=(EM(1:3)+EL(1:3))/2;
zh = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);
zh = -zh; % flipping so vector points cranially ?? maybe don't need 

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
h = [h Origin];

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
function [f] =  asfore(blmat)

%Kacey 10.2021
[RS,US,OL]=deal(blmat1(14,:),blmat1(15,:),blmat1(16,:));

% Kacey Redefining X,Y,Z axes 10.6.21
H_mid=(RS(1:3)+US(1:3))/2;
zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);
zf = -zh; % flipping so vector points cranially 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); %Vector through EL and EM
yf =cross(zf,x); %flipped order because z in opposite direction
yf=yf/norm(yf);


xf = cross (yf,zf);
xf = xf/norm(xf);

f = [xf;yf;zf]';
f = [f;0 0 0];
org_fore = [OL(1:3) 1]';


%Forearm Coordinate System in Marker CF
f = [f org_fore];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to estimate the center of rotation of the GH joint
% based on a regression equation of the scapular bony landmarks
% (AC, AA, TS, AI)
% ADD REFERENCE AND CHECK THE REGRESSION MODEL TO MATCH THE CSs
%       input : bl=[ac aa ts ai] (3D coordinates of scapular bony landmarks in
%                              the scapular CS)
%               Rsca (scapula rotation matrix)
%       output: gh (3D coordinates of the center of rotation of the GH
%                   joint in scapular CS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gh=ghest(bl,Rscap)
% Rsca=asscap(ac,ts,ai); % No longer necessary, Rscap is an input
Rsca=Rsca*diag([-1 -1 1]); % Flips the x and y axes == 180 degree rotation about z FIGURE OUT IF THIS IS NEEDED
 
Osca=(bl(:,1)+bl(:,2))/2; % Osca=(ac+aa)/2; compute midpoint between AC and AA

% ac=Rsca'*(ac-Osca); No necessary because BLs are already in scapular CS
% aa=Rsca'*(aa-Osca);
% ts=Rsca'*(ts-Osca);
% ai=Rsca'*(ai-Osca);

% Change origin to midpoint between AC and AA
bl=bl-repmat(Osca,1,4); % for 4 Bls

lacaa=norm(bl(:,1)-bl(:,2)); %lacaa=norm(ac-aa);
lacts=norm(bl(:,1)-bl(:,3)); %lacts=norm(ac-ts);
lacai=norm(bl(:,1)-bl(:,4)); %lacai=norm(ac-ai);
ltsai=norm(bl(:,3)-bl(:,4)); %ltsai=norm(ts-ai);

% TWO DIFFERENT REGRESSION EQUATIONS (2 AND 3 ARE THE SAME EXCEPT FOR THE NUMBER OF DECIMALS) WHICH ONE IS BEST????
% ghrel=[ ...
%   [  lacaa lacts       ltsai]*[     0.45 -0.28        0.18]';
%   [1       lacts lacai      ]*[-70        0.73 -0.28      ]';
%   [        lacts lacai ltsai]*[          -0.51  0.42 -0.38]'];

%   ghrel=[ ...
%     [1       lacts lacai      ]*[  9.8       -0.399  0.223      ]';
%     [1       lacts lacai      ]*[-69.6        0.731 -0.277      ]';
%     [1       lacts lacai      ]*[ -2.7       -0.297  0.065      ]'];

% AMA changed ghrel to gh since the last rotation is not needed.
  gh=[ ...
    [1       lacts lacai      ]*[ 10       -0.40  0.22      ]'; % Xcoord
    [1       lacts lacai      ]*[-70        0.73 -0.28      ]';  % Y coord
    [1       lacts lacai      ]*[ -3       -0.30  0.06      ]']; 


% 1X3 * (1X3)' --> 1X3* 3X1 = 1X1 ( x coord) 


%gh=Rsca*ghrel+Osca; Not needed because GH is in scapular CS
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 02-08-91 %%
% Function to estimate the axial rotation of the clavicle and compute
% the clavicle coordinate system
%       input : C (clavicle original coordinate system matrix)
%               S (scapula coordinate system matrix)
%       output: Cn (new clavicle coordinate system matrix)
%               rot (clavicle rotations about local axes)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kacey Ignoring Clavicular CS 10.4.21

% function[Cn,ROTr,ROTg]=axclav(C,S)
% % Ruststand van clavicula en scapula:
% Co = C(1:3,1:3); So = S(1:3,1:3);
% 
% % Relatie clavicula-scapula in ruststand:
% Mp = Co'*So;
% 
% % Bepalen van de rotaties van de clavicula rond de lokale assen t.o.v.
% % thorax LCS:
% 
% [n,m]=size(C);nDATA = n/3;
% 
% r=[];
% J=0;
% for i=1:nDATA
%     Rc=Co'*C(3*i-2:3*i,1:3);
%     r = [r;Rc];
% end
% 
% % r = rot2a(C,0);
% 
% % Bepalen van de eulerrotaties (y,z,x):
% [ROTg]=roteuler(r,3);
% [ROTr]=ROTg*(pi/180);
% [rij,kolom]=size(ROTr);
% 
% BETA = ROTr(:,1); GAMMA = ROTr(:,2); ALPHA = ROTr(:,3);
% 
% for I=1:rij
%     beta=BETA(I);gamma=GAMMA(I);          % Benodigde hoeken
%     RS  = S(I*3-2:I*3,1:3);                 % Scapula stand i
%     %____________________________________________________________________
%     
%     % (Berekening van axiale rotatie volgens axrot (vd Helm))
%     
%     Ma = Co*roty(beta)*rotz(gamma);
%     alpha=0;
%     Sposd = Ma*rotx(alpha)*Mp;
%     Spos=RS;
%     Emat = Sposd'*Spos;
%     E = acos(Emat(1,1)) + acos(Emat(2,2)) + acos(Emat(3,3));
%     SSQ = E*E;
%     SSQo = 0;
%     while abs(SSQ-SSQo)>0.001,
%         dalpha = max(0.1,alpha)*sqrt(eps);
%         Sposdd = Ma*rotx(alpha + dalpha)*Mp;
%         Ematd = Sposdd'*Spos;
%         Ed = acos(Ematd(1,1)) + acos(Ematd(2,2)) + acos(Ematd(3,3));
%         dEdalpha = (Ed - E)/dalpha;
%         V = E/dEdalpha;
%         d=2;
%         alpha0=alpha;
%         SSQo = SSQ;
%         while (SSQo <= SSQ) & ((abs(SSQo - SSQ) > 0.001)|(d==2)),
%             d = d/2;
%             alpha1 = alpha0 - d*V;
%             Sposd = Ma*rotx(alpha1)*Mp;
%             Emat = Sposd'*Spos;
%             E = acos(Emat(1,1)) + acos(Emat(2,2)) + acos(Emat(3,3));
%             SSQ=E*E;
%         end
%         alpha=alpha1;
%         
%     end
%     %[I,alpha]
%     %pause
%     %____________________________________________________________________
%     
%     ALPHA(I) = alpha;
%     J = J+3;
% end
% 
% ROTr(1:rij,3)=ALPHA;
% ROTg(1:rij,3)=ALPHA*180/pi;
% 
% % Berekenen van de nieuwe positiematrix van de clavicula :
% % (volgens Ci = Co * R waarbij R = (roty*rotz*rotx)
% 
% J = 0;
% 
% for I=1:rij
%     Ry = roty(BETA(I));
%     Rz = rotz(GAMMA(I));
%     Rx = rotx(ALPHA(I));
%     Cn(I*3-2:I*3,1:3) = Co*Ry*Rz*Rx;
%     
% end
% end

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
        [a,b,g] = rotxyz(R);
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
    %   gR(3*i-2:3*i,13:15)=Ti'*AS(3*i-2:3*i,13:15);  % Trunk to Forearm
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
    %   jR(3*i-2:3*i,13:15)=AS(3*i-2:3*i,10:12)'*AS(3*i-2:3*i,13:15);
end
end


function y = meanfilt(x,n)

%MEANFILT  One dimensional mean filter.
%   Y = MEANFILT(X,N) returns the output of the order N, one dimensional
%   moving average 2-sided filtering of vector X.  Y is the same length
%   as X;
%
%   If you do not specify N, MEANFILT uses a default of N = 3.

%   Author(s): Ana Maria Acosta, 2-26-01

if nargin < 2
    n=3;
end
if all(size(x) > 1)
    y = zeros(size(x));
    for i = 1:size(x,2)
        y(:,i) = meanfilt(x(:,i),n);
    end
    return
end

% Two-sided filtering to avoid phase shifts in the output
y=filter22(ones(n,1)/n,x,2);

% transpose if necessary
if size(x,1) == 1  % if x is a row vector ...
    y = y.';
end
end

function y = filter22(fil,x,numsides)
%
%	THIS FUNCTION PERFORMS 2-SIDED AS WELL AS ONE SIDED
% 	FILTERING.  NOTE THAT FOR A ONE-SIDED FILTER, THE
%	FIRST length(fil) POINTS ARE GARBAGE, AND FOR A TWO
%	SIDED FILTER, THE FIRST AND LAST length(fil)/2
%	POINTS ARE USELESS.
%
%	USAGE	: y = filter22(fil,x,numsides)
%
% EJP Jan 1991
%
[ri,ci]= size(x);
if (ci > 1)
    x = x';
end
numpts = length(x);
halflen = ceil(length(fil)/2);
if numsides == 2
    xxx=zeros(size(1:halflen))';
    x = [x ; xxx];
    y = filter(fil,1,x);
    y = y(halflen:numpts + halflen - 1);
else
    y=filter(fil,1,x);
end
if (ci > 1)
    y = y';
end
return
end
% Original Definitions of Segment CS
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
function [TrunkCS,BLnames,BLs_lcs ] = asthorho(blmat,bonylmrks)

IJidx = find(bonylmrks=='IJ');

[IJ,PX,C7,T8]=deal(blmat(IJidx,:),blmat(IJidx+1,:),blmat(IJidx+2,:),blmat(IJidx+3,:)); % in Marker Local CS
BLnames = ["IJ","PX","C7","T8"];
BLs_lcs ={IJ,PX,C7,T8};
%% Original way of setting CS  
yt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
yt = yt/norm(yt);


blmat_th =[IJ(1:3);PX(1:3);C7(1:3);T8(1:3)];

[A,DATAa,nvector,e]=vlak(blmat_th); 

%xhulp is vector normal to the plane
xhulp = nvector; 

zt = cross(xhulp,yt(1:3));
zt=zt/norm(zt);

%xt = cross(yt(1:3),zt);

%Redefined for Kacey 10.4.21
xt = cross(yt,zt);

% t = [xt,yt,zt];
t = [xt,yt,zt]; 


% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);

t = [xt;yt;zt]';

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
%%
%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
Emidx = find(bonylmrks=='EM');

[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
BLnames = ["EM","EL","GH"];
BLs_lcs ={EM,EL,GH};

%% Old way of defining CS
% X towards lateral epcondyle
% Y is down towards EM and EL from GH
% Z is into the page 

H_mid=(EM(1:3)+EL(1:3))/2;

y = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);

y = -y;

xh= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3));
z =cross(xh,y);
z=z/norm(z);

x =cross(y,z);

h=[x;y;-z]';

h = [h;0 0 0];
Origin = [GH(1:3) 1]';

Hum_CS = [h Origin];
end
function [ForeCS,BLs_lcs,BLnames] =  asfore(blmat,bonylmrks)

%Kacey 10.2021
rsidx = find(bonylmrks=='RS');
[RS,US,OL,MCP3,EM,EL]=deal(blmat(rsidx,:),blmat(rsidx+1,:),blmat(rsidx+2,:),blmat(rsidx+3,:),blmat(rsidx+4,:),blmat(rsidx+5,:));
%RS';'US';'OL';'MCP3';'EM';'EL'
BLnames = ["RS","US","OL","MCP3","EM","EL"];
BLs_lcs ={RS,US,OL,MCP3,EM,EL};

%% Old way of defining CS
H_mid=(RS(1:3)+US(1:3))/2;
yf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);
yf = -yf; % flipping so vector points cranially 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); %Vector through EL and EM
zf =cross(yf,x); 
zf=-(zf/norm(zf));

xf = cross (zf,yf);
xf = xf/norm(xf);
xf = -xf;

f = [xf;yf;zf]';
f = [f;0 0 0];

%Creating New Origin Midpoint Between Epicondyles not OL
H_mid_2=(EL(1:3)+EM(1:3)).'/2;
org_fore = [H_mid_2;1];

%Forearm Coordinate System in Marker CF
ForeCS = [f org_fore];
end
function [ScapCoord,BLnames,BLs_lcs ] =  asscap(blmat,bonylmrks)
%% Old way of creating CS
ACidx = find(bonylmrks=='AC');
[AC,TS,AI]=deal(blmat(ACidx,:),blmat(ACidx+1,:),blmat(ACidx+2,:));
BLnames = ["AC","TS","AI"];
BLs_lcs ={AC,TS,AI};



xs = (AC(1:3)-TS(1:3))/norm(AC(1:3)-TS(1:3)); 

zs = cross(xs,(AC(1:3)-AI(1:3)));
zs = zs/norm(zs);

ys = cross(xs,zs);
ys= ys/norm(ys);
ys=ys;

S = [xs;ys;-zs]';
S = [S; 0 0 0];

Orig = [AC(1:3) 1]';

%Scapular CS in Marker Frame
ScapCoord = [S Orig];

end
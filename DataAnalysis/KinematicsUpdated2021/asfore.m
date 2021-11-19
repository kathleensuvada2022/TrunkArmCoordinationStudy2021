
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
function [ForeCS,BLs_lcs_f,BLnames_f] =  asfore(blmat,bonylmrks)

%Kacey 10.2021
rsidx = find(bonylmrks=='RS');
[RS,US,OL,MCP3,EM,EL]=deal(blmat(:,rsidx),blmat(:,rsidx+1),blmat(:,rsidx+2),blmat(:,rsidx+3),blmat(:,rsidx+4),blmat(:,rsidx+5));
%RS';'US';'OL';'MCP3';'EM';'EL'
BLnames_f = ["RS","US","OL","MCP3","EM","EL"];
BLs_lcs_f ={RS,US,OL,MCP3,EM,EL};

%%
% Kacey Redefining X,Y,Z axes 10.6.21

H_mid=(RS(1:3)+US(1:3))/2;
zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);
%zf = zf; % flipping so vector points cranially 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); %Vector through EL and EM
yf =cross(zf,x); %flipped order because z in opposite direction
yf=(yf/norm(yf));


xf = cross (yf,zf);
xf = xf/norm(xf);

f = [xf yf zf];
f = [f;0 0 0];


%Creating New Origin Midpoint Between Epicondyles not OL
H_mid_2=(EL(1:3)+EM(1:3)).'/2;
org_fore = [H_mid_2 1]';

%Forearm Coordinate System in Marker CF
ForeCS = [f org_fore];
%%

end
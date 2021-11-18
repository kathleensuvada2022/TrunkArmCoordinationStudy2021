
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
function [Hum_CS,BLs_lcs_h,BLnames_h] =  ashum(blmat,GH,bonylmrks)
%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
%%
Emidx = find(bonylmrks=='EM',1); %EM is at the end as well for Forearm CS

[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
BLnames_h = ["EM","EL","GH"];
BLs_lcs_h ={EM,EL,GH};
% Kacey Redefining X,Y,Z axes 10.4.21 

H_mid=(EM(1:3)+EL(1:3))/2;
zh = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3)); %Vector through EL and EM
yh =cross(zh,x); %flipped order because z in opposite direction
yh=yh/norm(yh);


xh = cross (yh,zh);
xh = xh/norm(xh);

h = [xh;yh;zh]';

h = [h;0 0 0];

Origin = [GH(1:3)';1];

%T of Humerus in marker CS
Hum_CS = [h Origin];
%%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
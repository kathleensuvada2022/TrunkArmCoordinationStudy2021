
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
function [Hum_CS,GH] =  ashum(blmat,GH)

%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
[EM,EL]=deal(blmat(1,:),blmat(2,:));
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
Hum_CS = [h Origin];

end
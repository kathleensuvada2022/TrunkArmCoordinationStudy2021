
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the humerus in marker CS (local)
% Inputs: EM, EL
% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Y-axis : line between GH and mid-point between epicondyles.
% Local Z-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M

% KACEY 10.4.21
% KACEY 10.17.22 - adding updated GH estimate all coordinates in GCS

% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Z-axis : line between GH and mid-point between epicondyles.
% Local Y-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Hum_CS,BLs_lcs_h,BLnames_h] =  ashum_K_2022(EM_GCS,EL_GCS,xghest,hand)
%Kacey 10.2021
%Grabbing medial and laterial epi from matrix and matching to EM and EL
%%
EM = EM_GCS';
EL = EL_GCS'; 
GH = xghest';

BLnames_h = ["EM","EL","GH"];

% Kacey Redefining X,Y,Z axes 10.4.21 
%%
H_mid=(EM(1:3)+EL(1:3))/2;
zh = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3)); %Vector through EL and EM

% if strcmp(arm,'Left')
% x= (EM(1:3)-EL(1:3))/norm(EM(1:3)-EL(1:3)); %Vector through EL and EM
% end

yh =cross(zh,x); 
yh=yh/norm(yh);

xh = cross (yh,zh);
xh = xh/norm(xh);


h = [xh yh zh];
%%

% if strcmp(arm,'Left')
%  rot_180= rotz(180);
%  
%  h = h*rot_180;
%    
% end 

h = [h;0 0 0];
%%
Origin = GH(1:3)';
% 
% if strcmp(arm,'Left')
% Origin = GH(1:3)'*rot_180;   
% end
%%
Origin =[Origin 1]';

%%
%HT of Humerus in marker CS
Hum_CS = [h Origin]; % Humerus Coordinate System in the Global CS at given frame
%%

% if strcmp(arm,'Left')
% GH = Origin ;
% 
% EM = EM(1:3)'*rot_180;
% EM = [EM 1]';
% EL = EL(1:3)'*rot_180;
% EL = [EL 1]';
% BLs_lcs_h ={EM,EL,GH};
% end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
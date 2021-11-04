
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
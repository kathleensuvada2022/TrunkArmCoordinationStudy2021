
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
function [ScapCoord,BLnames_s,BLs_lcs_s ] =  asscap(blmat,bonylmrks)

% ACidx = find(bonylmrks=='AC');
% [AC,TS,AI]=deal(blmat(ACidx,:),blmat(ACidx+1,:),blmat(ACidx+2,:));
% BLnames = ["AC","TS","AI"];
% BLs_lcs ={AC,TS,AI};
%%

%Kacey 10.2021
% "AC" "AA" "TS" "AI"
ACidx = find(bonylmrks=='AC');
[AC,AA,TS,AI]=deal(blmat(:,ACidx),blmat(:,ACidx+1),blmat(:,ACidx+2),blmat(:,ACidx+3));
BLnames_s = ["AC","AA","TS","AI"];
BLs_lcs_s ={AC,AA,TS,AI};
%%

%10.4.21- Kacey Editing based on how want CS aligned 
xs = (AC(1:3)-TS(1:3))/norm(AC(1:3)-TS(1:3)); 
ys = cross(xs,(AC(1:3)-AI(1:3)));
ys = ys/norm(ys);
zs = cross(ys,xs);
zs= zs/norm(zs);

S = [xs ys zs];


%%
% if strcmp(arm,'Left')
%  rot_180= rotz(180);
%  
%  S = S*rot_180;
%    
% end 
% 


%%

S = [S;0 0 0];
%%
Orig = AC(1:4);

% if strcmp(arm,'Left')
% 
% Orig =Orig(1:3)'* rot_180; 
% 
% Orig= [Orig 1]';
%     
% end
%% 
% For plotting Computed GH
% Gh_bone = inv(ScapCoord)*gh_markr;
% plot3(Gh_bone(1),Gh_bone(2),Gh_bone(3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')

%After Running 
plotBLandCS(BLs_lcs_s,BLnames_s,ScapCoord,'Shoulder CS')
hold on
plot3(Gh_bone(1),Gh_bone(2),Gh_bone(3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(Gh_bone(1),Gh_bone(2),Gh_bone(3),'GH Computed','FontSize',12)


%%
%Scapular CS in Marker Frame
ScapCoord = [S Orig];
%%
end

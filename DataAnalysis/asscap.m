
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
function ScapCoord =  asscap(blmat)
% [AA,TS,AI]=deal(blmat(:,1),blmat(:,2),blmat(:,3));
%Edited to replace AA with AC Kacey 10.4.21

%Kacey 10.2021
ACidx = find(blmat(:,1)=='AC');
blmat=str2double(blmat);
[AC,TS,AI]=deal(blmat(ACidx,2:end),blmat(ACidx+1,2:end),blmat(ACidx+2,2:end));

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
ScapCoord = [S Orig];

%% Testing Plotting CS and BLS in marker CS

figure(2)
quiver3(ScapCoord([1 1 1],4)',ScapCoord([2 2 2],4)',ScapCoord([3 3 3],4)',ScapCoord(1,1:3),ScapCoord(2,1:3),ScapCoord(3,1:3))
text(ScapCoord(1,4)+ScapCoord(1,1:3),ScapCoord(2,4)+ScapCoord(2,1:3),ScapCoord(3,4)+ScapCoord(3,1:3),{'x','y','z'})

hold on
plot3(AC(1),AC(2),AC(3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(AC(1),AC(2),AC(3),'AC','FontSize',12)

plot3(TS(1),TS(2),TS(3),'-o','Color','g','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(TS(1),TS(2),TS(3),'TS','FontSize',12)

plot3(AI(1),AI(2),AI(3),'-o','Color','m','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(AI(1),AI(2),AI(3),'AI','FontSize',12)

%% Plotting BLS, Bone CS in Marker CF just X,Y

figure(1)
quiver(ScapCoord([1 1],4)',ScapCoord([2 2],4)',ScapCoord(1,1:2),ScapCoord(2,1:2))
text(ScapCoord(1,4)+ScapCoord(1,1:2),ScapCoord(2,4)+ScapCoord(2,1:2),{'x','y'})

hold on
plot(AC(1),AC(2),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(AC(1),AC(2),'AC','FontSize',12)

plot(TS(1),TS(2),'-o','Color','g','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
text(TS(1),TS(2),'TS','FontSize',12)

plot(AI(1),AI(2),'-o','Color','m','MarkerSize',10,...
   'MarkerFaceColor','#D9FFFF')
text(AI(1),AI(2),'AI','FontSize',12)


end
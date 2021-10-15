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
function [TrunkCS,BLnames,BLs_lcs ] = asthorho(blmat,bonylmrks)
%%
%[IJ,PX,C7,T8]=deal(blmat(1:3,1),blmat(1:3,2),blmat(1:3,3),blmat(1:3,4));

%Kacey 10.2021
IJidx = find(bonylmrks=='IJ');

[IJ,PX,C7,T8]=deal(blmat(IJidx,:),blmat(IJidx+1,:),blmat(IJidx+2,:),blmat(IJidx+3,:)); % in Marker Local CS
BLnames = ["IJ","PX","C7","T8"];
BLs_lcs ={IJ,PX,C7,T8};

% yt = (IJ+C7)/2 - (PX+T8)/2;
% yt = yt/norm(yt);
%%
% Edited Kacey 10.5.21
zt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
zt = zt/norm(zt);


blmat_th =[IJ(1:3);PX(1:3);C7(1:3);T8(1:3)];


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
t = [xt,yt,zt]; 


% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);

t = [xt;yt;zt]';
%%
diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end

t = [t;0 0 0];
orign_trunk = [IJ(1:3) 1]';

%Trunk Coordinate System in Marker CS
TrunkCS = [t orign_trunk];
% %% Testing Plotting CS and BLS in marker CS
% 
% figure(2)
% quiver3(TrunkCS([1 1 1],4)',TrunkCS([2 2 2],4)',TrunkCS([3 3 3],4)',TrunkCS(1,1:3),TrunkCS(2,1:3),TrunkCS(3,1:3))
% text(TrunkCS(1,4)+TrunkCS(1,1:3),TrunkCS(2,4)+TrunkCS(2,1:3),TrunkCS(3,4)+TrunkCS(3,1:3),{'x','y','z'})
% 
% 
% hold on
% plot3(IJ(1),IJ(2),IJ(3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(IJ(1),IJ(2),IJ(3),'IJ','FontSize',12)
% 
% plot3(PX(1),PX(2),PX(3),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(PX(1),PX(2),PX(3),'PX','FontSize',12)
% 
% plot3(C7(1),C7(2),C7(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(C7(1),C7(2),C7(3),'C7','FontSize',12)
% 
% plot3(T8(1),T8(2),T8(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(T8(1),T8(2),T8(3),'T8','FontSize',12)
% 
% %% Plotting BLS, Bone CS in Marker CF just X,Y
% 
% figure(1)
% quiver(TrunkCS([1 1],4)',TrunkCS([2 2],4)',TrunkCS(1,1:2),TrunkCS(2,1:2))
% text(TrunkCS(1,4)+TrunkCS(1,1:2),TrunkCS(2,4)+TrunkCS(2,1:2),{'x','y'})
% 
% hold on
% plot(AC(1),AC(2),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(AC(1),AC(2),'AC','FontSize',12)
% 
% plot(TS(1),TS(2),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(TS(1),TS(2),'TS','FontSize',12)
% 
% plot(AI(1),AI(2),'-o','Color','m','MarkerSize',10,...
%    'MarkerFaceColor','#D9FFFF')
% text(AI(1),AI(2),'AI','FontSize',12)


end
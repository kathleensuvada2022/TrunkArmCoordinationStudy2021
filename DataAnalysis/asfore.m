
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
function [ForeCS,BLs_lcs,BLnames] =  asfore(blmat,bonylmrks)

%Kacey 10.2021

rsidx = find(bonylmrks=='RS');
[RS,US,OL,MCP3]=deal(blmat(rsidx,:),blmat(rsidx+1,:),blmat(rsidx+2,:),blmat(rsidx+3,:));
BLnames = ["RS","US","OL","MCP3"];
BLs_lcs ={RS,US,OL,MCP3};

%%
% Kacey Redefining X,Y,Z axes 10.6.21
H_mid=(RS(1:3)+US(1:3))/2;
zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);
%zf = zf; % flipping so vector points cranially 

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); %Vector through EL and EM
yf =cross(zf,x); %flipped order because z in opposite direction
yf=-(yf/norm(yf));


xf = cross (zf,yf);
xf = xf/norm(xf);

f = [xf;yf;zf]';
f = [f;0 0 0];
org_fore = [OL(1:3) 1]';

%Forearm Coordinate System in Marker CF
ForeCS = [f org_fore];



%% Testing Plotting CS and BLS in marker CS
% 
% figure(3)
% quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50*ForeCS(1,1:3),50*ForeCS(2,1:3),50*ForeCS(3,1:3))
% %quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
% text(ForeCS(1,4)+50*ForeCS(1,1:3),ForeCS(2,4)+50*ForeCS(2,1:3),ForeCS(3,4)+50*ForeCS(3,1:3),{'x','y','z'})
% 
% hold on
% plot3(RS(1),RS(2),RS(3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(RS(1),RS(2),RS(3),'RS','FontSize',12)
% 
% plot3(US(1),US(2),US(3),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(US(1),US(2),US(3),'US','FontSize',12)
% 
% plot3(MCP3(1),MCP3(2),MCP3(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(MCP3(1),MCP3(2),MCP3(3),'MCP3','FontSize',12)
% 
% plot3(OL(1),OL(2),OL(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(OL(1),OL(2),OL(3),'OL','FontSize',12)
% 
% axis equal
% %% Plotting BLS, Bone CS in Marker CF just X,Y
% 
% % change u and V to see magnitude 
% figure(1)
% quiver(ForeCS([1 1],4)',ForeCS([2 2],4)',ForeCS(1,1:2),ForeCS(2,1:2))
% text(ForeCS(1,4)+ForeCS(1,1:2),ForeCS(2,4)+ForeCS(2,1:2),{'x','y'})
% 
% hold on
% plot(RS(1),RS(2),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(RS(1),RS(2),'RS','FontSize',12)
% 
% plot(US(1),US(2),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(US(1),US(2),'US','FontSize',12)
% 
% plot(MCP3(1),MCP3(2),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(MCP3(1),MCP3(2),'MCP3','FontSize',12)
% 

end
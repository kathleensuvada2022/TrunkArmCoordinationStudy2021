
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
zh = zh; 

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

%% Testing Plotting CS and BLS in marker CS

% See updated function "plotBLandCS
% figure(2)
% quiver3(Hum_CS([1 1 1],4)',Hum_CS([2 2 2],4)',Hum_CS([3 3 3],4)',Hum_CS(1,1:3),Hum_CS(2,1:3),Hum_CS(3,1:3))
% text(Hum_CS(1,4)+Hum_CS(1,1:3),Hum_CS(2,4)+Hum_CS(2,1:3),Hum_CS(3,4)+Hum_CS(3,1:3),{'x','y','z'})
% 
% hold on
% plot3(EM(1),EM(2),EM(3),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(EM(1),EM(2),EM(3),'EM','FontSize',12)
% 
% plot3(EL(1),EL(2),EL(3),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(EL(1),EL(2),EL(3),'EL','FontSize',12)
% 
% plot3(GH(1),GH(2),GH(3),'-o','Color','m','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(GH(1),GH(2),GH(3),'GH','FontSize',12)
% 
% %% Plotting BLS, Bone CS in Marker CF just X,Y
% 
% figure(1)
% quiver(Hum_CS([1 1],4)',Hum_CS([2 2],4)',Hum_CS(1,1:2),Hum_CS(2,1:2))
% text(Hum_CS(1,4)+Hum_CS(1,1:2),Hum_CS(2,4)+Hum_CS(2,1:2),{'x','y'})
% 
% hold on
% plot(EM(1),EM(2),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(EM(1),EM(2),'RS','FontSize',12)
% 
% plot(EL(1),EL(2),'-o','Color','g','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(EL(1),EL(2),'US','FontSize',12)
% 
% plot(GH(1),GH(2),'-o','Color','m','MarkerSize',10,...
%    'MarkerFaceColor','#D9FFFF')
% text(GH(1),GH(2),'OL','FontSize',12)


end
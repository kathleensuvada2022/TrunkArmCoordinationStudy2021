
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the Forearm local coordinate system.

%Inputs: RS,US,OL
% KACEY 10.4.21
% Local X-axis : defined by Y cross Z
% Local Z-axis : line between OL and mid-point between styloids.
% Local Y-axis : perpendicular to the plane defined by Z axis and line
% through styloids
% GH is determined using regression equations in GHEST.M

%K. Suvada 10.17.22 
% Updating so CS in GCS for computation of elbow angle 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ForeCS =   asfore_K_2022(RS,US,OL,EM,EL,hand,frame,flag)
% 10.17.22
BLnames_f = ["RS","US","OL","MCP3","EL","EM"];

RS = RS';
US = US';
OL = OL';

EM = EM';
EL = EL';

H_mid=(RS(1:3)+US(1:3))/2; %midpnt between RS and US
H_mid_2=(EL(1:3)+EM(1:3))/2; % midpnt between EM and EL


%%
% Kacey Redefining X,Y,Z axes 10.6.21

% Changed from OL to Midpnt EM/EL 10.28.22
zf = (H_mid_2-H_mid) / norm(H_mid_2-H_mid);

%zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);



x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); % from US to RS
yf =cross(zf,x); %flipped order because z in opposite direction
yf=(yf/norm(yf));


xf = cross (yf,zf);
xf = xf/norm(xf);

f = [xf yf zf];

%%  Flipping to mimic the right arm 

if strcmp(hand,'Left')
xf = -xf;
yf = -yf;
% zf = cross(xf,yf);
f = [xf,yf,zf];

end


%%
f = [f;0 0 0];


org_fore = [H_mid_2 ;1];



%%
%Forearm Coordinate System in Marker CF
ForeCS = [f org_fore];
%%
%% Plotting CS and BLS
if flag ==1
  figure(42)
%Plotting the BonyLandmarks and their Labels

    plot3(EL(1),EL(2),EL(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(EL(1),EL(2),EL(3),'EL','FontSize',14)


    plot3(EM(1),EM(2),EM(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(EM(1),EM(2),EM(3),'EM','FontSize',14)

    plot3(US(1),US(2),US(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(US(1),US(2),US(3),'US','FontSize',14)

    plot3(RS(1),RS(2),RS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(RS(1),RS(2),RS(3),'RS','FontSize',14)

    plot3(OL(1),OL(2),OL(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(OL(1),OL(2),OL(3),'OL','FontSize',14)


% Plotting FORE CS at given Frame
quiver3(ForeCS ([1 1 1],4)',ForeCS ([2 2 2],4)',ForeCS ([3 3 3],4)',50*ForeCS (1,1:3),50*ForeCS (2,1:3),50*ForeCS (3,1:3))
text(ForeCS (1,4)+50*ForeCS (1,1:3),ForeCS (2,4)+50*ForeCS (2,1:3),ForeCS (3,4)+50*ForeCS (3,1:3),{'X_F','Y_F','Z_F'})

% line between styloids
plot3([RS(1) US(1)],[RS(2) US(2)],[RS(3) US(3)])

axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title(['Forearm CS and Respective BLS in GCS During Trial. FRAME:' num2str(frame)],'FontSize',16)  
    
end

end
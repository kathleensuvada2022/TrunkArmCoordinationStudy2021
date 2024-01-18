
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the humerus in marker CS (local)
% Inputs: EM, EL
% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Y-axis : line between GH and mid-point between epicondyles.
% Local Z-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M


% KACEY 2022 - adding updated GH estimate all coordinates in GCS and


% Local X-axis : axis perpendicular to line between epicondyles epi_l -> epi_m
% Local Z-axis : line between GH and mid-point between epicondyles.
% Local Y-axis : axis perpendicular to local X and Y-axis.
% GH is determined using regression equations in GHEST.M
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Hum_CS,BLs_lcs_h,BLnames_h] =  ashum_K_2024_EMEL(EM_GCS,EL_GCS,xghest,hand,frame,flag)

%Grabbing medial and laterial epi from matrix and matching to EM and EL
%%
EM = EM_GCS';
EL = EL_GCS'; 
GH = xghest';

BLnames_h = ["EM","EL","GH"];
%%
H_mid=(EM(1:3)+EL(1:3))/2;
zh = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);

%Yh: Need perpendicular to plane defined by z axis and line through em el
x= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3)); %Vector through EL and EM


yh =cross(zh,x); 
yh=yh/norm(yh);

xh = cross (yh,zh);
xh = xh/norm(xh);


h = [xh yh zh];


h = [h;0 0 0];

% Origin = GH(1:3)';
% 

Origin = H_mid(1:3)' ; 

Origin =[Origin 1]';

%%
%HT of Humerus in marker CS
Hum_CS = [h Origin]; % Humerus Coordinate System in the Global CS at given frame

%% Plotting CS and BLS
if flag ==1
  figure(46)
%Plotting the BonyLandmarks and their Labels

    plot3(EL(1),EL(2),EL(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(EL(1),EL(2),EL(3),'EL','FontSize',14)


    plot3(EM(1),EM(2),EM(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(EM(1),EM(2),EM(3),'EM','FontSize',14)

    plot3(GH(1),GH(2),GH(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(GH(1),GH(2),GH(3),'GH','FontSize',14)


% Plotting HUM CS at given Frame
quiver3(Hum_CS ([1 1 1],4)',Hum_CS ([2 2 2],4)',Hum_CS ([3 3 3],4)',50*Hum_CS (1,1:3),50*Hum_CS (2,1:3),50*Hum_CS (3,1:3))
text(Hum_CS (1,4)+50*Hum_CS (1,1:3),Hum_CS (2,4)+50*Hum_CS (2,1:3),Hum_CS (3,4)+50*Hum_CS (3,1:3),{'X_H','Y_H','Z_H'})


axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title(['Humerus CS and Respective BLS in GCS During Trial. FRAME:' num2str(frame)],'FontSize',16)  
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
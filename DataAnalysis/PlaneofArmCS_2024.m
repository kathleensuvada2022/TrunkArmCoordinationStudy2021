function PlaneofArmCS = PlaneofArmCS_2024(GH_TCS,GH_TCS_init,xhand_TCS,EL_TCS,EM_TCS,frame,flag)


% Used to create a coordinate system in the plane of the arm
% for proper computation of the Reaching Distance, Trunk Displacement, and
% Glenohumeral Joint Displacement.

%Convention when arm is in horizontal plane reaching: X is to the right, Y
%is forwards in the direction of the reach, and Z is up. Note all the
%inputs are in the TRUNK COORDINATE SYSTEM.

% Inputs: GH_TCS,xhand_TCS,EL_TCS,EM_TCS : GH, MCP3, EM and EL in Trunk CS.
% Output: Coordinate system in the plane of the reach


%K. Suvada. Jan 2024.

%% Compute Midpoint of EM/EL
H_mid=(EM_TCS(1:3)+EL_TCS(1:3))/2;

%% Creating each axis

Y_planeArm = xhand_TCS(1:3)-GH_TCS_init(1:3);
Y_planeArm  = Y_planeArm /norm(Y_planeArm);

Xhat = H_mid-GH_TCS_init(1:3);

Z_planeArm = cross(Xhat,Y_planeArm);
Z_planeArm = Z_planeArm/norm(Z_planeArm);

X_planeArm  = cross(Y_planeArm,Z_planeArm);
X_planeArm = X_planeArm/norm(X_planeArm);

PlaneArmCS = [X_planeArm Y_planeArm Z_planeArm];


%% Setting Origin
PlaneArmCS = [PlaneArmCS;0 0 0];

Origin = GH_TCS_init(1:3)'; % GH Location at Start of Reach

Origin =[Origin 1]';

%%
PlaneofArmCS = [PlaneArmCS Origin]; % New Coordinate System with Origin at GHinit in the trunk CS

%% Plot of CS

if flag ==1
    figure(54)
    %Plotting the BonyLandmarks and their Labels
    plot3(EL_TCS(1),EL_TCS(2),EL_TCS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(EL_TCS(1),EL_TCS(2),EL_TCS(3),'EL','FontSize',14)


    plot3(EM_TCS(1),EM_TCS(2),EM_TCS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(EM_TCS(1),EM_TCS(2),EM_TCS(3),'EM','FontSize',14)

    plot3(GH_TCS(1),GH_TCS(2),GH_TCS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(GH_TCS(1),GH_TCS(2),GH_TCS(3),'GH','FontSize',14)


    plot3(xhand_TCS(1),xhand_TCS(2),xhand_TCS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(xhand_TCS(1),xhand_TCS(2),xhand_TCS(3),'MCP3','FontSize',14)

    % Plotting CS at first Frame
    quiver3(PlaneofArmCS ([1 1 1],4)',PlaneofArmCS ([2 2 2],4)',PlaneofArmCS ([3 3 3],4)',50*PlaneofArmCS (1,1:3),50*PlaneofArmCS (2,1:3),50*PlaneofArmCS (3,1:3))
    text(PlaneofArmCS (1,4)+50*PlaneofArmCS (1,1:3),PlaneofArmCS (2,4)+50*PlaneofArmCS (2,1:3),PlaneofArmCS (3,4)+50*PlaneofArmCS (3,1:3),{'X','Y','Z'})


    %% Adding lines from GH to MCP3, GH to MID, and MID to MCP3
    
    plot3([H_mid(1) GH_TCS(1)],[H_mid(2) GH_TCS(2)],[H_mid(3) GH_TCS(3)],'b','Linewidth',2) % GH to Midpnt
    
    plot3([xhand_TCS(1) GH_TCS(1)],[xhand_TCS(2) GH_TCS(2)],[xhand_TCS(3) GH_TCS(3)],'b','Linewidth',2) % GH to MCP3

    plot3([xhand_TCS(1) H_mid(1)],[xhand_TCS(2) H_mid(2)],[xhand_TCS(3) H_mid(3)],'b','Linewidth',2) % Midpnt to MCP3


    axis equal
    xlabel('X axis (mm)')
    ylabel('Y axis (mm)')
    zlabel('Z axis (mm)')

    title(['Plane of Arm CS and Respective BLS in TRUNK CS FRAME:' num2str(frame)],'FontSize',16)

end
end
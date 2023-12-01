% Computing Limb Length Based on Anatomical Landmarks of the Arm, Shoulder,
% and Hand: EM,EL,RS,US,GH,MCP3 in GCS. Use the start of the reach idx(1).
% Compute once then save to setup file. 

% November 2023
% K. Suvada

function LimbLength_BL = ComputeLimbLengthBLs(H_Mid_F,H_Mid_H,xhand,gh,idx,setup)

%Distance from Gh (gh) to midpnt EM/EL (H_Mid_H)
Seg1 = sqrt((H_Mid_H(idx(1),1) - gh(idx(1),1))^2+(H_Mid_H(idx(1),2) - gh(idx(1),2))^2+(H_Mid_H(idx(1),3) - gh(idx(1),3))^2)

% Distance from midpnt EM/EL (H_Mid_H) to midpnt RS/US (H_Mid_F)
% Seg2 = sqrt((H_Mid_F(idx(1),1) - H_Mid_H(idx(1),1))^2+(H_Mid_F(idx(1),2) - H_Mid_H(idx(1),2))^2+(H_Mid_F(idx(1),3) - H_Mid_H(idx(1),3))^2);

%Distance EM/EL to MCP3
 Seg2 = sqrt((H_Mid_H(idx(1),1) - xhand(idx(1),1))^2+(H_Mid_H(idx(1),2) - xhand(idx(1),2))^2+(H_Mid_H(idx(1),3) - xhand(idx(1),3))^2)


%Distance from midpnt RS/US to MCP3
% Seg3 =sqrt((xhand(idx(1),1) - H_Mid_F(idx(1),1))^2+(xhand(idx(1),2) - H_Mid_F(idx(1),2))^2+(xhand(idx(1),3) - H_Mid_F(idx(1),3))^2);

%Computing Limb Length

% Raw Metria Data is in mm 
%LimbLength_BL = Seg1+Seg2+Seg3
LimbLength_BL = Seg1+Seg2
% Saving to setup file and saving new setup file with LL from BLs
setup.BonylandmarkL= LimbLength_BL;

save setup

end
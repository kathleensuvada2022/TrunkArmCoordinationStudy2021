%% ComputeEulerAngles_2022
%  K. Suvada
%  Fall 2022

% Function to compute Euler Angles based off inputs as rotation matrices. 
% Angles are output in degrees. Feed in desired segments rotation matrices
% for angles. K. Suvada's coordinate system convention is as follows: 

% View from behind for right hand:

% - X to the right
% - Y forwards
% - Z upwards

%Inputs
% - Fore_CS_G: HT matrix for Forearm cs in GCS.
% - Hum_CS_G: HT matrix for Humerus cs in GCS
% - gR_trunk: Rotation matrix for Trunk in GCS. 
% - jR_trunk: Rotation matrix for Trunk relative to Trunk initial.
% - gR_Hum: Rotation matrix for Humerus in GCS.
% - jr_Hum_ti: Rotation matrix for Humerus rel to Trunk initial.
% - jr_Hum_T: Rotation matrix for Humerus rel to Trunk all frames.
% - gR_Scap: Rotation matrix Scapula rel to GCS.
% - jr_Scap_ti : Rotation matrix for Scapula rel to Trunk initial.
% - jr_Scap_T : Rotation matrix for Scapula rel to Trunk all frames.

%Outputs
% - ELB_ANG: Elbow angles Forearm rel to Humerus.
% - Trunk_ANG_: Trunk angles in GCS. 
% - Trunk_ANG_Ti: Trunk angles rel to Trunk inital. 
% - HumAng_: Humerus angles in GCS. 
% - HumAng_Ti: Humerus angles rel to Trunk inital. 
% - Hum_Ang_T: Humerus angles rel to Trunk.
% - ScapAng_G: Scap angles rel to GCS.
% - ScapAng_Ti: Scap angles rel to Trunk initial.
% - Scap_Ang_T: Scap angles rel to Trunk.
%%

function [ELB_ANG,Trunk_ANG_G,Trunk_ANG_Ti,HumAng_G,HumAng_Ti,HumAng_T,ScapAng_G,ScapAng_Ti,ScapAng_T] = ComputeEulerAngles_2022(Fore_CS_G,Hum_CS_G,gR_trunk,jR_trunk,gR_Hum,jr_Hum_ti,jr_Hum_T,gR_Scap,jr_Scap_ti,jr_Scap_T,k);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Compute Euler Angles %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Elbow
% Elbow Angles- Joint Angle. Angle is using two segments relative to each
% other. HT of Forearm in GCS and HT of Humerus in GCS. 

% Rotation matrix of forearm rel to humerus (joint rotation matrix jR)
jR_ForeinHum = inv(Hum_CS_G(1:3,1:3))*Fore_CS_G(1:3,1:3);

% Computing Elbow Angle 
% X- elbow flexion/extension
% Z - Pronation/Supination
jAngles_elbow = CalcEulerAng(jR_ForeinHum,'XZY',0); 

ELB_ANG=jAngles_elbow ;% Output of Function

%% Trunk
% TRUNK Angles - Joint angle and Global Angle. Trunk rel to GCS and Trunk
% rel to Trunk at start of reach. 

% Angles
% 1) Forward Flexion/Extension
% 2) Lateral Bending

% Global Angle
Trunk_ANG_G = CalcEulerAng(gR_trunk,'XZY',0); 

% TRUNK rel to Trunk Initial
Trunk_ANG_Ti = CalcEulerAng(jR_trunk,'XZY',0); 

%% Humerus 
% Humerus Angles - Joint angles and Global Angles. Hum rel to GCS, Hum
% rel to Trunk at start of reach, and Hum rel to Trunk.

% Angles
% 1) Pole angle
% 2) SABD

% Global Angle
HumAng_G =  CalcEulerAng(gR_Hum,'ZYZ',0); 

% Joint Angle - Ti
HumAng_Ti =  CalcEulerAng(jr_Hum_ti,'ZYZ',0); 

% Joint Angle - T
HumAng_T =  CalcEulerAng(jr_Hum_T,'ZYZ',0); 

 %% Scapula 
% Scapular Angles - Joint angles and Global Angles. Scap rel to GCS, Scap
% rel to Trunk at start of reach, and Scap rel to Trunk all time.

% Angles
% 1) Waving- laterl rotation (Y)
% 2) Forward/Backward tilt (Z) (pole)
% 3) Pro-retraction  (X)

% Global Angle
ScapAng_G =  CalcEulerAng(gR_Scap,'YZX',0); 

% Joint Angle - Ti
ScapAng_Ti =  CalcEulerAng(jr_Scap_ti,'YZX',0); 

% Joint Angle - T
ScapAng_T =  CalcEulerAng(jr_Scap_T,'YZX',0); 



end
 

 
 
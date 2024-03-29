%% ComputeEulerAngles_2022
%  K. Suvada
%  2022 
%  2023

% Function to compute Euler Angles and relative joint rotation matrices
% based off inputs as rotation matrices. 
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

function [ELB_ANG,ELB_ANG_MAT,Trunk_ANG_G,Trunk_ANG_G_Mat,Trunk_ANG_Ti,Trunk_ANG_Ti_Mat,HumAng_G,HumAng_G_CalcEuler,HumAng_Ti,HumAng_Ti_CalcEuler,HumAng_T,HumAng_T_CalcEuler,ScapAng_G,ScapAng_G_CalcEul,ScapAng_Ti,ScapAng_Ti_CalcEul,ScapAng_T,ScapAng_T_CalcEul] = ComputeEulerAngles_2022(hand,Fore_CS_G,Hum_CS_G,gR_trunk,jR_trunk,gR_Hum,jr_Hum_ti,jr_Hum_T,gR_Scap,jr_Scap_ti,jr_Scap_T,k);


%    The following rotation sequences, SEQ, are supported: 'ZYX', 'ZYZ', and
%     'XYZ'.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Computing Rotation Matrices + Respective Angles %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Elbow
% Elbow Angles- Joint Angle. Angle is using two segments relative to each
% other. HT of Forearm in GCS and HT of Humerus in GCS. 

% From Original 'ComputeEulerAngles' :    
% "Relative to Previous Segment"
% Hi*Rfi = Fi  -> Rfi = Hi'*Fi 


%  if strcmp(hand,'Left')

%  Try Line below 
% jR_ForeinHum = inv(rotz(180)*Hum_CS_G(1:3,1:3))*rotz(180)*Fore_CS_G(1:3,1:3); 
% jR_ForeinHum = inv(Hum_CS_G(1:3,1:3))*Fore_CS_G(1:3,1:3); 

%  else 
jR_ForeinHum = inv(Hum_CS_G(1:3,1:3))*Fore_CS_G(1:3,1:3); 

%  end 




% Computing Elbow Angle 
% X- elbow flexion/extension
% Y - Pronation/Supination -> Based off CalcInputKinem 'XZY'
jAngles_elbow = CalcEulerAng(jR_ForeinHum,'XYZ',0); 


jAngles_elbow_mat = rotm2eul(jR_ForeinHum,'XYZ'); % Internal Matlab Function 


ELB_ANG=jAngles_elbow ;% from CalcEulerAng
ELB_ANG_MAT=jAngles_elbow_mat ;% from internal Matlab Function

ELB_ANG_MAT = rad2deg(ELB_ANG_MAT);

%% Trunk
% TRUNK Angles - Joint angle and Global Angle. Trunk rel to GCS and Trunk
% rel to Trunk at start of reach. 

% Angles
% 1) Forward Flexion/Extension
% 2) Twisting
% 3) Lateral Bending

% Global Angle
Trunk_ANG_G = CalcEulerAng(gR_trunk,'XZY',0); % Need XZY order for K. Suvada

Trunk_ANG_G_Mat = rad2deg(rotm2eul(gR_trunk,'XYZ')); % Matlab function



% TRUNK rel to Trunk Initial
Trunk_ANG_Ti = CalcEulerAng(jR_trunk,'XZY',0);  %Flipped bc XZY actually XYZ (based on matlab internal function)???
% KACEY -> pls check  this logic as it does not hold 

Trunk_ANG_Ti_Mat = rad2deg(rotm2eul(jR_trunk,'XYZ')); %Matlab Function
%% Humerus 
% Humerus Angles - Joint angles and Global Angles. Hum rel to GCS, Hum
% rel to Trunk at start of reach, and Hum rel to Trunk.

% Angles
% 1) Pole angle
% 2) SABD
% 3) Internal/ External Rotation

% Global Angle
HumAng_G =   rad2deg(rotm2eul(gR_Hum,'ZYZ'));  
HumAng_G_CalcEuler = CalcEulerAng(gR_Hum,'ZYZ',0);

% Joint Angle - Ti
HumAng_Ti =  rad2deg(rotm2eul(jr_Hum_ti,'ZYZ'));
HumAng_Ti_CalcEuler = CalcEulerAng(jr_Hum_ti,'ZYZ',0);


% Joint Angle - T
HumAng_T =  rad2deg(rotm2eul(jr_Hum_T,'ZYZ'));
HumAng_T_CalcEuler= CalcEulerAng(jr_Hum_T,'ZYZ',0);


 %% Scapula 
% Scapular Angles - Joint angles and Global Angles. Scap rel to GCS, Scap
% rel to Trunk at start of reach, and Scap rel to Trunk all time.

% Both functions work just as well! Regardless does not matter if
% using rotm2eul (Matlab internal function) or CalcEulerAng (Ana Maria).
% Changed to internal function for consistency with humerus.



% Global Angle
 ScapAng_G_CalcEul =  CalcEulerAng(gR_Scap,'ZYX',0); 

ScapAng_G =  rad2deg(rotm2eul(gR_Scap,'ZYX')); 


% Joint Angle - Ti
ScapAng_Ti_CalcEul =  CalcEulerAng(jr_Scap_ti,'ZYX',0); 

ScapAng_Ti =  rad2deg(rotm2eul(jr_Scap_ti,'ZYX')); 


% Joint Angle - T
  ScapAng_T_CalcEul =  CalcEulerAng(jr_Scap_T,'ZYX',0); 

% Gives same thing regardless of function used


ScapAng_T =  rad2deg(rotm2eul(jr_Scap_T,'ZYX')); 


end
 

 
 
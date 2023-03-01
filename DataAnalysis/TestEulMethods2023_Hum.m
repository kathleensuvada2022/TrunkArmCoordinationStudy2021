% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% HUMERUS:
% Segment = 'Humerus'; 
%%
 %AngRange1_H = -45:134;
% AngRange2_H = -179:0;
% AngRange3_H = -35:144;
%%

function [CraigCheck,OrigCheck,Check_Mat,FinalCheck] = TestEulMethods2023_Hum(AngRange1_H,AngRange2_H,AngRange3_H)
%% Initializing Variables 

% Rotation matrix with all angle permutations
    RZYZ = zeros(3,3,length(AngRange1_H));

    % Angles for Craig Method
    z_2023 = zeros(1,length(AngRange1_H));
    y_2023 = zeros(1,length(AngRange1_H));
    za_2023 = zeros(1,length(AngRange1_H));

    % Angles for Dutch Method
    z_orig = zeros(1,length(AngRange1_H));
    y_orig = zeros(1,length(AngRange1_H));
    za_orig = zeros(1,length(AngRange1_H));

    % Angles for Matlab Function
    Angs_mat = zeros(length(AngRange1_H),3);
    %% Creating Matrix with all Permutations of 3 Angles

    Perm_Mat = combvec(AngRange1_H,AngRange2_H,AngRange3_H);

%% Creating Rotation Matrix with Known Angles and Computer Euler Angles 

    for i = 1:length(Perm_Mat)
        RZYZ = rotz(Perm_Mat(1,i))*roty(Perm_Mat(2,i))*rotz(Perm_Mat(3,i));
i
        % Craig Method with ArcTan2
        [z_2023(i),y_2023(i),za_2023(i)]=rotzyz2023(RZYZ);

        % Original Dutch Method
        [z_orig(i),y_orig(i),za_orig(i)]=rotzyz(RZYZ);

        %Internal Matlab Function - (only used with supported sequences)
        [Angs_mat(i,:)]=rotm2eul(RZYZ,'ZYZ');

    end

    %Converting to Degrees
    z_2023 = rad2deg(z_2023);
    y_2023 = rad2deg(y_2023);
    za_2023 = rad2deg(za_2023);

    z_orig = rad2deg(z_orig);
    y_orig = rad2deg(y_orig);
    za_orig = rad2deg(za_orig);

    Angs_mat = rad2deg(Angs_mat);

    %% Checking Input with Computed Angles:

    % Craig Method Check %
    % Z
    Check_CraigZ = Perm_Mat(1,:)' == round(z_2023(:));

    % Y
    Check_CraigY = Perm_Mat(2,:)' == round(y_2023(:)); 

    % Za
    Check_CraigZ2 = Perm_Mat(3,:)' == round(za_2023(:)); 

    CraigCheck = [Check_CraigZ,Check_CraigY,Check_CraigZ2];
   
    Craig_Mat = [z_2023;y_2023;za_2023]';

    % Dutch Method Check % - From Calc Euler Angles
    
    % Z
    Check_OrigZ = Perm_Mat(1,:)' == round(z_orig(:));

    % Y
    Check_OrigY = Perm_Mat(2,:)' == round(y_orig(:)); 
    % Za
    Check_OrigZ2 = Perm_Mat(3,:)' == round(za_orig(:));

    OrigCheck = [Check_OrigZ,Check_OrigY,Check_OrigZ2];

    Dutch_Mat = [z_orig;y_orig;za_orig]';

    % Matlab Method Check
 
    % Z
    Check_MatZ = Perm_Mat(1,:)' == round(Angs_mat(:,1));  
    % Y
    Check_MatY = Perm_Mat(2,:)' == round(Angs_mat(:,2)); 
    % Za
    Check_MatZ2 = Perm_Mat(3,:)' == round(Angs_mat(:,3)); 

    Check_Mat = [Check_MatZ,Check_MatY,Check_MatZ2];
   
    % Matlab = Dutch = Craig Check

    FinalCheck = round(Angs_mat) == round(Dutch_Mat) & round(Dutch_Mat) == round(Craig_Mat); 
end
% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% ELBOW:
% Joint = 'Elbow'; *USE ROTM2EUL TO SATISFY ANGLE RANGES REQUIRED
%%
AngRange1_E = 0: 90;  %--> need 180 - angle for elbow flexion/extension
 AngRange2_E = -10:80;
 AngRange3_E = -15:75;%note this is not a real angle
%%

function [OrigCheck,Check_Mat] = TestEulMethods2023_Elb(AngRange1_E,AngRange2_E,AngRange3_E,Joint)

if(strcmp(Joint,'Elbow'))

    RXYZ = zeros(3,3,length(AngRange1_E));

    x_2023 = zeros(1,length(AngRange1_E));
    y_2023 = zeros(1,length(AngRange1_E));
    z_2023 = zeros(1,length(AngRange1_E));

    x_orig = zeros(1,length(AngRange1_E));
    y_orig = zeros(1,length(AngRange1_E));
    z_orig = zeros(1,length(AngRange1_E));

    Angs_mat = zeros(length(AngRange1_E),3);

    for i = 1:length(AngRange1_E)
        RXYZ(:,:,i) = rotx(AngRange1_E(i))*roty(AngRange2_E(i))*rotz(AngRange3_E(i));

        % Original
        [x_orig(i),y_orig(i),z_orig(i)]=rotxyz(RXYZ(:,:,i)); %both work and yield the same


        %Internal Matlab Function - (only used with supported sequences)
        [Angs_mat(i,1:3)]=rotm2eul(RXYZ(:,:,i),'XYZ'); %works same as above

    end


    x_orig = rad2deg(x_orig);
    y_orig = rad2deg(y_orig);
    z_orig = rad2deg(z_orig);

    Angs_mat = rad2deg(Angs_mat);

    %% Checking Input with Computed Angles:


    % Original Method Check %

    % X
    Check_OrigX = AngRange1_E(:) == round(x_orig(:)); 

    % Y
    Check_OrigY = AngRange2_E(:) == round(y_orig(:));

    % Z
    Check_OrigZ = AngRange3_E(:) == round(z_orig(:)); 
    
    OrigCheck = [Check_OrigX,Check_OrigY,Check_OrigZ];

    % Matlab Method Check
 
    % X
    Check_MatX = AngRange1_E' == round(Angs_mat(:,1));  

    % Y
    Check_MatY = AngRange2_E' == round(Angs_mat(:,2)); 
   
    % Z
    Check_MatZ = AngRange3_E' == round(Angs_mat(:,3)); 
   
    Check_Mat = [Check_MatX,Check_MatY,Check_MatZ];

end


end
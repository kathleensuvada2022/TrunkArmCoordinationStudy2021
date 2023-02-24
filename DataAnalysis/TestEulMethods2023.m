% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% HUMERUS:
% Segment = 'Humerus';
%%
AngRange1_H = -45:134;
AngRange2_H = -179:0;
AngRange3_H = -35:144;
%%

function [outputArg1,outputArg2] = TestEulMethods2023(AngRange1_H,AngRange2_H,AngRange3_H,RZYZ,Segment)

if(strcmp(Segment,'Humerus'))

    RZYZ = zeros(3,3,length(AngRange1_H));

    z_2023 = zeros(1,length(AngRange1_H));
    y_2023 = zeros(1,length(AngRange1_H));
    za_2023 = zeros(1,length(AngRange1_H));

    z_orig = zeros(1,length(AngRange1_H));
    y_orig = zeros(1,length(AngRange1_H));
    za_orig = zeros(1,length(AngRange1_H));

    Angs_mat = zeros(length(AngRange1_H),3);

    for i = 1:length(AngRange1_H)
        RZYZ(:,:,i) = rotz(AngRange1_H(i))*roty(AngRange2_H(i))*rotz(AngRange3_H(i));

        % Craig Method with ArcTan2
        [z_2023(i),y_2023(i),za_2023(i)]=rotzyz2023(RZYZ(:,:,i));

        % Original Method
        [z_orig(i),y_orig(i),za_orig(i)]=rotzyz(RZYZ(:,:,i));

        %Internal Matlab Function - (only used with supported sequences)
        [Angs_mat(i,1:3)]=rotm2eul(RZYZ(:,:,i),'ZYZ');

    end

    %% Checking Input with Computed Angles:

    % Craig Method Check %
    % Z
    Check_CraigZ = AngRange1_H(:) == rad2deg(z_2023(:));

    % Y
    Check_CraigY = AngRange2_H(:) == rad2deg(y_2023(:));

    % Za
    Check_CraigZ2 = AngRange3_H(:) == rad2deg(za_2023(:));

    % Original Method Check %
    
    % Z
    Check_OrigZ = AngRange1_H(:) == rad2deg(z_orig(:));

    % Y
    Check_OrigY = AngRange2_H(:) == rad2deg(y_orig(:));

    % Za
    Check_OrigZ2 = AngRange3_H(:) == rad2deg(za_orig(:));

    % Euler Method Check %
    % Z
    Check_EulZ = AngRange1_H(:) == rad2deg(z_orig(:));

    % Y
    Check_EulY = AngRange2_H(:) == rad2deg(y_orig(:));

    % Za
    Check_EulZ2 = AngRange3_H(:) == rad2deg(za_orig(:));

   

end


end
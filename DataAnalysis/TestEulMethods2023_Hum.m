% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% HUMERUS:
% Segment = 'Humerus'; *USE ROTM2EUL TO SATISFY ANGLE RANGES REQUIRED
%%
% AngRange1_H = -45:134;
% AngRange2_H = -179:0;
% AngRange3_H = -35:144;
%%

function [CraigCheck,OrigCheck,Check_Mat] = TestEulMethods2023_Hum(AngRange1_H,AngRange2_H,AngRange3_H,Segment)

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
    Check_CraigZ = AngRange1_H(:) == round(z_2023(:)); % off by pi

    % Y
    Check_CraigY = AngRange2_H(:) == round(y_2023(:)); % gives negative version of true angle

    % Za
    Check_CraigZ2 = AngRange3_H(:) == round(za_2023(:)); %off by pi

    CraigCheck = [Check_CraigZ,Check_CraigY,Check_CraigZ2];
   
    % Original Method Check % - From Calc Euler Angles
    
    % Z
    Check_OrigZ = AngRange1_H(:) == round(z_orig(:)); % off by pi

    % Y
    Check_OrigY = AngRange2_H(:) == round(y_orig(:)); % gives negative version of true angle

    % Za
    Check_OrigZ2 = AngRange3_H(:) == round(za_orig(:)); % off by pi

    OrigCheck = [Check_OrigZ,Check_OrigY,Check_OrigZ2];

    % Matlab Method Check
 
    % Z
    Check_MatZ = AngRange1_H' == round(Angs_mat(:,1));  %fails at last index - rest correct

    % Y
    Check_MatY = AngRange2_H' == round(Angs_mat(:,2)); % all true
    % Za
    Check_MatZ2 = AngRange3_H' == round(Angs_mat(:,3)); %fails at last index- rest correct

    Check_Mat = [Check_MatZ,Check_MatY,Check_MatZ2];
end


end
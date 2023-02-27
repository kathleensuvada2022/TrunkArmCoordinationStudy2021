% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% Scapula:
% Segment = 'Scap'; 
% *USE ROTM2EUL TO SATISFY ANGLE RANGES REQUIRED
%%
AngRange1_S = -30:30;  
AngRange2_S = -30:30;
AngRange3_S = -30:30;
%%

function [OrigCheck,Check_Mat] = TestEulMethods2023_Scap(AngRange1_S,AngRange2_S,AngRange3_S,Segment)

if(strcmp(Segment,'Scap'))

    RZYX = zeros(3,3,length(AngRange1_S));

    z_orig = zeros(1,length(AngRange1_S));
    y_orig = zeros(1,length(AngRange1_S));
    x_orig = zeros(1,length(AngRange1_S));

    Angs_mat = zeros(length(AngRange1_S),3);

    for i = 1:length(AngRange1_S)
        RZYX(:,:,i) = rotz(AngRange1_S(i))*roty(AngRange2_S(i))*rotx(AngRange3_S(i));

        % Original
        [z_orig(i),y_orig(i),x_orig(i)]=rotzyx(RZYX(:,:,i)); 


        %Internal Matlab Function - (only used with supported sequences)
        [Angs_mat(i,1:3)]=rotm2eul(RZYX(:,:,i),'ZYX'); %works same as above

    end


    x_orig = rad2deg(x_orig);
    y_orig = rad2deg(y_orig);
    z_orig = rad2deg(z_orig);

    Angs_mat = rad2deg(Angs_mat);

    %% Checking Input with Computed Angles:


    % Original Method Check %

    % Z
    Check_OrigZ = AngRange1_S(:) == round(z_orig(:)); 

    % Y
    Check_OrigY = AngRange2_S(:) == round(y_orig(:));

    % X
    Check_OrigX = AngRange3_S(:) == round(x_orig(:)); 
    
    OrigCheck = [Check_OrigZ,Check_OrigY,Check_OrigX]; %Works always

    % Matlab Method Check
 
    % Z
    Check_MatZ = AngRange1_S' == round(Angs_mat(:,1));  

    % Y
    Check_MatY = AngRange2_S' == round(Angs_mat(:,2)); 
   
    % X
    Check_MatX = AngRange3_S' == round(Angs_mat(:,3)); 
   
    Check_Mat = [Check_MatZ,Check_MatY,Check_MatX]; %Works always

end


end
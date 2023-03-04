% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% TRUNK:
% Segment = 'Trunk'; 

%%
% AngRange1_T = -45:45;  
% AngRange2_T = -30:60;
% AngRange3_T = -60:30;
%%

function [OrigCheck,DutchMat,Perm_Mat] = TestEulMethods2023_Trunk(AngRange1_T,AngRange2_T,AngRange3_T)
%% Initializing Variables 

% Rotation matrix with all angle permutations
    RXZY = zeros(3,3,length(AngRange1_T));

    % Angles for Dutch Method
    x_orig = zeros(1,length(AngRange1_T));
    z_orig = zeros(1,length(AngRange1_T));
    y_orig = zeros(1,length(AngRange1_T));
    %% Creating Matrix with all Permutations of 3 Angles
Perm_Mat = combvec(AngRange1_T,AngRange2_T,AngRange3_T);
%% Creating Rotation Matrix with Known Angles and Computer Euler Angles 

    for i = 1:length(Perm_Mat)
        RXZY = rotx(Perm_Mat(1,i))*rotz(Perm_Mat(2,i))*roty(Perm_Mat(3,i));
i
        % Original
        [x_orig(i),z_orig(i),y_orig(i)]=rotxzy(RXZY); 

    end


    x_orig = rad2deg(x_orig);
    z_orig = rad2deg(z_orig);
    y_orig = rad2deg(y_orig);



    %% Checking Input with Computed Angles:


    % Original Method Check %

    % X
    Check_OrigX = Perm_Mat(1,:)' == round(x_orig(:)); 

    % Z
    Check_OrigZ = Perm_Mat(2,:)' == round(z_orig(:));

    % Y
    Check_OrigY = Perm_Mat(3,:)' == round(y_orig(:)); 
    
    OrigCheck = [Check_OrigX,Check_OrigZ,Check_OrigY];


    DutchMat = [x_orig;z_orig;y_orig]';



end
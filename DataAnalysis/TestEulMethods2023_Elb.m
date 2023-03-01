% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

%%%%%% USE THIS!!!!!%%%%%%%

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% ELBOW:
% Joint = 'Elbow'; 

%%
% AngRange1_E = 0: 90;  %--> need 180 - angle for elbow flexion/extension
% AngRange2_E = -10:80;
% AngRange3_E = -15:75;%note this is not a real angle

%%

function [OrigCheck,Check_Mat,FinalCheck] = TestEulMethods2023_Elb(AngRange1_E,AngRange2_E,AngRange3_E)

Perm_Mat = combvec(AngRange1_E,AngRange2_E,AngRange3_E);
 
% if(strcmp(Joint,'Elbow'))

    %% Initializing Variables 

    %Rotation matrix with all angle permutations
    RXYZ = zeros(3,3,length(AngRange1_E));

    % Angles for Dutch Method
    x_orig = zeros(1,length(AngRange1_E));
    y_orig = zeros(1,length(AngRange1_E));
    z_orig = zeros(1,length(AngRange1_E));

    % For Internal Matlab Function
    Angs_mat = zeros(length(Perm_Mat),3);
%% Creating Rotation Matrix with Known Angles and Computer Euler Angles 
    for i = 1:length(Perm_Mat)
        RXYZ = rotx(Perm_Mat(1,i))*roty(Perm_Mat(2,i))*rotz(Perm_Mat(3,i));
    i
        % Dutch
        [x_orig(i),y_orig(i),z_orig(i)]=rotxyz(RXYZ); 
    
       %Internal Matlab Function - (only used with supported sequences)
      [Angs_mat(i,:)]=rotm2eul(RXYZ,'XYZ'); 
    end
    
    %Converting to Degrees
    x_orig = rad2deg(x_orig);
    y_orig = rad2deg(y_orig);
    z_orig = rad2deg(z_orig);

    Angs_mat = rad2deg(Angs_mat);

    %% Checking Input with Computed Angles from Functions:


    % Dutch Method Check %

    % X
    Check_OrigX = Perm_Mat(1,:)' == round(x_orig(:)); 

    % Y
    Check_OrigY = Perm_Mat(2,:)' == round(y_orig(:));

    % Z
    Check_OrigZ = Perm_Mat(3,:)' == round(z_orig(:)); 
    
    OrigCheck = [Check_OrigX,Check_OrigY,Check_OrigZ]; % Testing if Dutch Method Matches Input Angles
    
    Dutch_Mat = [x_orig;y_orig;z_orig]';

    % Matlab Method Check
    % X
    Check_MatX = Perm_Mat(1,:)' == round(Angs_mat(:,1));  

    % Y
    Check_MatY = Perm_Mat(2,:)' == round(Angs_mat(:,2)); 
   
    % Z
    Check_MatZ = Perm_Mat(3,:)' == round(Angs_mat(:,3)); 
   
    Check_Mat = [Check_MatX,Check_MatY,Check_MatZ]; % Testing if Matlab Method Matches Input Angles

    %Matlab == Dutch Check

    FinalCheck = round(Angs_mat) == round(Dutch_Mat); %Testing if Dutch Method and Matlab Method Yield the Same
% end


end
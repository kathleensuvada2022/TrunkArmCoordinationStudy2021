% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% Scapula:
% Segment = 'Scap';
% *USE ROTM2EUL TO SATISFY ANGLE RANGES REQUIRED
%%
% AngRange1_S = -30:30;
% AngRange2_S = -30:30;
% AngRange3_S = -30:30;
%%

function [OrigCheck,Dutch_Mat,Check_Mat,Angs_mat] = TestEulMethods2023_Scap(AngRange1_S,AngRange2_S,AngRange3_S)
%% Initializing Variables

% Rotation matrix with all angle permutations
RZYX = zeros(3,3,length(AngRange1_S));

% Angles for Dutch Method
z_orig = zeros(1,length(AngRange1_S));
y_orig = zeros(1,length(AngRange1_S));
x_orig = zeros(1,length(AngRange1_S));

% Angles for Matlab Function
Angs_mat = zeros(length(AngRange1_S),3);
%% Creating Matrix with all Permutations of 3 Angles
Perm_Mat = combvec(AngRange1_S,AngRange2_S,AngRange3_S);
%%
for i = 1:length(Perm_Mat)
    RZYX = rotz(Perm_Mat(1,i))*roty(Perm_Mat(2,i))*rotx(Perm_Mat(3,i));

    % Original
    [z_orig(i),y_orig(i),x_orig(i)]=rotzyx(RZYX);
    i

    %Internal Matlab Function - (only used with supported sequences)
    [Angs_mat(i,1:3)]=rotm2eul(RZYX,'ZYX'); %works same as above

end


x_orig = rad2deg(x_orig);
y_orig = rad2deg(y_orig);
z_orig = rad2deg(z_orig);

Angs_mat = rad2deg(Angs_mat);

%% Checking Input with Computed Angles:


% Original Method Check %

% Z
Check_OrigZ = Perm_Mat(1,:)' == round(z_orig(:));

% Y
Check_OrigY = Perm_Mat(2,:)' == round(y_orig(:));

% X
Check_OrigX = Perm_Mat(3,:)' == round(x_orig(:));

OrigCheck = [Check_OrigZ,Check_OrigY,Check_OrigX]; %Works always

Dutch_Mat = [x_orig;y_orig;z_orig]';


% Matlab Method Check

% Z
Check_MatZ = Perm_Mat(1,:)' == round(Angs_mat(:,1));

% Y
Check_MatY = Perm_Mat(2,:)' == round(Angs_mat(:,2));

% X
Check_MatX = Perm_Mat(3,:)' == round(Angs_mat(:,3));

Check_Mat = [Check_MatZ,Check_MatY,Check_MatX]; %Works always



end
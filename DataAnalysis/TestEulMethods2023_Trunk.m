% K. Suvada 2023- Trouble Shooting Euler Angle Singularities

% Test the ranges required of segments of body. Which method
% works and how to modify st always yield proper angle.

% TRUNK:
% Segment = 'Trunk'; 

%%
AngRange1_T = -45:45;  
AngRange2_T = -30:60;
AngRange3_T = -60:30;
%%

function OrigCheck = TestEulMethods2023_Trunk(AngRange1_T,AngRange2_T,AngRange3_T,Segment)

if(strcmp(Segment,'Trunk'))

    RXZY = zeros(3,3,length(AngRange1_T));

    x_orig = zeros(1,length(AngRange1_T));
    z_orig = zeros(1,length(AngRange1_T));
    y_orig = zeros(1,length(AngRange1_T));


    for i = 1:length(AngRange1_T)
        RXZY(:,:,i) = rotx(AngRange1_T(i))*rotz(AngRange2_T(i))*roty(AngRange3_T(i));

        % Original
        [x_orig(i),z_orig(i),y_orig(i)]=rotxzy(RXZY(:,:,i)); 

    end


    x_orig = rad2deg(x_orig);
    z_orig = rad2deg(z_orig);
    y_orig = rad2deg(y_orig);



    %% Checking Input with Computed Angles:


    % Original Method Check %

    % X
    Check_OrigX = AngRange1_T(:) == round(x_orig(:)); 

    % Z
    Check_OrigZ = AngRange2_T(:) == round(z_orig(:));

    % Y
    Check_OrigY = AngRange3_T(:) == round(y_orig(:)); 
    
    OrigCheck = [Check_OrigX,Check_OrigZ,Check_OrigY]; %All correct



end


end
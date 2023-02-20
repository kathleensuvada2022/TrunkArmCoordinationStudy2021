%% K.Suvada 2023- redefined using ArcTan2 instead of Dutch Definitions

%  Edited original 'rotYZY' for Kacey's Analysis.
%  Coordinate system definitions swapped y and z from original analysis. 

%  Based on Craig Definitions and worked out Solution for 'ZYZ' sequence 
%  of rotations (page 50).

% Only works when 0=<Beta=<180


function [z,y,za]=rotzyz2023(r)

% Alpha corresponds to Z, Beta corresponds to Y, and Gamma corresponds to
% Za. 
y = atan2(sqrt(r(3,1)^2+r(3,2)^2),r(3,3)); % Beta
z = atan2(r(2,3)/sin(y),r(1,3)/sin(y)); % Alpha 
za = atan2(r(3,2)/sin(y),-r(3,1)/sin(y)); % Gamma



end

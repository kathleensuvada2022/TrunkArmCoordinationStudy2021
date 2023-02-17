%% K.Suvada 2023- redefined using ArcTan2 instead of Dutch Definitions

%  Edited original 'rotYZY' for Kacey's Analysis.
%  Coordinate system definitions swapped y and z from original analysis. 



function [z,y,za]=rotzyz2023(r)

% Alpha corresponds to Z, Beta corresponds to Y, and Gamma corresponds to
% Za. 

z = atan2(r(2,3),r(1,3));
y1 = acos(r(3,3))


szsy1 = r(2,3);
sy1= r(2,3)/sin(z);

za = atan2(r(3,2),-r(3,1));

if y1 >0 && y1<pi
     y = y1;

elseif y1 > pi && y1<2*pi
    y = -y1;
    z= pi+z;
    za = pi+ za;
end 

% if sy1 >0 && y1<pi
%      y = y1;
% 
% elseif y1 >pi && y1<2*pi
%     y = -y1;
%     z= pi+z;
%     za = pi+ za;
% end 


end

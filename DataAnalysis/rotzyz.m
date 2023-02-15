%% K.Suvada 2021-2023

%  Edited original 'rotYZY' for Kacey's Analysis.
%  Coordinate system definitions swapped y and z from original analysis. 



function [z,y,za]=rotzyz(r)
% z1 = acos(r(2,2));

% K. Suvada 2023: acos takes care of angles larger than 180. Gives 360-abs(Beta)

% K. Suvada 2023: Most likely will NOT go into the if statement BC of this. 

y1 = acos(r(3,3)); % Y1= Y Beta  Z gamma za gamma_prime

% if (z1==0) then
if (y1==0) then
   %y=acos(r(1,1));
    z=acos(r(1,1));
   %z=z1;
    y=y1;
   %ya=0.0;
    za=0.0;
	return
end
%sy = r(3,2)/sin(z1);
sz = r(2,3)/sin(y1);
%cy = -r(1,2)/sin(z1);
cz = r(1,3)/sin(y1);
%y1 = atan2(sy,cy);
z1 = atan2(sz,cz);
%sya = r(2,3)/sin(z1);

sza = r(3,2)/sin(y1); % za = gamma_prime
%cya = r(2,1)/sin(z1);
cza = -r(3,1)/sin(y1);
%ya1 = atan2(sya,cya);
za1 = atan2(sza,cza);
%z2 = -z1;

y2 = -y1;% Moves to quadrants I or II 
%sy = r(3,2)/sin(z2);
sz = r(2,3)/sin(y2);
%cy = -r(1,2)/sin(z2);
cz = r(1,3)/sin(y2);
%y2 = atan2(sy,cy);
z2 = atan2(sz,cz);
%sya = r(2,3)/sin(z2);
sza = r(3,2)/sin(y2);
%cya = r(2,1)/sin(z2);
cza = -r(3,1)/sin(y2);
%ya2 = atan2(sya,cya);
za2 = atan2(sza,cza);


%if (0 <= z1 & z1 <= pi)
if (0 <= y1 & y1 <= pi) 

  % y = y1;
  z = z1;
   %z = z1;
   y = y1;
  % ya = ya1;
  za = za1;
else
   %y = y2;
   z = z2;
   %z = z2;
   y = y2;
   %ya = ya2;
   za = za2;
end
% disp(rad2deg([z1 y1 za1;z2 y2 za2]))
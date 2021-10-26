   function [y,x,z]= rotyxz(R)
% programma voor y,x,z uit R
x1 = asin(-R(2,3));
sy = R(1,3)/cos(x1);
cy = R(3,3)/cos(x1);
y1 = atan2(sy,cy);
sz = R(2,1)/cos(x1);
cz = R(2,2)/cos(x1);
z1 = atan2(sz,cz);
if x1>=0
  x2 = pi - x1;
else
  x2 = -pi - x1;
end
sy = R(1,3)/cos(x2);
cy = R(3,3)/cos(x2);
y2 = atan2(sy,cy);
sz = R(2,1)/cos(x2);
cz = R(2,2)/cos(x2);
z2 = atan2(sz,cz);
if (-pi/2 <= x1 & x1 <= pi/2)
  y=y1;
  z=z1;
  x=x1;
else
  y=y2;
  z=z2;
  x=x2;
end

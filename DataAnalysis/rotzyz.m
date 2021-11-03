function [z,y,za]=rotzyz(r)
%
%     programma voor het berekenen van de rotaties rond achtereenvolgens
%     de y-, z- en lokale y-as uit de rotatiematrix r. er zijn twee 
%     oplossingen: de oplossing met de kleinste rotaties wordt uitgekozen.
% Kacey to do: 
% swap y and zs in code

% New Outputs :z,y,za
z1 = acos(r(2,2));
if (z1==0) then
   y=acos(r(1,1));
	z=z1;
	ya=0.0;
	return
end
sy = r(3,2)/sin(z1);
cy = -r(1,2)/sin(z1);
y1 = atan2(sy,cy);
sya = r(2,3)/sin(z1);
cya = r(2,1)/sin(z1);
ya1 = atan2(sya,cya);
z2 = -z1;
sy = r(3,2)/sin(z2);
cy = -r(1,2)/sin(z2);
y2 = atan2(sy,cy);
sya = r(2,3)/sin(z2);
cya = r(2,1)/sin(z2);
ya2 = atan2(sya,cya);
if (0 <= z1 & z1 <= pi)
   y = y1;
   z = z1;
   ya = ya1;
else
   y = y2;
   z = z2;
   ya = ya2;
end

%TRIANGLE function- K. Suvada. Winter 2022/2023

% Calculates angles of triangle given sides.
% Input: s1,s2,s3 sides of triangle.
% Output: Angles ang1,ang2,ang3 corresponding to sides 1,2,3 of triangle
% respectively. Angles are in degrees.



%%
function [ang1 ang2 ang3]=triangle(s1,s2,s3)

% Output is in degrees
ang1=acosd((s2^2 + s3^2 - s1^2)/(2*s2*s3));
ang2=acosd((s3^2 + s1^2 - s2^2)/(2*s3*s1));
ang3=acosd((s1^2 + s2^2 - s3^2)/(2*s1*s2));
end



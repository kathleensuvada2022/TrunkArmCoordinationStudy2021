function [ang1 ang2 ang3]=triangle(s1,s2,s3)
%TRIANGLE calculates the degrees of all angles given the length of all
%sides

% Output is in degrees
ang1=acosd((s2^2 + s3^2 - s1^2)/(2*s2*s3));
ang2=acosd((s3^2 + s1^2 - s2^2)/(2*s3*s1));
ang3=acosd((s1^2 + s2^2 - s3^2)/(2*s1*s2));
end



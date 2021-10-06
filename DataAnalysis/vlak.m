
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Function to calculate the parameters of a plane in R3
% %              Ax + By + Cz + D = 0
% % using matrix notation [x y z 1]*[A B C D]' = 0
% % using the technique tlls
% % input: m x 3 matrix with points; output: A,B,C and D

% n vector: vector normal to the plane and describes desired plane
% KACEY 10.4.21 what is DATA? just desired BLS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A,DATAa,nvector,e]=vlak(DATA)
% disp('just entered the vlak program');
[m,n]      = size(DATA);
[Ubef,Sbef,Vbef]    = svd(DATA);
Ubef*Sbef*Vbef';
DATA       = [DATA 1000000*ones(m,1)];
[U,S,V]    = svd(DATA);
S(n,n+1) = 0;
% S(n+1,n+1) = 0; %SABEEN CHANGED FIRST ONE FROM N+1 TO N, ASK AMA

DATAa = U*S*V';
A          = V(:,n+1)/V(n+1,n+1);
DATAa      = DATAa(:,1:3);
DATA       = DATA(:,1:3);
e          = sqrt(sum((DATA-DATAa)'.^2))';
A          = [A(1:3)/1000000;1];
nvector    = A(1:3)/norm(A(1:3));
end

  function [A,DATAa,nvector,e]=vlak(DATA)
% function [A,DATAa,nvector,e]=vlak(DATA)
% programma voor het berekenen van de parameters van een vlak in R3
%              Ax + By + Cz + D = 0
% via de matrix-notatie [x y z 1]*[A B C D]' = 0
% gebruik makend van de tlls-techniek
% invoer: m x 3 matrix van punten; uitvoer: A,B,C en D

[m,n]      = size(DATA);
DATA       = [DATA 1000000*ones(m,1)];
[U,S,V]    = svd(DATA);
S(n+1,n+1) = 0;
DATAa      = U*S*V';
A          = V(:,n+1)/V(n+1,n+1);
DATAa      = DATAa(:,1:3);
DATA       = DATA(:,1:3);
e          = sqrt(sum((DATA-DATAa)'.^2))';
A          = [A(1:3)/1000000;1];
nvector    = A(1:3)/norm(A(1:3));

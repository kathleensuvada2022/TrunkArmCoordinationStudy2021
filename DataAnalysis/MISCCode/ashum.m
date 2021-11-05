function [Hum_CS,BLs_lcs,BLnames] =  ashum(blmat,GH,bonylmrks)
%Kacey 10.2021 - original defintions
%Grabbing medial and laterial epi from matrix and matching to EM and EL
Emidx = find(bonylmrks=='EM');[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
BLnames = ["EM","EL","GH"];
BLs_lcs ={EM,EL,GH};
% 
% % Estimate GH joint location
% GH=CalculateGH(blmat(:,3:end));
% Compute the local axes
H_mid=(EM(1:3)+EL(1:3))/2;
y = (GH(1:3)-H_mid) / norm(GH(1:3)-H_mid);
xh= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3));
    
z =cross(xh,y);z=z/norm(z);
x =cross(y,z);
% h=[x,y,z];
h = [x;y;z]';

h = [h;0 0 0];

Origin = [GH(1:3) 1]';

%T of Humerus in marker CS
Hum_CS = [h Origin];
end

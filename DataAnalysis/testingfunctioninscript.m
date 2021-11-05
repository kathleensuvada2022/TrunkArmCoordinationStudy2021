% [Hum_CS,BLs_lcs_h,BLnames_h] =  ashum_orig(blmat,GH,bonylmrks);
% 
% 
% 
% 
% 
% function [Hum_CS,BLs_lcs,BLnames] =  ashum(blmat,GH,bonylmrks)
% %Kacey 10.2021
% %Grabbing medial and laterial epi from matrix and matching to EM and EL
% Emidx = find(bonylmrks=='EM');[EM,EL]=deal(blmat(Emidx,:),blmat(Emidx+1,:));
% BLnames = ["EM","EL","GH"];
% BLs_lcs ={EM,EL,GH};
% % 
% % % Estimate GH joint location
% % GH=CalculateGH(blmat(:,3:end));
% % Compute the local axes
% H_mid=(EM(1:3)+EL(1:3))/2;
% y = (GH-H_mid) / norm(GH-H_mid);
% xh= (EL(1:3)-EM(1:3))/norm(EL(1:3)-EM(1:3));
%     
% z =cross(xh,y);z=z/norm(z);
% x =cross(y,z);
% % h=[x,y,z];
% h = [x;y;z]';
% 
% h = [h;0 0 0];
% 
% Origin = [GH(1:3) 1]';
% 
% %T of Humerus in marker CS
% Hum_CS = [h Origin];
% end
%%
x = 1:10;
n = length(x);
avg = mymean(x,n);
med = mymedian(x,n);
%%
function a = mymean(v,n)
% MYMEAN Local function that calculates mean of array.

    a = sum(v)/n;
end

function m = mymedian(v,n)
% MYMEDIAN Local function that calculates median of array.

    w = sort(v);
    if rem(n,2) == 1
        m = w((n + 1)/2);
    else
        m = (w(n/2) + w(n/2 + 1))/2;
    end
end
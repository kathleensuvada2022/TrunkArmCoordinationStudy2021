function[AS]=asfunc(X,arm)
% Usage:	[AS]=asfuncam(X)
% function adapted from as_func.m for data recorded by
% Ana Maria Acosta (am) on JHJ.
%
% bepalen van lokale positiematrices
% X  = [4*12]_matrix met botcoordinaten
% AS = [3,12]_matrix met positie matrices
% August 31, 1999 Ana Maria Acosta
% Changed the definition of the coordinate frame for the scapula,
% replacing AC with AA.

if nargin<2, arm='right'; end
[m,n]=size(X);
Nr=m/4;
AS=[];

for i=1:Nr
   im1=(i-1)*4;
   t=asthorho(X(im1+1,1:3)',X(im1+2,1:3)',X(im1+3,1:3)',X(im1+4,1:3)');
   if strcmp(arm,'left'), t=roty(pi)*t; end
%    c7=t'*(X(im1+3,1:3)-X(im1+1,1:3))';
%    if (strcmp(arm,'right') & c7(3)<0)|(strcmp(arm,'left') & c7(3)>0), t(:,[1 3])=-t(:,[1 3]); end

   c=asclav(X(im1+1,4:6)',X(im1+2,4:6)',t(:,2));  % local Yt axis thorax!
   s=asscap(X(im1+2,7:9)',X(im1+3,7:9)',X(im1+4,7:9)'); % AA
   %s=asscap(X(im1+1,7:9)',X(im1+3,7:9)',X(im1+4,7:9)'); % AC
   %s=p_asscap(X(im1+2,7:9)',X(im1+3,7:9)',X(im1+4,7:9)'); % AA
   h=ashumn(X(im1+1,10:12)',X(im1+2,10:12)',X(im1+3,10:12)');
   f=asfore(X(im1+1,13:15)',X(im1+2,13:15)',X(im1+3,13:15)'); % Using OL
%    f=asfore2(X(im1+1,13:15)',X(im1+2,13:15)',X(im1+1,10:12)',X(im1+2,10:12)'); % Using mid Epi


   as=[t,c,s,h,f];
%    if strcmp(arm,'left'), as(:,4:end)=roty(pi)*as(:,4:end); end
   AS=[AS;as];
end

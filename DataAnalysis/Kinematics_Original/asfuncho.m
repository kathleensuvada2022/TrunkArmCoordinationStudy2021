   function[AS]=asfuncho(X)
%  function[AS]=asfuncho(X)
%  function adapted from as_func.m for data recorded by
%  Hans Oranje (ho)
%
%    bepalen van lokale positiematrices
%    X  = [4*12]_matrix met botcoordinaten
%    AS = [3,12]_matrix met positie matrices
    
    [m,n]=size(X);
    Nr=m/4;
    AS=[];
  
    for i=1:Nr
      im1=(i-1)*4;
      t=asthorho(X(im1+1,1:3)',X(im1+2,1:3)',X(im1+3,1:3)',X(im1+4,1:3)');
      c=asclav(X(im1+1,4:6)',X(im1+2,4:6)',t(:,2));  % local Yt axis thorax !
      s=asscap(X(im1+1,7:9)',X(im1+3,7:9)',X(im1+4,7:9)'); % AC
%      s=p_asscap(X(im1+2,7:9)',X(im1+3,7:9)',X(im1+4,7:9)'); % AA
      h=ashumn(X(im1+1,10:12)',X(im1+2,10:12)',X(im1+3,10:12)','r');
      as=[t,c,s,h];
      AS=[AS;as];
    end

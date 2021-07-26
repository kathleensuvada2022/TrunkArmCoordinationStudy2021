function out=smo(in,numtimes)
%3-point smoothing function
%Uses 2-sided filter to avoid phase shifting

if nargin ==1 numtimes=1; end

[nr,nc]=size(in);
if nc>nr in=in';[nr,nc]=size(in);end

out=in;

for j=1:nc
   for i=1:numtimes
      out(:,j)=filter22([0.25 0.5 0.25],out(:,j),2);
   end
end

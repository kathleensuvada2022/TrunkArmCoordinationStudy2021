function [y,ty]=Reem_resampledata(x,t,fs,fsnew)
% compute slope and offset (y = a1 x + a2)
[nr,nc]=size(x);
for i=1:nc
    a(1) = (x(end,i)-x(1,i)) / (t(end)-t(1));
    a(2) = x(1,i);
    
    % detrend the signal
    xdetrend = x(:,i) - polyval(a,t);
    [ydetrend,ty] = resample(xdetrend,t,fsnew,10,fs);
    
    if i==1, y=zeros(length(ty),nc); end
    
    y(:,i) = ydetrend + polyval(a,ty);
end
end
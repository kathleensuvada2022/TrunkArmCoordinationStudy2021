function p=gethandpos(x,th,exp)
% x - ACT3D end effector position
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - hand position column vector

[m,n]=size(x);
for i=1:m
    if strcmp(exp.arm,'right')
        p(i,:)=x(i,:)+transpose(rotz(th(i)+pi/2)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]');
        %     p=x(:)-rotz(th-3*pi/2)*[0 (exp.e2hLength-exp.ee2eLength)/100 0]';
    else
        p(i,:)=x(i,:)+transpose(rotz(th(i)-pi/2)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]');
        %     p=x(:)-rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
    end
end
% p=p-exp.origin; % Correct for the origin once it's set


end

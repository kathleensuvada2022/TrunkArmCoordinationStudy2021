
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to compute the segment/joint Euler Angles based on the input
% rotation matrices for the segment/joints and the desired order.
% Note that angles are output in radians.
% The rotation matrices are decomposed in the Euler angles around the global
% coordinate system
% alpha : first rotation
% beta  : second rotation
% gamma : third rotation
%
% The possible order of rotations are:
% XYZ    (thor)
% XZY    (fore)
% YZX    (clav,scap)
% ZYX
% ZXY
% YZY    (hum)
% Based on rotbones.m, rotjoint.m and roteuler.m from the DESM.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function abg = CalcEulerAng(A,B,Rorder)
function ANGg = CalcEulerAng(R,Rorder,val)
% R: rotations from B to A LCS
%       B*R = A  -> R = B'*A
% A
% B
% R = B'*A;  % B to A

% Determine the Euler angles alpha, beta, gamma (abg).
switch Rorder
    case 'XYZ'
        [a,b,g] = rotxyz(R);  % For KACEY NEED XYZ NOW Rorder='XYZ'
    case 'XZY'
        [a,b,g] = rotxzy(R);
    case 'YZX'
        [a,b,g] = rotyzx(R);
    case 'ZYX'
        [a,b,g] = rotzyx(R);
    case 'ZXY'
        [a,b,g] = rotzxy(R);
    case 'YZY'
        [a,b,g] = rotyzy(R);
end

ANGr = [a,b,g];
% ANGr = abg;
ANGg = ANGr*(180/pi);
ANGg = ANGg';

if val == 1
    disp('ANGg: ');
    disp(ANGg);
end

end
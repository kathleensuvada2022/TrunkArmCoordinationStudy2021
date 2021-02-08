%% Quat2Tform by hand 
% KCS Feb 2021
% Created for Matlab 2014b since Quaternion conversion to Homogeneous
% Transform doesn't exist in 2014

function H = Quaternion2tForm(q)

%% From quat2rotm
% Validate the quaternions
% q = robotics.internal.validation.validateQuaternion(q, 'quat2rotm', 'q');

% Normalize and transpose the quaternions
q = robotics.internal.normalizeRows(q).';

% Reshape the quaternions in the depth dimension
q2 = reshape(q,[4 1 size(q,2)]);

s = q2(1,1,:);
x = q2(2,1,:);
y = q2(3,1,:);
z = q2(4,1,:);

% Explicitly define concatenation dimension for codegen
tempR = cat(1, 1 - 2*(y.^2 + z.^2),   2*(x.*y - s.*z),   2*(x.*z + s.*y),...
2*(x.*y + s.*z), 1 - 2*(x.^2 + z.^2),   2*(y.*z - s.*x),...
2*(x.*z - s.*y),   2*(y.*z + s.*x), 1 - 2*(x.^2 + y.^2) );

R = reshape(tempR, [3, 3, length(s)]);
R = permute(R, [2 1 3]);

%% From rotmto tfrorm

% Ortho-normality is not tested, since this validation is expensive
robotics.internal.validation.validateRotationMatrix(R, 'rotm2tform', 'R');

numMats = size(R,3);

% The rotational components of the homogeneous transformation matrix
% are located in elements H(1:3,1:3).
H = zeros(4,4,numMats,'like',R);
H(1:3,1:3,:) = R;
H(4,4,:) = ones(1,1,numMats,'like',R);

end 
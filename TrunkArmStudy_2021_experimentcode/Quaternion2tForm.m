%% Quat2Tform by hand 
% KCS Feb 2021
% Created for Matlab 2014b since Quaternion conversion to Homogeneous
% Transform doesn't exist in 2014


% check which functions can be removed 

function H = Quaternion2tForm(q)

%% From quat2rotm
% Validate the quaternions
 q = robotics.internal.validation.validateQuaternion(q, 'quat2rotm', 'q')
   
    function numericMatrix = validateQuaternion(q, funcname, varname)
%This function is for internal use only. It may be removed in the future.

%VALIDATEQUATERNION Validate quaternion and return it as N-by-4 numeric matrix
%   NUMERICMATRIX = VALIDATEQUATERNION(Q, FUNCNAME, VARNAME) validates
%   whether the input Q represents a valid quaternion and returns the input
%   quaternion, Q, as N-by-4 numeric matrix, NUMERICMATRIX, where each row
%   is one quaternion. The input quaternion, Q, is expected to be either
%   N-by-4 numeric matrix of row quaternions, or N-by-1 or 1-by-N vector of
%   QUATERNION objects. FUNC_NAME and VAR_NAME are used in
%   VALIDATEATTRIBUTES to construct the error id and message.

%   Copyright 2017-2019 The MathWorks, Inc.

%#codegen

if (isa(q, 'quaternion'))
        
    % Extract quaternion parts
    [w,x,y,z] = parts(q);
    
    % Validate that the input quaternion is non-empty and that the input is
    % a vector. The validateattributes function is not supported for
    % quaternion input. Therefore, the validateattributes is called on each
    % part separately.
    validateattributes(w, {'numeric'}, {'nonempty', 'vector'}, funcname, varname);
    validateattributes(x, {'numeric'}, {'nonempty', 'vector'}, funcname, varname);
    validateattributes(y, {'numeric'}, {'nonempty', 'vector'}, funcname, varname);
    validateattributes(z, {'numeric'}, {'nonempty', 'vector'}, funcname, varname);
    
    % If the quaternion input is a row vector, transpose it to get a column
    % vector
    if (isrow(w))
        w = w';
        x = x';
        y = y';
        z = z';
    end
    
    % Save quaternion parts as N-by-4 numeric matrix
    numericMatrix = [w,x,y,z];
    
else
    
    % Validate that the input is N-by-4 numeric matrix
    robotics.internal.validation.validateNumericMatrix(q, funcname, varname, ...
        'ncols', 4);
    
    % Return the input as is
    numericMatrix = q;
    
end

end

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
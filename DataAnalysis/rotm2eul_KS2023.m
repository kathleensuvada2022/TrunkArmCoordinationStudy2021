function [eul, eulAlt] = rotm2eul_KS2023( R, varargin )

%% January 2023

% K. Suvada: Appended Internal Matlab Function to add addition rotation
% sequences

% Add 'XZY' rotation sequence
%%
%ROTM2EUL Convert rotation matrix to Euler angles
%   EUL = ROTM2EUL(R) converts a 3D rotation matrix, R, into the corresponding
%   Euler angles, EUL. R is an 3-by-3-by-N matrix containing N rotation
%   matrices. The output, EUL, is an N-by-3 matrix of Euler rotation angles.
%   Rotation angles are in radians.
%
%   EUL = ROTM2EUL(R, SEQ) converts a rotation matrix into Euler angles.
%   The Euler angles are specified by the body-fixed (intrinsic) axis rotation
%   sequence, SEQ.
%
%   [EUL, EULALT] = ROTM2EUL(___) also returns a second output, EULALT, that 
%   is a different set of euler angles that represents the same rotation.
% 
%   The default rotation sequence is 'ZYX', where the order of rotation
%   angles is Z Axis Rotation, Y Axis Rotation, and X Axis Rotation.
%
%   The following rotation sequences, SEQ, are supported: 'ZYX', 'ZYZ', and
%   'XYZ'.
%
%   Example:
%      % Calculates Euler angles for a rotation matrix
%      % By default, the ZYX axis order will be used.
%      R = [0 0 1; 0 1 0; -1 0 0];
%      eul = rotm2eul(R)
%
%      % Calculate the Euler angles for a ZYZ rotation
%      eulZYZ = rotm2eul(R, 'ZYZ')
%
%   See also eul2rotm

%   Copyright 2014-2020 The MathWorks, Inc.

%#codegen

%robotics.internal.validation.validateRotationMatrix(R, 'rotm2eul', 'R');
%seq = robotics.internal.validation.validateEulerSequence(varargin{:});

% Pre-allocate output
eul = zeros(size(R,3), 3 , 'like', R); %#ok<PREALL>
eulShaped = zeros(1, 3, size(R,3), 'like', R);

% The parsed sequence will be in all upper-case letters and validated
switch seq
    case 'ZYX'
        % Handle Z-Y-X rotation order        
        eulShaped = calculateEulerAngles(R, 'ZYX');

    case 'ZYZ'
        % Handle Z-Y-Z rotation order
        eulShaped = calculateEulerAngles(R, 'ZYZ');
        
    case 'XYZ'
        % Handle X-Y-Z rotation order
        eulShaped = calculateEulerAngles(R, 'XYZ');

    case 'XZY'
        % Handle X-Z-Y rotation order
        eulShaped = calculateEulerAngles(R, 'XZY');
end

% Shape output as a series of row vectors
eul = reshape(eulShaped,[3, numel(eulShaped)/3]).';

if nargout > 1
    eulAlt = robotics.core.internal.generateAlternateEulerAngles(eul, seq);
end

end

function eul = calculateEulerAngles(R, seq)
%calculateEulerAngles Calculate Euler angles from rotation matrix
%   EUL = calculateEulerAngles(R, SEQ) calculates the Euler angles, EUL,
%   corresponding to the input rotation matrix, R. The Euler angles follow
%   the axis order specified in SEQ. 

% Preallocate output
eul = zeros(1, 3, size(R,3), 'like', R);  %#ok<PREALL>

nextAxis = [2, 3, 1, 2];

% Pre-populate settings for different axis orderings
% Each setting has 4 values:
%   1. firstAxis : The right-most axis of the rotation order. Here, X=1,
%      Y=2, and Z=3.
%   2. repetition : If the first axis and the last axis are equal in
%      the sequence, then repetition = 1; otherwise repetition = 0.
%   3. parity : Parity is 0 if the right two axes in the sequence are
%      YX, ZY, or XZ. Otherwise, parity is 1.
%   4. movingFrame : movingFrame = 1 if the rotations are with
%      reference to a moving frame. Otherwise (in the case of a static
%      frame), movingFrame = 0.

seqSettings.ZYX = [1, 0, 0, 1];
seqSettings.ZYZ = [3, 1, 1, 1];
seqSettings.XYZ = [3, 0, 1, 1];
seqSettings.XZY = [2, 0, 0, 1];

% Retrieve the settings for a particular axis sequence
setting = seqSettings.(seq);
firstAxis = setting(1);
repetition = setting(2);
parity = setting(3);
movingFrame = setting(4);

% Calculate indices for accessing rotation matrix
i = firstAxis;
j = nextAxis(i+parity);
k = nextAxis(i-parity+1);

if repetition
    % Find special cases of rotation matrix values that correspond to Euler
    % angle singularities.
    sySq = R(i,j,:).*R(i,j,:) + R(i,k,:).*R(i,k,:); % sin(y)^2
    singular = sySq < 10 * eps(class(R));
    sy = sqrt(sySq);
    
    % Calculate Euler angles
    eul = [atan2(R(i,j,:), R(i,k,:)), atan2(sy, R(i,i,:)), atan2(R(j,i,:), -R(k,i,:))];
    
    % Singular matrices need special treatment (in this case, both z angles
    % cannot be uniquely determined, so just set one to zero)
    numSingular = sum(singular,3);
    assert(numSingular <= length(singular));
    if numSingular > 0
        eul(:,:,singular) = [atan2(-R(j,k,singular), R(j,j,singular)), ...
            atan2(sy(:,:,singular), R(i,i,singular)), zeros(1,1,numSingular,'like',R)];
    end
    
else
    % Find special cases of rotation matrix values that correspond to Euler
    % angle singularities.
    
    cySq = R(i,i,:).*R(i,i,:) + R(j,i,:).*R(j,i,:); % cos(y)^2
    singular = cySq < 10 * eps(class(R));
    cy = sqrt(cySq);
    
    % Calculate Euler angles
    eul = [atan2(R(k,j,:), R(k,k,:)), atan2(-R(k,i,:), cy), atan2(R(j,i,:), R(i,i,:))];
    
    % Singular matrices need special treatment (in this case, x and z
    % angles cannot be uniquely determined, so just assume one is zero)
    numSingular = sum(singular,3);
    assert(numSingular <= length(singular));
    if numSingular > 0
        eul(:,:,singular) = [atan2(-R(j,k,singular), R(j,j,singular)), ...
            atan2(-R(k,i,singular), cy(:,:,singular)), zeros(1,1,numSingular,'like',R)];
    end
end

if parity
    % Invert the result
    eul = -eul;
end

if movingFrame
    % Swap the X and Z columns
    eul(:,[1,3],:)=eul(:,[3,1],:);
end

end
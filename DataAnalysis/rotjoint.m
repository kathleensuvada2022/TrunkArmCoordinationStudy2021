
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the relative bone rotation matrices with respect
% to the previous segment.
%
% jR: 3x12 matrices
%     jR(:,1:3): rotations from global to thoracic LCS
%       G*Rti = Ti  -> Rti = G'*Ti = Ti
%
%     jR(:,4:6): rotations from thoracic to clavicular LCS
%       Ti*Rci = Ci  -> Rci = Ti'*Ci
%
%     jR(:,7:9): rotations from clavicular to scapular LCS
%       Ci*Rsi = Si  -> Rsi = Ci'*Si
%
%     jR(:,10:12): rotations from scapular to humeral LCS
%       Si*Rhi = Hi  -> Rhi = Si'*Hi
%
%     jR(:,13:15): rotations from humeral to forearm LCS
%       Hi*Rfi = Fi  -> Rfi = Hi'*Fi
%

% AS (#measurements x (3x12)) matrix: contains 4 local
    % coordinate systems (3x3 matrices) of thorax, clavicle, scapula and
    % humerus, respectively
    
%  N.B. Rotations are defined with respect to the LOCAL axis of the
%  proximal coordinate system (or G in case of thorax rotations)
%
%  November 1996, Frans van der Helmfunction [jR]=rotjoint(AS)


% Kacey October 2021 Testing

% AS =[CS_G{1,1}(1:3,1:3,1) CS_G{1,2}(1:3,1:3,1) CS_G{1,3}(1:3,1:3,1) CS_G{1,4}(1:3,1:3,1)];


function [jR]=rotjoint(AS)

% [n,m]=size(AS);nDATA = n/3;

%jR(1:n,1:3) = AS(:,1:3);
jR = zeros(3,3);

% for i=1:nDATA % don't need -- have this in the outer loop- and nData is time 
%     jR(3*i-2:3*i,4:6)=AS(3*i-2:3*i,1:3)'*AS(3*i-2:3*i,4:6);
%     jR(3*i-2:3*i,7:9)=AS(3*i-2:3*i,4:6)'*AS(3*i-2:3*i,7:9);
%     jR(3*i-2:3*i,10:12)=AS(3*i-2:3*i,7:9)'*AS(3*i-2:3*i,10:12);
%     jR(3*i-2:3*i,13:15)=AS(3*i-2:3*i,10:12)'*AS(3*i-2:3*i,13:15);
%     10:12 is hum 13:15 is forearm (OLD WAY)
  

% For KACEY Forearm (10:12) HUM (7:9) TO GET ELBOW ANGLE
   jR(1:3,1:3)=AS(:,7:9)'*AS(:,10:12);
    
    
% end
end

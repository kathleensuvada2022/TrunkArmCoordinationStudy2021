%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to calculate the absolute bone rotation matrices with respect
% to the trunk.
%
% gR: 3x12 matrices
%     gR(:,1:3): rotations from global to thoracic LCS
%       G*Rti = Ti  -> Rti = G'*Ti
%
%     gR(:,4:6): rotations from thorax to clavicular LCS
%       Ti*Rci = Ci  -> Rci = Ti'*Ci
%
%     gR(:,7:9): rotations from thorax to scapular LCS
%       Ti*Rsi = Si  -> Rsi = Ti'*Si
%
%     gR(:,10:12): rotations from thorax to humeral LCS
%       Ti*Rhi = Hi  -> Rhi = Ti'*Hi
%
%     gR(:,13:15): rotations from thorax to forearm LCS
%       Ti*Rfi = Fi  -> Rfi = Ti'*Fi
%
% N.B. Rci, Rsi and Rhi are defined as rotations about the LOCAL
%      axes of the thoracic coordinate system
% November 1996, Frans van der Helm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gR]=rotbones(AS)
%   function [gR]=rotbones(AS)
%
% [n,m]=size(AS);nDATA = n/3;

%  T0 = AS(1:3,1:3); % initial thorax orientation
% for i=1:nDATA
%     gR(3*i-2:3*i,1:3)=AS(3*i-2:3*i,1:3);
%     Ti = gR(3*i-2:3*i,1:3); %**
%     gR(3*i-2:3*i,1:3)=T0'*AS(3*i-2:3*i,1:3);  % Global to Trunk
%     Ti = T0*gR(3*i-2:3*i,1:3); %** These lines give the same result
%     gR(3*i-2:3*i,4:6)=Ti'*AS(3*i-2:3*i,4:6);  % Trunk to Clavicle
%     gR(3*i-2:3*i,7:9)=Ti'*AS(3*i-2:3*i,7:9);  % Trunk to Scapula
%     gR(3*i-2:3*i,10:12)=Ti'*AS(3*i-2:3*i,10:12);  % Trunk to Humerus
%     %   gR(3*i-2:3*i,13:15)=Ti'*AS(3*i-2:3*i,13:15);  % Trunk to Forearm
%     
%   AS =[TtoG(1:3,1:3,j) StoG(1:3,1:3,j) HtoG(1:3,1:3,j) FtoG(1:3,1:3,j)];  
gR(1:3,1:3) = AS(:,1:3); %trunk rotation matrix in global
gR(1:3,4:6) = AS(:,7:9); %humerus rotatin matrix in global
    
% end
end

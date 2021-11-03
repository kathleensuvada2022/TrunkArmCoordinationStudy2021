
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to estimate the center of rotation of the GH joint
% based on a regression equation of the scapular bony landmarks
% (AC, AA, TS, AI)
% ADD REFERENCE AND CHECK THE REGRESSION MODEL TO MATCH THE CSs
%       input : bl=[ac aa ts ai] (3D coordinates of scapular bony landmarks in
%                              the scapular CS)
%               Rsca (scapula rotation matrix)
%       output: gh (3D coordinates of the center of rotation of the GH
%                   joint in scapular CS) -

% Kacey 
% want to add Computed GH to BL file 
% Output: GH in marker CS 
% Inputs: BLs in marker CS (raw data file) 
  %RSCA: Rotation matrix created via BLs in bone CS 
% Done one time at the beginning via BL data
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gh=ghest(bl,Rsca)
% Rsca=asscap(ac,ts,ai); % No longer necessary, Rscap is an input

% Need to convert to bone KACEY

%Rotating 180 about Z
Rsca=Rsca*diag([-1 -1 1]); % Flips the x and y axes == 180 degree rotation about z FIGURE OUT IF THIS IS NEEDED

% Rotate 180 degrees about Y (Kacey)
Rsca=Rsca*diag([-1 1 -1]);

Osca=(bl(:,1)+bl(:,2))/2; % Osca=(ac+aa)/2; compute midpoint between AC and AA

% ac=Rsca'*(ac-Osca); No necessary because BLs are already in scapular CS
% aa=Rsca'*(aa-Osca);
% ts=Rsca'*(ts-Osca);
% ai=Rsca'*(ai-Osca);

% Change origin to midpoint between AC and AA
bl=bl-repmat(Osca,1,4); % for 4 Bls

lacaa=norm(bl(:,1)-bl(:,2)); %lacaa=norm(ac-aa); % length from AC to AA
lacts=norm(bl(:,1)-bl(:,3)); %lacts=norm(ac-ts);
lacai=norm(bl(:,1)-bl(:,4)); %lacai=norm(ac-ai);
ltsai=norm(bl(:,3)-bl(:,4)); %ltsai=norm(ts-ai);

% TWO DIFFERENT REGRESSION EQUATIONS (2 AND 3 ARE THE SAME EXCEPT FOR THE NUMBER OF DECIMALS) WHICH ONE IS BEST????
% ghrel=[ ...
%   [  lacaa lacts       ltsai]*[     0.45 -0.28        0.18]';
%   [1       lacts lacai      ]*[-70        0.73 -0.28      ]';
%   [        lacts lacai ltsai]*[          -0.51  0.42 -0.38]'];

%   ghrel=[ ...
%     [1       lacts lacai      ]*[  9.8       -0.399  0.223      ]';
%     [1       lacts lacai      ]*[-69.6        0.731 -0.277      ]';
%     [1       lacts lacai      ]*[ -2.7       -0.297  0.065      ]'];

% AMA changed ghrel to gh since the last rotation is not needed.
  gh=[ ...
    [1       lacts lacai      ]*[ 10       -0.40  0.22      ]'; % Xcoord
    [1       lacts lacai      ]*[-70        0.73 -0.28      ]';  % Y coord
    [1       lacts lacai      ]*[ -3       -0.30  0.06      ]']; % Z coord
% Kacey: Write out matrix. GH regression paper to see where numbers from

% 1X3 * (1X3)' --> 1X3* 3X1 = 1X1 ( x coord) 


%gh=Rsca*ghrel+Osca; Not needed because GH is in scapular CS


end

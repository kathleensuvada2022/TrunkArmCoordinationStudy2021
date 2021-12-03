
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

%Kacey November 2021
% 1) INPUTS bl: BLs_lcs_s bony landmarks of scap in Marker and Rsca: ScapCoord in bone CS
% 2) Convert BLs and CS to Bone CS 


%% testing 
Rscap_mark = ScapCoord; % HT Matrix in marker CS
bl_mark = BLs_lcs_s;% in marker CS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function gh=ghest(bl_mark,Rscap_mark)EL
%% Rsca=asscap(ac,ts,ai); % No longer necessary, Rscap is an input

%organizing BLS
bl = zeros(4,4);
for i =1:4
bl(1:4,i) = bl_mark{1,i}(:,1);
end

%%

% ["AC","AA","TS","AI"] KACEY'S BL ORDER
% for j = 1:4
% bl(1:3,j) = Rscap_mark'*bl(1:3,j); %converting BLs to Scapular CS
% end

% row0 = [0 0 0 1];
% col0 = [0 0 0]';
% Rscap_mark= cat(2, Rscap_mark,col0);
% Rscap_mark = cat(1, Rscap_mark,row0);

bl(:,:) = inv(Rscap_mark)*bl; %BL's now in Scapular CS

%%
% RotX_90 =rotx(deg2rad(90));
% RotX_90= cat(2, RotX_90,col0);
% RotX_90 = cat(1, RotX_90,row0); %Adding a column of 0s and row of 1s st 4x4

%Rotating BLS 90 about x so aligned with original system
bl =[rotx(pi/2) zeros(3,1); zeros(1,3) 1]*bl;

%% 
% Rotating 180 about Z 
% Rsca=Rsca*diag([-1 -1 1]); % Flips the x and y axes == 180 degree rotation about z % changing to that Scap Coord follows original definition

%% %right arm only 
% Rscap =rotx(deg2rad(90))*Rscap_mark(1:3,1:3); % make sure consistent with paper description 
% Scap_org = bl(:,1);
% Rscap= cat(2, Rscap,Scap_org(1:3));
% Rscap= cat(1, Rscap,row0);
%  % Plotting rotated R and BLs
% 
%  figure()
% quiver3(Rscap([1 1 1],4)',Rscap([2 2 2],4)',Rscap([3 3 3],4)',50*Rscap(1,1:3),50*Rscap(2,1:3),50*Rscap(3,1:3))
% %quiver3(ForeCS([1 1 1],4)',ForeCS([2 2 2],4)',ForeCS([3 3 3],4)',50,50,50)
% text(50*Rscap(1,1:3),50*Rscap(2,1:3),50*Rscap(3,1:3),{'x','y','z'})
% hold on
% for p = 1:length(bl)
% plot3(bl(1,p),bl(2,p),bl(3,p),'-o','Color','b','MarkerSize',10,...
%     'MarkerFaceColor','#D9FFFF')
% text(bl(1,p),bl(2,p),bl(3,p),BLnames_s(p),'FontSize',12)
% end
% axis equal
% xlabel('x')
% ylabel('y')
% zlabel('z')
 %%

Osca=(bl(:,1)+bl(:,2))/2; % Osca=(ac+aa)/2; compute midpoint between AC and AA

% ac=Rsca'*(ac-Osca); No necessary because BLs are already in scapular CS
% aa=Rsca'*(aa-Osca);
% ts=Rsca'*(ts-Osca);
% ai=Rsca'*(ai-Osca);

% Change origin to midpoint between AC and AA
bl=bl-repmat(Osca,1,4); % for 4 Bls

%%
lacaa=norm(bl(:,1)-bl(:,2)); %lacaa=norm(ac-aa); % length from AC to AA
lacts=norm(bl(:,1)-bl(:,3)); %lacts=norm(ac-ts); % length from AC to TS
lacai=norm(bl(:,1)-bl(:,4)); %lacai=norm(ac-ai)  % length from AC to AI
ltsai=norm(bl(:,3)-bl(:,4)); %ltsai=norm(ts-ai); % length from TS to AI

%%
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

%% Rotate GH back to my Coordinate system definition

gh_rot = rotx(-90)*gh; % Rotated GH still in the Bone CS

%% Then Get back into Scapula marker CS 
%Rscap_mark2 = Rscap_mark(1:3,1:3); % Just the rotation matrix
gh_markr = Rscap_mark*[gh_rot;1]; %Rotated GH now converted to the Marker CS --> THIS IS MARKER OF SCAPULAR 



%% Saving to set up file 
setupID = 'RTIS2011_setup';
setup.GHComp_shmarker = gh_markr;

save(setupID,'setup');

%%
%gh=Rsca*ghrel+Osca; Not needed because GH is in scapular CS


%end

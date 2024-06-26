 function [xhand,xshldr,xtrunk,maxreach,shtrdisp,maxreachtime]=GetHandShoulderTrunkPosition6(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
 % [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
%   % For testing
%      filepath='/Users/kcs762/Desktop/Data/RTIS2003/Experiment_Data/Trials';
%      filename='/trial22.mat';
%      partid='RTIS2003';


%% Load marker data

% for MOCAP DATA
% Matrix size = [Nimages x (2 + Nmarkers*14)]
% [FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
% x=dlmread([filepath filename],',',18,1);
% x(x==0)=NaN; %h Replace zeros with NaN
% x(:,end)=[]; % Remove last column
% 
%  [nimag,nmark]=size(x);
%   nmark=(nmark-2)/14;


% X FROM UDP 
% MARKERID X,Y,Z,Qr,Qx,Qy,Qz 
% For UDP dated 1.28.21
data=load([filepath filename]);
x = data.data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; % 


%%

load([partid '_setup'])


% Build the time vector
t = (1:length(x))';
% t=x(:,1)-x(1,1); From old MOCAP data

%% Extract trunk, arm, forearm, hand marker position
% % hidx=find(x(1,:)==setup.markerid(5)); xhand=x(:,hidx+(5:4:15)); 
%  fidx=find(x(1,:)==setup.markerid(4)); xfore=x(:,fidx+(5:4:15)); %extracting the forearm marker data index 
%  aidx=find(x(1,:)==setup.markerid(3)); xarm=x(:,aidx+(5:4:15)); %extracting humerus marker
%  sidx=find(x(1,:)==setup.markerid(2)); xshldr=x(:,sidx+(5:4:15));% extracting shoulder marker
%  tidx=find(x(1,:)==setup.markerid(1)); xtrunk=x(:,tidx+(5:4:15)); if ~isempty(tidx), xtrunk=x(:,tidx+(5:4:15)); else xtrunk=zeros(size(xhand));end
%  

% 1.19.21
%Need to account for fact that each marker ID is in a different column for
% every row? need to include i and this in for loop? too complicated since
% this now different?

fidx=find(x(1,:)==setup.markerid(4)); xfore=x(:,fidx:(fidx+7)); %extracting the forearm marker data index 
aidx=find(x(1,:)==setup.markerid(3)); xarm=x(:,aidx:(aidx+7)); %extracting humerus marker
sidx=find(x(1,:)==setup.markerid(2)); xshldr=x(:,sidx:(sidx+ 7));% extracting shoulder marker
tidx=find(x(1,:)==setup.markerid(1)); xtrunk=x(:,tidx:(tidx+7)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end

%% Transforming the Quaternion organization to the HT - 1.28.21

fore_quat = xfore(:,5:end);
a_quat = xarm(:,5:end);
s_quat = xshldr(:,5:end);
t_quat = xtrunk(:,5:end);

fore_quat= circshift(fore_quat,1); % added to compensate for quaternion shifted by 1
a_quat= circshift(a_quat,1); % added to compensate for quaternion shifted by 1
s_quat= circshift(s_quat,1); % added to compensate for quaternion shifted by 1
t_quat= circshift(t_quat,1); % added to compensate for quaternion shifted by 1

% XYZ point 
 P_fore = xfore(:,1:3)';
 P_arm = xarm(:,1:3)';
 P_shldr = xshldr(:,1:3)';
 P_trunk = xtrunk(:,1:3)';

% % Each quaternion represents a 3D rotation and is of the form 
% % q = [w(SCALAR REAL) qx qy qz]
% 
%  HT_UDP = quat2tform(Quat_UDP);
%  HT_UDP(1:3,4) = P;
%  HT_UDP
% 
% Now have HT matrix like is outout from MOCAP
HT_fore = quat2tform(fore_quat); HT_fore(1:3,4,:) = P_fore;
HT_arm = quat2tform(a_quat);  HT_arm(1:3,4,:) = P_arm;
HT_shldr = quat2tform(s_quat);  HT_shldr(1:3,4,:) = P_shldr;
HT_trunk = quat2tform(t_quat);  HT_trunk(1:3,4,:) = P_trunk;


%% Compute the BL in the global CS using P_LCS 

%2.12.21 
% Should have this for next data set directly from Metria. METKINDAQ will
% now give data in LCS

% HOW BL is organized {'Trunk';'Scapula';'Humerus';'Forearm'};
% {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker 
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
    Tftom= HT_fore;
    BLg=(Tftom).*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and -> Changed to column 4 2/16/21 -> check this
    xhand(i,:)=BLg(1:3,1)'; % X Y Z of the hand in global cs based off forearm
    % for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1];
    Tstom = HT_shldr; 
    BLg2=(Tstom).*setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
  xshldr=BLg2(:,4,:); % X Y Z of BL in the global frame and rows are time 
  xshldr = permute(xshldr,[1 3 2]); %added KCS
  xshldr = xshldr';%gives 250 rows and 4 columns where each row is time and each column is X,Y,Z and then 1  worked on 2.16.21
  xshldr(:,4) = []; % removed the 1s from each row

end


%% Compute reaching distance (between shoulder and hand from hand marker)
rdist=sqrt(sum((xhand-xshldr).^2,2));
[maxreach,mridx]=max(rdist);
disp(maxreach)
maxreachtime = mridx/89;  % added to display the time that metria data is at the max reach in second 4.30.20

maxreachidx = mridx;
%  %%
p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1)],-[xhand(:,3) xshldr(:,3) xtrunk(:,3)],'LineWidth',2); hold on
p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
phandles=[p1' p2 p3];
axis 'equal'
% legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach');
title(filename,'Interpreter','none')
%  %%
% p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xhand(:,3) xshldr(:,3) xtrunk(:,3) xfore(:,3)],'LineWidth',2); hold on
% p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
% phandles=[p1' p2 p3];
% axis 'equal'
% % legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
% legend(phandles,'Hand','Shoulder','Trunk','Forearm','Home','Max Reach');
% title(filename,'Interpreter','none')

%% Compute the mean trunk position
mtpos=nanmean(xtrunk); 
stdtpos=nanstd(xtrunk); 
mspos=nanmean(xshldr);
stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
shtrdisp=sqrt(sum(([xshldr(mridx,:);xtrunk(mridx,:)]-[nanmean(xshldr(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))'

%% Truncate data until max reach
xhand=xhand(1:mridx,:);
%xfore=xfore(1:mridx,:);
%xarm=xarm(1:mridx2,:);
xshldr=xshldr(1:mridx,:);
xtrunk=xtrunk(1:mridx,:);

% xhand=xhand(1:mridx2,:);
% xfore=xfore(1:mridx2,:);
% xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx2,:);
% xtrunk=xtrunk(1:mridx2,:);


 end

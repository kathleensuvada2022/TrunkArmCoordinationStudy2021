function [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data
% [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
%% For testing
% filepath='RTIS2001\metria\trunkfree\';
% filename='2001tf_final_00000001.hts';
% partid='RTIS2001';

%% Load marker data
% Matrix size = [Nimages x (2 + Nmarkers*14)]
% [FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
x=dlmread([filepath filename],',',18,1); % Skip header - 18 lines and first and last columns
x(x==0)=NaN; % Replace zeros with NaN
x(:,end)=[]; % Remove last column

[nimag,nmark]=size(x);
nmark=(nmark-2)/14;

load([partid '\' partid '_setup'])

%% Build the time vector
t=x(:,1)-x(1,1);

%% Extract trunk, arm, forearm, hand marker position
idx=find(x(1,:)==setup.markerid(5)); xhand=x(:,idx+(5:4:15));
idx=find(x(1,:)==setup.markerid(4)); xfore=x(:,idx+(5:4:15));
idx=find(x(1,:)==setup.markerid(3)); xarm=x(:,idx+(5:4:15));
idx=find(x(1,:)==setup.markerid(2)); xshldr=x(:,idx+(5:4:15));
idx=find(x(1,:)==setup.markerid(1)); xtrunk=x(:,idx+(5:4:15));

%% Compute reaching distance (between shoulder and hand)
rdist=sqrt(sum((xhand-xshldr).^2,2));
[maxreach,mridx]=max(rdist);

%% Plot results
% 3D plot
figure(1)
plot3([xhand(:,1) xshldr(:,1) xtrunk(:,1)],[xhand(:,2) xshldr(:,2) xtrunk(:,2)],[xhand(:,3) xshldr(:,3) xtrunk(:,3)])
axis 'equal'
legend('hand','shoulder','trunk')

% 2D plots
figure(2),clf
p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xhand(:,3) xshldr(:,3) xtrunk(:,3) xfore(:,3)],'LineWidth',2); hold on
p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
phandles=[p1' p2 p3];
axis 'equal'
legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
title(filename)

%% Compute the mean trunk position
mtpos=nanmean(xtrunk); stdtpos=nanstd(xtrunk); 
mspos=nanmean(xshldr); stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute reaching distance (between shoulder and hand)
rdist2=sqrt(sum((xhand-mspos).^2,2));
[maxreach2,mridx2]=max(rdist2);

%% Truncate data until max reach
xhand=xhand(1:mridx,:);
xfore=xfore(1:mridx,:);
xarm=xarm(1:mridx,:);
xshldr=xshldr(1:mridx,:);
xtrunk=xtrunk(1:mridx,:);

% xhand=xhand(1:mridx2,:);
% xfore=xfore(1:mridx2,:);
% xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx2,:);
% xtrunk=xtrunk(1:mridx2,:);



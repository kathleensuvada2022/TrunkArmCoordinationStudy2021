function [xhand,xshldr,xtrunk,maxreach,shtrdisp]=GetHandShoulderTrunkPosition(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
% [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
%% For testing
%   filepath='/Users/kcs762/Desktop/Strokedata/RTIS2001/metria/trunkrestrained/';
%   filename='RTIS2001_00000001.hts';
%   partid='RTIS2001';
%   

%% Load marker data
% Matrix size = [Nimages x (2 + Nmarkers*14)]
% [FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
x=dlmread([filepath filename],',',18,1);
x(x==0)=NaN; %h Replace zeros with NaN
x(:,end)=[]; % Remove last column

[nimag,nmark]=size(x);
nmark=(nmark-2)/14;

load([partid '/' partid '_setup'])

% Build the time vector
t=x(:,1)-x(1,1);

%% Extract trunk, arm, forearm, hand marker position
%hidx=find(x(1,:)==setup.markerid(5)); xhand=x(:,hidx+(5:4:15)); 
fidx=find(x(1,:)==setup.markerid(4)); %xfore=x(:,fidx+(5:4:15)); %extracting the forearm marker data index 
%aidx=find(x(1,:)==setup.markerid(3)); xarm=x(:,aidx+(5:4:15));
sidx=find(x(1,:)==setup.markerid(2)); %xshldr=x(:,sidx+(5:4:15));% 
tidx=find(x(1,:)==setup.markerid(1)); if ~isempty(tidx), xtrunk=x(:,tidx+(5:4:15)); else xtrunk=zeros(size(xhand));end

%% Compute the BL in the global CS using P_LCS 

for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker 
    Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
    BLg=(Tftom) *setup.bl.lcs{4}(:,1);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and 
    xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
    % for the acromion using the shoulder marker 
    Tstom= [reshape(x(i,sidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
    BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
    xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
end


%% Compute reaching distance (between shoulder and hand from hand marker)
rdist=sqrt(sum((xhand-xshldr).^2,2));
[maxreach,mridx]=max(rdist);

 %
p1=plot([xhand(:,1) xhand2(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xhand(:,3) xhand2(:,3) xshldr(:,3) xtrunk(:,3) xfore(:,3)],'LineWidth',2); hold on
p2=plot(gca,nanmean([xhand(1:10,1) xhand2(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xhand2(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
p3=plot([xhand(mridx,1) xhand2(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xhand2(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
phandles=[p1' p2 p3];
axis 'equal'
% legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
legend(phandles,'Hand','Hand2','Shoulder','Trunk','Forearm','Home','Max Reach');
title(filename,'Interpreter','none')

%% Compute the mean trunk position
mtpos=nanmean(xtrunk); 
stdtpos=nanstd(xtrunk); 
mspos=nanmean(xshldr);
stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
shtrdisp=sqrt(sum(([xshldr(mridx,:);xtrunk(mridx,:)]-[nanmean(xshldr(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))';

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



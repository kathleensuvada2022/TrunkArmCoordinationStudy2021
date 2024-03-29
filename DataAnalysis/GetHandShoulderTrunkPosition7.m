<<<<<<< Updated upstream
 function [x3mcp,xaa,xxp,maxreach,trdisp,maxreachtime]=GetHandShoulderTrunkPosition7(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
 % [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
%   % For testing
%      filepath='/Users/kcs762/Desktop/Data/RTIS2003/Experiment_Data/Trials';
%      filename='/trial22.mat';
%      partid='RTIS2003';


% This is only for data where each row doesn't have the marker data in the
% same place. Won't have to worry about this later.

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
load([filepath filename]);
x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; % 


%%

load([filepath '/' partid '_setup'])


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
%%

%NOTE FOR 2020 DATA STRUCTURE
% For RTIS 2003 run Consolidate Metria first to eliminate data
% from both Cameras 

% update 2021 data- don't need

%newdata=ConsolidateMETData(x); %passing in the data into consolidate
%metrria

% x= newdata;
% x = x(:,4:end);


%now data structure has each marker ID and corresponding data once

%forearm columns and rows where forearm marker ID is present 
     
[ridx,cidx]=find(x==setup.markerid(4));  
fidx =cidx(1);
% if isempty(x(1,fidx)) % to compensate for the fact that some rows may be empty 
%     for i =1:length(x) 
%         fidx=fidx+1;
%     end
% end
xfore=x(:,fidx:(fidx+7));

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1);

% if isempty(x(1,aidx)) % to compensate for the fact that some rows may be empty 
%     for i =1:length(x) 
%         aidx=aidx+i;
%     end
% end
xarm=x(:,aidx:(aidx+7)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1);

xshldr=x(:,sidx:(sidx+ 7)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1);

xtrunk=x(:,tidx:(tidx+7)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end


%Lines below KCS trying to create workaround for data being grabbed that's
%not correct... leaving incase but don't need
% %giving the columns that = 73 for each row
% col = zeros(length(x),2);
% for i = 1:length(x)
%     col(i,:)= find(x(i,:)==73);
% end 
% 
% 
% test_data_73=zeros(250,16);
% %checking to make sure x(r,c) =73
% for i = 1:250 % for all the rows
%     for j= 1:2 % for all the columns
% test_data_73(i,j+(0:7))= x(i,col(i,j)+(0:7)); 
%     end 
% end
% 
% xfore=x(test_data(:),fcidx:(fidx+7)); %  and do for aidx,sidx,tidx
% 
% 
% [row, col] = find(x(i,:)==73);
% 
% rc = sortrows([row(:), col(:)]);
% r = rc(:,1);
% c = rc(:,2);
% test73 = x(r,c);




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
% 
%2.12.21 
% Should have this for next data set directly from Metria. METKINDAQ will
% now give data in LCS

% HOW BL is organized {'Trunk';'Scapula';'Humerus';'Forearm'};
% {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

x3mcp = zeros(nimag,4); % for 3rd MCP position
xaa =zeros(nimag,4); %for anterior acromion
xxp = zeros(nimag,4);%for xiphoid process 
for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker 
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
    Tftom= HT_fore(:,:,i);
    BLg=(Tftom)*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and -> Changed to column 4 2/16/21 -> check this
    x3mcp(i,:)=BLg'; % X Y Z of the hand in global cs based off forearm
   
    % for the  acromion using the shoulder marker 
%       Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1];
     Tstom = HT_shldr(:,:,i); 
     BLg2=(Tstom)*setup.bl.lcs{2}(:,2);  %grabbing the XYZ point of the anterior acromionin LCS 
    xaa(i,:)=BLg2'; % X Y Z of BL in the global frame and rows are time 
%   xshldr=BLg2(:,4,:); % X Y Z of BL in the global frame and rows are time 
%   xshldr = permute(xshldr,[1 3 2]); %added KCS
%   xshldr = xshldr';%gives 250 rows and 4 columns where each row is time and each column is X,Y,Z and then 1  worked on 2.16.21
%   xshldr(:,4) = []; % removed the 1s from each row

% for the xiphoid process using the trunk marker 
Tttom = HT_trunk(:,:,i);
BLg3 =(Tttom)*setup.bl.lcs{1}(:,3); 
xxp(i,:) = BLg3';


end

% %%
% figure
% plot(x3mcp(:,1),x3mcp(:,2),'x')
% title('test plot 3rd mcp trajectory')
% xlabel('x')
% ylabel('y')


%% Compute reaching distance (between shoulder and hand from hand marker)


% use xmcp and xaa instead of xarm and xshldr
rdist=sqrt(sum((x3mcp-xaa).^2,2));
[maxreach,mridx]=max(rdist);
disp(maxreach/10) %reaching distance in cm
maxreachtime = mridx/89;  % added to display the time that metria data is at the max reach in second 4.30.20


maxreachidx = mridx;
% %  %%
% p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1)],-[xhand(:,3) xshldr(:,3) xtrunk(:,3)],'LineWidth',2);

% plot3(x3mcp(:,1),x3mcp(:,2),x3mcp(:,3),'o'); % adding in 3rd MCP
% hold on
 plot(P_fore(1,:),P_fore(2,:))
 hold on
 text(P_fore(1,1),P_fore(2,1),'Forearm','FontSize',14)

 plot(P_trunk(1,:),P_trunk(2,:))
 text(P_trunk(1,1),P_trunk(2,1),'Trunk','FontSize',14)
 
 plot(P_shldr(1,:),P_shldr(2,:))
 text(P_shldr(1,10),P_shldr(2,10),'Shoulder','FontSize',14)
% % p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% % p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
% % phandles=[p1' p2 p3];
%  axis 'equal'
%  legend('Forearm','Trunk','Shoulder')
% % legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach');
 title('Reaching Plot')
 xlabel('X position (cm)')
 ylabel('Y position (cm)')

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

disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
% shtrdisp=sqrt(sum(([xaa(mridx,:);xtrunk(mridx,:)]-[nanmean(xaa(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))'


for i = mridx:length(xxp)
if isnan(xxp(mridx))
    
    mridx =mridx+1;
    
end 
end

trdisp =sqrt(sum([xxp(mridx,1:3)-nanmean(xxp(1:20,1:3))].^2,2));

       
%% Truncate data until max reach
xhand=x3mcp(1:mridx,:);
%xfore=xfore(1:mridx,:);
%xarm=xarm(1:mridx2,:);
xshldr=xaa(1:mridx,:);
xtrunk=xtrunk(1:mridx,:);

% xhand=xhand(1:mridx2,:);
% xfore=xfore(1:mridx2,:);
% xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx2,:);
% xtrunk=xtrunk(1:mridx2,:);


 end
=======
 function [x3mcp,xaa,xxp,maxreach,trdisp,maxreachtime]=GetHandShoulderTrunkPosition7(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
 % [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
%   % For testing
%      filepath='/Users/kcs762/Desktop/Data/RTIS2003/Experiment_Data/Trials';
%      filename='/trial22.mat';
%      partid='RTIS2003';


% This is only for data where each row doesn't have the marker data in the
% same place. Won't have to worry about this later.

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
load([filepath filename]);
x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; % 


%%

load([filepath '/' partid '_setup'])


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
%%

%NOTE FOR 2020 DATA STRUCTURE
% For RTIS 2003 run Consolidate Metria first to eliminate data
% from both Cameras 

% update 2021 data- don't need

%newdata=ConsolidateMETData(x); %passing in the data into consolidate
%metrria

% x= newdata;
% x = x(:,4:end);


%now data structure has each marker ID and corresponding data once

%forearm columns and rows where forearm marker ID is present 
     
[ridx,cidx]=find(x==setup.markerid(4));  
fidx =cidx(1);
% if isempty(x(1,fidx)) % to compensate for the fact that some rows may be empty 
%     for i =1:length(x) 
%         fidx=fidx+1;
%     end
% end
xfore=x(:,fidx:(fidx+7));

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1);

% if isempty(x(1,aidx)) % to compensate for the fact that some rows may be empty 
%     for i =1:length(x) 
%         aidx=aidx+i;
%     end
% end
xarm=x(:,aidx:(aidx+7)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1);

xshldr=x(:,sidx:(sidx+ 7)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1);

xtrunk=x(:,tidx:(tidx+7)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end


%Lines below KCS trying to create workaround for data being grabbed that's
%not correct... leaving incase but don't need
% %giving the columns that = 73 for each row
% col = zeros(length(x),2);
% for i = 1:length(x)
%     col(i,:)= find(x(i,:)==73);
% end 
% 
% 
% test_data_73=zeros(250,16);
% %checking to make sure x(r,c) =73
% for i = 1:250 % for all the rows
%     for j= 1:2 % for all the columns
% test_data_73(i,j+(0:7))= x(i,col(i,j)+(0:7)); 
%     end 
% end
% 
% xfore=x(test_data(:),fcidx:(fidx+7)); %  and do for aidx,sidx,tidx
% 
% 
% [row, col] = find(x(i,:)==73);
% 
% rc = sortrows([row(:), col(:)]);
% r = rc(:,1);
% c = rc(:,2);
% test73 = x(r,c);




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
% 
%2.12.21 
% Should have this for next data set directly from Metria. METKINDAQ will
% now give data in LCS

% HOW BL is organized {'Trunk';'Scapula';'Humerus';'Forearm'};
% {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

x3mcp = zeros(nimag,4); % for 3rd MCP position
xaa =zeros(nimag,4); %for anterior acromion
xxp = zeros(nimag,4);%for xiphoid process 
for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker 
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
    Tftom= HT_fore(:,:,i);
    BLg=(Tftom)*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and -> Changed to column 4 2/16/21 -> check this
    x3mcp(i,:)=BLg'; % X Y Z of the hand in global cs based off forearm
   
    % for the  acromion using the shoulder marker 
%       Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1];
     Tstom = HT_shldr(:,:,i); 
     BLg2=(Tstom)*setup.bl.lcs{2}(:,2);  %grabbing the XYZ point of the anterior acromionin LCS 
    xaa(i,:)=BLg2'; % X Y Z of BL in the global frame and rows are time 
%   xshldr=BLg2(:,4,:); % X Y Z of BL in the global frame and rows are time 
%   xshldr = permute(xshldr,[1 3 2]); %added KCS
%   xshldr = xshldr';%gives 250 rows and 4 columns where each row is time and each column is X,Y,Z and then 1  worked on 2.16.21
%   xshldr(:,4) = []; % removed the 1s from each row

% for the xiphoid process using the trunk marker 
Tttom = HT_trunk(:,:,i);
BLg3 =(Tttom)*setup.bl.lcs{1}(:,3); 
xxp(i,:) = BLg3';


end

% %%
% figure
% plot(x3mcp(:,1),x3mcp(:,2),'x')
% title('test plot 3rd mcp trajectory')
% xlabel('x')
% ylabel('y')


%% Compute reaching distance (between shoulder and hand from hand marker)


% use xmcp and xaa instead of xarm and xshldr
rdist=sqrt(sum((x3mcp-xaa).^2,2));
[maxreach,mridx]=max(rdist);
disp(maxreach/10) %reaching distance in cm
maxreachtime = mridx/89;  % added to display the time that metria data is at the max reach in second 4.30.20


maxreachidx = mridx;
% %  %%
% p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1)],-[xhand(:,3) xshldr(:,3) xtrunk(:,3)],'LineWidth',2);

plot(x3mcp(:,1),x3mcp(:,2),'LineWidth',2); % adding in 3rd MCP
hold on
plot(P_fore(2,1:41),P_fore(3,1:41),'LineWidth',2);

plot(P_trunk(2,:),P_trunk(3,:),'LineWidth',2)
plot(P_shldr(2,:),P_shldr(3,:),'LineWidth',2)
% % p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% % p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
% % phandles=[p1' p2 p3];
 axis 'equal'
 legend('Forearm','Trunk','Shoulder')
% % legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach');
 title('Reaching Plot')
 xlabel('X position (cm)')
 ylabel('Y position (cm)')
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

disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
% shtrdisp=sqrt(sum(([xaa(mridx,:);xtrunk(mridx,:)]-[nanmean(xaa(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))'


for i = mridx:length(xxp)
if isnan(xxp(mridx))
    
    mridx =mridx+1;
    
end 
end

trdisp =sqrt(sum([xxp(mridx,1:3)-nanmean(xxp(1:20,1:3))].^2,2));

       
%% Truncate data until max reach
xhand=x3mcp(1:mridx,:);
%xfore=xfore(1:mridx,:);
%xarm=xarm(1:mridx2,:);
xshldr=xaa(1:mridx,:);
xtrunk=xtrunk(1:mridx,:);

% xhand=xhand(1:mridx2,:);
% xfore=xfore(1:mridx2,:);
% xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx2,:);
% xtrunk=xtrunk(1:mridx2,:);


 end
>>>>>>> Stashed changes

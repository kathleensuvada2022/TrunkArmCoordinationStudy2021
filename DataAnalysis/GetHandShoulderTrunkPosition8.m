% function [xshldr,xtrunk,maxreach,shtrdisp,maxreachtime]=GetHandShoulderTrunkPosition8(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
 % [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
% %   % For testing
%      filepath='/Users/kcs762/Box/KACEY/Data/RTIS2001/metria/trunkfree';
%      filename='/2001tf_final_00000011.hts';
%      partid='RTIS2001';


%Kacey's Comments April 2021
% Just need to load in the BL file and the trial then run script 

%% Load marker data
% Matrix size = [Nimages x (2 + Nmarkers*14)]
% [FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
% x=dlmread([filepath filename],',',18,1);
% x(x==0)=NaN; %h Replace zeros with NaN
% x(:,end)=[]; % Remove last column
% 
% [nimag,nmark]=size(x);
% nmark=(nmark-2)/14;

% X FROM UDP 
% MARKERID X,Y,Z,Qr,Qx,Qy,Qz 
% For UDP dated 1.28.21
% load([filepath filename]);
x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 



% %  Load in the act3d data to compare with metria
% xact =data.act; 
% xee = xact(:,5);
% yee = xact(:,6);
% zee = xact(:,7);
% 
% xhnd = xact(:,2); % is this supposed to be the 3rd MCP computed from ACT
% yhnd = xact(:,3);
% zhnd = xact(:,4);
% 
% th =xact(:,8); % for rotation to compute 3rd MCP

% ACT-3D data saved
% Column 1 period in s
% Column 2-4 hand position 
% Column 5-7 robot.endEffectorPosition
% Column 8 robot.endEffectorRotation(1);
% Column 9-11 robot.endEffectorVelocity;
% Column 12-14 robot.endEffectorForce;
% Column 15-17 robot.endEffectorTorque;





%% CHANGE THIS !!!! 4.20.20
% % load(['/Users/kcs762/Desktop/Strokedata/RTIS2001/RTIS2001_setup'])
% % RTIS2001/metria/trunkrestrained/RTIS2001_setup
% % disp([filepath partid '_setup'])
% load([partid '/' partid '_setup'])
% 
% 
% % Build the time vector
% % t=x(:,1)-x(1,1);
% 
% load([filepath '/' partid '_setup'])
% 
% % Build the time vector
% t = (1:length(x))';

%% Extract trunk, arm, forearm, hand marker position
% %hidx=find(x(1,:)==setup.markerid(5)); xhand=x(:,hidx+(5:4:15)); 
% fidx=find(x(1,:)==setup.markerid(4)); %xfore=x(:,fidx+(5:4:15)); %extracting the forearm marker data index 
% %aidx=find(x(1,:)==setup.markerid(3)); xarm=x(:,aidx+(5:4:15));
% sidx=find(x(1,:)==setup.markerid(2)); %xshldr=x(:,sidx+(5:4:15));% 
% tidx=find(x(1,:)==setup.markerid(1)); xtrunk=x(:,tidx+(5:4:15)); %if ~isempty(tidx), xtrunk=x(:,tidx+(5:4:15)); else xtrunk=zeros(size(xhand));end


% markerid=[Trunk Shoulder Arm Forearm ]
% setup.markerid=[80 19 87 73];


%for testing
setup.markerid(4) = 73;
setup.markerid(3) = 87;
setup.markerid(2) = 19;
setup.markerid(1) = 80;

[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xarm=x(:,aidx:(aidx+6)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshldr=x(:,sidx:(sidx+ 6)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1)+1;
xtrunk=x(:,tidx:(tidx+6)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end
%%
% compute the hand position (3rd MCP) from the end effector
% position - From ACT3DTACS


% x - ACT3D end effector position  endEffectorPosition = [X, Y, Z] (replace with forearm data from metria);
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - hand position column vector
% 
% if strcmp(setup.exp.arm,'right')
%     p=xfore(:,1:3)+rotz(th+pi/2)*[(setup.exp.e2hLength-setup.exp.ee2eLength)/100 0 0]';
% %     p=x(:)-rotz(th-3*pi/2)*[0 (exp.e2hLength-exp.ee2eLength)/100 0]';
% else
%     p=xfore(:,1:3)+rotz(th-pi/2)*[(setup.exp.e2hLength-setup.exp.ee2eLength)/100 0 0]';
% %     p=x(:)-rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
% end
% 




%% Compute the BL in the global CS using P_LCS 
%From MetriaKinDaq
% dig.bl{dig.currentSEG}(dig.currentBL,:) =[Ptip_RB' quat_pointer PRB_RB' quat_RB];
%Gives XYZ of pointer tool,quaterion of pointer marker in GCS, then the marker in LCS (this should always be about 001, then quaternion marker in GCS

for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(xfore(i,4:7));
    Tftom(1:3,4) = xfore(i,1:3)';% Transformation matrix for forearm in time i
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
%      BLg=(Tftom)*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and
       BLg = Tftom*(bl{1,4}(4,1:4))';
      xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
%     % for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1]; 
%     BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
end



%% Compute reaching distance (between shoulder and hand from hand marker)
% rdist=sqrt(sum((xhand-xshldr).^2,2));
% [maxreach,mridx]=max(rdist);
maxreach=0;
maxreachtime = 0;
shtrdisp =0;
% disp(maxreach)
% maxreachtime = mridx/89;  % added to display the time that metria data is at the max reach in second 4.30.20
% 
% maxreachidx = mridx;
%  %% Comparing with ACT3D data (xhand2)
% p1=plot([xhand(:,1) xhand2(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xhand(:,3) xhand2(:,3) xshldr(:,3) xtrunk(:,3) xfore(:,3)],'LineWidth',2); hold on
% p2=plot(gca,nanmean([xhand(1:10,1) xhand2(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xhand(1:10,3) xhand2(1:10,3) xshldr(1:10,3) xtrunk(1:10,3)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% p3=plot([xhand(mridx,1) xhand2(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xhand2(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
% phandles=[p1' p2 p3];
% axis 'equal'
% % legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
% legend(phandles,'Hand','Hand2','Shoulder','Trunk','Forearm','Home','Max Reach');
% title(filename,'Interpreter','none')
 %%
 
 figure
 
%   p1=plot([xshldr(:,1) xtrunk(:,1) xfore(:,1)],[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2);
  p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1)],[xhand(:,2) xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2)
  hold on
% p1=plot(-[xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2); hold on
% p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1)]),nanmean([xhand(1:10,2) xshldr(1:10,2) xtrunk(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% p3 = plot([xee*1000 xhnd*1000],[yee*1000 yhnd*1000],'LineWidth',4);  % added to add act 3d data
% p2=plot(gca,-nanmean([xshldr(1:10,1) xtrunk(1:10,1)]),-nanmean([xshldr(1:10,2) xtrunk(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');

% p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
%  phandles=[p1;p2;p3];

axis 'equal'
% legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
%  legend(phandles,'Hand','Shoulder','Trunk','Forearm','Home');
legend('Hand','Shoulder','Trunk','Forearm');
% title(filename,'Interpreter','none')



%% Testing Forearm data and 3rd MCP position


%For one frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%grabbing the HT of the forearm marker (used for creating the forearm
%marker coordinate system)
HTfore_global = quat2tform(xfore(:,4:7));

for i =1:length(HTfore_global)
HTfore_global(1:3,4,i)=xfore(i,1:3);
end

%Plotting CS for the forearm marker
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1  % for one frame
quiver(xfore(i,1),xfore(i,2),HTfore_global(1,1,i),HTfore_global(2,1,i))%for x axis

hold on
quiver(xfore(i,1),xfore(i,2),HTfore_global(1,2,i),HTfore_global(2,2,i)) %for y axis

legend('x axis',' y axis')
% xlim([20 45])
% ylim([-20 5])
end 

% Plot of 3rd MCP and forearm in GCS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(xfore(:,1),xfore(:,2),'g','LineWidth',2)
hold on
plot(xhand(:,1),xhand(:,2),'m','LineWidth',2)  
legend('forearm','3rdMCP')
axis equal


%Plot of 3rd MCP and forearm CS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:3
quiver(xfore(i,1),xfore(i,2),HTfore_global(1,1,i),HTfore_global(2,1,i))%for x axis
hold on
quiver(xfore(i,1),xfore(i,2),HTfore_global(1,2,i),HTfore_global(2,2,i)) %yaxis

hold on
plot(xhand(i,1),xhand(i,2),'*','LineWidth',2)  
legend('X axis Forearm','Y axis Forearm','3rd MCP')

end








% return
% Compute the mean trunk position
% mtpos=nanmean(xtrunk); 
% stdtpos=nanstd(xtrunk); 
% mspos=nanmean(xshldr);
% stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
% shtrdisp=sqrt(sum(([xshldr(mridx,:);xtrunk(mridx,:)]-[nanmean(xshldr(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))'

%% Truncate data until max reach
% xhand=xhand(1:mridx,:);
% %xfore=xfore(1:mridx,:);
% %xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx,:);
% xtrunk=xtrunk(1:mridx,:);

% xhand=xhand(1:mridx2,:);
% xfore=xfore(1:mridx2,:);
% xarm=xarm(1:mridx2,:);
% xshldr=xshldr(1:mridx2,:);
% xtrunk=xtrunk(1:mridx2,:);



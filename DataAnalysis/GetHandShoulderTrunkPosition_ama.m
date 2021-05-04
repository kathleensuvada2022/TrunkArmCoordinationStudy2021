% function [xshldr,xtrunk,maxreach,shtrdisp,maxreachtime]=GetHandShoulderTrunkPosition_ama(filepath,filename,partid)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. The hand position is computed based on the forearm marker because
% the hand marker was not visible in all trials.
 % [xhand,xshldr,xtrunk,maxreach]=GetHandShoulderPosition('RTIS2001\metria\trunkfree\','2001tf_final_00000009.hts','RTIS2001')
% %   % For testing
%      filepath='/Users/kcs762/Box/KACEY/Data/RTIS2001/metria/trunkfree';
%      filename='/2001tf_final_00000011.hts';
%      partid='RTIS2001';
filepath='F:\usr\Ana Maria\OneDrive - Northwestern University\Data\TACS\Data\MetriaPPSDataJass4821\test4821';
filename='trial2';
partid='test4821';


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
load(fullfile(filepath,filename));
x = data.met;
x = x(:,3:end); %omitting time and the camera series number
x(x==0)=NaN; %h Replace zeros with NaN
[nimag,nmark]=size(x);
nmark=(nmark)/8;

% ACT-3D data saved
% Column 1 period in s
% Column 2-4 hand position (3rd MCP) in m
% Column 5-7 robot.endEffectorPosition in m
% Column 8 robot.endEffectorRotation(1) in rad;
% Column 9-11 robot.endEffectorVelocity in m/s;
% Column 12-14 robot.endEffectorForce in N;
% Column 15-17 robot.endEffectorTorque in Nm;
%  Load in the act3d data to compare with metria
% % Build the time vector
% t=x(:,1)-x(1,1);
tact=[0;cumsum(data.act(:,1))];
% xactee =(data.act(:,5:7)-repmat(setup.exp.origin',length(xactee),1))*1000; % Convert to mm
xactee =data.act(:,5:7)*1000; % Convert to mm
% xee = xact(:,5);
% yee = xact(:,6);
% zee = xact(:,7);
xactha=data.act(:,2:4)*1000; % Convert to mm
% xhnd = xact(:,2);
% yhnd = xact(:,3);
% zhnd = xact(:,4);

% th =xact(:,8); % for rotation to compute 3rd MCP
xactth =data.act(:,8); % end effector rotation

% Hand position was incorrect in data collected up to 4/22/21. Recalculate
% based on end effector position and end effector rotation
% Also note that data collected on Jass had incorrect e2h and ee2e lengths,
% hence the negative sign in front

p=zeros(3,length(xactee));
for i=1:length(xactee)
    p(:,i)=xactee(i,:)'+rotz(xactth(i))*[-(setup.exp.e2hLength-setup.exp.ee2eLength)*10 0 0]';
end
p=p';

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


%% METRIA DATA
% Load setup file
load(fullfile(filepath,[partid '_Setup']))

%% Extract Metria trunk, arm, forearm, hand marker position
% markerid=[Trunk Shoulder Arm Forearm ]
% setup.markerid=[80 19 87 73];
     myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
    myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
    myhandles.met.markerid=[80 19 87 73 237]; %added pointer tool in 237
   
[ridx,cidx]=find(x==setup.markerid(4)); fidx =cidx(1)+1; xfore=x(:,fidx:(fidx+6));  
[ridx,cidx]=find(x==setup.markerid(3)); aidx =cidx(1)+1; xarm=x(:,aidx:(aidx+2)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshldr=x(:,sidx:(sidx+2)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1)+1;
xtrunk=x(:,tidx:(tidx+2)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end

%% Compute the BL in the global CS using P_LCS 
lcsfore=zeros(2*nimag,2);
for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(circshift(xfore(i,4:7),1,2));
    Tftom(1:3,4) = xfore(i,1:3)';
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
%     BLg=Tftom *setup.bl.lcs{4}(:,4);  % grabbing the XYZ point of the 3rd metacarpal in the LCS and 
   % BLg=Tftom *[setup.bl{4}(4,1:3) 1]';  % grabbing the XYZ point of the 3rd metacarpal in the LCS and 
   BLg=Tftom *[bl{4}(4,1:3) 1]'; 
   xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time
    % lcsfore=[lcsx lcsy]
    lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2);
%     % for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1]; 
%     BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows
%     are time
%     disp(Tftom)
%     disp(setup.bl{4}(4,1:3)')
%     disp(BLg)
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
 
figure(1), clf
p1=plot([xhand(:,1) xshldr(:,1) xtrunk(:,1) xfore(:,1) xarm(:,1)],[xhand(:,2) xshldr(:,2) xtrunk(:,2) xfore(:,2) xarm(:,2)],'LineWidth',2); hold on
% p1=plot(-[xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2); hold on
hold on
p2=plot(gca,nanmean([xhand(1:10,1) xshldr(1:10,1) xtrunk(1:10,1) xfore(1:10,1) xarm(1:10,1)]),nanmean([xhand(1:10,2) xshldr(1:10,2) xtrunk(1:10,2) xfore(1:10,2) xarm(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');
% p3 = plot([xee*1000 xhnd*1000],[yee*1000 yhnd*1000],'LineWidth',4);  % added to add act 3d data
% p3 = plot([xactee(:,1) xactha(:,1)],[xactee(:,2) xactha(:,2)],'LineWidth',4);  % added to add act 3d data
p3 = plot([xactee(:,1) p(:,1)],[xactee(:,2) p(:,2)],'LineWidth',4);  % added to add act 3d data
p4=plot(gca,[setup.exp.hometar(1) setup.exp.shpos(1)]*1000,[setup.exp.hometar(2) setup.exp.shpos(2)]*1000,'o','MarkerSize',10,'MarkerFaceColor','r');


p5=quiver(gca,xfore([1 1 40 40],1),xfore([1 1 40 40],2),lcsfore([1 2 79 80],1),lcsfore([1 2 79 80],2),'LineWidth',2);
% p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
phandles=[p1; p2; p3; p4; p5];
% phandles=[p1' p2 p3];
axis 'equal'
% legend(phandles,'Hand','Shoulder','Trunk','Home','Max Reach')
xlabel('x (mm)')
ylabel('y (mm)')
legend(phandles,'MHand','MShoulder','MTrunk','MForearm','MArm','MHome','ACTEE','ACTHA','ACTHome','ForeCS');

% title(filename,'Interpreter','none')
%%
figure(2), clf
p1=plot(bl{4}(4,1),bl{4}(4,2),'o','MarkerSize',10,'MarkerFaceColor','g'); hold on
p2=plot(gca,bl{4}(4,9),bl{4}(4,10),'o','MarkerSize',10,'MarkerFaceColor','r');
% Tptr=quat2tform((bl{4}(4,5:8)));
% Tmkr=quat2tform((bl{4}(4,13:16)));
Tptr=quat2tform(circshift(bl{4}(4,5:8),1,2));
Tmkr=quat2tform(circshift(bl{4}(4,13:16),1,2));
% p3=quiver(gca,bl{4}(4,[1 1 9 9])',bl{4}(4,[2 2 10 10])',[Tptr(1,1:2)'; Tmkr(1,1:2)'],[Tptr(2,1:2)'; Tmkr(2,1:2)']);
p3=quiver(gca,bl{4}(4,[1 9])',bl{4}(4,[2 10])',[Tptr(1,1); Tmkr(1,1)],[Tptr(2,1); Tmkr(2,1)]);
p4=quiver(gca,bl{4}(4,[1 9])',bl{4}(4,[2 10])',[Tptr(1,2); Tmkr(1,2)],[Tptr(2,2); Tmkr(2,2)]);
legend([p1;p2;p3;p4],'BL','MarkerOrigin','LCSx','LCSy')
return

%% Compute the mean trunk position
mtpos=nanmean(xtrunk); 
stdtpos=nanstd(xtrunk); 
mspos=nanmean(xshldr);
stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach
% shtrdisp=sqrt(sum(([xshldr(mridx,:);xtrunk(mridx,:)]-[nanmean(xshldr(1:20,:));nanmean(xtrunk(1:20,:))]).^2,2))'

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



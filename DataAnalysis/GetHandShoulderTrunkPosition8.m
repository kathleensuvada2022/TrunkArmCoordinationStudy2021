 function [t,mridx,rdist,xhand,xshoulder,xtrunk,xshldr,xjug,maxreach,maxhandexcrsn,sh_exc,trunk_exc]=GetHandShoulderTrunkPosition8(filepath,filename,partid,setup,flag)
% Function to compute the hand and shoulder 3D position based on the Metria
% data. Have ACT3D Data as well. Currently does not plot anything- just
% computes marker positions. Plotted in 'PlotKinematicData6.'

load([filepath '/BL.mat'])
% load([filepath '/' partid,'_',setup])
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

load([filepath filename]);
x = data.met;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

t = (data.met(:,2)-data.met(1,2))/89; 

% %  Load in the act3d data to compare with metria
% actdata =data.act; 
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


% Right hand any data to correct for issue above... anyone after this date
% DO NOT NEED


% p=zeros(3,length(xactee));
% for i=1:length(xactee)
% if strcmp(setup.exp.arm,'right')
% %     p(:,i)=xactee(i,:)'+rotz(xactth(i))*[-(setup.exp.e2hLength-setup.exp.ee2eLength)*10 0 0]';
% else
%       p=xactee(i,:)'+rotz(-th)*[(setup.exp.e2hLength-setup.exp.ee2eLength)/100 0 0]'; % added by Kacey for left arm
% end
% 
% % end
% % p=p';


%%
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


% %for testing
% setup.markerid(4) = 73;
% setup.markerid(3) = 87;
% setup.markerid(2) = 19;
% setup.markerid(1) = 80;

[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xarm=x(:,aidx:(aidx+6)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshoulder=x(:,sidx:(sidx+ 6)); % extracting shoulder marker

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

%% Plot 3D Position of markers in computed ROOM coords 
% Tftom= zeros(4,4,nimag);
% Forearm_Room=zeros(4,4,nimag);
% rcsfore=zeros(2*nimag,2);
% for i=1:nimag % loop through time points
%     
% % For the 3rd metacarpal grabbing the forearm marker
%     Tftom(:,:,i) = quat2tform(circshift(xfore(i,4:7),1,2));
%     Tftom(1:3,4,i) = xfore(i,1:3)';% Transformation matrix for forearm in time i
% 
%    Forearm_Room(:,:,i) =(Tftom(:,:,i))*(HTrC'); % Now have forarm HT in room CS************
%     
% % % for the acromion using the shoulder marker 
% %      Tstom= quat2tform(circshift(xshoulder(i,4:7),1,2));% grabbing the HT of the shoulder marker 
% %      Tstom(1:3,4) = xshoulder(i,1:3)';
% %      
% %     Tstom =Tstom*(HTrC'); % Now have shoulder HT in room CS************
% % 
% % % for the jugular notch using the trunk marker 
% %      Tttom= quat2tform(circshift(xtrunk(i,4:7),1,2));% grabbing the HT of the shoulder marker 
% %      Tttom(1:3,4) = xtrunk(i,1:3)';
% %     Tttom =Tttom*(HTrC'); % Now have Trunk HT in room CS************
% 
% end



%% Compute the BL in the global CS 
%From MetriaKinDaq
% dig.bl{dig.currentSEG}(dig.currentBL,:) =[Ptip_RB' quat_pointer PRB_RB' quat_RB];
%Gives XYZ of pointer tool,quaterion of pointer marker in GCS, then the marker in LCS (this should always be about 001, then quaternion marker in GCS

% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

lcsfore=zeros(2*nimag,2);
for i=1:nimag % loop through time points
    
% For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(circshift(xfore(i,4:7),1,2));  %*****************
   Tftom(1:3,4) = xfore(i,1:3)';% Transformation matrix *************

      BLg=Tftom *[bl{4}(4,1:3) 1]'; 
      xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
      lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2); %what is this?

% for the acromion using the shoulder marker 
      Tstom= quat2tform(circshift(xshoulder(i,4:7),1,2));% *************
      Tstom(1:3,4) = xshoulder(i,1:3)'; %*************

     BLg2=(Tstom) *[bl{2}(2,1:3) 1]';  %grabbing the XYZ point of the anterior acromion in the LCS
     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of Acromion in the global frame and rows are time 

% for the jugular notch using the trunk marker 
      Tttom= quat2tform(circshift(xtrunk(i,4:7),1,2));%  ************* 
      Tttom(1:3,4) = xtrunk(i,1:3)';% *************
     
     BLg3=(Tttom) *[bl{1}(2,1:3) 1]';  %grabbing the XYZ point of the anterior acromion in the LCS
     xjug(i,:)=BLg3(1:3,1)'; % X Y Z of Jugular notch in the global frame and rows are time 
end



%% Compute reaching distance (between shoulder and hand from hand marker)
rdist=sqrt(sum((xhand(:,1:2)-xshldr(:,1:2)).^2,2));
[maxreach,mridx]=max(rdist);

%% Max Hand Excursion

%using original data
Xo_sh= nanmean(xshldr(1:5,1));
Yo_sh = nanmean(xshldr(1:5,2)); 



%dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
handex = sqrt((xhand(:,1)-Xo_sh).^2 +(xhand(:,2)-Yo_sh).^2);

maxhandexcrsn = max(handex);

%% 
% Compute the mean trunk position
% mtpos=nanmean(xtrunk); 
% stdtpos=nanstd(xtrunk); 
% mspos=nanmean(xshldr);
% stdspos=nanstd(xshldr);

% disp([mtpos stdtpos mspos stdspos])

%% Compute shoulder and trunk displacement at maximum reach - using BLS

  shtrdisp=sqrt(sum(([xshldr(mridx,:);xjug(mridx,:)]-[nanmean(xshldr(1:20,:));nanmean(xjug(1:20,:))]).^2,2))';
  
  sh_exc = shtrdisp(1) -shtrdisp(2);
  
  trunk_exc = shtrdisp(2);
    
 

%% Truncate data until max reach
% xhand=xhand(1:mridx,:);
%  xshldr=xshldr(1:mridx,:);%Using BL Acromion
%  xjug=xjug(1:mridx,:); %Using BL jug notch

%% Testing Forearm data and 3rd MCP position
% 
% 
% %For one frame
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %grabbing the HT of the forearm marker (used for creating the forearm
% %marker coordinate system)
% HTfore_global = quat2tform(xfore(:,4:7));
% 
% for i =1:length(HTfore_global)
% HTfore_global(1:3,4,i)=xfore(i,1:3);
% end
% 
% %Plotting CS for the forearm marker
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% for i = 1  % for one frame
% quiver(xfore(i,1),xfore(i,2),HTfore_global(1,1,i),HTfore_global(2,1,i))%for x axis
% 
% hold on
% quiver(xfore(i,1),xfore(i,2),HTfore_global(1,2,i),HTfore_global(2,2,i)) %for y axis
% 
% legend('x axis',' y axis')
% % xlim([20 45])
% % ylim([-20 5])
% end 
% 
% % Plot of 3rd MCP and forearm in GCS
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot(xfore(:,1),xfore(:,2),'g','LineWidth',2)
% hold on
% plot(xhand(:,1),xhand(:,2),'m','LineWidth',2)  
% legend('forearm','3rdMCP')
% axis equal
% 
% 
% %Plot of 3rd MCP and forearm CS 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:3
% quiver(xfore(i,1),xfore(i,2),HTfore_global(1,1,i),HTfore_global(2,1,i))%for x axis
% hold on
% quiver(xfore(i,1),xfore(i,2),HTfore_global(1,2,i),HTfore_global(2,2,i)) %yaxis
% 
% hold on
% plot(xhand(i,1),xhand(i,2),'*','LineWidth',2)  
% legend('X axis Forearm','Y axis Forearm','3rd MCP')
% 
% end
% 
% 

 end
 
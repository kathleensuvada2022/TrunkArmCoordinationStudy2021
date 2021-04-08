<<<<<<< Updated upstream
% load in a given trial (load in that data)
%load in BL in LCS
%load in setup 

function  PlotGCS(datafile,bl,setup)
%%  Loading in data for one frame for one trial 

%load(datafile)
metdata=datafile.data.met; %whole data matrix all frames

%saving for one frame - all marker data present 

endtrial =200;
x= metdata(1:endtrial,:);
%% Loading in the data from the BL file (P_RB) 

%extracting the BLS from each rigid body 
Bl_forearm =bl.bl{1,4};
Bl_trunk = bl.bl{1,1};
Bl_shoulder = bl.bl{1,2};
Bl_humerus = bl.bl{1,3};

% Forearm
%BLs for forearm in LCS of the RGB marker
Forearm_points = Bl_forearm(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Forearm_marker = Bl_forearm(1,9:11); %only grabbing first row since all same (0,0,0)

%Trunk
%BLs for Trunk in LCS of the RGB marker
Trunk_points = Bl_trunk(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Trunk_marker = Bl_trunk(1,9:11);%only grabbing first row since all same (0,0,0)


%Shoulder
%BLs for shoulder in LCS of the RGB marker
Shoulder_points = Bl_shoulder(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Shoulder_marker = Bl_shoulder(1,9:11);%only grabbing first row since all same (0,0,0)


%Humerus
%BLs for shoulder in LCS of the RGB marker
Humerus_points = Bl_humerus(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Humerus_marker = Bl_humerus(1,9:11);%only grabbing first row since all same (0,0,0)
%% Sorting the data by the marker ID  (HTRB_G)


%forearm columns and rows where RGB marker ID is present 
     
%Forearm
[ridx,cidx]=find(x==setup.markerid(4));  
fidx =cidx(1);

xfore=x(:,fidx:(fidx+7));

%Humerus
[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1);

xarm=x(:,aidx:(aidx+7));

%Shoulder
[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1);

xshldr=x(:,sidx:(sidx+ 7)); 

%Trunk
[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1);

xtrunk=x(:,tidx:(tidx+7)); 

%% Transforming the Quaternion organization to the HT 

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
%% Getting Pointer Tip in GCS = HTRB_G*Pmcp_RB


%Calculate position of 3rd MCP in GCS with forearm marker on for all frames
P_global=zeros(4,1,endtrial);
for i =1:endtrial
P_global(:,:,i)= HT_fore(:,:,i)*([Forearm_points(4,:) 1]');
end 
%just grabbing xyz
P_global =P_global(1:3,:,:);

%grabbing xyz point in global cs of forearm,trunk and shoulder marker for all frames
Forarmmarker_global = HT_fore(1:3,4,:);
Trunkmarker_global =HT_trunk(1:3,4,:);
Shouldermarker_global = HT_shldr(1:3,4,:);
for i=1:endtrial
plot3(P_global(1,1,i),P_global(2,1,i),P_global(3,1,i),'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
%text(P_global(1,1,1),P_global(2,1,1),P_global(3,1,1),'3rd MCP','FontSize',13)
hold on
 plot3(Forarmmarker_global(1,1,i),Forarmmarker_global(2,1,i),Forarmmarker_global(3,1,i),'-o')
%text(Forarmmarker_global(1,1,1),Forarmmarker_global(2,1,1),Forarmmarker_global(3,1,1),'Forearm Marker','FontSize',13')
%plot3(Trunkmarker_global(1,1,i),Trunkmarker_global(2,1,i),Trunkmarker_global(3,1,i),'*')
%text(Trunkmarker_global(1,1,1),Trunkmarker_global(2,1,1),Trunkmarker_global(3,1,1),'Trunk Marker','FontSize',13')
%plot3(Shouldermarker_global(1,1,i),Shouldermarker_global(2,1,i),Shouldermarker_global(3,1,i),'*')
%text(Shouldermarker_global(1,1,20),Shouldermarker_global(2,1,20),Shouldermarker_global(3,1,1),'Shoulder Marker','FontSize',13')
set(gca,'XColor', 'none','YColor','none','ZColor','none')
% xlabel('X position in mm','FontSize', 14)
ylabel('X position in mm','FontSize', 14)
zlabel('Y position in mm','FontSize', 14)
title('Trunk, Shoulder, and 3rd MCP Trajectory in Global CS -Control','FontSize', 16)
end

% 
% 
% t = 0:pi/20:10*pi;
% xt = sin(t);
% yt = cos(t);
% plot3(xt,yt,t,'-o','Color','b','MarkerSize',10,'MarkerFaceColor','#D9FFFF')
%%

end

=======
% load in a given trial (load in that data)
%load in BL in LCS
%load in setup 

function  PlotGCS(data,bl,setup)
%%  Loading in data for one frame for one trial 

metdata=data.met; %whole data matrix all frames

%saving for one frame - all marker data present 

endtrial =15;
x= metdata(1:endtrial,:);
%% Loading in the data from the BL file (P_RB) 

%extracting the BLS from each rigid body 
Bl_forearm =bl{1,4};
Bl_trunk = bl{1,1};
Bl_shoulder = bl{1,2};
Bl_humerus = bl{1,3};

% Forearm
%BLs for forearm in LCS of the RGB marker
Forearm_points = Bl_forearm(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Forearm_marker = Bl_forearm(1,9:11); %only grabbing first row since all same (0,0,0)

%Trunk
%BLs for Trunk in LCS of the RGB marker
Trunk_points = Bl_trunk(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Trunk_marker = Bl_trunk(1,9:11);%only grabbing first row since all same (0,0,0)


%Shoulder
%BLs for shoulder in LCS of the RGB marker
Shoulder_points = Bl_shoulder(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Shoulder_marker = Bl_shoulder(1,9:11);%only grabbing first row since all same (0,0,0)


%Humerus
%BLs for shoulder in LCS of the RGB marker
Humerus_points = Bl_humerus(:,1:3); %Rows are each BL and column is XYZ
%grabbing XYZ of the RGB marker
Humerus_marker = Bl_humerus(1,9:11);%only grabbing first row since all same (0,0,0)
%% Sorting the data by the marker ID  (HTRB_G)


%forearm columns and rows where RGB marker ID is present 
     
%Forearm
[ridx,cidx]=find(x==setup.markerid(4));  
fidx =cidx(1);

xfore=x(:,fidx:(fidx+7));

%Humerus
[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1);

xarm=x(:,aidx:(aidx+7));

%Shoulder
[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1);

xshldr=x(:,sidx:(sidx+ 7)); 

%Trunk
[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1);

xtrunk=x(:,tidx:(tidx+7)); 

%% Transforming the Quaternion organization to the HT 

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
%% Getting Pointer Tip in GCS = HTRB_G*Pmcp_RB


%Calculate position of 3rd MCP in GCS with forearm marker on for all frames
P_global=zeros(4,1,endtrial);
for i =1:endtrial
P_global(:,:,i)= HT_fore(:,:,i)*([Forearm_points(4,:) 1]');
end 
%just grabbing xyz
P_global =P_global(1:3,:,:);

%grabbing xyz point in global cs of forearm marker for all frames
Forarmmarker_global = HT_fore(1:3,4,:);
for i=1:endtrial
plot3(P_global(1,1,i),P_global(2,1,i),P_global(3,1,i),'o')
text(P_global(1,1,1),P_global(2,1,1),P_global(3,1,1),'3rd MCP','FontSize',13)
hold on
plot3(Forarmmarker_global(1,1,i),Forarmmarker_global(2,1,i),Forarmmarker_global(3,1,i),'*')
text(Forarmmarker_global(1,1,1),Forarmmarker_global(2,1,1),Forarmmarker_global(3,1,1),'Forearm Marker','FontSize',13')
xlabel('X position in mm','FontSize', 14)
ylabel('Y position in mm','FontSize', 14)
title('Forearm Marker and 3rd MCP in Global CS')
end


%%

end

>>>>>>> Stashed changes

% load in a given trial (load in that data)

function  PlotGCS(inputArg1,inputArg2)
%%  Loading in data for one frame for one trial 

metdata=data.met; %whole data matrix all frames

%saving for one frame
x= metdata(27,:);

%% Sorting the data by the marker ID


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


end


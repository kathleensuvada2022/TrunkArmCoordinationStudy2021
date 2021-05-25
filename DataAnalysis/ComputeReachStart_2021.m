%% COMPUTEREACHSTART

% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

% function [dist,vel,timestart,timevelmax]=ComputeReachStart_NRSA(flpath,filename)

function [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_2021(actdata,metdata,setup,g)

%% Loading in ACT3D Data


% Xpos = actdata(:,2);
% Ypos = actdata(:,3);
% Zpos = actdata(:,4);
% 
% Xvel = actdata(:,9);
% Yvel = actdata(:,10);
% Zvel = actdata(:,11);

%% Loading in Metria Data

x = metdata;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

% Creating Variables for Hand, Trunk Shoulder, Forearm, and Humerus
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
xtrunk=x(:,tidx:(tidx+6)); 
lcsfore=zeros(2*nimag,2);

%% Computing 3rd MCP position from forearm 
for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(circshift(xfore(i,4:7),1,2));
    Tftom(1:3,4) = xfore(i,1:3)';% Transformation matrix for forearm in time i
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
%      BLg=(Tftom)*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and
%        BLg = Tftom*(bl{1,4}(4,1:4))';
%       BLg=Tftom *[bl{4}(4,1:3) 1]'; From GetHandShoulderTrunkPosition8
 
      BLg=Tftom *setup.bl.lcs{1,4}(1:4,4) ; %changed from BL file 
      xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
      lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2);
% for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1]; 
%     BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
end



%% Finding Distance and Vel -- Updated May 2021 for Metria Data 

Xo = nanmean(xhand(1:50,1));
Yo = nanmean(xhand(1:50,2)); 
Zo = nanmean(xhand(1:50,3)); 

%Computing Velocity from hand position
Xvel = diff(xhand(:,1));
Yvel = diff(xhand(:,2));
Zvel = diff(xhand(:,3));

Xov = nanmean(Xvel(1:50));
Yov = nanmean(Yvel(1:50)); 
Zov = nanmean(Zvel(1:50)); 

dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);

vel = sqrt((Xvel-Xov).^2 +(Yvel-Yov).^2 + (Zvel-Zov).^2);

t = length(vel)/ 50; % time in seconds sampling rate of metria? 250 samples in 5 seconds
t = 0:.02:5;
t = t(2:end);

idx=zeros(1,4); % creating variable with the indices of vel and distance for ACT3D
idx(1) = find(vel>.05,1); % start reaching 

% idx(1) = i(1); 


% [vpks,vlocs] = findpeaks(vel(idx(1):end)); vlocs=vlocs+idx(1)-1;
% [~,idx(2)] = max(vel); %max vel
% idx(2)=vlocs(1); %finding the first peak as the max vel

maxvel =max(vel);
idx(2)= find(vel==maxvel);


%Yielded odd results 
% [dpks,dlocs] = findpeaks(dist(idx(1):end)); dlocs=dlocs+idx(1)-1;
% % [~,idx(3)] = max(dist(idx(2)+1:end)); % idx3 max reach
% idx(3)=dlocs(1); %Finding first peak of max distance
% rdist=dpks(1);

%Finding Max dist
maxdist= max(dist);
idx(3)= find(dist==maxdist);

idx(4)=idx(2)+3; % Mark end of movement 0.5s after max velocity

%sampling rate of act 3d - 50 HZ

% start time in seconds 
timestart = idx(1)*(1/50);% sampling rate of ACT 50 samples/sec
timevelmax = idx(2)*(1/50); % time when max velocity
timedistmax = idx(3) *(1/50); %when at max dist
timebefore = timestart-.05; %time 50 ms prior to start of reach
ibefore = ceil(timebefore*50); 
timeend = idx(4)*(1/50);
%% Plotting Data 

Muscles = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'}

figure()
subplot(3,3,2)
%ax = axes('position',[0.12,0.75,0.75,0.22]);
%plot(t(1:50),dist(1:50))
plot(t(1:249),dist(1:249))
hold on
plot(t(1:249),vel)
%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach


p1 = line('Color','b','Xdata',[timestart timestart],'LineWidth',1); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'LineWidth',1); % max vel
p3= line('Color','c','Xdata',[timedistmax timedistmax],'LineWidth',1); %max dist
p4= line('Color','g','Xdata',[timeend timeend],'LineWidth',1); %endreach

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))


xlabel('time')
ylabel('Distance/ Velocity') 
legend('Distance', 'Velocity','Start Reach','Max Velocity','Max Dist',' End of Reach')
title(Muscles(g))


end 
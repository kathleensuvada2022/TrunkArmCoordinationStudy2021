%% COMPUTEREACHSTART

% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

% function [dist,vel,timestart,timevelmax]=ComputeReachStart_NRSA(flpath,filename)

function [dist2,vel2,t2,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_2021(metdata,setup)

%% Loading in ACT3D Data
%Use if plotting ACT3D data
% 
% Xpos = actdata(:,2);
% Ypos = actdata(:,3);
% Zpos = actdata(:,4);
% 
% Xvel = actdata(:,9);
% Yvel = actdata(:,10);
% Zvel = actdata(:,11);

%% Loading in Metria Data
% Sampling Rate for Metria is 89 HZ

t = (metdata(:,2)-metdata(1,2))/89;


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
 
      BLg=Tftom *setup.bl{1,4}(1:4,4) ; %changed from BL file 
      xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
      lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2);
% for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1]; 
%     BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
end

%% Resampling Xhand 

[xhand2,t2]=resampledata(xhand,t,100,89); %updated July 2021 


%% Finding Distance and Vel -- Updated May 2021 for Metria Data 

%using original data
Xo= nanmean(xhand(1:50,1));
Yo = nanmean(xhand(1:50,2)); 
Zo = nanmean(xhand(1:50,3)); 

dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
dist = dist(:)-dist(1); %offsetting so not starting above 0

%using Resampled Data
Xo = nanmean(xhand2(1:50,1));
Yo = nanmean(xhand2(1:50,2)); 
Zo = nanmean(xhand2(1:50,3)); 

dist2 =sqrt((xhand2(:,1)-Xo).^2 +(xhand2(:,2)-Yo).^2 + (xhand2(:,3)-Zo).^2);
dist2 = dist2(:)-dist2(1);

% Computing Velocity and resampling 
vel = ddt(smo(dist,3),1/89);
[vel2,t2] = resampledata(vel,t,100,89);


%% Finding Time Points 

idx=zeros(1,4); % creating variable with the indices of vel and distance for ACT3D
idx(1) = find(vel2>250,1); % start reaching 


%Finding Max Vel
 maxvel =max(vel2);
 idx(2)= find(vel2==maxvel);

%Finding Max dist
maxdist= max(dist2);
idx(3)= find(dist2==maxdist);

% Start Time 
timestart = idx(1)*(1/89);% divide by sampling rate
timevelmax = idx(2)*(1/89); % time when max velocity
timedistmax = idx(3) *(1/89); %when at max dist
% timebefore = timestart-.05; %time 50 ms prior to start of reach
timebefore =1;
timeend = timedistmax+2;
%ibefore = ceil(timebefore*50); 
%timeend = idx(4)*(1/1000);
%% Plotting Data 

figure(2)
clf
 subplot(3,1,1)
%ax = axes('position',[0.12,0.75,0.75,0.22]);
%plot(t(1:50),dist(1:50))
 plot(t2,dist2)
hold on
plot(t2,vel2) 
%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach



p1 = line('Color','b','Xdata',[timestart timestart],'Ydata',[min(vel2) max(vel2)], 'LineWidth',.5); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[min(vel2) max(vel2)],'LineWidth',.5); % max vel
p3= line('Color','c','Xdata',[timedistmax timedistmax],'Ydata',[min(vel2) max(vel2)],'LineWidth',.5); %max, dist
%p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
%p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))

xlim([0.5 5])

xlabel('time in seconds')
ylabel('Distance/ Velocity') 
legend('Distance', 'Velocity','Time Start','Max Vel','Max Dist')
% %title(Muscles(g))


end 
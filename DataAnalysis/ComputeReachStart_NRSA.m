%% COMPUTEREACHSTART

% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

% function [dist,vel,timestart,timevelmax]=ComputeReachStart_NRSA(flpath,filename)

function [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_2021(actdata,metdata,g)

% load([flpath '/' filename]);




Xpos = actdata(:,2);
Ypos = actdata(:,3);
Zpos = actdata(:,4);

Xvel = actdata(:,9);
Yvel = actdata(:,10);
Zvel = actdata(:,11);

Xo = mean(Xpos(1:50));
Yo = mean(Ypos(1:50)); 
Zo = mean(Zpos(1:50)); 


Xov = mean(Xvel(1:50));
Yov = mean(Yvel(1:50)); 
Zov = mean(Zvel(1:50)); 

dist = sqrt((Xpos-Xo).^2 +(Ypos-Yo).^2 + (Zpos-Zo).^2);
vel = sqrt((Xvel-Xov).^2 +(Yvel-Yov).^2 + (Zvel-Zov).^2);

t = length(vel)/ 50; % time in seconds
t = 0:.02:5;
t = t(2:end);

idx=zeros(1,4); % creating variable with the indices of vel and distance for ACT3D
idx(1) = find(vel>.05,1); % start reaching 

% idx(1) = i(1); 
[vpks,vlocs] = findpeaks(vel(idx(1):end)); vlocs=vlocs+idx(1)-1;
% [~,idx(2)] = max(vel); %max vel
idx(2)=vlocs(1); %finding the first peak as the max vel

%Yielded odd results 
% [dpks,dlocs] = findpeaks(dist(idx(1):end)); dlocs=dlocs+idx(1)-1;
% % [~,idx(3)] = max(dist(idx(2)+1:end)); % idx3 max reach
% idx(3)=dlocs(1); %Finding first peak of max distance
% rdist=dpks(1);

%Finding Max dist
maxdist= max(dist);
idx(3)= find(dist==maxdist);

idx(4)=idx(3)+3; % Mark end of movement 0.5s after max reac

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
plot(t,dist)
% hold on
plot(t,vel)
%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  %plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach
p1 = line('Color','b','Xdata',[timestart timestart],'LineWidth',.5); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'LineWidth',.5); % max vel
p3= line('Color','c','Xdata',[timedistmax timedistmax],'LineWidth',.5); %max dist
p4= line('Color','g','Xdata',[timeend timeend],'LineWidth',.5); %endreach

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))


xlabel('time')
ylabel('Distance/ Velocity') 
legend('Distance', 'Velocity','Start Reach','Max Velocity','Max Dist',' End of Reach')
title(Muscles(g))


end 
%% COMPUTEREACHSTART

% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

function [dist,vel,timestart]=ComputeReachStart_NRSA(flpath,filename)

load([flpath '/' filename]);


Xpos = cell2mat(trialData(3,2:end));
Ypos = -cell2mat(trialData(4,2:end));
Zpos = cell2mat(trialData(5,2:end));

Xvel = cell2mat(trialData(6,2:end));
Yvel = -cell2mat(trialData(7,2:end));
Zvel = cell2mat(trialData(8,2:end));


Xo = mean(Xpos(1:50));
Yo = mean(Ypos(1:50)); 
Zo = mean(Zpos(1:50)); 


Xov = mean(Xvel(1:50));
Yov = mean(Yvel(1:50)); 
Zov = mean(Zvel(1:50)); 

dist = sqrt((Xpos-Xo).^2 +(Ypos-Yo).^2 + (Zpos-Zo).^2);
vel = sqrt((Xvel-Xov).^2 +(Yvel-Yov).^2 + (Zvel-Zov).^2);

ivel = find(vel ==max(vel));


i = find(vel>.1);
istart = i(1);

% for i = 1:length(dist)
%     if dist(i)>= .02
%     istart= i
%     break;
%     else 
%     continue;
%     end    
% end 

%sampling rate of act 3d - 50 HZ

% start time in seconds 
timestart = istart*(1/50);% sampling rate of ACT 50 samples/sec
timevelmax = ivel*(1/50); % time when max velocity
timebefore = timestart-.05; %time 50 ms prior to start of reach
ibefore = ceil(timebefore*50); 


% % computing emg activation 
% figure(1)
% hold on
% title(' ACT 3D Plot Reach ') 
% xlabel('X Position Meters')
% ylabel('Y Position Meters')
% plot(Xpos,Ypos)
% plot(Xpos(istart),Ypos(istart),'-o')
% % plot(istart,Ypos(istart),'-o')
% % hold off
% 
%  figure(2)
% plot(dist)
% hold on
% plot(vel)
% plot(istart,dist(istart),'-o')
% %plot(ivel,dist(ivel),'-o')
% %plot(ibefore,dist(ibefore),'-o')
% xlabel('time')
% ylabel('3D Distance/ Velocity') 
% legend('Distance','Velocity','Start Reach','Max Velocity','50 ms Before Reach')
% title('3D Distance and Velocity During Reach')
% 
% % 

end 
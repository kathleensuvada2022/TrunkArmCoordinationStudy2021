%% COMPUTEREACHSTART
% NEW 
% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

% AMA 5/1/20 Fix algorithm so that it marks whatever happens first: the max reach timepoint
% or the point when velocity goes back to zero as the point where the max
% reach happened.

function [dist,vel,time,rdist,t]=ComputeReachStart4(flpath,filename)

load([flpath '/' filename]);

cp = cell2mat(trialData(2,2:end));
t = cumsum([0 cp]);t(end)=[];


idx = zeros(1,4);
Xpos = cell2mat(trialData(3,2:end));
Ypos = -cell2mat(trialData(4,2:end));
Zpos = cell2mat(trialData(5,2:end));

Xvel = cell2mat(trialData(6,2:end));
Yvel = -cell2mat(trialData(7,2:end));
Zvel = cell2mat(trialData(8,2:end));


% Xo = mean(Xpos(1:50));
% Yo = mean(Ypos(1:50)); 
% Zo = mean(Zpos(1:50)); 

Xo = Xpos(1);
Yo = Ypos(1); 
Zo = Zpos(1); 


% Xov = mean(Xvel(1:50));
% Yov = mean(Yvel(1:50)); 
% Zov = mean(Zvel(1:50)); 
Xov = 0;
Yov = 0; 
Zov = 0; 

dist = sqrt((Xpos-Xo).^2 +(Ypos-Yo).^2 + (Zpos-Zo).^2);
vel = sqrt((Xvel-Xov).^2 +(Yvel-Yov).^2 + (Zvel-Zov).^2);

% i = find(vel>.07);
% idx(1) = i(1);
% idx(2) = find(vel ==max(vel));
% [~,idx(3)] = max(dist(idx(2)+1:end));
% idx_4 = find(vel(idx(2)+1:end) <.01);
% % disp([idx_4(1) idx])
% 
% idx(3)=idx(3)+idx(2);
% if isempty(idx_4)
%     idx(4) = idx(2)+50; % 1 second later or approximately 50 samples/s
%     if idx(4)>length(t), idx(4)=length(t); end
% else
%     idx(4) = idx_4(1)+idx(2);    
% end
% % idx(3)= 108;
% rdist = dist(idx(4));
% disp(idx)

idx=zeros(1,4);
idx(1) = find(vel>.07,1); % start reaching 

% idx(1) = i(1); 
[vpks,vlocs] = findpeaks(vel(idx(1):end)); vlocs=vlocs+idx(1)-1;
% [~,idx(2)] = max(vel); %max vel
idx(2)=vlocs(1);
[dpks,dlocs] = findpeaks(dist(idx(1):end)); dlocs=dlocs+idx(1)-1;
% [~,idx(3)] = max(dist(idx(2)+1:end)); % idx3 max reach
rdist=dpks(1);
idx(3)=dlocs(1);
idx(4)=idx(3)+3; % Mark end of movement 0.5s after max reach

time = t(idx); 
% 
% figure(1)
% title(' ACT 3D Plot Reach ') 
% xlabel('X Position Meters')
% ylabel('Y Position Meters')
% plot(-Xpos,-Ypos,Xo,Yo,'r',-Xpos(idx(1:4)),-Ypos(idx(1:4)),'o')
% text(-Xpos(idx(1:4))',-Ypos(idx(1:4)),{'1-Start','2-MaxV','3-MaxR','4-EndM'})
% % hold off
% 
% figure(2)
% 
% plot(t,dist,t(idx(1:4)),dist(idx(1:4)),'o')
% text(t(idx(1:4)),dist(idx(1:4)),{'1','2','3','4'})
% ylabel('Distance') 
% yyaxis right 
% plot(t,vel,t(idx(1:4)),vel(idx(1:4)),'o')
% text(t(idx(1:4)),vel(idx(1:4)),{'1','2','3','4'})
% ylabel('Velocity') 
% xlabel('time')

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
% 
% %timestart = istart*(1/50);% sampling rate of ACT 50 samples/sec
% timevelmax = ivel*(1/50); % time when max velocity
% timebefore = timestart-.05; %time 50 ms prior to start of reach
% ibefore = ceil(timebefore*50); 

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
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


% "t" is the actual time vector for the act3d in seconds "time" is the time
% in seconds for 1) reach start 2) max velocity 3) max reach 4) end of
% movement 
function [dist,vel,time,rdist,t]=ComputeReachStart5(flpath,filename)

load([flpath filename]);

actdata = data.act;

% ACT-3D data saved
% Column 1 period in s
% Column 2-4 hand position (3rd MCP)
% Column 5-7 robot.endEffectorPosition
% Column 8 robot.endEffectorRotation(1);
% Column 9-11 robot.endEffectorVelocity;
% Column 12-14 robot.endEffectorForce;
% Column 15-17 robot.endEffectorTorque;


 t= actdata(:,1); %actual time stops at 5 seconds for length of trial
 % don't need to divide by 50 why dividing by 0????

% idx = zeros(1,4);
% Xpos = cell2mat(trialData(3,2:end));
% Ypos = -cell2mat(trialData(4,2:end));
% Zpos = cell2mat(trialData(5,2:end));
% 
% Xvel = cell2mat(trialData(6,2:end));
% Yvel = -cell2mat(trialData(7,2:end));
% Zvel = cell2mat(trialData(8,2:end));


%  Xpos = actdata(:,5);
%  Ypos = actdata(:,6);
%  Zpos = actdata(:,7);


Xpos = actdata(:,2);
Ypos = actdata(:,3);
Zpos = actdata(:,4);

Xvel = actdata(:,9);
Yvel = actdata(:,10);
Zvel = actdata(:,11);


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

idx=zeros(1,4); % creating variable with the indices of vel and distance 
idx(1) = find(vel>.07,1); % start reaching 

% idx(1) = i(1); 
[vpks,vlocs] = findpeaks(vel(idx(1):end)); vlocs=vlocs+idx(1)-1;
% [~,idx(2)] = max(vel); %max vel
idx(2)=vlocs(1); %finding the first peak as the max vel
[dpks,dlocs] = findpeaks(dist(idx(1):end)); dlocs=dlocs+idx(1)-1;
% [~,idx(3)] = max(dist(idx(2)+1:end)); % idx3 max reach
idx(3)=dlocs(1);
rdist=dpks(1);
% idx_4 = find(vel(idx(2)+1:end) <.01); % idx 4 end of movement
% 
% t_idx = [idx(1) idx(2)]; %creates the indices where the reach starts and the max vel is
% 
% % disp([idx_4(1) idx])
% 
% idx(3)=idx(3)+idx(2);
% if isempty(idx_4)
%     idx(4) = idx(2)+50; % 1 second later or approximately 50 samples/s
%     if idx(4)>length(t), idx(4)=length(t); end
% else
%     idx(4) = idx_4(1)+idx(2);    
% end
% idx(3)= 108; % For RTIS2001???
idx(4)=idx(3)+3; % Mark end of movement 0.5s after max reach
% [maxreach,idx(5)]=max(dist);

% rdist = dist(idx(4));
% disp(idx)
 
time = t(idx); % t0 in other function - actual time in seconds version of idx



% time = t_idx/50;

% for i = 1:length(dist)
%     if dist(i)>= .02
%     istart= i;
%     break;
%     else 
%     continue;
%     end    
% end 

%sampling rate of act 3d - 50 HZ

% start time in seconds 
% 

% timestart = istart*(1/50);% sampling rate of ACT 50 samples/sec
 
% ivel = idx(2);
% timevelmax = ivel*(1/50); % time when max velocity
% timebefore = timestart-.05; %time 50 ms prior to start of reach
% ibefore = ceil(timebefore*50); 



% Shows trace above with trajectory for reach 
% figure(1)
% title(' ACT 3D Plot Reach ') 
% xlabel('X Position Meters')
% ylabel('Y Position Meters')
% plot(-Xpos,-Ypos,Xo,Yo,'r',-Xpos(idx(1:4)),-Ypos(idx(1:4)),'o')
% text(-Xpos(idx(1:4))',-Ypos(idx(1:4)),{'1-Start','2-MaxV','3-MaxR','4-EndM'})
% % hold off
% 


% using this plot to confirm maxes
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
% % legend('Distance','Velocity','Start Reach','Max Velocity','50 ms Before Reach')
% % title('3D Distance and Velocity During Reach')
% 
% % 

end 
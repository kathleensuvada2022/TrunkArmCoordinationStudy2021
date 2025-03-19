%% COMPUTEREACHSTART

% Script for computing where the reach begins for participant  

% Testing 
%   flpath = '/Users/kcs762/Desktop/Strokedata/Control1/act3d/trunkrestrained/AllData'
%filepath = 'D:\usr\Ana Maria Acosta\OneDrive - Northwestern University\Data\TACS\Data';
partid = 'RTIS2001';
%load(fullfile(filepath,partid,[partid '_setup.mat'])); %load setup file 

%    filename = 'Target_01_2_table.mat'

% needs act 3d file path and file name 

% function [dist,vel,timestart,timevelmax]=ComputeReachStart_NRSA(flpath,filename)

% function [dist,vel,timestart,timevelmax,timeend,timedistmax,distold]=ComputeReachStart_2021(actdata,metdata,setup,g)

%% Load ACT3D Data
%load(fullfile(filepath,partid,'trials2'))

%%
actdata=data.act;
x= data.met;

%Use if plotting ACT3D data
% 
tact = actdata(:,1);
Xpos_act = actdata(:,2);
Ypos_act = actdata(:,3);
Zpos_act = actdata(:,4);

Xvel_act = actdata(:,9);
Yvel_act = actdata(:,10);
Zvel_act = actdata(:,11);

%% Loading in Metria Data
% Sampling Rate for Metria is 89 HZ

%uncomment this section is using 

tmet = (x(:,2)-x(1,2))/89;

% x = metdata;
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

% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};


for i=1:nimag % loop through time points
    
% Forearm 

    % For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(circshift(xfore(i,4:7),1,2));  %*****************
    Tftom(1:3,4) = xfore(i,1:3)';% Transformation matrix *************
    
    BLg=Tftom *[bl{4}(4,1:3) 1]'; %Grabbing 3rd MCP
    xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time
%     lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2); 


end

%% Resampling Xhand 

[xhand2,tmet2]=resampledata(xhand,tmet,100,89);



%% Plotting YPos from Metria (not resampled) with Time Vector

figure
plot(tmet,xhand(:,2)/1000,'linewidth',2)
hold on
plot(tmet,-Ypos_act,'linewidth',2)
plot(tact,-Ypos_act,'linewidth',2)
legend('Metria','ACT with Metria Time','ACT with ACT Time')

emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
%%
% EMG
plot(data.daq{1,1},data.daq{1,2}(:,13:14))






%% Grabbing start,end,and max vel
dist = NNMF_allConds_Filtered(1).dist; 
emg = NNMF_allConds_Filtered(1).FiltEMG;
vel = NNMF_allConds_Filtered(1).vel;
XYZMET = SelectedCond(k).xyzmet;
idxmetriastart = NNMF_allConds_Filtered(1).idx_metriastart; % At trial 1
idxmetriaend = NNMF_allConds_Filtered(1).idx_metriaend;

%Max vel index
maxvel = max(vel(idxmetriastart:idxmetriaend,1));
ans=find(vel==maxvel);
Cond1(k).MaxVel = maxvel;
idxmetriamaxvel =ans;
% 


x_all = XYZMET(1,:);
y_all = XYZMET(2,:);
z_all = XYZMET(3,:);
x1 = XYZMET(1,idxmetriastart);
y1 = XYZMET(2,idxmetriastart);
x2 = XYZMET(1,idxmetriaend);
y2 = XYZMET(2,idxmetriaend);

XYdistnew = sqrt((x_all-x1).^2+(y_all-y1).^2);

% idxmetria= SelectedCond(k).idx_metria;
tmet = SelectedCond(k).tmet;
temg = SelectedCond(k).emgtimevec;


% Correcting - KINEMATICS
timestart = idxmetriastart/100;
timedistmax = idxmetriaend/100;
timevelmax = idxmetriamaxvel/100;


timestart_EMG = timestart-.05;% Times for EMG (subtracting 50 ms)
timedistmax_EMG = timedistmax-.05;% Times for EMG (subtracting 50 ms)
timevelmax_EMG = timevelmax-.05;% Times for EMG (subtracting 50 ms)
timeAPA = timestart_EMG - .075; % 75 ms prior to movement onset therefore with 25 ms window still in APA interval
timeaccelphase = mean([timestart_EMG,timevelmax_EMG]);

ACCidx_EMG = timeaccelphase*1000; % EMG index for Acceleration phase
APAidx_EMG= timeAPA*1000; % EMG index APA

%% EMG Data 
maxEMG = NNMFstruc(1).emgMaxes;
sampRate=1000;
avgwindow=0.050; ds=sampRate*avgwindow;
nEMG=size(emg,2);
t=(0:size(emg,1)-1)/sampRate; 
avgwindow=0.050; ds=sampRate*avgwindow;

emg = emg-repmat(mean(emg(1:250,:)),length(emg),1); %removes baseline

emgrect= abs(emg);
emgrectnew=emgrect(:,1:15)./maxEMG(ones(length(emgrect(:,1:15)),1),:);
meanEMG=movmean(emgrectnew,ds);

idx1=[1:2:7 9:12]; idx2=[2:2:8 13:15];

nEMG=length(idx1);
memg=max([max(emg(:,idx1));[max(emg(:,idx2)) 0]]);
yspacing=cumsum([0 memg(2:nEMG)+.9]);
yrange = 0:1;

cleandata=emgrectnew;
cleandata2=emg;




%% Plotting Data 

Muscles = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'}

figure()
subplot(3,3,2)
%ax = axes('position',[0.12,0.75,0.75,0.22]);
%plot(t(1:50),dist(1:50))
 plot(t,dist)
hold on
plot(t,vel) 
%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach

p1 = line('Color','b','Xdata',[timestart timestart],'Ydata',[-500 500], 'LineWidth',.5); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[-500 500],'LineWidth',.5); % max vel
p3= line('Color','c','Xdata',[timedistmax timedistmax],'Ydata',[-500 500],'LineWidth',.5); %max, dist
p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))

xlim([0.5 5])

xlabel('time in seconds')
ylabel('Distance/ Velocity') 
legend('Distance', 'Velocity','Start Reach','Max Velocity','Max Dist','Time Prior','Time End')
title(Muscles(g))

function [y,ty]=resampledata(x,t,fs,fsnew)
% compute slope and offset (y = a1 x + a2)
[nr,nc]=size(x);
for i=1:nc
    a(1) = (x(end,i)-x(1,i)) / (t(end)-t(1));
    a(2) = x(1,i);
    
    % detrend the signal
    xdetrend = x(:,i) - polyval(a,t);
    [ydetrend,ty] = resample(xdetrend,t,fsnew,10,fs);
    
    if i==1, y=zeros(length(ty),nc); end
    
    y(:,i) = ydetrend + polyval(a,ty);
end
end

% end 
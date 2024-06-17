% May 2022 K. Suvada
% June 2024 K. Suvada 

% Process_PPS: Function used to process pressure mat data. PlotKinematicdata6 calls
% this function so can plot with main analysis code. For stroke
% participants, always had Mat2 on the seat. Check data collection sheets
% to confirm and especially for controls.

% Updated May 2022- Main function for PPS that calls other PPS functions
% for processing and plotting.

% May 2024- Note each element is 1" apart. 

% INPUTS:
% - ppsdata: data matrix of pressure values.
% - tpps: Time vector via PPS
% - t_start: starting time of the reach (seconds)
% - t_end: ending time of the reach (seconds)
% - hand: which hand reaching with
% - partid: participant ID
% - mtrial_Num: The current trial number not the ACTUAL number but the
% trial counter for the current condition. Checking if it's the first
% one for the set.
% - sm and sm2: are the small plots - after setting these axes first trial,
% keep them as output variables so can plot next trial's traces.

%OUTPUTS:
% - sm and sm2: are the small plots - after setting these axes first trial,
% keep them as output variables so can plot next trial's traces.



function [sm sm2] = Process_PPS(ppsdata,tpps,t_start,t_end,hand,partid,mtrial_Num,filename,expcond, sm,sm2)

%Loading in PPS baseline file

% K. Suvada 2024: Flow for the PPS Data Collection code is as follows : 
% When the PPS Box is checked on the GUI -->  PPS_Init_Callback: creates PPS object, calls InitializePPS 
% (which runs StartPPS, ReadData after 3 seconds, ppsSetBaseline, ppsStop, then saves file in that order). 
% Then back in PPS_Init_Callback, ppsStart is called and left running to avoid the issue of the elements 
% having to re-stabilize once in trial data. So yes, the mats have been torn prior to trials and therefore 
% trial data will not reflect participant weights. It will still be able to track the changes however, which 
% is what I am interested in. So I only need to subtract the first 250 ms of the trial prior to them starting the reach.

% In other words, for processing your actual data, you don't need the
% baseline file as this is zeroing the mat prior to the trial.

%For PC
%datafilepath = ['C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\','\',partid,'\',hand];
% %%
%For MAC
% datafilepath = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data','/',partid,'/',hand];
% load(fullfile(datafilepath, 'pps_baseline.mat')); %load setup file
% baseline_mat1 = data(:,1:256);
% baseline_mat2 = data(:,257:end); % Mat on seat  
% baseline_t = t;
%
% %Averaging Across the Interval
% avg_interval = size(baseline_mat2,1)/2;
% avg_interval = round(avg_interval);
% %
% baseline_mat1_corrected = mean(baseline_mat1(avg_interval:end,:));

 % Average Value per element (1x 256) - cutting such that it's when the
 % elements have stabilized 
% baseline_mat2_corrected = mean(baseline_mat2(avg_interval:end,:));

% % Replacing Negative Values with 0s 
% if any(baseline_mat1_corrected < 0)
%     baseline_mat1_corrected(baseline_mat1_corrected < 0) = 0;
% end
% 
% if any(baseline_mat2_corrected < 0)
%     baseline_mat2_corrected(baseline_mat2_corrected < 0) = 0;
% end


% Figure 15 shows average value for each element during baseline (this is prior to
% Mat being zeroed bc it is read before calling library 'SetBaseline'.

%
% subplot(2,1,1)
% plot(baseline_mat2)
% title('Mat 2- baseline','FontSize',20)
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% subplot(2,1,2)
% plot(baseline_mat2_corrected ,'o')
% title('Mat 2- Average/Element (Stable Interval)','FontSize',20)
% xlabel('Element','FontSize',16)
% ylabel('PSI','FontSize',16)

%
% figure()
% subplot(2,1,1)
% plot(baseline_mat1)
% title('Mat 1- baseline','FontSize',20)
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% subplot(2,1,2)
% plot(baseline_mat1_corrected,'o')
% title('Mat 1- Average/Element (Stable Interval)','FontSize',20)
% xlabel('Element','FontSize',16)
% ylabel('PSI','FontSize',16)
%
%% Finding start/stop samples for each mat
% Mat 1 SR = 13.5 Hz  Mat 2 SR = 14 Hz

start_samp_M1= round(t_start*13.5);
end_samp_M1= round(t_end*13.5);

start_samp_M2= round(t_start*14);
end_samp_M2= round(t_end*14);


%% Removing Tare BaseLine From Trial Data

pps_mat2_trial = ppsdata(:,257:512);

% pps_mat2_trial_minustare = pps_mat2_trial- baseline_mat2_corrected;

pps_mat1_trial = ppsdata(:,1:256);

% pps_mat1_trial_minustare = pps_mat1_trial- baseline_mat1_corrected;

%% Trial Data Minus the Tarebaseline - WRONG Don't USE. See Comment at top of function

% % Should see positive values and the participant's weight
% 
% figure()
% plot(pps_mat2_trial_minustare)
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% title('MAT 2: TareBaselineAVG Removed','FontSize',20)
% % 
% % pause
% % 
% figure()
% plot(pps_mat1_trial_minustare)
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% title('MAT 1: TareBaselineAVG Removed','FontSize',20)
% % 
%  pause
%%
% Raw Data Baseline and Trial
% figure()
% subplot(4,1,1)
% plot(data(:,1:256))
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% title('Mat 1: Raw Baseline Data ','FontSize',20)
% subplot(4,1,2)
% plot(data(:,257:512))
% xlabel('Samples','FontSize',16)
% ylabel('PSI','FontSize',16)
% title('Mat2: Raw Baseline Data ','FontSize',20)
figure()
subplot(2,1,1)
plot(ppsdata(:,1:256))
xlabel('Samples','FontSize',16)
ylabel('PSI','FontSize',16)
title('Mat 1: Raw Trial Data ','FontSize',20)
subplot(2,1,2)
plot(ppsdata(:,257:512))
xlabel('Samples','FontSize',16)
ylabel('PSI','FontSize',16)
title('Mat 2: Raw Trial Data','FontSize',20)
pause
%%

% Seeing How Many Elements are Negative - most likely due to seat cushion
% or noise if negative
Negs = ppsdata(ppsdata<0);
NumElmPPSData = size(ppsdata,1)*size(ppsdata,2);

PercentNegElements_BothMatsRaw = length(Negs)/NumElmPPSData *100;

%% Subtracting Baseline (First 5 samples) from Trial Data

pps_mat1 = ppsdata(:,1:256); %just the raw data
pps_mat2 = ppsdata(:,257:512); %just the raw data

%Negs_M1 = pps_mat1(pps_mat1<0);
%NumElmPPSData_M1 = size(pps_mat1,1)*size(pps_mat1,2);

%PercentNegElements_M1 = length(Negs_M1)/NumElmPPSData_M1*100;

% Mat 1 (Chair Back)
% pps_mat1_FINAL = pps_mat1_trial_minustare-mean(pps_mat1_trial_minustare(1:4,:)); % subtracting first 250 ms of trial

pps_mat1_FINAL = pps_mat1 - mean(pps_mat1(1:5,:));
%Mat 2 (Seat)
% pps_mat2_FINAL = pps_mat2_trial_minustare-mean(pps_mat2_trial_minustare(1:4,:)); % subtracting first 250 ms of trial
pps_mat2_FINAL = pps_mat2 - mean(pps_mat2(1:5,:));
%% Plotting Mat 2 minus the first 250 ms (with the TareBaseline ALSO removed) 

figure()
subplot(2,1,1)
plot(pps_mat1_FINAL)

ylabel('PSI','FontSize',16)
xlabel('Samples','FontSize',16)
% xline(start_samp_M1,'g','LineWidth',2)
% xline(end_samp_M1,'r','LineWidth',2)
title('Mat 1(Back): TRIAL DATA FINAL','FontSize',20)

subplot(2,1,2)
% plot(pps_mat2_FINAL(start_samp_M2:end_samp_M2,:))
plot(pps_mat2_FINAL)

ylabel('PSI','FontSize',16)
xlabel('Samples','FontSize',16)
% xline(start_samp_M2,'g','LineWidth',2)
% xline(end_samp_M2,'r','LineWidth',2)
title('Mat 2 (Seat): TRIAL DATA FINAL','FontSize',20)

pause

%% 
% if strcmp(partid,'RTIS2002') && strcmp(hand,'Left') && expcond ==3
%     % For the artifact along bottom of mat
%     pps_mat1(:,1:16) = 0;
%     
% end 
% if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
%     % For the artifact along bottom of mat
%     pps_mat1(:,26) = 0;
%     
% end 

% Negs_M2 = pps_mat2(pps_mat2<0);
% NumElmPPSData_M2 = size(pps_mat2,1)*size(pps_mat2,2);
% 
% PercentNegElements_M2 = length(Negs_M2)/NumElmPPSData_M2*100
% pause



%% Calling Small Multiples Function

if mtrial_Num~= 1
    [sm,sm2] = PPS_timeseriesPlots(pps_mat1_FINAL,pps_mat2_FINAL,tpps,start_samp_M1,end_samp_M1,start_samp_M2,end_samp_M2,mtrial_Num,sm,sm2);
else
    [sm,sm2] = PPS_timeseriesPlots(pps_mat1_FINAL,pps_mat2_FINAL,tpps,start_samp_M1,end_samp_M1,start_samp_M2,end_samp_M2,mtrial_Num);
end


return

%% Number of Frames
nframes=size(ppsdata,1);

%% Calculating COP for Both Mats (Not Hemi COP for Each Mat)
% elements 1" apart
% rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
% CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
% CoP1(:,2) = 16- CoP1(:,2);
%
% CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2]; % mat 2
% CoP2(:,2) = 16- CoP2(:,2);

%%
%%%%%%%%%% Mat 1%%%%%%%%%%% - back of seat
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Matrices for Left and Right Half of Mat 1
% *Note: Left/Right is PARTICIPANT'S left and right.

Mat1_RightHalf = pps_mat1(:,[1:8 17:24 33:40 49:56 65:72 81:88 97:104 113:120 129:136 145:152 161:168 177:184 193:200 209:216 225:232 241:248]);
Mat1_LeftHalf= pps_mat1(:,[9:16 25:32 41:48 57:64 73:80 89:96 105:112 121:128 137:144 153:160 169:176 185:192 201:208 217:224 233:240 249:256]);

rm=repmat((0:15)'+0.5,1,8); rm=rm'; rm=rm(:);

   % Calling COP function for Right Half of Mat 1 - set flag to 1 if want to
% plot
CoP_Mat1_RightHalf = ComputeCoP(Mat1_RightHalf,repmat((0:7)+0.5,nframes,16),repmat(rm',nframes,1),nframes,128);

% Calling COP function for Left Half of Mat 1
CoP_Mat1_LeftHalf = ComputeCoP(Mat1_LeftHalf,repmat((0:7)+0.5,nframes,16),repmat(rm',nframes,1),nframes,128);


rm_whole=repmat((0:15)'+0.5,1,16); rm_whole=rm_whole'; rm_whole=rm_whole(:); % Use for both mats
%
% Whole Mat COP X and Y Position over time 
CoP_Mat1_Whole = ComputeCoP(pps_mat1,repmat((0:15)+0.5,nframes,16),repmat(rm_whole',nframes,1),nframes,256);
% 
%% Omitting COP Data that Deviates too much from the first few samples - Mat1
% 
% CoP_Mat1_RightHalf = CleanupCOP(CoP_Mat1_RightHalf,start_samp_M1,end_samp_M1,filename,partid,hand,expcond); %Right Half
% CoP_Mat1_LeftHalf = CleanupCOP(CoP_Mat1_LeftHalf,start_samp_M1,end_samp_M1,filename,partid,hand,expcond); % Left Half
% CoP_Mat1_Whole = CleanupCOP(CoP_Mat1_Whole,start_samp_M1,end_samp_M1,filename,partid,hand,expcond); % Whole Mat
% 


%%
%%%%%%%%%% Mat 2%%%%%%%%%%% - seat of chair 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating Matrices for Left and Right Half of Mat 2
% *Note: Left/Right is PARTICIPANT'S left and right.

Mat2_RightHalf = pps_mat2(:,[1:8 17:24 33:40 49:56 65:72 81:88 97:104 113:120 129:136 145:152 161:168 177:184 193:200 209:216 225:232 241:248]);
Mat2_LeftHalf= pps_mat2(:,[9:16 25:32 41:48 57:64 73:80 89:96 105:112 121:128 137:144 153:160 169:176 185:192 201:208 217:224 233:240 249:256]);


% Calling COP function for Right Half of Mat 2 - set flag to 1 if want plot
CoP_Mat2_RightHalf = ComputeCoP(Mat2_RightHalf,repmat((0:7)+0.5,nframes,16),repmat(rm',nframes,1),nframes,128);

% Calling COP function for Left Half of Mat 2
CoP_Mat2_LeftHalf = ComputeCoP(Mat2_LeftHalf,repmat((0:7)+0.5,nframes,16),repmat(rm',nframes,1),nframes,128);



% Whole Mat COP
CoP_Mat2_Whole = ComputeCoP(pps_mat2,repmat((0:15)+0.5,nframes,16),repmat(rm_whole',nframes,1),nframes,256);


%% Omitting COP Data that Deviates too much from the first few samples - Mat2

% CoP_Mat2_RightHalf = CleanupCOP(CoP_Mat2_RightHalf,start_samp_M2);
% CoP_Mat2_LeftHalf = CleanupCOP(CoP_Mat2_LeftHalf,start_samp_M2);
% CoP_Mat2_Whole = CleanupCOP(CoP_Mat2_Whole,start_samp_M2); % Whole Mat


%% Reorganizing data Matrix to Create Orientation of both Mats - for HeatMap

% Mat1
% need to reshape to be a 16x16 where we have Nframes matrices
Pressuremat1R_frame= zeros(16,8,nframes);
Pressuremat1L_frame= zeros(16,8,nframes);

for i=1:nframes
    Pressuremat1R_frame(:,:,i) =flipud(reshape(Mat1_RightHalf(i,:),[8,16])'); %corresponds to layout of mat (see figure from PPS)
    Pressuremat1L_frame(:,:,i) =flipud(reshape(Mat1_LeftHalf(i,:),[8,16])');
end

% Full Mat
Pressuremat1_frame= zeros(16,16,nframes);


for i=1:nframes
    Pressuremat1_frame(:,:,i) =flipud(reshape(pps_mat1(i,:),[16,16])'); %corresponds to layout of mat (see figure from PPS)
    
end
Pressuremat1_frame(15,7,:) = 0; 

% Mat2
% need to reshape to be a 16x16 where we have Nframes matrices
Pressuremat2R_frame= zeros(16,8,nframes);
Pressuremat2L_frame= zeros(16,8,nframes);

for i=1:nframes
    Pressuremat2R_frame(:,:,i) =flipud(reshape(Mat2_RightHalf(i,:),[8,16])'); %corresponds to layout of mat (see figure from PPS)
    Pressuremat2L_frame(:,:,i) =flipud(reshape(Mat2_LeftHalf(i,:),[8,16])');
end

% Full Mat
Pressuremat2_frame= zeros(16,16,nframes);


for i=1:nframes
    Pressuremat2_frame(:,:,i) =flipud(reshape(pps_mat2(i,:),[16,16])'); %corresponds to layout of mat (see figure from PPS)
    
end

%%%%%%%%%% Plotting Trajectories Mat 1 and Mat 2 Together%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Print out Delta COP
 DeltaCOP_right  = sqrt((CoP_Mat1_RightHalf(end_samp_M1,1)-CoP_Mat1_RightHalf(start_samp_M1,1))^2 +(CoP_Mat1_RightHalf(end_samp_M1,2)-CoP_Mat1_RightHalf(start_samp_M1,2))^2);             
 DeltaCOP_left  = sqrt((CoP_Mat1_LeftHalf(end_samp_M1,1)-CoP_Mat1_LeftHalf(start_samp_M1,1))^2 +(CoP_Mat1_LeftHalf(end_samp_M1,2)-CoP_Mat1_LeftHalf(start_samp_M1,2))^2);       
 
 % Convert to cm
 DeltaCOPMat1_whole = sqrt((CoP_Mat1_Whole(end_samp_M1,1)-CoP_Mat1_Whole(start_samp_M1,1))^2 +(CoP_Mat1_Whole(end_samp_M1,2)-CoP_Mat1_Whole(start_samp_M1,2))^2  )  *2.54  
 DeltaCOPMat2_whole = sqrt((CoP_Mat2_Whole(end_samp_M2,1)-CoP_Mat2_Whole(start_samp_M2,1))^2 +(CoP_Mat2_Whole(end_samp_M2,2)-CoP_Mat2_Whole(start_samp_M2,2))^2  )    *2.54


 pause 

if strcmp(partid,'RTIS2001') && strcmp(hand,'Right') 
    if strcmp(filename,'/trial5.mat') || strcmp(filename,'/trial13.mat') || strcmp(filename,'/trial14.mat') || strcmp(filename,'/trial25.mat')
  
    CoP_Mat1_RightHalf(end_samp_M1,1) = nan;
    CoP_Mat1_RightHalf(end_samp_M1,2) = nan;
    CoP_Mat1_RightHalf(start_samp_M1,1) = nan;
    CoP_Mat1_RightHalf(start_samp_M1,2) = nan;
      
% elseif isnan(DeltaCOP_left) 
    CoP_Mat1_LeftHalf(end_samp_M1,1) = nan;
    CoP_Mat1_LeftHalf(end_samp_M1,2) = nan;
    CoP_Mat1_LeftHalf(start_samp_M1,1) = nan;
    CoP_Mat1_LeftHalf(start_samp_M1,2) = nan;
       
% elseif isnan(DeltaCOP_whole)
    CoP_Mat1_Whole(start_samp_M1,1) = nan;
    CoP_Mat1_Whole(start_samp_M1,2) = nan;
    CoP_Mat1_Whole(end_samp_M1,1) = nan;
    CoP_Mat1_Whole(end_samp_M1,2) = nan;
    end
end

if strcmp(partid,'RTIS2002') && strcmp(hand,'Left') 
    if strcmp(filename,'/trial13.mat') ||strcmp(filename,'/trial1.mat') || strcmp(filename,'/trial2.mat') || strcmp(filename,'/trial4.mat') || strcmp(filename,'/trial6.mat') || strcmp(filename,'/trial7.mat') || strcmp(filename,'/trial9.mat')  || strcmp(filename,'/trial10.mat')
  
    CoP_Mat1_RightHalf(end_samp_M1,1) = nan;
    CoP_Mat1_RightHalf(end_samp_M1,2) = nan;
    CoP_Mat1_RightHalf(start_samp_M1,1) = nan;
    CoP_Mat1_RightHalf(start_samp_M1,2) = nan;
      
% elseif isnan(DeltaCOP_left) 
    CoP_Mat1_LeftHalf(end_samp_M1,1) = nan;
    CoP_Mat1_LeftHalf(end_samp_M1,2) = nan;
    CoP_Mat1_LeftHalf(start_samp_M1,1) = nan;
    CoP_Mat1_LeftHalf(start_samp_M1,2) = nan;
       
% elseif isnan(DeltaCOP_whole)
    CoP_Mat1_Whole(start_samp_M1,1) = nan;
    CoP_Mat1_Whole(start_samp_M1,2) = nan;
    CoP_Mat1_Whole(end_samp_M1,1) = nan;
    CoP_Mat1_Whole(end_samp_M1,2) = nan;
    end
end

%           pause


%% Trajectory of COP Mats 1 and 2                
% Mat 1
figure(6)
% subplot(1,3,1)
%  h1 = plot(CoP_Mat1_RightHalf(start_samp_M1: end_samp_M1,1),CoP_Mat1_RightHalf(start_samp_M1: end_samp_M1,2),'LineWidth',2);
hold on
xlabel('Postion in X','FontSize',16)
ylabel('Position in Y','FontSize',16)
% yl = ylim;
% xl= xlim;
% rangex = (xl(2)-xl(1));
% rangey = (yl(2)-yl(1));
% % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )

% c1= viscircles([CoP_Mat1_RightHalf(start_samp_M1,1),CoP_Mat1_RightHalf(start_samp_M1,2)],.08,'Color','g');
% c2= viscircles([CoP_Mat1_RightHalf(end_samp_M1,1),CoP_Mat1_RightHalf(end_samp_M1,2)],.08,'Color','r');

% p1 = [CoP_Mat1_RightHalf(start_samp_M1,1) CoP_Mat1_RightHalf(start_samp_M1,2)]
% p2 = [CoP_Mat1_RightHalf(end_samp_M1,1) CoP_Mat1_RightHalf(end_samp_M1,2)]
% h1 = plot([ p1(1) p2(1)], [p1(2) p2(2)],'LineWidth',2);
%  
% set(h1,'Color',[0.4660 0.6740 0.1880]);
% title('RTIS2002(P): Back of Chair-COP Tracking','Fontsize',16)

%  h2 = plot(CoP_Mat1_LeftHalf(start_samp_M1: end_samp_M1,1)+8,CoP_Mat1_LeftHalf(start_samp_M1: end_samp_M1,2),'LineWidth',2);


hold on
% c1= viscircles([CoP_Mat1_LeftHalf(start_samp_M1,1)+8,CoP_Mat1_LeftHalf(start_samp_M1,2)],.08,'Color','g');
% c2= viscircles([CoP_Mat1_LeftHalf( end_samp_M1,1)+8,CoP_Mat1_LeftHalf( end_samp_M1,2)],.08,'Color','r');


% p1 = [CoP_Mat1_LeftHalf(start_samp_M1,1)+8 CoP_Mat1_LeftHalf(start_samp_M1,2)]
% p2 = [CoP_Mat1_LeftHalf(end_samp_M1,1)+8 CoP_Mat1_LeftHalf(end_samp_M1,2)]
% h2 = plot([ p1(1) p2(1)], [p1(2) p2(2)],'LineWidth',2);set(h2,'Color',[0.4940 0.1840 0.5560]);

 h5 = plot(CoP_Mat1_Whole(start_samp_M1: end_samp_M1,1),CoP_Mat1_Whole(start_samp_M1: end_samp_M1,2),'k','LineWidth',2);
c1= viscircles([CoP_Mat1_Whole(start_samp_M1,1),CoP_Mat1_Whole(start_samp_M1,2)],.08,'Color','g');
c2= viscircles([CoP_Mat1_Whole( end_samp_M1,1),CoP_Mat1_Whole( end_samp_M1,2)],.08,'Color','r');

% p1 = [CoP_Mat1_Whole(start_samp_M1,1) CoP_Mat1_Whole(start_samp_M1,2)]
% p2 = [CoP_Mat1_Whole(end_samp_M1,1) CoP_Mat1_Whole(end_samp_M1,2)]
% h5 = plot([ p1(1) p2(1)], [p1(2) p2(2)],'LineWidth',2);
% 
%
% set(h5,'Color','c');

% xline(5);
% xline(10);
% legend('Right COP','Left COP','Whole Mat COP','Fontsize',14)

xlim([0 16])
ylim([0 16])
title('Mat 1 COP','FontSize',20)

%% Heat Map
% for p = start_samp_M1: end_samp_M2
%     figure(7)
%     clf
% 
%     imagesc(Pressuremat1_frame(:,:,p),[min(min(pps_mat1(start_samp_M1: end_samp_M1,:))) max(max(pps_mat1(start_samp_M1: end_samp_M1,:)))])
% 
%     set(gca,'yticklabel',[])
%     
%     
%     colorbar
%     caxis([min(min(pps_mat1(start_samp_M1: end_samp_M1,:))) max(max(pps_mat1(start_samp_M1: end_samp_M1,:)))])
% 
%     
% 
%     title(['Back Mat' ' ' 'frame' ' '  num2str(p)])
% 
%     pause(.25)
% end

%%


% Mat 2
figure(8)
% h3 = plot(CoP_Mat2_RightHalf(start_samp_M2: end_samp_M2,1),CoP_Mat2_RightHalf(start_samp_M2: end_samp_M2,2),'LineWidth',2);
% hold on
% xlabel('Postion in X','FontSize',14)
% ylabel('Position in Y','FontSize',14)

% hold on
% c1= viscircles([CoP_Mat2_RightHalf(start_samp_M2,1),CoP_Mat2_RightHalf(start_samp_M2,2)],.05,'Color','g');
% c2= viscircles([CoP_Mat2_RightHalf(end_samp_M2,1),CoP_Mat2_RightHalf(end_samp_M2,2)],.05,'Color','r');
% set(h3,'Color',[0.4660 0.6740 0.1880]);
% title('COP Tracking Mat 2-Seat of Chair','Fontsize',16)

% h4 = plot(CoP_Mat2_LeftHalf(start_samp_M2: end_samp_M2,1)+8,CoP_Mat2_LeftHalf(start_samp_M2: end_samp_M2,2),'LineWidth',2);
% xlabel('Postion in X','FontSize',14)
% ylabel('Position in Y','FontSize',14)
% 
% hold on
% c1= viscircles([CoP_Mat2_LeftHalf(start_samp_M2,1)+8,CoP_Mat2_LeftHalf(start_samp_M2,2)],.05,'Color','g');
% c2= viscircles([CoP_Mat2_LeftHalf( end_samp_M2,1)+8,CoP_Mat2_LeftHalf( end_samp_M2,2)],.05,'Color','r');
% set(h4,'Color',[0.4940 0.1840 0.5560]);

% h6 = plot(CoP_Mat2_Whole(start_samp_M2: end_samp_M2,1),CoP_Mat2_Whole(start_samp_M2: end_samp_M2,2),'LineWidth',2);
c1= viscircles([CoP_Mat2_Whole(start_samp_M2,1),CoP_Mat2_Whole(start_samp_M2,2)],.05,'Color','g');
c2= viscircles([CoP_Mat2_Whole( end_samp_M2,1),CoP_Mat2_Whole( end_samp_M2,2)],.05,'Color','r');
% set(h6,'Color',[0.6350 0.0780 0.1840]);

% legend('Right Side COP','Left Side COP','Whole Mat COP','Fontsize',14)

xlim([0 16])
ylim([0 16])


% Heat Map for Mat 2 

% for p = start_samp_M1: end_samp_M2
%     
%     figure(9)
%     clf
%     
%     %     subplot(1,2,1)
%     imagesc(Pressuremat2_frame(:,:,p),[min(min(pps_mat2(start_samp_M1: end_samp_M2))) max(max(pps_mat2(start_samp_M1: end_samp_M2)))])
%     set(gca,'yticklabel',[])
%     
%     colorbar
%     caxis([min(min(pps_mat2(start_samp_M1: end_samp_M2))) max(max(pps_mat2(start_samp_M1: end_samp_M2)))])
%     
%     title(['Seat Mat' ' ' 'frame' ' '  num2str(p)])
%     
%     
%     
%     %     subplot(1,2,2)
%     %     imagesc(Pressuremat2L_frame(:,:,p))
%     %     set(gca,'yticklabel',[])
%     %
%     %     colorbar
%     %     caxis([min(min(Mat2_LeftHalf)) max(max(Mat2_LeftHalf))])
%     %
%     %     title(['Left Half' ' ' 'frame' ' '  num2str(p) ' ' 'COPL' ' ' num2str(CoP2_left(p,:)) ])
%     %
%     
%     pause(1)
%     
% end

%pause

%close all




return

%% Manually Filtering out artifact bands(not best method) - May 2022 with Heatmap
% Kept incase useful later but not adaptable and participant specific methods.

% % RTIS2003- Paretic : artifacts in columns. Finds columns where 2x average and sets
% % to 0.
%  if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
% %if strcmp(partid,'RTIS2003')
%     avg_mat1 = zeros(nframes,16);
%     avg_mat2 = zeros(nframes,16);
%     for p = 1: nframes
%
%         % Pressure mat 1
%         avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(p,:));
%
%         Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));
%
%         if isempty(Artifact_Cols)
%         else
%             Pressuremat1_frame(:,Artifact_Cols,p) =nan;
%         end
%
%         % Pressure mat 2
%         avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
%         Abs_avg_mat2(p) = mean(avg_mat2(p,:));
%
%         Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));
%
%         if isempty(Artifact_Cols)
%
%         else
%             Pressuremat2_frame(:,Artifact_Cols,p) =nan;
%
%         end
%     end
%
%  end
%
%  if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
%
%     avg_mat1 = zeros(nframes,16);
%     avg_mat2 = zeros(nframes,16);
%     for p = 1: nframes
%
%         % Pressure mat 1
%         avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(p,:));
%
%         Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));
%
%         if isempty(Artifact_Cols)
%         else
%             Pressuremat1_frame(:,Artifact_Cols,p) =nan;
%         end
%     end
%     % Pressure mat 2
%
%
%     Pressuremat2_frame(:,6,:) =nan;
%
% end
%
%
%
%
%
% if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
%     avg_mat1 = zeros(nframes,16);
%     avg_mat2 = zeros(nframes,16);
%     for p = 1: nframes
%
%         % Pressure mat 1
%         avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(p,:));
%
%         Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));
%
%         if isempty(Artifact_Cols)
%         else
%             Pressuremat1_frame(:,Artifact_Cols,p) =nan;
%         end
%
%         % Pressure mat 2
%         avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
%         Abs_avg_mat2(p) = mean(avg_mat2(p,:));
%
%         Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));
%
%         if isempty(Artifact_Cols)
%
%         else
%             Pressuremat2_frame(:,Artifact_Cols,p) =nan;
%
%         end
%     end
% end
%
% if strcmp(partid,'RTIS2009') && strcmp(hand,'Right')
%     avg_mat1 = zeros(nframes,16);
%     avg_mat2 = zeros(nframes,16);
%     for p = 1: nframes
%
%         % Pressure mat 1
%         avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(p,:));
%
%         Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));
%
%         if isempty(Artifact_Cols)
%         else
%             Pressuremat1_frame(:,Artifact_Cols,p) =nan;
%         end
%
%         % Pressure mat 2
%         avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
%         Abs_avg_mat2(p) = mean(avg_mat2(p,:));
%
%         Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));
%
%         if isempty(Artifact_Cols)
%
%         else
%             Pressuremat2_frame(:,Artifact_Cols,p) =nan;
%
%         end
%     end
% end
%  if strcmp(partid,'RTIS2009') && strcmp(hand,'Left') %Horizontal Bar Artifacts
% %     avg_mat1 = zeros(16,nframes);
% %     avg_mat2 = zeros(16,nframes);
%     for p = 1: nframes
%
%         % Pressure mat 1
% %         avg_mat1(:,p) = mean(Pressuremat1_frame(:,:,p),2); % Average of each column across all time nframes X 16 cols
% %         Abs_avg_mat1(p) = mean(avg_mat1(:,p));
% %
% %         Artifact_Cols = find (avg_mat1(:,p) > 2*Abs_avg_mat1(p));
%
% %         if isempty(Artifact_Cols)
% %         else
%             Pressuremat1_frame(9,:,p) =nan; % Needed to manually do
%             Pressuremat1_frame(4,:,p) =nan; % Needed to manually do
% %         end
%
% %         % Pressure mat 2
% %         avg_mat2(:,p) = mean(Pressuremat2_frame(:,:,p),2); % Average of each column
% %         Abs_avg_mat2(p) = mean(avg_mat2(:,p));
% %
% %         Artifact_Cols = find (avg_mat2(:,p) > 2*Abs_avg_mat2(p));
% %
% %         if isempty(Artifact_Cols)
% %
% %         else
% %             Pressuremat2_frame(Artifact_Cols,:,p) =0;
% %
% %         end
%     end
% %    Pressuremat1_frame(:,:,:) = - Pressuremat1_frame(:,:,:);
%
% end
%
% if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
%     avg_mat1 = zeros(nframes,16);
%     avg_mat2 = zeros(nframes,16);
%     for p = 1: nframes
%
%         % Pressure mat 1
%         avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(p,:));
%
%         Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));
%
%         if isempty(Artifact_Cols)
%         else
%             Pressuremat1_frame(:,Artifact_Cols,p) =nan;
%         end
%
%         % Pressure mat 2
%         avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
%         Abs_avg_mat2(p) = mean(avg_mat2(p,:));
%
%         Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));
%
%         if isempty(Artifact_Cols)
%
%         else
%             Pressuremat2_frame(:,Artifact_Cols,p) =nan;
%
%         end
%     end
% end
%
%
% if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')
%     Pressuremat2_frame(4,:,:) =nan;
% end

%% Note: Everything below here is outdated and from 2021.
%  Kept incase useful later. Code for creating video, heatmap plots,
%  heatmap plots with altering the resolution.

%% Normal Scaling For Loop Plotting Pressure Data Mat 1 and 2
% %
% % %For video uncomment if needed
% %    %     v = VideoWriter('pps.avi');
% %   %      open(v);
% % figure(3), clf
% % % for i =1:nframes
% %     %
% %     subplot(2,1,1)
% %     %Mat 1
% %        imagesc(.5,.5,Pressuremat1_frame(:,:,i))
% %     hold on
% % %     plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
% %     title('Mat 1')
% %     colorbar
% %     % % %
% %     subplot(2,1,2)
% %     %Mat 2
% %       imagesc(.5,.5,Pressuremat2_frame(:,:,i))
% %     hold on
% %     plot(CoP2(i,1),CoP2(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
% %     title('Mat 2')
% % %     %
% % %               colormap(hot)
% % %               colormap(turbo)
% %     colorbar
% %     %
% %     %    %     frame = getframe(gcf);% for video uncomment if want
% %     %    %     writeVideo(v,frame);% for video uncomment if want
% %     %           pause(.1)
% %     %
% % end
% % % %    %      close(v); %for video uncomment if want
% % %
% % %
% %
% %
%
%
% %% Plotting the Center of Pressure Changes
%
% % Whole trial
% % figure(6)
% % subplot(2,1,1)
% % h1 = plot(CoP1(:,1)*10,CoP1(:,2)*10,'LineWidth',2);
% % hold on
% % xlabel('Postion in X (mm)','FontSize',16)
% % ylabel('Position in Y (mm)','FontSize',16)
% % yl = ylim;
% % xl= xlim;
% % rangex = (xl(2)-xl(1));
% % rangey = (yl(2)-yl(1));
% % % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
% % hold on
% % c1= viscircles([CoP1(1,1)*10,CoP1(1,2)*10],.01,'Color','g');
% % c2= viscircles([CoP1(end,1)*10,CoP1(end,2)*10],.01,'Color','r');
% % set(h1,'Color',[0 0.4470 0.7410]);
% % title('COP shifts for Mat1 ')
% % axis equal
% %
% % subplot(2,1,2)
% % hold on
% % h1 = plot(CoP2(:,1)*10,CoP2(:,2)*10,'LineWidth',2);
% % xlabel('Postion in X (mm)','FontSize',16)
% % ylabel('Position in Y (mm)','FontSize',16)
% % yl = ylim;
% % xl= xlim;
% % yl = ylim;
% % xl= xlim;
% % rangex = (xl(2)-xl(1));
% % rangey = (yl(2)-yl(1));
% % % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
% % hold on
% % c1= viscircles([CoP2(1,1)*10,CoP2(1,2)*10],.01,'Color','g');
% % c2= viscircles([CoP2(end,1)*10,CoP2(end,2)*10],.01,'Color','r');
% % set(h1,'Color',[0 0.4470 0.7410]);
% % title('COP shifts for Mat 2')
% % axis equal
%
%
% % Cut
% figure(6)
% subplot(2,1,1)
% h1 = plot(CoP1(start_samp_M1: end_samp_M2,1)*10,CoP1(start_samp_M1: end_samp_M2,2)*10,'LineWidth',2);
% hold on
% xlabel('Postion in X (mm)','FontSize',16)
% ylabel('Position in Y (mm)','FontSize',16)
% yl = ylim;
% xl= xlim;
% rangex = (xl(2)-xl(1));
% rangey = (yl(2)-yl(1));
% % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
% hold on
% c1= viscircles([CoP1(start_samp_M1,1)*10,CoP1(start_samp_M1,2)*10],.01,'Color','g');
% c2= viscircles([CoP1(end_samp_M2,1)*10,CoP1(end_samp_M2,2)*10],.01,'Color','r');
% set(h1,'Color',[0 0.4470 0.7410]);
% title('COP shifts for Mat1 ')
% axis equal
%
%
% subplot(2,1,2)
% hold on
% h1 = plot(CoP2(start_samp_M1: end_samp_M2,1)*10,CoP2(start_samp_M1: end_samp_M2,2)*10,'LineWidth',2);
% xlabel('Postion in X (mm)','FontSize',16)
% ylabel('Position in Y (mm)','FontSize',16)
% yl = ylim;
% xl= xlim;
% yl = ylim;
% xl= xlim;
% rangex = (xl(2)-xl(1));
% rangey = (yl(2)-yl(1));
% % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
% hold on
% c1= viscircles([CoP2(start_samp_M1,1)*10,CoP2(start_samp_M1,2)*10],.01,'Color','g');
% c2= viscircles([CoP2( end_samp_M2,1)*10,CoP2( end_samp_M2,2)*10],.01,'Color','r');
% set(h1,'Color',[0 0.4470 0.7410]);
% title('COP shifts for Mat 2')
% axis equal
%
%
% %% Creating Greater Resolution
%
% %Location in x and y where the COP is for all frames of the trial
% element_idx= round([CoP2(:,1) CoP2(:,2)]);
%
%
% scalingsize = 64;
% scalingfactor =4 ;
%
% % I1 (mat 1) new data matrix (64x64xnimages) - increase resolution
% I1 = zeros(scalingsize,scalingsize,nframes);
% for i = 1:nframes
% I1(:,:,i) = imresize(Pressuremat1_frame(:,:,i),scalingfactor);
% end
%
% % I2 (mat 2) new data matrix (64x64xnimages) - increase resolution
% I2 = zeros(scalingsize,scalingsize,nframes);
% for i = 1:nframes
% I2(:,:,i) = imresize(Pressuremat2_frame(:,:,i),scalingfactor);
% end
%
%
%
%
%
% %%
%
% % April 2022- Kacey not sure what need this for?? commented out for
% % plotting
%
% % Mat 1
% % Finding the minimum for each frame of new data martrix I
% for h = 1:nframes
% min_I1 = min(I1(:,:,h));
% min_I1(h) = min(min_I1);
% end
%
% %using the absolute minimum from all frames because then it resets the colormap basically for each frame (flashing)
%
% min_I1 = min(min_I1);
%
%
% % Mat 2
% % Finding the minimum for each frame of new data martrix I
% for h = 1:nframes
% min_I2 = min(I2(:,:,h));
% min_I2(h) = min(min_I2);
% end
%
% %using the absolute minimum from all frames because then it resets the colormap basically for each frame (flashing)
%
% min_I2 = min(min_I2);
%
% % return
%
% %% Plotting Higher Resolution
% for i =start_samp_M1: end_samp_M2
%     figure(16)
%     clf
%
%     subplot(2,1,1)
%
%     %     if i == start_samp_M1
% %         max_press1 = max(max(I1(:,:,i)+abs(min_I1)));
% %         min_press1 = min(min(I1(:,:,i)+abs(min_I1)));
% %     end
%
%     if i == start_samp_M1 % for colorbar
%         max_press1 = max(max(I1(:,:,i)));
%         min_press1 = min(min(I1(:,:,i)));
%     end
%
%
%     % Needed to add min to adjust colormap issues
%   %   imagesc(I1(:,:,i)+abs(min_I1),[min_press1 max_press1])
%     imagesc(I1(:,:,i),[min_press1 max_press1])
%
%    % imagesc(I(:,:,i))
%     title('Pressure Mat 1 Pressure Values')
%     xlabel('X position')
%     ylabel('Y position')
%     colorbar
%
%     subplot(2,1,2)
% %     if i == start_samp_M1
% %         max_press2 = max(max(I2(:,:,i)+abs(min_I2)));
% %         min_press2 = min(min(I2(:,:,i)+abs(min_I2)));
% %
% %     end
%
%     if i == start_samp_M1  % for colorbar range
%         max_press2 = max(max(I2(:,:,i)));
%         min_press2 = min(min(I2(:,:,i)));
%
%     end
%
%     % Needed to add min to adjust colormap issues 2021
% %     imagesc(I2(:,:,i)+abs(min_I2),[ min_press2  max_press2])
%      imagesc(I2(:,:,i),[ min_press2  max_press2]) %looks fine on own now April 2022 KCS adjusted color bar mins/maxes
%
%    % imagesc(I(:,:,i))
%     title('Pressure Mat 2 Pressure Values')
%     xlabel('X position')
%     ylabel('Y position')
%     colorbar
%
%
%
%     pause(.5)
%
%
% end
%
%
%
% %% Video way  with smaller pixels
%
%
%
%
% % v = VideoWriter('pps.avi');
% % open(v);
% %
% %
% % for i=1:nframes
% %
% %
% %     imagesc(I1(:,:,i)+abs(min_I1),[0 3])
% %
% %     title('Pressure Mat 1 Pressure Values with COP')
% %     xlabel('X position')
% %     ylabel('Y position')
% %     colorbar
% %     %             colormap(hot)
% %     %    colormap(turbo)
% %
% %
% %     frame = getframe(gcf);
% %     writeVideo(v,frame);
% %     pause(.1)
% %
% % %     i
% % end
% % close(v);
%
%
% %% Testing COP calculation
% % testmatrix = [-10 -10; -20 -20];
% %
% % % testmatrix = [10 10; 10 10];
% % clf
% % h=imagesc(.5,.5,testmatrix);
% % %imagesc([.5 1.5],[1.5 .5],testmatrix)
% % colorbar
% % totalp = sum(sum(testmatrix));
% %
% %        % rm=(0:3); rm=rm'; rm=rm(:);
% %
% %         CoP1=[sum(sum(testmatrix(:,1:2).*repmat((0:1)+.5,2,1),2)./totalp); sum(sum(testmatrix(1:2,:).*(repmat((0:1)+.5,2,1))',2)./totalp)]; % mat 1
% %
% % hold on
% % plot(CoP1(1),CoP1(2),'s','MarkerFaceColor','k','MarkerSize',16)
% % set(h.Parent,'YTickLabel',cellstr(string((1.5:-1:0.5)')));
% % h.Parent.XTickLabel=cellstr(string((0.5:1.5)'));
%
% %% Testing with the dimensions of the pressure mat 16X16
%
% % %
% % ppsdata = zeros(1,256);
% % ppsdata(1,1:8) = 20;
% % ppsdata(1,17:17+7) = 20;
% % ppsdata(1,33:33+7) = 20;
% % ppsdata(1,49:49+7) = 20;
% %
% % TotalPressure1 = sum(ppsdata(:,1:256),2);
% % Pressuremat1 = ppsdata(:,1:256);
% % nframes=size(ppsdata,1);
% %
% % Pressuremat1_frame= zeros(16,16,nframes);
% %
% %        for i=1:nframes
% %         % flipped to align with PPS mat layout
% %         Pressuremat1_frame(:,:,i) =flipud(reshape(Pressuremat1(i,:),[16,16])');
% %        % Pressuremat1_frame(:,:,i) =reshape(Pressuremat1(i,:),[16,16])';
% %        % Pressuremat2_frame(:,:,i) =flipud(reshape(Pressuremat2(i,:),[16,16])');
% %        end
% %
% %
% %  % elements 1" apart
% % rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
% % CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
% % CoP1(:,2) = 16- CoP1(:,2);
% %
% %
% % clf
% % imagesc(.5,.5,Pressuremat1_frame(:,:,i))%,[-20 100])
% % colorbar
% % hold on
% % plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%

end



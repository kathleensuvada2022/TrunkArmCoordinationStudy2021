% May 2022 K. Suvada

% Function used to visualize pressure mat data. PlotKinematicdata6 calls
% this function so can plot with main analysis code. For stroke
% participants, always had Mat2 on the seat. Check data collection sheets
% to confirm and especially for controls.

% INPUTS:
% - ppsdata: data matrix of pressure values. Turns then positive so more
% interpretable


%OUTPUTS:


function ComputeCOP(ppsdata,tpps,t_start,t_end,hand,partid);
close all 
%% Plotting Raw Data and Baseline File

%Loading in PPS baseline file 

%For PC
%datafilepath = ['C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\','\',partid,'\',hand];

%For MAC
datafilepath = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data','/',partid,'/',hand];
load(fullfile(datafilepath, 'pps_baseline.mat')); %load setup file
%%
baseline_mat1 = data(:,1:256);
baseline_mat2 = data(:,257:end);
baseline_t = t;

%Averaging Across the Interval
avg_interval = size(baseline_mat1,1)/2;
avg_interval = round(avg_interval);

baseline_mat1_corrected = mean(baseline_mat1(avg_interval:end,:));
baseline_mat2_corrected = mean(baseline_mat2(avg_interval:end,:));
%%
% Figure 15 shows average value for each element during baseline (this is prior to
% Mat being zeroed bc it is read before calling library 'SetBaseline'.

% figure(15)
% clf
% subplot(2,1,1)
% plot(baseline_mat1_corrected,'o')
% title('Mat 1 Baseline- averaged')
% xlabel('Element')
% ylabel('Value in Volts')
% 
% subplot(2,1,2)
% plot(baseline_mat2_corrected,'o')
% title('Mat 2 Baseline- averaged')
% xlabel('Element')
% ylabel('Value in Volts')
% 
% figure(16)
% clf
% subplot(2,1,1)
% plot(t,baseline_mat1)
% title('Mat 1 Element Values during PPS Initialization')
% xlabel('Time')
% ylabel('Volts')
% 
% subplot(2,1,2)
% plot(t,baseline_mat2)
% title('Mat 2 Element Values during PPS Initialization')
% xlabel('Time')
% ylabel('Volts')
%% 

%% MAT 1 - tiled layout
% figure(17)
% clf
% t = tiledlayout(16,16);
% nexttile
% 
% for i = 1:256
%     plot(tpps,ppsdata(:,i))
%     % xlabel('Time')
%     % ylabel('Volts')
%     title(i)
%     if i<256
%         nexttile
%     end
%     
% end

%% Mat 1- 

%%
pause

return
%%
%Finding start/stop samples for each mat
% Mat 1 SR = 13.5 Hz  Mat 2 SR = 14 Hz

start_samp_M1= round(t_start*13.5);
end_samp_M1= round(t_end*13.5);

start_samp_M2= round(t_start*14);
end_samp_M2= round(t_end*14);


%%  Making the pps data matrix have all positive values

min_ppsdata = min(min(ppsdata));

ppsdata = ppsdata+abs(min_ppsdata);

% ppsdata : 290 rows (samples) x 512 columns (elements on mats)
%%

% Number of Frames
nframes=size(ppsdata,1);

%Finding the total pressure for each mat 

% Total pressure for all elements for Mat 1
TotalPressure1 = sum(ppsdata(:,1:256),2); 

% Total pressure for all elements for Mat 2
TotalPressure2 = sum(ppsdata(:,257:end),2);

Pressuremat1 = ppsdata(:,1:256);
Pressuremat2 = ppsdata(:,257:end);

%% Reorganizing data Matrix to Create Orientation of both Mats

% need to reshape to be a 16x16 where we have Nframes matrices
Pressuremat1_frame= zeros(16,16,nframes);
Pressuremat2_frame= zeros(16,16,nframes);

for i=1:nframes
    Pressuremat1_frame(:,:,i) =flipud(reshape(Pressuremat1(i,:),[16,16])'); %corresponds to layout of mat (see figure from PPS)
    Pressuremat2_frame(:,:,i) =flipud(reshape(Pressuremat2(i,:),[16,16])');
end

% Calculating COP for Both Mats
% elements 1" apart
rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
CoP1(:,2) = 16- CoP1(:,2);

% CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2];
% CoP2(:,2) = 16- CoP2(:,2);


CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2]; % mat 2
CoP2(:,2) = 16- CoP2(:,2);



deltax = CoP2(end,1)-CoP2(1,1); % change in x in cm

deltay =CoP2(end,2)-CoP2(1,2); % change in y in cm

%% Filtering out artifact bands- May 2022

% RTIS2003- Paretic : artifacts in columns. Finds columns where 2x average and sets
% to 0.
 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
%if strcmp(partid,'RTIS2003')
    avg_mat1 = zeros(nframes,16);
    avg_mat2 = zeros(nframes,16);
    for p = 1: nframes

        % Pressure mat 1
        avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
        Abs_avg_mat1(p) = mean(avg_mat1(p,:));

        Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));

        if isempty(Artifact_Cols)
        else
            Pressuremat1_frame(:,Artifact_Cols,p) =nan;
        end

        % Pressure mat 2
        avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
        Abs_avg_mat2(p) = mean(avg_mat2(p,:));

        Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));

        if isempty(Artifact_Cols)

        else
            Pressuremat2_frame(:,Artifact_Cols,p) =nan;

        end
    end

 end
 
 if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')

    avg_mat1 = zeros(nframes,16);
    avg_mat2 = zeros(nframes,16);
    for p = 1: nframes

        % Pressure mat 1
        avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
        Abs_avg_mat1(p) = mean(avg_mat1(p,:));

        Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));

        if isempty(Artifact_Cols)
        else
            Pressuremat1_frame(:,Artifact_Cols,p) =nan;
        end
    end 
    % Pressure mat 2


    Pressuremat2_frame(:,6,:) =nan;

end





if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
    avg_mat1 = zeros(nframes,16);
    avg_mat2 = zeros(nframes,16);
    for p = 1: nframes

        % Pressure mat 1
        avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
        Abs_avg_mat1(p) = mean(avg_mat1(p,:));

        Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));

        if isempty(Artifact_Cols)
        else
            Pressuremat1_frame(:,Artifact_Cols,p) =nan;
        end

        % Pressure mat 2
        avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
        Abs_avg_mat2(p) = mean(avg_mat2(p,:));

        Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));

        if isempty(Artifact_Cols)

        else
            Pressuremat2_frame(:,Artifact_Cols,p) =nan;

        end
    end
end

if strcmp(partid,'RTIS2009') && strcmp(hand,'Right')
    avg_mat1 = zeros(nframes,16);
    avg_mat2 = zeros(nframes,16);
    for p = 1: nframes

        % Pressure mat 1
        avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
        Abs_avg_mat1(p) = mean(avg_mat1(p,:));

        Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));

        if isempty(Artifact_Cols)
        else
            Pressuremat1_frame(:,Artifact_Cols,p) =nan;
        end

        % Pressure mat 2
        avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
        Abs_avg_mat2(p) = mean(avg_mat2(p,:));

        Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));

        if isempty(Artifact_Cols)

        else
            Pressuremat2_frame(:,Artifact_Cols,p) =nan;

        end
    end
end
 if strcmp(partid,'RTIS2009') && strcmp(hand,'Left') %Horizontal Bar Artifacts
%     avg_mat1 = zeros(16,nframes);
%     avg_mat2 = zeros(16,nframes);
    for p = 1: nframes

        % Pressure mat 1
%         avg_mat1(:,p) = mean(Pressuremat1_frame(:,:,p),2); % Average of each column across all time nframes X 16 cols
%         Abs_avg_mat1(p) = mean(avg_mat1(:,p));
% 
%         Artifact_Cols = find (avg_mat1(:,p) > 2*Abs_avg_mat1(p));

%         if isempty(Artifact_Cols)
%         else
            Pressuremat1_frame(9,:,p) =nan; % Needed to manually do 
            Pressuremat1_frame(4,:,p) =nan; % Needed to manually do
%         end

%         % Pressure mat 2
%         avg_mat2(:,p) = mean(Pressuremat2_frame(:,:,p),2); % Average of each column
%         Abs_avg_mat2(p) = mean(avg_mat2(:,p));
% 
%         Artifact_Cols = find (avg_mat2(:,p) > 2*Abs_avg_mat2(p));
% 
%         if isempty(Artifact_Cols)
% 
%         else
%             Pressuremat2_frame(Artifact_Cols,:,p) =0;
% 
%         end
    end
%    Pressuremat1_frame(:,:,:) = - Pressuremat1_frame(:,:,:);

end
   
if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
    avg_mat1 = zeros(nframes,16);
    avg_mat2 = zeros(nframes,16);
    for p = 1: nframes

        % Pressure mat 1
        avg_mat1(p,:) = mean(Pressuremat1_frame(:,:,p)); % Average of each column across all time nframes X 16 cols
        Abs_avg_mat1(p) = mean(avg_mat1(p,:));

        Artifact_Cols = find (avg_mat1(p,:) > 2*Abs_avg_mat1(p));

        if isempty(Artifact_Cols)
        else
            Pressuremat1_frame(:,Artifact_Cols,p) =nan;
        end

        % Pressure mat 2
        avg_mat2(p,:) = mean(Pressuremat2_frame(:,:,p)); % Average of each column
        Abs_avg_mat2(p) = mean(avg_mat2(p,:));

        Artifact_Cols = find (avg_mat2(p,:) > 2*Abs_avg_mat2(p));

        if isempty(Artifact_Cols)

        else
            Pressuremat2_frame(:,Artifact_Cols,p) =nan;

        end
    end
end


if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')
    Pressuremat2_frame(4,:,:) =nan;
end
%% Normal Scaling For Loop Plotting Pressure Data Mat 1 and 2 
%
% %For video uncomment if needed
%    %     v = VideoWriter('pps.avi');
%   %      open(v);
% figure(3), clf
% % for i =1:nframes
%     %
%     subplot(2,1,1)
%     %Mat 1
%        imagesc(.5,.5,Pressuremat1_frame(:,:,i))
%     hold on
% %     plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%     title('Mat 1')
%     colorbar
%     % % %
%     subplot(2,1,2)
%     %Mat 2
%       imagesc(.5,.5,Pressuremat2_frame(:,:,i))
%     hold on
%     plot(CoP2(i,1),CoP2(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%     title('Mat 2')
% %     %
% %               colormap(hot)
% %               colormap(turbo)
%     colorbar
%     %
%     %    %     frame = getframe(gcf);% for video uncomment if want
%     %    %     writeVideo(v,frame);% for video uncomment if want
%     %           pause(.1)
%     %
% end
% % %    %      close(v); %for video uncomment if want
% %
% %
% 
% 


%% Plotting the Center of Pressure Changes

% Whole trial
% figure(6)
% subplot(2,1,1)
% h1 = plot(CoP1(:,1)*10,CoP1(:,2)*10,'LineWidth',2);
% hold on
% xlabel('Postion in X (mm)','FontSize',16)
% ylabel('Position in Y (mm)','FontSize',16)
% yl = ylim;
% xl= xlim;
% rangex = (xl(2)-xl(1));
% rangey = (yl(2)-yl(1));
% % text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
% hold on
% c1= viscircles([CoP1(1,1)*10,CoP1(1,2)*10],.01,'Color','g');
% c2= viscircles([CoP1(end,1)*10,CoP1(end,2)*10],.01,'Color','r');
% set(h1,'Color',[0 0.4470 0.7410]);
% title('COP shifts for Mat1 ')
% axis equal
% 
% subplot(2,1,2)
% hold on
% h1 = plot(CoP2(:,1)*10,CoP2(:,2)*10,'LineWidth',2);
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
% c1= viscircles([CoP2(1,1)*10,CoP2(1,2)*10],.01,'Color','g');
% c2= viscircles([CoP2(end,1)*10,CoP2(end,2)*10],.01,'Color','r');
% set(h1,'Color',[0 0.4470 0.7410]);
% title('COP shifts for Mat 2')
% axis equal


% Cut 
figure(6)
subplot(2,1,1)
h1 = plot(CoP1(start_samp_M1: end_samp_M2,1)*10,CoP1(start_samp_M1: end_samp_M2,2)*10,'LineWidth',2);
hold on
xlabel('Postion in X (mm)','FontSize',16)
ylabel('Position in Y (mm)','FontSize',16)
yl = ylim;
xl= xlim;
rangex = (xl(2)-xl(1));
rangey = (yl(2)-yl(1));
% text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
hold on
c1= viscircles([CoP1(start_samp_M1,1)*10,CoP1(start_samp_M1,2)*10],.01,'Color','g');
c2= viscircles([CoP1(end_samp_M2,1)*10,CoP1(end_samp_M2,2)*10],.01,'Color','r');
set(h1,'Color',[0 0.4470 0.7410]);
title('COP shifts for Mat1 ')
axis equal


subplot(2,1,2)
hold on
h1 = plot(CoP2(start_samp_M1: end_samp_M2,1)*10,CoP2(start_samp_M1: end_samp_M2,2)*10,'LineWidth',2);
xlabel('Postion in X (mm)','FontSize',16)
ylabel('Position in Y (mm)','FontSize',16)
yl = ylim;
xl= xlim;
yl = ylim;
xl= xlim;
rangex = (xl(2)-xl(1));
rangey = (yl(2)-yl(1));
% text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
hold on
c1= viscircles([CoP2(start_samp_M1,1)*10,CoP2(start_samp_M1,2)*10],.01,'Color','g');
c2= viscircles([CoP2( end_samp_M2,1)*10,CoP2( end_samp_M2,2)*10],.01,'Color','r');
set(h1,'Color',[0 0.4470 0.7410]);
title('COP shifts for Mat 2')
axis equal


%% Creating Greater Resolution 

%Location in x and y where the COP is for all frames of the trial
element_idx= round([CoP2(:,1) CoP2(:,2)]); 


scalingsize = 64;
scalingfactor =4 ;

% I1 (mat 1) new data matrix (64x64xnimages) - increase resolution
I1 = zeros(scalingsize,scalingsize,nframes);
for i = 1:nframes
I1(:,:,i) = imresize(Pressuremat1_frame(:,:,i),scalingfactor); 
end

% I2 (mat 2) new data matrix (64x64xnimages) - increase resolution
I2 = zeros(scalingsize,scalingsize,nframes);
for i = 1:nframes
I2(:,:,i) = imresize(Pressuremat2_frame(:,:,i),scalingfactor); 
end





%%

% April 2022- Kacey not sure what need this for?? commented out for
% plotting

% Mat 1
% Finding the minimum for each frame of new data martrix I
for h = 1:nframes
min_I1 = min(I1(:,:,h));
min_I1(h) = min(min_I1);
end

%using the absolute minimum from all frames because then it resets the colormap basically for each frame (flashing)

min_I1 = min(min_I1);


% Mat 2
% Finding the minimum for each frame of new data martrix I
for h = 1:nframes
min_I2 = min(I2(:,:,h));
min_I2(h) = min(min_I2);
end

%using the absolute minimum from all frames because then it resets the colormap basically for each frame (flashing)

min_I2 = min(min_I2);

% return

%% Plotting Higher Resolution
for i =start_samp_M1: end_samp_M2
    figure(16)
    clf
    
    subplot(2,1,1)

    %     if i == start_samp_M1
%         max_press1 = max(max(I1(:,:,i)+abs(min_I1)));
%         min_press1 = min(min(I1(:,:,i)+abs(min_I1)));
%     end

    if i == start_samp_M1 % for colorbar
        max_press1 = max(max(I1(:,:,i)));
        min_press1 = min(min(I1(:,:,i)));
    end


    % Needed to add min to adjust colormap issues
  %   imagesc(I1(:,:,i)+abs(min_I1),[min_press1 max_press1])
    imagesc(I1(:,:,i),[min_press1 max_press1])
  
   % imagesc(I(:,:,i))
    title('Pressure Mat 1 Pressure Values')
    xlabel('X position')
    ylabel('Y position')
    colorbar
  
    subplot(2,1,2)
%     if i == start_samp_M1
%         max_press2 = max(max(I2(:,:,i)+abs(min_I2)));
%         min_press2 = min(min(I2(:,:,i)+abs(min_I2)));
% 
%     end

    if i == start_samp_M1  % for colorbar range
        max_press2 = max(max(I2(:,:,i)));
        min_press2 = min(min(I2(:,:,i)));

    end

    % Needed to add min to adjust colormap issues 2021
%     imagesc(I2(:,:,i)+abs(min_I2),[ min_press2  max_press2])
     imagesc(I2(:,:,i),[ min_press2  max_press2]) %looks fine on own now April 2022 KCS adjusted color bar mins/maxes
  
   % imagesc(I(:,:,i))
    title('Pressure Mat 2 Pressure Values')
    xlabel('X position')
    ylabel('Y position')
    colorbar



    pause(.5)
    
 
end



%% Video way  with smaller pixels




% v = VideoWriter('pps.avi');
% open(v);
% 
% 
% for i=1:nframes
%     
%     
%     imagesc(I1(:,:,i)+abs(min_I1),[0 3])
%     
%     title('Pressure Mat 1 Pressure Values with COP')
%     xlabel('X position')
%     ylabel('Y position')
%     colorbar
%     %             colormap(hot)
%     %    colormap(turbo)
%     
%     
%     frame = getframe(gcf);
%     writeVideo(v,frame);
%     pause(.1)
%     
% %     i
% end
% close(v);


%% Testing COP calculation
% testmatrix = [-10 -10; -20 -20];
%
% % testmatrix = [10 10; 10 10];
% clf
% h=imagesc(.5,.5,testmatrix);
% %imagesc([.5 1.5],[1.5 .5],testmatrix)
% colorbar
% totalp = sum(sum(testmatrix));
%
%        % rm=(0:3); rm=rm'; rm=rm(:);
%
%         CoP1=[sum(sum(testmatrix(:,1:2).*repmat((0:1)+.5,2,1),2)./totalp); sum(sum(testmatrix(1:2,:).*(repmat((0:1)+.5,2,1))',2)./totalp)]; % mat 1
%
% hold on
% plot(CoP1(1),CoP1(2),'s','MarkerFaceColor','k','MarkerSize',16)
% set(h.Parent,'YTickLabel',cellstr(string((1.5:-1:0.5)')));
% h.Parent.XTickLabel=cellstr(string((0.5:1.5)'));

%% Testing with the dimensions of the pressure mat 16X16

% %
% ppsdata = zeros(1,256);
% ppsdata(1,1:8) = 20;
% ppsdata(1,17:17+7) = 20;
% ppsdata(1,33:33+7) = 20;
% ppsdata(1,49:49+7) = 20;
%
% TotalPressure1 = sum(ppsdata(:,1:256),2);
% Pressuremat1 = ppsdata(:,1:256);
% nframes=size(ppsdata,1);
%
% Pressuremat1_frame= zeros(16,16,nframes);
%
%        for i=1:nframes
%         % flipped to align with PPS mat layout
%         Pressuremat1_frame(:,:,i) =flipud(reshape(Pressuremat1(i,:),[16,16])');
%        % Pressuremat1_frame(:,:,i) =reshape(Pressuremat1(i,:),[16,16])';
%        % Pressuremat2_frame(:,:,i) =flipud(reshape(Pressuremat2(i,:),[16,16])');
%        end
%
%
%  % elements 1" apart
% rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
% CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
% CoP1(:,2) = 16- CoP1(:,2);
%
%
% clf
% imagesc(.5,.5,Pressuremat1_frame(:,:,i))%,[-20 100])
% colorbar
% hold on
% plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)


end



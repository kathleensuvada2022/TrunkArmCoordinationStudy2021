% April 2022 K. Suvada

% Function used to visualize pressure mat data. PlotKinematicdata6 calls
% this function so can plot with main analysis code. For stroke
% participants, always had Mat2 on the seat. Check data collection sheets
% to confirm and especially for controls.

% INPUTS:
% - ppsdata: data matrix of pressure values. Turns then positive so more
% interpretable


%OUTPUTS:


function ComputeCOP(ppsdata,tpps,t_start,t_end);
close all 

%Finding start/stop samples for each mat
% Mat 1 SR = 13.5 Hz  Mat 2 SR = 14 Hz

start_samp_M1= round(t_start*13.5);
end_samp_M1= round(t_end*13.5);

start_samp_M2= round(t_start*14);
end_samp_M2= round(t_end*14);

 %% Kacey playing with baseline subtraction
% avgbaseline = mean(baseline);
% 
% for i = 1:size(trialdata,1)
% SubBaseline(i,i) = trialdata(i,i) - avgbaseline(i);
% end

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

%% Normal Scaling For Loop Plotting Pressure Data Mat 1 and 2 
%
% %For video uncomment if needed
%    %     v = VideoWriter('pps.avi');
%   %      open(v);
% figure(3), clf
% for i =1:nframes
%     %
%     subplot(2,1,1)
%     %Mat 1
%     imagesc(.5,.5,Pressuremat1_frame(:,:,i),[0 3])
%     hold on
%     plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%     title('Mat 1')
%     colorbar
%     % % %
%     subplot(2,1,2)
%     %Mat 2
%     imagesc(.5,.5,Pressuremat2_frame(:,:,i),[0 3])
%     hold on
%     plot(CoP2(i,1),CoP2(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%     title('Mat 2')
%     %
% %               colormap(hot)
%               colormap(turbo)
%     colorbar
%     %
%     %    %     frame = getframe(gcf);% for video uncomment if want
%     %    %     writeVideo(v,frame);% for video uncomment if want
%     %           pause(.1)
%     %
% end
% %    %      close(v); %for video uncomment if want
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



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



deltax = CoP2(end,1)-CoP2(1,1) % change in x in cm

deltay =CoP2(end,2)-CoP2(1,2) % change in y in cm

%% Normal Scaling For Loop Plotting Pressure Data Mat 1
%
% %For video uncomment if needed
%    %     v = VideoWriter('pps.avi');
%   %      open(v);
% figure(3), clf
%     for i =1:nframes
%
%
% %          %Mat 1
% %          imagesc(.5,.5,Pressuremat1_frame(:,:,i))
% %         hold on
% %          plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
% %
% %
%          %Mat 2
%          imagesc(.5,.5,Pressuremat2_frame(:,:,i),[5 8])
%          hold on
%          plot(CoP2(i,1),CoP2(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
%
%
%          %colormap(hot)
%          %colormap(turbo)
%          colorbar
%
%    %     frame = getframe(gcf);% for video uncomment if want
%    %     writeVideo(v,frame);% for video uncomment if want
%           pause(.1)
%
%        end
%    %      close(v); %for video uncomment if want
%
%


%% Plotting the Center of Pressure Changes

figure(6)

h1 = plot(CoP2(:,1)*10,-CoP2(:,2)*10,'LineWidth',2);
xlabel('Postion in X (mm)','FontSize',16)
ylabel('Position in Y (mm)','FontSize',16)
yl = ylim;
xl= xlim;
rangex = (xl(2)-xl(1));
rangey = (yl(2)-yl(1));
% text(xl(1)+(rangex/2),yl(1)+(rangey/2), num2str([deltax deltay]) )
hold on
c1= viscircles([CoP2(1,1)*10,-CoP2(1,2)*10],.01,'Color','g');
c2= viscircles([CoP2(end,1)*10,-CoP2(end,2)*10],.01,'Color','r');
set(h1,'Color',[0 0.4470 0.7410]);

axis equal
%pause
%% Plotting COP and Pressure for Mat 2- smaller scaling

%Location in x and y where the COP is for all frames of the trial
element_idx= round([CoP2(:,1) CoP2(:,2)]); 


scalingsize = 64;
scalingfactor =4 ;

% I new data matrix (64x64xnimages) - increase resolution
I = zeros(scalingsize,scalingsize,nframes);
for i = 1:nframes
I(:,:,i) = imresize(Pressuremat2_frame(:,:,i),scalingfactor); 
end
%%

% Finding the minimum for each frame of new data martrix I
for h = 1:nframes
min_I = min(I(:,:,h));
min_I(h) = min(min_I);
end

%using the absolute minimum from all frames because then it resets the colormap basically for each frame (flashing)

min_I = min(min_I);

%%
for i =start_samp_M2:end_samp_M2
    clf
    
    % creating where the COP is multiply by 4 (scaling factor)
    I(element_idx(i,2)*4,element_idx(i,1)*4,i) = -15;
    
    
    % Needed to add min to adjust colormap issues
    imagesc(I(:,:,i)+abs(min_I),[0 2.95])
  
   % imagesc(I(:,:,i))
    title('Pressure Mat 2 Pressure Values')
    xlabel('X position')
    ylabel('Y position')
    colorbar
    %         hold on
    %         plot(CoP1(i,1),CoP1(i,2),'*')
    pause(.1)
    
end



%% Video way  with smaller pixels
%
element_idx = round([CoP1(i,1) CoP1(i,2)]); % don't think need .5 since used above to calculate it?
Pressuremat1_frame(element_idx(1),element_idx(2),i) = -15;

% Just using IMAGESC will plot through all the frames pressure data
I = zeros(64,64,nframes);
for i = 1:nframes
I(:,:,i) = imresize(Pressuremat1_frame(:,:,i),4); %use to alter resolution: bigger number smaller pixels
end



        v = VideoWriter('pps.avi');
        open(v);

%    get max across all frames and min to set colorbar range
   % want colorbar to stay the same across frames... need to find the max and min ofwhole trial all frames
%
%imagesc(___,clims) specifies the data values that map to the first and last elements of the colormap. Specify clims as a two-element vector of the form [cmin cmax],


%         ppsmaxreachindx = maxreach_seconds*39.5;  %scan rate of pressure mats is 13.5 HZ
        for i=1:nframes

%          imagesc(I(:,:,i),[-15 -2])

          imagesc(I(:,:,i)+abs(min_I),[0 3])

         title('Pressure Mat Pressure Values with COP')
         xlabel('X position')
         ylabel('Y position')
         colorbar
%             colormap(hot)
          %    colormap(turbo)


           frame = getframe(gcf);
             writeVideo(v,frame);
             pause(.1)

        end
        close(v);


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



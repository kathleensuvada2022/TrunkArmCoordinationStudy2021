% Feb 2021. Function used to compute center of pressure offline post
% experiment.


function [CoP1]=  ComputeCOP(ppsdata,maxreach_seconds)

% cut out beginning with odd behavior and then cut the end of the trial max
% reach 
    
ppsdata= ppsdata{1,2};
%% Loading in Data for Mat 1 and 2
        
        % NEED TO MAKE PRESSURE MAT DATA POSITIVE, SO FIND MINIMUM AND ADD ABS 
        
        min_ppsdata = min(min(ppsdata));
        
        ppsdata = ppsdata+abs(min_ppsdata);
        
        %Finding the max of new data for scaling of ImageSC
        
        max_ppsdata = max(max(ppsdata));
        
        %Finding the min of new data for scaling of ImageSC
        
        min_new = min(min(ppsdata));
        
       
        %Number of Frames
        nframes=size(ppsdata,1);
        
        %Finding the total pressure for each mat and separating 

        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);
        
        Pressuremat1 = ppsdata(:,1:256);
        Pressuremat2 = ppsdata(:,257:end);
       
 
  %% Creating Matrices to Replicate Pressure Mat
        
       % need to reshape to be a 16x16 where we have Nframes matrices
        Pressuremat1_frame= zeros(16,16,nframes);
        Pressuremat2_frame= zeros(16,16,nframes);
        
        for i=1:nframes
        Pressuremat1_frame(:,:,i) =flipud(reshape(Pressuremat1(i,:),[16,16])'); %corresponds to layout of mat (see figure from PPS) 
        Pressuremat2_frame(:,:,i) =flipud(reshape(Pressuremat2(i,:),[16,16])');
        end
 %% Calculating COP for Both Mats    
        % elements 1" apart
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
        CoP1(:,2) = 16- CoP1(:,2);
        
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2]; % mat 1
        CoP2(:,2) = 16- CoP2(:,2);

        
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2]; % mat 1
        CoP2(:,2) = 16- CoP2(:,2);

%% Normal Scaling For Loop Plotting Pressure Data Mat 1
   
% For video uncomment if needed 
%         v = VideoWriter('pps.avi');
%         open(v);
figure(3), clf    
        for i=1:nframes
      
     
         %Mat 1
         %imagesc(.5,.5,Pressuremat1_frame(:,:,i),[min_new max_ppsdata])
        % hold on
         %plot(CoP1(i,1),CoP1(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
         
         
         %Mat 2
         imagesc(.5,.5,Pressuremat2_frame(:,:,i),[.5 3])
         hold on
         plot(CoP2(i,1),CoP2(i,2),'s','MarkerFaceColor','k','MarkerSize',16)
         
           
         %colormap(hot)
         %colormap(turbo)
         colorbar
             
%         frame = getframe(gcf); for video uncomment if want
%         writeVideo(v,frame); for video uncomment if want
          pause(.1)
            
        end
%         close(v); for video uncomment if want




%% Plotting the Center of Pressure Changes

figure(4), clf

plot(CoP2(:,1),CoP2(:,2),'s','LineWidth',16)
xlabel('Postion in X','FontSize',16)
ylabel('Position in Y','FontSize',16)
title('Trajectory of COP')
hold on
axis([0 16 0 16])
        
 %% Plotting COP and Pressure for Mat 1- smaller scaling 

% element_idx= round([CoP1(:,1) CoP1(:,2)]); %location in x and y where the COP is for all frames of the trial
% 
% % Pressuremat1_frame(element_idx(1),element_idx(2),i) = -15;
% 
% scalingsize = 64; 
% scalingfactor =4 ; %increasing so 4X as many values (increasing resolution) 
% 
% % Just using IMAGESC will plot through all the frames pressure data
% I = zeros(scalingsize,scalingsize,nframes);
% for i = 1:nframes
% I(:,:,i) = imresize(Pressuremat1_frame(:,:,i),scalingfactor); %use to alter resolution: bigger number smaller pixels
% end
% 
% %KCS 4.28.21 find the minimum for all frames
% 
% % Finding the minimum for each frame of scaled variable I
% for h = 1:nframes
% min_I = min(I(:,:,h));
% min_I(h) = min(min_I);
% end
% 
% min_I = min(min_I); %using the absolute minimum from all frames in a trial because then it resets the colormap basically for each frame (flashing)
% 
% 
% for i =1:nframes
%         clf
% %         %plotting with pause to simulate video
% 
%           % Needs to be the y value since Y is moving across the rows - X
%           % moving across the columns 
%          I(element_idx(i,2)*4,element_idx(i,1)*4,i) = -15; % creating where the COP is multiply by 4 (scaling factor)
% 
% 
%           imagesc(I(:,:,i)+abs(min_I),[0 9.3])
%          title('Pressure Mat Pressure Values with COP - BACKCHAIR')
%          xlabel('X position KNEES')
%          ylabel('Y position')
%          colorbar
% %         hold on
% %         plot(CoP1(i,1),CoP1(i,2),'*')
%          pause(.1)
%          
% end 


       
   %% Video way  with smaller pixels      
% 
% element_idx = round([CoP1(i,1) CoP1(i,2)]); % don't think need .5 since used above to calculate it?
% Pressuremat1_frame(element_idx(1),element_idx(2),i) = -15;
% 
% % Just using IMAGESC will plot through all the frames pressure data
% I = zeros(64,64,nframes);
% for i = 1:nframes
% I(:,:,i) = imresize(Pressuremat1_frame(:,:,i),4); %use to alter resolution: bigger number smaller pixels
% end
% 


%         v = VideoWriter('pps.avi');
%         open(v);
%         
% %    get max across all frames and min to set colorbar range    
%    % want colorbar to stay the same across frames... need to find the max and min ofwhole trial all frames     
% %         
% %imagesc(___,clims) specifies the data values that map to the first and last elements of the colormap. Specify clims as a two-element vector of the form [cmin cmax],
% 
% 
% %         ppsmaxreachindx = maxreach_seconds*39.5;  %scan rate of pressure mats is 13.5 HZ
%         for i=1:nframes
%             
% %          imagesc(I(:,:,i),[-15 -2])
% 
%           imagesc(I(:,:,i)+abs(min_I),[0 9.3])
%  
%          title('Pressure Mat Pressure Values with COP')
%          xlabel('X position')
%          ylabel('Y position')
%          colorbar
% %             colormap(hot)
%           %    colormap(turbo)
%          
%              
%            frame = getframe(gcf);
%              writeVideo(v,frame);
%              pause(.1)
%             
%         end
%         close(v);


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



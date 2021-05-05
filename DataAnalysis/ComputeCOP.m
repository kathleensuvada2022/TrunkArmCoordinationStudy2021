% Feb 2021. Function used to compute center of pressure offline post
% experiment.


function [CoP1,CoP2,stdMat1,stdMat2]=  ComputeCOP(ppsdata,maxreach_seconds)

% cut out beginning with odd behavior and then cut the end of the trial max
% reach 
    
ppsdata= ppsdata{1,2};
%%
        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);
        Pressuremat1 = ppsdata(:,1:256);
        Pressuremat2 = ppsdata(:,257:end);
       
        
%         plot(Pressuremat1)
       
        nframes=size(ppsdata,1);
        
      
        maxmat1= max(abs(Pressuremat1),[],2); %maximum pressure of mat 1 per each frame
        maxmat2= max(abs(Pressuremat2),[],2); %maximum pressure of mat 2 per each frame
        
        absmaxmat1= max(max(Pressuremat1));
        absmaxmat2 = max(max(Pressuremat2));
   
 
        % TOLD NOT TO NORMALIZE BY AMA
%         Pressuremat1 =Pressuremat1./maxmat1; %normalized to the max on each frame for mat 1
%         Pressuremat2 =Pressuremat2./maxmat2;%normalized to the max on each frame for mat 2
  %%      
        % check the values of the pressure data from reshaping
        
       % need to reshape to be a 16x16 where we have Nframes matrices
        Pressuremat1_frame= zeros(16,16,nframes);
        Pressuremat2_frame= zeros(16,16,nframes);
        
        for i=1:nframes
        Pressuremat1_frame(:,:,i) =flipud(reshape(Pressuremat1(i,:),[16,16])'); %corresponds to layout of mat (see figure from PPS) 
%         Pressuremat2_frame(:,:,i) =flipud(reshape(Pressuremat2(i,:),[16,16])');
        end
        
        % elements 1" apart
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2]; % mat 2
        
        stdMat1 = std(CoP1); %gives standard deviation of x and y COP 
        stdMat2 = std(CoP2); %gives standard deviation of x and y COP 
%% Plotting COP and Pressure for Mat 1 Using Loop and Pause

element_idx= round([CoP1(:,1) CoP1(:,2)]); %location in x and y where the COP is for all frames of the trial

% Pressuremat1_frame(element_idx(1),element_idx(2),i) = -15;

scalingsize = 64; 
scalingfactor =4 ; %increasing so 4X as many values (increasing resolution) 

% Just using IMAGESC will plot through all the frames pressure data
I = zeros(scalingsize,scalingsize,nframes);
for i = 1:nframes
I(:,:,i) = imresize(Pressuremat1_frame(:,:,i),scalingfactor); %use to alter resolution: bigger number smaller pixels
end

%KCS 4.28.21 find the minimum for all frames

% Finding the minimum for each frame of scaled variable I
for h = 1:nframes
min_I = min(I(:,:,h));
min_I(h) = min(min_I);
end

min_I = min(min_I); %using the absolute minimum from all frames in a trial because then it resets the colormap basically for each frame (flashing)


for i =1:nframes
        clf
%         %plotting with pause to simulate video

          % Needs to be the y value since Y is moving across the rows - X
          % moving across the columns 
         I(element_idx(i,2)*4,element_idx(i,1)*4,i) = -15; % creating where the COP is multiply by 4 (scaling factor)


          imagesc(I(:,:,i)+abs(min_I),[0 9.3])
         title('Pressure Mat Pressure Values with COP - BACKCHAIR')
         xlabel('X position KNEES')
         ylabel('Y position')
         colorbar
%         hold on
%         plot(CoP1(i,1),CoP1(i,2),'*')
         pause(.1)
         
end 


%% Video works ! but larger pixels 
   
%Finding minimum of non scaled pressure data 

min_Pressuremat1 = zeros(1,nframes);

%Min Presure for all frames
for i = 1:nframes
min_Pressuremat1(i)= min(Pressuremat1_frame(:,:,i),[],'all');
end

%absolute min pressure for Mat 1
min_Pressuremat1 = min(min_Pressuremat1);

   
%Finding the COP index
element_idx= round([CoP1(:,1) CoP1(:,2)]); %location in x and y where the COP is for all frames of the trial

for i = 1:nframes
Pressuremat1_frame(element_idx(i,2),element_idx(i,1),i) = 20;  
%Pressuremat1_frame(element_idx(i,2),element_idx(i,1),i) = 0; % Y is going by rows and X is going by columns 
end           
%%

%    axis tight manual
%         set(gca,'nextplot','replacechildren');
%         set(gca,'YDir','normal') 
        v = VideoWriter('pps.avi');
        open(v);
        
    
        
%     get max across all frames and min to set colorbar range    
   % want colorbar to stay the same across frames... need to find the max and min ofwhole trial all frames     
%         
%imagesc(___,clims) specifies the data values that map to the first and last elements of the colormap. Specify clims as a two-element vector of the form [cmin cmax],


%         ppsmaxreachindx = maxreach_seconds*39.5;  %scan rate of pressure mats is 13.5 HZ
        for i=2:nframes
            
%           
         
         imagesc(Pressuremat1_frame(:,:,i)+abs(min_Pressuremat1),[0 10])
   %     imagesc(Pressuremat1_frame(:,:,i)+abs(min_Pressuremat1),[50 100])
%             imagesc(I(:,:,i))
            
            %colormap(hot)
          %   colormap(turbo)
             colorbar
             
             frame = getframe(gcf);
             writeVideo(v,frame);
             pause(.1)
            
        end
        close(v);
        
%         implay('pps.avi')
        
       
   %% Video way 2 attempt with smaller pixels      
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

%   axis tight manual
%         set(gca,'nextplot','replacechildren');
%         set(gca,'YDir','normal') 
        v = VideoWriter('pps.avi');
        open(v);
        
%     get max across all frames and min to set colorbar range    
   % want colorbar to stay the same across frames... need to find the max and min ofwhole trial all frames     
%         
%imagesc(___,clims) specifies the data values that map to the first and last elements of the colormap. Specify clims as a two-element vector of the form [cmin cmax],


%         ppsmaxreachindx = maxreach_seconds*39.5;  %scan rate of pressure mats is 13.5 HZ
        for i=1:nframes
            
%          imagesc(I(:,:,i),[-15 -2])

          imagesc(I(:,:,i)+abs(min_I),[0 9.3])
 
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
        
%         implay('pps.avi')
        

  %% Testing COP calculation 
        
testmatrix = [4,10; 20, 0];

imagesc(testmatrix); 
colorbar

        rm=(0:3); rm=rm'; rm=rm(:);
        CoP1=[sum(testmatrix(:,1:4).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1]; % mat 1
        

end 



% Feb 2021. Function used to compute center of pressure offline post
% experiment.


function [CoP1,CoP2,stdMat1,stdMat2]=  ComputeCOP(ppsdata)


        ppsdata= ppsdata{1,2};
        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);
        Pressuremat1 = ppsdata(:,1:256);
        Pressuremat2 = ppsdata(:,257:end);
       
       
        nframes=size(ppsdata,1);
        maxmat1= max(Pressuremat1,[],2); %maximum pressure of mat 1 per each frame
        maxmat2= max(Pressuremat2(:,257:end),[],2); %maximum pressure of mat 2 per each frame
        
        Pressuremat1 =Pressuremat1./maxmat1; %normalized to the max on each frame for mat 1
        Pressuremat2 =Pressuremat2./maxmat2;%normalized to the max on each frame for mat 2
        
        
       % need to reshape to be a 16x16 where we have Nframes matrices
        Pressuremat1_frame= zeros(16,16,nframes);
        Pressuremat2_frame= zeros(16,16,nframes);
        for i = 1:nframes   
        Pressuremat1_frame(:,:,i) =reshape(Pressuremat1(i,:),[16,16]);
        Pressuremat2_frame(:,:,i) =reshape(Pressuremat2(i,:),[16,16]);
        end
        
        %plotting frames with for loop can click through all frames
        for i = 1:nframes
        subplot(2,1,1)   
        imagesc(Pressuremat1_frame(:,:,i))
        set(gca,'YDir','normal') 
        colorbar
        subplot(2,1,2)
        imagesc(Pressuremat2_frame(:,:,i))
        set(gca,'YDir','normal') 
        colorbar
        pause
        end
        
        %saving as a video and playing
        imagesc(Pressuremat1_frame(:,:,i))

        axis tight manual
        set(gca,'nextplot','replacechildren');
        set(gca,'YDir','normal') 
        v = VideoWriter('peaks.avi');
        open(v);
        
        for i=1:nframes
            imagesc(Pressuremat1_frame(:,:,i))
            frame = getframe(gcf);
            writeVideo(v,frame);
        end
        close(v);
        implay('peaks.avi')
        
       
        
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1];
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2];
        
        stdMat1 = std(CoP1); %gives standard deviation of x and y COP 
        stdMat2 = std(CoP2); %gives standard deviation of x and y COP 

        
        
% Figures showing average COP         
%         figure
%         plot(CoP1(:,1),CoP1(:,2),'o')
%         xlabel ('XCOP')
%         ylabel('YCOP')
%         title('Mat 1')
%         xlim([0 16])
%         ylim([0 16])
%         
%         figure
%         plot(CoP2(:,1),CoP2(:,2),'o')
%         xlabel ('XCOP')
%         ylabel('YCOP')
%         title('Mat 2')
%          xlim([0 16])
%         ylim([0 16])
        


        
%   
% %from test analysis creating video file
% Z = peaks;
% surf(Z); 
% axis tight manual 
% set(gca,'nextplot','replacechildren'); 
% v = VideoWriter('peaks.avi');
% open(v);
% for k = 1:20 
%    surf(sin(2*pi*k/20)*Z,Z)
%    frame = getframe(gcf);
%    writeVideo(v,frame);
% end
% 
% close(v);
% implay('peaks.avi')
%         
        

end 



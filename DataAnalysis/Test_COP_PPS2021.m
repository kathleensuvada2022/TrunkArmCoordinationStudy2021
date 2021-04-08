%% Script to calculate and plot COPs of mat 1 and 2     
%KCS2.3.2021
        
% load data file
        ppsdata = data.pps{2};
        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);

     
        nframes=size(ppsdata,1);
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1];
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2];
        
        figure
        scatter(CoP1(:,1),CoP1(:,2))
        xlabel ('XCOP')
        ylabel('YCOP')
        title('Mat 1')
        
        figure
        scatter(CoP2(:,1),CoP2(:,2))
        xlabel ('XCOP')
        ylabel('YCOP')
        title('Mat 2')
%         
%         set(myhandles.pps.hline(1),'Xdata',CoP1(:,1),'Ydata',CoP1(:,2))
%         set(myhandles.pps.hline(2),'Xdata',CoP2(:,1),'Ydata',CoP2(:,2))
%         set(myhandles.pps.hline(1),'Xdata',CoP1(:,1),'Ydata',CoP1(:,2))
%         set(myhandles.pps.hline(2),'Xdata',CoP2(:,1),'Ydata',CoP2(:,2))
%         

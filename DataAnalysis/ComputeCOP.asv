% Feb 2021. Function used to compute center of pressure offline post
% experiment. Integrate in with Analysis.m


%Where subtract the baseline??? Need to add this in as well !!!!!!!!

function [CoP1,CoP2]=  ComputeCOP(ppsdata)


        TotalPressure1 = sum(ppsdata(:,1:256),2); 
        TotalPressure2 = sum(ppsdata(:,257:end),2);

     
        nframes=size(ppsdata,1);
        rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
        CoP1=[sum(ppsdata(:,1:256).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure1 sum(ppsdata(:,1:256).*repmat(rm',nframes,1),2)./TotalPressure1];
        CoP2=[sum(ppsdata(:,257:end).*repmat((0:15)+0.5,nframes,16),2)./TotalPressure2 sum(ppsdata(:,257:end).*repmat(rm',nframes,1),2)./TotalPressure2];
        
        figure
        plot(CoP1(:,1),CoP1(:,2),'-o')
        xlabel ('XCOP')
        ylabel('YCOP')
        title('Mat 1')
        
        figure
        plot(CoP2(:,1),CoP2(:,2),'-o')
        xlabel ('XCOP')
        ylabel('YCOP')
        title('Mat 2')
%         

end 



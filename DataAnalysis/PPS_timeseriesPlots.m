% K. Suvada. May 2022 

% PPS_timeseriesPlots: This function for plotting minimizes the white space around the figures. Works
% much better than the subplot command. Pressure mat time series data.
% Calls created Matlab Function 'smplot'. Not built in.

% Input Arguments: 

% - pps_mat1: Pressure Mat Data Mat 1
% - pps_mat2: Pressure Mat Data Mat 2
% - tpps: Time vector via PPS
% - start_samp_M1: Starting sample for Mat 1 
% - end_samp_M1: Ending sample for M1 
% - mtrial_Num: The current trial number not the ACTUAL number but the
% trial counter for the current condition. Checking if it's the first 
% one for the set. 

% Output Arguments: 

% - sm and sm2: are the small plots - after setting these axes first trial,
% keep them as output variables so can plot next trial's traces. 

function [sm,sm2] = PPS_timeseriesPlots(pps_mat1,pps_mat2,tpps,start_samp_M1,end_samp_M1,start_samp_M2,end_samp_M2,mtrial_Num,sm,sm2)

% Splitting Mats in Half for Plotting

%Mat 1  - Participant's Left Side
%%
for i = 1:256 % Mat 1
  
        if i <=8
            figure(1)
            sm(i) = smplot(16,8,i+120,'axis','on');
            %sm(i) = smplot(16,16,i+240,'axis','on');
        end

        % Need to put 9 here  figure (2)
        
        if 16 < i && i <25
            figure(1)
            sm(i) = smplot(16,8,i+96,'axis','on');       
        end
              
        if 32 < i && i <41
            figure(1)
            sm(i) = smplot(16,8,i+72,'axis','on');
            
        end
   
        if 48 < i && i <57
            figure(1)
            sm(i) = smplot(16,8,i+48,'axis','on');
            
        end
           
        if 64 < i && i <73
            figure(1)
            sm(i) = smplot(16,8,i+24,'axis','on');
            
        end
                   
        if 80 < i && i <89
            figure(1)
            sm(i) = smplot(16,8,i,'axis','on');
            
        end
                           
        if 96 < i && i <104
            figure(1)
            sm(i) = smplot(16,8,i-24,'axis','on');
            
        end
                                   
        if 112 < i && i <121
            figure(1)
            sm(i) = smplot(16,8,i-48,'axis','on');
            
        end
        
                                           
        if 128 < i && i <137
            figure(1)
            sm(i) = smplot(16,8,i-72,'axis','on');
            
        end
                                                   
        if 144 < i && i <153
            figure(1)
            sm(i) = smplot(16,8,i-96,'axis','on');
            
        end
                                                           
        if 160 < i && i <169
            figure(1)
            sm(i) = smplot(16,8,i-120,'axis','on');
            
        end
                                                                   
        if 176 < i && i <185
            figure(1)
            sm(i) = smplot(16,8,i-144,'axis','on');
            
        end
                                                                           
        if 192 < i && i <201
            figure(1)
            sm(i) = smplot(16,8,i-168,'axis','on');
            
        end
        
                                                                                   
        if 208 < i && i <217
            figure(1)
            sm(i) = smplot(16,8,i-192,'axis','on');
            
        end
        
                                                                                   
        if 224 < i && i <233
            figure(1)
            sm(i) = smplot(16,8,i-216,'axis','on');
            
        end
                                                                                           
        if 240 < i && i <249
            figure(1)
            sm(i) = smplot(16,8,i-240,'axis','on');
            
        end
        
        axis tight
        plot(sm(i),tpps,pps_mat1(:,i))
        title(['Element' ' ' num2str(i)])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])

        hold on



        % Need other half of mat 

end
    %%


% Mat 2
 figure(18)
for i = 1:256
    
    if mtrial_Num ==1
        if i <=16
            sm2(i) = smplot(16,16,i+240,'axis','on');
        end
        
        if 16 < i && i <33
            sm2(i) = smplot(16,16,i+208,'axis','on');
            
        end
        
        if 32 < i && i <49
            sm2(i) = smplot(16,16,i+176,'axis','on');
            
        end
        
        if 48 < i && i <65
            sm2(i) = smplot(16,16,i+144,'axis','on');
            
        end
        
        if 64 < i && i <81
            sm2(i) = smplot(16,16,i+112,'axis','on');
            
        end
        
        if 80 < i && i <97
            sm2(i) = smplot(16,16,i+80,'axis','on');
            
        end
        
        if 96 < i && i <113
            sm2(i) = smplot(16,16,i+48,'axis','on');
            
        end
        
        if 112 < i && i <129
            sm2(i) = smplot(16,16,i+16,'axis','on');
            
        end
        
        
        if 128 < i && i <145
            sm2(i) = smplot(16,16,i-16,'axis','on');
            
        end
        
        if 144 < i && i <161
            sm2(i) = smplot(16,16,i-48,'axis','on');
            
        end
        
        if 160 < i && i <177
            sm2(i) = smplot(16,16,i-80,'axis','on');
            
        end
        
        if 176 < i && i <193
            sm2(i) = smplot(16,16,i-112,'axis','on');
            
        end
        
        if 192 < i && i <209
            sm2(i) = smplot(16,16,i-144,'axis','on');
            
        end
        
        
        if 208 < i && i <225
            sm2(i) = smplot(16,16,i-176,'axis','on');
            
        end
        
        
        if 224 < i && i <241
            sm2(i) = smplot(16,16,i-208,'axis','on');
            
        end
        
        if 240 < i && i <257
            sm2(i) = smplot(16,16,i-240,'axis','on');
            
        end
        
        
        axis tight
        plot(sm2(i),tpps(1:end_samp_M2),pps_mat2((1:end_samp_M2),i))
%         plot(sm2(i),tpps,pps_mat2(:,i),i)
%         hold on
%         xline(start_samp_M2,'g')
%         xline(end_samp_M2,'r')
        set(gca,'xticklabel',[])
        title(['Element' ' ' num2str(i+256)])
        hold on
        
    else
        plot(sm2(i),tpps(1:end_samp_M2),pps_mat2((1:end_samp_M2),i))
%         plot(sm2(i),tpps,pps_mat2(:,i),i)
%         hold on
%         xline(start_samp_M2,'g')
%         xline(end_samp_M2,'r')
        set(gca,'xticklabel',[])
        title(['Element' ' ' num2str(i+256)])
    end
    
end



end


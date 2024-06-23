% K. Suvada. May 2022 

% K. Suvada June 2024 - splitting each mat in half to view full trial
% better

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

% Figure 1 is participant's Right Side
% Figure 2 is participant's Left Side 

for i = 1:256 % Mat 1
  
        if i <=8
            figure(1)
            sm(i) = smplot(16,8,i+120,'axis','on');
            %sm(i) = smplot(16,16,i+240,'axis','on');
        end

        % Need to put 9 here  figure (2)

        if 8 < i && i <17
            figure(2)
            sm(i) = smplot(16,8,i+112,'axis','on');       
        end
        
        if 16 < i && i <25
            figure(1)
            sm(i) = smplot(16,8,i+96,'axis','on');       
        end

        if 24 < i && i <33
            figure(2)
            sm(i) = smplot(16,8,i+88,'axis','on');       
        end

        if 32 < i && i <41
            figure(1)
            sm(i) = smplot(16,8,i+72,'axis','on');
            
        end
      
        if 40 < i && i <49
            figure(2)
            sm(i) = smplot(16,8,i+64,'axis','on');
            
        end
   
        if 48 < i && i <57
            figure(1)
            sm(i) = smplot(16,8,i+48,'axis','on');
            
        end

      
        if 56 < i && i <65
            figure(2)
            sm(i) = smplot(16,8,i+40,'axis','on');
            
        end
        
        if 64 < i && i <73
            figure(1)
            sm(i) = smplot(16,8,i+24,'axis','on');
            
        end

        if 72 < i && i <81
            figure(2)
            sm(i) = smplot(16,8,i+16,'axis','on');     
        end
                   
        if 80 < i && i <89
            figure(1)
            sm(i) = smplot(16,8,i,'axis','on');
            
        end

        if 88 < i && i <97
            figure(2)
            sm(i) = smplot(16,8,i-8,'axis','on');     
        end
                
                           
        if 96 < i && i <105
            figure(1)
            sm(i) = smplot(16,8,i-24,'axis','on');
            
        end

        if 104< i && i <113
            figure(2)
            sm(i) = smplot(16,8,i-32,'axis','on');     
        end
       
             
                                   
        if 112 < i && i <121
            figure(1)
            sm(i) = smplot(16,8,i-48,'axis','on');
            
        end
        
        if 120< i && i <129
            figure(2)
            sm(i) = smplot(16,8,i-56,'axis','on');     
        end     
                                           
        if 128 < i && i <137
            figure(1)
            sm(i) = smplot(16,8,i-72,'axis','on');
            
        end

        if 136< i && i <145
            figure(2)
            sm(i) = smplot(16,8,i-80,'axis','on');     
        end   
                                                   
        if 144 < i && i <153
            figure(1)
            sm(i) = smplot(16,8,i-96,'axis','on');
            
        end

        if 152< i && i <161
            figure(2)
            sm(i) = smplot(16,8,i-104,'axis','on');     
        end   
              
                                                           
        if 160 < i && i <169
            figure(1)
            sm(i) = smplot(16,8,i-120,'axis','on');
            
        end

        if 168< i && i <177
            figure(2)
            sm(i) = smplot(16,8,i-128,'axis','on');     
        end   
                                                                   
        if 176 < i && i <185
            figure(1)
            sm(i) = smplot(16,8,i-144,'axis','on');
            
        end


        if 184< i && i <193
            figure(2)
            sm(i) = smplot(16,8,i-152,'axis','on');     
        end   
               
                                                                           
        if 192 < i && i <201
            figure(1)
            sm(i) = smplot(16,8,i-168,'axis','on');
            
        end

        if 200< i && i <209
            figure(2)
            sm(i) = smplot(16,8,i-176,'axis','on');     
        end   
               
        
                                                                                   
        if 208 < i && i <217
            figure(1)
            sm(i) = smplot(16,8,i-192,'axis','on');
            
        end

        if 216< i && i <225
            figure(2)
            sm(i) = smplot(16,8,i-200,'axis','on');     
        end   
               
        
                                                                                   
        if 224 < i && i <233
            figure(1)
            sm(i) = smplot(16,8,i-216,'axis','on');
            
        end

        if 232< i && i <241
            figure(2)
            sm(i) = smplot(16,8,i-224,'axis','on');     
        end   
               
        
                                                                                           
        if 240 < i && i <249
            figure(1)
            sm(i) = smplot(16,8,i-240,'axis','on');
            
        end
        

        if 248< i && i <= 256
            figure(2)
            sm(i) = smplot(16,8,i-248,'axis','on');     
        end   
               
        
        axis tight
        plot(sm(i),pps_mat1(:,i))
        title(['Element' ' ' num2str(i)])
        set(gca,'xticklabel',[])
%         set(gca,'yticklabel',[])

        hold on



        xline(start_samp_M1,'g','Linewidth',2)
        xline(end_samp_M1,'r','Linewidth',2)

end
    %%

'Both Sides of Mat 1 Displayed'

% pause



% Mat 2

for i = 1:256
     
        if i <=8
            figure(3)
            sm(i) = smplot(16,8,i+120,'axis','on');
            %sm(i) = smplot(16,16,i+240,'axis','on');
        end

        % Need to put 9 here  figure (2)

        if 8 < i && i <17
            figure(4)
            sm(i) = smplot(16,8,i+112,'axis','on');       
        end
        
        if 16 < i && i <25
            figure(3)
            sm(i) = smplot(16,8,i+96,'axis','on');       
        end

        if 24 < i && i <33
            figure(4)
            sm(i) = smplot(16,8,i+88,'axis','on');       
        end

        if 32 < i && i <41
            figure(3)
            sm(i) = smplot(16,8,i+72,'axis','on');
            
        end
      
        if 40 < i && i <49
            figure(4)
            sm(i) = smplot(16,8,i+64,'axis','on');
            
        end
   
        if 48 < i && i <57
            figure(3)
            sm(i) = smplot(16,8,i+48,'axis','on');
            
        end

      
        if 56 < i && i <65
            figure(4)
            sm(i) = smplot(16,8,i+40,'axis','on');
            
        end
        
        if 64 < i && i <73
            figure(3)
            sm(i) = smplot(16,8,i+24,'axis','on');
            
        end

        if 72 < i && i <81
            figure(4)
            sm(i) = smplot(16,8,i+16,'axis','on');     
        end
                   
        if 80 < i && i <89
            figure(3)
            sm(i) = smplot(16,8,i,'axis','on');
            
        end

        if 88 < i && i <97
            figure(4)
            sm(i) = smplot(16,8,i-8,'axis','on');     
        end
                
                           
        if 96 < i && i <105
            figure(3)
            sm(i) = smplot(16,8,i-24,'axis','on');
            
        end

        if 104< i && i <113
            figure(4)
            sm(i) = smplot(16,8,i-32,'axis','on');     
        end
       
             
                                   
        if 112 < i && i <121
            figure(3)
            sm(i) = smplot(16,8,i-48,'axis','on');
            
        end
        
        if 120< i && i <129
            figure(4)
            sm(i) = smplot(16,8,i-56,'axis','on');     
        end     
                                           
        if 128 < i && i <137
            figure(3)
            sm(i) = smplot(16,8,i-72,'axis','on');
            
        end

        if 136< i && i <145
            figure(4)
            sm(i) = smplot(16,8,i-80,'axis','on');     
        end   
                                                   
        if 144 < i && i <153
            figure(3)
            sm(i) = smplot(16,8,i-96,'axis','on');
            
        end

        if 152< i && i <161
            figure(4)
            sm(i) = smplot(16,8,i-104,'axis','on');     
        end   
              
                                                           
        if 160 < i && i <169
            figure(3)
            sm(i) = smplot(16,8,i-120,'axis','on');
            
        end

        if 168< i && i <177
            figure(4)
            sm(i) = smplot(16,8,i-128,'axis','on');     
        end   
                                                                   
        if 176 < i && i <185
            figure(3)
            sm(i) = smplot(16,8,i-144,'axis','on');
            
        end


        if 184< i && i <193
            figure(4)
            sm(i) = smplot(16,8,i-152,'axis','on');     
        end   
               
                                                                           
        if 192 < i && i <201
            figure(3)
            sm(i) = smplot(16,8,i-168,'axis','on');
            
        end

        if 200< i && i <209
            figure(4)
            sm(i) = smplot(16,8,i-176,'axis','on');     
        end   
               
        
                                                                                   
        if 208 < i && i <217
            figure(3)
            sm(i) = smplot(16,8,i-192,'axis','on');
            
        end

        if 216< i && i <225
            figure(4)
            sm(i) = smplot(16,8,i-200,'axis','on');     
        end   
               
        
                                                                                   
        if 224 < i && i <233
            figure(3)
            sm(i) = smplot(16,8,i-216,'axis','on');
            
        end

        if 232< i && i <241
            figure(4)
            sm(i) = smplot(16,8,i-224,'axis','on');     
        end   
               
        
                                                                                           
        if 240 < i && i <249
            figure(3)
            sm(i) = smplot(16,8,i-240,'axis','on');
            
        end
        

        if 248< i && i <= 256
            figure(4)
            sm(i) = smplot(16,8,i-248,'axis','on');     
        end   
               
        
        axis tight
        plot(sm(i),pps_mat2(:,i))
        title(['Element' ' ' num2str(i+256)])

        set(gca,'xticklabel',[])
%         set(gca,'yticklabel',[])

        hold on

        xline(start_samp_M2,'g','Linewidth',2)
        xline(end_samp_M2,'r','Linewidth',2)

end

'Both Sides of Mat 2 Displayed'

pause

end


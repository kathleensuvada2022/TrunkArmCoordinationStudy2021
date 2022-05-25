% K. Suvada. May 2022 

% CleanupCOP: Function to omit COP values that deviate beyond the average
% of the samples until the start of the reach. Also omits if negative. mat
% 2

function [CleanCOP] = CleanupCOP(COP,startSamp,endSamp,mfname,partid,hand,expcond)
if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
    
    if expcond==1
        
        if strcmp(mfname,'/trial1.mat')
            CleanCOP= COP;
            
            
        elseif strcmp(mfname,'/trial2.mat')
            CleanCOP= COP;
            
        else
            
            
            avgtrial = mean(COP(startSamp:startSamp+10,:));
            stdtrial = std(COP(startSamp:startSamp+10,:));
            
            [r c] = find (COP(startSamp:endSamp,:)> (avgtrial+stdtrial));
            [r2 c] = find (COP(startSamp:endSamp,:)< (avgtrial-stdtrial));
            Omit_COP = [r; r2];
            COP(Omit_COP+startSamp-1,:) =nan;
            CleanCOP= COP;
        end
        
    end
    
    if expcond ==2 
             
        if strcmp(mfname,'/trial11.mat')
            CleanCOP= COP;
        end
        
        
    end 
    
end

end


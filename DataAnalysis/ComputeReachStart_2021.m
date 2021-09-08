function [dist,vel,distmax,timestart,timevelmax,timeend,timedistmax,idx]=ComputeReachStart_2021(metdata,setup,mridx,expcond,partid,mfname,hand)

%% Loading in ACT3D Data
%Use if plotting ACT3D data
% 
% Xpos = actdata(:,2);
% Ypos = actdata(:,3);
% Zpos = actdata(:,4);
% 
% Xvel = actdata(:,9);
% Yvel = actdata(:,10);
% Zvel = actdata(:,11);

%% Loading in Metria Data
% Sampling Rate for Metria is 89 HZ

t = (metdata(:,2)-metdata(1,2))/89;


x = metdata;
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

% Creating Variables for Hand, Trunk Shoulder, Forearm, and Humerus
[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xarm=x(:,aidx:(aidx+6)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshoulder=x(:,sidx:(sidx+ 6)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1)+1;
xtrunk=x(:,tidx:(tidx+6)); 
lcsfore=zeros(2*nimag,2);

%% Computing 3rd MCP position from forearm 
for i=1:nimag % loop through time points
    % For the 3rd metacarpal grabbing the forearm marker
    Tftom = quat2tform(circshift(xfore(i,4:7),1,2));
    Tftom(1:3,4) = xfore(i,1:3)';% Transformation matrix for forearm in time i
%     Tftom= [reshape(x(i,fidx+(2:13)),4,3)';[0 0 0 1]]; % Transformation matrix for forearm in time i
%      BLg=(Tftom)*setup.bl.lcs{4}(:,4);  %grabbing the XYZ point of the 3rd metacarpal in the LCS and
%        BLg = Tftom*(bl{1,4}(4,1:4))';
%       BLg=Tftom *[bl{4}(4,1:3) 1]'; From GetHandShoulderTrunkPosition8
 
      BLg=Tftom *setup.bl{1,4}(1:4,4) ; %changed from BL file 
      xhand(i,:)=BLg(1:3,1)'; % X Y Z of the BL in global cs and rows are time 
      lcsfore(2*i-1:2*i,:)=Tftom(1:2,1:2);
% for the acromion using the shoulder marker 
%     Tstom= reshape(x(i,sidx+(2:13)),4,3)'; % grabbing the HT of the shoulder marker 
%     Tstom = [Tstom;0 0 0 1]; 
%     BLg2=(Tstom) *setup.bl.lcs{2}(:,1);  %grabbing the XYZ point of the anterior acromion in the LCS
%     xshldr(i,:)=BLg2(1:3,1)'; % X Y Z of BL in the global frame and rows are time 
end

%% Resampling Xhand 

[xhand2,t2]=resampledata(xhand,t,100,89); %250x3 X,Y,Z across time


%% Finding Distance and Vel -- Updated May 2021 for Metria Data 

%using original data
Xo= nanmean(xhand(1:5,1));
Yo = nanmean(xhand(1:5,2)); 
Zo = nanmean(xhand(1:5,3)); 

%dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2);

%using Resampled Data
Xo = nanmean(xhand2(1:50,1));
Yo = nanmean(xhand2(1:50,2)); 
Zo = nanmean(xhand2(1:50,3)); 

dist2 =sqrt((xhand2(:,1)-Xo).^2 +(xhand2(:,2)-Yo).^2 + (xhand2(:,3)-Zo).^2);
dist2 = dist2(:)-dist2(1);

% Computing Velocity and resampling 
%vel = ddt(smo(dist,3),1/89);
%[vel2,t2] = resampledata(vel,t,100,89);

velx= ddt(smo(xhand(:,1),3),1/89);
vely= ddt(smo(xhand(:,2),3),1/89);


velx2= ddt(smo(xhand2(:,1),3),1/89);
vely2= ddt(smo(xhand2(:,2),3),1/89);


vel = sqrt(velx.^2+vely.^2);
vel2= sqrt(velx2.^2+vely2.^2);
%% Finding Time Points 

idx=zeros(1,4); % creating variable with the indices of vel and distance
% Max distance
distmax = max(dist(1:70));
idx(3)= find(dist==distmax,1);
distmax = distmax+abs(min(dist));

% Finding Max Vel
 maxvel =max(vel(10:idx(3)));
 idx(2)= find(vel==maxvel) ;
% Start Reach
idx(1) = find(abs(dist)>=abs(.06*dist(mridx)),1);% reach start when participant is 5% of max distance


%% Correcting if issues with reach start
% RTIS 1004
 if  strcmp(partid,'RTIS1004') 
        if expcond==1 

        idx(1) = find(dist>=.015*dist(mridx),1);% reach start when participant is 5% of max distance
            if strcmp(mfname,'/trial6.mat')
                idx(1)=idx(1)-2;
            end
            
            if strcmp(mfname,'/trial10.mat')
                idx(1)=idx(1)-2;
            end 
        end 
        
        if expcond==2
            idx(1) = find(dist>=.05*dist(mridx),1);% reach start when participant is 5% of max distance
            if strcmp(mfname,'/trial25.mat')
                idx(1)=idx(1)-2;
            end
            
        end
        
        
        if expcond==4
            idx(1) = find(dist>=.05*dist(mridx),1);% reach start when participant is 5% of max distance
            if strcmp(mfname,'/trial36.mat')
                idx(1)=idx(1)-5;
            end
            
            if strcmp(mfname,'/trial37.mat')
                idx(1)=idx(1)-5;
            end
            
            
            if strcmp(mfname,'/trial38.mat')
                idx(1)=idx(1)-5;
            end
            
            if strcmp(mfname,'/trial39.mat')
                idx(1)=idx(1)-5;
            end
            
            
            if strcmp(mfname,'/trial44.mat')
                idx(1)=idx(1)-5;
            end
            
        end
        
        
        if expcond==5
             
            if strcmp(mfname,'/trial51.mat')
                idx(1)=idx(1)-5;
            
            end 
        end
        
        
        if expcond==6
             
            if strcmp(mfname,'/trial62.mat')
                idx(1)=idx(1)-5;
            
            end 
            
             if strcmp(mfname,'/trial64.mat')
                idx(1)=idx(1)-5;
            
            end 
        end 
     
     
 end

%% RTIS 1005

if strcmp(partid,'RTIS1005') 
           
    if expcond==1 

        idx(1) = find(dist>=.02*dist(mridx),1);% reach start when participant is 5% of max distance
      
    end 
    
    if expcond==2
        idx(1) = find(dist>=.025*dist(mridx),1);% reach start when participant is 5% of max distance
        if strcmp(mfname,'/trial14.mat')
            distMax= max(dist(1:60));
            idx(3)=find(dist==distMax,1);
        end
        
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)+20;
        end
        if strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)+10;
        end
        
        
        if strcmp(mfname,'/trial23.mat')
            idx(1) = idx(1)+10;
        end
        
    end
    
    if expcond ==3 
              
        idx(1) = find(dist>=.025*dist(mridx),1);% reach start when participant is 5% of max distance
           
        if strcmp(mfname,'/trial19.mat')
            
            idx(1) = idx(1)+15;
          
        end
        
        
        if strcmp(mfname,'/trial28.mat')
            maxdistint = max(dist);
            idx(3) = find(dist==maxdistint,1);
          
        end
        
        
        if strcmp(mfname,'/trial29.mat')
            
            idx(3) = idx(3)+14;
          
        end
  
    end 
    
    if expcond ==4 
          if strcmp(mfname,'/trial33.mat')
            
            idx(1) = idx(1)-10;
          
            
          end
          
          
          if strcmp(mfname,'/trial37.mat')
            
            idx(1) = idx(1)-10;
            xhand = xhand2;
            dist= dist2;
            t= t2;
            vel = vel2;
            velx = velx2;
            vely=vely2;
            
          end
        
        
    end
    
    
    
    if expcond ==5
              
        idx(1) = find(dist>=.025*dist(mridx),1);
    end 

    if expcond ==6 
          
        idx(1) = find(dist>=.025*dist(mridx),1);
          
        if strcmp(mfname,'/trial41.mat')
            maxdistint= max(dist)
            idx(3) = find(dist==maxdistint);
       
           
        end
            
    
    end         
        
   
    
    
end


%% RTIS1006
if strcmp(partid,'RTIS1006') 
    if expcond ==1 
            
        idx(1) = find(dist>=.01*dist(mridx),1);% reach start when participant is 5% of max distance
        if strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1)-5;
        end 
    end
    
    if expcond ==4
            
        if strcmp(mfname,'/trial87.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial88.mat')
            idx(1) = idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial90.mat')
            idx(1) = idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial91.mat')
            idx(1) = idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial92.mat')
            idx(1) = idx(1)-5;
        end 
    end 
    
    if expcond==6
       
        if strcmp(mfname,'/trial86.mat')
            idx(3) = find(dist==max(dist),1);
        end 
        
    end 

    
    
end
 %% RTIS 2001 Paretic
if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
    
    if expcond ==1 

    if strcmp(mfname,'/trial9.mat')
        idx(1)= idx(1)-5;
    end 
    end
    
    if expcond ==3 
       
    if strcmp(mfname,'/trial22.mat')
        idx(1)= idx(1)+10;
    end
    
    
    if strcmp(mfname,'/trial26.mat')
        idx(1)= idx(1)+10;
    end
    
    
    if strcmp(mfname,'/trial28.mat')
        idx(1)= idx(1)+21;
    end
    
    
    if strcmp(mfname,'/trial29.mat')
        idx(1)= idx(1)+26;
    end
    end
    
    
    if expcond ==4 
       
        
    if strcmp(mfname,'/trial47.mat')
        idx(1)= idx(1)-6;
    end 
        
            
    if strcmp(mfname,'/trial49.mat')
        idx(1)= idx(1)-6;
    end 
        
        
    end 
    
    if expcond ==5 
       
     
    if strcmp(mfname,'/trial40.mat')
        idx(1)= idx(1)+10;
    end
    
    
    if strcmp(mfname,'/trial60.mat')
        idx(1)= idx(1)+15;
    end
    
    
    
    if strcmp(mfname,'/trial61.mat')
        idx(1)= idx(1)+5;
    end 
        
    end 
    
    if expcond ==6 
     
        
    if strcmp(mfname,'/trial43.mat')
        idx(1)= idx(1)+12;
    end
    
    
    if strcmp(mfname,'/trial52.mat')
        idx(1)= idx(1)+15;
    end
    
    
    if strcmp(mfname,'/trial53.mat')
        idx(1)= idx(1)+10;
        velint = max(vel(idx(1):idx(3)));
        idx(2) = find(vel==velint,1);
        
    end
    
    
    if strcmp(mfname,'/trial56.mat')
        idx(1)= idx(1)+15;
        
    end 
    
    
    end 



end



%% RTIS 2003 Paretic 

if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
   if expcond ==1 

  
    if strcmp(mfname,'/trial17.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial18.mat')
        idx(1)= idx(1)-3;
    end  
    
    if strcmp(mfname,'/trial19.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial20.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial21.mat')
        idx(1)= idx(1)-5;
    end
    
    
    if strcmp(mfname,'/trial34.mat')
        idx(1)= idx(1)-5;
    end
    
    
    if strcmp(mfname,'/trial37.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial38.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial39.mat')
        idx(1)= idx(1)-3;
    end
          
   end
   
   if expcond ==2 
  
    if strcmp(mfname,'/trial23.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial24.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial25.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial27.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial41.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial42.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial43.mat')
        idx(1)= idx(1)-3;
    end 
    
    
   end 
    
   if expcond == 3
         
       
    if strcmp(mfname,'/trial29.mat')
        idx(1)= idx(1)-3;
    end
    
    
    if strcmp(mfname,'/trial30.mat')
        idx(1)= idx(1)-13;
    end  
       
   end 
  
if expcond ==4 
     
    if strcmp(mfname,'/trial57.mat')
        idx(1)= idx(1)-6;
    end
    
    if strcmp(mfname,'/trial73.mat')
        idx(1)= idx(1)-6;
    end
    
    
    if strcmp(mfname,'/trial74.mat')
        idx(1)= idx(1)-6;
    end 
    
end 
 
if expcond==5 
    if strcmp(mfname,'/trial64.mat')
        idx(1)= idx(1)-6;
    end
    
    if strcmp(mfname,'/trial7.mat')
        idx(1)= idx(1)-3;
    end
    
        
    if strcmp(mfname,'/trial80.mat')
        idx(1)= idx(1)-3;
    end 
    
    
end 
   
if expcond ==6
    
     
    if strcmp(mfname,'/trial70.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial71.mat')
        idx(1)= idx(1)-3;
    end
    
    if strcmp(mfname,'/trial82.mat')
        idx(1)= idx(1)-5;
    end
    
    if strcmp(mfname,'/trial83.mat')
        idx(1)= idx(1)+15;
    end 
    
end 
    
    
end
%% RTIS 2003 Non-Paretic
if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
idx(1) = find(dist>=.02*max(dist),1); 

if expcond ==4
  
    if strcmp(mfname,'/trial69.mat')
        idx(1)= idx(1)-5;
    end
    
    if strcmp(mfname,'/trial70.mat')
        idx(1)= idx(1)-5;
    end
    
    
    if strcmp(mfname,'/trial85.mat')
        idx(1)= idx(1)-5;
    end
    
end 
    
    
end





%% RTIS 2006 -Paretic

if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
    if expcond==1 
    idx(1) = find(dist>=.02*max(dist),1); 
    
    if strcmp(mfname,'/trial22.mat')
        idx(1)= idx(1)+15;
    end 
    end
    
    if expcond ==2
    idx(1) = find(dist>=.02*max(dist),1); 
    end
    
    
    if expcond ==3
    idx(1) = find(dist>=.05*max(dist),1); 
       
    if strcmp(mfname,'/trial42.mat')
        idx(1)= idx(1)+2;
    end
    
    
    if strcmp(mfname,'/trial43.mat')
        idx(1)= idx(1)+5;
    end
    
    
    if strcmp(mfname,'/trial44.mat')
        idx(1)= idx(1)+3;
    end
    
    end
   
    if expcond==4      
        
    if strcmp(mfname,'/trial54.mat')
        idx(1)= idx(1)-4;
    end
    
    
    if strcmp(mfname,'/trial55.mat')
        idx(1)= idx(1)-4;
    end
    
    
    if strcmp(mfname,'/trial56.mat')
        idx(1)= idx(1)-4;
    end
    
    
    
    if strcmp(mfname,'/trial63.mat')
        idx(1)= idx(1)-4;
    end 
    
    
    end 
   
    if expcond==6
  
    if strcmp(mfname,'/trial61.mat')
        idx(1)= idx(1)-6;
    end 
    end

    
end 
    

%% RTIS 2006 Non-Paretic
if strcmp(partid,'RTIS2006') && strcmp(hand,'Left')
     
    if expcond==1 
    idx(1) = find(dist>=.02*max(dist),1); 
    
    if strcmp(mfname,'/trial8.mat')
        idx(1) = idx(1)-5;
    end
    end
    
    if expcond ==2 

    idx(1) = find(dist>=.02*max(dist),1); 
     
    end

    if expcond ==3

    idx(1) = find(dist>=.02*max(dist),1); 
     
    end

    if expcond ==4

    idx(1) = find(dist>=.02*max(dist),1); 
     
    end
    
 
    if expcond ==5 || 6

    idx(1) = find(dist>=.02*max(dist),1); 
     
    end 
end 


%% RTIS 2002 Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
       if expcond==1 
    idx(1) = find(dist>=.02*max(dist),1); 
    
       end  
       
       if expcond ==2 
           idx(1)= find(dist>=.05*max(dist),1); 
       end
       
       
       if expcond ==3
           if strcmp(mfname,'/trial12.mat')
           idx(1)=idx(1)+25;
           end
           
           
           
           if strcmp(mfname,'/trial23.mat')
           idx(1)=idx(1)+25;
           end
       end
       
       
       if expcond ==4
           if strcmp(mfname,'/trial40.mat')
           idx(1)=idx(1)-15;
           end
       end
       
       
       if expcond ==6
           if strcmp(mfname,'/trial50.mat')
           idx(1)=idx(1)+20;
           end
           
           if strcmp(mfname,'/trial51.mat')
           idx(1)=idx(1)+20;
           end
           
           if strcmp(mfname,'/trial54.mat')
           idx(1)=idx(1)+20;
           end
           
           
           if strcmp(mfname,'/trial55.mat')
           idx(1)=idx(1)+20;
           end
       end
       
end


%% RTIS 2002 Non-Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
    if expcond==1 
    idx(1) = find(dist>=.02*max(dist),1); 
    if strcmp(mfname,'/trial6.mat')
        idx(1) = idx(1)+5;
    end 
    end
    
    
    if expcond==4
    idx(1) = find(dist>=.02*max(dist),1); 
    if strcmp(mfname,'/trial53.mat')
        idx(1) = idx(1)-5;
    end
    
    if strcmp(mfname,'/trial74.mat')
        idx(1) = idx(1)-5;
    end 
    
    
    end
    
    
    if expcond ==5 
    if strcmp(mfname,'/trial64.mat')
        idx(3) = find(dist==max(dist),1);
        idx(2) = find(vel== max(vel(idx(1):idx(3))));
    
    end  
    end 
       
end 
       

    
%% RTIS 2007 - Paretic 
if strcmp(partid,'RTIS2007') && strcmp(hand,'Right')
    
    if expcond==1 
      if   strcmp(mfname,'/trial2.mat')
          idx(1) = idx(2)-6;
      end
      
      if   strcmp(mfname,'/trial3.mat')
          idx(1) = idx(2)-6;
      end
      
      if   strcmp(mfname,'/trial22.mat')
          idx(1) = idx(2)-6;
      end 
    end
    
    if expcond==2 
        
      if   strcmp(mfname,'/trial8.mat')
          idx(1) = idx(1)+6;
      end
      
      
      if   strcmp(mfname,'/trial11.mat')
          idx(1) = idx(1)+10;
      end
      
      if   strcmp(mfname,'/trial12.mat')
          idx(1) = idx(1)+15;
      end  
    end
    
    
    if expcond ==3 
        
   idx(1) = find(dist>=.1*max(dist),1); 
       
   if   strcmp(mfname,'/trial13.mat')
          idx(1) = idx(1)-5;
     
   end
   
   
   if   strcmp(mfname,'/trial14.mat')
          idx(1) = 15;
     
   end
   
   
   if   strcmp(mfname,'/trial16.mat')
          idx(1) = idx(1)-5;
     
   end
   
   
   if   strcmp(mfname,'/trial32.mat')
          idx(1) = idx(1)-5;
     
   end
   
   if   strcmp(mfname,'/trial33.mat')
          idx(1) = idx(1)-5;
     
   end
   
   
   if   strcmp(mfname,'/trial34.mat')
          idx(1) = idx(1)-5;
     
   end
   
   if   strcmp(mfname,'/trial36.mat')
          idx(1) = idx(1)-5;
     
   end
   
   
    end
    
    if expcond ==5 
      
        if   strcmp(mfname,'/trial42.mat')
          idx(1) = idx(1)+10;
    
        end
        
        if   strcmp(mfname,'/trial44.mat')
          idx(1) = idx(1)+10;
    
        end
        
        if   strcmp(mfname,'/trial45.mat')
          idx(1) = idx(1)+10;
    
        end
        
        if   strcmp(mfname,'/trial46.mat')
          idx(1) = idx(1)+20;
    
        end
        
        if   strcmp(mfname,'/trial63.mat')
          idx(1) = idx(1)+20;
    
        end
        
        if   strcmp(mfname,'/trial64.mat')
          idx(1) = idx(1)+20;
    
        end
        
        if   strcmp(mfname,'/trial66.mat')
          idx(1) = idx(1)+15;
    
        end
        
        if   strcmp(mfname,'/trial68.mat')
          idx(1) = idx(1)+15;
    
        end 

    end 
    
    if expcond ==6
        
        if   strcmp(mfname,'/trial49.mat')
          idx(1) = idx(1)+15;
    
        end
        
        if   strcmp(mfname,'/trial50.mat')
          idx(1) = idx(1)+15;
    
        end
        
        if   strcmp(mfname,'/trial53.mat')
          idx(1) = idx(1)+15;
    
        end
        
        if   strcmp(mfname,'/trial56.mat')
          idx(1) = idx(1)+15;
    
        end  
        
        
        
    end 
    
end
%% RTIS 2008 Paretic 
if strcmp(partid,'RTIS2008') && strcmp(hand,'Right')
idx(1) = find(dist>=.02*max(dist),1); 

if expcond ==1 
           
    if   strcmp(mfname,'/trial6.mat')
        idx(1) =idx(1) +8;
    end
    
    if   strcmp(mfname,'/trial8.mat')
        idx(1) =idx(1) -5;
    end 

    
end

if expcond ==2

    if   strcmp(mfname,'/trial26.mat')
        idx(1) = idx(1)-3;
    end 

end 

if expcond ==3 
    
   
   if   strcmp(mfname,'/trial17.mat')
        idx(1) = idx(1)+20;
   end
   
   
   if   strcmp(mfname,'/trial18.mat')
        idx(1) = idx(1)+10;
   
   end
   
   if   strcmp(mfname,'/trial20.mat')
        idx(1) = idx(1)+15;
   
   end
   
   if   strcmp(mfname,'/trial21.mat')
        idx(1) = idx(1)+5;
   
   end 
    
end 


if expcond ==4 
   if   strcmp(mfname,'/trial42.mat')
        idx(1) = idx(1)-5;
   
   end
   
   
   if   strcmp(mfname,'/trial43.mat')
        idx(1) = idx(1)-5;
        idx(1) = idx(1)+ 10;
   end
   
   
   if   strcmp(mfname,'/trial45.mat')
        idx(1) = idx(1)-5;
   
   end   
    

end 

if expcond ==6 
    
    
   if   strcmp(mfname,'/trial39.mat')
        idx(1) = idx(1)+5;
   
   end      
    
end
end

%% RTIS 2008 Non-Paretic
 if strcmp(partid,'RTIS2008') && strcmp(hand,'Left')
    idx(1) = find(dist>=.02*max(dist),1); 
 
if expcond ==1 
         
    if   strcmp(mfname,'/trial4.mat')
           idx(1) = idx(1)-5;
       
    end

    
    if   strcmp(mfname,'/trial5.mat')
           idx(1) = idx(1)-5;
       
    end
    
    
    if   strcmp(mfname,'/trial9.mat')
           idx(1) = idx(1)-5;
       
    end
    
    if   strcmp(mfname,'/trial10.mat')
           idx(1) = idx(1)-2;
       
    end
       
end

if expcond == 3 
    
    if   strcmp(mfname,'/trial27.mat')
           idx(1) = idx(1)-5;
       
    end  
    
    
end

 end


%% RTIS 2009 - paretic 
if strcmp(partid,'RTIS2009') && strcmp(hand,'Left')
    if expcond ==1 
        idx(1) = find(dist>=.02*max(dist),1); 
        if   strcmp(mfname,'/trial1.mat')
           idx(1) = idx(1)-5;
        end
        
        if   strcmp(mfname,'/trial4.mat')
           idx(1) = idx(1)-5;
        end
        
        if   strcmp(mfname,'/trial9.mat')
           idx(1) = idx(1)-5;
        end 
    end
    
    if expcond ==2 
                
    idx(1) = find(dist>=.02*max(dist),1);
    
       if   strcmp(mfname,'/trial17.mat')
           idx(1) = idx(1)+15;
        end 
    end
    
    if expcond ==4
          
        if   strcmp(mfname,'/trial37.mat')
           idx(1) = idx(1)-10;
        end
        
        if   strcmp(mfname,'/trial38.mat')
           idx(1) = idx(1)-5;
        end 
        
    end 

    if expcond ==6 
        
        if   strcmp(mfname,'/trial48.mat')
           idx(1) = idx(1)-5;
        end
        
        
        if   strcmp(mfname,'/trial50.mat')
           idx(1) = idx(1)-5;
        end
        
        if   strcmp(mfname,'/trial57.mat')
           idx(1) = idx(1)-5;
        end
               
        if   strcmp(mfname,'/trial59.mat')
           idx(1) = idx(1)-5;
        end
    end 

end 

%% RTIS 2010 - paretic 
if strcmp(partid,'RTIS2010') && strcmp(hand,'Right')
        
    idx(1) = find(dist>=.015*max(dist),1); 
    
    if expcond ==1 
              
        if   strcmp(mfname,'/trial43.mat')
        idx(1) = idx(1)-4;
        end
        
        
        if   strcmp(mfname,'/trial46.mat')
        idx(1) = idx(1)-4;
        end
        
        
        if   strcmp(mfname,'/trial48.mat')
        idx(1) = idx(1)-3;
        end
        
        if   strcmp(mfname,'/trial49.mat')
        idx(1) = idx(1)-3;
        end
        
        
        if   strcmp(mfname,'/trial50.mat')
        idx(1) = idx(1)-3;
        end 
        
        
    end 

    
    if expcond ==2 
        
        if   strcmp(mfname,'/trial35.mat')
%         idx(1) = idx(1)+15;
        end
        
        if   strcmp(mfname,'/trial38.mat')
        idx(1) = idx(1)+15;
        end  
    end 
    
    if expcond ==3
           
        idx(1) = find(dist>=.2*max(dist),1); 

    end 
    
    if expcond==5 
            
        if   strcmp(mfname,'/trial74.mat')
            idx(1) = idx(1) +15;
        end 
    end
    
    if expcond==6
            
        if   strcmp(mfname,'/trial78.mat')
            idx(1) = idx(1) +15;
        end
        
        if   strcmp(mfname,'/trial79.mat')
            idx(1) = idx(1) +5;
        end
        
        if   strcmp(mfname,'/trial84.mat')
            idx(1) = idx(1) +5;
        end
        
        if   strcmp(mfname,'/trial86.mat')
            idx(1) = idx(1) +10;
        end 
    end 
       

    
end
%% RTIS 2011 Paretic

if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')

    idx(1) = find(dist>=.02*max(dist),1); 
    
    if expcond ==1
%            
        if   strcmp(mfname,'/trial4.mat')
            idx(1) = idx(1) +20;
            idx(3) = find(dist==max(dist(1:65)));
        end
        
        if   strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1) +20;
            idx(3) = find(dist==max(dist(1:65)));
        end
        
        if   strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1) +10;
            idx(3) = find(dist==max(dist(1:65)));
        end 
           
    end
    
    if expcond ==2 
               
        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1) +15;
        end
        if   strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1) +15;
        end
        
        if   strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1) +10;
        end
        
        
        if   strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1) +10;
        end
        
                
        if   strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1) +10;
        end
        if   strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1) +10;
        end
        
        if   strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1) +10;
        end  
        
    end
    
    if expcond ==3 
         
        if   strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1) +10;
        end
        
        if   strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1) +15;
        end   
                
        if   strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1) +15;
        end
        
        if   strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1) +10;
        end
        
        if   strcmp(mfname,'/trial34.mat')
            idx(1) = idx(1) +10;
        end
        
        if   strcmp(mfname,'/trial35.mat')
            idx(1) = idx(1) +15;
        end 
                
        if   strcmp(mfname,'/trial36.mat')
            idx(1) = idx(1) -5;
        end
        
        if   strcmp(mfname,'/trial37.mat')
            idx(1) = idx(1) +10;
        end
        
    end
    
    
    if expcond ==4 
       
           
        if   strcmp(mfname,'/trial40.mat')
            idx(1) = idx(1) +10;
        end
        
        
        if   strcmp(mfname,'/trial41.mat')
            idx(1) = idx(1) +10;
        end
        
        
        if   strcmp(mfname,'/trial64.mat')
            idx(1) = idx(1) +20;
        end
        
        
        if   strcmp(mfname,'/trial65.mat')
            idx(1) = idx(1) +20;
        end
        
        if   strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1) +10;
        end
        
        if   strcmp(mfname,'/trial68.mat')
            idx(1) = idx(1) +20;
        end 
        
    end
    
    if expcond ==5 
 
        if   strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1) +20;
        end
        
        if   strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1) +15;
        end
        
        
        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1) +10;
        end
        
        
        if   strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1) +20;
        end 
        
        
        
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1) +15;
        end 
        
        
        
    end
   
    
    if expcond ==6
        
         
        idx(1) = find(dist>=.1*max(dist),1); 
        
        if   strcmp(mfname,'/trial47.mat')
            velint = max(vel(idx(1) : idx(3)));
            idx(3) = find(vel==velint,1);
        end 
        
        
        
    end 
    
    
    
end

%%

 timestart = t(idx(1));
 timevelmax = t(idx(2));
 timedistmax = t(idx(3));

% Start Time 
% timestart = idx(1)*(1/89);% divide by sampling rate
% timevelmax = idx(2)*(1/89); % time when max velocity
% timedistmax = idx(3) *(1/89); %when at max dist
 timebefore = timestart-.05; %time 50 ms prior to start of reach
% timebefore =1;
 timeend = timedistmax+2;
%ibefore = ceil(timebefore*50); 
%% Plotting Data 

figure(2)
clf
 %subplot(5,1,1)
%ax = axes('position',[0.12,0.75,0.75,0.22]);
%plot(t(1:50),dist(1:50))
yyaxis left
plot(t,dist)
ylabel('Distance (mm)')
hold on
yyaxis right
plot(t,vel) 
plot(t,velx)
plot(t,vely)
ylabel('Velocity (mm/s)')
%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach

y1=ylim;
title('Trunk Muscles')
 p1 = line('Color','g','Xdata',[timestart timestart],'Ydata',[y1(1) y1(2)], 'LineWidth',.5); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); % max vel
p3= line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); %max, dist
%p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
%p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))
xlim([0.25 5])
xlabel('time in seconds')
legend('Distance','Velocity','Velx', 'Vely','Reach Start','Max Vel','Max Dist')

%%
figure(3)
clf
 subplot(5,1,1)
yyaxis left
plot(t,dist)
ylabel('Distance (mm)')
hold on
yyaxis right
plot(t,vel) 
plot(t,velx)
plot(t,vely)
ylabel('Velocity (mm/s)')
hold on

%  plot(timestart,dist(idx(1)),'-o') %reach start
%  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
%  plot(timebefore,dist(ibefore),'-o') %Time before
%  plot(timedistmax ,dist(idx(3)),'-o') %max distance
%  plot(timeend,dist(idx(4)),'-o') %end of reach
title('Reaching Arm Muscles')
y1=ylim;
p1 = line('Color','g','Xdata',[timestart timestart],'Ydata',[y1(1) y1(2)], 'LineWidth',.5); % start reach
p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); % max vel
p3= line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); %max, dist
%p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
%p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);

% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))

xlim([0.5 5])

xlabel('time in seconds')
legend('Distance','Velocity','Velx', 'Vely','Time Start','Max Vel','Max Dist')

end 
function [dist,vel,timestart,timevelmax,timeend,timedistmax]=ComputeReachStart_2021(metdata,setup,mridx,expcond,partid,mfname,hand)

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
Xo= nanmean(xhand(1:50,1));
Yo = nanmean(xhand(1:50,2)); 
Zo = nanmean(xhand(1:50,3)); 

%dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2);
dist = dist(:)-dist(1); %offsetting so not starting above 0

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

vel = sqrt(velx.^2+vely.^2);
%% Finding Time Points 

% ***** NOTE **** Shift EMG muscles back by 50 ms because they occur earlier than the
% movement itself.. Move back 

idx=zeros(1,4); % creating variable with the indices of vel and distance
%Finding Max Vel
 maxvel =max(vel(10:mridx));
 idx(2)= find(vel==maxvel) ;
 % ********subtract 50 samples from this number to have it align with the movement
 % better 

%Start Reach
%windowvel=vel(25:200);
%velcond =abs(windowvel)>=(270);
% distcond= find(abs(dist)>5,1);
% idx(1)= find(abs(xhand(10:100,2))-abs(xhand(1,2))>abs(xhand(10:100,1))-abs(xhand(1,1)),1); % when y displacement bigger than x displacement
% idx(1) = idx(1)+9;

idx(1) = find(abs(dist)>=abs(.06*dist(mridx)),1);% reach start when participant is 5% of max distance

%% Correcting if issues with reach start

%% RTIS 1004
if  strcmp(partid,'RTIS1004') 
  
   if (expcond==1 && strcmp(mfname,'/trial2.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.02*dist(mridx),1);% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==1 && strcmp(mfname,'/trial4.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.02*dist(mridx),1);% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==1 && strcmp(mfname,'/trial9.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.04*dist(mridx),1);% reach start when participant is 5% of max distance
   end
   
   
   
   if (expcond==2 && strcmp(mfname,'/trial23.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.14*dist(mridx),1)-3;% reach start when participant is 5% of max distance
   end
   
   if (expcond==2 && strcmp(mfname,'/trial24.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.04*dist(mridx),1)+6;% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial25.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.04*dist(mridx),1)+10;% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial26.mat')) % Trial containing artifact
    %  idx(1) = find(abs(dist)>=.04*dist(mridx),1);% reach start when participant is 5% of max distance
    idx(1) = idx(2);
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial27.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.10*dist(mridx),1)-4;% reach start when participant is 5% of max distance
   end
   
      
   if (expcond==2 && strcmp(mfname,'/trial28.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.10*dist(mridx),1)+6;% reach start when participant is 5% of max distance
   end
   
   if (expcond==2 && strcmp(mfname,'/trial30.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.06*dist(mridx),1)+8;% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial33.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.10*dist(mridx),1)+11;% reach start when participant is 5% of max distance
   end
   
     
   if (expcond==2 && strcmp(mfname,'/trial34.mat')) % Trial containing artifact
      idx(1) = find(abs(dist)>=.10*dist(mridx),1)+11;% reach start when participant is 5% of max distance
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial12.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
   end
   
   if (expcond==3 && strcmp(mfname,'/trial13.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial14.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial15.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
   end
   
    if (expcond==3 && strcmp(mfname,'/trial16.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
   end
   
   if (expcond==3 && strcmp(mfname,'/trial17.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+1;
   end
   
   if (expcond==3 && strcmp(mfname,'/trial20.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   if (expcond==3 && strcmp(mfname,'/trial21.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial35.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   if (expcond==4 && strcmp(mfname,'/trial36.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial37.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial38.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial41.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial42.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
   end
   
   if (expcond==4 && strcmp(mfname,'/trial43.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
   end  
   
   if (expcond==4 && strcmp(mfname,'/trial44.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial45.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
   end
   
   if (expcond==5 && strcmp(mfname,'/trial46.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial47.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial48.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial49.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
   end  
     
    if (expcond==5 && strcmp(mfname,'/trial51.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial52.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+11;
    end
    
    if (expcond==5 && strcmp(mfname,'/trial53.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(2);
    end
    
    if (expcond==5 && strcmp(mfname,'/trial54.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    end
    
    if (expcond==5 && strcmp(mfname,'/trial55.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial56.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial57.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+1;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial58.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial59.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial60.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial61.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+11;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial62.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial63.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial64.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial65.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial66.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
   

   
   
end


%% RTIS 1005

if strcmp(partid,'RTIS1005') 
                   
    if (expcond==1 && strcmp(mfname,'/trial6.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    if (expcond==1 && strcmp(mfname,'/trial10.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial11.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+23;
    end 
    if (expcond==2 && strcmp(mfname,'/trial12.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial13.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+25;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial14.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+18;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial15.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+23;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial21.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+28;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial22.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial23.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+19;
    end
        
    if (expcond==2 && strcmp(mfname,'/trial24.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+21;
    end
    if (expcond==2 && strcmp(mfname,'/trial25.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+19;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial16.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+18;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial17.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+20;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial18.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+22;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial19.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial20.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+20;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial26.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+22;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial27.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial28.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+22;
    end
    
    if (expcond==3 && strcmp(mfname,'/trial29.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
    end
    
    if (expcond==4 && strcmp(mfname,'/trial31.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    if (expcond==4 && strcmp(mfname,'/trial34.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    end
    
    if (expcond==4 && strcmp(mfname,'/trial35.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
    end
        
    if (expcond==4 && strcmp(mfname,'/trial36.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial37.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial38.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial39.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    if (expcond==5 && strcmp(mfname,'/trial51.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial53.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+29;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial54.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial55.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    if (expcond==5 && strcmp(mfname,'/trial57.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+20;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial60.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+11;
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial61.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+13;
    end
    
        
    if (expcond==6 && strcmp(mfname,'/trial41.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+28;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial42.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+17;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial43.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    end
    
    if (expcond==6 && strcmp(mfname,'/trial44.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+21;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial45.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+16;
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial46.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+18;
    end
end


%% RTIS1006
if strcmp(partid,'RTIS1006') 
    if (expcond==1 && strcmp(mfname,'/trial64.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    end
    
    if (expcond==1 && strcmp(mfname,'/trial65.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial66.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
    end   
    
        
    if (expcond==1 && strcmp(mfname,'/trial67.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial68.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial72.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    
    if (expcond==1 && strcmp(mfname,'/trial74.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end  
    
    
   if (expcond==2 && strcmp(mfname,'/trial53.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial54.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   if (expcond==2 && strcmp(mfname,'/trial55.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial56.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial57.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial58.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial59.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial60.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial61.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end
   
   if (expcond==2 && strcmp(mfname,'/trial62.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial42.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial43.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial44.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial46.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial48.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial49.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial51.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial52.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial87.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial88.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial89.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial90.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end 
   
      
   if (expcond==4 && strcmp(mfname,'/trial91.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial92.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial93.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
   
   if (expcond==4 && strcmp(mfname,'/trial94.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end 
   if (expcond==4 && strcmp(mfname,'/trial95.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial97.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
   
   
   if (expcond==4 && strcmp(mfname,'/trial98.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
  
   
   
   if (expcond==5 && strcmp(mfname,'/trial76.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+1;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial77.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial78.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   if (expcond==5 && strcmp(mfname,'/trial79.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end
   
   if (expcond==5 && strcmp(mfname,'/trial80.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial81.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial82.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+14;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial83.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial85.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial86.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial99.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+1;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial100.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial101.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    
   end 
   
   
end 


%% RTIS 2006 -Paretic 

if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
    
   if (expcond==2 && strcmp(mfname,'/trial27.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial28.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial29.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end 
   
      
   if (expcond==2 && strcmp(mfname,'/trial30.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   if (expcond==2 && strcmp(mfname,'/trial31.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial38.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   if (expcond==2 && strcmp(mfname,'/trial39.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial40.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   
   if (expcond==2 && strcmp(mfname,'/trial41.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end 
   
   if (expcond==3 && strcmp(mfname,'/trial42.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial43.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial44.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+4;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial45.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial46.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   if (expcond==3 && strcmp(mfname,'/trial47.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial48.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+2;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial49.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+3;
    
   end
   
   
   if (expcond==3 && strcmp(mfname,'/trial50.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
    
   end
   
   
   
   if (expcond==3 && strcmp(mfname,'/trial51.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+8;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial63.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial65.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   if (expcond==4 && strcmp(mfname,'/trial70.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial57.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    
   end
   if (expcond==5 && strcmp(mfname,'/trial75.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+11;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial76.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    
   end
   
   
   if (expcond==5 && strcmp(mfname,'/trial78.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    
   end
      
   if (expcond==5 && strcmp(mfname,'/trial79.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial62.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+19;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial71.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+19;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial73.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+6;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial66.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    
   end
   
   if (expcond==6 && strcmp(mfname,'/trial67.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial72.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+11;
    
   end
   
   
   if (expcond==6 && strcmp(mfname,'/trial74.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+9;
    
   end
   
end 
%% RTIS 2006 Non-Paretic
if strcmp(partid,'RTIS2006') && strcmp(hand,'Left')
    if (expcond==1 && strcmp(mfname,'/trial1.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    
  
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial2.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-6;
  
    end
    
    
    
    if (expcond==1 && strcmp(mfname,'/trial3.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-6;
  
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial4.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    if (expcond==1 && strcmp(mfname,'/trial5.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial6.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    if (expcond==1 && strcmp(mfname,'/trial7.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
       
    if (expcond==1 && strcmp(mfname,'/trial8.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end 
    
           
    if (expcond==1 && strcmp(mfname,'/trial9.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    
    if (expcond==1 && strcmp(mfname,'/trial10.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial16.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    if (expcond==2 && strcmp(mfname,'/trial19.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial20.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-7;
  
    end
    
    if (expcond==2 && strcmp(mfname,'/trial21.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial22.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end 
    
       
    if (expcond==2 && strcmp(mfname,'/trial25.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-8;
  
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial26.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial11.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-2;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial14.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial15.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    if (expcond==3 && strcmp(mfname,'/trial27.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-8;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial28.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial29.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-8;
  
    end
    
    if (expcond==3 && strcmp(mfname,'/trial30.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-8;
  
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial31.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    if (expcond==3 && strcmp(mfname,'/trial32.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    if (expcond==4 && strcmp(mfname,'/trial33.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial34.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial35.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    if (expcond==4 && strcmp(mfname,'/trial37.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial39.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
        
    if (expcond==4 && strcmp(mfname,'/trial40.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==4 && strcmp(mfname,'/trial41.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-4;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial55.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-1;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial57.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-7;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial58.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial59.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    
    if (expcond==5 && strcmp(mfname,'/trial60.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-8;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial61.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    if (expcond==5 && strcmp(mfname,'/trial62.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    if (expcond==5 && strcmp(mfname,'/trial63.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    
    if (expcond==6 && strcmp(mfname,'/trial44.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial45.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+5;
  
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial48.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial49.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    
    if (expcond==6 && strcmp(mfname,'/trial50.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
  
    end
    
    if (expcond==6 && strcmp(mfname,'/trial54.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
  
    end
    
end 

%% RTIS 2002 Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
    
    
    if (expcond==1 && strcmp(mfname,'/trial1.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
    end   
     
    if (expcond==1 && strcmp(mfname,'/trial2.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    
    if (expcond==1 && strcmp(mfname,'/trial6.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial7.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    if (expcond==1 && strcmp(mfname,'/trial9.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    if (expcond==1 && strcmp(mfname,'/trial10.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-3;
    end
    
    
    
    if (expcond==2 && strcmp(mfname,'/trial16.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial17.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+27;
    end
    
    
    
    if (expcond==2 && strcmp(mfname,'/trial18.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+27;
    end
    
    if (expcond==2 && strcmp(mfname,'/trial19.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+7;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial20.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial26.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+15;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial28.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+30;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial29.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+34;
    end
    
    
    if (expcond==2 && strcmp(mfname,'/trial30.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+10;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial11.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+14;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial12.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+29;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial13.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)-5;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial14.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+19;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial15.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+23;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial21.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+25;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial22.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+25
      
      idx(2) = find(max(vel(idx(1):mridx)),1)
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial23.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+30;
    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial24.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+23
           
      idx(2) = find(max(vel(idx(1)+1:mridx)),1)

    end
    
    
    if (expcond==3 && strcmp(mfname,'/trial25.mat')) % Trial containing artifact
      %idx(1) = find(abs(dist)>=.10*dist(mridx),1)+;% reach start when participant is 5% of max distance
      idx(1)=idx(1)+16;
    end
    
end

%%
% max distance
idx(3)= mridx; %pulled from gethandshouldtrunk8

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
xlim([0.5 5])
xlabel('time in seconds')
legend('Distance','Velocity','Velx', 'Vely','Reach Start','Max Vel','Max Dist')

%%
% figure(3)
% clf
%  subplot(5,1,1)
% yyaxis left
% plot(t,dist)
% ylabel('Distance (mm)')
% hold on
% yyaxis right
% plot(t,vel) 
% plot(t,velx)
% plot(t,vely)
% ylabel('Velocity (mm/s)')
% hold on
% 
% %  plot(timestart,dist(idx(1)),'-o') %reach start
% %  plot(timevelmax,vel(idx(2)),'-o') % Max velocity
% %  plot(timebefore,dist(ibefore),'-o') %Time before
% %  plot(timedistmax ,dist(idx(3)),'-o') %max distance
% %  plot(timeend,dist(idx(4)),'-o') %end of reach
% title('Reaching Arm Muscles')
% y1=ylim;
% p1 = line('Color','g','Xdata',[timestart timestart],'Ydata',[y1(1) y1(2)], 'LineWidth',.5); % start reach
% p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); % max vel
% p3= line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[y1(1) y1(2)],'LineWidth',.5); %max, dist
% %p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
% %p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);
% 
% % co=get(lax1,'ColorOrder');
% % set(lax1,'ColorOrder',co(end-1:-1:1,:))
% 
% xlim([0.5 5])
% 
% xlabel('time in seconds')
% legend('Distance','Velocity','Velx', 'Vely','Time Start','Max Vel','Max Dist')

end 
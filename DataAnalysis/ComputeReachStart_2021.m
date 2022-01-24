%% Compute Reach Start/End Times
% Using Metria Data, computing velocity , distance, and x and y velocity to
% find the start and end of reach. For stroke, need to use Z position as
% well to make sure they're off the table when reach trajectories are less
% obvious.

% Inputs:
% - t,xhand,xshldr,xjug: all created from Metria data file
% 'GetHandShoulderTrunkPost'
% - setup:setup file for participant
% - expcond: 1:6 for condition (see summary sheet)
% - partid: string participant ID
% - mfname: from 'Plotkinematicdata'.Metria file name as string.
% - hand: which hand as string.

% Outputs:
% - dist,vel,distmax: computed via 3rd MCP position (Metria)
% - idx: indices of start of reach idx(1) and end idx(3), max vel idx(2).
% - timestart,timevelmax,timedistmax: times in second of above
% - t: time vector
% - xhand: may be filled now when missing data.


% K.SUVADA 2021-2022
%%



function [dist,vel,distmax,idx,timestart,timevelmax, timedistmax,t,xhand]=ComputeReachStart_2021(t,xhand,xshldr,xjug,setup,expcond,partid,mfname,hand)
%% Resampling Xhand

[xhand2,t2]=resampledata(xhand,t,100,89); %250x3 X,Y,Z across time


%% Finding Distance and Vel -- Updated May 2021 for Metria Data

if sum(isnan(xhand)) %returns true now if any element is NAN
    %     'NAN are present'
    %     find(isnan(xhand))
    
    if strcmp(partid,'RTIS1006')
        if expcond==6 || expcond ==4
            
            [xhand,TF] = fillmissing(xhand,'spline');
            
        else
            [xhand,TF] = fillmissing(xhand,'spline','SamplePoints',t);
        end
        
    else
        [xhand,TF] = fillmissing(xhand,'spline','SamplePoints',t);
    end
    
end

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
vel = ddt(smo(dist,3),1/89);
%[vel2,t2] = resampledata(vel,t,100,89);

velx= ddt(smo(xhand(:,1),3),1/89);
vely= ddt(smo(xhand(:,2),3),1/89);

% Computing Angle of velocity vector
% ratio_vel = vely./velx;
% theta_vel = atand(ratio_vel);

theta_vel2 = atan2(vely,velx);
theta_vel2 = rad2deg(theta_vel2);


% velx2= ddt(smo(xhand2(:,1),3),1/89);
% vely2= ddt(smo(xhand2(:,2),3),1/89);
%
%
% vel = sqrt(velx.^2+vely.^2);
% vel2= sqrt(velx2.^2+vely2.^2);
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
idx(1) = find(abs(dist)>=abs(.06*max(dist)),1);% reach start when participant is 5% of max distance


%% Correcting if issues with reach start
% RTIS 1004
if  strcmp(partid,'RTIS1004')
    %
    %     %testing out using y vel for start idx
    %     pos_vely = find(vely>0);
    %
    %     if vely(pos_vely(1):pos_vely(1)+10) >0
    %         idxstart = pos_vely(1);
    %     else
    %         idxstart = pos_vely(2);
    %     end
    
    %
    end_reach = find(vel(1:75)>=.05*max(vel(1:75)));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    
    if expcond==1
        velcond = find(vel(1:75)>=.10*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(length(vUd));
        
        if strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1) -1;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(1) = idx(1) +4;
        end
        
        if strcmp(mfname,'/trial10.mat')
            idx(1) = idx(1) -1;
        end
    end
    
    if expcond==2
        velcond = find(vel(1:75)>=.10*max(vel(1:75)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1) +10;
        end
        
        if strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1) +9;
        end
        
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1) +10;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1) +10;
        end
        
        if strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1) +14;
        end
        
        if strcmp(mfname,'/trial33.mat')
            idx(1) = idx(1) +12;
        end
        
    end
    
    if expcond==3
        velcond = find(vel(1:75)>=.10*max(vel(1:75)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)+5;
        
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1) -7;
        end
        
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1) -8;
        end
        
        if strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1) -6;
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1) -8;
        end
        
        if strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1) +4;
        end
        
        if strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1) -10;
        end
    end
    
    
    if expcond ==4
        %% JAN 2022 KCS % USING DIST/VEL/ ANGLE
        
        % Finding idx(3) max distance
        velcond = find(vel(1:75)<=.10*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(1);
        
        %Finding Start of the Reach (idx(1))
        startvelcond = find(vel>=.05*max(vel)) ;     % finding velocity range
        
        % Did not need DIST condition -- will probably for stroke.
        %startdist_velcond = find(dist(startvelcond)>=.02*max(dist));
        
        %startdist_velcond = startvelcond(startdist_velcond); %where both vel and dist apply
        
        PosAngleStart=  find(theta_vel2(startvelcond) <= 180 & theta_vel2(startvelcond)>= 90); %looking in velocity range for angle range
        idx(1) = startvelcond(PosAngleStart(1)); %setting start idx to be velocity range
        
        %%
        if strcmp(mfname,'/trial35.mat')
            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trial36.mat')
            idx(3) = idx(3) -3;
        end
        
        
        if strcmp(mfname,'/trial37.mat')
            idx(3) = idx(3) -1;
            %idx(1) = idx(1) -1;
        end
        
        if strcmp(mfname,'/trial38.mat')
            idx(3) = idx(3) -3;
            % idx(1) = idx(1) -1;
        end
        
        if strcmp(mfname,'/trial39.mat')
            idx(3) = idx(3) -4;
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(3) = idx(3) -4;
            idx(1) = idx(1) +3;
        end
        
        if strcmp(mfname,'/trial41.mat')
            idx(3) = idx(3) -3;
            idx(1) = idx(1) +1;
        end
        
        if strcmp(mfname,'/trial42.mat')
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial43.mat')
            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trial44.mat')
            idx(3) = idx(3) -2;
        end
    end
    
    if expcond ==5
        %Finding reach start using velocity threshold and then angle
        startvelcond = find(vel>=.05*max(vel)) ;     % finding velocity range
        
        % Did not need DIST condition -- will probably for stroke.
        startdist_velcond = find(dist(startvelcond)>=.1*max(dist));
        
        startdist_velcond = startvelcond(startdist_velcond); %where both vel and dist apply
        
        PosAngleStart=  find(theta_vel2(startdist_velcond) <= 180 & theta_vel2(startdist_velcond)>= 90); %looking in velocity range for angle range
        idx(1) = startdist_velcond(PosAngleStart(1)); %setting start idx to be velocity range
        idx(1) = idx(1) -3;
        
        % Finding end of reach idx(3)
        velcond = find(vel(1:75)<=.1*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(1);
        %
        if strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -2;
        end
        %         %
        if strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -3;
        end
        %
        if strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1) +1;
            idx(3) = idx(3) -3;
        end
        %         %
        if strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1) +8;
            idx(3) = idx(3) -3;
        end
        %                 %
        if strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -1;
        end
        %
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1) -3;
            idx(3) = idx(3) -2;
        end
        %
        if strcmp(mfname,'/trial52.mat')
            %          idx(1) = idx(1) +8;
            idx(3) = idx(3) -2;
        end
        %
        if strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1) -1;
            idx(3) = idx(3) -1;
        end
        %
        if strcmp(mfname,'/trial54.mat')
            %         idx(1) = idx(1) +5;
            idx(3) = idx(3) -3;
        end
        %
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1) +13;
            idx(3) = idx(3) -2;
        end
    end
    
    
    if expcond ==6
        %Finding reach start using velocity threshold and then angle
        startvelcond = find(vel>=.05*max(vel)) ;     % finding velocity range
        
        % Did not need DIST condition -- will probably for stroke.
        startdist_velcond = find(dist(startvelcond)>=.1*max(dist));
        
        startdist_velcond = startvelcond(startdist_velcond); %where both vel and dist apply
        
        PosAngleStart=  find(theta_vel2(startdist_velcond) <= 180 & theta_vel2(startdist_velcond)>= 90); %looking in velocity range for angle range
        idx(1) = startdist_velcond(PosAngleStart(1)); %setting start idx to be velocity range
        idx(1) = idx(1) -3;
        
        % Finding end of reach idx(3)
        velcond = find(vel(1:75)<=.1*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(1);
        
        if strcmp(mfname,'/trial56.mat')
            %             idx(1) = idx(1) +13;
            %             idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1) +4;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial59.mat')
            %            idx(1) = idx(1) +6;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial60.mat')
            %            idx(1) = idx(1) +6;
            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(1) = idx(1) +8;
            %            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial64.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -1;
        end
        
        if strcmp(mfname,'/trial65.mat')
            %            idx(1) = idx(1) +2;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1) +1;
            %            idx(3) = idx(3) -2;
        end
        
    end
    
end
%% RTIS 1005

if strcmp(partid,'RTIS1005')
    end_reach = find(vel(1:75)>=.15*max(vel));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    if expcond==1
        if strcmp(mfname,'/trial5.mat')
            idx(3) = idx(3)+1;
        end
        if strcmp(mfname,'/trial8.mat')
            idx(3) = idx(3);
        end
        if strcmp(mfname,'/trial10.mat')
            idx(3) = idx(3)-6;
        end
    end
    
    if expcond==2
        velcond = find(vel(1:75)>=.10*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trial11.mat')
            idx(3) = idx(3);
        end
        
        if strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1)-4;
        end
        % %
        if strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1)+7;
        end
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)-4;
        end
        
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)-3;
        end
        
        if strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1)-3;
        end
        
        if strcmp(mfname,'/trial23.mat')
            idx(3) = idx(3)-1;
        end
        if strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)+12;
            idx(3) = idx(3)+1;
        end
        
    end
    
    if expcond ==3
        velcond = find(vel(1:75)>=.08*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)-5;
        
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+1;
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)+4;
        end
        
        if strcmp(mfname,'/trial26.mat')
            idx(3) = idx(3)+3;
        end
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)+4;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)+1;
        end
        %
        if strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1)+3;
            
            end_reach = find(vel(1:75)>=.10*max(vel));
            idx(3) = end_reach(length(end_reach));
            idx(3) = idx(3)+4;
        end
    end
    
    if expcond ==4
        if strcmp(mfname,'/trial32.mat')
            idx(1)=idx(1)-4;
        end
        
        if strcmp(mfname,'/trial35.mat')
            idx(3)=idx(3)-3;
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(3)=idx(3)-2;
        end
        
    end
    
    
    if expcond ==5
        velcond = find(vel(1:75)>=.10*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        idx(1) = idx(1)-4; %needed to adjust for this condition
        
        if strcmp(mfname,'/trial51.mat')
            idx(3)=idx(3)+3;
        end
        
        if strcmp(mfname,'/trial53.mat')
            idx(1)=idx(1)+1;
        end
        
        if strcmp(mfname,'/trial57.mat')
            idx(1)=idx(1)+2;
        end
        
        if strcmp(mfname,'/trial60.mat')
            idx(3)=idx(3)+2;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(3)=idx(3);
        end
        
        
    end
    
    if expcond ==6
        
        %         if strcmp(mfname,'/trial41.mat')
        %             maxdistint= max(dist);
        %             idx(3) = find(dist==maxdistint);
        %         end
        velcond = find(vel(1:75)>=.08*max(vel(1:75)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)-5;
        
        if strcmp(mfname,'/trial41.mat')
            idx(3)=idx(3)+4;
        end
        
        if strcmp(mfname,'/trial43.mat')
            idx(3)=idx(3)+4;
            idx(1)=idx(1)+2;
        end
        
        if strcmp(mfname,'/trial46.mat')
            idx(3)=idx(3)+1;
        end
    end
    
    
    
end


%% RTIS1006
if strcmp(partid,'RTIS1006')
    end_reach = find(vel(1:75)>=.15*max(vel));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    
    if expcond ==1
        
        if strcmp(mfname,'/trial64.mat')
            idx(3) = idx(3)+1;
            idx(1) = idx(1)-2;
        end
        
        if strcmp(mfname,'/trial65.mat')
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1)-2;
            %             idx(3) = idx(3)-1;
        end
        %
        %         if strcmp(mfname,'/trial67.mat')
        %             %            idx(1) = idx(1)+9;
        %             %             idx(3) = idx(3)+9;
        %         end
        
        if strcmp(mfname,'/trial68.mat')
            %             idx(1) = idx(1)+1;
            idx(3) = idx(3)+2;
        end
        if strcmp(mfname,'/trial69.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+2;
        end
        
        if strcmp(mfname,'/trial70.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial71.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial72.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial73.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial74.mat')
            %            idx(1) = idx(1)+9;
            idx(3) = idx(3)+1;
        end
    end
    
    if expcond ==2
        idx(1) = find(dist>=.05*max(dist),1)+6;
        idx(3) = idx(3)+3;
        
        if strcmp(mfname,'/trial53.mat')
            idx(3) = idx(3)-2;
        end
        
        if strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)-1;
            idx(3) = idx(3)-1;
        end
        
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)-3;
        end
        
        if strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)-3;
            idx(3) = idx(3)-2;
        end
                
               
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)+3;
%            idx(3) = idx(3)-6;
        end
                
        if strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1)+9;
%            idx(3) = idx(3)-6;
        end
        
                        
        if strcmp(mfname,'/trial59.mat')
            idx(1) = idx(1)+2;
%            idx(3) = idx(3)-6;
        end
        
        if strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)+5;
            idx(3) = idx(3)-1;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(3) = idx(3)-2;
        end
        
        if strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1)+2;
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(3) = idx(3)-3;
        end
        
    end
    if expcond ==3
        idx(1) = find(dist>=.05*max(dist),1)+6;
        idx(3) = idx(3)+3;
        
        if strcmp(mfname,'/trial43.mat')
            idx(1) = idx(1)-3;
            idx(3) = idx(3)-2;
        end
                
        if strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)-3;
        end
        
        if strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1)+3;
        end
        
        if strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial48.mat')
            idx(3) = idx(3)-4;
            idx(1) = idx(1)-1;
        end
        if strcmp(mfname,'/trial49.mat')
            idx(3) = idx(3)-2;
            idx(1) = idx(1)-2;
        end
        
        if strcmp(mfname,'/trial50.mat')
            idx(3) = idx(3)-2;
        end
        
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1)-4;
            idx(3) = idx(3)-4;
        end
        
        if strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)-2;
        end
        
    end
    
    if expcond ==4
        idx(1) = find(dist>=.05*max(dist),1)-2;
        %       idx(3) = idx(3)+3;
                         
        if strcmp(mfname,'/trial87.mat')
%             idx(1) = idx(1)-2;
            idx(3) = idx(3)-1;
        end    
        
        if strcmp(mfname,'/trial88.mat')
%             idx(1) = idx(1)-2;
            idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial89.mat')
            idx(1) = idx(1)-2;
%             idx(3) = idx(3)+10;
        end
        
        if strcmp(mfname,'/trial90.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)+1;
        end
                
        if strcmp(mfname,'/trial92.mat')
            idx(1) = idx(1)-5;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial95.mat')
            %              idx(1) = idx(1)-2;
            idx(3) = idx(3);
        end
                
        if strcmp(mfname,'/trial97.mat')
            %              idx(1) = idx(1)-2;
            idx(3) = idx(3)+9;
        end
        
        if strcmp(mfname,'/trial98.mat')
            %              idx(1) = idx(1)-2;
            idx(3) = idx(3)+2;
        end
    end
    
    if expcond ==5
        idx(1) = find(dist>=.10*max(dist),1);
    end
    
    
    if expcond ==6
        idx(1) = find(dist>=.10*max(dist),1);
        
        if strcmp(mfname,'/trial86.mat')
            idx(1) = idx(1)-4;
            idx(3) = idx(3)+3;
        end
                
        if strcmp(mfname,'/trial84.mat')
            idx(1) = idx(1)+7;
%             idx(3) = idx(3)+3;
        end
                
        if strcmp(mfname,'/trial99.mat')
            idx(1) = idx(1)+5;
%             idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial100.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial101.mat')
            idx(1) = idx(1)+8;
            
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
        idx(1) = find(dist>=.02*max(dist),1);
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2);
        
        
        if strcmp(mfname,'/trial17.mat')
            idx(1)= idx(1)-10;
            idx(3) = idx(3)-8;
        end
        
        if strcmp(mfname,'/trial18.mat')
            idx(1)= idx(1)-5;
        end
        
        if strcmp(mfname,'/trial19.mat')
            idx(1)= idx(1)-10;
            idx(3) = idx(3)-3;
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1)= idx(1)-3;
        end
        
        if strcmp(mfname,'/trial21.mat')
            idx(1)= idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial35.mat')
            idx(3)= idx(3)-3;
        end
        
        
        if strcmp(mfname,'/trial37.mat')
            idx(1)= idx(1)-3;
            idx(3) = idx(3)-3;
        end
        
        
        if strcmp(mfname,'/trial38.mat')
            idx(1)= idx(1)-3;
        end
        
        
        if strcmp(mfname,'/trial39.mat')
            idx(1)= idx(1)-3;
        end
        
    end
    
    if expcond ==2
        
        idx(1) =find(xhand(:,3)>=.4*max(xhand(:,3)),1);
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2);
        
        
        %     if strcmp(mfname,'/trial23.mat')
        %         idx(1)= idx(1)-3;
        %     end
        %
        %
        %     if strcmp(mfname,'/trial24.mat')
        %         idx(1)= idx(1)-3;
        %     end
        %
        %
        %     if strcmp(mfname,'/trial25.mat')
        %         idx(1)= idx(1)-3;
        %     end
        %
        %
        if strcmp(mfname,'/trial27.mat')
            idx(1)= idx(1)-2;
            idx(3) = idx(3)-5;
        end
        %
        if strcmp(mfname,'/trial40.mat')
            idx(1)= idx(1)-5;
            
            idx(3) = idx(3)-3;
            
        end
        
        if strcmp(mfname,'/trial41.mat')
            idx(3)= idx(3)-3;
        end
        %
        %
        %     if strcmp(mfname,'/trial43.mat')
        %         idx(1)= idx(1)-3;
        %     end
        %
        
    end
    
    if expcond == 3
        
        
        idx(1) =find(xhand(:,3)>=.4*max(xhand(:,3)),1);
        
        %
        if strcmp(mfname,'/trial29.mat')
            idx(1)= idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial46.mat')
            idx(3)= idx(3)-3;
        end
        
    end
    
    if expcond ==4
        
        if strcmp(mfname,'/trial57.mat')
            idx(1)= idx(1)-6;
        end
        
        
        
        if strcmp(mfname,'/trial72.mat')
            idx(1)= idx(1);
            idx(3) = idx(3) -1;
        end
        
        if strcmp(mfname,'/trial73.mat')
            idx(1)= idx(1)-6;
        end
        
        
        if strcmp(mfname,'/trial74.mat')
            idx(1)= idx(1)-6;
        end
        
        if strcmp(mfname,'/trial75.mat')
            idx(1)= idx(1)-5;
        end
        
    end
    
    if expcond==5
        
        idx(1) =find(xhand(:,3)>=.4*max(xhand(:,3)),1);
        
        if strcmp(mfname,'/trial64.mat')
            idx(1)= idx(1)-6;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(1)= idx(1)-3;
        end
        
        
        if strcmp(mfname,'/trial80.mat')
            idx(1)= idx(1)-2;
        end
        
        
    end
    
    if expcond ==6
        
        
        idx(1) =find(xhand(:,3)>=.3*max(xhand(:,3)),1)-3;
        
        if strcmp(mfname,'/trial70.mat')
            idx(1)= idx(1)-3;
        end
        
        if strcmp(mfname,'/trial71.mat')
            idx(1)= idx(1);
        end
        
        if strcmp(mfname,'/trial82.mat')
            idx(1)= idx(1);
        end
        
        if strcmp(mfname,'/trial83.mat')
            idx(1)= idx(1)+35;
        end
        
        
        if strcmp(mfname,'/trial84.mat')
            idx(1)= idx(1)+9;
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
        
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2)-5;
        
        idx(1) = find(dist>=.08*max(dist),1)-5;
        
        if strcmp(mfname,'/trial24.mat')
            idx(3)= idx(3)-5;
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(3)= idx(3);
        end
        
        
        if strcmp(mfname,'/trial26.mat')
            idx(3)= idx(3)-1;
        end
        
        
        if strcmp(mfname,'/trial33.mat')
            idx(3)= idx(3)-1;
        end
        
        
        if strcmp(mfname,'/trial32.mat')
            idx(3)= idx(3)-3;
        end
        
        
        if strcmp(mfname,'/trial35.mat')
            idx(3)= idx(3)+2;
        end
        if strcmp(mfname,'/trial36.mat')
            idx(3)= idx(3)-2;
        end
    end
    
    if expcond ==2
        idx(1) =find(dist>=.08*max(dist),1)+5;
        
        
        
        
        if strcmp(mfname,'/trial27.mat')
            idx(3)= idx(3)-6;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(3)= idx(3)-12;
        end
        
        if strcmp(mfname,'/trial29.mat')
            idx(3)= idx(3)-5;
        end
        
        if strcmp(mfname,'/trial38.mat')
            idx(3)= idx(3)-5;
        end
        
        if strcmp(mfname,'/trial39.mat')
            idx(3)= idx(3)-2;
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(3)= idx(3)-6;
            idx(1)=idx(1)+5;
        end
        
        
        if strcmp(mfname,'/trial41.mat')
            
            idx(1)=idx(1)+2;
        end
    end
    
    
    if expcond ==3
        idx(1) = find(dist>=.05*max(dist),1);
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2)-10;
        
        if strcmp(mfname,'/trial42.mat')
            idx(1)= idx(1)+2;
            idx(3) = idx(3)-3;
        end
        
        
        if strcmp(mfname,'/trial43.mat')
            idx(1)= idx(1)+5;
            idx(3)= idx(3)-3;
        end
        
        
        if strcmp(mfname,'/trial44.mat')
            idx(1)= idx(1)+3;
            idx(3) = idx(3)+5;
        end
        
        
        if strcmp(mfname,'/trial46.mat')
            idx(1)= idx(1)+3;
            idx(3) = idx(3)-5;
        end
        
        
        if strcmp(mfname,'/trial47.mat')
            idx(1)= idx(1)+5;
            idx(3) = idx(3)+8;
        end
        
        if strcmp(mfname,'/trial49.mat')
            idx(1)= idx(1)+5;
            idx(3) = idx(3)-2;
        end
        
        
    end
    
    if expcond==4
        
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2)-2;
        
        idx(1) = find(dist>=.08*max(dist),1)-5;
        
        if strcmp(mfname,'/trial54.mat')
            idx(1)= idx(1)-4;
        end
        
        
        if strcmp(mfname,'/trial55.mat')
            idx(1)= idx(1)-4;
        end
        
        
        if strcmp(mfname,'/trial56.mat')
            idx(1)= idx(1)-9;
        end
        
        
        
        if strcmp(mfname,'/trial63.mat')
            idx(1)= idx(1)-4;
        end
        
        if strcmp(mfname,'/trial64.mat')
            idx(3)= idx(3)-4;
        end
        
        
    end
    
    
    if expcond ==5
        
        idx(1) = find(dist>=.1*max(dist),1);
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2)-10;
        
        if strcmp(mfname,'/trial57.mat')
            idx(1)= idx(1)+6;
            idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial81.mat')
            % idx(1)= idx(1)+6;
            idx(3) = idx(3)+4;
        end
        
        
        if strcmp(mfname,'/trial75.mat')
            % idx(1)= idx(1)+6;
            idx(3) = idx(3)+2;
        end
        
        if strcmp(mfname,'/trial76.mat')
            % idx(1)= idx(1)+6;
            idx(3) = idx(3)+1;
        end
        
        
        if strcmp(mfname,'/trial77.mat')
            % idx(1)= idx(1)+6;
            idx(3) = idx(3)+5;
        end
        if strcmp(mfname,'/trial78.mat')
            % idx(1)= idx(1)+6;
            idx(3) = idx(3)+5;
        end
        
        
    end
    
    if expcond==6
        
        idx(1) = find(dist>=.1*max(dist),1);
        
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2)-5;
        
        if strcmp(mfname,'/trial61.mat')
            idx(1)= idx(1)+1;
            
        end
        
        
        if strcmp(mfname,'/trial62.mat')
            idx(1)= idx(1)+2 ;
            
        end
        
        
        if strcmp(mfname,'/trial67.mat')
            idx(3)= idx(3)-3 ;
            
        end
        
        if strcmp(mfname,'/trial72.mat')
            idx(3)= idx(3)-5 ;
            idx(1) = idx(1)+5;
            
        end
        
        if strcmp(mfname,'/trial73.mat')
            
            idx(1) = idx(1)-3;
            
        end
        
        
        if strcmp(mfname,'/trial74.mat')
            
            idx(1) = idx(1)+3;
            
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
        
        
        if strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1)+5;
        end
        
    end
end


%% RTIS 2002 Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
    if expcond==1
        idx(1) = find(dist>=.02*max(dist),1);
        
        if strcmp(mfname,'/trial2.mat')
            idx(3)=idx(3)-15;
        end
        
        if strcmp(mfname,'/trial4.mat')
            idx(3)=idx(3)-18;
        end
        
        if strcmp(mfname,'/trial5.mat')
            idx(3)=idx(3)-20;
        end
        
        if strcmp(mfname,'/trial6.mat')
            idx(3)=idx(3)-20;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(3)=idx(3)-20;
        end
        
        
        if strcmp(mfname,'/trial10.mat')
            idx(3)=idx(3)-23;
        end
        
    end
    
    if expcond ==2
        idx(1)= find(dist>=.05*max(dist),1);
        idx(1) =find(xhand(:,3)>=.65*max(xhand(:,3)),1);
        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2);
        
        if strcmp(mfname,'/trial16.mat')
            idx(1)=idx(1)+23;
        end
        
        %
        %        if strcmp(mfname,'/trial17.mat')
        %            idx(1)=idx(1)+15;
        %            idx(3) = idx(3) -10;
        %        end
        %
        %
        %        if strcmp(mfname,'/trial19.mat')
        %            idx(1)=idx(1)+10;
        %
        %        end
        %        if strcmp(mfname,'/trial20.mat')
        %            idx(1)=idx(1)+10;
        %
        %        end
        %
        %
        if strcmp(mfname,'/trial28.mat')
            idx(1)=idx(1)+35;
            
        end
        
    end
    
    
    if expcond ==3
        idx(1) =find(xhand(:,3)>=.75*max(xhand(:,3)),1);
        %        idx(3) = find(vel(idx(2):end)<=0,1)+idx(2);
        
        
        if strcmp(mfname,'/trial15.mat')
            idx(3)=idx(3)-5;
            
        end
        
        
        if strcmp(mfname,'/trial21.mat')
            idx(3)=idx(3)-4;
            
        end
        
        
    end
    
    
    if expcond ==4
        if strcmp(mfname,'/trial40.mat')
            idx(1)=idx(1)-15;
            idx(3) = idx(3)-10;
        end
        
        
        if strcmp(mfname,'/trial39.mat')
            idx(3)=idx(3)-4;
        end
        
        
        if strcmp(mfname,'/trial36.mat')
            idx(3)=idx(3)-20;
        end
        
        
        if strcmp(mfname,'/trial41.mat')
            idx(3)=idx(3)-20;
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(3)=idx(3)-25;
        end
    end
    
    if expcond ==5
        
        idx(1) =find(xhand(:,3)>=.75*max(xhand(:,3)),1);
        
        if strcmp(mfname,'/trial42.mat')
            idx(2)=find(max(vel(idx(1):idx(3))),1)+idx(1);
        end
        
        if strcmp(mfname,'/trial44.mat')
            idx(1)=idx(1)-5;
        end
        
        if strcmp(mfname,'/trial60.mat')
            idx(1)=idx(1)-8;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(1)=idx(1)-5;
        end
    end
    
    if expcond ==6
        
        
        idx(1) =find(xhand(:,3)>=.6*max(xhand(:,3)),1);
        
        %            if strcmp(mfname,'/trial50.mat')
        %            idx(1)=idx(1)+20;
        %            end
        idx(1)
        if strcmp(mfname,'/trial51.mat')
            idx(2)=find(vel==max(vel(idx(1):89)),1)
            idx(3) = find(dist==max(dist(idx(1):89)),1)
        end
        %
        %            if strcmp(mfname,'/trial54.mat')
        %            idx(1)=idx(1)+20;
        %            end
        %
        %
        %            if strcmp(mfname,'/trial55.mat')
        %            idx(1)=idx(1)+20;
        %            end
    end
    
end


%% RTIS 2002 Non-Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
    if expcond==1
        idx(1) = find(dist>=.02*max(dist),1);
        idx(3) = find(vel(idx(2):end)<0,1) +idx(2);
        if strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1)+5;
            idx(3) =idx(3)-10;
        end
        
        if strcmp(mfname,'/trial2.mat')
            idx(3) = idx(3)-15;
        end
        
        
        if strcmp(mfname,'/trial7.mat')
            idx(3) = idx(3)-10;
        end
        
        
        if strcmp(mfname,'/trial9.mat')
            idx(3) = idx(3)-35-16-3;
        end
        
    end
    
    if expcond ==2
        
        idx(1) =find(xhand(:,3)>=.65*max(xhand(:,3)),1);
        
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)-10;
        end
        
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)-10;
        end
        
        
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial31.mat')
            idx(1) = idx(1)-5;
        end
        
        if strcmp(mfname,'/trial32.mat')
            idx(1) = idx(1)-5;
        end
    end
    
    if expcond ==3
        
        idx(1) =find(xhand(:,3)>=.5*max(xhand(:,3)),1)-2;
        
        if strcmp(mfname,'/trial22.mat')
            idx(3) = idx(3)-5;
            
        end
        
        if strcmp(mfname,'/trial23.mat')
            idx(3) = idx(3)-5;
            
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(3) = idx(3)-5;
            
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
        idx(1) =find(xhand(:,3)>=.6*max(xhand(:,3)),1)-2;
        
        if strcmp(mfname,'/trial64.mat')
            idx(3) = find(dist==max(dist),1);
            idx(2) = find(vel== max(vel(idx(1):idx(3))));
            
        end
    end
    
    
    if expcond ==6
        
        idx(1) =find(xhand(:,3)>=.6*max(xhand(:,3)),1)-2;
        
        
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

%% Testing to see if shoulder, trunk marker visible at indices
%missing shoulder
% % for h = idx(1):length(xshldr)
% if isnan(xshldr(h)) || isnan(xjug(h))
%     idx(1) = h+1;
% end
%
% %use find to see where NAN in xshldr and xjug then ~ to get true where
% %numbers then bump up one if NAN
%
% % end
%
% for k = idx(3):length(xshldr)
% if isnan(xshldr(k)) || isnan(xjug(k))
%     idx(3) = k+1;
% end
% end


%%
idx;
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
%  subplot(5,1,1)
%ax = axes('position',[0.12,0.75,0.75,0.22]);
%plot(t(1:50),dist(1:50))
yyaxis left

plot(t,dist,'LineWidth',1)
% plot(t,xhand(:,3))
hold on

ylabel('Distance (mm)')
hold on
yyaxis right
plot(t,vel,'LineWidth',1)
% plot(t,velx)
plot(t,vely)
ylabel('Velocity (mm/s)')

y1=ylim;

title('Distance and Velocity','FontSize',24)
p1 = line('Color','g','Xdata',[timestart timestart],'Ydata',[-5000 5000], 'LineWidth',1); % start reach
% p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[-5000 5000],'LineWidth',1); % max vel
p3= line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[-5000 5000],'LineWidth',1); %max, dist
p4= line('Color','b','Ydata',[0 0],'Xdata',[-5000 5000],'LineWidth',2); %time prior
%p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);
% ylim([-400 400])
% co=get(lax1,'ColorOrder');
% set(lax1,'ColorOrder',co(end-1:-1:1,:))
xlim([0.25 5])
xlabel('time in seconds')
legend('Distance', 'Velocity','Vel y','Time Start','Time End','vel=0','Location','northwest','FontSize',16)


% figure (6),clf
%
% plot(t,xhand(:,3))
% hold on
%
% ylabel('Hand Position (mm)')
% % plot(t,vel,'LineWidth',1)
% % plot(t,velx)
% % plot(t,vely)
%
% y1=ylim;
%
% title('Z Position of Hand','FontSize',24)
%  p1 = line('Color','g','Xdata',[timestart timestart],'Ydata',[-5000 5000], 'LineWidth',1); % start reach
% % p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[-5000 5000],'LineWidth',1); % max vel
% p3= line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[-5000 5000],'LineWidth',1); %max, dist
% %p4= line('Color','g','Xdata',[timebefore timebefore],'Ydata',[-500 500],'LineWidth',.5); %time prior
% %p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);
% % ylim([-400 400])
% % co=get(lax1,'ColorOrder');
% % set(lax1,'ColorOrder',co(end-1:-1:1,:))[-5000 5000]
% xlim([0.25 5])
% ylim([0 300])
% xlabel('time in seconds')
% legend('Z position','Time Start','Time End','FontSize',16)
%


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
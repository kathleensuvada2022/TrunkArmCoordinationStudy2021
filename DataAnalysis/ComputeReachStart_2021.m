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

function [dist,vel,idx,timestart, timedistmax,xhand,rangeZ]= ComputeReachStart_2021(Zpos_act,Ypos_act,t,xhand,xjug,dist,vel,velx,vely,theta_vel2,setup,expcond,partid,mfname,hand);


idx=zeros(1,4); % creating variable with the indices of vel and distance

%% RTIS1002
if  strcmp(partid,'RTIS1002')
    end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    if expcond==1
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(length(vUd));
        
        
        if strcmp(mfname,'/trials2.mat')
            idx(3) = idx(3) -4;
        end
        
        
        if strcmp(mfname,'/trials3.mat')
            idx(3) = idx(3) -2;
        end
        
        
        if strcmp(mfname,'/trials5.mat')
            idx(3) = idx(3) -10;
        end
        
        
        if strcmp(mfname,'/trials7.mat')
            idx(1) = idx(1)+85;
        end
    end
    
    
    if expcond ==2
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trials14.mat')
            idx(3) = idx(3)-150;
        end
    end
    
    
    if expcond ==3
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        %
        if strcmp(mfname,'/trials8.mat')
            idx(1) = idx(1)+160;
        end
        
        if strcmp(mfname,'/trials11.mat')
            idx(1) = idx(1)+100;
        end
        
    end
    
    
    
    
    if expcond ==4
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        %
        if strcmp(mfname,'/trials25.mat')
            idx(3) = idx(3)-220;
        end
        
        if strcmp(mfname,'/trials28.mat')
            idx(3) = idx(3)-85;
        end
        
        if strcmp(mfname,'/trials32.mat')
            idx(1) = idx(1)+30;
        end
        
        if strcmp(mfname,'/trials35.mat')
            idx(1) = idx(1)+45;
            idx(3) = idx(3) -152;
        end
    end
    
    
    if expcond ==5
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trials16.mat')
            %             idx(1) = idx(1)+45;
            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trials38.mat')
            idx(1) = idx(1)+97;
            %             idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trials39.mat')
            %             idx(1) = idx(1)+55;
            idx(3) = idx(3) -15;
        end
        
        if strcmp(mfname,'/trials40.mat')
            idx(1) = idx(1)+205;
        end
        
        
        if strcmp(mfname,'/trials42.mat')
            idx(1) = idx(1)+15;
        end
    end
    
    
    if expcond ==6
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trials21.mat')
            idx(1) = idx(1)+85;
            idx(3) = idx(3)-15;
        end
        
        
        if strcmp(mfname,'/trials36.mat')
            idx(1) = idx(1)+90;
            idx(3) = idx(3)-20;
        end
        
        
        if strcmp(mfname,'/trials37.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)-25;
        end
    end
end

%% RTIS 1003
if  strcmp(partid,'RTIS1003')
    
    end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    
    if expcond==1
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(length(vUd));
        
        if strcmp(mfname,'/trials1.mat')
            idx(3) = idx(3) -30;
        end
        
        if strcmp(mfname,'/trials2.mat')
            idx(3) = idx(3) -30;

           maxdisty= max(xhand(1:idx(3),2)); 
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;

        end
        
        if strcmp(mfname,'/trials3.mat')
            idx(3) = idx(3) -11;
        end
        
        
        if strcmp(mfname,'/trials4.mat')
            idx(3) = idx(3) -4;
        end
        
        
        if strcmp(mfname,'/trials5.mat')
            idx(3) = idx(3) +8;
        end
    end
    
    if expcond==2
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trials13.mat')
            idx(3) = idx(3) -195;
            idx(1) = idx(1) +15;
        end
        
        
        if strcmp(mfname,'/trials14.mat')
            idx(3) = idx(3) -15;
        end
        
        
        if strcmp(mfname,'/trials15.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -25;
        end
        
        
        if strcmp(mfname,'/trials16.mat')
            %             idx(1) = idx(1) +15;
            idx(3) = idx(3) -20;
        end
        
    end
    
    
    if expcond==3
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)+5;
        %
        if strcmp(mfname,'/trials6.mat')
            idx(1) = idx(1) +25;
            idx(3) = idx(3) -10;
        end
        if strcmp(mfname,'/trials7.mat')
            idx(3) = idx(3) -4;
        end
        
        if strcmp(mfname,'/trials8.mat')
            idx(3) = idx(3) -14;
            idx(1) = idx(1)-6;
        end
        
        
        if strcmp(mfname,'/trials9.mat')
            idx(1) = idx(1) +10+11;
            idx(3) = idx(3) -15;
      
            maxdisty= max(xhand(1:idx(3),2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trials10.mat')
            idx(1) = idx(1)+12;
            idx(3) = idx(3) -7;
        end
        
        
        
        if strcmp(mfname,'/trials11.mat')
            idx(1) = idx(1) +39;
            idx(3) = idx(3) -10;
        end
    end
    
    if expcond ==4
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(length(vUd));
        
        
        if strcmp(mfname,'/trials19.mat')
            %             idx(1) = idx(1) +43;
            idx(3) = idx(3) -108;
        end
        
        
        if strcmp(mfname,'/trials20.mat')
            %             idx(1) = idx(1) +43;
            idx(3) = idx(3) -44;
        end
        
        
        if strcmp(mfname,'/trials21.mat')
            %             idx(1) = idx(1) +43;
            idx(3) = idx(3) +1;
        end
    end
    
    if expcond ==5
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)+5;
        %
        if strcmp(mfname,'/trials30.mat')
            idx(1) = idx(1) +20;
            idx(3) = idx(3) -10;
        end
        
        if strcmp(mfname,'/trials31.mat')
            idx(3) = idx(3) -20;
            %             idx(3) = idx(3) -9;
        end
        
        
        if strcmp(mfname,'/trials32.mat')
            idx(1) = idx(1) +30;
            %             idx(3) = idx(3) -9;
        end
        
        if strcmp(mfname,'/trials33.mat')
            idx(3) = idx(3) -180;
            %             idx(3) = idx(3) -9;
        end
        
        
        if strcmp(mfname,'/trials34.mat')
            idx(3) = idx(3) -2;
            idx(1) = idx(1) +8;
        end
        
        
        if strcmp(mfname,'/trials35.mat')
            idx(3) = idx(3) -230;
            idx(1) = idx(1) +11;
        end
        
        
        if strcmp(mfname,'/trials36.mat')
            idx(3) = idx(3) -45;
            idx(1) = idx(1) +15;
        end
    end
    
    if expcond ==6
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)+5;
        
        
        if strcmp(mfname,'/trials23.mat')
            idx(3) = idx(3) -112;
            %                     idx(1) = idx(1) +15;
        end
        if strcmp(mfname,'/trials26.mat')
            idx(3) = idx(3) -17;
            %                     idx(1) = idx(1) +15;
        end
        if strcmp(mfname,'/trials27.mat')
            idx(3) = idx(3) -290;
            idx(1) = idx(1) +15;
        end
        
    end
    
    
    
    
end








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
    %     end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
    end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    %resampling: switch 75 to 501
    
    if expcond==1
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(length(vUd));
        
        
        if strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1) +15;
            idx(3) = idx(3) -58;
        end
        
        if strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1) -15;
            idx(3) = idx(3) -4;
        end
        
        if strcmp(mfname,'/trial3.mat')
            idx(1) = idx(1) +15;
            idx(3) = idx(3) -15;
        end
        
        if strcmp(mfname,'/trial4.mat')
            idx(1) = idx(1) -5;
            idx(3) = idx(3) +5;
        end
        
        if strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1) -13;
        end
        
        
        if strcmp(mfname,'/trial7.mat')
            idx(1) = idx(1) +34;
        end
        
        if strcmp(mfname,'/trial10.mat')
            idx(1) = idx(1) -16;
        end
    end
    
    if expcond==2
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        
        
        if strcmp(mfname,'/trial23.mat')
            idx(1) = idx(1) +3;
            %idx(3) = idx(3) -6;
        end
        if strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1) +10;
            idx(3) = idx(3) -6;
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1) +10;
            idx(3) = idx(3) -8;
        end
        
        if strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1) +60;
            idx(3) = idx(3) -4;
        end
        
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1) +75;
            idx(3) = idx(3) +1;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1) +85;
            idx(3) = idx(3) -10;
        end
        
        if strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1) +14+5;
        end
        
        if strcmp(mfname,'/trial33.mat')
            idx(1) = idx(1) +82;
            idx(3) = idx(3) -15;
        end
        
        
        if strcmp(mfname,'/trial34.mat')
            %idx(1) = idx(1) +42;
            idx(3) = idx(3) -20;
        end
        
    end
    
    if expcond==3
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist<=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)+5;
        
        if strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1) +39;
            idx(3) = idx(3) -30;
        end
        
        if strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1) +30;
            idx(3) = idx(3) -10;
        end
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1) +23+15;
        end
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1) +15+25;
            idx(3) = idx(3)-15;
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
            idx(1) = idx(1) -30;
        end
    end
    
    
    if expcond ==4
        %% JAN 2022 KCS % USING DIST/VEL/ ANGLE
        
        % Finding idx(3) max distance
        velcond = find(vel(1:501)<=.10*max(vel(1:501)));
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
            idx(3) = idx(3) -15;
            idx(1) = idx(1) +5;
        end
        
        if strcmp(mfname,'/trial36.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) +5;
        end
        
        
        if strcmp(mfname,'/trial37.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) +5;
        end
        
        if strcmp(mfname,'/trial38.mat')
            idx(3) = idx(3) -6;
            idx(1) = idx(1) +15;
        end
        
        if strcmp(mfname,'/trial39.mat')
            idx(3) = idx(3) -11;
            idx(1) = idx(1) +5;
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(3) = idx(3) -24;
            idx(1) = idx(1) +13;
        end
        
        if strcmp(mfname,'/trial41.mat')
            idx(3) = idx(3) -3;
            idx(1) = idx(1) +20-10;
        end
        
        if strcmp(mfname,'/trial42.mat')
            idx(3) = idx(3) -7;
            idx(1) = idx(1) +20;
        end
        
        if strcmp(mfname,'/trial43.mat')
            idx(3) = idx(3) -23+6;
            idx(1) = idx(1) +20;
        end
        
        if strcmp(mfname,'/trial44.mat')
            idx(3) = idx(3) -2;
            idx(1) = idx(1) ;
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
        velcond = find(vel(1:501)<=.1*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(1);
        %
        if strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1) +2-17;
            idx(3) = idx(3) -15+2;
        end
        %         %
        if strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1) +30;
            idx(3) = idx(3) -3-6-1;
        end
        %
        if strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1) +1;
            idx(3) = idx(3) -26;
        end
        %         %
        if strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1) +48+6;
            idx(3) = idx(3) -9;
        end
        %                 %
        if strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1) +2;
            idx(3) = idx(3) -11;
        end
        %
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1) -23;
            idx(3) = idx(3) -8;
        end
        %
        if strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1) -19;
            idx(3) = idx(3) -15;
        end
        %
        if strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1) -16;
            idx(3) = idx(3) -4;
        end
        %
        if strcmp(mfname,'/trial54.mat')
            %         idx(1) = idx(1) +5;
            idx(3) = idx(3) -13+5;
        end
        %
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1) +58;
            idx(3) = idx(3) -12+5+3;
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
        velcond = find(vel(1:501)<=.1*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(3) = vUd(1);
        
        if strcmp(mfname,'/trial56.mat')
            %             idx(1) = idx(1) +13;
            %             idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1) -3;
            idx(3) = idx(3) -2;
        end
        
        if strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1)+14+6;
            idx(3) = idx(3) -12+3;
        end
        
        if strcmp(mfname,'/trial59.mat')
            %            idx(1) = idx(1) +6;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial60.mat')
            %            idx(1) = idx(1) +6;
            idx(3) = idx(3) -6;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(1) = idx(1) +48;
            %            idx(3) = idx(3) -3;
        end
        
        if strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1) -3;
            idx(3) = idx(3) -2-15;
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1) -1;
            idx(3) = idx(3) -10;
        end
        
        if strcmp(mfname,'/trial64.mat')
            idx(1) = idx(1) -3;
            idx(3) = idx(3) -4;
        end
        
        if strcmp(mfname,'/trial65.mat')
            idx(1) = idx(1) -12;
            idx(3) = idx(3) -12+4;
        end
        
        if strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1) -14;
            idx(3) = idx(3) +1;
        end
        
    end
    
end
%% RTIS 1005

if strcmp(partid,'RTIS1005')
    end_reach = find(vel(1:501)>=.15*max(vel));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    if expcond==1
        if strcmp(mfname,'/trial3.mat')
            idx(3) = idx(3)+2;
        end
        if strcmp(mfname,'/trial5.mat')
            idx(3) = idx(3)+16;
            idx(1) = idx(1)-5;
        end
        if strcmp(mfname,'/trial8.mat')
            idx(3) = idx(3)-10;
        end
        if strcmp(mfname,'/trial10.mat')
            idx(3) = idx(3)-56+14;
        end
    end
    
    if expcond==2
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        
        idx(1) = vUd(1);
        
        if strcmp(mfname,'/trial11.mat')
            idx(1) = idx(1)-65;
        end
        
        if strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1)-20;
            idx(3) = idx(3)+ 36;
        end
        % %
        if strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1)-20;
        end
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)-14;
            idx(3) = idx(3) -20+25;
        end
        
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)-23;
        end
        
        if strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1)-23;
        end
        
        if strcmp(mfname,'/trial23.mat')
            idx(3) = idx(3);
        end
        if strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)+102;
            idx(3) = idx(3)-15+17;
        end
        
    end
    
    if expcond ==3
        velcond = find(vel(1:501)>=.08*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)-5;
        
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+1;
        end
        
        
        if strcmp(mfname,'/trial17.mat')
            idx(3) = idx(3)-3;
            idx(1) = idx(1)-16;
        end
        
        
        if strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)-20;
            idx(3) = idx(3) -6;
        end
        
        if strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1)-20;
            %  idx(3) = idx(3) -6;
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)+24-25;
            idx(3) = idx(3)+15;
        end
        
        if strcmp(mfname,'/trial26.mat')
            idx(3) = idx(3)+3+15;
        end
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)-6;
            idx(3) = idx(3) +5;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)+1;
        end
        %
        if strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1)+3;
            
            end_reach = find(vel(1:501)>=.10*max(vel));
            idx(3) = end_reach(length(end_reach));
            idx(3) = idx(3)+4;
            idx(3) = idx(3) -15;
        end
    end
    
    if expcond ==4
        if strcmp(mfname,'/trial32.mat')
            idx(1)=idx(1)+5;
            %             idx(3) = idx(3) -20;
        end
        
        
        if strcmp(mfname,'/trial35.mat')
            idx(3)=idx(3)-3;
            idx(1) = idx(1) +15;
        end
        
        if strcmp(mfname,'/trial38.mat')
            idx(1)=idx(1)-15;
            
        end
        if strcmp(mfname,'/trial40.mat')
            idx(3)=idx(3)-10;
        end
        
    end
    
    
    if expcond ==5
        velcond = find(vel(1:501)>=.10*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1);
        idx(1) = idx(1)-4; %needed to adjust for this condition
        
        if strcmp(mfname,'/trial51.mat')
            idx(3)=idx(3)+3;
        end
        
        if strcmp(mfname,'/trial53.mat')
            idx(1)=idx(1)-19;
        end


        if strcmp(mfname,'/trial54.mat')
            idx(1)=idx(1)-45;
        end
        

        if strcmp(mfname,'/trial55.mat')
            idx(1)=idx(1)-20;
        end
        
        if strcmp(mfname,'/trial57.mat')
            idx(1)=idx(1)-18;
        end
        
        if strcmp(mfname,'/trial60.mat')
            idx(3)=idx(3)+2;
            idx(1)=idx(1)-150;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(3)=idx(3)+51;
            idx(1)=idx(1)-25;
        end
        
        
    end
    
    if expcond ==6
        
        %         if strcmp(mfname,'/trial41.mat')
        %             maxdistint= max(dist);
        %             idx(3) = find(dist==maxdistint);
        %         end
        velcond = find(vel(1:501)>=.08*max(vel(1:501)));
        distcond = find(dist>=.2*max(dist));
        
        %Finding where distance and vel threshold apply
        vUd = intersect (velcond,distcond);
        idx(1) = vUd(1)-5;
        
        if strcmp(mfname,'/trial41.mat')
            idx(3)=idx(3)+4;
            idx(1)=idx(1)-15;
        end
        
        
        if strcmp(mfname,'/trial42.mat')
            idx(1)=idx(1)-25;
        end

        if strcmp(mfname,'/trial43.mat')
            idx(3)=idx(3)+4;
            idx(1)=idx(1)-15;
        end
        

        if strcmp(mfname,'/trial44.mat')
%             idx(3)=idx(3)+4;
            idx(1)=idx(1)-25;
        end
        
        
        if strcmp(mfname,'/trial45.mat')
            % idx(3)=idx(3)+4;
            idx(1)=idx(1)-35;
        end
        
        if strcmp(mfname,'/trial46.mat')
            idx(3)=idx(3)+1;
            idx(1)=idx(1)-25;
        end
    end
    
    
    
end


%% RTIS1006
if strcmp(partid,'RTIS1006')
    end_reach = find(vel(1:501)>=.15*max(vel));
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
            idx(3) = idx(3);
            idx(1) = idx(1) +20;
        end
        
        if strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)+10;
        end
        
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)-3;
        end
        
        if strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)-2;
        end
        
        
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)+50;
            %            idx(3) = idx(3)-6;
        end
        
        if strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1)+9;
            %            idx(3) = idx(3)-6;
        end
        
        
        if strcmp(mfname,'/trial59.mat')
            idx(1) = idx(1)+40;
            %            idx(3) = idx(3)-6;
        end
        
        if strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)+60;
            idx(3) = idx(3)-1;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(3) = idx(3)-2;
            idx(1) = idx(1) +30;
        end
        
        if strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1)+45;
            idx(3) = idx(3)+20;
        end

        
        if strcmp(mfname,'/trial63.mat')
            idx(3) = idx(3)-3;
            idx(1) = idx(1) +55;
        end
        
    end
    if expcond ==3
        idx(1) = find(dist>=.05*max(dist),1)+6;
        idx(3) = idx(3)+3;
        
        
        if strcmp(mfname,'/trial42.mat')
            idx(1) = idx(1)+50;
            idx(3) = idx(3)-2;
        end
        
        if strcmp(mfname,'/trial43.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)-2;
        end
        
        if strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)+15;
        end
        
        if strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1)+55;
            idx(3) = idx(3)+25;
        end
        
        if strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)+20;
        end
        
        if strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1)+35;
        end
        if strcmp(mfname,'/trial48.mat')
            idx(3) = idx(3)-4;
            idx(1) = idx(1)+40;
        end
        if strcmp(mfname,'/trial49.mat')
            idx(3) = idx(3)-2;
            idx(1) = idx(1)+37;
        end
        
        if strcmp(mfname,'/trial50.mat')
            idx(3) = idx(3)-2;
            idx(1) = idx(1) +45;
        end
        
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1)+22;
            idx(3) = idx(3)-4;
        end
        
        if strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3)-2;
        end
        
    end
    
    if expcond ==4
        
        end_reach = find(vel(1:501)>=.15*max(vel));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        
        
        if strcmp(mfname,'/trial87.mat')
            %             idx(1) = idx(1)-2;
            idx(3) = idx(3)-10;
        end
        
        if strcmp(mfname,'/trial88.mat')
            %             idx(1) = idx(1)-2;
            idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial89.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)-2;
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
        %         idx(1) = find(dist>=.05*max(dist),1)+6;
        %         idx(3) = idx(3)+3;
        
        if strcmp(mfname,'/trial76.mat')
            idx(1) = idx(1)+25;
            % idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial77.mat')
            idx(1) = idx(1)+30;
            idx(3) = idx(3)-10;
        end
        
        if strcmp(mfname,'/trial79.mat')
            idx(1) = idx(1)+15;
            % idx(3) = idx(3)-10;
        end
        
        if strcmp(mfname,'/trial80.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3)-9;
        end
        
        
        if strcmp(mfname,'/trial81.mat')
            idx(1) = idx(1)+15;
            %   idx(3) = idx(3)-9;
        end
    end
    
    
    if expcond ==6
        idx(1) = find(dist>=.10*max(dist),1);
        
        if strcmp(mfname,'/trial86.mat')
            idx(1) = idx(1)-19;
            idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial84.mat')
            idx(1) = idx(1)+27;
            %             idx(3) = idx(3)+3;
        end
        
        if strcmp(mfname,'/trial99.mat')
            idx(1) = idx(1)+25;
            %             idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial100.mat')
            idx(1) = idx(1)-2;
            idx(3) = idx(3)+1;
        end
        
        if strcmp(mfname,'/trial101.mat')
            idx(1) = idx(1)+38;
            
        end
    end
    
end
%% RTIS 2001 Paretic
if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
    end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
    idx(3) = end_reach(length(end_reach));
    idx(1) = find(dist>=.02*max(dist),1)-1;
    
    if expcond ==1
        if strcmp(mfname,'/trial1.mat')
            idx(1)= idx(1)-2;
            idx(3)= idx(3)-25+8;
            
        end
        if strcmp(mfname,'/trial2.mat')
            idx(1)= idx(1)-2;
            idx(3)= idx(3)-225+20;
            
        end
        
        if strcmp(mfname,'/trial3.mat')
            idx(1)= idx(1)-3;
            idx(3)= idx(3)-180;
        end
        
        if strcmp(mfname,'/trial4.mat')
            idx(1)= idx(1)-2;
            idx(3)= idx(3)-2;
        end
        
        if strcmp(mfname,'/trial5.mat')
            idx(1)= idx(1)-2;
            idx(3)= idx(3)-10;
        end
        
        if strcmp(mfname,'/trial6.mat')
            idx(1)= idx(1)-4;
            idx(3)= idx(3)-3;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(1)= idx(1)-2;
            idx(3)= idx(3)-8;
        end
        
        if strcmp(mfname,'/trial8.mat')
            idx(1)= idx(1)-1;
            %             idx(3)= idx(3)-1;
        end
        
        if strcmp(mfname,'/trial9.mat')
            idx(1)= idx(1)-2;
            %             idx(3)= idx(3)-1;
        end
        
        if strcmp(mfname,'/trial10.mat')
            idx(1)= idx(1)-3;
            %             idx(3)= idx(3)-1;
        end
        
        
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        if strcmp(mfname,'/trial11.mat')
            idx(1)= idx(1)+7;
            idx(3)= idx(3)-17;
        end
        
        if strcmp(mfname,'/trial12.mat')
            idx(1)= idx(1)+35;
            idx(3)= idx(3)-55;
        end
        
        
        
        if strcmp(mfname,'/trial13.mat')
            idx(1)= idx(1)+11;
            idx(3)= idx(3)-121;
        end
        
        
        if strcmp(mfname,'/trial14.mat')
            idx(1)= idx(1)+25;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3)= idx(3)+5;
            
        end
        
        if strcmp(mfname,'/trial15.mat')
            idx(1)= idx(1)+21;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            
            %             idx(3)= idx(3)-35;
        end
        
        
        if strcmp(mfname,'/trial16.mat')
            idx(1)= idx(1)+21;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3) = idx(3)-9;
        end
        
        if strcmp(mfname,'/trial17.mat')
            idx(1)= idx(1)+40;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
                         idx(3)= idx(3)+5;
        end
        
        
        if strcmp(mfname,'/trial18.mat')
            idx(1)= idx(1)+10;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3)= idx(3)+10;
        end
        
        
        if strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1) -35;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3) = idx(3)-35;
        end
        
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1) +2;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3) = idx(3)-6-2;
        end
        
        
    end
    
    if expcond ==3
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
        idx(3) = vely_threshold(length(vely_threshold))+1;
        
        if strcmp(mfname,'/trial21.mat')
            idx(3)= idx(3)-3;
            idx(1)= idx(1)+20;
            
        end
        
        if strcmp(mfname,'/trial22.mat')
            idx(1)= idx(1)+5;
            idx(3) = idx(3) +3;
        end
        
        if strcmp(mfname,'/trial23.mat')
            idx(1)= idx(1)+26;
            idx(3) = idx(3)-5;
        end
        %
        if strcmp(mfname,'/trial26.mat')
            idx(1)= idx(1)+1;
        end
        %
        %
        if strcmp(mfname,'/trial24.mat')
            idx(3)= idx(3)-6;
            idx(1) =idx(1) +3;
        end
        %
        
        if strcmp(mfname,'/trial25.mat')
            idx(3)= idx(3)-140+5;
            idx(1)= idx(1)+30;
        end
        
        if strcmp(mfname,'/trial26.mat')
            %      idx(3)= idx(3)-1;
            idx(1)= idx(1)+1;
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1)= idx(1)+2;
            idx(3)= idx(3);
        end
        if strcmp(mfname,'/trial29.mat')
            idx(1)= idx(1)+13;
            idx(3)= idx(3)-9;
        end
        if strcmp(mfname,'/trial30.mat')
            idx(1)= idx(1)+15;
            %             idx(3)= idx(3)-9;
        end
        if strcmp(mfname,'/trial31.mat')
            idx(1)= idx(1)+3;
            idx(3)= idx(3)-1;
        end
    end
    
    
    if expcond ==4
        idx(1) = find(dist>=.02*max(dist),1)-1;
        vel_threshold= find(vel(1:501)>.2*max(vel));
        idx(3) = vel_threshold(length(vel_threshold));
        
        if strcmp(mfname,'/trial32.mat')
            
            end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
            idx(3) = end_reach(length(end_reach));
            idx(3) = idx(3)+10;
        end
        
        if strcmp(mfname,'/trial34.mat')
            idx(1)= idx(1)-4;
            idx(3)= idx(3)+1;
        end
                
        if strcmp(mfname,'/trial36.mat')
            idx(1)= idx(1)+126;
        end
        if strcmp(mfname,'/trial47.mat')
            idx(3)= idx(3)-1;
        end
        
        if strcmp(mfname,'/trial48.mat')
            idx(3)= idx(3)+4;
        end
        
        if strcmp(mfname,'/trial49.mat')
            idx(3)= idx(3)-3;
        end
        
        if strcmp(mfname,'/trial51.mat')
            idx(3)= idx(3)+2;
        end
        
        
    end
    
    if expcond ==5
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        vel_threshold= find(vel(1:501)>.2*max(vel));
        idx(3) = vel_threshold(length(vel_threshold));
        
        
        if strcmp(mfname,'/trial37.mat')
            idx(1)= idx(1)+31-4;
            idx(3) = idx(3) -2;
        end
        %
        if strcmp(mfname,'/trial38.mat')
            idx(3)= idx(1)+81-6;
            idx(1)= idx(1)+21;
            
        end
        if strcmp(mfname,'/trial39.mat')
            idx(3)= idx(1)+50+15+2;
            idx(1)= idx(1)+10;
            
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(1)= idx(1)+5;
            idx(3)= idx(1)+35;
        end
        
        if strcmp(mfname,'/trial41.mat')
            idx(1)= idx(1)+17;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+2;
            idx(3) = idx(3) +20-3;
        end
        
        
        if strcmp(mfname,'/trial57.mat')
            idx(3)= idx(3)+1;
            idx(1)= idx(1)+6;

            
           maxdisty= max(xhand(1:idx(3),2)); 
           endreach = find(xhand(:,2)==maxdisty);
          
           idx(3) = endreach;

            
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            idx(3)= idx(3)+3;
            idx(1) = idx(1)+8;
            
        end
        
        if strcmp(mfname,'/trial59.mat')
            idx(1)= idx(1)+13;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            idx(3) = idx(3)+1;
            
        end
        
        
        if strcmp(mfname,'/trial60.mat')
            idx(1)= idx(1)+18;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))+1;
            
            
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(1)= idx(1)+20-8;
            vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
            idx(3) = vely_threshold(length(vely_threshold))-37;
            idx(3) = idx(3) - 85;
            
        end
        
        
        
    end
    
    if expcond ==6
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        vely_threshold= find(vely(1:501) > .15*max(vely(1:501)));
        idx(3) = vely_threshold(length(vely_threshold))+1;
        
        %
        if strcmp(mfname,'/trial42.mat')
            idx(3)= idx(3)+21-7;
            idx(1) = idx(1) +15-9;
        end
        %
        %
        if strcmp(mfname,'/trial43.mat')
            idx(1)= idx(1)+6;
            idx(3) = idx(1)+35+11;
        end
        %
        %
        if strcmp(mfname,'/trial44.mat')
            idx(1)= idx(1)+21-2;
            idx(3) = idx(3)+10+7;
            
            
        end
        %
        %
        if strcmp(mfname,'/trial45.mat')
            idx(1)= idx(1)+20;
            idx(3) = idx(3)-4;
            
        end
        
        if strcmp(mfname,'/trial46.mat')
            idx(1)= idx(1)+6;
            idx(3) = idx(3)-1;
            
        end
        
        if strcmp(mfname,'/trial52.mat')
            idx(1)= idx(1)+5;
            idx(3) = idx(3)+2;
        end
        
        if strcmp(mfname,'/trial54.mat')
            idx(1)= idx(1)-1;
            idx(3)= idx(3)-1;
        end
        
        
        if strcmp(mfname,'/trial55.mat')
            idx(1)= idx(1)+26+5;
            idx(3) = idx(3)+2;
        end
        
        if strcmp(mfname,'/trial56.mat')
            idx(3)= idx(3)+11;
            idx(1) = idx(1) +10-3;
        end
    end
    
    
    
end

%% RTIS 2001 Non-Paretic
if strcmp(partid,'RTIS2001') && strcmp(hand,'Left')
    
    if expcond ==1
        idx(1) = find(dist>=.02*max(dist),1)-1;
        idx(3)= find(dist(1:501)==max(dist));
        %
        
        
        if strcmp(mfname,'/trial1.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-5;
        end
        
        if strcmp(mfname,'/trial2.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-7;
        end
        
        if strcmp(mfname,'/trial5.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-1;
        end
        
        if strcmp(mfname,'/trial6.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-6;
        end
        
        
        if strcmp(mfname,'/trial11.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-15;
        end
        
        if strcmp(mfname,'/trial12.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-2;
        end
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .3*max(zdisp));
        
        yvelcond = find(vely(indxZDisp) > .2*max(vely));
        
        idx(1) = indxZDisp(yvelcond(1));
        
        
        idx(3)= find(dist(1:501)==max(dist));
        
        if strcmp(mfname,'/trial30.mat')
            %             idx(1)= idx(1)-10;
            idx(3) = idx(3)-1;
        end
        
        
        if strcmp(mfname,'/trial31.mat')
            %             idx(1)= idx(1)-10;
            idx(1) = idx(1)-2;
        end
        
        
        if strcmp(mfname,'/trial34.mat')
            %             idx(1)= idx(1)-10;
            idx(1) = idx(1)-1;
            %             idx(3) = idx(3)-4;
        end
        
        if strcmp(mfname,'/trial35.mat')
            %             idx(1)= idx(1)-10;
            idx(1) = idx(1)+11;
            idx(3) = idx(3)-4;
        end
        
        
        if strcmp(mfname,'/trial36.mat')
            idx(1) = idx(1)+10;
            idx(3) = idx(3)-3;
        end
        
        
        
        if strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)-6;
        end
        
                
 
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)-15;
        end
        
        if strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1)+1;
        end
        

        if strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)-5;
        end
        
    end
    
    
    if expcond ==3
        % Finding idx(3) max distance
        velcond = find(vel(1:501)<=.10*max(vel(1:501)));
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
        idx(1) = idx(1)+80;
        
        if strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1)-6;
        end
        
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)+6;
        end
        
        if strcmp(mfname,'/trial15.mat')
            
            
        end
        
        
        if strcmp(mfname,'/trial16.mat')
            
            %             indx =  find(abs(vely(10:501))>.2*max(abs(vely(10:501))));
            %             idx(1) =indx(1)+10-1;
            
            idx(1) = idx(1) +5;
            
        end
        
        
        if strcmp(mfname,'/trial17.mat')
            
            
            
        end
        
        
        if strcmp(mfname,'/trial23.mat')
            
            
            
        end
        
        
        if strcmp(mfname,'/trial24.mat')
            
            
            
        end
        if strcmp(mfname,'/trial31.mat')
            
            idx(1) = idx(1) +5-7;
            
        end
        
        if strcmp(mfname,'/trial32.mat')
            
            idx(1) = idx(1) +85+50;
            
        end
        
        
        if strcmp(mfname,'/trial33.mat')
            
            idx(1) = idx(1) +25;
            
        end
        
        if strcmp(mfname,'/trial34.mat')
            
            idx(1) = idx(1) -95-10;
            
        end
        if strcmp(mfname,'/trial25.mat')
            
            idx(3) = idx(3) -13;
            idx(1) = idx(1)-6;
            
        end
        
        
        if strcmp(mfname,'/trial26.mat')
            
            idx(1) = idx(1)+21-7;
            idx(3) = idx(3) +2;
        end
        
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1) +5;
            idx(3) = idx(3) +3;
            
            
        end
        
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1) +13;
            idx(3) = idx(3) +8;
        end
        
        
        if strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1) +5;
            idx(3) = idx(3) -2;
            
            
        end
        
                
        if strcmp(mfname,'/trial30.mat')
%             idx(1) = idx(1) +5;
            idx(3) = idx(3) +5;
            
            
        end
        
        
    end
    
    
    
    if expcond ==4
        idx(1) = find(dist>=.02*max(dist),1)-1;
        idx(3)= find(dist(1:501)==max(dist));
        
        
        if strcmp(mfname,'/trial39.mat')
            idx(1) = idx(1) -2;
            idx(3) = idx(3) -2;
            
        end
        
        
        if strcmp(mfname,'/trial41.mat')
            % idx(1) = idx(1) -2;
            idx(3) = idx(3) -13;
            
        end
        
        
        if strcmp(mfname,'/trial44.mat')
             idx(3) = idx(3) -1;
            idx(1) = idx(1) +25;
            
        end


        
        if strcmp(mfname,'/trial45.mat')
            % idx(1) = idx(1) -2;
            idx(1) = idx(1) -10;
            
        end
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1) +5;
            % idx(3) = idx(3) -1;
        end
        
        
        
        if strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1) +3;
            % idx(3) = idx(3) -1;
        end
        
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1) +7;
            % idx(3) = idx(3) -1;
        end
        
    end
    
    
    
    if expcond ==5
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .3*max(zdisp));
        
        yvelcond = find(vely(indxZDisp) > .2*max(vely));
        idx(1) = indxZDisp(yvelcond(1));
        
        
        idx(3)= find(dist(1:501)==max(dist));
        
        %
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1) -2;
            % idx(3) = idx(3) -1;
        end
        
        
        if strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1) -2;
            % idx(3) = idx(3) -1;
        end
        

        
        if strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1) -20;
            % idx(3) = idx(3) -1;
        end
    end
    
    
    if expcond ==6
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .3*max(zdisp));
        
        yvelcond = find(vely(indxZDisp) > .2*max(vely));
        idx(1) = indxZDisp(yvelcond(1));
        
        idx(3)= find(dist(1:501)==max(dist(1:501)));
        
        
        
        if strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1) -2;
            % idx(3) = idx(3) -1;
        end
        
        
        
        if strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1) +10;
            % idx(3) = idx(3) -1;
        end
        

        
        if strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1) -15;
            % idx(3) = idx(3) -1;
        end
        
        
        if strcmp(mfname,'/trial64.mat')
            idx(1) = idx(1) +6;
            % idx(3) = idx(3) -1;
        end
        
        
        if strcmp(mfname,'/trial65.mat')
            idx(1) = idx(1) -4-15;
            % idx(3) = idx(3) -1;
        end
        
        
    end
    
    
    
end


%% RTIS 2003 Paretic

if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
    if expcond ==1
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        if strcmp(mfname,'/trial18.mat')
            idx(1)= idx(1)-5;
            idx(3) = idx(3) -5;
            %             length(dist)
        end
        
        if strcmp(mfname,'/trial19.mat')
            idx(1)= idx(1)-10;
            idx(3) = idx(3)-9;
        end
        
        if strcmp(mfname,'/trial34.mat')
            %             idx(1)= idx(1)-3;
            idx(3) = idx(3)-5;


            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach-5;
        end
        
        if strcmp(mfname,'/trial36.mat')
            %             idx(1)= idx(1)-3;
            idx(3) = idx(3)-2;


            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial37.mat')
            idx(1)= idx(1)-3;
            idx(3) = idx(3)-3;


            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial38.mat')
            idx(1)= idx(1)-3;
            idx(3) = idx(3) - 200;



            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach-1;
        end
        
    end
    
    if expcond ==2
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        
        if strcmp(mfname,'/trial22.mat')
            idx(3)= idx(3)-205;
            idx(1) = idx(1) +10;
        end
        %
        %
        if strcmp(mfname,'/trial23.mat')
            idx(1)= idx(1)-35;
            idx(3) = idx(3) -193;
        end
        %
        
        if strcmp(mfname,'/trial24.mat')
            idx(1)= idx(1)-10-15;
            idx(3) = idx(3) +65;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %
        %
        if strcmp(mfname,'/trial26.mat')
            idx(1)= idx(1)+5-8;
            idx(3) = idx(3)+55;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %         %
        if strcmp(mfname,'/trial27.mat')
            idx(1)= idx(1)-10-12;
            idx(3) = idx(3)+50;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        %
        if strcmp(mfname,'/trial40.mat')
            idx(3)= idx(3)-250+18;
            idx(1) = idx(1)-25;
        end
        %
        %
        if strcmp(mfname,'/trial41.mat')
            idx(3)= idx(3)+65-11;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
           idx(1) = idx(1)-12;
        end
        %
        if strcmp(mfname,'/trial42.mat')
            idx(3)= idx(3)-40;
            idx(1) =  idx(1)-5;
        end
        
        if strcmp(mfname,'/trial43.mat')
            idx(3)= idx(3)+75-8;


            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;

           idx(1) = idx(1)-20;
        end
        
        
    end
    
    if expcond == 3
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        
        if strcmp(mfname,'/trial28.mat')
            idx(3)= idx(3)-220+3;
        end
        %
        
        if strcmp(mfname,'/trial29.mat')
            idx(3)= idx(3)+64;
            idx(1) = idx(1)-15;
        end
        
        
        if strcmp(mfname,'/trial30.mat')
            idx(3)= idx(3)-105-9;
            idx(1) = idx(1)-15;

            maxdisty= max(xhand(1:idx(3),2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial32.mat')
            idx(3)= idx(3)-250;
            idx(1) = idx(1)-15;
        end
        
        if strcmp(mfname,'/trial45.mat')
            idx(3)= idx(3)+65+6;
            idx(1) = idx(1)-25+2;
        end
        
        
        if strcmp(mfname,'/trial48.mat')
            idx(3)= idx(3)-85-9;
            idx(1) = idx(1)-15;
        end
        
        
        if strcmp(mfname,'/trial49.mat')
            idx(3)= idx(3)-130;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
           idx(1) = idx(1)-2;
        end
    end
    
    if expcond ==4
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        


        if strcmp(mfname,'/trial57.mat')
            maxdisty= max(xhand(1:idx(3),2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end


        if strcmp(mfname,'/trial59.mat')
            idx(1)= idx(1)+15;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;

        end
        
        %
        %
        if strcmp(mfname,'/trial60.mat')
            idx(1)= idx(1)+2-12;
            idx(3) = idx(3) -10-14;
        end
        %
        if strcmp(mfname,'/trial72.mat')
            idx(1)= idx(1)+53;
            idx(3) = idx(3) -12;
        end
        %
        %
        if strcmp(mfname,'/trial73.mat')
            idx(1)= idx(1)+130;
        end
        %
        if strcmp(mfname,'/trial75.mat')
            idx(3)= idx(3)-335-10;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        %
        if strcmp(mfname,'/trial76.mat')
            idx(3)= idx(3)-15-13;
        end
        
    end
    
    if expcond==5
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        if strcmp(mfname,'/trial62.mat')
            idx(1)= idx(1)-25;
            idx(3) = idx(3) +55;
           
           maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach;
        end
        %
        if strcmp(mfname,'/trial63.mat')
            idx(1)= idx(1)-20-6;
            idx(3) = idx(3) - 67;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %
        
        if strcmp(mfname,'/trial64.mat')
            idx(1)= idx(1)-10-9;
            idx(3) = idx(3) +70;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach-13;
        end
        %
        
        if strcmp(mfname,'/trial65.mat')
            idx(1)= idx(1)-10-12;
            idx(3) = idx(3) -229;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial66.mat')
            idx(1)= idx(1)-15-14;
            idx(3) = idx(3) +60;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial77.mat')
            idx(1)= idx(1)-10-10;
            idx(3) = idx(3) +55;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial79.mat')
            idx(1)= idx(1)-10-12;
            idx(3) = idx(3) -25;
        end
        
        
        if strcmp(mfname,'/trial80.mat')
            idx(1)= idx(1)-10-12;
            idx(3) = idx(3) +55+15;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial81.mat')
            idx(1)= idx(1)-35-10;
            idx(3) = idx(3) +70;
        end
    end
    
    if expcond ==6
        
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        if strcmp(mfname,'/trial68.mat')
            
            idx(1)= idx(1)-20;
            idx(3) = idx(3) +70;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %
        if strcmp(mfname,'/trial69.mat')
            idx(1)= idx(1)-35;
            idx(3) = idx(3) + 65;
        end
        %
        if strcmp(mfname,'/trial70.mat')
            idx(1)= idx(1)-10-10;
            idx(3) = idx(3) +70;
        end
        %
        if strcmp(mfname,'/trial83.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1) -10-10;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %
        %
        if strcmp(mfname,'/trial84.mat')
            idx(1)= idx(1)-30;
            idx(3) = idx(3) -25-15;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        %
        if strcmp(mfname,'/trial86.mat')
            idx(1)= idx(1)-15-10;
            idx(3) = idx(3) +65;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
    end
    
    
end
%% RTIS 2003 Non-Paretic
if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
    if expcond ==1
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        if strcmp(mfname,'/trial35.mat')
            idx(3)= idx(3)-6;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        
        if strcmp(mfname,'/trial36.mat')
            idx(3)= idx(3)-55-13;
            idx(1) = idx(1)-10;
        end
        
        if strcmp(mfname,'/trial37.mat')
            idx(3)= idx(3)-55-13-7;
            idx(1) = idx(1)-6;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
       
        if strcmp(mfname,'/trial38.mat')

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;
            idx(1) = idx(1)-6;
        end

        if strcmp(mfname,'/trial39.mat')
            idx(3)= idx(3)-55-13-4;
        end
        
        
        if strcmp(mfname,'/trial50.mat')
            idx(3)= idx(3)-12;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial51.mat')
            idx(3)= idx(3)-76;
            idx(1) = idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial52.mat')
            idx(3)= idx(3)-12;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;
            idx(1)=idx(1)-9;
        end
        
        
        if strcmp(mfname,'/trial53.mat')
            idx(3)= idx(3)-5;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;

            idx(1) = idx(1)-5;
        end
        
        
        if strcmp(mfname,'/trial54.mat')
            idx(3)= idx(3)-96;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);

            idx(3) = endreach;
        end
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        %


        if strcmp(mfname,'/trial40.mat')
            idx(3)= idx(3)+68;
            idx(1) = idx(1) +15;
        end
        %
        %
        if strcmp(mfname,'/trial41.mat')
            idx(3)= idx(3)+59;
            idx(1) = idx(1)+20 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        %
        if strcmp(mfname,'/trial42.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)+12 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        %
        if strcmp(mfname,'/trial43.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)+20 ;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        %
        if strcmp(mfname,'/trial44.mat')
            idx(3)= idx(3)+68;
            idx(1) = idx(1)+20+3 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        %
        if strcmp(mfname,'/trial55.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)+20 -4;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        %
        if strcmp(mfname,'/trial56.mat')
            idx(3)= idx(3)+80-7;
            idx(1) = idx(1)+10 +5;
        end
        
        %
        if strcmp(mfname,'/trial59.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)+10-7 ;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
    end
    
    if expcond ==3
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        
        if strcmp(mfname,'/trial45.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1)+30+1 ;
        end
        
        
        if strcmp(mfname,'/trial46.mat')
            idx(3)= idx(3)-120;
            idx(1) = idx(1)+20 ;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        
        if strcmp(mfname,'/trial47.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)+15 ;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        if strcmp(mfname,'/trial48.mat')
            idx(3)= idx(3)+65+8;
            idx(1) = idx(1)+20-5 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1)+10 ;
        end
        
        
        if strcmp(mfname,'/trial64.mat')
            idx(3)= idx(3)-65-13;
            idx(1) = idx(1)-5-15 ;
        end
        
        
        if strcmp(mfname,'/trial65.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1)-5 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
        
        
        if strcmp(mfname,'/trial66.mat')
            idx(3)= idx(3)+65;
            idx(1) = idx(1)-5 ;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 
        end
    end
    
    
    if expcond ==4
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        if strcmp(mfname,'/trial67.mat')
            idx(3)= idx(3)-95-12;
            idx(3) = idx(3)-2;
            idx(1) = idx(1)-3;
        end
        %
        if strcmp(mfname,'/trial68.mat')
            idx(3)= idx(3)-115+21;
            idx(1) = idx(1)-1;
        end
        %
        if strcmp(mfname,'/trial69.mat')
            idx(3)= idx(3)-105+8;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

        end
        %
        if strcmp(mfname,'/trial83.mat')

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

        end

        if strcmp(mfname,'/trial84.mat')

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

        end

        if strcmp(mfname,'/trial86.mat')

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

        end


    end
    
    if expcond ==5
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        %
        if strcmp(mfname,'/trial74.mat')
            idx(3)= idx(3)-75;
            idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

            idx(1) = idx(1)+3;

     
        end
        
        %
        if strcmp(mfname,'/trial75.mat')
            idx(3)= idx(3)+65;
            %  idx(1) = idx(1) +10;

     
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach; 

        end
        
        %
        if strcmp(mfname,'/trial88.mat')
            idx(3)= idx(3)+65;
            %  idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        %
        if strcmp(mfname,'/trial89.mat')
            idx(3)= idx(3)+75;
            %  idx(1) = idx(1) +10;
        end
        
        if strcmp(mfname,'/trial90.mat')
            idx(3)= idx(3)+75;
            %  idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial91.mat')
            idx(3)= idx(3)+70;
            %  idx(1) = idx(1) +10;
        end
    end
    
    if expcond ==6
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        %
        %
        if strcmp(mfname,'/trial77.mat')
            idx(3)= idx(3)+69;
            %  idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        %
        if strcmp(mfname,'/trial78.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        %
        if strcmp(mfname,'/trial79.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1) +10;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
            idx(1) = idx(1)-20;
        end
        %
        if strcmp(mfname,'/trial80.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1) +10;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;

        end
        
        %
        if strcmp(mfname,'/trial93.mat')
            idx(3)= idx(3)+63;
            idx(1) = idx(1) +10;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        %
        if strcmp(mfname,'/trial94.mat')
            idx(3)= idx(3)+70;
            idx(1) = idx(1)-5;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
    end
    
end





%% RTIS 2006 -Paretic

if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
    if expcond==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %

                %
        if strcmp(mfname,'/trial22.mat')
            idx(1)= idx(1)-7;
        end
        if strcmp(mfname,'/trial23.mat')
            idx(3)= idx(3)-25+7;
            idx(1) = idx(1)-10;
        end
        %
        if strcmp(mfname,'/trial24.mat')
            idx(3)= idx(3)-35-18;
             idx(1) = idx(1)-10;
        end
        %
        
        if strcmp(mfname,'/trial25.mat')
            idx(3)= idx(3)-60;
            idx(1) = idx(1) +15;
        end
        %
        %
        if strcmp(mfname,'/trial26.mat')
            idx(3)= idx(3)-55+18;
            idx(1) = idx(1)-10;

        end
        %
        %
        if strcmp(mfname,'/trial32.mat')
            idx(3)= idx(3)-35-25;
             idx(1) = idx(1)-15;
        end
        %
        
        if strcmp(mfname,'/trial33.mat')
            idx(3)= idx(3)-62;
            idx(1) = idx(1)-15;

        end
        
        if strcmp(mfname,'/trial34.mat')
            idx(3)= idx(3)-45;
            idx(1) = idx(1)-15;

        end
        
        if strcmp(mfname,'/trial35.mat')
%             idx(3)= idx(3)-45;
            idx(1) = idx(1)-15;

        end
        
        if strcmp(mfname,'/trial36.mat')
            idx(3)= idx(3)-54;
            idx(1) = idx(1)-15;

            
        end
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        
        if strcmp(mfname,'/trial27.mat')
            idx(3)= idx(3)-180-1;
            idx(1) = idx(1) -20+1;
        end
        %
        if strcmp(mfname,'/trial28.mat')
            idx(3)= idx(3)-41-3;
            idx(1) = idx(1)-12 ;
        end
        %
        if strcmp(mfname,'/trial29.mat')
            idx(3)= idx(3)-190;
            idx(1) = idx(1)-12;
        end
        %
        if strcmp(mfname,'/trial30.mat')
            idx(3)= idx(3)-185;
            idx(1) = idx(1) -5-11;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        

        end
        %
        if strcmp(mfname,'/trial31.mat')
            idx(3)= idx(3)-140;
            idx(1) = idx(1) +5-20;
            idx(3)=idx(3)+15;
        end
        %
        if strcmp(mfname,'/trial37.mat')
            idx(3)= idx(3)+55+12;
            idx(1)=idx(1)-5-15;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach-50;

            maxdisty= max(xhand(idx(1):idx(3),2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        %
        %
        if strcmp(mfname,'/trial38.mat')
            idx(1) = idx(1)-15+9;
            idx(3)=idx(3)-20;
        end
        %
        if strcmp(mfname,'/trial41.mat')
            idx(1) = idx(1)-8;
            idx(3)=idx(3)-200;
            
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
          
        end
    end
    
    
    if expcond ==3
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        if strcmp(mfname,'/trial42.mat')
            idx(1)= idx(1)+2-10;
            idx(3) = idx(3)-205;
        end
        %
        
        if strcmp(mfname,'/trial45.mat')
            idx(1)= idx(1)-10-10;
            idx(3)= idx(3)-175;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
           
        end
        %
        
        if strcmp(mfname,'/trial48.mat')
            idx(1)= idx(1)+21;
            idx(3) = idx(3)-190-6;
        end
        %
        %
        if strcmp(mfname,'/trial49.mat')
            idx(1)= idx(1)-15-6;
            idx(3) = idx(3)-15;
        end
        %
        %
        if strcmp(mfname,'/trial50.mat')
            idx(1)= idx(1)+5;
            idx(3) = idx(3)-155-9;
        end
        %
        if strcmp(mfname,'/trial51.mat')
            idx(1)= idx(1)-15;
            idx(3) = idx(3)-200;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        
    end
    
    if expcond==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                
        if strcmp(mfname,'/trial52.mat')
            idx(1)= idx(1)-20;
%             idx(3) = idx(3) -15;
        end

        
        if strcmp(mfname,'/trial53.mat')
            idx(1)= idx(1)-15;
            idx(3) = idx(3) -15;
        end
        %
        % %
        if strcmp(mfname,'/trial54.mat')
            idx(3)= idx(3)-5;
            idx(1)= idx(1)-15;
        end
        %
        if strcmp(mfname,'/trial55.mat')
%             idx(3)= idx(3)-5;
            idx(1)= idx(1)-15;
        end
        if strcmp(mfname,'/trial56.mat')
            idx(3)= idx(3)-70;
            idx(1)= idx(1)-15-10;
        end
        %
        %
        
        if strcmp(mfname,'/trial64.mat')
            idx(3)= idx(3)-25;
            idx(1)= idx(1)-15;
        end
        %
        if strcmp(mfname,'/trial65.mat')
            idx(3)= idx(3)-13;
            idx(1)= idx(1)-15;
        end
        
        
        if strcmp(mfname,'/trial70.mat')
            idx(3)= idx(3)-20+7;
            idx(1)= idx(1)-15;
        end
    end
    
    
    if expcond ==5
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        %
        if strcmp(mfname,'/trial57.mat')
            idx(1)= idx(1)+90-2;
            idx(3) = idx(3)+20+15;
        end
        
        if strcmp(mfname,'/trial80.mat')
            idx(1)= idx(1)-20-20;
            idx(3) = idx(3)+25+18;
        end
        %
        %
        if strcmp(mfname,'/trial81.mat')
            idx(1)= idx(1)-25-12;
            idx(3) = idx(3)+5+16;
        end
        %
        if strcmp(mfname,'/trial75.mat')
            idx(1)= idx(1)-20-15;
            idx(3) = idx(3)+15+4;
        end
        %
        
        if strcmp(mfname,'/trial76.mat')
            idx(1)= idx(1)-15;
            idx(3) = idx(3)+2;
        end

        if strcmp(mfname,'/trial77.mat')
            idx(1)= idx(1)-5-15;
            idx(3) = idx(3)+60;
        end
        
        
        if strcmp(mfname,'/trial78.mat')
            idx(1)= idx(1)-5-6;
            idx(3) = idx(3)+55+4;
        end
        %
        
        if strcmp(mfname,'/trial79.mat')
            idx(1)= idx(1)-15;
            idx(3) = idx(3)+55;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
            idx(1)=idx(1)-10;
        end
        %
        
    end
    
    if expcond==6
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        if strcmp(mfname,'/trial60.mat')
            idx(1)= idx(1)-30-10;
            idx(3) = idx(3) -205+7;
            
        end
        %
        %
        if strcmp(mfname,'/trial61.mat')
            idx(1)= idx(1)-45 ;
            idx(3) = idx(3) -10+30+20+9;
            
        end
        %
        
        if strcmp(mfname,'/trial62.mat')
            idx(3)= idx(3)-170+10 ;
            idx(1) = idx(1) -5-10;
            
        end
        %
        if strcmp(mfname,'/trial71.mat')
            idx(3)= idx(3)+45 +6;
            idx(1) = idx(1)+22;
            
        end
        %

        if strcmp(mfname,'/trial73.mat')
            
            idx(1) = idx(1)-10;
            idx(3) = idx(3) +20+20+4;
            
        end

        %
        %
        if strcmp(mfname,'/trial67.mat')
            
            idx(1) = idx(1)-15;
            idx(3) = idx(3) -25;
            
        end
        %
        if strcmp(mfname,'/trial72.mat')
            
            idx(1) = idx(1)+30;
            idx(3) = idx(3) +35+20+13;
            
        end
        %
        if strcmp(mfname,'/trial74.mat')
            
              idx(1) = idx(1)-15;
            idx(3) = idx(3) -190+20+17;
            
        end
        %
    end
    
    
end


%% RTIS 2006 Non-Paretic
if strcmp(partid,'RTIS2006') && strcmp(hand,'Left')
    max_dist = max(dist);
    end_reach = find(dist==max_dist);
    idx(3) = end_reach;
    idx(1) = find(dist>=.2*max(dist),1);
    %
    if expcond==1
        %
        idx(1) = find(dist>=.02*max(dist),1);
        
        if strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1)-15;
        end
      
        if strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-15;
        end

        if strcmp(mfname,'/trial3.mat')
            idx(3) = idx(3)-8;
            idx(1) = idx(1)-15;
        end
        if strcmp(mfname,'/trial4.mat')
%             idx(3) = idx(3)-8;
            idx(1) = idx(1)-10;
        end
        if strcmp(mfname,'/trial5.mat')
%             idx(3) = idx(3)-8;
            idx(1) = idx(1)-10;
        end
        if strcmp(mfname,'/trial6.mat')
         idx(1) = idx(1)-10;
        end
        if strcmp(mfname,'/trial8.mat')
                    idx(1) = idx(1)-5;
        end
        if strcmp(mfname,'/trial10.mat')
%                         idx(3) = idx(3)-27;
        end
    end
    
    if expcond ==2
        if strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1)-20-20 ;
            idx(3) = idx(3) -5;
            
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)-20 -20;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)-10-20-20 ;
            %             idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1)-20-15 ;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1)+60 ;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)-35 ;
            %             idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1)-45 ;
            idx(3) = idx(3) -10;
        end
    end
    
    if expcond ==3
        
        
        if strcmp(mfname,'/trial11.mat')
            idx(1) = idx(1)-20 -20;
            idx(3) = idx(3) -10;
        end
        
        
        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)-9-20 -20;
            idx(3) = idx(3) -5;
        end
        
        
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)-20 -15;
            idx(3) = idx(3) -5;
        end
        
                
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)-20 ;
%             idx(3) = idx(3) -10;
        end
        
        
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)-20-20 ;
            idx(3) = idx(3) -10;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1)-20-20 ;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1)-20 -25;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        
        if strcmp(mfname,'/trial31.mat')
            idx(1) = idx(1)-20-18 ;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial32.mat')
            idx(1) = idx(1)-20 ;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
    end
    
    if expcond ==4
        
        if strcmp(mfname,'/trial33.mat')
            idx(1) = idx(1)-30 ;
            idx(3) = idx(3) -15;
        end
        
        
        if strcmp(mfname,'/trial34.mat')
            idx(1) = idx(1)-30 ;
            idx(3) = idx(3) -15;
        end
        
        if strcmp(mfname,'/trial35.mat')
            idx(1) = idx(1)-20-10 ;
            idx(3) = idx(3) -10;
        end
        
        if strcmp(mfname,'/trial37.mat')
            idx(1) = idx(1)-30 ;
            idx(3) = idx(3) -10;
        end
        
        if strcmp(mfname,'/trial39.mat')
            idx(1) = idx(1)-20 -10;
            idx(3) = idx(3) -25;
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial40.mat')
            idx(1) = idx(1)-25 -15;
            idx(3) = idx(3) -15;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial41.mat')
            idx(1) = idx(1)-35 ;
            idx(3) = idx(3) -5;
        end
    end
    
    if expcond ==5
        
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)-25-3 ;
            idx(3) = idx(3) -5;
        end
        
        
        if strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)-25 -15;
            idx(3) = idx(3) -25;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach-2;
        end
        
        
        
        if strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1)-9 ;
            %            idx(3) = idx(3) -25;
        end
        
        
        if strcmp(mfname,'/trial59.mat')
            idx(1) = idx(1)-20-20 ;
            %            idx(3) = idx(3) -25;
        end
        
        
        if strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)-25 -30;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial61.mat')
            idx(1) = idx(1)-20-15 ;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1)-25 ;
            idx(3) = idx(3) -25;
         
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach-5;
        end
    end
    
    
    if expcond ==6
        
        
        if strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1)-25-30 -7;
            idx(3) = idx(3) -40;

            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1)-30-6 ;
            idx(3) = idx(3) -20;
        end
        
        if strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1)-20-30 ;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial50.mat')
            idx(1) = idx(1)-20-30 ;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1)-25 ;
            idx(3) = idx(3) -5;
        end
        
        if strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)-25 ;
            idx(3) = idx(3) -5;
        end
    end
    
    
    
end


%% RTIS 2002 Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
    if expcond==1
        
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        
        
        if strcmp(mfname,'/trial1.mat')
            idx(3)=idx(3)-100;
            %idx(1) = idx(1) +100;
        end
        
        if strcmp(mfname,'/trial2.mat')
            idx(3)=idx(3)-120;
            idx(1) = idx(1) +100-20;
        end
        %
        
        if strcmp(mfname,'/trial3.mat')
            idx(3)=idx(3)-120+30;
            idx(1) = idx(1) +90-20;
        end
        if strcmp(mfname,'/trial4.mat')
            idx(3)=idx(3)-110;
            idx(1) = idx(1) +30;
        end
        
        if strcmp(mfname,'/trial5.mat')
            idx(3)=idx(3)-140;
        end
        %
        if strcmp(mfname,'/trial6.mat')
            idx(3)=idx(3)-120;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(3)=idx(3)-60+11;
        end
        
        if strcmp(mfname,'/trial7.mat')
            idx(3)=idx(3)-80;
        end
        
        if strcmp(mfname,'/trial8.mat')
            idx(3)=idx(3)-140+10;
            idx(1) = idx(1) +120;
        end
        
        
        if strcmp(mfname,'/trial9.mat')
            idx(3)=idx(3)-150+3;
        end
        
        
        if strcmp(mfname,'/trial10.mat')
            idx(3)=idx(3)-120+6;
        end
        
        
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
                if strcmp(mfname,'/trial16.mat')
                    idx(3)=idx(3)+20+20;
                end
        
        
        if strcmp(mfname,'/trial17.mat')
            idx(1)=idx(1)+12;
            idx(3) = idx(3) -10+2;
        end
        %
        %
        if strcmp(mfname,'/trial18.mat')
            idx(1)=idx(1)+50-16;
            
        end
        if strcmp(mfname,'/trial19.mat')
            idx(1)=idx(3);
            idx(3) = idx(3) +60+10;
            
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1)=idx(1)-2;
            idx(3) = idx(3) +25;
            
        end
        %
        %
        if strcmp(mfname,'/trial26.mat')
            idx(1)=idx(1)-10;
            idx(3) = idx(3) +55-10+30;
            
        end
        
        if strcmp(mfname,'/trial28.mat')
            idx(1)=idx(1)-40+5;
            idx(3) = idx(3) -90;
            
        end
        
        if strcmp(mfname,'/trial29.mat')
            idx(1)=idx(1)+20;
            idx(3) = idx(3) +10+18;
            
        end
        
        if strcmp(mfname,'/trial30.mat')
            %             idx(1)=idx(1)+20;
            idx(3) = idx(3) -20;
            
        end
    end
    
    
    if expcond ==3
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        
        if strcmp(mfname,'/trial11.mat')
            idx(1)=idx(3)-15-5-5;
            idx(3)= idx(3) +70;
            
        end
        
        if strcmp(mfname,'/trial12.mat')
            idx(1)=idx(1)+25;
            idx(3) = idx(3) +45+10;
            
        end
        
        
        if strcmp(mfname,'/trial13.mat')
            idx(3)=idx(3)+65-40-15;
            idx(1) = idx(1)-15;
            
        end
        
        
        if strcmp(mfname,'/trial14.mat')
            idx(1)=idx(1)+50;
            idx(3) = idx(3) +30-18;
            
        end
        
        %
        if strcmp(mfname,'/trial15.mat')
            idx(1)=idx(1)+10-3;
            idx(3) = idx(3) -33+2;
            
        end
        %
        if strcmp(mfname,'/trial21.mat')
            idx(1)=idx(1)+50-3;
            idx(3) = idx(3)+20 ;
            
        end
        %
        if strcmp(mfname,'/trial22.mat')
            idx(1)=idx(1)-14;
            idx(3) = idx(3) +40;
            
        end
        
        %
        if strcmp(mfname,'/trial23.mat')
            idx(1)=idx(1)+25;
            idx(3) = idx(3) -20+15;
            
        end
        %
        if strcmp(mfname,'/trial25.mat')
            idx(1)=idx(1)+15;
            idx(3) = idx(3) -5;
            
        end
        
    end
    
    
    if expcond ==4
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach));
        idx(1) = find(dist>=.02*max(dist),1)-1;
        
        if strcmp(mfname,'/trial31.mat')
            idx(1)=idx(1)+45;
            idx(3) = idx(3)-135+2;
        end
        %
        %
        if strcmp(mfname,'/trial32.mat')
            idx(3)=idx(3)-60+30+2;
            idx(1)=idx(1);
        end
        %
        %
        if strcmp(mfname,'/trial33.mat')
            idx(3)=idx(3)-85+30+15;
        end
        %
        %
        if strcmp(mfname,'/trial34.mat')
            idx(3)=idx(3)-25+15;
        end
        %
        if strcmp(mfname,'/trial35.mat')
            idx(3)=idx(3)-100;
        end
        
        %
        if strcmp(mfname,'/trial36.mat')
            idx(3)=idx(3)-80;
            idx(1) = idx(1)-20;
        end
       
        %
        if strcmp(mfname,'/trial37.mat')
            idx(3)=idx(3)-80;
            idx(1) = idx(1)-15;
          
        end
        %
        if strcmp(mfname,'/trial38.mat')
            idx(3)=idx(3)-20+5;
            idx(1) = idx(1);
        end
        
        %
        if strcmp(mfname,'/trial39.mat')
            idx(3)=idx(3)-60;
            idx(1) = idx(1) ;
        end
        
        %
        if strcmp(mfname,'/trial40.mat')
            idx(3)=idx(3)-100;
            idx(1) = idx(1) +65;
        end
        
        
        %
        if strcmp(mfname,'/trial41.mat')
            idx(3)=idx(3)-110;
        end
        
        
        %
        if strcmp(mfname,'/trial62.mat')
            idx(3)=idx(3)-80;
            idx(1)=idx(1)+20;
            
        end
        
        %
        if strcmp(mfname,'/trial63.mat')
            idx(3)=idx(3)-165;
            idx(1)=idx(1)+20-10;
            
        end
    end
    
    if expcond ==5
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        %
        if strcmp(mfname,'/trial42.mat')
            idx(1) = idx(1) +27;
            idx(3) = idx(3) + 70;
        end
        %
        if strcmp(mfname,'/trial43.mat')
            idx(1)=idx(1)-10-10;
            idx(3) = idx(3) +70;
        end
        %
        if strcmp(mfname,'/trial46.mat')
            idx(1)=idx(1)-65+20;
            idx(3) = idx(3) -22;
        end
        %
        if strcmp(mfname,'/trial57.mat')
            idx(1)=idx(1)-115+45+15;
            idx(3) = idx(3) -140;
        end
        
        %
        if strcmp(mfname,'/trial59.mat')
            idx(1)=idx(1)-165+45+35+15;
            idx(3) = idx(3)+45 ;
        end
        %
        if strcmp(mfname,'/trial60.mat')
            idx(1)=idx(1)-95+35;
            idx(3) = idx(3) -115;
        end
        
        %
        if strcmp(mfname,'/trial61.mat')
            idx(1)=idx(1)-35;
            idx(3) = idx(3) -160;
        end
    end
    
    if expcond ==6
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>= .2*max(zdisp));
        idx(1) = indxZDisp(1);
        %
        end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
        idx(3) = end_reach(length(end_reach))-70;
        
        %
        if strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1) -10;
            idx(3) = idx(3) -141;
            
        end
        %
        if strcmp(mfname,'/trial48.mat')
            idx(3)=idx(1)+10+5;
            idx(1) = idx(1)-100-10+25+5;
        end
        %
        if strcmp(mfname,'/trial50.mat')
            idx(3)=idx(1)-20+50;
            idx(1) = idx(1)-80;
        end
        
        %
        if strcmp(mfname,'/trial51.mat')
            idx(3)=idx(1)-10+51;
            idx(1) = idx(1)-30;
        end
                
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1);
            idx(3) = idx(3)+33+5;
        end

        if strcmp(mfname,'/trial56.mat')
            idx(1)=idx(1)-100+4+18;
            idx(3) = idx(3)-110+35;
        end
    end
    
end


%% RTIS 2002 Non-Paretic

if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
    if expcond==1
        velthresh = find(vely(1:501)>.02*max(vely(1:501)));
        distthresh = find(dist(velthresh)>.02*max(dist(velthresh)));
        
        idx(1) = velthresh(distthresh(1));
        
        
        indx= find(vel(1:501)>.2*max(vel(1:501)));
        idx(3) = indx(length(indx));
        
        
        if strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1)-5;
            idx(3) =idx(3)+15+8;
        end
        if strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-5;
            idx(3) =idx(3);
        end
        %
        if strcmp(mfname,'/trial3.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3) -60;
        end
        %
        %
        %
        if strcmp(mfname,'/trial4.mat')
            idx(1) = idx(1)-5;
            idx(3) = idx(3)+20+10+16;


            maxdisty= max(xhand(1:idx(3),2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        if strcmp(mfname,'/trial5.mat')
            idx(1) = idx(1)-1;
            idx(3) = idx(3) -20;
        end
        %
        %
        if strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1) + 130-5;
            idx(3) = idx(3) + 15;
            
        end

        if strcmp(mfname,'/trial7.mat')
            idx(3) = idx(3) + 16;
            
        end
        
        
        %
        if strcmp(mfname,'/trial8.mat')
            % idx(1) = idx(1) + 80;
            idx(3) = idx(3)+14;
            
        end
        
        %
        if strcmp(mfname,'/trial9.mat')
            idx(1) = idx(1) ;
            idx(3) = idx(3)+25;
            
        end
        %
        if strcmp(mfname,'/trial10.mat')
            idx(1) = idx(1) ;
            idx(3) = idx(3);
            
        end
        %
        if strcmp(mfname,'/trial11.mat')
            idx(1) = idx(1);
            idx(3) = idx(3)+25 ;
            
        end
        
    end
    
    if expcond ==2
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>.2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        idx(3)= find(dist(1:501)==max(dist));
        
        
        if strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1)+45-15;
            idx(3) = idx(3) -30+15;
        end


        if strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1)-15;
%             idx(3) = idx(3) -30+15;
        end
        

        if strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)-20-15+5;
            idx(3) = idx(3) -10;
        end
        %
        if strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)-8-20-10;
            idx(3) = idx(3) -45+15;
        end
        %
        %
        if strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)-5-15;
            idx(3) = idx(3)-15;
        end
        %
        if strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)-5-10-15;
            idx(3) = idx(3)-50+20+13;
        end
        %
        if strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)-28-10;
            idx(3) = idx(3) -15+4;
        end
        %      %
        if strcmp(mfname,'/trial29.mat')
            idx(3) = idx(3)-16+10;
            
        end
        if strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1)-16-10;
            
        end
        %
        if strcmp(mfname,'/trial31.mat')
            idx(1) = idx(1)-5-15;
            idx(3) = idx(3) ;
        end
        %
        if strcmp(mfname,'/trial32.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3)-20;
            
        end
    end
    
    if expcond ==3
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>.2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        idx(3)= find(dist(1:501)==max(dist));
        %
        if strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1)-20;
            
        end
        %
        if strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3);
            
        end
        %
        if strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1)-35-15;
            idx(3) = idx(3) +5;
            
        end
        
        if strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)-10-15;
            idx(3) = idx(3) -20;
        end
        
        if strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3) -25;
        end
        
        
        if strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1)-3-20;
            idx(3) = idx(3)-40+15;
            
        end
        
        
        if strcmp(mfname,'/trial23.mat')
            idx(1) = idx(1)-5-15;
            idx(3) =idx(3)-85+25+45;
            
        end
        
        
        if strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1)-5-20;
            idx(3) =idx(3)-50+35+5;
            
        end
        
        
        if strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)+15-10;
            idx(3) =idx(3)-55+10;
            
        end
        
        
        if strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1)-3-15;
            idx(3) =idx(3)-50;
            
        end
        
    end
    
    if expcond==4
        velthresh = find(vely(1:501)>.02*max(vely(1:501)));
        distthresh = find(dist(velthresh)>.02*max(dist(velthresh)));
        
        idx(1) = velthresh(distthresh(1));
        
        
        indx= find(vel(1:501)>.2*max(vel(1:501)));
        idx(3) = indx(length(indx));
        
        if strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1)+15-25;
            idx(3) =idx(3)+15;
            
        end
        
        if strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1)+15-25;
             idx(3) =idx(3)+15;
            
        end
        
        
        if strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)-3-25;
            % idx(3) =idx(3)-5;
            
        end
        
        
        if strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)-15;
            idx(3) =idx(3)+16;
            
        end
        if strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)-10;
            idx(3) =idx(3)+11;
            
        end
        
        
        if strcmp(mfname,'/trial68.mat')
            idx(1) = idx(1);
            idx(3) =idx(3)-10+16;
            
        end
        
        if strcmp(mfname,'/trial69.mat')
            idx(1) = idx(1)-5;
            idx(3) =idx(3)+10;
            
        end
        
        
        if strcmp(mfname,'/trial70.mat')
            idx(1) = idx(1)-5;
            idx(3) =idx(3)+25+25;
            
        end
        
        
        if strcmp(mfname,'/trial71.mat')
            idx(1) = idx(1);
            idx(3) =idx(3)+10;
            
        end
        
        
        if strcmp(mfname,'/trial72.mat')
            idx(1) = idx(1)-6;
            idx(3) =idx(3)+10;
            
        end
        
        
        if strcmp(mfname,'/trial73.mat')
            % idx(1) = idx(1)-2;
            idx(3) =idx(3)+18;
            idx(1)= idx(1)-5;
            
        end
        
        
        
        if strcmp(mfname,'/trial74.mat')
            idx(1) = idx(1)+65;
            idx(3) =idx(3)+20;
            
        end
        
    end
    
    
    if expcond ==5
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>.2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        idx(3)= find(dist(1:501)==max(dist));
        %
        
        if strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1) - 5;
            idx(3) = idx(3) -15;
            
        end
        
        
        if strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3)-15+5;
            
        end
        
        
        if strcmp(mfname,'/trial65.mat')
            idx(1) = idx(1) -15;
            idx(3) = idx(3) ;
            
        end
        
        if strcmp(mfname,'/trial66.mat')
            idx(3) = idx(3);
            idx(1) = idx(1) - 15;
            
        end
        
        if strcmp(mfname,'/trial67.mat')
            idx(3) = idx(3) - 10;
            idx(1) = idx(1)-10;            
        end
        
        
        if strcmp(mfname,'/trial75.mat')
            idx(1) = idx(1) -15+12;
            idx(3) = idx(3) +30;
            maxdisty= max(xhand(1:idx(3),2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
       
        if strcmp(mfname,'/trial76.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3)-15;
            
        end
                
        
        if strcmp(mfname,'/trial77.mat')
            idx(1) = idx(1) - 35;
            
        end
        
        
        if strcmp(mfname,'/trial78.mat')
            idx(1) = idx(1) -35-10;
            idx(3) = idx(3) -15+10;
            
        end
        
        if strcmp(mfname,'/trial79.mat')       
            idx(1) = idx(1) +50;         
        end
        
        
        if strcmp(mfname,'/trial80.mat')
            idx(3) = idx(3) -15+4;
            idx(1) = idx(1) - 25;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        
        
    end
    
    
    if expcond ==6
        
        zdisp = xhand(:,3)-xhand(1,3);
        indxZDisp =  find(zdisp>.2*max(zdisp));
        idx(1) = indxZDisp(1);
        
        idx(3)= find(dist(1:501)==max(dist));
        
        if strcmp(mfname,'/trial57.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1)-35;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        if strcmp(mfname,'/trial58.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) -35;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        if strcmp(mfname,'/trial59.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) -35;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;  
        end
        
        
        if strcmp(mfname,'/trial60.mat')
            idx(3) = idx(3) -25;
            idx(1) = idx(1) -35;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        
        if strcmp(mfname,'/trial61.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) -5-20;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        if strcmp(mfname,'/trial81.mat')
            idx(3) = idx(3) -15;
            idx(1) = idx(1) -15;
            
        end
        
        if strcmp(mfname,'/trial82.mat')
            idx(3) = idx(3) -35;
            idx(1) = idx(1) -45;
            
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
        end
        
        if strcmp(mfname,'/trial83.mat')
            idx(3) = idx(3) -25;
            idx(1) = idx(1) -5;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        if strcmp(mfname,'/trial84.mat')
            % idx(3) = idx(3) -25;
            idx(1) = idx(1) +70;
            
        end
        
        if strcmp(mfname,'/trial85.mat')
            % idx(3) = idx(3) -25;
            idx(1) = idx(1) -35+10;
            
        end
        
        
        if strcmp(mfname,'/trial86.mat')
            idx(3) = idx(3) -35;
            idx(1) = idx(1) -25;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
    end
    
end



%% RTIS 2007 - Paretic Right
if strcmp(partid,'RTIS2007') && strcmp(hand,'Right')
    
    if expcond==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %
        if   strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-20;
            idx(3) = idx(3) -45+22;
        end
        %
        if   strcmp(mfname,'/trial3.mat')
            idx(3) = idx(3)-15+2+7-8+1+7+1;
            idx(1) = idx(1)-6-6;
        end
        %
        if   strcmp(mfname,'/trial4.mat')
            idx(3) = idx(3)-150+30-6+8;
            idx(1) = idx(1)-10;
        end
        %
        if   strcmp(mfname,'/trial5.mat')
            idx(3) = idx(3)-35-27-10;
            idx(1)= idx(1)-8;
        end
        %
        if   strcmp(mfname,'/trial20.mat')
            idx(3) = idx(3)-75;
            idx(1) = idx(1)-20-15;
        end
        %
        if   strcmp(mfname,'/trial21.mat')
            idx(3) = idx(3)-75;
            idx(1) = idx(1) -15-8;
        end
        %
        if   strcmp(mfname,'/trial22.mat')
            idx(3) = idx(3)-77;
            idx(1) = idx(1) -15;
        end
        %
        if   strcmp(mfname,'/trial23.mat')
            idx(3) = idx(3)-95+10;
            idx(1) = idx(1) +10-20;
        end
        %
        if   strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3)-75+12;
            idx(1) = idx(1) +2-10;
%             maxdisty= max(xhand(:,2));
%             endreach = find(xhand(:,2)==maxdisty);
% 
%            idx(3) = endreach;
        end
    end
    
    if expcond==2
        
        idx(1) = find(dist>=.2*max(dist),1);
        
        if   strcmp(mfname,'/trial8.mat')
            idx(1) = idx(1)+33;
            
            
            %Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+47;
            
        end
        
        if   strcmp(mfname,'/trial10.mat')
            idx(1) = idx(1)+60;
            
            
            %Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act> Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-150;
            
            
        end
        
        
        if   strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1) + 76;
            
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004); %Finding range where Y is postive > y at start - reaching forwards
            
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx;
            idx(3) = idx(3) +49;
        end
        
        
        if   strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1) +50;
            
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004); %Finding range where Y is postive > y at start - reaching forwards
            
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx;
            idx(3) = idx(3)+45 ;
        end
        
        
        if   strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)+245;
            
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004); %Finding range where Y is postive > y at start - reaching forwards
            
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx;
            idx(3) = idx(3)+43;
        end
        
        
        if   strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1) +60;
            
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004); %Finding range where Y is postive > y at start - reaching forwards
            
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx;
            idx(3) = idx(3)-70;
        end
        
        
        
%         figure()
%         plot(t,Zpos_act,'Linewidth',1.5)
%         hold on
%         plot(t,Ypos_act,'Linewidth',1.5)
%         plot(t(rangeYandZ),Ypos_act(rangeYandZ),'ro')
%         plot(t(rangeYandZ),Zpos_act(rangeYandZ),'ro')
%         xline(t(idx(1)),'g','Linewidth',1.5)
%         xline(t(idx(3)),'r','Linewidth',1.5)
%         yline(Ypos_act(idx(1)),'m','Linewidth',1.5)
%         xlabel('Time (s)')
%         ylabel('Position (m)')
%         legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%         title(mfname,'FontSize',24)
        
    end
    
    
    if expcond ==3
        idx(1) = find(dist>=.2*max(dist),1);
        
        if   strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1)+217;
            
            %            Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+49;
            
        end
        %
        %
        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+238;
            
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+65;
        end
        %
        %
        if   strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)+150;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+47;
        end
        %
        %         if   strcmp(mfname,'/trial32.mat')
        %             idx(1) = idx(1)+115;
        %             % Skip becaue was reaching more to side even though Y>Ystart
        % %             %             Using ACT3D Data to see when off table and Y>Ystart
        % %             rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
        % %             maxdistidx = find(dist==max(dist(rangeYandZ)));
        % %             idx(3) = maxdistidx-16;
        %         end
        %
        %
        if   strcmp(mfname,'/trial33.mat')
            idx(1) = idx(1)+75;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+27;
        end
        
        %
        if   strcmp(mfname,'/trial34.mat')
            idx(1) = idx(1)+33+18;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-167;
        end
        
        if   strcmp(mfname,'/trial35.mat')
            idx(1) = idx(1)+53;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
        end
        
        if   strcmp(mfname,'/trial36.mat')
            idx(1) = idx(1)+53;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+50;
        end
        
        
        
%         figure()
%         plot(t,Zpos_act,'Linewidth',1.5)
%         hold on
%         plot(t,Ypos_act,'Linewidth',1.5)
%         plot(t(rangeYandZ),Ypos_act(rangeYandZ),'ro')
%         plot(t(rangeYandZ),Zpos_act(rangeYandZ),'ro')
%         xline(t(idx(1)),'g','Linewidth',1.5)
%         xline(t(idx(3)),'r','Linewidth',1.5)
%         yline(Ypos_act(idx(1)),'m','Linewidth',1.5)
%         xlabel('Time (s)')
%         ylabel('Position (m)')
%         legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%         title(mfname,'FontSize',24)
%         
        
    end
    
    if expcond == 4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial38.mat')
            idx(1) = idx(1)-5;
            idx(3) = idx(3) -150+20;
            
        end
        
        if   strcmp(mfname,'/trial39.mat')
            idx(1) = idx(1)+190-20-15;
            idx(3) = idx(3) -55;
            
        end
        
        if   strcmp(mfname,'/trial40.mat')
            idx(1) = idx(1)+150-25-20;
            idx(3) = idx(3) -15;
            
        end
        
        if   strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)-20;
            idx(3) = idx(3) -55;
            
        end
        
        if   strcmp(mfname,'/trial58.mat')
            %             idx(1) = idx(1)+150;
            idx(3) = idx(3) -85;
            
        end
        
        if   strcmp(mfname,'/trial59.mat')
            idx(1) = idx(1)-20;
            idx(3) = idx(3) -85-23;
            
        end
        
        if   strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)-15;
            idx(3) = idx(3) -50;
            
        end
        
        if   strcmp(mfname,'/trial61.mat')
            idx(1) = idx(1)+50;
            idx(3) = idx(3) -55+14;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
    end
    
    if expcond ==5
        idx(1) = find(dist>=.2*max(dist),1);
        
        
        %
        if   strcmp(mfname,'/trial43.mat')
            idx(1) = idx(1)+74;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+37;
            
        end
        %         %
        if   strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)+110-2+4 ;
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx+68;
        end
        
        if   strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)+198;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +44;
        end
        %         %
        if   strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1)+112;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +35;
        end
        %
        if   strcmp(mfname,'/trial65.mat')
            idx(1) = idx(1)+112+13;
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            
            idx(3) = idx(1)+83;
            
        end
        %
        if   strcmp(mfname,'/trial66.mat')
            idx(1) = idx(1)+151;
            idx(1) = idx(1) +23;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
            idx(3) = idx(1) +80-26;
            
        end
        
        
        
        rangeZ= find(Zpos_act>.00005);
%       
%         figure()
%         plot(t,Zpos_act*1000,'Linewidth',1.5)
%         hold on
%         plot(t,xhand(:,2),'Linewidth',1.5)
%         plot(t(rangeZ),xhand(rangeZ,2),'ro')
% %         plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%         xline(t(idx(1)),'g','Linewidth',1.5)
%         xline(t(idx(3)),'r','Linewidth',1.5)
% %         yline(Ypos_act(idx(1)),'m','Linewidth',1.5)
%         xlabel('Time (s)')
%         ylabel('Position (m)')
%         legend('Zpos','Ypos','Z Range','Z Range','START','STOP','FontSize',14)
%         title(mfname,'FontSize',24)
    end
    
    if expcond ==6
        idx(1) = find(dist>=.2*max(dist),1);
%         rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
        
        if   strcmp(mfname,'/trial47.mat')
%             idx(1) = idx(1)+150;
%             
%             %             Using ACT3D Data to see when off table and Y>Ystart
%             rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
%             maxdistidx = find(dist==max(dist(rangeYandZ)));
%             idx(3) = idx(1) +60-18;
% %             idx(1) = idx(3) +5;
% %             idx(3) = idx(1) +54;
            idx(1) = 458;
            idx(3) = 483;
            
        end
        
        if   strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1)+285+3+12;
         
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
            idx(3) = idx(1) +52-12;
%             
%             idx(1) = idx(1)-200+20;
%             idx(3) = idx(3) -200;
            
        end
        
        if   strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1)+270;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
            idx(3) = idx(1) +20;
            
        end
        
        if   strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1)+50;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            idx(3) = idx(1) +30;
            
        end
        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1)+165;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
            idx(3) = idx(1) +80+9;
            
        end
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)+175;
            
            %             Using ACT3D Data to see when off table and Y>Ystart
            rangeYandZ= find((Ypos_act)>Ypos_act(idx(1)) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = maxdistidx-36;
            idx(3) = idx(1) +53;
            
        end
        
%         rangeZ= find(Zpos_act>.00005);
%         figure()
%         plot(t,Zpos_act*1000,'Linewidth',1.5)
%         hold on
%         plot(t,xhand(:,2),'Linewidth',1.5)
%         plot(t(rangeZ),xhand(rangeZ,2),'ro')
% %         plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%         xline(t(idx(1)),'g','Linewidth',1.5)
%         xline(t(idx(3)),'r','Linewidth',1.5)
% %         yline(Ypos_act(idx(1)),'m','Linewidth',1.5)
%         xlabel('Time (s)')
%         ylabel('Position (m)')
%         legend('Zpos','Ypos','Z Range','Z Range','START','STOP','FontSize',14)
%         title(mfname,'FontSize',24)
%         
    end
    
end

%% RTIS2007 Non-Paretic Left
if strcmp(partid,'RTIS2007') && strcmp(hand,'Left')
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1)-15;
            
        end
        if   strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-15;
            
        end
        if   strcmp(mfname,'/trial3.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1)-15;
        end
        if   strcmp(mfname,'/trial4.mat')
            idx(3) = idx(3)-14;
            idx(1) = idx(1)-15;
            
        end
        
        
        if   strcmp(mfname,'/trial5.mat')
            idx(1) = idx(1)-15;
            
        end
        
               
        if   strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1)-15+7;
            
        end
        if   strcmp(mfname,'/trial7.mat')
            idx(3) = idx(3)-17;
            idx(1) = idx(1)-15;

        end
        
        if   strcmp(mfname,'/trial10.mat')
            idx(3) = idx(3)-6;
            idx(1) = idx(1)-15;
        end
        
        if   strcmp(mfname,'/trial11.mat')
            idx(3) = idx(3)-15+2;
            idx(1) = idx(1)-15;
        end
        
        
        
        if   strcmp(mfname,'/trial12.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1)-15;

        end
        
        
        if   strcmp(mfname,'/trial13.mat')
            idx(3) = idx(3)-20+3;
            idx(1) = idx(1)-15;
            
        end
        
        if   strcmp(mfname,'/trial14.mat')
            idx(3) = idx(3)-20;
            idx(1) = idx(1)-10;
            
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            
            idx(3) = endreach;
        end
        
    end
    
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial15.mat')
            idx(3) = idx(3)-15+7;
            idx(1) = idx(1)-25 ;
            
            maxdisty= max(xhand(:,2));
            endreach = find(xhand(:,2)==maxdisty);
            
            idx(3) = endreach;

            maxdisty= max(xhand(1:idx(3)-20,2));
            endreach = find(xhand(:,2)==maxdisty);
            
            idx(3) = endreach;
            
        end
        
        
        if   strcmp(mfname,'/trial17.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1) +15-6;
            
        end
        
        if   strcmp(mfname,'/trial18.mat')
            idx(3) = idx(3)-20+14;
            idx(1) = idx(1) -20;
        end
        
        
        if   strcmp(mfname,'/trial19.mat')
            idx(3) = idx(3)-45;
            idx(1) = idx(1) -20+1;

        end
        
        if   strcmp(mfname,'/trial30.mat')
            idx(3) = idx(3)-15+10;
            idx(1) = idx(1) +30-15;
        end
        
        if   strcmp(mfname,'/trial31.mat')
            %             idx(3) = idx(3)-15;
            idx(1) = idx(1) +55;
        end
        
        if   strcmp(mfname,'/trial32.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1) +55;
        end
        
        
        if   strcmp(mfname,'/trial33.mat')
            idx(3) = idx(3)-5+1;
            idx(1) = idx(1) +75+5;
        end
        
        
        if   strcmp(mfname,'/trial34.mat')
            idx(3) = idx(3)-112;
            idx(1) = idx(1) +80;
        end
        
        if   strcmp(mfname,'/trial35.mat')
            idx(3) = idx(3)-70;
            idx(1) = idx(1) +95;
        end
        
        if   strcmp(mfname,'/trial36.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1) +10;
        end
    end
    
    if expcond ==3
        
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial20.mat')
%             idx(3) = idx(3)-25;
            idx(1) = idx(1) -30;
        end
                
        if   strcmp(mfname,'/trial21.mat')
%             idx(3) = idx(3)-25;
            idx(1) = idx(1) -20-10;
        end
        


        if   strcmp(mfname,'/trial22.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1) +60;
        end
        
        
        if   strcmp(mfname,'/trial23.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1) -20;
        end
        
        
        if   strcmp(mfname,'/trial24.mat')
            %              idx(3) = idx(3)-15;
            idx(1) = idx(1) +45+25;
        end
        
        
        if   strcmp(mfname,'/trial27.mat')
            idx(3) = idx(3)-45+2;
            idx(1) = idx(1) +45;
        end
        if   strcmp(mfname,'/trial28.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1) +45;
        end
        
        
        if   strcmp(mfname,'/trial29.mat')
            idx(3) = idx(3)-90+9;
            idx(1) = idx(1) +130;
        end
    end
    
    if expcond ==4
        
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial37.mat')
            idx(3) = idx(3)-35;
            idx(1) = idx(1) -25;
            
           maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        
        if   strcmp(mfname,'/trial38.mat')
            idx(3) = idx(3)-50+2;
            idx(1) = idx(1) -20;
        end
        
        if   strcmp(mfname,'/trial39.mat')
            idx(3) = idx(3)-15+11;
            idx(1) = idx(1)-20;
        end


        if   strcmp(mfname,'/trial40.mat')
%             idx(3) = idx(3)-15+11;
            idx(1) = idx(1)-20;
        end
        
        if   strcmp(mfname,'/trial41.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1)-15;
        end
        
        if   strcmp(mfname,'/trial42.mat')
            idx(3) = idx(3)-10;
             idx(1) = idx(1) -20;
     
        end
        
        if   strcmp(mfname,'/trial43.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1) -25;
        end
        
        if   strcmp(mfname,'/trial44.mat')
            idx(3) = idx(3)-10+3;
            idx(1) = idx(1) -20;
        end
        
        if   strcmp(mfname,'/trial45.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1) -20;
        end
        
        if   strcmp(mfname,'/trial46.mat')
            idx(3) = idx(3)-10;
            idx(1) = idx(1) -25-20;
        end
        
        if   strcmp(mfname,'/trial47.mat')
            idx(3) = idx(3)-16;
            idx(1) = idx(1) -25;
        end
    end
    
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial48.mat')
            idx(3) = idx(3)-20+5;
            idx(1) = idx(1) +70;
        end
        
        
        if   strcmp(mfname,'/trial49.mat')
            idx(3) = idx(3)-20+6;
            idx(1) = idx(1) +40;
        end
        
        if   strcmp(mfname,'/trial50.mat')
            idx(3) = idx(3)-20;
            idx(1) = idx(1) +60;
        end
        
        if   strcmp(mfname,'/trial51.mat')
            idx(3) = idx(3)-45;
           idx(1) = idx(1) -12;

            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach-9;
            
        end
        
        if   strcmp(mfname,'/trial52.mat')
            idx(3) = idx(3)-5;
           idx(1) = idx(1) -20;
        end
        
        if   strcmp(mfname,'/trial64.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1) +130;
            
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach;
            
        end
        
        if   strcmp(mfname,'/trial65.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1) +65-15;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);

           idx(3) = endreach-16;
            
        end
        
        if   strcmp(mfname,'/trial66.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1)-15;
        end
        
        
        if   strcmp(mfname,'/trial67.mat')
            idx(3) = idx(3)-25;
            %              idx(1) = idx(1) +25;
        end


        
        if   strcmp(mfname,'/trial68.mat')
%             idx(3) = idx(3)-25;
                  idx(1) = idx(1) -15;
        end
    end
    
    if expcond ==6
        
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1)+65-5;
            idx(3) = idx(3) -10;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach;
        end
        
        
        if   strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)+60;
            idx(3) = idx(3) -10;
        end
        
        
        if   strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)+105;
            idx(3) = idx(3) -5;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach-5;
        end
        
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)+45;
            idx(3) = idx(3) -20;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach;
        end
        
        if   strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)+90-6;
            idx(3) = idx(3) -20;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach;
        end
        
        if   strcmp(mfname,'/trial58.mat')
            idx(1) = idx(1)+80;
            idx(3) = idx(3) -15;
        end
        
        if   strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)+100;
            idx(3) = idx(3) -20-4-2;
        end
        
        if   strcmp(mfname,'/trial61.mat')
            idx(1) = idx(1)+65+16;
            idx(3) = idx(3) -15;
        end
        
        if   strcmp(mfname,'/trial62.mat')
            idx(1) = idx(1)+190;
            idx(3) = idx(3) -30;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3) = endreach-25;
        end
        
        if   strcmp(mfname,'/trial63.mat')
            idx(1) = idx(1)+90-15;
            idx(3) = idx(3) -25;
        end
    end
    
end




%% RTIS 2008 Paretic
if strcmp(partid,'RTIS2008') && strcmp(hand,'Right')
    %  idx(1) = find(dist>=.02*max(dist),1);
    
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %
        
        if   strcmp(mfname,'/trial1.mat')
            idx(3) =idx(3) -80;
            idx(1)=idx(1)-15;
        end
        %
        if   strcmp(mfname,'/trial2.mat')
            idx(3) =idx(3) -95+20;
             idx(1)=idx(1)-20;
        end
        
        %
        if   strcmp(mfname,'/trial5.mat')
            idx(3) =idx(3) -80;
            idx(1)=idx(1)-20;
        end
        
        %
        if   strcmp(mfname,'/trial6.mat')
            idx(3) =idx(3) -28;
            idx(1)=idx(1)-20;
        end
        
        if   strcmp(mfname,'/trial10.mat')
%             idx(3) =idx(3) -28;
            idx(1)=idx(1)-10-5;
        end
        
        %
        if   strcmp(mfname,'/trial9.mat')
            idx(3) =idx(3) -50;
            idx(1)=idx(1)-5;

        end
        
        if   strcmp(mfname,'/trial8.mat')
            %idx(3) =idx(3) -50;
            idx(1)=idx(1)-9;

        end
        
    end
    
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %
        
        if   strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)+45;
            idx(3) = idx(3)-55;
            
        end
        
        if   strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1)+70;
            idx(3) = idx(3)-35;
            
        end
        
        
        if   strcmp(mfname,'/trial27.mat')
            idx(1) = idx(1)+70-10;
            idx(3) = idx(3)-20;
            
        end
        
        
        if   strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)+45;
            idx(3) = idx(3)-15-8;
            
        end
        
        if   strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1)+50;
            idx(3) = idx(3)-28;
            
        end
        
    end
    
    if expcond ==3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)+75-25;
            idx(3) = idx(3) -35;
        end
        %
        %
        if   strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)+135;
            idx(3) = idx(3) -15;
        end
        
        %
        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+175;
            idx(3) = idx(3) -15;
        end
        
        if   strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1)+140-20;
            idx(3) = idx(3) -40;
        end
        
        if   strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)+165+6;
            idx(3) = idx(3) -35;
            
        end
        
        if   strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)+115;
            idx(3) = idx(3) -40;
            
        end
        
        
    end
    
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial40.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1)-10;
            
        end
        %
        %
        if   strcmp(mfname,'/trial41.mat')
             idx(1) = idx(1)-15+2;
            idx(3) = idx(3)- 25;
        end
        %
        %
        if   strcmp(mfname,'/trial42.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1)-25;
            
        end
        
        %
        if   strcmp(mfname,'/trial43.mat')
            idx(3) = idx(3)-110-25-15;
            idx(1) = idx(1)-25;
            
        end
        %
        if   strcmp(mfname,'/trial44.mat')
            idx(3) = idx(3)-400;
            idx(1) = idx(1)-25;
            
        end
        
        %
        if   strcmp(mfname,'/trial45.mat')
            idx(3) = idx(3)-80-30;
            idx(1) = idx(1)-25;
            
        end
        
    end
    
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %

        if   strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1)-20;
%             idx(3) = idx(3)-15;
            
        end
        if   strcmp(mfname,'/trial32.mat')
            idx(1) = idx(1)+5;
            idx(3) = idx(3)-15+2;
            
        end
        
        %
        if   strcmp(mfname,'/trial33.mat')
            idx(3) = idx(3)-40;
            idx(1) = idx(1) +15;
        end
        %
        if   strcmp(mfname,'/trial34.mat')
            %idx(3) = idx(3)-15;
            idx(1) = idx(1) +15;
        end
    end
    
    if expcond ==6
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial35.mat')
            idx(3) = idx(3)-200;
            idx(1) = idx(1) -25;
        end
        
        
        if   strcmp(mfname,'/trial36.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1) +45;
           maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3)=endreach;
        end
        
        if   strcmp(mfname,'/trial37.mat')
            idx(3) = idx(3)-45-15+25;
            %idx(1) = idx(1) +45;
            
        end
        
        if   strcmp(mfname,'/trial38.mat')
            idx(3) = idx(3)-145;
            idx(1) = idx(1) +5;
            
        end
        
        
        if   strcmp(mfname,'/trial39.mat')
            idx(3) = idx(3)-135+10;
            idx(1) = idx(1) +60-15;
            
        end
    end
end

%% RTIS 2008 Non-Paretic
if strcmp(partid,'RTIS2008') && strcmp(hand,'Left')
    
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        

        
        if   strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1)-10;
            
        end


        
        if   strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-10;
            
        end

        
        if   strcmp(mfname,'/trial3.mat')
            idx(1) = idx(1)-10;
            
        end
        if   strcmp(mfname,'/trial4.mat')
            idx(3) = idx(3)-5;
            idx(1) = idx(1)-10;
            
        end

        if   strcmp(mfname,'/trial5.mat')
            idx(1) = idx(1)-10;
            
        end
        
        if   strcmp(mfname,'/trial6.mat')
            idx(3) = idx(3)-1;
            idx(1) = idx(1)-10;
            
        end
        
        if   strcmp(mfname,'/trial7.mat')
            idx(3) = idx(3);
            idx(1) = idx(1)-10;

        end


        if   strcmp(mfname,'/trial8.mat')
%             idx(3) = idx(3);
            idx(1) = idx(1)-10;

        end
        

        if   strcmp(mfname,'/trial9.mat')
%             idx(3) = idx(3);
            idx(1) = idx(1)-10;
        end
        

        if   strcmp(mfname,'/trial10.mat')
%             idx(3) = idx(3);
            idx(1) = idx(1)-10;
        end
    end
    
    
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial11.mat')
            idx(3) = idx(3)-29;
            
        end
        
        
        if   strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1)+45;
            
        end
        
        if   strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1)+10;
            idx(3) = idx(3)-51;
            
        end
        
        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+25;
            %             idx(3) = idx(3)-30;
            
        end
        
        if   strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1)+10;
            %             idx(3) = idx(3)-30;
            
        end
        
        if   strcmp(mfname,'/trial18.mat')
            idx(1) = idx(1)+20;
            %             idx(3) = idx(3)-30;
            
        end
        if   strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1)-12;
            %             idx(3) = idx(3)-30;
            
        end
        if   strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)+20;
            %             idx(3) = idx(3)-30;
            
        end
        
        if   strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3)-6;
            
        end
    end
    
    if expcond == 3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        
        if   strcmp(mfname,'/trial22.mat')
            idx(3) = idx(3)-13;
            
        end
        
        if   strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1)-25;
        end
                
        if   strcmp(mfname,'/trial25.mat')
%             idx(3) = idx(3)-15;
            idx(1) = idx(1)-10;
        end
                        
        if   strcmp(mfname,'/trial26.mat')
%             idx(3) = idx(3)-15;
            idx(1) = idx(1)-5;
        end

        if   strcmp(mfname,'/trial29.mat')
            idx(1) = (idx(1)+9)-15+7+8;
            idx(3) = idx(3) -15;
            
        end
        
        
        if   strcmp(mfname,'/trial31.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1)-5;

            
        end
    end
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial32.mat')
            idx(3) = idx(3)-4;
            idx(1) = idx(1)-15;
            
        end
        
                
        if   strcmp(mfname,'/trial33.mat')
%             idx(3) = idx(3)-4;
            idx(1) = idx(1)-15;
            
        end

        if   strcmp(mfname,'/trial34.mat')
            idx(3) = idx(3)-5;
            idx(1) = idx(1)-15;
        end
        
        if   strcmp(mfname,'/trial35.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-5;
        end

        if   strcmp(mfname,'/trial36.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-5;
        end

        if   strcmp(mfname,'/trial58.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-10;
        end

        if   strcmp(mfname,'/trial59.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-10;
        end

        if   strcmp(mfname,'/trial60.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-10;
        end

        if   strcmp(mfname,'/trial61.mat')
%             idx(3) = idx(3)-5;
            idx(1) = idx(1)-10+6;
        end

        if   strcmp(mfname,'/trial62.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1)-10;

            
        end
        
    end
    
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        
        if   strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)+35;
            
        end
        
        
        if   strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1)+10;
            
        end
        
        
        
        if   strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1)+20;
            idx(3) = idx(3) -15;
        end
        
        if   strcmp(mfname,'/trial50.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3) -10;
        end
        
        
        if   strcmp(mfname,'/trial51.mat')
            %             idx(1) = idx(1)+15;
            idx(3) = idx(3) -10;
        end
        
        if   strcmp(mfname,'/trial52.mat')
            %             idx(1) = idx(1)+15;
            idx(1) = idx(1) +20;
        end

        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3) -10;
        end
        
        if   strcmp(mfname,'/trial54.mat')
            %              idx(1) = idx(1)+15;
            idx(3) = idx(3) -7;
        end
        
        if   strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)+41;
            idx(3) = idx(3) -10;
        end
    end
    

    
    if expcond ==6
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
            
        if   strcmp(mfname,'/trial40.mat')
            idx(1) = idx(1)+25;
%             idx(3) = idx(3) -10;
        end
    
        if   strcmp(mfname,'/trial42.mat')
            idx(1) = idx(1)+20;
%             idx(3) = idx(3) -10;
        end
    
        
        if   strcmp(mfname,'/trial43.mat')
            idx(1) = idx(1)+20;
%             idx(3) = idx(3) -10;
        end
            
        if   strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)+20;
            idx(3) = idx(3) -29;
        end
    
                
        if   strcmp(mfname,'/trial45.mat')
            idx(1) = idx(1)+25;
%             idx(3) = idx(3) -10;
        end
    
    
                    
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)+10;
%             idx(3) = idx(3) -10;
        end
    
                        
        if   strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1)+20;
%             idx(3) = idx(3) -10;
        end
    
    
    
    end
    
%     rangeZ= find(Zpos_act>.00005);
%     figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
%     
%     
end


%% RTIS 2009 - paretic
if strcmp(partid,'RTIS2009') && strcmp(hand,'Left')
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        if   strcmp(mfname,'/trial1.mat')
            idx(3) = idx(3)-8;
            idx(1) = idx(1)-8;

        end
%         
        if   strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1)-10;
        end
        
        if   strcmp(mfname,'/trial4.mat')
            idx(1) = idx(1)-5;
        end
                     
        if   strcmp(mfname,'/trial5.mat')
            idx(1) = idx(1)-10;
        end  

        if   strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1)-10;
        end 

        if   strcmp(mfname,'/trial7.mat')
            idx(3) = idx(3)-6;
        end
                        
        if   strcmp(mfname,'/trial9.mat')
            idx(1) = idx(1)-5;
        end
                                      
        if   strcmp(mfname,'/trial8.mat')
            idx(1) = idx(1)-15;
        end

        if   strcmp(mfname,'/trial10.mat')
            idx(3) = idx(3)-13;
            idx(1) = idx(1)-15;
        end
    end
    
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
%         
        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1)+62;
            idx(3) = idx(3)-105;
        end
        
        %         
        if   strcmp(mfname,'/trial17.mat')
            idx(1) = idx(1)+62;
            idx(3) = idx(3)-205;
        end
        %         
        if   strcmp(mfname,'/trial19.mat')
            idx(1) = idx(1)+77;
            idx(3) = idx(3)-145;
        end
                %         
        if   strcmp(mfname,'/trial20.mat')
            idx(1) = idx(1)+120;
            idx(3) = idx(3)-263;
        end
                        %         
        if   strcmp(mfname,'/trial26.mat')
            idx(1) = idx(1)+50-10;
            idx(3) = idx(3)-203;
        end
                                %         
        if   strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1)+50-8;
            idx(3) = idx(3)-55+6;
        end
                                        %         
        if   strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1)+35-20+16;
            idx(3) = idx(3)-30;
        end
                                        %         
        if   strcmp(mfname,'/trial31.mat')
            idx(1) = idx(1)+35-20;
            idx(3) = idx(3)-25+3;
        end
    end
    
    if expcond ==3 
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                                %         
        if   strcmp(mfname,'/trial11.mat')
            idx(1) = idx(1)+210;
            idx(3) = idx(3)-10;
        end
                                                        %         
        if   strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1)+25+20;
            idx(3) = idx(3)-10;
            maxdisty= max(xhand(:,2));
           endreach = find(xhand(:,2)==maxdisty);
           idx(3)=endreach;
        end
                                                                %         
        if   strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1);
            idx(3) = idx(3)-275;
        end
                                                                        %         
        if   strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1)+70;
            idx(3) = idx(3)-230;
        end
                                                                                %         
        if   strcmp(mfname,'/trial21.mat')
            idx(1) = idx(1)+105;
            idx(3) = idx(3)-150;
        end
                                                                                        %         
        if   strcmp(mfname,'/trial22.mat')
            idx(1) = idx(1)+85;
            idx(3) = idx(3)-185;
        end
                                                                                                         
        if   strcmp(mfname,'/trial23.mat')
            idx(1) = idx(1)+10;
            idx(3) = idx(3)-55;
        end
                                                                                                                 
        if   strcmp(mfname,'/trial24.mat')
            idx(1) = idx(1)+175;
            idx(3) = idx(3)-185;
        end
                                                                                                                         
        if   strcmp(mfname,'/trial25.mat')
            idx(1) = idx(1)+100;
            idx(3) = idx(3)-235;
        end
                                                                                                                                
 
    end
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
%         
        if   strcmp(mfname,'/trial34.mat')
            idx(3) = idx(3)-15;
        end
%         
        if   strcmp(mfname,'/trial36.mat')
            idx(3) = idx(3)-15;
        end
%       
%         
        if   strcmp(mfname,'/trial37.mat')
            idx(3) = idx(3)-20;
        end
%         %         
        if   strcmp(mfname,'/trial39.mat')
            idx(3) = idx(3)-10;
        end
        %         %         
        if   strcmp(mfname,'/trial40.mat')
            idx(3) = idx(3)-5;
        end
    end
    
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
               
        if   strcmp(mfname,'/trial42.mat')
            idx(1) = idx(1)+55;
            idx(3) = idx(3) -15;
        end
         
                       
        if   strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)+20;
            idx(3) = idx(3) -15;
        end
  
                       
        if   strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)+25;
%             idx(3) = idx(3) -15;
        end
                               
        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1)+25;
%             idx(3) = idx(3) -15;
        end
                                       
        if   strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1)+30;
%             idx(3) = idx(3) -15;
        end
        
        if   strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1)+80;
            idx(3) = idx(3) -35;
        end
    end 
    
    if expcond ==6
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        if   strcmp(mfname,'/trial47.mat')
            idx(1) = idx(1)+15;
            idx(3) = idx(3)-10;
        end
%                 
        if   strcmp(mfname,'/trial48.mat')
%             idx(1) = idx(1)+15;
            idx(3) = idx(3)-25;
        end
%         
        if   strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1)+90;
            idx(3) = idx(3)-20;
        end
%         
        if   strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1)+25;
        end
%         
        if   strcmp(mfname,'/trial57.mat')
            idx(3) = idx(3)-15;
        end
        %         
        if   strcmp(mfname,'/trial58.mat')
            idx(3) = idx(3)-15;
            idx(1) = idx(1)+25;
        end
                %         
        if   strcmp(mfname,'/trial59.mat')
%             idx(3) = idx(3)-15;
            idx(1) = idx(1)+15;
        end
    end
%     
    rangeZ= find(Zpos_act>.00005);
%     figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
% %     
    
end



%% RTIS2009 - Non Paretic

if strcmp(partid,'RTIS2009') && strcmp(hand,'Right')
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial1.mat')
            idx(3) = idx(3)-25;
            idx(1) = idx(1)+5;
        end
        
                
        if   strcmp(mfname,'/trial2.mat')
            idx(3) = idx(3)-60;
          %  idx(1) = idx(1)+5;
        end
                        
        if   strcmp(mfname,'/trial3.mat')
            idx(3) = idx(3)-10;
          %  idx(1) = idx(1)+5;
        end
        
    end
    
    
    if expcond ==2 
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);

                                
        if   strcmp(mfname,'/trial15.mat')
            idx(3) = idx(3)-35;
            idx(1) = idx(1)+35;
        end
                                        
        if   strcmp(mfname,'/trial16.mat')
            idx(3) = idx(3)-45;
            idx(1) = idx(1)+75;
        end
        
                                                
        if   strcmp(mfname,'/trial17.mat')
            idx(3) = idx(3)-55;
            idx(1) = idx(1)+55;
        end
        
                                                        
        if   strcmp(mfname,'/trial18.mat')
            idx(3) = idx(3)-45;
%             idx(1) = idx(1)+55;
        end
                                                                
        if   strcmp(mfname,'/trial19.mat')
            idx(3) = idx(3)-4;
%             idx(1) = idx(1)+55;
      
        end
                                                                        
        if   strcmp(mfname,'/trial21.mat')
            idx(3) = idx(3)-5;
            idx(1) = idx(1)+35;
      
        end
        
                                                                                
        if   strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3)-15;
%             idx(1) = idx(1)+35;
      
        end
    end
    
    if expcond ==3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        
        
        if   strcmp(mfname,'/trial26.mat')
            idx(3) = idx(3)-55;
            idx(1) = idx(1)+5;
            
        end
                
        if   strcmp(mfname,'/trial28.mat')
            idx(3) = idx(3)-1;
%             idx(1) = idx(1)+5;
            
        end
                        
        if   strcmp(mfname,'/trial29.mat')
            idx(3) = idx(3)-15;
%             idx(1) = idx(1)+5;
            
        end
        
                                
        if   strcmp(mfname,'/trial30.mat')
            idx(3) = idx(3)-20;
            idx(1) = idx(1)+40;
            
        end
                                        
        if   strcmp(mfname,'/trial31.mat')
%             idx(3) = idx(3)-20;
            idx(1) = idx(1)+35;
            
        end
        
                                                
        if   strcmp(mfname,'/trial35.mat')
             idx(3) = idx(3)-16;
            idx(1) = idx(1)+60;
            
        end
    end
    
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                                        
        if   strcmp(mfname,'/trial36.mat')
             idx(3) = idx(3)-35;
        end
                                                              
        if   strcmp(mfname,'/trial37.mat')
             idx(3) = idx(3)-35;
        end
        
                                                                        
        if   strcmp(mfname,'/trial39.mat')
             idx(3) = idx(3)-35;
            
        end
                                                                                
        if   strcmp(mfname,'/trial40.mat')
             idx(3) = idx(3)-35;
            
        end
                                                                                        
        if   strcmp(mfname,'/trial42.mat')
             idx(3) = idx(3)-15;
            
        end
                                                                                                
        if   strcmp(mfname,'/trial58.mat')
             idx(3) = idx(3)-5;
            
        end
    end
    
    
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                                                                                        
        if   strcmp(mfname,'/trial41.mat')
             idx(3) = idx(3)-65;
            
        end
                                                                                                                
        if   strcmp(mfname,'/trial43.mat')
             idx(3) = idx(3)-15;
            
        end
                                                                                                                        
        if   strcmp(mfname,'/trial44.mat')
             idx(3) = idx(3)-80;
            
        end
                                                                                                                                
        if   strcmp(mfname,'/trial45.mat')
             idx(3) = idx(3)-4;
            
        end
                                                                                                                                        
        if   strcmp(mfname,'/trial46.mat')
             idx(3) = idx(3)-10;
            
        end
                                                                                                                                                
        if   strcmp(mfname,'/trial52.mat')
             idx(3) = idx(3)-85-8;
            
        end
                                                                                                                                                        
        if   strcmp(mfname,'/trial53.mat')
             idx(3) = idx(3)-105;
            
        end
                                                                                                                                                                
        if   strcmp(mfname,'/trial54.mat')
             idx(3) = idx(3)-100;
            
        end
    end
    
    if expcond ==6
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                                                                                                                                                        
        if   strcmp(mfname,'/trial47.mat')
             idx(3) = idx(3)-55;
             idx(1) = idx(1)+6;

        end
        
                                                                                                                                                                                
        if   strcmp(mfname,'/trial48.mat')
             idx(3) = idx(3)-35;
             idx(1) = idx(1)+20;

        end
                                                                                                                                                                                        
        if   strcmp(mfname,'/trial49.mat')
             idx(3) = idx(3)-55;
%              idx(1) = idx(1)+20;

        end
                                                                                                                                                                                                
        if   strcmp(mfname,'/trial51.mat')
             idx(3) = idx(3)-50;
%              idx(1) = idx(1)+20;

        end
                                                                                                                                                                                                        
        if   strcmp(mfname,'/trial63.mat')
             idx(3) = idx(3)-50;
%              idx(1) = idx(1)+20;

        end
        
                                                                                                                                                                                                                
        if   strcmp(mfname,'/trial64.mat')
             idx(3) = idx(3)-73;
%              idx(1) = idx(1)+20;

        end
        
    end
    
    rangeZ= find(Zpos_act>.00005);
%     figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
%     
    
end

%% RTIS 2010 - paretic
if strcmp(partid,'RTIS2010') && strcmp(hand,'Right')
        
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial43.mat')
            idx(3) = idx(3)-1;
        end
%         
%         
        if   strcmp(mfname,'/trial46.mat')
            idx(3) = idx(3)-15;
        end
%         
%         
%         if   strcmp(mfname,'/trial48.mat')
%             idx(1) = idx(1)-3;
%         end
%         
%         if   strcmp(mfname,'/trial49.mat')
%             idx(1) = idx(1)-3;
%         end
%         
%         
%         if   strcmp(mfname,'/trial50.mat')
%             idx(1) = idx(1)-3;
%         end
        
        
    end
    
    
    if expcond ==2
                max_dist = max(dist);
                end_reach = find(dist==max_dist);
                idx(3) = end_reach;
               
                zdisp = xhand(:,3)-xhand(1,3);
                velyint= find(vely>0);
                Zint = find(zdisp >= .2*max(zdisp));
                Vely_Z_INT = intersect(velyint,Zint);
                
                idx(1) = Vely_Z_INT(1);
%         zdisp = xhand(:,3)-xhand(1,3);
%         indxZDisp =  find(zdisp>= .2*max(zdisp));
%         idx(1) = indxZDisp(1);
%         %
%         end_reach = find(vel(1:501)>=.05*max(vel(1:501)));
%         idx(3) = end_reach(length(end_reach))-70;
        
        %
        if   strcmp(mfname,'/trial35.mat')
            idx(1) = idx(1)+11;
        end
        %
        if   strcmp(mfname,'/trial36.mat')
            idx(1) = idx(1)+34;
        end
        
                %
        if   strcmp(mfname,'/trial37.mat')
            idx(1) = idx(1)+27;
        end
                        %
        if   strcmp(mfname,'/trial38.mat')
            idx(1) = idx(1)+6;
            idx(3) = idx(3) -24;
        end
        
                                %
        if   strcmp(mfname,'/trial51.mat')
            idx(3) = idx(3)+80;
            idx(1) = idx(1) +18;
        end
        
                                %
        if   strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1)+6;
        end
               
                                %
        if   strcmp(mfname,'/trial54.mat')
            idx(3) = idx(3)-14;
          
            idx(1) = idx(1)+20;
        end
                       
                                %
        if   strcmp(mfname,'/trial55.mat')
%             idx(3) = idx(3)-14;
            idx(1) = idx(1)+20;
        end
        
    end
    
    if expcond ==3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        
        zdisp = xhand(:,3)-xhand(1,3);
        velyint= find(vely>0);
        Zint = find(zdisp >= .2*max(zdisp));
        Vely_Z_INT = intersect(velyint,Zint);
        
        idx(1) = Vely_Z_INT(1);
                
        if   strcmp(mfname,'/trial24.mat')
            idx(3) = idx(3) +75;
            idx(1) = idx(1) +15;
        end
                        
        if   strcmp(mfname,'/trial25.mat')
%             idx(3) = idx(3) +75;
            idx(1) = idx(1) +35;
        end
                                
        if   strcmp(mfname,'/trial26.mat')
%             idx(3) = idx(3) +75;
            idx(1) = idx(1) +12;
        end
                                        
        if   strcmp(mfname,'/trial28.mat')
%             idx(3) = idx(3) +75;
            idx(1) = idx(1) +10;
        end
                                                
        if   strcmp(mfname,'/trial29.mat')
%             idx(3) = idx(3) +75;
            idx(1) = idx(1) +17;
        end
                                                        
        if   strcmp(mfname,'/trial30.mat')
             idx(3) = idx(3) -11;
            idx(1) = idx(1) +3;
        end
                                                                
        if   strcmp(mfname,'/trial33.mat')
%             idx(3) = idx(3) +75;
            idx(1) = idx(1) +12;
        end
    end
    
    
    if expcond ==4

        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
                                                                        
        if   strcmp(mfname,'/trial66.mat')
             idx(3) = idx(3) -1;
%             idx(1) = idx(1) +12;
        end
        
        
    end
    
    if expcond==5
        
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        
        zdisp = xhand(:,3)-xhand(1,3);
        velyint= find(vely>0);
        Zint = find(zdisp >= .2*max(zdisp));
        Vely_Z_INT = intersect(velyint,Zint);
           
        idx(1) = Vely_Z_INT(1);
        
        rangeZ= find(Zpos_act>.00005);
        
        if   strcmp(mfname,'/trial67.mat')
            idx(1) = idx(1) +15;
            idx(3) = rangeZ(end)+7;
        end
                
        if   strcmp(mfname,'/trial68.mat')
            idx(1) = idx(1) +1;
            idx(3) = rangeZ(end)+1;
        end
                        
        if   strcmp(mfname,'/trial69.mat')
             idx(1) = idx(1) +18;
            idx(3) = rangeZ(end)-22;
        end
                                
        if   strcmp(mfname,'/trial70.mat')
             idx(1) = idx(1) +15;
            idx(3) = rangeZ(end)-22;
        end
                                        
        if   strcmp(mfname,'/trial71.mat')
            idx(1) = idx(1) +6;
            idx(3) = rangeZ(end)-44;
        end
                                                
        if   strcmp(mfname,'/trial72.mat')
             idx(1) = idx(1) +13;
            idx(3) = rangeZ(end)-8;
        end
                                                        
        if   strcmp(mfname,'/trial73.mat')
             idx(1) = idx(1) +10;
            idx(3) = rangeZ(end);
        end
                                                                
        if   strcmp(mfname,'/trial74.mat')
             idx(1) = idx(1) +16;
            idx(3) = rangeZ(end);
        end
    end
    
    if expcond==6
        

        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
%         idx(1) = find(dist>=.05*max(dist),1);
        
        zdisp = xhand(:,3)-xhand(1,3);
        velyint= find(vely>0);
        Zint = find(zdisp >= .2*max(zdisp));
        Vely_Z_INT = intersect(velyint,Zint);
        
        idx(1) = Vely_Z_INT(1);
        
        rangeZ= find(Zpos_act>.00005);
        
        if   strcmp(mfname,'/trial78.mat')
            idx(1) = idx(1) +15;
        end
%         
        if   strcmp(mfname,'/trial79.mat')
            idx(1) = idx(1) +15;
        end
%         
        if   strcmp(mfname,'/trial80.mat')
            idx(3) = idx(3) -6;
        end
%         
        if   strcmp(mfname,'/trial81.mat')
            idx(1) = idx(1) +7;
        end
        %         
        if   strcmp(mfname,'/trial82.mat')
            idx(1) = idx(1) +15;
        end
                %         
        if   strcmp(mfname,'/trial83.mat')
            idx(1) = idx(1) +5;
            idx(3) = idx(3) -6;
        end
                        %         
        if   strcmp(mfname,'/trial84.mat')
%             idx(1) = idx(1) +5;
            idx(3) = idx(3) -18;
        end
        
                                %         
        if   strcmp(mfname,'/trial85.mat')
             idx(1) = idx(1) +2;
            idx(3) = idx(3) -12;
        end
                                        %         
        if   strcmp(mfname,'/trial86.mat')
             idx(1) = idx(1) +6;
            idx(3) = idx(3) -12;
        end
    end
    rangeZ= find(Zpos_act>.00005);
% 
%         figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
%     
    
    
end

%% RTIS 2010 Non Paretic - Left

if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
    
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        %
        if   strcmp(mfname,'/trial1.mat')
            idx(1) = idx(1) -10;
            idx(3) = idx(3) -20;
        end
        %
        if   strcmp(mfname,'/trial2.mat')
            idx(1) = idx(1) -10;
            %             idx(3) = idx(3) -20;
        end
                %
        if   strcmp(mfname,'/trial3.mat')
            idx(1) = idx(1) -9;
            idx(3) = idx(3) -9;
        end
                        %
        if   strcmp(mfname,'/trial4.mat')
%             idx(1) = idx(1) -10;
            idx(3) = idx(3) -5;
        end
                                %
        if   strcmp(mfname,'/trial9.mat')
%             idx(1) = idx(1) -10;
            idx(3) = idx(3) -9;
        end
                                        %
        if   strcmp(mfname,'/trial10.mat')
%             idx(1) = idx(1) -10;
            idx(3) = idx(3) -11;
        end
    end
    
    
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                        %
        if   strcmp(mfname,'/trial11.mat')
             idx(1) = idx(1) +25;
%             idx(3) = idx(3) -11;
        end
                                                
        if   strcmp(mfname,'/trial12.mat')
             idx(1) = idx(1) +10;
%             idx(3) = idx(3) -11;
        end
                                                        
        if   strcmp(mfname,'/trial13.mat')
             idx(1) = idx(1) +15+22;
%             idx(3) = idx(3) -11;
        end
                                                                
        if   strcmp(mfname,'/trial14.mat')
             idx(1) = idx(1) +25;
%             idx(3) = idx(3) -11;
        end
                                                                        
        if   strcmp(mfname,'/trial15.mat')
             idx(1) = idx(1) +43;
%             idx(3) = idx(3) -11;
        end
        
        if   strcmp(mfname,'/trial27.mat')
             idx(1) = idx(1) +40;
%             idx(3) = idx(3) -11;
        end
                                                                                      
        if   strcmp(mfname,'/trial28.mat')
             idx(1) = idx(1) +68;
%             idx(3) = idx(3) -11;
        end
    end
    
    if expcond ==3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);  
                                                                                              
        if   strcmp(mfname,'/trial17.mat')
             idx(1) = idx(1) +35;
%             idx(3) = idx(3) -11;
        end
                                                                                                      
        if   strcmp(mfname,'/trial18.mat')
             idx(1) = idx(1) +52;
%             idx(3) = idx(3) -11;
        end
                                                                                                              
        if   strcmp(mfname,'/trial19.mat')
             idx(1) = idx(1) +37;
%             idx(3) = idx(3) -11;
        end
        
                                                                                                                      
        if   strcmp(mfname,'/trial20.mat')
             idx(1) = idx(1) +35;
             idx(3) = idx(3) -5;
        end
                                                                                                                              
        if   strcmp(mfname,'/trial21.mat')
             idx(1) = idx(1) +35;
%             idx(3) = idx(3) -11;
        end
                                                                                                                              
        if   strcmp(mfname,'/trial22.mat')
             idx(1) = idx(1) +35+12;
%              idx(3) = idx(3) -10;
        end
                                                                                                                              
        if   strcmp(mfname,'/trial23.mat')
             idx(1) = idx(1) +35-9;
             idx(3) = idx(3) -10;
        end
                                                                                                                              
        if   strcmp(mfname,'/trial24.mat')
             idx(1) = idx(1) +35;
%             idx(3) = idx(3) -11;
        end
                                                                                                                              
        if   strcmp(mfname,'/trial25.mat')
             idx(1) = idx(1) +29;
             idx(3) = idx(3) -6;
        end
    end
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
                                                                                                                                     
        if   strcmp(mfname,'/trial32.mat')
             idx(1) = idx(1) -10;
             idx(3) = idx(3) -6;
        end                                        
                                                                                                                                             
        if   strcmp(mfname,'/trial35.mat')
%              idx(1) = idx(1) -10;
             idx(3) = idx(3) -8;
        end    
                                                                                                                                                     
        if   strcmp(mfname,'/trial36.mat')
%              idx(1) = idx(1) -10;
             idx(3) = idx(3) -4;
        end 
                                                                                                                                                             
        if   strcmp(mfname,'/trial40.mat')
              idx(1) = idx(1) -10;
             idx(3) = idx(3) -15;
        end  
    end
        
    if expcond ==5
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +55;
                                                                                                                                                                     
        if   strcmp(mfname,'/trial45.mat')
              idx(1) = idx(1) -10;
              idx(3) = idx(3) -1;
        end  
                                                                                                                                                                             
        if   strcmp(mfname,'/trial46.mat')
              idx(1) = idx(1) -20;
%               idx(3) = idx(3) -1;
        end  
                                                                                                                                                                             
        if   strcmp(mfname,'/trial57.mat')
              idx(1) = idx(1) -10;
%               idx(3) = idx(3) -1;
        end  
                                                                                                                                                                                     
        if   strcmp(mfname,'/trial58.mat')
              idx(1) = idx(1) -5;
%               idx(3) = idx(3) -1;
        end  
                                                                                                                                                                                             
        if   strcmp(mfname,'/trial59.mat')
              idx(3) = idx(3) -4;
%               idx(3) = idx(3) -1;
        end
                                                                                                                                                                                                     
        if   strcmp(mfname,'/trial61.mat')
              idx(1) = idx(1) -20;
               idx(3) = idx(3) -15;
        end  
    end
    
    if expcond ==6
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +55;
                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial47.mat')
              idx(1) = idx(1) -15;
               idx(3) = idx(3) -10;
        end  
         
                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial48.mat')
              idx(1) = idx(1) -20;
%                idx(3) = idx(3) -15;
        end  
        
                                                                                                                                                                                                                     
        if   strcmp(mfname,'/trial49.mat')
              idx(1) = idx(1) -5;
               idx(3) = idx(3) -1;
        end  
                                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial50.mat')
              idx(1) = idx(1) -20;
               idx(3) = idx(3) -1;
        end  
          
                                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial51.mat')
              idx(1) = idx(1) -15;
               idx(3) = idx(3) -7;
        end  
                                                                                                                                                                                                                                     
        if   strcmp(mfname,'/trial52.mat')
              idx(1) = idx(1) -10;
%                idx(3) = idx(3) -7;
        end  
                                                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial53.mat')
              idx(1) = idx(1) -15;
%                idx(3) = idx(3) -7;
        end 
                                                                                                                                                                                                                                                     
        if   strcmp(mfname,'/trial54.mat')
              idx(1) = idx(1) -30;
%                idx(3) = idx(3) -7;
        end 
                                                                                                                                                                                                                                                             
        if   strcmp(mfname,'/trial56.mat')
              idx(1) = idx(1) -35;
%                idx(3) = idx(3) -7;
        end
    end
    
    
    rangeZ= find(Zpos_act>.00005);
%     
%     figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
end



%% RTIS 2011 Paretic

if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')

    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.25*max(dist),1);
     
        if   strcmp(mfname,'/trial4.mat')
             idx(1) = idx(1) -50;
            idx(3) = idx(1)+100;
        end
%         
        if   strcmp(mfname,'/trial5.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -115;
        end
        
        if   strcmp(mfname,'/trial6.mat')
            idx(1) = idx(1) -50;
            idx(3) = idx(3) -230+21;
        end
                
        if   strcmp(mfname,'/trial7.mat')
            idx(1) = idx(1) -50;
            idx(3) = idx(3) -70;
        end
                        
        if   strcmp(mfname,'/trial8.mat')
            idx(1) = idx(1) -48;
            idx(3) = idx(3) -70;
        end
                                
        if   strcmp(mfname,'/trial9.mat')
            idx(1) = idx(1) -50;
            idx(3) = idx(3) -85;
        end
                                        
        if   strcmp(mfname,'/trial10.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -70;
        end
                                                
        if   strcmp(mfname,'/trial11.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -55;
        end
                                                        
        if   strcmp(mfname,'/trial12.mat')
            idx(1) = idx(1) -45;
            idx(3) = idx(3) -88;
        end
                                                        
        if   strcmp(mfname,'/trial13.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -122;
        end
                                                        
        if   strcmp(mfname,'/trial14.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -55;
        end
                                                        
        if   strcmp(mfname,'/trial15.mat')
            idx(1) = idx(1) -35;
            idx(3) = idx(3) -129;
        end
    end
    
    if expcond ==2

         idx(1) = find(dist>=.25*max(dist),1);
%                     
%         rangeYandZ= find(Ypos_act>Ypos_act(idx(1)) & Zpos_act>.0004);
%         maxdistidx = find(dist==max(dist(rangeYandZ)));
%         idx(3) = maxdistidx+47;

        if   strcmp(mfname,'/trial16.mat')
            idx(1) = idx(1) +100;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +60;
        end
        
        if   strcmp(mfname,'/trial17.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +237;
            idx(3) =  rangeZ(end)-20;
        end
                
        if   strcmp(mfname,'/trial18.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +150-35;
            idx(3) =  rangeZ(end)-95;
        end
                        
        if   strcmp(mfname,'/trial19.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +170;
            idx(3) =  idx(1) +50;
        end
                                
        if   strcmp(mfname,'/trial20.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +180;
            idx(3) =  idx(1) +50;
        end
                                        
        if   strcmp(mfname,'/trial21.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +220;
            idx(3) =  idx(1) +46;
        end
                                                
        if   strcmp(mfname,'/trial22.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +150;
            idx(3) =  idx(1) +75-21;
        end
                                                        
        if   strcmp(mfname,'/trial23.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +170;
            idx(3) =  idx(1) +52;
        end
                                                                
        if   strcmp(mfname,'/trial24.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +143;
            idx(3) =  idx(1) +85;
        end
                                                                        
        if   strcmp(mfname,'/trial25.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +165;
            idx(3) =  idx(1) +65-8;
        end
                                                                        
        if   strcmp(mfname,'/trial26.mat')
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            rangeZ= find(Zpos_act>.00005);
            idx(1) = idx(1) +270+17;
            idx(3) =  idx(1) +85-17;
        end
    end
    
    if expcond ==3
        
        idx(1) = find(dist>=.25*max(dist),1);

    
       
        if   strcmp(mfname,'/trial28.mat')
            idx(1) = idx(1) +220;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +50;
        end
        
               
        if   strcmp(mfname,'/trial29.mat')
            idx(1) = idx(1) +160;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +85;
        end
                       
        if   strcmp(mfname,'/trial30.mat')
            idx(1) = idx(1) +160;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +55;
        end
                       
        if   strcmp(mfname,'/trial32.mat')
            idx(1) = idx(1) +160+15-30;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +25+30;
        end
                               
        if   strcmp(mfname,'/trial33.mat')
            idx(1) = idx(1) +85;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +70-24;
        end
                                       
        if   strcmp(mfname,'/trial34.mat')
            idx(1) = idx(1) +145;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +55-18;
        end
                                               
        if   strcmp(mfname,'/trial35.mat')
            idx(1) = idx(1) +100;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +15;
        end
                                                       
        if   strcmp(mfname,'/trial36.mat')
            idx(1) = idx(1) +148;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +67-12;
        end
                                                       
        if   strcmp(mfname,'/trial37.mat')
            idx(1) = idx(1) +225;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +49;
        end
    end
    
    
    if expcond ==4 
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
                                                               
        if   strcmp(mfname,'/trial64.mat')

            idx(3) = idx(3)-25;
        end
        
                                                                       
        if   strcmp(mfname,'/trial67.mat')
            idx(1) = idx(1)+55;
            idx(3) = idx(3)-35;
        end
                                                                               
        if   strcmp(mfname,'/trial68.mat')
            idx(1) = idx(1)+55;
            idx(3) = idx(3)-78;
        end
    end
    
    if expcond ==5

                                                                                       
        if   strcmp(mfname,'/trial48.mat')
            idx(1) = idx(1) +190;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +70;
        end
                                                                                       
        if   strcmp(mfname,'/trial49.mat')
            idx(1) = idx(1) +214;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +56-19;
        end
                                                                                       
        if   strcmp(mfname,'/trial50.mat')
            idx(1) = idx(1) +190;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +34;
        end

                                                                                       
        if   strcmp(mfname,'/trial51.mat')
            idx(1) = idx(1) +190-15;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +48;
        end
                                                                                               
        if   strcmp(mfname,'/trial52.mat')
            idx(1) = idx(1) +198;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +64;
        end
                                                                                               
        if   strcmp(mfname,'/trial53.mat')
            idx(1) = idx(1) +175;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +64-20;
        end
                                                                                                       
        if   strcmp(mfname,'/trial54.mat')
            idx(1) = idx(1) +198-18;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +64+17;
        end
                                                                                                       
        if   strcmp(mfname,'/trial55.mat')
            idx(1) = idx(1) +198+12;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +80;
        end
                                                                                                       
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1) +225;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +41;
        end
                                                                                                       
        if   strcmp(mfname,'/trial57.mat')
            idx(1) = idx(1) +203;
            
            rangeYandZ= find(xhand(:,2)>xhand(idx(1),2) & Zpos_act>.0004);
            maxdistidx = find(dist==max(dist(rangeYandZ)));
            idx(3) = idx(1) +43;
        end

    end

    
    if expcond ==6
        
        rangeZ= find(Zpos_act>.00005);
        LocalMins = find(islocalmin(xhand(rangeZ(1:length(rangeZ)),2)));
        
        idx(1) =    LocalMins(2)+rangeZ(1);
        idx(3) = idx(1) +75;
        
                                                                                                               
        if   strcmp(mfname,'/trial43.mat')
            idx(3) = rangeZ(end);
        end
        
                                                                                                                       
        if   strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1) +27;
            idx(3) = idx(1) +35;
        end
        
                
                                                                                                                       
        if   strcmp(mfname,'/trial45.mat')
 
             idx(1) = LocalMins(8)+rangeZ(1);
             idx(3) = rangeZ(end)-70;
        end
                                                                                                                               
        if   strcmp(mfname,'/trial46.mat')
 
             idx(1) = idx(1) +42;
             idx(3) = idx(1) +25;
        end
                                                                                                                                       
        if   strcmp(mfname,'/trial58.mat')
 
             idx(1) = idx(1) +85;
             idx(3) = idx(1) +55;
        end
                                                                                                                                               
        if   strcmp(mfname,'/trial59.mat')
 
%              idx(1) = idx(1) +50;
             idx(3) = idx(3)-25;
        end
                                                                                                                                                       
        if   strcmp(mfname,'/trial60.mat')
               idx(1) = idx(1) -40;
             idx(3) = idx(3)-36;
        end
                                                                                                                                                       
        if   strcmp(mfname,'/trial61.mat')
 
%              idx(1) = idx(1) +50;
             idx(3) = idx(3)-48;
        end
                                                                                                                                                               
        if   strcmp(mfname,'/trial62.mat')
 
%              idx(1) = idx(1) +50;
             idx(3) = idx(3)+55;
        end
                                                                                                                                                               
        if   strcmp(mfname,'/trial63.mat')
 
              idx(1) = idx(1) +15;
             idx(3) = idx(3)-25;
        end
    end
    

    
    
end

%% RTIS2011 Non-Paretic
if strcmp(partid,'RTIS2011') && strcmp(hand,'Right')
  
    if expcond ==1
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        
        if   strcmp(mfname,'/trial1.mat')
        idx(3) = idx(3) -5;
        end
                
        if   strcmp(mfname,'/trial2.mat')
        idx(3) = idx(3) -13;
        end
                        
        if   strcmp(mfname,'/trial9.mat')
        idx(3) = idx(3) -14;
        end

    end
    
      
    if expcond ==2
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +25;
                                
        if   strcmp(mfname,'/trial12.mat')
        idx(1) = idx(1)+11;
        end
                                        
        if   strcmp(mfname,'/trial13.mat')
        idx(1) = idx(1)-31;
        end
                                                
        if   strcmp(mfname,'/trial16.mat')
        idx(1) = idx(1)-25;
        end
                                                        
        if   strcmp(mfname,'/trial19.mat')
        idx(1) = idx(1)-20;
        end
                                                                
        if   strcmp(mfname,'/trial20.mat')
        idx(1) = idx(1)-30;
        end

                                                                
        if   strcmp(mfname,'/trial21.mat')
        idx(1) = idx(1)-20;
        end
    end
    
    
    if expcond ==3
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +10;
        
                                                                
        if   strcmp(mfname,'/trial22.mat')
        idx(1) = idx(1)-10;
        end
                
                                                                
        if   strcmp(mfname,'/trial23.mat')
        idx(1) = idx(1)-20;
        end
                                                                        
        if   strcmp(mfname,'/trial24.mat')
        idx(1) = idx(1)-15;
        end
                                                                                
        if   strcmp(mfname,'/trial26.mat')
        idx(1) = idx(1)-15;
        end
                                                                                        
        if   strcmp(mfname,'/trial27.mat')
        idx(1) = idx(1)-5;
        idx(3) = idx(3)-2;
        end
                                                                                                
        if   strcmp(mfname,'/trial28.mat')
        idx(1) = idx(1)-10;
%         idx(3) = idx(3)-2;
        end
                                                                                                        
        if   strcmp(mfname,'/trial29.mat')
        idx(1) = idx(1)-13;
%         idx(3) = idx(3)-2;
        end
                                                                                                                
        if   strcmp(mfname,'/trial30.mat')
%         idx(1) = idx(1)-13;
         idx(3) = idx(3)-5;
        end
                                                                                                                        
        if   strcmp(mfname,'/trial31.mat')
         idx(1) = idx(1)-20;
%          idx(3) = idx(3)-5;
        end
    end
    
    if expcond ==4
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
    end
    
    if expcond ==5 
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +20;
                                                                                                                                
        if   strcmp(mfname,'/trial47.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                        
        if   strcmp(mfname,'/trial48.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                        
        if   strcmp(mfname,'/trial49.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                                
        if   strcmp(mfname,'/trial51.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                                
        if   strcmp(mfname,'/trial53.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                                
        if   strcmp(mfname,'/trial54.mat')
         idx(1) = idx(1)-25;
%          idx(3) = idx(3)-5;
        end
                                                                                                                                                
        if   strcmp(mfname,'/trial56.mat')
            idx(1) = idx(1)-25;
            idx(3) = idx(3)-5;
        end
    end
    
    if expcond ==6
        
        max_dist = max(dist);
        end_reach = find(dist==max_dist);
        idx(3) = end_reach;
        idx(1) = find(dist>=.05*max(dist),1);
        idx(1) = idx(1) +20;
                                                                                                                                                        
        if   strcmp(mfname,'/trial43.mat')
            idx(1) = idx(1)+25;
%             idx(3) = idx(3)-5;
        end
                                                                                                                                                                
        if   strcmp(mfname,'/trial44.mat')
            idx(1) = idx(1)-20;
%             idx(3) = idx(3)-5;
        end
                                                                                                                                                                        
        if   strcmp(mfname,'/trial46.mat')
            idx(1) = idx(1)-15;
%             idx(3) = idx(3)-5;
        end
        
                                                                                                                                                                                
        if   strcmp(mfname,'/trial59.mat')
            idx(1) = idx(1)-35;
%             idx(3) = idx(3)-5;
        end
                                                                                                                                                                                        
        if   strcmp(mfname,'/trial60.mat')
            idx(1) = idx(1)-15;
%             idx(3) = idx(3)-5;
        end
    end
        
    rangeZ= find(Zpos_act>.00005);
    
%     figure()
%     plot(t,Zpos_act,'Linewidth',1.5)
%     hold on
%     %             plot(t,-Ypos_act,'Linewidth',1.5)
%     %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
%     plot(t(rangeZ),Zpos_act(rangeZ),'ro')
%     xline(t(idx(1)),'g','Linewidth',1.5)
%     xline(t(idx(3)),'r','Linewidth',1.5)
%     %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
%     xlabel('Time (s)')
%     ylabel('Position (m)')
%     legend('ZposACT','YposACT','Y and Z Range','Y and Z Range','START','STOP','YValue_start','FontSize',14)
%     title(mfname,'FontSize',24)
%     
end



% %         
rangeZ= find(Zpos_act>.00005);
% 
% figure()
% plot(t,Zpos_act,'Linewidth',1.5)
% hold on
% %             plot(t,-Ypos_act,'Linewidth',1.5)
% %             plot(t(rangeZ),-Ypos_act(rangeZ),'ro')
% plot(t(rangeZ),Zpos_act(rangeZ),'ro')
% xline(t(idx(1)),'g','Linewidth',1.5)
% xline(t(idx(3)),'r','Linewidth',1.5)
% %             yline(-Ypos_act(idx(1)),'m','Linewidth',1.5)
% xlabel('Time (s)')
% ylabel('Position (m)')
% legend('ZposACT','Y and Z Range','START','STOP','YValue_start','FontSize',14)
% title(mfname,'FontSize',24)


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



%% Verification of reach start and end - 2024 

% Correcting for the resampling 1000 HZ sampling Rate 

% idx = idx*10; 

idxmetria = idx;

% Correcting - KINEMATICS
timestart = idx(1)/100;
timedistmax = idx(3)/100;
timevelmax =idx(2)/100;


tmet = t;
x_all = xhand(:,1);
y_all = xhand(:,2);
z_all = xhand(:,3);

figure(1)
subplot(4,3,1)
plot(tmet,vel/1000,'b','LineWidth',2)
hold on
plot(tmet,vely/1000,'LineWidth',2)

line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
ylabel('m/s','FontSize',16)
hold on
yyaxis right
ylabel('m','FontSize',16)
plot(tmet,dist/1000)
xlim([0 5])


legend('vel','vely','start','end','dist','fontsize',16)

figure(1)
subplot(4,3,4)
plot(tmet,x_all/1000,'b','LineWidth',2)
xlim([0 5])
ylabel('m','FontSize',16)
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist

title('X','FontSize',16)

subplot(4,3,7)
plot(tmet,y_all/1000,'b','LineWidth',2)
xlim([0 5])
ylabel('m','FontSize',16)
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title('Y','FontSize',16)
subplot(4,3,10)
plot(tmet,z_all/1000,'b','LineWidth',2)
hold on
plot(tmet,Zpos_act,'b','LineWidth',2)

xlim([0 5])
ylabel('m','FontSize',16)
line('Color','g','Xdata',[timestart timestart],'Ydata',ylim, 'LineWidth',2.5); % start reach
% line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',ylim,'LineWidth',2.5); % max vel
line('Color','r','Xdata',[timedistmax timedistmax],'Ydata',ylim,'LineWidth',2.5); %max, dist
title('Z','FontSize',16)
legend('Z Metria','Z ACT3D','FontSize',16)
xlabel('Time(s)','FontSize',16)


subplot(4,3,[2:3 5:6 8:9 11:12])
plot(x_all,y_all,'LineWidth',2)
hold on
plot(x_all(idxmetria(1),1 ), y_all(idxmetria(1), 1), 'go', 'MarkerSize', 10);
plot(x_all(idxmetria(3),1), y_all(idxmetria(3),1), 'ro', 'MarkerSize', 10);
axis equal



pause
%%

rangeZ= find(Zpos_act>.00005);
idx;
timestart = t(idx(1));
% timevelmax = t(idx(2));
timedistmax = t(idx(3));



%% USE THIS PLOT FOR VERIFICATION OF REACH START 2023!!!!!! UNCOMMENT BELOW
% figure(2)
% clf
% yyaxis left
% hold on
% plot(t,dist,'LineWidth',1.5)
% plot(t, abs(xhand(:,3)-mean(xhand(1:20,3))),'LineWidth',1.5)
% ylabel('Position (mm)')
% yyaxis right
% plot(t,vely,'LineWidth',1.5)
% ylabel('Velocity (mm/s)')
% y1=ylim;
% title(['Distance and Velocity' mfname],'FontSize',24)
% p1 = xline(timestart,'g','Linewidth',1); %startreach
% p3 = xline(timedistmax,'r','Linewidth',1); %maxdist
% xlim([0 t(end)])
% xlabel('time in seconds')
% legend('Distance','Z DISP','Vel Y','Time Start','Time End','Location','northeast','FontSize',16)

%%
%% Plotting Data
% 
% figure(2)
% clf
% %  subplot(5,1,1)
% %ax = axes('position',[0.12,0.75,0.75,0.22]);
% yyaxis left
% 
% % plot(t,xhand(:,2),'LineWidth',1.5)
% hold on
% %plot(t,abs(xhand(:,3)-xhand(1,3)),'LineWidth',1)
% plot(t,dist,'LineWidth',1.5)
% plot(t, abs(xhand(:,3)-mean(xhand(1:20,3))),'LineWidth',1.5)
% % plot(t(rangeZ),dist(rangeZ),'ro')
% ylabel('Position (mm)')
% 
% yyaxis right
% 
% plot(t,vely,'LineWidth',1.5)
% % plot(t(rangeZ),vely(rangeZ),'ro')
% ylabel('Velocity (mm/s)')
% y1=ylim;
% 
% title(['Distance and Velocity' mfname],'FontSize',24)
% % p1 = xline('Color','g','Xdata',[timestart timestart],'Ydata',[-10000 10000], 'LineWidth',1); % start reach
% 
% p1 = xline(timestart,'g','Linewidth',1); %startreach
% % p2= line('Color','m','Xdata',[timevelmax timevelmax],'Ydata',[-5000 5000],'LineWidth',1); % max vel
% 
% %p3= xline('Color','r','Xdata',[timedistmax timedistmax],'Ydata',[-10000 10000],'LineWidth',1); %max, dist
% p3 = xline(timedistmax,'r','Linewidth',1); %maxdist
% 
% %p4= line('Color','b','Ydata',[0 0],'Xdata',[-5000 5000],'LineWidth',2); %time prior
% %p5= line('Color','r','Xdata',[timeend timeend],'Ydata',[-500 500],'LineWidth',.5);
% % ylim([-400 400])
% % co=get(lax1,'ColorOrder');
% % set(lax1,'ColorOrder',co(end-1:-1:1,:))
% xlim([0 t(end)])
% 
% xlabel('time in seconds')
% % legend('Distance', 'Velocity','Time Start','Time End','Location','northeast','FontSize',16)
% % legend('Z displacement','Vel y','Time Start','Time End','vel=0','Location','northwest','FontSize',16)
% % legend('Distance','Z DISP','Range Z','Vel Y','Range Z','Time Start','Time End','Location','northeast','FontSize',16)
% 
% 
% 
% legend('Distance','Z DISP','Vel Y','Time Start','Time End','Location','northeast','FontSize',16)

%close all
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
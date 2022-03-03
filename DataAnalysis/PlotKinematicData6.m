%% Plotting Kinematic Data- Main Function

% Main function that calls other functions for analysis. This function
% calls 'ComputeReachStart2021', 'GetHandShoulderTrunkPosition8', EMG functions,
% interpolates missing Metria data and then resamples so more in line with
% EMG data. More samples per second. Ultimately plots filled data,
% distance, velocity, and overhead plot.Use to confirm reach start/end
% times and interpolation is valid.

% Inputs:
% - expcond: 1:6 for condition (see summary sheet)
% - partid: string participant ID
% - metriafname: Metria file name as string
% - act3dfname : act3d file name. Same as metria file name. Same now
% - hand: which hand as string

% Outputs:
%- avgshouldertrunk: Average shoulder and trunk position across all trials
%- std_shldtr: std dev shoulder and trunk
%- avgmaxreach: average reach across trials
%- std_maxreach: std deviation of max reach.
%- avgemg_vel: average emg at max vel (check this)
%- avgemg_start: average EMG at the start of the reach. (check this)


% K.SUVADA 2019-2022
%%
function [avgshouldertrunk std_shldtr  avgmaxreach std_maxreach,avgemg_vel,avgemg_start] = PlotKinematicData6(partid,hand,metriafname,act3dfname,expcond,flag)
% File path and loading setupfile
 datafilepath = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data','/',partid,'/',hand];
 load(fullfile(datafilepath,[partid '_setup.mat'])); %load setup file


%% Loading in Max EMGS

% load([datafilepath '/Maxes/maxEMG.mat']);
%% Loading and setting file name and condition
expcondname={'RT','R25','R50','UT','U25','U50'};

% all the same file path now
afilepath = datafilepath;
afilepath2 = afilepath;
mfilepath = afilepath2;

% 
% %updated for new data structure 1.28.21
mtrials=setup.trial{expcond};
atrials=setup.trial{expcond};
ntrials=length(mtrials);

%% Initializing Variables

maxreach_current_trial=zeros(ntrials,1);

maxhandexcrsn_current_trial =zeros(ntrials,1);

shex_current_trial=zeros(ntrials,1);

trex_current_trial=zeros(ntrials,1);

% NOT SURE ABOUT ONES BELOW
% maxreach=zeros(ntrials,1);
% emgstart = zeros(ntrials,15);
%
% emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
% % rdist = zeros(ntrials,1);
% maxreach=zeros(ntrials,1);
% emgstart = zeros(ntrials,15);
%
% emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
% rdist = zeros(ntrials,1);
%
% % maxreach_current_trial =zeros(ntrials,1);
% % maxTrunk_current_trial=zeros(ntrials,1);
% % emgsmaxvel_vals = zeros(ntrials,15);
%
%
% maxreach_current_trial =zeros(ntrials,1);
% shtrdisp_current_trial=zeros(ntrials,2);
%
% emgvel_trial= zeros(length(mtrials),15);
% emgstart_trial= zeros(length(mtrials),15);
%% Main loop that grabs Metria data and plots
for i=1: length(mtrials)% i = 3
    
    
    mfname = ['/' metriafname num2str(mtrials(i)) '.mat'];
    afname =  mfname;
    afname2 = mfname;
    
    mfname
    
    if strcmp(partid,'RTIS1002')
        if strcmp(mfname,'/trials1.mat')
            continue
        end
        
        if strcmp(mfname,'/trials4.mat')
            continue
        end
        
        if strcmp(mfname,'/trials13.mat')
            continue
        end
        
        if strcmp(mfname,'/trials15.mat')
            continue
        end
%         
        if strcmp(mfname,'/trials10.mat')
            continue
        end
        
        if strcmp(mfname,'/trials11.mat')
            continue
        end
        
        if strcmp(mfname,'/trials26.mat')
            continue
        end
        
        if strcmp(mfname,'/trials29.mat')
            continue
        end
        
%                 
        if strcmp(mfname,'/trials31.mat')
            continue
        end
        
        if strcmp(mfname,'/trials34.mat')
            continue
        end
        
        if strcmp(mfname,'/trials30.mat')
            continue
        end
       
        if strcmp(mfname,'/trials16.mat')
            continue
        end
        if strcmp(mfname,'/trials17.mat')
            continue
        end
        
        if strcmp(mfname,'/trials18.mat')
            continue
        end
        
        if strcmp(mfname,'/trials19.mat')
            continue
        end
        
        if strcmp(mfname,'/trials20.mat')
            continue
        end
        
        if strcmp(mfname,'/trials41.mat')
            continue
        end
        
        if strcmp(mfname,'/trials43.mat')
            continue
        end
        
        if strcmp(mfname,'/trials47.mat')
            continue
        end
        
        if strcmp(mfname,'/trials22.mat')
            continue
        end
        
        if strcmp(mfname,'/trials23.mat')
            continue
        end
        
                
        if strcmp(mfname,'/trials24.mat')
            continue
        end
    end
    
    
    
    
    if strcmp(partid,'RTIS1003')
        if strcmp(mfname,'/trials14.mat')
            continue
        end
        if strcmp(mfname,'/trials1.mat')
            continue
        end
        if strcmp(mfname,'/trials6.mat')
            continue
        end
        if strcmp(mfname,'/trials17.mat')
            continue
        end
        
        if strcmp(mfname,'/trials18.mat')
            continue
        end
        if strcmp(mfname,'/trials22.mat')
            continue
        end
        if strcmp(mfname,'/trials33.mat')
            continue
        end
        if strcmp(mfname,'/trials32.mat')
            continue
        end
        if strcmp(mfname,'/trials31.mat')
            continue
        end
        if strcmp(mfname,'/trials36.mat')
            continue
        end
        if strcmp(mfname,'/trials24.mat')
            continue
        end
        if strcmp(mfname,'/trials25.mat')
            continue
        end
        if strcmp(mfname,'/trials28.mat')
            continue
        end
        if strcmp(mfname,'/trials29.mat')
            continue
        end
    end
    
    
    
    if strcmp(partid,'RTIS1004')
        if strcmp(mfname,'/trial21.mat')
            continue
        end
        
    end
    
    
    if strcmp(partid,'RTIS1005')
        if strcmp(mfname,'/trial21.mat')
            continue
        end
        if strcmp(mfname,'/trial31.mat')
            continue
        end
        
        
        if strcmp(mfname,'/trial34.mat')
            continue
        end
        
        if strcmp(mfname,'/trial36.mat')
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS1006')
        if strcmp(mfname,'/trial58.mat')
            continue
        end
        
        if strcmp(mfname,'/trial78.mat')
            continue
        end
        
    end
    
    
    
    if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial8.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial9.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial10.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial24.mat')

            continue
        end
        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
        if strcmp(mfname,'/trial51.mat')
            
            continue
        end
        if strcmp(mfname,'/trial34.mat')
            
            continue
        end
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        if strcmp(mfname,'/trial33.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2001') && strcmp(hand,'Left')
        
        % These were empty matrices metria data
        if strcmp(mfname,'/trial66.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial68.mat')
            
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        if strcmp(mfname,'/trial24.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
                
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
                        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial45.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
                
        if strcmp(mfname,'/trial49.mat')
            
            continue
        end
                        
        if strcmp(mfname,'/trial52.mat')
            
            continue
        end
        
                        
        if strcmp(mfname,'/trial53.mat')
            
            continue
        end
                                
        if strcmp(mfname,'/trial54.mat')
            
            continue
        end
    end
    
    
    if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
        
        
        if strcmp(mfname,'/trial3.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial5.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial64.mat')
            
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial17.mat')
            
            continue
        end
        
                
        if strcmp(mfname,'/trial20.mat')
            
            continue
        end
        
                        
        if strcmp(mfname,'/trial21.mat')
            
            continue
        end
        
                                
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
                                        
        if strcmp(mfname,'/trial39.mat')
            
            continue
        end
                                                
        if strcmp(mfname,'/trial25.mat')
            
            continue
        end
        
                                                        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
                                                                
        if strcmp(mfname,'/trial31.mat')
            
            continue
        end
        
                                                                        
        if strcmp(mfname,'/trial46.mat')
            
            continue
        end
        
                                                                                
        if strcmp(mfname,'/trial47.mat')
            
            continue
        end
        
                                                                                        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
                                                                                                
        if strcmp(mfname,'/trial28.mat')
            
            continue
        end
        
                                                                                                        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
                                                                                                                
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
        
                                                                                                                        
        if strcmp(mfname,'/trial74.mat')
            
            continue
        end
        
                                                                                                                                
        if strcmp(mfname,'/trial78.mat')
            
            continue
        end
        
                                                                                                                                        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
        
                                                                                                                                                
        if strcmp(mfname,'/trial71.mat')
            
            continue
        end
                                                                                                                                                        
        if strcmp(mfname,'/trial82.mat')
            
            continue
        end
                                                                                                                                                                
        if strcmp(mfname,'/trial85.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
                                                                                                                                                                      
        if strcmp(mfname,'/trial57.mat')
            
            continue
        end  
       
                                                                                                                                                                              
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end  
                                                                                                                                                                                      
        if strcmp(mfname,'/trial60.mat')
            
            continue
        end 
        
                                                                                                                                                                                              
        if strcmp(mfname,'/trial49.mat')
            
            continue
        end  
        
                                                                                                                                                                                                      
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end  
        
                                                                                                                                                                                                              
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end  
        
                                                                                                                                                                                                                      
        if strcmp(mfname,'/trial70.mat')
            
            continue
        end 
        
                                                                                                                                                                                                                              
        if strcmp(mfname,'/trial71.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                      
        if strcmp(mfname,'/trial82.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                            
        if strcmp(mfname,'/trial85.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                                    
        if strcmp(mfname,'/trial73.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                                    
        if strcmp(mfname,'/trial72.mat')
            
            continue
        end
        
                
                                                                                                                                                                                                                                                    
        if strcmp(mfname,'/trial76.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                                           
        if strcmp(mfname,'/trial87.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                                                   
%         if strcmp(mfname,'/trial79.mat')
%             
%             continue
%         end
%         
                                                                                                                                                                                                                                                                          
        if strcmp(mfname,'/trial81.mat')
            
            continue
        end
%                                                                                                                                                                                                                                                                           
        if strcmp(mfname,'/trial92.mat')
            
            continue
        end
                                                                                                                                                                                                                                                                                  
        if strcmp(mfname,'/trial95.mat')
            
            continue
        end
        
                                                                                                                                                                                                                                                                                          
        if strcmp(mfname,'/trial96.mat')
            
            continue
        end
    end
    %
    % % Kacey added to call new function to plot in GCS
    % bl = load('/Users/kcs762/Box/KACEY/Data/RTIS1002/BLs/BL.mat');
    % datafile =load([mfilepath '/' mfname]);
    % PlotGCS(datafile,bl,setup)
    %
    %     figure(2),clf
    %     if strcmp(partid,'RTIS2001') && (mtrials(i)==8)
    %         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
    %     else
    %
    %
    
    %%%%%%%%%%% Getting Metria Data %%%%%%%%%%%%%%%%%%%
    
    [t,xhand,xshoulder,xtrunk,xshldr,xjug,x]=GetHandShoulderTrunkPosition8(mfilepath,mfname,partid,setup);
    
    
    %% Checking NANS and Interpolating Prior to Resampling
    if strcmp(partid,'RTIS1006') % fixing that kacey switched x and y in GCS creation
        
        xhandfix(:,1) = xhand(:,2);
        xhand(:,2) = -xhand(:,1);
        
        xhand(:,1) =  xhandfix(:,1);
    end
    
    if strcmp(partid,'RTIS1002') % fixing that kacey switched x and y in GCS creation
       xhand(:,2) = -xhand(:,2); 
       xhand(:,1) = -xhand(:,1);

    end

    if strcmp(partid,'RTIS1006')
        
        xjugfix(:,1) = xjug(:,2);
        xjug(:,2) = -xjug(:,1);
        
        xjug(:,1) =  xjugfix(:,1);
        
        
        xjug(:,1) = -xjug(:,1);
    end
    
    if strcmp(partid,'RTIS1002') % fixing that kacey switched x and y in GCS creation
        xjug(:,2) = -xjug(:,2);
        xjug(:,1) = -xjug(:,1);

    end
    
    if sum(sum(isnan(xhand)))>0 || sum(sum(isnan(xjug)))>0 %
        
        if sum(sum(isnan(xhand)))>0 %checking if  xhand has NANs
            
            'NANS PRESENT IN XHAND'
            
            filled_data =   find(isnan(xhand(1:250)));
            
            if strcmp(partid,'RTIS1006') &&  expcond >3
                
                [xhandnew,TF] = fillmissing(xhand,'nearest');
                
            elseif strcmp(partid,'RTIS1002')
                if strcmp(mfname,'/trials10.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials9.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials22.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials23.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials24.mat')
                    [xhandnew,TF] = fillmissing(xhand,'nearest');
                end
                if strcmp(mfname,'/trials37.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                    
                else
                    [xhandnew,TF] = fillmissing(xhand,'spline','SamplePoints',t);
                end

            else
                
                [xhandnew,TF] = fillmissing(xhand,'spline','SamplePoints',t);
                
            end
            
            if flag == 1
                figure(9)
                clf
                %Plotting the Original Data then the Filled Samples
                subplot(3,1,1)
                plot(t(filled_data),xhandnew(filled_data,1),'ro')
                hold on
                plot(t,xhand(:,1),'b','Linewidth',1)
                % legend('Interpolated Data','Original Data','Location','northwest','FontSize',13)
                title('3D 3rd MCP Position','FontSize',18)
                xlabel('Time (s)','FontSize',14)
                ylabel('X Position (mm)','FontSize',14)
                xlim([0 5])
                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                    xlim([0 10])
                end
                                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                subplot(3,1,2)
                plot(t(filled_data),xhandnew(filled_data,2),'ro')
                hold on
                plot(t,xhand(:,2),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Y Position (mm)','FontSize',14)
                xlim([0 5])
                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                    xlim([0 10])
                end
                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                subplot(3,1,3)
                plot(t(filled_data),xhandnew(filled_data,3),'ro')
                hold on
                plot(t,xhand(:,3),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Z Position (mm)','FontSize',14)
                xlim([0 5])
               if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                     xlim([0 10]) 
               end 
                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                    
                'User Check Interpolation Accuracy'
                pause
                
            end
            xhand = xhandnew; %Replacing with interpolated data
            
        end
        

        
        if sum(sum(isnan(xjug)))>0  % Checking if Trunk has NANS
            'NANS PRESENT in XJUG'
            filled_data =   find(isnan(xjug(1:250)));
            
            if strcmp(partid,'RTIS1006') &&  expcond >3
                [xjugnew,TF] = fillmissing(xjug,'spline');
                
            else
                [xjugnew,TF] = fillmissing(xjug,'spline','SamplePoints',t);
            end
            
            if flag ==1
                figure(10)
                clf
                %Plotting the Original Data then the Filled Samples
                subplot(3,1,1)
                plot(t(filled_data),xjugnew(filled_data,1),'ro')
                hold on
                plot(t,xjug(:,1),'b','Linewidth',1)
                %  legend('Interpolated Data','Original Data','FontSize',13)
                title(['3D Trunk Position' mfname],'FontSize',18)
                xlabel('Time (s)','FontSize',14)
                ylabel('X Position (mm)','FontSize',14)
                xlim([0 5])
                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                    xlim([0 10])
                end
                                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                subplot(3,1,2)
                plot(t(filled_data),xjugnew(filled_data,2),'ro')
                hold on
                plot(t,xjug(:,2),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Y Position (mm)','FontSize',14)
                xlim([0 5])
                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                    xlim([0 10])
                end
                                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                subplot(3,1,3)
                plot(t(filled_data),xjugnew(filled_data,3),'ro')
                hold on
                plot(t,xjug(:,3),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Z Position (mm)','FontSize',14)
                xlim([0 5])
              
                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                    xlim([0 10])
                end
                
                if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                    xlim([0 10])
                end
                
                'User Check Interpolation Accuracy'
                
                pause
            end
            xjug= xjugnew;
            
        end
        
    end
    
    
    
    %% Computing Dist/Vel/Angles With Original Data
    Xo= nanmean(xhand(1:5,1));
    Yo = nanmean(xhand(1:5,2));
    Zo = nanmean(xhand(1:5,3));
    
    %dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
    dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2);
    
    % Computing Velocity and resampling
    vel = ddt(smo(dist,3),1/89);
    
    velx= ddt(smo(xhand(:,1),3),1/89);
    vely= ddt(smo(xhand(:,2),3),1/89);
    
    
    theta_vel2 = atan2(vely,velx);
    theta_vel2 = rad2deg(theta_vel2);
    
    %% RESAMPLE
    % Resample variables before feeding into the ComputeReachStart
    
    
    [xhand,t2]=resampledata(xhand,t,89,100);
    [xjug,t2]=resampledata(xjug,t,89,100);
    [dist,t2]=resampledata(dist,t,89,100);
    
    
    [vel,t2]=resampledata(vel,t,89,100);
    [velx,t2]=resampledata(velx,t,89,100);
    [vely,t2]=resampledata(vely,t,89,100);
    
    [theta_vel2,t2]=resampledata(theta_vel2,t,89,100);
    
    
    
    %% Metria Trial by Trial Kinematic Data (computed BLS)
    
%     if flag
%         figure(1),clf
%         subplot(2,1,1)
%         plot([(xhand(:,1)-xjug(1,1)) (xshldr(:,1)-xjug(1,1)) (xjug(:,1)-xjug(1,1))],[(xhand(:,2)-xjug(1,2)) (xshldr(:,2)-xjug(1,2)) (xjug(:,2)-xjug(1,2))],'LineWidth',1);
%         hold on
%         
%         plot(xhand(mridx,1),xhand(mridx,2),'o','MarkerSize',10,'MarkerFaceColor','r');
%         
%         % % p1=plot(-[xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2); hold on
%         % hold on
%         % p2=plot(gca,nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1) xfore(1:10,1) xarm(1:10,1)]),nanmean([xhand(1:10,2) xshoulder(1:10,2) xtrunk(1:10,2) xfore(1:10,2) xarm(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');
%         % % p3 = plot([xee*1000 xhnd*1000],[yee*1000 yhnd*1000],'LineWidth',4);  % added to add act 3d data
%         % % p3 = plot([xactee(:,1) xactha(:,1)],[xactee(:,2) xactha(:,2)],'LineWidth',4);  % added to add act 3d data
%         % %p3 = plot([xactee(:,1) p(:,1)],[xactee(:,2) p(:,2)],'LineWidth',4);  % added to add act 3d data
%         % p4=plot(gca,[setup.exp.hometar(1) setup.exp.shpos(1)]*1000,[setup.exp.hometar(2) setup.exp.shpos(2)]*1000,'o','MarkerSize',10,'MarkerFaceColor','r');
%         %
%         %
%         % %p5=quiver(gca,xfore([1 1 40 40],1),xfore([1 1 40 40],2),lcsfore([1 2 79 80],1),lcsfore([1 2 79 80],2),'LineWidth',2);
%         % % p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
%         
%         % % phandles=[p1' p2 p3];
%         axis 'equal'
%         legend('Hand','Shoulder','Trunk')
%         xlabel('x (mm)')
%         ylabel('y (mm)')
%         title(mfname)
%         
%         %Metria Distance Plot with Max Distance Marked
%         subplot(2,1,2)
%         plot(t,rdist)
%         hold on
%         p1 = line('Color','b','Xdata',[t(mridx) t(mridx)],'Ydata',[400 650], 'LineWidth',.5); % start reach
%         % co=get(lax1,'ColorOrder');
%         % set(lax1,'ColorOrder',co(end-1:-1:1,:))
%         xlabel('Time')
%         ylabel('Distance')
%         % legend('Distance','Max Dist')
%         axis equal
%         %
%         pause
%     end
    
    
    %% Loading in EMGS
    
    % Normalized EMGS
%     load([afilepath afname])
%     emg= data.daq{1,2};
%     emg=abs(detrend(emg(:,1:15)))./maxEMG(ones(length(emg(:,1:15)),1),:); % Detrend and rectify EMG
%     
    %% Computing the start of the reach
    
    
    [dist,vel,idx,timestart, timedistmax,xhand]= ComputeReachStart_2021(t2,xhand,xjug,dist,vel,velx,vely,theta_vel2,setup,expcond,partid,mfname,hand);
    
    
    %% Saving Variables from ComputeReachStart_2021 to .mat file 10.2021
    
    %Saves file for each trial
    %     extention='.mat';
    %     filepath_times=datafilepath;
    %     name_times = ['Times_Trial' num2str(mtrials(i)) '.mat'];
    %     matname = fullfile(filepath_times, [name_times extention]);
    %
    % save(matname,'dist','vel','distmax','idx','timestart','timevelmax', 'timedistmax','t_vector')
    
    %save(['Times_trial' num2str(i) '.mat'],'dist','vel','distmax','idx','timestart','timevelmax', 'timedistmax')
    %% Getting Computed GH and Euler Angles via Updated Kinematic Analysis Nov/Dec 2021
%     flag=0; %will not plot all Segment CSes
    
    metdata =  x; % using resampled x
    
    gh= zeros(4,length(metdata));
    
    for k = 1:length(metdata) %looping through each frame to get GH
        gh(:,k) = ComputeEulerAngles_AMA_K(mfname,hand,partid,k); %This gives computed GH converted to GCS
    end
    
    gh = gh';%Flipping so organized by columns (time = rows) like other variables
    
    if strcmp(hand,'Left')
        gh(:,1) = -gh(:,1);
        gh(:,2) = -gh(:,2);
    end
    
    
    if strcmp(partid,'RTIS1006')  %flipping x and y issue with kacey GCS digitization fixed now
        
        ghfix(:,1) = gh(:,2);
        gh(:,2) = -gh(:,1);
        
        gh(:,1) =  ghfix(:,1);
        
        gh(:,1) = -gh(:,1);
    end
    
    if strcmp(partid,'RTIS1002') % fixing that kacey switched x and y in GCS creation
        gh(:,2) = -gh(:,2);
        gh(:,1) = -gh(:,1);
    end
    
    % Interpolation of GH- accounting for trials with issues and need
    % alternative interpolation method.
    
    if sum(sum(isnan(gh)))>0  % Checking if Trunk has NANS
        'NANS PRESENT in GH'
        
        filled_data =   find(isnan(gh(1:250))); %rows of NANs
        if strcmp(partid,'RTIS1006') &&  expcond >3
            [ghNew,TF] = fillmissing(gh,'spline');
    
        elseif strcmp(partid,'RTIS1004') % Trial 26 weird interp so just use constant
            
            if strcmp(mfname,'/trial26.mat')
                
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            else
                 [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
            end
            
        elseif strcmp(partid,'RTIS1002')
            if strcmp(mfname,'/trials4.mat')
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            end
            
            if strcmp(mfname,'/trials5.mat')
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            else
                [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
                
            end
            
        else
            [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
        end
        
        
        if flag ==1
        figure(11)
        clf
        %Plotting the Original Data then the Filled Samples
        subplot(3,1,1)
        plot(t(filled_data),ghNew(filled_data,1),'ro')
        hold on
        plot(t,gh(:,1),'b','Linewidth',1)
        %   legend('Interpolated Data','Original Data','FontSize',13)
        title(['3D GH Position' mfname],'FontSize',18)
        xlabel('Time (s)','FontSize',14)
        ylabel('X Position (mm)','FontSize',14)
        xlim([0 5])
        if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            xlim([0 10])
        end
        
        if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            xlim([0 10])
        end
        subplot(3,1,2)
        plot(t(filled_data),ghNew(filled_data,2),'ro')
        hold on
        plot(t,gh(:,2),'b','Linewidth',1)
        %         legend('Interpolated Data','Original Data','FontSize',13)
        xlabel('Time (s)','FontSize',14)
        ylabel('Y Position (mm)','FontSize',14)
        xlim([0 5])
        if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            xlim([0 10])
        end
        
        if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            xlim([0 10])
        end
        subplot(3,1,3)
        plot(t(filled_data),ghNew(filled_data,3),'ro')
        hold on
        plot(t,gh(:,3),'b','Linewidth',1)
        %         legend('Interpolated Data','Original Data','FontSize',13)
        xlabel('Time (s)','FontSize',14)
        ylabel('Z Position (mm)','FontSize',14)
        xlim([0 5])
        if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            xlim([0 10])
        end
        
        if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            xlim([0 10])
        end
        'User Check Interpolation Accuracy'
        end
        
        pause
        
        
        gh= ghNew;
        
        
        
    end
    
    
    
    % Resampling GH
    [gh,t2]=resampledata(gh,t,89,100);
    
    
    t = t2;
    
    %% Checking to see if GH has NANs via missing shoulder marker
    %OLD way prior to resampling
    %     if isnan(gh(idx(1),1)) || isnan(gh(idx(3),1))  %returns t- NAN start/end
    %         'NAN SHLDR present Start/End Trial'
    %
    %         num_real_sh = find(~isnan(gh(:,1))); %Finding indices where not NAN
    %
    %         if isnan(gh(idx(1),1))
    %         % for start index
    %         Locs1_start= find(num_real_sh<idx(1));
    %         Locs1_start = Locs1_start(length(Locs1_start));
    %
    %         Locs2_start= find(num_real_sh>idx(1),1);
    %         Locs2_start = num_real_sh(Locs2_start);
    %
    %         if abs(Locs2_start-Locs2_start)-1 <=5 % seeing if NANs consecutive
    %             [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %         else
    %             if abs(Locs2_start-Locs2_start)-1  ==6 % allowing if it's just 1 over
    %                 [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %             else
    %                 'CHECK GH DATA- NUM_NANS CONSEC START >5'
    %                 %            abs(NANLocations_2-NANLocations_1)-1
    %                 %             mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %         else
    %
    %         % end index
    %         Locs1_end= find(num_real_sh<idx(3));
    %         Locs1_end = Locs1_end(length(Locs1_end));
    %
    %         Locs2_end= find(num_real_sh>idx(3),1);
    %         Locs2_end = num_real_sh(Locs2_end);
    %
    %         if abs(Locs2_end-Locs1_end)-1  <=5 % seeing if NANs consecutive
    %             [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %         else
    %             if abs(Locs2_end-Locs2_end)-1  ==6 % allowing if it's just 1 over
    %                 [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %             else
    %                 'CHECK GH DATA- NUM_NANS CONSEC END >5'
    %                 %            abs(NANLocations_2-NANLocations_1)-1
    %                 %             mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %        end
    %
    %   end
    %     %% Checking to see where Trunk has NANs
    %     if isnan(xjug(idx(1),1)) || isnan(xjug(idx(3),1))  %returns true now if any element is NAN
    %         'NAN TRUNK present Start/End Trial'
    %         num_real_tr = find(~isnan(xjug(:,1))); %Finding # of reals
    %
    %         % for start index
    %         if isnan(xjug(idx(1),1))
    %         Locs1_start= find(num_real_tr<idx(1));
    %         Locs1_start = Locs1_start(length(Locs1_start));
    %
    %         Locs2_start= find(num_real_tr>idx(1),1);
    %         Locs2_start = num_real_tr(Locs2_start);
    %
    %         if abs(Locs2_start-Locs2_start)-1 <=5 % seeing if NANs consecutive
    %             %     if length(num_NANS_tr) <= 5 %threshold 5 NANS
    %             [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %         else
    %
    %             if abs(Locs2_start-Locs2_start)-1 ==6 % allowing if it's just 1 over
    %                 [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %             else
    %                 'CHECK Trunk DATA- NUM_NANS CONSEC START >5'
    %                 % mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %         else
    %         % For end index
    %         Locs1_end= find(num_real_tr <idx(3));
    %         Locs1_end = Locs1_end(length(Locs1_end));
    %
    %         Locs2_end= find(num_real_tr>idx(3),1);
    %         Locs2_end = num_real_tr(Locs2_end);
    %
    %         if abs(Locs2_end-Locs1_end)-1 <=5 % seeing if NANs consecutive
    %             %     if length(num_NANS_tr) <= 5 %threshold 5 NANS
    %             [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %         else
    %
    %             if abs(Locs2_end-Locs2_end)-1 ==6 % allowing if it's just 1 over
    %                 [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %             else
    %                 'CHECK Trunk DATA- NUM_NANS CONSEC END >5'
    %                 % mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %         end
    %     end
    
    
    
    %% Compute reaching distance (between shoulder and hand from hand marker)
    
    %Updating Definition using Computed GH
    
    maxreach = sqrt((xhand(idx(3),1)-gh(idx(3),1))^2+(xhand(idx(3),2)-gh(idx(3),2))^2);
    
    %% Max Hand Excursion
    
    %using original data
    % Xo_sh= nanmean(xshldr(1:5,1));
    % Yo_sh = nanmean(xshldr(1:5,2));
    
    maxhandexcrsn = sqrt((xhand(idx(3),1)-xhand(idx(1),1))^2 +(xhand(idx(3),2)-xhand(idx(1),2))^2);
    
    
    %% Compute shoulder and trunk displacement at maximum reach - using BLS
    
    %Changed to be based on GH
    sh_exc=sqrt(sum((gh(idx(3),1:2)-nanmean(gh(1:5,1:2))).^2,2))';
    
    %Based on jugular notch
    trunk_exc = sqrt((xjug(idx(3),1)-nanmean(xjug(1:5,1)))^2+(xjug(idx(3),2)-nanmean(xjug(1:5,2)))^2);
    
    %% Getting Trunk, Shoulder, Hand Excursion, and reaching distance for the current trial
    maxhandexcrsn_current_trial(i) = maxhandexcrsn; %hand excursion defined as difference between hand at every point and inital shoudler position
    
    maxreach_current_trial(i) =maxreach; % reaching distance in mm difference hand and shoudler
    
    shex_current_trial(i) = sh_exc;
    
    trex_current_trial(i) = trunk_exc;
    
    
    %% Plotting EMGS
    %  [emg_timevel emg_timestart]= PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)% disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])
    %
    %  emgvel_trial(i,:) = emg_timevel;
    %  emgstart_trial(i,:) = emg_timestart;
    
    
    
    
    %% Main Cumulative Metria Figure
    figure(4)
    clf
%     p1=plot([xhand(idx(1):idx(3),1) xshldr(idx(1):idx(3),1) xjug(idx(1):idx(3),1)],[xhand(idx(1):idx(3),2) xshldr(idx(1):idx(3),2) xjug(idx(1):idx(3),2)],'LineWidth',2);
    
    %     p1=plot([xhand(idx(1):idx(3),1) gh(idx(1):idx(3),1) xjug(idx(1):idx(3),1)],[xhand(idx(1):idx(3),2) gh(idx(1):idx(3),2) xjug(idx(1):idx(3),2)],'LineWidth',3);
    
    % Works for plotting GH just from start to end reach : subtracting initial trunk position
    %          p1= plot([(xhand(idx(1):idx(3),1)-xjug(idx(1),1)) (gh(idx(1):idx(3),1)-xjug(idx(1),1)) (xjug(idx(1):idx(3),1)-xjug(idx(1),1))],[(xhand(idx(1):idx(3),2)-xjug(idx(1),2)) (gh(idx(1):idx(3),2)-xjug(idx(1),2)) (xjug(idx(1):idx(3),2)-xjug(idx(1),2))],'LineWidth',3);
    %% Plotting whole trial with GH - UN COMMENT JAN 2022
    %  p1= plot([(xhand(:,1)-xjug(idx(1),1)) (gh(:,1)-xjug(idx(1),1)) (xjug(:,1)-xjug(idx(1),1))],[(xhand(:,2)-xjug(idx(1),2)) (gh(:,2)-xjug(idx(1),2)) (xjug(:,2)-xjug(idx(1),2))],'LineWidth',3); % - trunk
 

   % p1=plot([xhand(:,1) gh(:,1) xjug(:,1)],[xhand(:,2) gh(:,2) xjug(:,2)],'LineWidth',3);% not subtracting trunk
    p1=plot([xhand(:,1)],[xhand(:,2)],'LineWidth',3);% not subtracting trunk
    

%     length(xhand)
    %%
    %p1= plot([(xhand(:,1)-xjug(idx(1),1)) (gh(idx(1):idx(3),1)-xjug(idx(1),1)) (xjug(idx(1):idx(3),1)-xjug(idx(1),1))],[(xhand(idx(1):idx(3),2)-xjug(idx(1),2)) (gh(idx(1):idx(3),2)-xjug(idx(1),2)) (xjug(idx(1):idx(3),2)-xjug(idx(1),2))],'LineWidth',3);
    
    %          p1= plot([(xhand(:,1)-xjug(idx(1),1)) (xshldr(:,1)-xjug(idx(1),1)) (xjug(:,1)-xjug(idx(1),1))],[(xhand(:,2)-xjug(idx(1),2)) (xshldr(:,2)-xjug(idx(1),2)) (xjug(:,2)-xjug(idx(1),2))],'LineWidth',3);
    
    Newreachx = (xhand(:,1)-xjug(1,1));
    Newreachy = (xhand(:,2)-xjug(1,2));
    hold on
    
    %       idxvelmax = find(t==timevelmax,1);
    %       c1= viscircles([Newreachx(idxvelmax),Newreachy(idxvelmax)],5,'Color','m');emgvel_trial
    
    %       c2= viscircles([xhand(idxvelmax,1),xhand(idxvelmax,2)],5,'Color','m');
    %    c2=  plot(xhand(idxvelmax,1),xhand(idxvelmax,2),'o','MarkerEdgeColor','m','MarkerSize',10);
    
    
    
    %      idxreachstart = find(t==timestart,1);
    % c1= plot(Newreachx(idx(1)),Newreachy(idx(1)),'o','MarkerFaceColor','g','MarkerSize',10);
    %% Jan 2022 marking start and end hand trace
    %c1= plot(xhand(idx(1),1)-xjug(idx(1),1),xhand(idx(1),2)-xjug(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); % minus trunk
    

    c1= plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10);
    c3= plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10);
    
    %%
    %      c1= viscircles([xhand(idxreachstart,1),xhand(idxreachstart,2)],5,'Color','g');
    %          c1= plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10);
    
    %         plot(xshldr(idx(1),1),xshldr(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
    %         plot(xshldr(idx(3),1),xshldr(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); % marking shoulder end
    %%
    %          plot(gh(idx(1),1)-xjug(1,1),gh(idx(1),2)-xjug(1,2),'o','MarkerFaceColor','g','MarkerSize',10); %marking shoulder start
    %          plot(gh(idx(3),1)-xjug(1,1),gh(idx(3),2)-xjug(1,2),'o','MarkerFaceColor','r','MarkerSize',10); % marking shoulder end
    %
    %
    %         plot(xjug(idx(1),1)-xjug(1,1),xjug(idx(1),2)-xjug(1,2),'o','MarkerFaceColor','g','MarkerSize',10); %marking trunk start
    %         plot(xjug(idx(3),1)-xjug(1,1),xjug(idx(3),2)-xjug(1,2),'o','MarkerFaceColor','r','MarkerSize',10); % marking trunk end
    
    

    % Not minus trunk
    plot(gh(idx(1),1),gh(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); %marking shoulder start
    plot(gh(idx(3),1),gh(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10); % marking shoulder end
    
    
    plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); %marking trunk start
    plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10); % marking trunk end
   
    
    
    %        c3= viscircles([Newreachx(idx(3)),Newreachy(idx(3))],5,'Color','r','MarkerSize',10);
    %        c3= plot(Newreachx(idx(3)),Newreachy(idx(3)),'o','MarkerFaceColor','r','MarkerSize',10);
    
    %%
    %         c3= viscircles([xhand(idx(3),1),xhand(idx(3),2)],5,'Color','r');
    %         c3= plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10);
    
    
    %    p2=plot(nanmean([xhand(1:10,1) xshldr(1:10,1) xjug(1:10,1)]),nanmean([xhand(1:10,2) xshldr(1:10,2) xjug(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
    %       p2=plot([xhand(10,2) xshoulder(10,2) xtrunk(10,2)],[xhand(10,2) xshoulder(10,2) xtrunk(10,2)],'o','MarkerSize',10,'MarkerFaceColor','g','MarkerEdgeColor','g');
    %     p3=plot([xhand(end,1) xshldr(end,1) xjug(end,1)],[xhand(end,2) xshldr(end,2) xjug(end,2)],'s','MarkerSize',10,'MarkerFaceColor','r','MarkerEdgeColor','r');
    
    
    
    %     set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
    
    %     viscircles([nanmean(xhand(1:10,1)),nanmean(xhand(1:10,2))],10,'Color','g')
    
    %   if i ==1
    %   armlength = ((setup.exp.armLength+setup.exp.e2hLength)*10)-abs(xshldr(idx(3),2))
    %   armlength = 397.7616;
    %   y1= yline( armlength,'LineWidth',2,'Color','b');% Line where the arm length is
    %   end
    
    
     legend([p1' c1 c3],'Hand','Shoulder','Trunk','Reach Start','Max Distance','Location','northeast','FontSize',16)
    %axis 'equal'
    xlabel('X (mm)','FontSize',16)
    ylabel('Y (mm)','FontSize',16)
    %   axis equal
    %   xlim([-250 50])
    %   ylim([-100 600])
    
    if expcond== 1
        title(['Restrained Table' mfname],'FontSize',24)
    end
    
    if expcond== 2
        title(['Restrained 25%' mfname],'FontSize',24)
    end
    
    if expcond== 3
        title(['Restrained 50%' mfname],'FontSize',24)
    end
    
    if expcond== 4
        title(['Unrestrained Table' mfname],'FontSize',24)
    end
    
    if expcond== 5
        title(['Unrestrained 25%' mfname],'FontSize',24)
    end
    
    if expcond== 6
        title(['Unrestrained 50%' mfname],'FontSize',24)
    end
    axis equal
    
    %% Calling COP Function
    %   ppsdata =data.pps;
    %   tpps = data.pps{1,1};
    %   ppsdata= ppsdata{1,2};
    %   ppsdata = ppsdata(1:mridx,:); % cutting off at max reach
    %  [CoP2]= ComputeCOP(ppsdata,tpps);
    
     pause
    close all
end




%% Printing out the max reach, std, shoulder and trunk displacement and std

% UPDATED KCS Jan 2022 -- to fix large standard dev issue
% Need to change 0s from skipped trials to NANs

for k = 1:length(maxreach_current_trial)
    
    if maxreach_current_trial(k)== 0
        maxreach_current_trial(k) = nan;
    end
    if maxhandexcrsn_current_trial(k) ==0
        maxhandexcrsn_current_trial(k) = nan;
    end
    if shex_current_trial(k) ==0
        shex_current_trial(k) = nan;
    end
    
    if trex_current_trial(k) ==0
        trex_current_trial(k) = nan;
    end
end

avgmaxreach =nanmean(maxreach_current_trial)
std_maxreach = nanstd(maxreach_current_trial)

avgmaxhand = nanmean(maxhandexcrsn_current_trial)
std_maxhand= nanstd(maxhandexcrsn_current_trial)

%Updated based on GH computation
avgshldr = nanmean(shex_current_trial)
stdshldr = nanstd(shex_current_trial)

avgtrunk = nanmean(trex_current_trial)
stdtrunk = nanstd(trex_current_trial)

%  avgemg_vel = mean(emgvel_trial)
%  avgemg_start = mean(emgstart_trial)

end
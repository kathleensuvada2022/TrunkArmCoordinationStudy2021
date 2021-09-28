%%% USED JULY 2021 WORKS!

%%
flpath='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2010/Left/Maxes';
basename='clean_data_trial_';
partid='RTIS2010';
setfname='RTIS2010_setup';

plotflag=1;
hand ='Left';
%%

function maxEMG=GetMaxMusAct3(flpath,basename,setfname,partid,plotflag,hand)
% Function to get the maximum EMGs from the MVC Torques data. The output is a .mat file (*MaxEMG.mat)
% which contains the following matrices:
% Inputs: basename: triacleal file name (before index)
%         setfname: setup filename.
%         plotflag: 1-plot torques, 0-do not plot torques
% Outputs: maxEMG: [1 x nEMG]. Maximum EMG for each channel
%          maxidx: [1 x nEMG]. Trial index where max EMG occurred
% 7/19 AMA - updated routine for Kacey's trunk-arm reaching data
% Updated 10.2019
% Usage example:
%    [maxEMG]=GetMaxMusAct('/Users/kcs762/Documents/MATLAB/Data/AIM1/MaxEMGS/owen061819maxemgs/Left','max','savedsetupKacey',1)

% flpath = '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/DATA/MAXES'
% basename = 'maxes'
% setfname = 'savedsetupKacey'
% 
% enter the command below in the command line
%KCS 7.2019
% basename is 'max'
% searches through all of the files 
%
load([flpath '/' setfname]);

sampRate= setup.daq.sRate;

% Specify the width of the averaging window in seconds
avgwindow=0.25; ds=sampRate*avgwindow;
trials=dir([flpath '/*' basename '*.mat']);

%Updated 10.14.19
%emgchan = chanList(1:15);
emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
nEMG= length(emgchan);
maxTEMG=zeros(length(trials),nEMG);
Tlength=zeros(length(trials),1);
%%
for j=1:length(trials)
    disp([flpath '/' trials(j).name])
    
    %Replace this line with however you load your data. Important to
    %include the code that selects the jth file     
    try load([flpath '/' trials(j).name]);
%         data= Totaldata.data %updated 10.2019
    catch maxTEMG(j,:)=zeros(1,nEMG); continue % make comment about error after catch 
    end
%     Tlength(j)=length(data);

    emg=detrend(cleandata(:,1:15)); %updated 11.2020
    % Rectify EMG
    emg=abs(emg);
    % Compute the mean EMG
    meanEMG=movmean(emg,ds);  %movmean change from previous function
    % Find maximum EMG
    [maxTEMG(j,:),maxtidx(j,:)]=max(meanEMG);
    
    % ARTIFACT CORRECTION

 %%%%%%%%%%%%%%%%RTIS 2001%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%  if strcmp(partid,'RTIS2001')  %% RIGHT ARM
%          if strcmp(trials(j).name,'clean_data_trial_2.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=3500; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%        if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4000; dnid=5000; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end
%         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4500; dnid=5000; iemg=4;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         end 
%        if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4500; dnid=5000; iemg=6;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end  
%      if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4500; dnid=5000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%      end  
%           if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4500; dnid=5000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end 
%         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=2000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%      end 
%   
%  end
%  
  if strcmp(partid,'RTIS2001') %% LEFT ARM

         if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=4000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
%          
         if strcmp(trials(j).name,'clean_data_trial_31.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=4000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=4000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=500; dnid=2500; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=3000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=3000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_27.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2000; dnid=3000; iemg=12;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2200; dnid=4000; iemg=5;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_2.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_7.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_8.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end

        if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_19.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_20.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_21.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end

        if strcmp(trials(j).name,'clean_data_trial_23.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        
        if strcmp(trials(j).name,'clean_data_trial_24.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_25.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_27.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end

        if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_31.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        
        if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_35.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=8;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_27.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1; dnid=2500; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
        
        if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1; dnid=3000; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end














  end 
%%%%%%%%%%%%%%%%RTIS 2002%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%    if strcmp(partid,'RTIS2002') %% LEFT ARM 
%          if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%          if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%          if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=4000; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%          
%          if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%         if strcmp(trials(j).name,'clean_data_trial_40.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         end
%          if strcmp(trials(j).name,'clean_data_trial_39.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%           if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1003; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=2500; dnid=5000; iemg=5;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3500; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         end
%        
%         if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         end
%        
%        if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1700; dnid=2000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_35.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1500; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_36.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1500; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end
%        
%           if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=2500; dnid=3000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_24.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=2000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%            if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%            if strcmp(trials(j).name,'clean_data_trial_36.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4000; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%            end
%           if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4000; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4000; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           if strcmp(trials(j).name,'clean_data_trial_37.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4000; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%          if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%           
%            if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=4500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%        
%          if strcmp(trials(j).name,'clean_data_trial_35.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=5000; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%           
%           if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1500; dnid=5000; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1500; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%                     
%           if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_31.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=10;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_36.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_37.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end   
%  
%            if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%            end
%            
%            
%            if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%            end
%            
%            if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%            end
%            
%            if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%            end  
%                   
%           if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_35.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_31.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=2000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           
%           if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1; dnid=4500; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=2000; dnid=5000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%           if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1; dnid=2000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%           
%  
%           if strcmp(trials(j).name,'clean_data_trial_8.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1; dnid=2000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end 
%           
%           if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end 
%    end
% %   
% %   
 
%  
   if strcmp(partid,'RTIS2002') %% Right ARM 
         if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2200; dnid=2300; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=3000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_37.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=3000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2000; dnid=2500; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4500; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3500; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_25.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
   end
  
%%%%%%%%%%%%%%%%%RTIS2003%%%%%%%%%%%%%%%%
    if strcmp(partid,'RTIS2003') %Right (Left didn't need any ) 
%       if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
%             upid=2500; dnid=3500; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%       end
    end
%       
%    if strcmp(partid,'RTIS2005') % Name of folder containing artifact trial. Include "/" at the end.
%       if strcmp(trials(j).name,'maxes17.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3500; iemg=6;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         
%       elseif strcmp(trials(j).name,'maxes17.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3500; iemg=6;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;    
%                
%       elseif strcmp(trials(j).name,'maxes3.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=1500; iemg=3;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             
%             %LIO
%             upid=4500; dnid=5000; iemg=7;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             
%             %LD
%             upid=1000; dnid=2000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%                            
%             
%         elseif strcmp(trials(j).name,'maxes20.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=4500; dnid=5000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%       
%         elseif strcmp(trials(j).name,'maxes39.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %BIC
%             upid=1000; dnid=1200; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%            
%         elseif strcmp(trials(j).name,'maxes2.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %PM
%             upid=1000; dnid=4500; iemg=12;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%         elseif strcmp(trials(j).name,'maxes6.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %LD
%             upid=1000; dnid=2000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%                                                        
%        elseif strcmp(trials(j).name,'maxes7.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %LD
%             upid=1000; dnid=2000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;             
%        elseif strcmp(trials(j).name,'maxes41.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %LD
%             upid=4000; dnid=5000; iemg=9;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;                                                                 
%             
%       end
%    end
   
    if strcmp(partid,'RTIS2010') && strcmp(hand,'Right')
         if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1500; dnid=5000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
       if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
             upid=1000; dnid=1500; iemg=4;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
     if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=4;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
     end
   if strcmp(trials(j).name,'clean_data_trial_23.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
   end
  if strcmp(trials(j).name,'clean_data_trial_19.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
  end
if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end

if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end

if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'clean_data_trial_20.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
             upid=1000; dnid=3500; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
    end
    
    
    
    if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
        upid=1000; dnid=3000; iemg=3;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
             upid=1000; dnid=3000; iemg=2;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end
        
        if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
             upid=1000; dnid=3000; iemg=2;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end
        
        if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
             upid=3000; dnid=4000; iemg=3;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end
        
        
        if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
             upid=1000; dnid=4000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
                   
           
        end
        
        if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
             upid=1000; dnid=2900; iemg=6;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end
        
        if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
             upid=3000; dnid=5000; iemg=6;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end
        
        if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
             upid=1400; dnid=5000; iemg=8;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
        end 
        
    end 

 %%%%%%%%%%%%RTIS2006%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      if strcmp(partid,'RTIS2006')  % RIGHT
%          if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=2000; iemg=1;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%           end
%        if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
%              upid=2000; dnid=3000; iemg=2;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%      if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
%              upid=1000; dnid=2000; iemg=3;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%      end
%     if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
%              upid=500; dnid=3500; iemg=6;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%     end
%     
%  
%     if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
%              upid=500; dnid=3500; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%     end
%   end  
   
     if strcmp(partid,'RTIS2006')  % LEFT
         if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_2.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=600; dnid=650; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=550; dnid=600; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=600; dnid=620; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1300; dnid=1400; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_7.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=500; dnid=550; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1200; dnid=1400; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=800; dnid=1000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=4100; dnid=4102; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2620; dnid=2624; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_19.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=4940; dnid=4943; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=270; dnid=275; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=401; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1100; dnid=1103; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_8.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=850; dnid=852; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=860; dnid=862; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=150; dnid=152; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=900; dnid=903; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_23.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_20.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_21.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=400; dnid=403; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
     end
  %%%%%%%%%%%%%%%%%%%RTIS2007%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if strcmp(partid,'RTIS2007') && strcmp(hand,'Right')
        
         if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
    end
    
    
    
    if strcmp(partid,'RTIS2007') && strcmp(hand,'Left')
          upid=1000; dnid=3000; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
              
            upid=1000; dnid=3000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
            
            upid=1000; dnid=3000; iemg=5;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
           
            upid=1000; dnid=3000; iemg=13;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        
        
        
         if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
          
            upid=500; dnid=1500; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
          
            upid=500; dnid=1400; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
          
            upid=1000; dnid=1600; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
          
            upid=1000; dnid=1400; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
          
            upid=1500; dnid=3500; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
                        
            upid=2400; dnid=2500; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_21.mat') % Trial containing artifact
          
            upid=2200; dnid=3400; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_23.mat') % Trial containing artifact
          
            upid=1500; dnid=3500; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
            
                 
            upid=2500; dnid=5000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
          
            upid=1500; dnid=3500; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
          
            upid=2000; dnid=3300; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
            
                
            upid=2800; dnid=2900; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
          
            upid=600; dnid=1100; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
          
            upid=982; dnid=4800; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_8.mat') % Trial containing artifact
          
            upid=1700; dnid=2500; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
                     
            upid=3000; dnid=5000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
          
            upid=1000; dnid=3000; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
              
            upid=4600; dnid=4700; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
          
            upid=1200; dnid=1800; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
          
            upid=1500; dnid=1800; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_7.mat') % Trial containing artifact
          
            upid=1900; dnid=2600; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
               
            upid=2200; dnid=2400; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
          
            upid=1000; dnid=3000; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
          
            upid=2100; dnid=2900; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
                    
            upid=1800; dnid=3000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
          
            upid=1300; dnid=1800; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
          
            upid=700; dnid=1200; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
          
            upid=4300; dnid=4400; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
          
            upid=4300; dnid=4400; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_19.mat') % Trial containing artifact
          
            upid=2500; dnid=2800; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
    end 
    
    %%%%%%%%%%%%%%%%%%%RTIS2008%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     if strcmp(partid,'RTIS2008') %Right
         if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3500; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_27.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
                  
         if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
     end
   %%%%%%%%%%%%%%%%%%%RTIS2009%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%    if strcmp(partid,'RTIS2009') % Left
%          if strcmp(trials(j).name,'clean_data_trial_37.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3000; iemg=2;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%        if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
%              upid=2800; dnid=2802; iemg=2;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
%              upid=4500; dnid=4501; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_24.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=5;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        
%        if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_14.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%        
%        if strcmp(trials(j).name,'clean_data_trial_24.mat') % Trial containing artifact
%              upid=1000; dnid=4000; iemg=11;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
% %    end
 if strcmp(partid,'RTIS2009') 
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=9;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=9;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=9;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4500; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=4500; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=10;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=10;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=10;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         
         if strcmp(trials(j).name,'clean_data_trial_15.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_18.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2000; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_16.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2500; iemg=11;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
 end



  
 %%%%%%%%%%%%%%%%%%%RTIS2011%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%    if strcmp(partid,'RTIS2011')  % Left
%          if strcmp(trials(j).name,'clean_data_trial_28.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             %REO
%             upid=1000; dnid=3000; iemg=1;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%          end
%        if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
%              upid=1000; dnid=2500; iemg=2;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%   
%    end
               
if strcmp(partid,'RTIS2011')  % Right
         if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=3500; dnid=5000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
       if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
             upid=1; dnid=3400; iemg=2;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
       
       if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
             upid=1000; dnid=4000; iemg=8;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
    
end
    %%%%%%%%%%%%%%%%%%%RTIS1006%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

  if strcmp(partid,'RTIS1006') 
         if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2000; iemg=3;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
%        if strcmp(trials(j).name,'maxes30.mat') % Trial containing artifact
%              upid=4000; dnid=5000; iemg=2;
%              [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%              maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%        end
%   
  end
   
    if strcmp(partid,'RTIS1004') 
         if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=4500; dnid=5000; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
       if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
             upid=1000; dnid=5000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
       if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
             upid=1000; dnid=3000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
       if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
             upid=4900; dnid=5000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
         if strcmp(trials(j).name,'clean_data_trial_13.mat') % Trial containing artifact
             upid=4900; dnid=5000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
         end
       if strcmp(trials(j).name,'clean_data_trial_12.mat') % Trial containing artifact
             upid=1000; dnid=1005; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
      if strcmp(trials(j).name,'clean_data_trial_10.mat') % Trial containing artifact
             upid=4116; dnid=4124; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
             upid=2000; dnid=2500; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      
      if strcmp(trials(j).name,'clean_data_trial_9.mat') % Trial containing artifact
             upid=4900; dnid=4901; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      
      if strcmp(trials(j).name,'clean_data_trial_8.mat') % Trial containing artifact
             upid=3716; dnid=3719; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      
      if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
             upid=2100; dnid=2200; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      if strcmp(trials(j).name,'clean_data_trial_1.mat') % Trial containing artifact
             upid=2100; dnid=2200; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
      if strcmp(trials(j).name,'clean_data_trial_2.mat') % Trial containing artifact
             upid=2000; dnid=2100; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
      end
     if strcmp(trials(j).name,'clean_data_trial_6.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
     end
     if strcmp(trials(j).name,'clean_data_trial_3.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
   if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
   if strcmp(trials(j).name,'clean_data_trial_7.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
   end
   
   
   if strcmp(trials(j).name,'clean_data_trial_2.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
     
   end
   
   
   if strcmp(trials(j).name,'clean_data_trial_5.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
   
   end 
   
      
   if strcmp(trials(j).name,'clean_data_trial_4.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=11;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
   
   end 
   
   
   end
    
end 
%%

Tlength(j)=size(cleandata,1);

[maxEMG,maxidx]=max(maxTEMG);
maxTlength=max(Tlength);


% %% Plots 
if plotflag
    %figure(1), clf
    newemg=zeros(length(cleandata),nEMG);   % changed to length(data) from maxTlength for RTIS2005
    t=(0:maxTlength - 1)/sampRate;
    for k=1:nEMG
        load([flpath '/' trials(maxidx(k)).name]);
%         newemg(:,k)=[data(:,k+6);zeros(maxTlength-length(data),1)];
%         data=structData.totalData; % no longer need this line 10.2019
        newemg(:,k)=cleandata(:,k);  
    end
end
   % PlotEMGs(newemg)
    figure(), clf
    newemg=abs(detrend(newemg));
    newmeanEMG=movmean(newemg,ds);
    memg=max(newemg);
    yspacing=cumsum([0 memg(2:nEMG)+.1]);
    rax = axes('position',[0.1,0.05,0.75,0.9]);
    set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');
    set(rax,'TickLabelInterpreter','none')
    set(rax,'YTick',fliplr(-yspacing),'YTickLabel',flipud(strcat(emgchan','-',strvcat(trials(maxidx).name))),...
        'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
    lax=axes('position',[0.1,0.05,0.75,0.9]);
    plot(t,newemg-yspacing(ones(length(t),1),:),t(diag(maxtidx(maxidx,1:nEMG))),maxEMG-yspacing,'k*'),hold on;
    co=get(lax,'ColorOrder');
    set(lax,'ColorOrder',co(end-1:-1:1,:),'YLim',[-yspacing(end) memg(1)])
    plot(t,newmeanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
    ylabel 'V'
    title(['Maximum EMGs across all trials - ' flpath(1:end)],'Interpreter','none')
    print('-f1','-djpeg',[flpath '\MaxEMGs'])


% Save results
save([flpath '/maxEMG'],'maxEMG','maxidx')

end % if plotflag



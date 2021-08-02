%%% USED JULY 2021 WORKS!

%%
flpath='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2002/Left/maxes';
basename='clean_data_trial_';
partid='RTIS2002';
setfname='RTIS2002_setup';

plotflag=1;
%%

function maxEMG=GetMaxMusAct3(flpath,basename,setfname,partid,plotflag)
% Function to get the maximum EMGs from the MVC Torques data. The output is a .mat file (*MaxEMG.mat)
% which contains the following matrices:
% Inputs: basename: trial file name (before index)
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
         if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
        if strcmp(trials(j).name,'clean_data_trial_29.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
         if strcmp(trials(j).name,'clean_data_trial_30.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1; dnid=2000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_31.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1; dnid=2000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1; dnid=1500; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
  end 
%  
   if strcmp(partid,'RTIS2002') %% LEFT ARM 39??
         if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
         
         if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
        if strcmp(trials(j).name,'clean_data_trial_40.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
         if strcmp(trials(j).name,'clean_data_trial_39.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
          if strcmp(trials(j).name,'clean_data_trial_26.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1003; iemg=2;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
          if strcmp(trials(j).name,'clean_data_trial_17.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2500; dnid=5000; iemg=5;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
        if strcmp(trials(j).name,'clean_data_trial_33.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        end
       
       if strcmp(trials(j).name,'clean_data_trial_34.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1700; dnid=2000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
       if strcmp(trials(j).name,'clean_data_trial_35.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1500; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
       if strcmp(trials(j).name,'clean_data_trial_36.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=1500; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
          if strcmp(trials(j).name,'clean_data_trial_32.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=2500; dnid=3000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
          
          if strcmp(trials(j).name,'clean_data_trial_24.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
           if strcmp(trials(j).name,'clean_data_trial_11.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=3000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
       
   
   end
%   
%   
  
  
%      if strcmp(partid,'RTIS1001') % Name of folder containing artifact trial. Include "/" at the end.
%     
%         if strcmp(trials(j).name,'MAXES8.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=1500; dnid=5000; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'MAXES28.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2500; dnid=5000; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'MAXES27.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4000; dnid=5000; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'MAXES36.mat') 
%             % LRA
%             upid=3000; dnid=5000; iemg=3;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             % LD
%             upid=2500; dnid=3000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             % RIO
%             upid=4000; dnid=5000; iemg=8;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;           
% 
%         elseif strcmp(trials(j).name,'MAXES5.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=1;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'MAXES34.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'MAXES7.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;   
%        elseif strcmp(trials(j).name,'MAXES1.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2000; dnid=3500; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%       
%        elseif strcmp(trials(j).name,'MAXES4.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2000; dnid=5000; iemg=13;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%             
%        elseif strcmp(trials(j).name,'MAXES39.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=1500; dnid=2500; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
%       elseif strcmp(trials(j).name,'MAXES32.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2000; dnid=3000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             
%       elseif strcmp(trials(j).name,'MAXES31.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=1500; dnid=2000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        
%        
%      elseif strcmp(trials(j).name,'MAXES30.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%            
%             % LD
%             upid=4800; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             
%        
%             
%       elseif strcmp(trials(j).name,'MAXES37.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2500; dnid=3500; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%             
%       elseif strcmp(trials(j).name,'MAXES38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=3000; dnid=3500; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;      
%       
%       elseif strcmp(trials(j).name,'MAXES35.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4000; dnid=5000; iemg=11;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;       
%         end
%      end
% 
%     if strcmp(partid,'RTIS2003') % Name of folder containing artifact trial. Include "/" at the end.
%       if strcmp(trials(j).name,'maxes27.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=2500; dnid=3500; iemg=16;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%       elseif strcmp(trials(j).name,'maxes29.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=16;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        elseif strcmp(trials(j).name,'maxes28.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=16;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;  
%        elseif strcmp(trials(j).name,'maxes38.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=16;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;         
%         elseif strcmp(trials(j).name,'maxes36.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=16;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%         elseif strcmp(trials(j).name,'maxes40.mat') % Trial containing artifact
%             % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=4500; dnid=5000; iemg=12;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;          
%                  
%       end
%     end
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
   
   if strcmp(partid,'RTIS2010') 
         if strcmp(trials(j).name,'maxes22.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=4000; dnid=5000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
       if strcmp(trials(j).name,'maxes32.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=4;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
     if strcmp(trials(j).name,'maxes26.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=4;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
     end
   if strcmp(trials(j).name,'maxes23.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
   end
  if strcmp(trials(j).name,'maxes19.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=5;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
  end
if strcmp(trials(j).name,'maxes15.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end

if strcmp(trials(j).name,'maxes16.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end

if strcmp(trials(j).name,'maxes17.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'maxes18.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'maxes20.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'maxes14.mat') % Trial containing artifact
             upid=1000; dnid=3500; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
if strcmp(trials(j).name,'maxes16.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=10;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
end
   end
   
     if strcmp(partid,'RTIS2006') 
         if strcmp(trials(j).name,'clean_data_trial_38.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
          end
       if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
             upid=2000; dnid=3000; iemg=2;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
     if strcmp(trials(j).name,'clean_data_trial_22.mat') % Trial containing artifact
             upid=1000; dnid=2000; iemg=3;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
     end
    if strcmp(trials(j).name,'maxes2.mat') % Trial containing artifact
             upid=2500; dnid=3000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
    if strcmp(trials(j).name,'maxes4.mat') % Trial containing artifact
             upid=500; dnid=1000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
    if strcmp(trials(j).name,'maxes1.mat') % Trial containing artifact
             upid=3500; dnid=4000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
    if strcmp(trials(j).name,'maxes5.mat') % Trial containing artifact
             upid=1; dnid=5000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
    if strcmp(trials(j).name,'maxes3.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=7;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
    end
    end
    
   if strcmp(partid,'RTIS2011') 
         if strcmp(trials(j).name,'maxes28.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            %REO
            upid=1000; dnid=2000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
         end
       if strcmp(trials(j).name,'maxes30.mat') % Trial containing artifact
             upid=4000; dnid=5000; iemg=2;
             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1; 
       end
  
   end
   
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
        newemg(:,k)=cleandata(:,k);  %updated 10.2019 because channels changed
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



function [maxEMG newemg]=GetMaxMusAct2(flpath,basename,setfname,partid,plotflag,p)
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
%  basename = 'maxes'
%  setfname = 'savedsetupKacey'
% 
% enter the command below in the command line
%KCS 7.2019
% basename is 'max'
% searches through all of the files 
%
load([flpath '/' setfname]);

% Specify the width of the averaging window in seconds
sampRate = setup.daq.sRate;

avgwindow=0.25; ds=sampRate*avgwindow;
trials=dir([flpath '/*' basename '*.mat']);

%Updated 10.14.19
%emgchan = chanList(1:15);
emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'} %,'ADEL'};
nEMG= length(emgchan);
maxTEMG=zeros(length(trials),nEMG);
Tlength=zeros(length(trials),1);

%changed data to structData.totalData KCS 7.3.19
for j=1:length(trials)
    disp([flpath '/' trials(j).name])
    
    %Replace this line with however you load your data. Important to
    %include the code that selects the jth file     
    try load([flpath '/' trials(j).name]);
%         data= Totaldata.data %updated 10.2019
    catch maxTEMG(j,:)=zeros(1,nEMG); continue % make comment about error after catch 
    end
%     Tlength(j)=length(data);

    emg=detrend(data(:,1:15)); %updated 10.2019
    % Rectify EMG
    emg=abs(emg);
    % Compute the mean EMG
    meanEMG=movmean(emg,ds);  %movmean change from previous function
    % Find maximum EMG
    [maxTEMG(j,:),maxtidx(j,:)]=max(meanEMG);
    
    
%     % This is an example, change it to fit your data *Kacey changed
	if strcmp(partid,'RTIS2001') % Name of folder containing artifact trial. Include "/" at the end.
       if strcmp(trials(j).name,'maxes26.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=1; dnid=6000; iemg=4;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       elseif strcmp(trials(j).name,'maxes27.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=1; dnid=9000; iemg=10;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

%             disp(maxtidx(j,iemg))
%             figure(4), plot(abs(data(:,iemg)))
       end
    elseif strcmp(partid,'RTIS1001') % Name of folder containing artifact trial. Include "/" at the end.
       if strcmp(trials(j).name,'MAXES8.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=1500; dnid=5000; iemg=13;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
     elseif strcmp(partid,'RTIS1003') % Name of folder containing artifact trial. Include "/" at the end.
       if strcmp(trials(j).name,'maxes9.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=1500; dnid=3000; iemg=5;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
     elseif strcmp(partid,'RTIS1002') % Name of folder containing artifact trial. Include "/" at the end.
       if strcmp(trials(j).name,'maxes44.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=2500; dnid=5000; iemg=7;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
       
       if strcmp(trials(j).name,'maxes40.mat') % Trial containing artifact
            % In order to exclude the artifact from the analysis, set upid
            % and dnid to the beginning sample and final sample of the
            % trial that excludes the artifact. iemg is the EMG channel
            % that has the artifact.
            upid=1500; dnid=5000; iemg=1;
            [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
            maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       end
    end
    Tlength(j)=size(data,1);
    
end 

[maxEMG,maxidx]=max(maxTEMG);
maxTlength=max(Tlength);


%% Plots 
if plotflag
     figure(1)
    newemg=zeros(maxTlength,nEMG);
    t=(0:maxTlength - 1)/sampRate;
    for k=1:nEMG
        load([flpath '/' trials(maxidx(k)).name]);
%         newemg(:,k)=[data(:,k+6);zeros(maxTlength-length(data),1)];
%         data=structData.totalData; % no longer need this line 10.2019
        newemg(:,k)=data(:,k); % First 5 channels are forces and torques %updated 10.2019 because channels changed
    end
%     PlotEMGs(newemg)
%     subplot(3,3,6) UNCOMMENT FOR SINGLE PLot 
    newemg=abs(detrend(newemg));
    newmeanEMG=movmean(newemg,ds);
    memg=max(newemg);
  %% UNCOMMENT FOR SINGLE PLot 
    
    yspacing=cumsum([0 memg(2:nEMG)+.1]);
   rax = axes('position',[0.05,0.03,0.7,0.9]);
   set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');
   set(rax,'TickLabelInterpreter','none')
    set(rax,'YTick',fliplr(-yspacing),'YTickLabel',flipud(strcat(emgchan','-',strvcat(trials(maxidx).name))),...
       'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
    lax=axes('position',[0.05,0.03,0.7,0.9]);
   plot(t,newemg-yspacing(ones(length(t),1),:),t(diag(maxtidx(maxidx,1:nEMG))),maxEMG-yspacing,'k*')
   hold on
   %%
%   plot(t,newemg(:,1));
%%  UNCOMMENT FOR SINGLE PLot  
  
  co=get(lax,'ColorOrder');
   set(lax,'ColorOrder',co(end-1:-1:1,:),'YLim',[-yspacing(end) memg(1)])
    plot(t,newmeanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
   ylabel 'V'
 %% 
  title ('MVC')
%     title(['Maximum EMGs across all trials - ' flpath(1:end)],'Interpreter','none')
    print('-f1','-djpeg',[flpath '\MaxEMGs'])
end % if plotflag

% Save results
save([flpath '/maxEMG'],'maxEMG','maxidx')
end 


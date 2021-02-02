
%Edits for Kacey July 2019

flpath = '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/DATA/MAXES'
basename = 'maxes'
setfname = 'savedsetupKacey'



function [maxEMG]=GetMaxMusAct2(flpath,basename,setfname,plotflag)

%enter the command below in the command line

%


% [maxEMG]=GetMaxMusAct('/Users/kcs762/Documents/MATLAB/Data/AIM1/MaxEMGS/owen061819maxemgs/Left','max','savedsetupKacey',1)
%KCS 7.2019
% basename is 'max'
% searches through all of the files 


% Function to get the maximum EMGs from the MVC Torques data. The output is a .mat file (*MaxEMG.mat)
% which contains the following matrices:
% Inputs: basename: trial file name (before index)
%         setfname: setup filename.
%         plotflag: 1-plot torques, 0-do not plot torques
% Outputs: maxEMG: [1 x nEMG]. Maximum EMG for each channel
%          maxidx: [1 x nEMG]. Trial index where max EMG occurred
%
% 2/9/16 AMA updated routine for Amee Seitz' shoulder torque data analysis
% 
% Usage example:
%  [maxEMG]=GetMaxMusAct('..\Data\07\Left','MVIC','01_07_Setup',1);
%  [maxEMG]=GetMaxMusAct('..\Data\01\Right','MVC','01_01_R_Setup',1);
%  [maxEMG]=GetMaxMusAct('..\Data\01\Left','MVC','01_01_L_Setup',1);
%  [maxEMG]=GetMaxMusAct('..\Data\02\Right','MVC','03_02_R_Setup',1);
%  [maxEMG]=GetMaxMusAct('..\Data\05\Right','MVC','03_05_R_Setup',1);

load([flpath '/' setfname]);



% Specify the width of the averaging window in seconds


avgwindow=0.25; ds=sampRate*avgwindow;



trials=dir([flpath '/*' basename '*.mat']);


emgchan = chanList(1:15);


nEMG= length(emgchan);

maxTEMG=zeros(length(trials),nEMG);

Tlength=zeros(length(trials),1);


%changed data to structData.totalData KCS 7.3.19

for j=1:length(trials)
    
    disp([flpath '/' trials(j).name])
    
    %Replace this line with however you load your data. Important to
    %include the code that selects the jth file     
    
    
    
    try load([flpath '/' trials(j).name]);
        data=structData.totalData;
    catch maxTEMG(j,:)=zeros(1,nEMG); continue %make comment about error after catch 
    end
    
    
%     Tlength(j)=length(data);

    emg=detrend(data(:,1:15));
    % Rectify EMG
    emg=abs(emg);
    % Compute the mean EMG
    meanEMG=movmean(emg,ds);  %movmean change from previous function
    % Find maximum EMG
    [maxTEMG(j,:),maxtidx(j,:)]=max(meanEMG);
    
    
%     % This is an example, change it to fit your data *Kacey changed
% 	if strcmp(flpath,'Left/') % Name of folder containing artifact trial. Include "/" at the end.
%        if strcmp(trials(j).name,'maxowbic2.mat') % Trial containing artifact
%            
%            % In order to exclude the artifact from the analysis, set upid
%             % and dnid to the beginning sample and final sample of the
%             % trial that excludes the artifact. iemg is the EMG channel
%             % that has the artifact.
%             upid=3500; dnid=length(meanEMG); iemg=3;
%             [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%             maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
%        end
%     end
    Tlength(j)=size(data,1); %skipping this line entirely? where is data defined? 
    
end % for j=1:length(trials)

[maxEMG,maxidx]=max(maxTEMG);

maxTlength=max(Tlength)





%% Plots 

if plotflag
    clf
%     newemg=zeros(length(t),nEMG);
    newemg=zeros(maxTlength,nEMG);
    t=(0:maxTlength - 1)/sampRate;
    for k=1:nEMG,
        % REPLACE NEXT LINE WITH THE ONE YOU WROTE ABOVE
        load([flpath '/' trials(maxidx(k)).name]);
%         newemg(:,k)=[data(:,k+6);zeros(maxTlength-length(data),1)];
        data=structData.totalData;
        newemg(:,k)=data(:,k+5); % First 5 channels are forces and torques
    end
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
end % if plotflag

% Save results
save([flpath '/maxEMG'],'maxEMG','maxidx')
end 


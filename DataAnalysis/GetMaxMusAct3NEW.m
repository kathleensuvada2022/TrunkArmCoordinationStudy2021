%%% USED JULY 2021 WORKS!

%%
% flpath='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS2010/Left/Maxes';
% basename='trial';
% partid='RTIS2010';
% setfname='RTIS2010_setup';
% 
% plotflag=1;
% hand ='Left';
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


load([flpath '/' setfname]);

sampRate= setup.daq.sRate;

% Specify the width of the averaging window in seconds
avgwindow=0.25; ds=sampRate*avgwindow;
trials=dir([flpath '/*' basename '*.mat']);

%emgchan = chanList(1:15);
emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
nEMG= length(emgchan);
maxTEMG=zeros(length(trials),nEMG);
Tlength=zeros(length(trials),1);
%%
for j=1:length(trials)
    disp([flpath trials(j).name])
    
    %Replace this line with however you load your data. Important to
    %include the code that selects the jth file     
    
    try load([flpath basename num2str(j)]);
%         data= Totaldata.data %updated 10.2019
    catch maxTEMG(j,:)=zeros(1,nEMG); continue % make comment about error after catch 
    end
%     Tlength(j)=length(data);

    emg=detrend(data(:,1:15)); %updated 12.2023- using raw not filtered maxes
    % Rectify EMG
    emg=abs(emg);
 
    emg = emg-repmat(mean(emg(1:250,:)),length(emg),1); %removes baseline

    % Compute the mean EMG
    meanEMG=movmean(emg,ds);

    % Find maximum EMG
    [maxTEMG(j,:),maxtidx(j,:)]=max(meanEMG);

    % ARTIFACT CORRECTION


if 1 %plotres

        t=(0:length(emg) - 1)/sampRate;

            clf
            title(['Maximum EMGs -  (trial' num2str(j) '): '])
            memg=max(emg);
            yspacing=cumsum([0 emg(2:nEMG)+0.1]);
            rax = axes('position',[0.1,0.05,0.75,0.9]);
            set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');
%             set(rax,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(ylabels),...
%                 'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
            set(rax,'YTick',fliplr(-yspacing),'YTickLabel',flipud(strcat(emgchan')),...
                 'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
            lax=axes('position',[0.1,0.05,0.75,0.9]);
            plot(t,emg-yspacing(ones(length(t),1),:),t(maxtidx(j,:)),maxTEMG(j,:)-yspacing,'k*'),hold on;
%             line([t([upid,upid]) t([dnid,dnid])],repmat([-yspacing(end) memg(1)]',1,2),'Color','b')
            co=get(lax,'ColorOrder');
            set(lax,'ColorOrder',co([2:end 1],:),'YLim',[-yspacing(end) memg(1)])
            plot(t,meanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
            ylabel 'V'
%             pause
        end
end
% %%

Tlength(j)=size(data,1);

[maxEMG,maxidx]=max(maxTEMG);% Max of all trials and max trial max occurs
maxTlength=max(Tlength);


% %% Plots 
if plotflag
    %figure(1), clf
    newemg=zeros(length(data),nEMG);  
    t=(0:maxTlength - 1)/sampRate;
    for k=1:nEMG
        load([flpath basename num2str(j)]);
%         newemg(:,k)=[data(:,k+6);zeros(maxTlength-length(data),1)];
%         data=structData.totalData; % no longer need this line 10.2019
        newemg(:,k)=data(:,k);  
    end
end
   % PlotEMGs(newemg)
    figure(), clf
    newemg=abs(detrend(newemg));
    newemg = newemg-repmat(mean(newemg(1:250,:)),length(newemg),1); %removes baseline
    newmeanEMG=movmean(newemg,ds);
    memg=max(newemg);
    yspacing=cumsum([0 memg(2:nEMG)+.1]);
    rax = axes('position',[0.1,0.05,0.75,0.9]);
    set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');
    set(rax,'TickLabelInterpreter','none')
    set(rax,'YTick',fliplr(-yspacing),'YTickLabel',flipud(strcat(emgchan','-',strvcat(maxidx))),...
        'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
    lax=axes('position',[0.1,0.05,0.75,0.9]);
   % plot(t,newemg-yspacing(ones(length(t),1),:))% t(diag(maxtidx(maxidx,1:nEMG)),maxEMG-yspacing,'k*'),hold on;
   %plot(t,emg-yspacing(ones(length(t),1),:),t(maxtidx(j,:)),maxTEMG(j,:)-yspacing,'k*'),hold on;

   plot(t,newemg-yspacing(ones(length(t),1),:),t(diag(maxtidx(maxidx,1:nEMG))),maxEMG-yspacing,'k*'),hold on;
    co=get(lax,'ColorOrder');
    set(lax,'ColorOrder',co(end-1:-1:1,:),'YLim',[-yspacing(end) memg(1)])
    plot(t,newmeanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
%     alltimesinsec = t(maxtidx(maxidx),1);
%     allmaxes = newmeanEMG(maxtidx(maxidx),:);
 %   plot(alltimesinsec(1),allmaxes(1)-yspacing(ones(length(maxtidx(maxidx)),1),1),'k*')
    ylabel 'V'
    title(['Maximum EMGs across all trials - ' flpath(1:end)],'Interpreter','none')
    print('-f1','-djpeg',[flpath '\MaxEMGs'])


% Save results
% save([flpath '/maxEMG'],'maxEMG','maxidx')

end % if plotflag



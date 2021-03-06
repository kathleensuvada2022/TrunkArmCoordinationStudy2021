function emgDAQ()
% emgDAQ Program to record EMGs while providing real time feedback of the
% signals. Based on TargetDAQ_Upgraded.
% Ana Maria Acosta 7/1/19 - Major modifications to TargetDAQ_Upgraded to
% simplify visualization,streamline acquisition and simplify code. This
% version only records EMGs.

%% GUI VISUALIZATION CODE
% Start by closing open figures and creating the main figure window for the GUI
close all;
scrsz = get(groot,'ScreenSize');
emgDAQ.Fig = figure('Name','EMG DAQ','NumberTitle', 'off','OuterPosition',[0.25*scrsz(3) 40 0.75*scrsz(3) scrsz(4)-40]);
emgDAQ.Fig.MenuBar = 'none';
emgDAQ.Fig.DeleteFcn =  @closeMainGUI;

%% Initialize GUI variables
% Note that myhandles is available to all the subfunctions in this program
% and therefore there is no need to use guidata to save myhandles for
% access across functions.
myhandles = guihandles(emgDAQ.Fig);
myhandles.daqDevice = 'Dev1';
myhandles.loadFile = 0;  % What is this?
myhandles.loadFilePrev = 0; % What is this?
myhandles.nChan = 15; % default # of channels to record
myhandles.sRate = 1000; % default sampling rate
myhandles.sTime = 5; % default sampling length
myhandles.timebuffer=(0:myhandles.sRate*2-1)'/myhandles.sRate;
% Create data buffer in app for real time data display
setappdata(emgDAQ.Fig,'databuffer',zeros(length(myhandles.timebuffer),myhandles.nChan));

% myhandles.Timer = 0;
myhandles.Channels = 0:myhandles.nChan-1; % Channel list for DAQ
myhandles.ChannelNames = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL','Channel 16','Channel 17','Channel 18','Channel 19','Channel 20','Channel 21','Channel 22','Channel 23','Channel 24'};
% myhandles.ChannelNames = myhandles.ChannelNames(1:myhandles.nChan);
myhandles.maxChannels = 24;

myhandles.itrial = 1;
myhandles.filename = 'trial';

% Initialize beep played at the beginning of each trial (queue for
% participant)
[y,fs]=audioread('beep.wav');
myhandles.beep=audioplayer(y,fs);

%% Add the GUI panels
%% DAQ PARAMETERS PANEL
daqParaPanel = uipanel('Title','DAQ Parameters','FontSize',11,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Tag','numChanET','Position',[0.775,0.7,0.2,0.3]);
% Number of channels
uicontrol(daqParaPanel,'Style','text','String','# of Channels','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.85,.5,.1],'FontSize',10);
myhandles.nChan_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.nChan,'Tag','numChan','Callback',@nChan_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .84 .3 0.12],'FontSize',10);
% Sampling rate
uicontrol(daqParaPanel,'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.68,.6,0.1],'FontSize',10);
myhandles.sRate_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.sRate,'Tag','sampRate','Callback',@SampRate_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .67 .3 .12],'FontSize',10);
% Sampling length
uicontrol(daqParaPanel,'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.52,0.6,0.1],'FontSize',10);
myhandles.sTime_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.sTime,'Tag','sampTime','Callback',@SampTime_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .51 .3 .12],'FontSize',10);
% Timer - not enabled in this version
% tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% myhandles.Timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.Timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);
% File name
uicontrol(daqParaPanel,'Style','text','String','File Name','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.33,0.6,0.1],'FontSize',10);
myhandles.fileName_Edit = uicontrol(daqParaPanel,'Style','edit','Callback',@FileName_Callback,'String',myhandles.filename,'HorizontalAlignment','center','Units','normalized','Position',[.45 .32 .5 .12],'FontSize',10);

%Initialize DAQ pushbutton 
uicontrol(daqParaPanel,'Style','pushbutton','Callback',@pbDaqInit_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.2 0.05 0.6 0.2],'FontSize',10);

% Acquire button
emgDAQ.Fig.KeyPressFcn = @aKeyPress_Callback;
myhandles.pbAcquire = uicontrol(emgDAQ.Fig,'Style','pushbutton','Callback',@pbAcquire_Callback,'String','<html>ACQUIRE<br>(Press "a")','FontWeight','Bold','FontSize',10,'Units','normalized','Enable','Off','Position',[0.8 0.6 0.15 0.075]);

%% Realtime DAQ Checkbox
myhandles.RTcheckbox = uicontrol(emgDAQ.Fig,'Style','checkbox','String','Realtime DAQ','Units','Normalized','Enable','Off','Interruptible','on','Callback',@RT_Callback,'Position',[0.775 0.53 0.125 0.05],'FontSize',10);
myhandles.RTdaq = 0;

%% TRIAL NUMBER PANEL
% This panel will iterate the trial number every time that you press acquire
numtrPanel = uipanel('HighlightColor','[0.5 0 0.9]','Position',[0.775 0.2 0.2 0.3]);
tNumTr = uicontrol(numtrPanel,'Style','text','String','Trial Number','HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.68,0.5,0.2],'FontSize',10);
myhandles.TrialNumber = uicontrol(numtrPanel,'Style','edit','HorizontalAlignment','Center','Callback',@TrialNumber_Callback,'String',num2str(myhandles.itrial),'Units','normalized','Position',[0.55 0.8 0.4 0.1],'FontSize',10);
myhandles.currdir = uicontrol(numtrPanel,'Style','text','String',sprintf('Data will be saved in \n%s',pwd),'HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.001,0.9,0.6],'FontSize',10);

%% Plots panel
% Create axes objects for data plots by calling CreateAxes (based on awesomePlots in TargetDAQ_Updated)
[myhandles.Axis,myhandles.Line,myhandles.Label]=createAxes(myhandles.nChan,myhandles.ChannelNames);

%% MENU ITEMS FOR GUI
%Setup Menu
mSetup = uimenu(emgDAQ.Fig,'Label','Setup');

mSubjInfo= uimenu(mSetup,'Label','Subject Information','Callback',{@subjInfo,myhandles});
% Plot/channel names are hard coded in this version.
% mPlots_1 = uimenu(mPlots,'Label','Plot Names','Callback',@dataCreation);
mSaveSetup = uimenu(mSetup,'Label','Save Setup','Callback',@saveSetup);
mLoadSetup = uimenu(mSetup,'Label','Load Setup','Callback',@loadSetup);

emgDAQ.Fig.Visible = 'on';

% Target acquisition and feedback is disabled in this version.
% Target Menu
% mTarget = uimenu(emgDAQ.Fig,'Label','Target');
% DisplayTarget_menu = uimenu(mTarget,'Label','Display Target','Callback',@Display_Target_Callback,'Enable','Off');
% TargetOptions_menu = uimenu(mTarget,'Label','Target Options','Enable','Off','Callback',@tarOpt_Callback);

%% Program Functions
%  Function to create the axes objects for data display
    function [hAxis,hLine,hLabel]=createAxes(nChan,yaxlabel)
        % Create panel of fixed size
        plotPanel = uipanel('Tag','plotPanel','Position',[0.01,0.01,0.76,0.98]);
        nrows=ceil(nChan/2);
        ncol=2; % Arrange plots in two columns
        axheight=0.98/nrows;
        if nChan>1, axwidth=0.44; else axwidth=0.98; end
        axposx=[0.055, 0.55];
        hAxis=zeros(nChan,1);   % Plot axes
        hLabel=zeros(nChan,1);  % Plot ylabels
        hLine=zeros(nChan,2);  % [rectifiedEMG envelopeEMG] traces -
        for i=1:nChan
            hAxis(i)=axes(plotPanel,'Position',[axposx(2-mod(i,2)),(nrows-ceil(i/2))*axheight,axwidth,axheight],'XTickLabel','');
            hLabel(i) = uicontrol(plotPanel,'Style','text','BackgroundColor','w','HorizontalAlignment','left','Units','normalized','FontSize',9,'Position',[axposx(2-mod(i,2))+0.3,(nrows-ceil(i/2))*axheight+axheight-0.03,0.14,0.025]);
            ylabel(hAxis(i), yaxlabel{i},'Color','[0.5 0 0.9]','FontWeight','bold');
            hLine(i,1)=line('Parent',hAxis(i),'Xdata',[],'Ydata',[],'Color','b','LineWidth',2);
            hLine(i,2)=line('Parent',hAxis(i),'Xdata',[],'Ydata',[],'Color','r','LineWidth',2);
        end
    end

% Realtime DAQ checkbox callback. Set daq to continuous acquisition, reset the line objects
% and start the background acquisition.
    function RT_Callback(source,event)
        myhandles.RTdaq = source.Value;
        % Change DAQ object to continuous time acquisition
        if myhandles.RTdaq
            % Change DAQ object to continuous time acquisition
            myhandles.s.IsContinuous = true;
            myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
            for i=1:myhandles.nChan
                set(myhandles.Line(i,1),'XData',[],'YData',[]);
                set(myhandles.Line(i,2),'XData',[],'YData',[]);
            end
            startBackground(myhandles.s);
        else
            stop(myhandles.s);
            myhandles.s.IsContinuous = false;
            myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALLBACKS FOR GUI Menu Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % Subject Information Menu Figure - collect participant ID and any additional information
    % AMA - Other info that needs to be collected here???
    function subjInfo(source,event,handles)
        % Create figure and add text and edit components
        scrsz = get(groot,'ScreenSize');
        h = figure('Name','Participant Information','NumberTitle','off','OuterPosition',[0.7*scrsz(3) 0.4*scrsz(4) 0.3*scrsz(3) 0.6*scrsz(4)],...
            'MenuBar','none','ToolBar','none');
        set(h,'CloseRequestFcn',{@subjInfo_Close,h});
%         subj_fig.Position = [100,100,400,500];
        fighandles=guidata(h);
        uicontrol(h,'Style','text','FontSize',12,'String','Participant Information','HorizontalAlignment','Center','Units','normalized','Position',[.05,.85,.9,.125]);

        uicontrol(h,'Style','text','FontSize',10,'String','Participant ID','HorizontalAlignment','Left','Units','normalized','Position',[.05,.75,.2,.125]);
        fighandles.hsubjid=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.83125,.3125,.05],'Callback',@subjInfo_ID);
        uicontrol(h,'Style','text','FontSize',10,'String','Experimental Protocol','HorizontalAlignment','Left','Units','normalized','Position',[.05,.65,.2,.125]);
        fighandles.hprotocol=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.72125,.5,.05],'Callback',@subjInfo_ExpProt);

        uicontrol(h,'Style','text','FontSize',10,'String','Notes','HorizontalAlignment','Left','Units','normalized','Position',[.05,.54,.4,.125]);
        fighandles.hnotes=uicontrol(h,'Style','edit','FontSize',10,'HorizontalAlignment','Left','Units','normalized','Max',10,'Min',0,'Visible','on','Position',[.05,.325,.9,.3],'Callback',@SubjInfo_Notes);
%         pbZeroFM = uicontrol(targetDAQ.Fig,'Style','pushbutton','Callback',@Zero_FM_Callback,'String','Zero FM','FontWeight','Bold','FontSize',9,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.825 0.400 0.10 0.05]);
    
        if isfield(myhandles,'subjID')
            set(fighandles.hsubjid,'String',myhandles.subjID); 
            set(fighandles.hprotocol,'String',myhandles.Protocol); 
            set(fighandles.hnotes,'String',myhandles.Notes); 
        end
        
        guidata(h,fighandles);

        uicontrol(h,'Style','pushbutton','Callback',{@subjInfo_Close,h,fighandles},'String','OK','FontSize',12,'Units','normalized','HorizontalAlignment','Center','Position',[.5,.125,.15,.1]);
        
        uiwait(h);
        delete(h)
    end

    function subjInfo_Close(source,event,varargin)
        h=varargin{1};
        if length(varargin)>1
            dlghandles=varargin{2};
            myhandles.subjID=get(dlghandles.hsubjid,'String');
            myhandles.Protocol=get(dlghandles.hprotocol,'String');
            myhandles.Notes=get(dlghandles.hnotes,'String');
            FileName_Callback('','',myhandles.subjID)
        end
        uiresume(h);
    end

    function subjInfo_ID(source,event)
        myhandles.subjID=source.String;
    end

    function subjInfo_ExpProt(source,event)
        myhandles.Protocol=source.String;
    end

    function SubjInfo_Notes(source,event)
        myhandles.Notes=source.String;
    end

    %% Function to save the experiment setup in a file named subjID_Setup.mat
    function saveSetup(source,event)
        if isfield(myhandles,'subjID')
            setup.subject=struct('Date',date,'subjID',myhandles.subjID,'Protocol',myhandles.Protocol,'Notes',myhandles.Notes);
            setup.daq=struct('nChan',myhandles.nChan,'Channels',myhandles.Channels,'ChannelNames',{myhandles.ChannelNames},...
                'sRate',myhandles.sRate,'sTime',myhandles.sTime);
            if isfield(myhandles,'datadir'), [fname,pname]=uiputfile('','Save the setup file (*.mat)',[myhandles.datadir '\' myhandles.subjID '_Setup.mat']);
            else [fname,pname]=uiputfile('','Save the setup file (*.mat)',[myhandles.subjID '_Setup.mat']);
            end
            if fname~=0, save(fullfile(pname,fname),'setup');
            else
                warndlg('Setup file was not saved','Save Setup')
            end
        else
            warndlg('Please fill the participant information form first','Save Setup');
        end
    end

    %% Function to load experiment setup
    function loadSetup(source,event)
        if isfield(myhandles,'datadir'), [fname,pname] = uigetfile([myhandles.datadir '\*.mat'],'Select the setup file (*.mat)');
        else [fname,pname] = uigetfile([pwd '\*.mat'],'Select the setup file (*.mat)');
        end
        if fname~=0 
            load(fullfile(pname,fname),'setup');
            if exist('setup')
                setnames=fieldnames(setup);
                for i=1:length(setnames)   % Don't do the same for the filter settings
%                     if ~strcmp(setnames{i},'filters')
                    eval(['subsetnames=fieldnames(setup.' setnames{i} ');'])
                    for j=1:length(subsetnames)
                        eval(['myhandles.' subsetnames{j} '=setup.' setnames{i} '.' subsetnames{j} ';'])
                    end
%                     end
                end           
            end

            myhandles.sRate_Edit.String=num2str(myhandles.sRate);
            myhandles.sTime_Edit.String=num2str(myhandles.sTime);
            myhandles.nChan_Edit.String=num2str(myhandles.nChan);
            % Adjust # of panels
            [myhandles.Axis,myhandles.Line,myhandles.Label]=createAxes(myhandles.nChan,myhandles.ChannelNames);

%           AMA - There is currently no option for changing the channel names, it
%           is hardcoded. Uncomment this if this option is added to the program
%             for i=1:length(myhandles.ChannelNames)
%                 eval(['set(myhandles.Label' num2str(i) ', ''String'',handles.chnames{i})'])
%             end

%             eChannels_Callback(h, [], myhandles) % Revise the arguments

        end
    end

%% Callbacks for DAQ Parameters Panel
% function to read in the # of Channels
    function nChan_Callback(source,event)
        newNumChan = str2num(source.String);
        source.UserData = newNumChan; % ???
        %         numChan = myhandles.nChan;
        if newNumChan ~= myhandles.nChan
            myhandles.nChan=newNumChan;
            myhandles.Channels=0:myhandles.nChan-1;
            
           % Check to make sure specified # of channels is within allowable range
            if newNumChan < 1 || newNumChan > myhandles.maxChannels
%                 max = myhandles.maxChannels;
                warning = 'O_o. incorrect number of channels entered- min of 1 and max of %d needed for proper usage. Please re-enter appropriate value.';
                str = sprintf(warning,myhandles.maxChannels);
                errordlg(str,'User Error');
            end
            % Update the plots based on the new # of channels
            [myhandles.Axis,myhandles.Line,myhandles.Label]=createAxes(myhandles.nChan,myhandles.ChannelNames);
            
        end
    end

% Sampling Rate
    function SampRate_Callback(source,event)
        sampRate = str2num(source.String);
%         source.UserData = sampRate;
        myhandles.sRate = sampRate;
        if isfield(myhandles,'s'), 
            myhandles.s.sRate=myhandles.sRate; 
            pbDaqInit_Callback([],[]); 
        end
    end

% Sampling Time
    function SampTime_Callback(source,~)
        sampTime = str2num(source.String);
%         source.UserData = sampTime;
        myhandles.sTime = sampTime;
        if isfield(myhandles,'s'), 
            myhandles.s.DurationInSeconds=myhandles.sRate; 
            pbDaqInit_Callback([],[]); 
        end
    end

% function to read in the file name
    function FileName_Callback(source,event,varargin)
        if length(varargin)==1, source.String = myhandles.subjID; end % Called from subjInfo_Close
        myhandles.filename = source.String;
        myhandles.itrial=1; myhandles.TrialNumber.String=num2str(myhandles.itrial);
        
        if ~isfield(myhandles,'datadir')
            myhandles.datadir = uigetdir(pwd,'Select Directory to Save Data'); 
            set(myhandles.currdir,'String',myhandles.datadir);
        end
        
        if exist([myhandles.datadir '\' myhandles.filename num2str(myhandles.itrial) '.mat'],'file')==2
            response=questdlg('The data file already exists. Do you want to overwrite it?','TargetDAQ','Yes','No','No');
            if strcmp(response,'No')
                prompt={'Enter the file name:','Enter the trial number:'};
                def={myhandles.filename num2str(myhandles.itrial)};
                dlgTitle='Input File Name';
                lineNo=1;
                answer=inputdlg(prompt,dlgTitle,lineNo,def);
                myhandles.filename=answer{1};set(myhandles.fileName_Edit,'String',myhandles.filename);
                myhandles.itrial=str2num(answer{2}); set(myhandles.TrialNumber,'String',num2str(myhandles.itrial))
            end
        end
    end

    function TrialNumber_Callback(source,event)
        myhandles.itrial=str2num(source.String);
%         setappdata(emgDAQ.Fig,'itrial',myhandles.itrial); %Is this line necessary?
        if exist([myhandles.filename num2str(myhandles.itrial) '.mat'],'file')==2,
            response=questdlg('The data file already exists. Do you want to overwrite it?','TargetDAQ','Yes','No','No');
            if strcmp(response,'No')
                prompt={'Enter the file name:','Enter the trial number:'};
                def={myhandles.filename num2str(myhandles.itrial)};
                dlgTitle='Input File Name';
                lineNo=1;
                answer=inputdlg(prompt,dlgTitle,lineNo,def);
                myhandles.filename=answer{1};set(myhandles.fileName_Edit,'String',myhandles.filename);
                myhandles.itrial=str2num(answer{2}); set(myhandles.TrialNumber,'String',num2str(myhandles.itrial))
            end
        end

    end

%% CALLBACKS FOR GUI BUTTONS
% InitDAQ Pushbutton Callback
    function pbDaqInit_Callback(source,event)
        % Delete DAQ objects if they already exist to avoid errors
        if isfield(myhandles,'s'), delete(myhandles.s); myhandles=rmfield(myhandles, 's'); end
        % Create regular DAQ object
        myhandles.s = daq.createSession('ni');
        % Add analog input channels specified in myhandles.Channels
        myhandles.s.addAnalogInputChannel(myhandles.daqDevice,floor(myhandles.Channels/8)*16+rem(myhandles.Channels,8),'Voltage');
        % Set DAQ object sampling rate and time
        myhandles.s.Rate = myhandles.sRate;
        myhandles.s.DurationInSeconds = myhandles.sTime;
        % Add listener object
        lh = addlistener(myhandles.s, 'DataAvailable', @localTimerAction);
        myhandles.pbAcquire.Enable = 'On';
        myhandles.RTcheckbox.Enable = 'On';
    end

% Acquire Pushbutton callback
    function pbAcquire_Callback(source,event)
        source.Enable = 'off';
        % If running real time daq, stop first
        myhandles.RTcheckbox.Value=0;
        RT_Callback(myhandles.RTcheckbox,event)
%         if myhandles.RTdaq
%             stop(myhandles.s);
%             myhandles.s.IsContinuous = false;
%             myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
%             myhandles.RTcheckbox.Value = 0;
%             myhandles.RTdaq = 0;
%          end
        myhandles.RTcheckbox.Enable = 'off'; % disable realtime checkbox
        
        [data,t]=startForeground(myhandles.s);
        displayData(myhandles.nChan, t, data, myhandles.sRate, [myhandles.datadir,'\',myhandles.filename,num2str(myhandles.itrial),'.mat']); % AMA 7/2/19
        myhandles.itrial = myhandles.itrial+1;
        myhandles.TrialNumber.String = num2str(myhandles.itrial);
        source.Enable = 'on';
        myhandles.RTcheckbox.Enable = 'on';
    end

% Function to plot data at the end of the data acquisition
    function displayData(nChan, t, data, sRate, filename)
    % Assumes all the data is EMG. If adding forces and torques, need to
    % include data analysis here.
        % Compute the rectified average EMG
        meandata=meanfilt(abs(data),0.1*sRate);
        
        for i=1:nChan
%             get(myhandles.Line(i,1),'XData')
%             get(myhandles.Line(i,2),'XData')
            set(myhandles.Line(i,1),'XData',t,'YData',abs(data(:,i))); 
            set(myhandles.Line(i,2),'XData',t,'YData',meandata(:,i));
            set(myhandles.Label(i),'String',num2str(max(meandata(:,i)),'%.3f  '));
        end
        drawnow
         % AMA - only save the time and data matrices. All the other
         % parameters should be saved in a setup file
        save(filename,'t','data');
    end

    % AMA - function to display data in real time and play beep at 200 ms 
    function localTimerAction(source, event)
        if ~myhandles.RTdaq
            if source.ScansAcquired == 0.2*myhandles.sRate, play(myhandles.beep, [1 myhandles.beep.SampleRate*0.5]); end
        else
            localDisplayData(myhandles.timebuffer,event.Data,myhandles.nChan)
        end
    end

% Function to display data in real time - should probably be merged into
% localTimerAction.
    function localDisplayData(t,data,nChan)
        blocksize=size(data,1);
        databuffer=getappdata(emgDAQ.Fig,'databuffer');
        databuffer=[data;databuffer(1:end-blocksize,:)];
        setappdata(emgDAQ.Fig,'databuffer',databuffer)
        for i=1:nChan
            set(myhandles.Line(i,1),'XData',t,'YData',databuffer(:,i));
            set(myhandles.Label(i),'String',num2str([max(databuffer(:,i)) min(databuffer(:,i))],'%.3f  %.3f'));
        end
        drawnow
    end

    function aKeyPress_Callback(source,event)
        switch event.Key
            case 'a'
                pbAcquire_Callback(myhandles.pbAcquire,[])
        end
    end

% Function to cleanup once GUI is closed
    function closeMainGUI(source,event)
        disp('Goodbye :)');
        fclose('all');
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OTHER FUNCTIONS FROM TARGETDAQ_UPDATE THAT MAY BE USEFUL
% Option to set plot/channel names is disabled in this version. This
% function would need to be revised
%     function chGUI(updatedNumChan)
%         %This GUI stems off of the main GUI and allows you to create a list
%         %of which channels you'd like to read from
%         myhandles.placeHolder = myhandles.Channels;
%         
%         channelList = myhandles.Channels;
%         channelNameList = myhandles.NameChannels;
%         
%         numChan = updatedNumChan;
%         myhandles.nChan = numChan;
%         totPossibleChan = myhandles.maxChannels;
%         armChoice = myhandles.armChoice;
%         armSwitch = myhandles.armSwitched;
%         
%         if armSwitch == 1
%             if strcmp(armChoice,'left')
%                 channels = myhandles.lChannels;
%                 chanNames = myhandles.lNameChannels;
%             else
%                 channels = myhandles.rChannels;
%                 chanNames = myhandles.rNameChannels;
%             end
%             
%             channelList = [];
%             channelNameList = {};
%         else
%             if numChan == 6
%                 if strcmp(armChoice,'left')
%                     channels = myhandles.lChannels;
%                     chanNames = myhandles.lNameChannels;
%                 else
%                     channels = myhandles.rChannels;
%                     chanNames = myhandles.rNameChannels;
%                 end
%                 
%                 chanArray = channels;
%                 chanList = sort(channels);
%                 
%                 myhandles.chanTypeList = cell(1,myhandles.nChan);
%                 
%                 for i = 1:numChan
%                     chanVal = chanList(i);
%                     if find(chanVal==chanArray)
%                         ind = find(chanVal==chanArray);
%                         myhandles.chanTypeList{i} = num2str(ind);
%                     else
%                         myhandles.chanTypeList{i} = num2str(8);
%                     end
%                 end
%                 
%                 myhandles.noStrChanTypeList = str2double(myhandles.chanTypeList);
%             else
%                 channels = [];
%                 chanNames = {};
%                 % || myhandles.oldNChan == 6
%                 if myhandles.loadFile == 1 || myhandles.initChSelect == 1
%                     channels = [];
%                     chanNames = [];
%                 else
%                     if myhandles.initChSelect == 0
%                         if strcmp(armChoice,'left')
%                             channels = myhandles.lChannels;
%                             chanNames = myhandles.lNameChannels;
%                         else
%                             channels = myhandles.rChannels;
%                             chanNames = myhandles.rNameChannels;
%                         end
%                         myhandles.Channels = channels;
%                     else
%                         channels = [];
%                         chanNames = [];
%                     end
%                 end
%             end
%         end
%         
%         
%         totChannels = channels;
%         totChanNames = chanNames;
%         
%         if numChan > 6
%             f1 = figure('Name','Channel Selection Menu','NumberTitle', 'off');
%             f1.Position = [100, 100, 600, 200];
%             f1.MenuBar = 'none';
%             %             f1.Name = 'Channel Selection Menu';
%             f1.DeleteFcn = @closeChGUI;
%             
% %             hLine(4)=line('Parent',targetGUI.Axes1,'Xdata',xt(:,1),'Ydata',xt(:,2),'Color','r','LineWidth',2);
% 
%             chNumber = 0;
%             maxChan = myhandles.maxChannels;
%             
%             for i = 1:4
%                 for j = 1:7
%                     if chNumber < maxChan
%                         chButton(chNumber+1) = uicontrol(f1,'Style','checkbox','String',['Channel',' ',num2str(chNumber)],'Units','Normalized','Callback',@cSelect,'Position',[0.0125+(0.137*(j-1)),0.8675-(0.175*(i-1)), 0.125 0.15],'UserData',num2str(chNumber));
%                         if find(chNumber==totChannels)
%                             chButton(chNumber+1).Value = 1;
%                         end
%                         chNumber = chNumber + 1;
%                     end
%                 end
%             end
% 
%             myhandles.pbChSelect = uicontrol(f1,'Style','pushbutton','Callback',@pbChSelect_Callback,'String','Initialize Channels','Units','normalized','Position',[0.25 0.05 0.5 0.2]);            
% 
%             for i = 1:totPossibleChan
%                 button = chButton(i);
%                 name = button.String;
%                 for j = 1:length(channelNameList)
%                     if strcmp(channelNameList(j),name)
%                         button.Value = 1;
%                     end
%                 end
%             end       
%             
%             addChan = channelList;
%             totChannels = [channels,addChan];
%             totChanNames = [chanNames,channelNameList];
%         end
%         
%         myhandles.Channels = totChannels;
%         myhandles.NameChannels = totChanNames;
% %         myhandles.armSwitched = 0;
%     end

% Timer is disabled in this version
% %Timer Value
%     function TimerVal_Callback(source,event)
%         %         myhandles.kinematicsDAQ
%         timeDelay = str2num(source.String);
%         source.UserData = timeDelay;
%         myhandles.Timer = timeDelay;
%     end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTIONS FROM TARGETDAQ_UPDATE THAT MAY BE USEFUL IF INTRODUCING JR3 DAQ AND TARGET DISPLAY

% %Callbacks for Experimental Setup Panel if you are recording from
% loadcell. Need to be revised
% %Abduction Angle
%     function abdAngle_Callback(source,event)
%         abdAngleNum = str2num(source.String);
%         source.UserData = abdAngleNum;
%         myhandles.abdAngle = abdAngleNum;
%     end
% 
% %Elbow Flexion Angle
%     function EFAngle_Callback(source,event)
%         EFAngleNum = str2num(source.String);
%         source.UserData = EFAngleNum;
%         myhandles.efAngle = EFAngleNum;
%     end
% 
% %Arm Length
%     function ArmLength_Callback(source,event)
%         ALengthNum = str2num(source.String);
%         source.UserData = ALengthNum;
%         myhandles.aLength = ALengthNum;
%     end
% 
% %Forearm length
%     function FArmLength_Callback(source,event)
%         FALengthNum = str2num(source.String);
%         source.UserData = FALengthNum;
%         myhandles.faLength = FALengthNum;
%     end
% 
% %Z-offset
%     function ZOffset_Callback(source,event)
%         zOffNum = str2num(source.String);
%         source.UserData = zOffNum;
%         myhandles.zOffset = zOffNum;
%     end
%Right or Left Arm
%     function rbExpCallback(rbg,event)
%         sbnew = event.NewValue.String;
%         sbold = event.OldValue.String;
%         %         if ~strcmp(sbnew,sbold) && (initChan == 1)
%         if ~strcmp(sbnew,sbold)
%             myhandles.armSwitched = 1;
%             myhandles.pbAcquireVal = 0;
%         end
%         ArmBG = rbg.SelectedObject.String;
%         rbg.UserData = ArmBG;
%         myhandles.armChoice = ArmBG;
%     end

% Target not included in this version
% Functions to create the GUI where you can set the target options. These
% functions need to be revised
%     function tarOpt_Callback(source,event)
%         f2 = figure(3);
%         
%         f2.Position = [100,100,500,400];
%         f2.MenuBar = 'none';
%         f2.Name = 'Target Options Menu';
%         
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Cursor Options','FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.0875,.775,.2,.15]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Cursor Size (Nm)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.675,.2,.15]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Pie Width (Nm)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.6,.2,.15]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Dial Zero (Deg)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.525,.2,.15]);
%         etTar1 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Cursor_size_Callback,'HorizontalAlignment','Left','String',myhandles.Cursor_s,'Units','normalized','Position',[.2375,.7875,.10,.0375]);
%         etTar2 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Pie_size_Callback,'HorizontalAlignment','Left','String',myhandles.Pie_size,'Units','normalized','Position',[.2375,.7125,.10,0.0375]);
%         etTar3 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@theta_zero_Callback,'HorizontalAlignment','Left','String',myhandles.th_zero,'Units','normalized','Position',[.2375,.6375,.10,0.0375]);
%         
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Target Options (Nm)','FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.0325,.475,.3,.1]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Size','HorizontalAlignment','Left','Units','normalized','Position',[.025,.425,.15,.05]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Horizontal','HorizontalAlignment','Left','Units','normalized','Position',[.025,.35,.15,.05]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Vertical','HorizontalAlignment','Left','Units','normalized','Position',[.025,.275,.15,.05]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Rotation','HorizontalAlignment','Left','Units','normalized','Position',[.025,.20,.15,.05]);
%         tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Zoom','HorizontalAlignment','Left','Units','normalized','Position',[.025,.125,.15,.05]);
%         
%         etTar4 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_size_Callback,'HorizontalAlignment','Left','String',myhandles.Target_s,'Units','normalized','Position',[.2375,.4375,.10,.0375]);
%         etTar5 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_x_Callback,'HorizontalAlignment','Left','String',num2str(myhandles.Target_x),'Units','normalized','Position',[.2375,.3625,.10,0.0375]);
%         etTar6 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_y_Callback,'HorizontalAlignment','Left','String',num2str(myhandles.Target_y),'Units','normalized','Position',[.2375,.2875,.10,0.0375]);
%         etTar7 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_theta_Callback,'HorizontalAlignment','Left','String',myhandles.Target_t,'Units','normalized','Position',[.2375,.2125,.10,0.0375]);
%         myhandles.etTar8 = uicontrol(f2,'Style','edit','FontSize',9,'Enable','off','Callback',@Target_zoom_Callback,'HorizontalAlignment','Left','String',myhandles.Target_z,'Units','normalized','Position',[.2375,.1375,.10,0.0375]);
%         
%         tarZoom = uicontrol(f2,'Style','checkbox','String','Zoom Feature','Callback',@zoomEnableCB,'Units','normalized','Position',[0.5 0.06125 0.25 0.05]);
%         [x,map] = imread('Target.JPG');
%         tarFigButton = uicontrol(f2,'Style','pushbutton','Units','normalized','Position',[0.4,0.25,0.55,0.55],'cdata',x,'Callback',@tarPBCB);
%         
%         ok_button = uicontrol(f2,'Style','pushbutton','Callback',@pbOkTarMenu_Callback,'String','OK','Units','normalized','Position',[0.825 0.1 0.15 0.05]);
%         cancel_button = uicontrol(f2,'Style','pushbutton','Callback',@pbCancelTarMenu_Callback,'String','Cancel','Units','normalized','Position',[0.825 0.0375 0.15 0.05]);
%         
%     end
% 
%     function zoomEnableCB(source,event)
%         val = source.Value;
%         button = myhandles.etTar8;
%         
%         if val == 1
%             button.Enable = 'on';
%             myhandles.zoomOpt = 1;
%         else
%             button.Enable = 'off';
%             myhandles.zoomOpt = 0;
%         end
%     end
% 
%     function tarPBCB(source,event)
%         f3 = figure(4);
%         f3.Position = [75,75,350,300];
%         f3.MenuBar = 'none';
%         f3.Name = 'More Target Options Menu';
%         
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Horizontal','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.575,.25,.15]);
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Vertical','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.45,.25,.15]);
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Dial','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.325,.25,.15]);
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Zoom','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.2,.25,.15]);
%         
%         tPopUp1 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',4,'Callback',@xtorque_Callback,'Units','normalized','Position',[0.4,0.575,0.25,0.15]);
%         tPopUp2 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',1,'Callback',@ytorque_Callback,'Units','normalized','Position',[0.4,0.45,0.25,0.15]);
%         tPopUp3 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',2,'Callback',@thtorque_Callback,'Units','normalized','Position',[0.4,0.325,0.25,0.15]);
%         tPopUp4 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',3,'Callback',@ztorque_Callback,'Units','normalized','Position',[0.4,0.20,0.25,0.15]);
%         
%         tOK = uicontrol(f3,'Style','pushbutton','String','OK','FontSize',11,'Callback',@moreTarOK,'Units','normalized','Position',[0.225,0.075,0.2,0.125]);
%         tCancel = uicontrol(f3,'Style','pushbutton','String','Cancel','FontSize',11,'Callback',@moreTarCancel,'Units','normalized','Position',[0.525,0.075,0.2,0.125]);
%         
%         tCheck1 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@xlock_Callback,'Position',[.75,.6125,.25,.15]);
%         tCheck2 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@ylock_Callback,'Position',[.75,.4875,.25,.15]);
%         tCheck3 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@thlock_Callback,'Position',[.75,.3625,.25,.15]);
%         tCheck4 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@zlock_Callback,'Position',[.75,.2425,.25,.15]);
%         
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'FontWeight','Bold','String','DOF','Units','normalized','Position',[.45,0.75,.15,.1]);
%         tTar = uicontrol(f3,'Style','text','FontSize',12,'FontWeight','Bold','String','Lock','Units','normalized','Position',[.7,0.75,.15,.1]);
%         
%         if myhandles.moreTarOK == 1
%             tPopUp1.Value = myhandles.torquemask(1);
%             tPopUp2.Value = myhandles.torquemask(2);
%             tPopUp3.Value = myhandles.torquemask(3);
%             tPopUp4.Value = myhandles.torquemask(4);
%             
%             tCheck1.Value = myhandles.lockmask(1);
%             tCheck2.Value = myhandles.lockmask(2);
%             tCheck3.Value = myhandles.lockmask(3);
%             tCheck4.Value = myhandles.lockmask(4);
%             
%         else
%             if myhandles.moreTarCancel == 1
%                 tPopUp1.Value = myhandles.prevtorquemask(1);
%                 tPopUp2.Value = myhandles.prevtorquemask(2);
%                 tPopUp3.Value = myhandles.prevtorquemask(3);
%                 tPopUp4.Value = myhandles.prevtorquemask(4);
%                 
%                 tCheck1.Value = myhandles.prevlockmask(1);
%                 tCheck2.Value = myhandles.prevlockmask(2);
%                 tCheck3.Value = myhandles.prevlockmask(3);
%                 tCheck4.Value = myhandles.prevlockmask(4);
%             else
%                 tPopUp1.Value = 4;
%                 tPopUp2.Value = 1;
%                 tPopUp3.Value = 2;
%                 tPopUp4.Value = 3;
%                 
%                 tCheck1.Value = 0;
%                 tCheck2.Value = 0;
%                 tCheck3.Value = 0;
%                 tCheck4.Value = 0;
%             end
%             
%         end
%     end
% 
%     function moreTarOK(source,event)
%         setValues = [4,1,2,3];
%         for i = 1:length(myhandles.torquemask)
%             if myhandles.torquemask(i) == 0
%                 myhandles.torquemask(i) = setValues(i);
%             end
%         end
%         myhandles.prevtorquemask = myhandles.torquemask;
%         myhandles.prevlockmask = myhandles.lockmask;
%         
%         myhandles.moreTarOK = 1;
%         myhandles.moreTarCancel = 0;
%         close(gcf);
%     end
% 
%     function moreTarCancel(source,event)
%         myhandles.torquemask = myhandles.prevtorquemask;
%         myhandles.lockmask = myhandles.prevlockmask;
%         myhandles.moreTarOK = 0;
%         myhandles.moreTarCancel = 1;
%         close(gcf);
%     end
% 
%     function Cursor_size_Callback(source,event)
%         cursSize = str2num(source.String);
%         source.UserData = cursSize;
%         myhandles.Cursor_s = cursSize;
%     end
% 
%     function Pie_size_Callback(source,event)
%         pieWidth = str2num(source.String);
%         source.UserData = pieWidth;
%         myhandles.Pie_size = pieWidth;
%     end
% 
%     function theta_zero_Callback(source,event)
%         dialZero = str2num(source.String);
%         source.UserData = dialZero;
%         myhandles.th_zero = dialZero;
%     end
% 
%     function Target_size_Callback(source,event)
%         tarSize = str2num(source.String);
%         source.UserData = tarSize;
%         myhandles.Target_s = tarSize;
%     end
% 
%     function Target_x_Callback(source,event)
%         tarHorizon = str2num(source.String);
%         source.UserData = tarHorizon;
%         myhandles.Target_x = tarHorizon;
%     end
% 
%     function Target_y_Callback(source,event)
%         tarVert = str2num(source.String);
%         source.UserData = tarVert;
%         myhandles.Target_y = tarVert;
%     end
% 
%     function Target_theta_Callback(source,event)
%         tarRot = str2num(source.String);
%         source.UserData = tarRot;
%         myhandles.Target_t = tarRot;
%     end
% 
%     function Target_zoom_Callback(source,event)
%         tarZoom = str2num(source.String);
%         source.UserData = tarZoom;
%         myhandles.Target_z = tarZoom;
%     end
% 
%     function xlock_Callback(source,event)
%         myhandles.lockmask(1) = source.Value;
%         source.UserData = myhandles.lockmask;
%     end
% 
%     function ylock_Callback(source,event)
%         myhandles.lockmask(2) = source.Value;
%         source.UserData = myhandles.lockmask(2);
%     end
% 
%     function thlock_Callback(source,event)
%         myhandles.lockmask(3) = source.Value;
%         source.UserData = myhandles.lockmask(3);
%     end
% 
%     function zlock_Callback(source,event)
%         myhandles.lockmask(4) = source.Value;
%         source.UserData = myhandles.lockmask(4);
%     end
% 
%     function xtorque_Callback(source,event)
%         myhandles.torquemask(1) = source.Value;
%         source.UserData = myhandles.torquemask(1);
%     end
% 
%     function ytorque_Callback(source,event)
%         myhandles.torquemask(2) = source.Value;
%         source.UserData = myhandles.torquemask(2);
%     end
% 
%     function thtorque_Callback(source,event)
%         myhandles.torquemask(3) = source.Value;
%         source.UserData = myhandles.torquemask(3);
%     end
% 
%     function ztorque_Callback(source,event)
%         myhandles.torquemask(4) = source.Value;
%         source.UserData = myhandles.torquemask(4);
%     end
% 
%     function pbOkTarMenu_Callback(source,event)
%         myhandles.TarOK = 1;
%         myhandles.TarCancel = 0;
%         tempArray = [myhandles.Target_x, myhandles.Target_y];
%         if length(tempArray) < 2 || length(tempArray) > 2
%             errordlg('The horizontal and vertical targets should have one element each (e.g. [30 45])');
%         else
%             myhandles.prevTarValues = [myhandles.Cursor_s, myhandles.Pie_size, myhandles.th_zero, myhandles.Target_s, myhandles.Target_x, myhandles.Target_y, myhandles.Target_t, myhandles.Target_z];
%             close(gcf);
%         end
%     end
% 
%     function pbCancelTarMenu_Callback(source,event)
%         myhandles.TarCancel = 1;
%         myhandles.TarOK = 0;
%         myhandles.Cursor_size = myhandles.prevTarValues(1);
%         myhandles.Pie_size = myhandles.prevTarValues(2);
%         myhandles.th_zero = myhandles.prevTarValues(3);
%         myhandles.Target_s = myhandles.prevTarValues(4);
%         myhandles.Target_x = myhandles.prevTarValues(5);
%         myhandles.Target_y = myhandles.prevTarValues(6);
%         myhandles.Target_t = myhandles.prevTarValues(7);
%         myhandles.Target_z = myhandles.prevTarValues(8);
%         close(gcf);
%     end

% AMA- This may be needed for displaying a target in real time
%     function Display_Target_Callback(source,event)
%         if strcmp(source.Checked,'off')
%             source.Checked = 'on';
%             %             TargetOptions_menu.Enable = 'On';
%             myhandles.targetGUI = createDataCaptureUI();
%             RTTargetcheckbox.Enable = 'on';
%             RTForceCB.Enable = 'off';
%             triggerCB.Enable = 'On';
%             if isvalid(s3)
%                 delete(s3);
%             end
%             
%             s3 = daq.createSession('ni');
%             DAQInit(s3,1);
%         else
%             source.Checked = 'off';
%             %             TargetOptions_menu.Enable = 'Off';
%             try
%                 close('Target GUI');
%             end
%             RTTargetcheckbox.Enable = 'off';
%             RTForceCB.Enable = 'on';
%         end
%     end

% AMA - Real time target is disabled in this version. Code is from if TargetDAQ
% and needs to be modified.
%     function RTTarget_Callback(source,event)
% %         disp('entered RT target');
%         if source.Value == 1
%             %             disp('source is 1');
%             %First release s as a session
%             release(s);
%             s3.IsContinuous = true;
%             % Specify triggered capture timespan, in seconds- test if we
%             % use 0.45 instead...
%             capture.TimeSpan = myhandles.sTime;            
%             % Specify continuous data plot timespan, in seconds
%             capture.plotTimeSpan = 0.5;
%             % Determine the timespan corresponding to the block of samples supplied
%             % to the DataAvailable event callback function.
%             callbackTimeSpan = double(s3.NotifyWhenDataAvailableExceeds)/s3.Rate;
%             % Determine required buffer timespan, seconds
%             capture.bufferTimeSpan = max([capture.plotTimeSpan, capture.TimeSpan * 3, callbackTimeSpan * 3]);
%             % Determine data buffer size
%             capture.bufferSize =  round(capture.bufferTimeSpan * s3.Rate);
%             lh = addlistener(s3, 'DataAvailable', @(src,event)collectRT(src,event,capture,0,myhandles.targetGUI));
%             myhandles.timeMat = [];
%             myhandles.collectedData = [];
%             startBackground(s3);
%         else
%             %Release s3 as a session
% %             disp('entered callback killing s3');
%             if s3.IsRunning
%                 stop(s3);
%             end
%             release(s3);
%         end
%     end

% Function to create a circle graph, used in realtime target display
%     function x = Circle(r,x0,th)
%         if nargin < 3
%             th = (0:359)';
%         end
%         
%         th = th(:)*pi/180;
%         x(:,1) = r*cos(th)+x0(1);
%         x(:,2) = r*sin(th)+x0(2);
%     end

% Function to plot realtime target data. Needs to be revised
%     function dataCapture(src, event, c, targetGUI)
%         %         persistent dataBuffer
%         
%         %         If dataCapture is running for the first time, initialize persistent vars
%         %         if event.TimeStamps(1)==0
%         %             dataBuffer = [];          % data buffer
%         %         end
%         
%         %         Store continuous acquistion data in persistent FIFO buffer dataBuffer
%         %         latestData = [event.TimeStamps, event.Data];
%         %         latestData = event.Data;
%         %         dataBuffer = [dataBuffer; latestData];
%         %         numSamplesToDiscard = size(dataBuffer,1) - c.bufferSize;
%         %         if (numSamplesToDiscard > 0)
%         %             dataBuffer(1:numSamplesToDiscard, :) = [];
%         %         end
%         data = event.Data;
%         newData = ones(size(data(:,1:6)));
%         chanTypes = myhandles.noStrChanTypeList;
%         
%         for i = 1:6
%             if find(chanTypes == i)
%                 ind = find(chanTypes == i);
%                 newData(:,i) = data(:,ind);
%             end
%         end
%         
%         meanLC = myhandles.meanLC;
%         
%         if find(chanTypes == 7)
%             forceInd = find(chanTypes==7);
%             forceData = data(:,forceInd);
%             convForceData = forceConversion(forceData-meanLC);
%         else
%             convForceData = 0*ones(size(data,1),1);
%         end
%         
%         [m,n]=size(newData(:,1:6));
%         FMhandbase = newData(:,1:6) - (diag(myhandles.FMoffset)*ones(n,m))';
%         FMhand = JR3toFM(FMhandbase(:,1:6),myhandles);
%         
%         convForceData_Base = convForceData;
%         
%         newData = [FMhand,convForceData_Base];
%         
%         M=mean(newData(:,myhandles.torquemask+3)).*(~myhandles.lockmask);
%         
%         if strcmp(myhandles.armChoice,'right'), M(1)=-M(1); end
%         
%         % Update live data plot
%         myhandles.timeMat = [myhandles.timeMat,event.TimeStamps'];
%         myhandles.collectedData = [myhandles.collectedData,event.Data'];
%         
%         if ~myhandles.zoomOpt
%             xd=Circle(myhandles.Cursor_s,M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
%             set(targetGUI.lh(1),'Xdata',myhandles.x(:,1)+M(1),'Ydata',myhandles.x(:,2)+M(2),'Color','g')
%             set(targetGUI.lh(2),'Xdata',myhandles.xp(:,1)+M(1),'Ydata',myhandles.xp(:,2)+M(2))
%             set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
%         else
%             x=Circle(myhandles.Cursor_s + M(4),M(1:2));
%             xp=Circle(myhandles.Cursor_s + M(4),[0 0],[myhandles.Pie_center+myhandles.Nmtodeg*[-myhandles.Pie_size myhandles.Pie_size]/2 myhandles.th_zero]);
%             xp=[0 0;xp(1,:);0 0;xp(2,:)];
%             xd=Circle(myhandles.Cursor_s + M(4),M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
%             set(targetGUI.lh(1),'Xdata',x(:,1),'Ydata',x(:,2),'Color','g')
%             set(targetGUI.lh(2),'Xdata',xp(:,1)+M(1),'Ydata',xp(:,2)+M(2))
%             set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
%             set(targetGUI.lh(6),'Xdata',myhandles.xz(:,1)+M(1),'Ydata',myhandles.xz(:,2)+M(2));
%         end
%         drawnow;
%     end

% Function to create the realtime target display GUI. Needs to be revised.
%     function targetGUI = createDataCaptureUI()
%         %CREATEDATACAPTUREUI Create a graphical user interface for data capture.
%         % Create a figure and configure a callback function (executes on window close)
%         targetGUI.Fig = figure('Name','Target GUI', ...
%             'NumberTitle', 'off','Resize', 'on','Position', [100 100 650 650]);
%         
%         set(targetGUI.Fig, 'DeleteFcn', @closeTargetGUI);
%         
%         % Make sure the real-time data comes to the front
%         uistack(targetGUI.Fig,'top');
%         
%         targetGUI.Axes1 = axes;
%         targetGUI.lh = plot(nan);
%         
%         title('Target Display');
%         
%         if ~isempty(targetGUI.lh)
%             delete(targetGUI.lh)
%             targetGUI.lh=[];
%         end
%         
%         myhandles.x=Circle(myhandles.Cursor_s,[0 0]);
%         myhandles.Pie_center=90;
%         
%         % Pie and dial on cursor - these objects change with time
%         if myhandles.Target_t == 0
%             myhandles.th_zero=90;
%             myhandles.Nmtodeg=180/(5*myhandles.Pie_size);
%         else
%             % If the dial zero is at 90 degrees, set the pie width to 60 degrees.
%             if myhandles.th_zero==90
%                 myhandles.Nmtodeg=60/(myhandles.Pie_size);
%             else
%                 myhandles.Nmtodeg=abs(myhandles.Pie_center-myhandles.th_zero)/abs(myhandles.Target_t);
%             end
%         end
%         
%         xp=Circle(myhandles.Cursor_s,[0 0],[myhandles.Pie_center+myhandles.Nmtodeg*[-myhandles.Pie_size myhandles.Pie_size]/2 myhandles.th_zero]);
%         myhandles.xp=[0 0;xp(1,:);0 0;xp(2,:)];
%         xd=[0 0;xp(3,:)];
%         
%         % Plot cursor
%         hLine(1)=line('Parent',targetGUI.Axes1,'Xdata',myhandles.x(:,1),'Ydata',myhandles.x(:,2),'Color','g','LineWidth',2);
%         hLine(2)=line('Parent',targetGUI.Axes1,'Xdata',myhandles.xp(:,1),'Ydata',myhandles.xp(:,2),'Color','y','LineWidth',3);
%         hLine(3)=line('Parent',targetGUI.Axes1,'Xdata',xd(:,1),'Ydata',xd(:,2),'Color','r','LineWidth',3);
%         
%         if strcmp(myhandles.armChoice,'right')
%             xt=Circle(myhandles.Target_s,[-myhandles.Target_x myhandles.Target_y]);
%         else
%             xt=Circle(myhandles.Target_s,[myhandles.Target_x myhandles.Target_y]);
%         end
%         
%         % Cone from cursor to target - this object is fixed
%         if ((myhandles.Target_y)==0 && (myhandles.Target_x==0))
%             xc=zeros(4,2);
%         else
%             d=norm([myhandles.Target_x myhandles.Target_y]);
%             if strcmp(myhandles.armChoice,'right')
%                 thc=(atan2(myhandles.Target_y,-myhandles.Target_x)+[asin(myhandles.Target_s/d) -asin(myhandles.Target_s/d)])*180/pi;
%             else
%                 thc=(atan2(myhandles.Target_y,myhandles.Target_x)+[asin(myhandles.Target_s/d) -asin(myhandles.Target_s/d)])*180/pi;
%             end
%             xc=Circle(d,[0 0],thc);xc=[0 0;xc(1,:);0 0;xc(2,:)];
%         end
%         
%         hLine(4)=line('Parent',targetGUI.Axes1,'Xdata',xt(:,1),'Ydata',xt(:,2),'Color','r','LineWidth',2);
%         hLine(5)=line('Parent',targetGUI.Axes1,'Xdata',xc(:,1),'Ydata',xc(:,2),'Color','m','LineWidth',2);
%         
%         if myhandles.zoomOpt
%             % Zoom target - this object changes with time
%             myhandles.xz=[Circle(1.1*myhandles.Target_z,[0 0]); Circle(0.9*myhandles.Target_z,[0 0])];
%             hLine(6)=line('Parent',targetGUI.axes1,'Xdata',myhandles.xz(:,1),'Ydata',myhandles.xz(:,2),'Color','w');
%         end
%         lim=round(max(abs([myhandles.Target_x myhandles.Target_y]))+1.1*myhandles.Target_s);
%         targetGUI.Axes1.XLim = [-lim lim];
%         targetGUI.Axes1.YLim = [-lim lim];
%         set(targetGUI.Fig,'color','k');
%         set(gca,'Color','k');
%         targetGUI.lh = hLine;
%     end

% Function used with GUI to change channel names
%     function closeChGUI(source,event)
%         button = myhandles.pbChSelect;
%         val = button.Value;
%         if val ~= 1
%             myhandles.Channels = myhandles.placeHolder;
%             if myhandles.oldNChan ~= myhandles.nChan
%                 myhandles.nChan = myhandles.oldNChan;
%                 nChan_Edit.String = myhandles.nChan;
%             end
%         end
%         
%         try
%             g = findobj('-depth',1,'type','figure','Name','Channel Selection Menu');
%             delete(g)
%         end
%     end

%     function closeTargetGUI(source,event)
%         try
%             if isvalid(s)
%                 if s.IsRunning
%                     stop(s);
%                 end
%             end
%             
%             if isvalid(s3)
%                 if s3.IsRunning
%                     stop(s3);
%                 end
%                 delete(s3);
%             end
%             
%         catch
%             warning('The GUI was shut down this first time line 2732');
%             %             delete(dataListener);
%             %             delete(errorListener);
%         end
%         
%         try
%             DisplayTarget_menu.Checked ='off';
%             if RTTargetcheckbox.Value == 1
%                 RTTargetcheckbox.Value = 0;
%             end
%             RTTargetcheckbox.Enable = 'off';
%             RTForceCB.Enable = 'on';
%             
%             g = findobj('-depth',1,'type','figure','Name','Target GUI');
%             delete(g)
%             %             TargetOptions_menu.Enable = 'Off';
%         catch
%             warning('The GUI was shut down for the second time line 2732');
%         end
%         if s.IsRunning
%             %             disp('in the cancel and still running');
%             stop(s);
%         end
%         disp('Target off o_O');
%     end

%     function FMshe=JR3toFM(FM,handles)
%         abdAngle=handles.abdAngle*pi/180;  % degrees to rad
%         efAngle=pi-handles.efAngle*pi/180;  % degrees to rad
%         aLength=handles.aLength/1000;    % mm to m
%         faLength=handles.faLength/1000;  % mm to m
%         zOffset=handles.zOffset/1000;    % mm to m
%         
%         % Translate moments to the shoulder and elbow
%         [FMsh,FMe]=JR3toSHandE(FM,abdAngle,efAngle,aLength,faLength,zOffset,handles.armChoice,handles.sensMat);
%         %FMshe=[FMsh FMe(:,4:5)];%LCM modified 4/29 to include pronation/supination in feedack
%         FMshe=[FMsh FMe(:,4)];
%     end
end

function emgDAQR2020()
% emgDAQ Program to record EMGs while providing real time feedback of the
% signals. Based on TargetDAQ_Upgraded.
% Ana Maria Acosta 7/1/19 - Major modifications to TargetDAQ_Upgraded to
% simplify visualization,streamline acquisition and simplify code. This
% version only records EMGs.
% AMA 4/8/21 Updated code to include real time feedback of shoulder
% abduction force measured with the JR3.

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
myhandles.daqDevice = 'Dev3';
myhandles.loadFile = 0;  % What is this?
myhandles.loadFilePrev = 0; % What is this?
myhandles.nChan = 15; % default # of channels to record
myhandles.sRate = 1000; % default sampling rate
myhandles.tRate = 100; % timer rate
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
myhandles.datadir=pwd;

myhandles.max_sabdf=0;
myhandles.MVFdaq=0;

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

%% SABD MVF PANEL
mvfPanel = uipanel('HighlightColor','[0.5 0 0.9]','Position',[0.775 0.35 0.2 0.15]);
myhandles.pbZeroJR3 = uicontrol(mvfPanel,'Style','pushbutton','Callback',@pbZeroJR3_Callback,'String','ZERO JR3','FontWeight','Bold','FontSize',10,'Units','normalized','Enable','Off','Position',[0.05 0.4 0.4 0.5]);
myhandles.pbMVFdaq = uicontrol(mvfPanel,'Style','pushbutton','Callback',@pbMVFdaq_Callback,'String','SABD MAX','FontWeight','Bold','FontSize',10,'Units','normalized','Enable','Off','Position',[0.55 0.4 0.4 0.5]);
% SABD MVF
uicontrol(mvfPanel,'Style','text','String','Max SABD Force (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.01,.5,.2],'FontSize',10);
myhandles.MVF_Display = uicontrol(mvfPanel,'Style','text','String','N/A','HorizontalAlignment','left','Units','normalized','Position',[.6 .01 .3 0.2],'FontSize',10);

%% TRIAL NUMBER PANEL
% This panel will iterate the trial number every time that you press acquire
numtrPanel = uipanel('HighlightColor','[0.5 0 0.9]','Position',[0.775 0.05 0.2 0.25]);
tNumTr = uicontrol(numtrPanel,'Style','text','String','Trial Number','HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.68,0.5,0.2],'FontSize',10);
myhandles.TrialNumber = uicontrol(numtrPanel,'Style','edit','HorizontalAlignment','Center','Callback',@TrialNumber_Callback,'String',num2str(myhandles.itrial),'Units','normalized','Position',[0.55 0.8 0.4 0.15],'FontSize',10);
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
%             myhandles.s.IsContinuous = true;
%             myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
            for i=1:myhandles.nChan
                set(myhandles.Line(i,1),'XData',[],'YData',[]);
                set(myhandles.Line(i,2),'XData',[],'YData',[]);
            end
%             startBackground(myhandles.s);
            start(myhandles.s,'Continuous');
        else
            stop(myhandles.s);
%             myhandles.s.IsContinuous = false;
%             myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
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
                    subsetnames=fieldnames(setup.setnames{i});
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
       myhandles.s = daq('ni');

        % Add analog input channels specified in myhandles.Channels
        addinput(myhandles.s,myhandles.daqDevice,floor(myhandles.Channels/8)*16+rem(myhandles.Channels,8),'Voltage');
        % Set DAQ object sampling rate and time (R2020 sampling length is
        % specified in the start and read commands)
        myhandles.s.Rate = myhandles.sRate;
%         myhandles.s.DurationInSeconds = myhandles.sTime;
        % Add listener object (R2020 no need for listener, use start to
        % start background daq)
%         lh = addlistener(myhandles.s, 'DataAvailable', @localTimerAction);
        myhandles.s.ScansAvailableFcn = @localTimerAction;
        myhandles.s.ScansAvailableFcnCount = myhandles.tRate;
        myhandles.pbAcquire.Enable = 'On';
        myhandles.pbZeroJR3.Enable = 'On';
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
        if length(myhandles.s.Channels)>myhandles.nChan
            jr3chan=myhandles.Channels(end)+(1:6);
            removechannel(myhandles.s,myhandles.nChan+(1:6));
            myhandles.pbMVFdaq.Enable='off';
        end
%         [data,t]=startForeground(myhandles.s);
        start(myhandles.s,'Duration',myhandles.sTime)
        pause(5)
        [data,t]=read(myhandles.s,'all','OutputFormat','Matrix');
%         data=read(myhandles.s,'all');
        displayData(myhandles.nChan, t, data, myhandles.sRate, [myhandles.datadir,'\',myhandles.filename,num2str(myhandles.itrial),'.mat']); % AMA 7/2/19
        myhandles.itrial = myhandles.itrial+1;
        myhandles.TrialNumber.String = num2str(myhandles.itrial);
        source.Enable = 'on';
        myhandles.RTcheckbox.Enable = 'on';
    end

% AMA 4/7/21 EDIT THIS FUNCTION TO DISPLAY SABD TORQUE IN REAL TIME AND
% CREATE ZERO JR3 FUNCTION TO GO WITH ZERO JR3 BUTTON
% JR3 Signals - Ch15 to Ch20
    function pbMVFdaq_Callback(source,event)
        source.Enable = 'off';
        myhandles.MVFdaq=1;
        % Open figure window for max force feedback
%         [myhandles.mvf.hFig,myhandles.mvf.hAxis,myhandles.mvf.hArea,myhandles.mvf.hLine] = createMVFAxis(myhandles.max_sabdf);

        if myhandles.RTdaq
            stop(myhandles.s);
            myhandles.RTcheckbox.Value = 0;
%             myhandles.s.IsContinuous = false;
%             myhandles.s.NotifyWhenDataAvailableExceeds = 0.1*myhandles.sRate;
%             myhandles.RTdaq = 0;
        end
        myhandles.RTcheckbox.Enable = 'off'; % disable realtime checkbox
%         jr3chan=myhandles.Channels(end)+(1:6);
%         addinput(myhandles.s,myhandles.daqDevice,floor(jr3chan/8)*16+rem(jr3chan,8),'Voltage');
        start(myhandles.s,'Duration',5)
        pause(5)
        myhandles.MVF_Display.String=num2str(myhandles.max_sabdf,'%7.2f');
        source.Enable = 'on';
        myhandles.MVFdaq=0;
        myhandles.RTcheckbox.Enable = 'on'; % enable realtime checkbox
    end

    function pbZeroJR3_Callback(source,event)
        if myhandles.RTdaq
            stop(myhandles.s);
            myhandles.RTcheckbox.Value=0;
        end
        if isfield(myhandles,'mvf')
            close(myhandles.mvf.hFig)
            rmfield(myhandles,'mvf')
        end
        jr3chan=myhandles.Channels(end)+(1:6);
        addinput(myhandles.s,myhandles.daqDevice,floor(jr3chan/8)*16+rem(jr3chan,8),'Voltage');
        data = read(myhandles.s, seconds(1),'OutputFormat','Matrix');
        myhandles.FMzero = mean(data(:,myhandles.nChan+(0:5)));
        [myhandles.mvf.hFig,myhandles.mvf.hAxis,myhandles.mvf.hArea,myhandles.mvf.hLine] = createMVFAxis(20);
%         jr3mat=load('adjJR32620xV2');
%         myhandles.JR3mat = jr3mat.adjJR32620xV2;
        jr3mat=load('JR3U760Large');
        myhandles.JR3mat = jr3mat.JR3U760Large;
        myhandles.pbMVFdaq.Enable='On';
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
         % parameters should be saved in the setup file
        save(filename,'t','data');
    end

    % AMA - function to display data in real time and play beep at 200 ms 
    function localTimerAction(obj, event)
        if myhandles.RTdaq || myhandles.MVFdaq
            data = read(obj,obj.ScansAvailableFcnCount,'OutputFormat','Matrix');
            localDisplayData(myhandles.timebuffer,data,myhandles.nChan)
        else
            if obj.NumScansAvailable == 0.2*myhandles.sRate, play(myhandles.beep); end
        end
    end

% Function to display data in real time - should probably be merged into
% localTimerAction.
    function localDisplayData(t,data,nChan)
        if myhandles.RTdaq
            blocksize=size(data,1);
            databuffer=getappdata(emgDAQ.Fig,'databuffer');
            databuffer=[data;databuffer(1:end-blocksize,:)];
            setappdata(emgDAQ.Fig,'databuffer',databuffer)
            for i=1:nChan
                set(myhandles.Line(i,1),'XData',t,'YData',databuffer(:,i));
                set(myhandles.Label(i),'String',num2str([max(databuffer(:,i)) min(databuffer(:,i))],'%.3f  %.3f'));
            end
        else
            force=JR3toSAbdF(mean(data(:,myhandles.nChan+(0:5))),myhandles.JR3mat)-myhandles.FMzero(1);
            maxforce=myhandles.max_sabdf;
            % If force exceeds plot limits, increase by 5 N
            ylimit=get(myhandles.mvf.hAxis,'YLim');
            if force > ylimit(2)
                set(myhandles.mvf.hAxis,'YLim',ylimit+[0 5]);
            end
            %
            if force > maxforce
                maxforce=force;
                set(myhandles.mvf.hLine,'YData',maxforce([1 1]));
            end
            if force > 0.9*maxforce
                set(myhandles.mvf.hLine,'Color','g');
            else
                set(myhandles.mvf.hLine,'Color','c');
            end
            set(myhandles.mvf.hArea,'YData',force([1 1]));
            myhandles.max_sabdf=maxforce;
        end
        drawnow
    end

% Function to create feedback display for maximum shoulder abduction force
% measurement
    function [hFig,hAxis,hArea,hLine] = createMVFAxis(sabdf0)
        scrpos = get(groot,'MonitorPositions');
        if size(scrpos,1)==1
            figpos=[700,40,650,800];
            hFig = figure('Visible','on','Position',figpos,'Color','k','Name','ACT3D-TACS SHOULDER ABDUCTION STRENGTH');
        else
            figpos=scrpos(2,:);
            hFig = figure('Visible','on','Position',figpos,'Color','k','Name','ACT3D-TACS SHOULDER ABDUCTION STRENGTH');
        end
        
        % Create UIAxes
        hAxis = axes('Parent',hFig,'Position',[0.3 0 0.4 1],'Color','k','XColor','none','XTick',[],'XTickLabel',[],'YColor','none','YTick',[],'YTickLabel',[]);
        set(hAxis,'YLim',[0 100]);
        % Create the area and line objects
        hArea = area('Parent',hAxis,[0 0],'FaceColor','r','EdgeColor','none');
        
        hLine = line('Parent',hAxis,'Visible','on','Xdata',hArea.XData,'Ydata',[sabdf0 sabdf0],'Color','g','LineWidth',5);
        set(hAxis,'Color','k')
    end

    function FMx=JR3toSAbdF(FMraw,JR3mat)
        % Function to transform the y-force from the JR3 coordinate system in volts to the
        % shoulder coordinate system in N
        % JR3 coordinates: x - down, y - along forearm toward hand, z - away from forearm
        %
        % Inputs:
        %   FMjr: [nsamp x 6] matrix with the raw forces and torques
        %   arm: 'right' or 'left'
        %   JR3mat: JR3 calibration matrix

        % Decouple FM
        [frows,fcol]=size(FMraw);
%         if (frows>fcol) FMraw=FMraw'; end

        FMjr=(JR3mat*FMraw')';

        % Convert to N and Nm if using old JR3
        if JR3mat(4,4) > JR3mat(1,1)
            FMjr(:,1:3)=FMjr(:,1:3)*9.81/2.2;
            FMjr(:,4:6)=FMjr(:,4:6)*9.81/2.2*2.54/100;
        end

        % Convert to right hand coordinate system
        FMjr(:,[3 6])=-FMjr(:,[3 6]);

        % Rotated JR3 - AMA Is this necessary? Check! COMMENTED OUT, IT WAS
        % FLIPPING X
%         FMjr(:,[1,2,4,5])=-FMjr(:,[1,2,4,5]); 

        % Flip coordinate system to right arm if necessary
%         if strcmp(arm,'left')
%             FMjr(:,[2 4 6])=-FMjr(:,[2 4 6]);
%         end
        FMx=FMjr(:,1);
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
        if isfield(myhandles,'mvf')
            delete(myhandles.mvf.hFig)
        end
        delete(emgDAQ.Fig)
%         close('all');
    end

end

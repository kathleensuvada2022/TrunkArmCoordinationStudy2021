function TargetDAQ_Upgraded()
%TargetDAQ_Upgraded Make your selections on the GUI interface and proceed to get
%the desired output plots and collection of data

%Incorporating changes decided from meeting with AMA and Amee 10.23.17
%% GUI VISUALIZATION CODE
%Start by creating the figure for the GUI layout
close all;

% f = figure('Visible','off');
targetDAQ.Fig = figure('Name','Target DAQ','Visible','off');
%These are function handle values that I want to be stored with my GUI while
%it's running; this will help to share data between functions


% myhandles = guihandles(f);
myhandles = guihandles(targetDAQ.Fig);
myhandles.daqDevice = 'Dev2';
myhandles.loadFile = 0;
myhandles.loadFilePrev = 0;
myhandles.abdAngle = 0;
myhandles.efAngle = 0;
myhandles.aLength = 0;
myhandles.faLength = 0;
myhandles.zOffset = 0;
myhandles.nChan = 0;
myhandles.oldNChan = 6;
myhandles.sRate = 0;
myhandles.sTime = 0;
% myhandles.Timer = 0;
myhandles.Channels = [];
myhandles.oldChanList = [];
myhandles.NameChannels = {};
myhandles.maxChannels = 25;

myhandles.pbAcquireVal = 0;
myhandles.RTtarget = 0;
myhandles.acquireCt = 0;

%change this if your channels for right and left arm change
myhandles.rChannels = [0:5];
%load cell is channel 13 for right
myhandles.lChannels = [0:5];
%load cell is channel 14 for left

myhandles.rNameChannels = {'Channel 0','Channel 1','Channel 2','Channel 3','Channel 4','Channel 5'};
myhandles.lNameChannels = {'Channel 0','Channel 1','Channel 2','Channel 3','Channel 4','Channel 5'};
myhandles.typesPossible = {'Force- JR3_1','Force- JR3_2','Force- JR3_3','Force- JR3_4','Force- JR3_5','Force- JR3_6','Force- Load Cell','EMG','Other'};

myhandles.plotNumber = 7;
myhandles.oldPlotNumber = 7;

myhandles.armChoice = 'left';
myhandles.initChSelect = 0;
myhandles.initDaq = 0;
myhandles.armSwitched = 0;
myhandles.moreTarOK = 0;
myhandles.moreTarCancel = 0;
myhandles.TarOK = 0;
myhandles.TarCancel = 0;
myhandles.torquemask = [0,0,0,0];
myhandles.prevtorquemask = [0,0,0,0];
myhandles.lockmask = [0,0,0,0];
myhandles.prevlockmask = [0,0,0,0];

myhandles.Cursor_s = 4;
myhandles.Pie_size = 4;
myhandles.th_zero = 270;
myhandles.Target_s = 4;
myhandles.Target_x = 0;
myhandles.Target_y = 0;
myhandles.Target_t = 10;
myhandles.Target_z = 10;
myhandles.prevTarValues = [0,0,0,0,0,0,0,0,0,0];
myhandles.zoomOpt = 0;
myhandles.lh = [];

myhandles.itrial = 1;
setappdata(targetDAQ.Fig,'itrial',1);
myhandles.TrialNumber = '1';
myhandles.fileName = 'file';
myhandles.daqAcquireVal = 1;
myhandles.FMoffset = [];
myhandles.meanLC = [];
myhandles.tdh = [];
% myhandles.sensMat = [];
% myhandles.JR3name = '';

sensMat = evalin('base', 'load(''adjJR32620xV2'')');
myhandles.sensMat = sensMat.adjJR32620xV2;
myhandles.JR3name = '45E15A-U760-A 250L1125';
% myhandles.sensMat = [];
% myhandles.JR3name = '';
myhandles.subjID = 'subj';

myhandles.plotNames = {'Fx','Fy','Fz','SFE','SAA','SEIR','EFE','WFE','Plot 9','Plot 10','Plot 11','Plot 12','Plot 13','Plot 14','Plot 15','Plot 16','Plot 17','Plot 18','Plot 19','Plot 20','Plot 21','Plot 22','Plot 23'};
myhandles.plotTypes = [1,2,3,4,5,6,7,8,9,9,9,9,9,9,9,10,10,10,10,10,10,10];
myhandles.prevPlotTypes = [];
myhandles.prevChanTypeList = [];
% myhandles.chanTypeList = [];
myhandles.chanTypeList = {'1','2','3','4','5','6'};
myhandles.noStrChanTypeList = [1,2,3,4,5,6];

myhandles.maxVals = [];

myhandles.pbOKds_Callback = 0;
myhandles.pbCancelds_Callback = 0;
myhandles.pbOKdfe_Callback = 0;
myhandles.pbCanceldfe_Callback = 0;
myhandles.pbOKcds_Callback = 0;
myhandles.pbCancelcds_Callback = 0;

myhandles.trigAlready = 0;

targetDAQ.Fig.Position = [75,75,875,850];

targetDAQ.Fig.MenuBar = 'none';
% f.Name = 'TargetDAQ';
targetDAQ.Fig.DeleteFcn =  @closeMainGUI;
movegui(targetDAQ.Fig,'center')

myhandles.lArmPath = [];
myhandles.rArmPath = [];
myhandles.addInfo = [];
myhandles.currDir = [];

%Global variables
loadSettings = {};

%Add the desired sub-panels to the GUI
%Create panels for layouts- don't add functionality yet

%EXPERIMENTAL SETUP PANEL
%Add static texts for variable that we want to enter, as well as editable
%text field for the user to be able to input a value for that variable
%Editing Note: if you want to add any data to the experimental setup panel,
%can add it here! Please remember that all of the positions are normalized,
%so you will need to shift everything else slightly higher as well as make
%the expPanel larger

expPanel = uipanel(targetDAQ.Fig,'Title','Experimental Setup','FontSize',11,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.775,0.75,0.2,0.225]);

tExp = uicontrol(expPanel,'Style','text','FontSize',9,'String','Load Cell Model','FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.225,.875,.55,.1]);

tExp = uicontrol(expPanel,'Style','text','String','Abduction (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.75,.5,.1]);
myhandles.abdAngle_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.abdAngle,'Callback',@abdAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.75 .775 .2 .075],'UserData','right');

tExp = uicontrol(expPanel,'Style','text','String','Elbow Flexion (deg)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.625,.6,0.1]);
myhandles.efAngle_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.efAngle,'Callback',@EFAngle_Callback,'Tag','EFAngle','HorizontalAlignment','center','Units','normalized','Position',[.75 .65 .2 .075]);

tExp = uicontrol(expPanel,'Style','text','String','Arm Length (mm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.5,0.6,0.1]);
myhandles.aLength_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.aLength,'Callback',@ArmLength_Callback,'Tag','ALength','HorizontalAlignment','center','Units','normalized','Position',[.75 .525 .2 .075]);

tExp = uicontrol(expPanel,'Style','text','String','Forearm Length (mm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.375,0.6,0.1]);
myhandles.faLength_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.faLength,'Callback',@FArmLength_Callback,'Tag','FALength','HorizontalAlignment','center','Units','normalized','Position',[.75 .4 .2 .075]);

tExp = uicontrol(expPanel,'Style','text','String','z-offset (mm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.25,0.6,0.1]);
myhandles.zOffset_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.zOffset,'Callback',@ZOffset_Callback,'Tag','zOff','HorizontalAlignment','center','Units','normalized','Position',[.75 .275 .2 .075]);

%Add radio buttons to select between right and left arms; if you want to
%have it so only one or the other can be selected, need to make this into a
%BUTTON GROUP

rbg = uibuttongroup('Parent',expPanel,'Visible','off','Tag','ArmBG','SelectionChangedFcn',@(rbg,event) rbExpCallback(rbg,event),'Position',[0.05 0.05 0.9 0.1875]);
myhandles.rbExp1 = uicontrol(rbg,'Style','radiobutton','Tag','RLArm','String','right','Value',0,'Units','normalized','Position',[0.2 0.25 0.5 0.5]);
myhandles.rbExp2 = uicontrol(rbg,'Style','radiobutton','Tag','RLArm','String','left','Value',1,'Units','normalized','Position',[0.65 0.25 0.5 0.5]);
rbg.Visible = 'on';

%DAQ PARAMETERS PANEL
daqParaPanel = uipanel('Title','DAQ Parameters','FontSize',11,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Tag','numChanET','Position',[0.775 0.5 0.2 0.225]);
tDaq = uicontrol(daqParaPanel,'Style','text','String','# of Channels','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.85,.5,.1]);
nChan_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.nChan,'Tag','numChan','Callback',@nChan_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .875 .2 .075]);

tDaq = uicontrol(daqParaPanel,'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.725,.6,0.1]);
myhandles.sRate_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.sRate,'Tag','sampRate','Callback',@SampRate_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .75 .2 .075]);

tDaq = uicontrol(daqParaPanel,'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.6,0.6,0.1]);
myhandles.sTime_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.sTime,'Tag','sampTime','Callback',@SampTime_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .625 .2 .075]);

% tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% myhandles.Timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.Timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);

tDaq = uicontrol(daqParaPanel,'Style','text','String','File Name','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.35,0.6,0.1]);
fileName_Edit = uicontrol(daqParaPanel,'Style','edit','Callback',@FileName_Callback,'String',myhandles.fileName,'HorizontalAlignment','center','Units','normalized','Position',[.55 .375 .4 .075]);

%Add pushbutton for the user to click on when they are ready to initialize
%the DAQ
pbDaq = uicontrol(daqParaPanel,'Style','pushbutton','Callback',@pbDaqInit_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.25 0.1 0.5 0.2]);

%ADD IN OTHER GUI VISUALIZATIONS
%Add push button for the user to click on when they are ready to collect
%data
targetDAQ.Fig.KeyPressFcn = @aKeyPress_Callback;
myhandles.pbAcquire = uicontrol(targetDAQ.Fig,'Style','pushbutton','Callback',@pbAcquire_Callback,'String','<html>ACQUIRE<br>(Press "a")','FontWeight','Bold','FontSize',9,'Units','normalized','Enable','Off','Position',[0.8 0.30 0.15 0.075]);
pxPos = getpixelposition(myhandles.pbAcquire);
myhandles.pbAcquire.String = ['<html><div width="' num2str(pxPos(3)-20) 'px" align="center">ACQUIRE<br>(Press "a")'];  % button margins use 20px

%%TRIAL NUMBER PANEL
%This panel will iterate the trial number every time that you press acquire
numtrPanel = uipanel('HighlightColor','[0.5 0 0.9]','Position',[0.775 0.2375 0.2 0.0375]);
tNumTr = uicontrol(numtrPanel,'Style','text','String','Trial Number','HorizontalAlignment','Center','Units','normalized','Position',[0.05,0.009375,0.5,0.75]);
etNumTr = uicontrol(numtrPanel,'Style','edit','HorizontalAlignment','Center','Callback',@TrialNumber_Callback,'String',myhandles.TrialNumber,'Units','normalized','Position',[.55 .125 .425 .675]);

%Pulse start and stop entries
myhandles.pulseStart = 0;
myhandles.pulseStop = 0;
pulsePanel = uipanel('HighlightColor','[0.5 0 0.9]','Position',[0.775 0.1575 0.2 0.075]);
tPulse = uicontrol(pulsePanel,'Style','text','String','Pulse Start (s)','HorizontalAlignment','left','Units','normalized','Position',[0.125,0.625,0.5,0.25]);
myhandles.pulseStart_Edit = uicontrol(pulsePanel,'Style','edit','String',num2str(myhandles.pulseStart),'Callback',@pulseCallback,'UserData','pulseStart','HorizontalAlignment','center','Units','normalized','Position',[.55 .6125 .425 .3]);
tPulse = uicontrol(pulsePanel,'Style','text','String','Pulse Stop (s)','HorizontalAlignment','left','Units','normalized','Position',[0.125,0.225,0.5,0.25]);
myhandles.pulseStop_Edit = uicontrol(pulsePanel,'Style','edit','String',num2str(myhandles.pulseStop),'Callback',@pulseCallback,'UserData','pulseStop','HorizontalAlignment','center','Units','normalized','Position',[.55 .2125 .425 .3]);

%Checkbox for realtime
RTcheckbox = uicontrol(targetDAQ.Fig,'Style','checkbox','String','Realtime DAQ','Units','Normalized','Interruptible','on','Callback',@RT_Callback,'Position',[0.775 0.1 0.125 0.05]);
myhandles.RTdaq = 0;
RTTargetcheckbox = uicontrol(targetDAQ.Fig,'Style','checkbox','Enable','off','String','Realtime Target','Units','Normalized','Callback',@RTTarget_Callback,'Position',[0.875 0.1 0.125 0.05]);
myhandles.RTTarget = 0;

%Checkbox for trigger
triggerCB = uicontrol(targetDAQ.Fig,'Style','checkbox','Enable','off','String','Trigger ','Units','Normalized','Callback',@TriggerCB_Callback,'Position',[0.775 0.0675 0.125 0.05]);
triggerOptions = uicontrol(targetDAQ.Fig,'Style','popupmenu','Enable','off','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','WFE'},'Value',1,'Units','Normalized','Callback',@triggerOpt_Callback,'Position',[0.845 0.0525 0.0775 0.05]);
myhandles.trigger = 0;
myhandles.trigResp = 4;
etTrigger = uicontrol(targetDAQ.Fig,'Style','edit','HorizontalAlignment','Left','Callback',@trigValue_Callback,'Units','normalized','Position',[.9375 .0775 .0375 .025]);
trigType = uibuttongroup('Parent',targetDAQ.Fig,'Visible','off','Tag','TrigTypeSelect','SelectionChangedFcn',@(trigType,event) trigExpCallback(trigType,event),'Position',[0.775 0.04 0.2 0.03]);
trigType1 = uicontrol(trigType,'Style','radiobutton','String','Singlet','Value',1,'Enable','off','Units','normalized','Position',[0.125 0.25 0.5 0.625]);
trigType2 = uicontrol(trigType,'Style','radiobutton','String','Doublet','Value',0,'Enable','off','Units','normalized','Position',[0.575 0.25 0.5 0.625]);
trigType.Visible = 'on';

%Checkbox for RT Plot of JR3toFM outputs
RTForceCB = uicontrol(targetDAQ.Fig,'Style','checkbox','Enable','off','String','Real-time FM','Units','Normalized','Callback',@RealtimeFM_Callback,'Position',[0.775 0.0125 0.1 0.025]);
myhandles.RTForce = 0;
myhandles.RealtimeFMResp = 1;
myhandles.RealtimeFMRespPrev = 1;

    function Display_FMRealtime_Callback(source,event)
        if strcmp(source.Checked,'off')
            source.Checked = 'on';
            %             TargetOptions_menu.Enable = 'On';
            myhandles.realtimeFMGUI = createDataCaptureUI3();
            RTForceCB.Enable = 'on';
            RTTargetcheckbox.Enable = 'off';
            triggerCB.Enable = 'On';
            if isvalid(s3)
                delete(s3);
            end
            
            s3 = daq.createSession('ni');
            DAQInit(s3,1);
        else
            source.Checked = 'off';
            %             TargetOptions_menu.Enable = 'Off';
            try
                close('Target GUI');
            end
            RTForceCB.Enable = 'off';
            RTTargetcheckbox.Enable = 'on';
        end
    end

    function FMOptSelect_Callback(source,event)
        val = source.Value;
        myhandles.RealtimeFMRespPrev = myhandles.RealtimeFMResp;
        myhandles.RealtimeFMResp = val+3;
%         RealtimeFMCapture_Callback(1);
    end

    function TriggerCB_Callback(source,event)
        if source.Value == 1
            triggerOptions.Enable = 'on';
            trigType1.Enable = 'on';
            trigType2.Enable = 'on';
            myhandles.trigger = 1;
%             myhandles.pulseStart_Edit.Enable = 'off';
%             myhandles.pulseStop_Edit.Enable = 'off';
            delete(s);
            delete(s4);
            s = daq.createSession('ni');
            s4 = daq.createSession('ni');
            DAQInit(s,2,s4);
        else
            triggerOptions.Enable = 'off';
            trigType1.Enable = 'off';
            trigType2.Enable = 'off';
            myhandles.trigger = 0;
%             myhandles.pulseStart_Edit.Enable = 'on';
%             myhandles.pulseStop_Edit.Enable = 'on';
            delete(s);
            s = daq.createSession('ni');
%             DAQInit(s,1); 
            if myhandles.pulseStop > 0 
                DAQInit(s,2);
            else                       
                DAQInit(s,1);
    %             addAnalogOutputChannel(s,myhandles.daqDevice,'ao0','Voltage');
            end
        end
    end

    function trigValue_Callback(source,event)
        myhandles.trigValue = str2num(source.String);
    end

    function triggerOpt_Callback(source,event)
        val = source.Value;
        myhandles.trigResp = val+3;
    end

    function trigExpCallback(src,event)
        sbnew = event.NewValue.String;
        sbold = event.OldValue.String;
        %         if ~strcmp(sbnew,sbold) && (initChan == 1)
        
        sRate = myhandles.sRate;
        divP = round(sRate/1000);
                    
        if ~strcmp(sbnew,sbold)
            if strcmp(sbnew,'Singlet')
                disp('selected singlet');
                pulse = [zeros(sRate,1);5*ones(round(.001*sRate/divP),1);zeros(2,1)];
            else
                disp('selected doublet');
                pulse = [zeros(sRate/2,1);5*ones(round(.001*sRate/divP),1);zeros(round(sRate*0.01),1);5*ones(round(.001*sRate/divP),1);zeros(4,1)];
            end
            myhandles.trigPulse = pulse;
        end
        
        trigSelection = src.SelectedObject.String;
        src.UserData = trigSelection;
        myhandles.trigType = trigSelection;
    end

    function pulseCallback(source,event)
        type = source.UserData;
        valStr = source.String;
        val = str2num(valStr);
        if strcmp(type,'pulseStart')
            myhandles.pulseStart = val;
            disp('entered pulse start');
        elseif strcmp(type,'pulseStop')
            myhandles.pulseStop = val;
            disp('entered pulse stop');
        end

        if myhandles.pulseStop > 0
            delete(s);
            s = daq.createSession('ni'); 
            DAQInit(s,2);
        else
            delete(s);
            s = daq.createSession('ni');                        
            DAQInit(s,1);
%             addAnalogOutputChannel(s,myhandles.daqDevice,'ao0','Voltage');
        end
    end

    function RT_Callback(source,event)
        val = source.Value;
        RT_GUI(val);
        source.Value = 0;
        if val == 0
            release(s2);
        end
    end

    function RTTarget_Callback(source,event)
%         disp('entered RT target');
        if source.Value == 1
            %             disp('source is 1');
            %First release s as a session
            release(s);
            s3.IsContinuous = true;
            % Specify triggered capture timespan, in seconds- test if we
            % use 0.45 instead...
            capture.TimeSpan = myhandles.sTime;            
            % Specify continuous data plot timespan, in seconds
            capture.plotTimeSpan = 0.5;
            % Determine the timespan corresponding to the block of samples supplied
            % to the DataAvailable event callback function.
            callbackTimeSpan = double(s3.NotifyWhenDataAvailableExceeds)/s3.Rate;
            % Determine required buffer timespan, seconds
            capture.bufferTimeSpan = max([capture.plotTimeSpan, capture.TimeSpan * 3, callbackTimeSpan * 3]);
            % Determine data buffer size
            capture.bufferSize =  round(capture.bufferTimeSpan * s3.Rate);
            lh = addlistener(s3, 'DataAvailable', @(src,event)collectRT(src,event,capture,0,myhandles.targetGUI));
            myhandles.timeMat = [];
            myhandles.collectedData = [];
            startBackground(s3);
        else
            %Release s3 as a session
%             disp('entered callback killing s3');
            if s3.IsRunning
                stop(s3);
            end
            release(s3);
        end
    end

    function RealtimeFM_Callback(source,event)
        disp('entered RT realtime fm figure callback');
        if source.Value == 1
            release(s);
            %First release s as a session
            release(s);
            s3.IsContinuous = true;
            % Specify triggered capture timespan, in seconds- is this part
            % necessary?
            capture.TimeSpan = 0.45;
%             capture.TimeSpan = myhandles.sTime;            
            % Specify continuous data plot timespan, in seconds
            capture.plotTimeSpan = 10;
            % Determine the timespan corresponding to the block of samples supplied
            % to the DataAvailable event callback function.
            callbackTimeSpan = double(s3.NotifyWhenDataAvailableExceeds)/s3.Rate;
            % Determine required buffer timespan, seconds
            capture.bufferTimeSpan = max([capture.plotTimeSpan, capture.TimeSpan * 3, callbackTimeSpan * 3]);
            % Determine data buffer size
            capture.bufferSize =  round(capture.bufferTimeSpan * s3.Rate);
            lh = addlistener(s3, 'DataAvailable', @(src,event) dataCapture3(src, event, capture,0,myhandles.realtimeFMGUI));
            myhandles.timeMat = [];
            myhandles.collectedData = [];
            startBackground(s3);
        else
            %Release s3 as a session
%             disp('entered callback killing s3');
            if s3.IsRunning
                stop(s3);
            end
            release(s3);
        end
    end

    function RT_GUI(command_val)
        if command_val == 1
            chanTypes = myhandles.noStrChanTypeList;
            numChan = myhandles.nChan;
            ind = [];

            for i = 1:numChan
                if find(chanTypes == 8)
                    ind = find(chanTypes == 8);
                end
            end

            if length(ind) >= 1
                if isvalid(s)
                    release(s);
                end
                
                if isvalid(s3)
                    release(s3);
                end
                
                delete(s2);
                s2 = daq.createSession('ni');
%                 DAQInit(s2,1);

                channelList = sort(myhandles.Channels);
%                 channelListNew = channelList;
                channelListNew = floor(channelList/8)*16+rem(channelList,8);
                %         channelList = [0,channelList];
                ch = addAnalogInputChannel(s2,myhandles.daqDevice,channelListNew,'Voltage');
                s2.Rate = myhandles.sRate;

                capture.TimeSpan = 0.45;
                capture.plotTimeSpan = 10;
                callbackTimeSpan = double(s2.NotifyWhenDataAvailableExceeds)/s2.Rate;
                capture.bufferTimeSpan = max([capture.plotTimeSpan, capture.TimeSpan * 3, callbackTimeSpan * 3]);
                capture.bufferSize =  round(capture.bufferTimeSpan * s2.Rate);

                hGui = createDataCaptureUI2(s2);
                dataListener = addlistener(s2, 'DataAvailable', @(src,event) dataCapture2(src, event, capture,hGui));
                %         timeListener = addlistener(s,'DataAvailable',@stopAfterTimeLimit);
                errorListener = addlistener(s2, 'ErrorOccurred', @(src,event) disp(getReport(event.Error)));
                s2.IsContinuous = true;
                startBackground(s2);
                while s2.IsRunning
                    pause(0.5);
                end

                s2.wait();
                stop(s2);
                release(s2);
                delete(dataListener);
                delete(errorListener);
                RTTargetcheckbox.Enable = 'off';
                RTForceCB.Enable = 'off';
                %Find out how many emg channels there are and initialize subplots
                %Set up the DAQ for RT data collection
                %Start plotting and have the "uncheck" make it turn off- actually,
                %we can have a separate GUI function that this function calls by
                %inputting the value of the check
            else
                warning = 'O_o. There are no EMG channels specified Please re-specify channels in Channel Specification Menu.';
                str = sprintf(warning);
                errordlg(str,'User Error');
            end
        else
            g = findobj('-depth',1,'type','figure','Name','Live EMG Plot');
            delete(g)
            RTTargetcheckbox.Enable = 'on';
            RTForceCB.Enable = 'on';
        end
    end

    function dataCapture2(src, event, c, hGui)
        persistent dataBuffer
        % trigActive trigMoment
        % If dataCapture is running for the first time, initialize persistent vars
        if event.TimeStamps(1)==0
            dataBuffer = [];          % data buffer
        end
        
        % Store continuous acquistion data in persistent FIFO buffer dataBuffer
        latestData = [event.TimeStamps, event.Data];
        dataBuffer = [dataBuffer; latestData];
        numSamplesToDiscard = size(dataBuffer,1) - c.bufferSize;
        if (numSamplesToDiscard > 0)
            dataBuffer(1:numSamplesToDiscard, :) = [];
        end
        
        data = dataBuffer(:,2:end);
        time = dataBuffer(:,1);
        
        % Update live data plot
        % Plot latest plotTimeSpan seconds of data in dataBuffer
        samplesToPlot = min([round(c.plotTimeSpan * src.Rate), size(dataBuffer,1)]);
        firstPoint = size(dataBuffer, 1) - samplesToPlot + 1;
        % Update x-axis limits
        %         xlim(hGui.Axes1, [dataBuffer(firstPoint,1), dataBuffer(end,1)]);
        
        chanTypes = myhandles.noStrChanTypeList;
        numChan = myhandles.nChan;
        %         newList = [];
        totalChanList = sort(myhandles.Channels);
        
        for i = 1:numChan
            if find(chanTypes == 8)
                ind = find(chanTypes == 8);
            end
        end
        nEMGs = length(ind);
        
        emgChanList = [];
        
        EMG = data;
        [m,n]=size(EMG);
        EMGbase=EMG-(diag(mean(EMG(1:10,:)))*ones(n,m))';%LCM 10.1.14 to baseline correct hand torques/EMG on display
        meanConvData=meanfilt(abs(EMGbase),0.25*myhandles.sRate);
        
        for i = 1:nEMGs
            emgChanList = [emgChanList,totalChanList(ind(i))];
        end
        
        for i = 1:nEMGs
            xlim(hGui.ax(i), [dataBuffer(firstPoint,1), dataBuffer(end,1)]);
        end
        
        for ii = 1:numel(hGui.LivePlot)
            set(hGui.LivePlot(ii), 'XData', time, ...
                'YData', EMGbase(:,ind(ii)))
        end
        drawnow;
    end

    function dataCapture3(src, event, c, captureRequested, hGui)
        persistent timeBuffer

        latestData = event.Data;
        latestTime = event.TimeStamps;

        timeBuffer = [timeBuffer; latestTime];
        
        RTFMresp = myhandles.RealtimeFMResp;
        numFM = length(myhandles.RealtimeFMResp);
        reset = 0;
        if reset ~= numFM
%             if (latestTime(1) == 0 || timeBuffer(end) >= 5)
            if (latestTime(1) == 0)
                for ii = 1:numFM                
                    clearpoints(hGui.hal(ii));
                    reset = reset + 1;
%                     cla(hGui.ax(ii));
                end
                
                if timeBuffer(end) >=90
                    timeBuffer = [];
                end
            end
        end

        % Update x-axis limits
        data = latestData;
        time = latestTime;
        
        newData = ones(size(data(:,1:6)));
        chanTypes = myhandles.noStrChanTypeList;
        %
        %         %         relCols = [1:6];
        for i = 1:6
            if find(chanTypes == i)
                ind = find(chanTypes == i);
                newData(:,i) = data(:,ind);
            end
        end
        
        meanLC = myhandles.meanLC;

        if find(chanTypes == 7)
            forceInd = find(chanTypes==7);
            forceData = data(:,forceInd);
            convForceData = forceConversion(forceData-meanLC);
        else
            convForceData = 0*ones(size(data,1),1);
        end
        
        [m,n]=size(newData(:,1:6));
        FMhandbase = newData(:,1:6) - (diag(myhandles.FMoffset)*ones(n,m))';
        FMhand = JR3toFM(FMhandbase(:,1:6),myhandles);
        FMhand = [FMhand,convForceData];
        meanFM=meanfilt(FMhand,0.5*myhandles.sRate);
        
        trigAlready = myhandles.trigAlready;
        tarCheck = RTTargetcheckbox.Value;
        
        if triggerCB.Value == 1 && trigAlready == 0 && tarCheck ~= 1
            trigVal = myhandles.trigValue;
            resp = myhandles.trigResp;

%             if any(meanFM(:,resp)>= abs(trigVal))
            if mean(FMhand(:,resp)>= trigVal)
                try
                    startBackground(s4);
                    myhandles.trigAlready = 1;
%                     outputSingleScan(s4,0)
                    disp('outputted');
                catch
                    disp('error');
                end
            end
        end

        % Live plot has one line for each acquisition channel                
        for ii = 1:numFM
            if latestTime(end,1)<=90
                xlim(hGui.ax(ii),[0,90]);
            else
                xlim(hGui.ax(ii),[latestTime(end,1)-45,latestTime(end,1)+45]);
            end
            addpoints(hGui.hal(ii),latestTime', meanFM(:,RTFMresp(ii)));
%             addpoints(hGui.hal(ii),latestTime', FMhand(:,RTFMresp(ii)));
        end        
        drawnow;
        
        if captureRequested == 1
            myhandles.timeMat = [myhandles.timeMat,latestTime'];
            myhandles.collectedData = [myhandles.collectedData,latestData'];
        end
    end

    function hGui = createDataCaptureUI2(s)
        %CREATEDATACAPTUREUI Create a graphical user interface for data capture.
        %   HGUI = CREATEDATACAPTUREUI(S) returns a structure of graphics
        %   components handles (HGUI) and creates a graphical user interface, by
        %   programmatically creating a figure and adding required graphics
        %   components for visualization of data acquired from a DAQ session (S).
        
        % Create a figure and configure a callback function (executes on window close)
        hGui.Fig = figure('Name','Live EMG Plot', ...
            'NumberTitle', 'off', 'Resize', 'off', 'Position', [100 100 750 650]);
        set(hGui.Fig, 'DeleteFcn', {@closeRT,s});
        uiBackgroundColor = get(hGui.Fig, 'Color');
        
        % Create the continuous data plot axes with legend
        numChan = myhandles.nChan;
        chanTypes = myhandles.noStrChanTypeList;
        
        ind = 0;
        for i = 1:numChan
            if find(chanTypes == 8)
                ind = find(chanTypes == 8);
            end
        end
        
        if length(ind) >= 1
            totalChanList = sort(myhandles.Channels);
            nEMGs = length(ind);
            emgChanList = [];
            
            for i = 1:nEMGs
                emgChanList = [emgChanList,totalChanList(ind(i))];
            end
            
            colNum = floor(nEMGs/4);
            remNum = rem(nEMGs,4);
            if remNum ~= 0
                colNum = colNum + 1;
            end
            
            emgNames = {'LES','RES','LLD','RLD','LRA','RRA','LEO','REO','LIO','RIO','LUT','RUT','BIC','LTRI','IDEL','EMG16'};
            for i = 1:nEMGs
                hGui.ax(i) = subplot(4,colNum,i);
                hGui.LivePlot(i) = plot(0,0);
                title(emgNames{i},'FontSize',8.5)
%                 title(num2str(emgChanList(i)),'FontSize',8.5)
            end
            
            % Create a stop acquisition button and configure a callback function
            hGui.DAQButton = uicontrol('style', 'pushbutton', 'string', 'Stop DAQ',...
                'units', 'normalized', 'position', [0.425 0.01 0.1 0.055]);
            set(hGui.DAQButton, 'callback', {@closeRT, s});
        else
            warning = 'O_o. There are no EMG channels specified Please re-specify channels in Channel Specification Menu.';
            str = sprintf(warning);
            errordlg(str,'User Error');
        end
    end

    function hGui = createDataCaptureUI3()
        %CREATEDATACAPTUREUI Create a graphical user interface for data capture.
        %   HGUI = CREATEDATACAPTUREUI(S) returns a structure of graphics
        %   components handles (HGUI) and creates a graphical user interface, by
        %   programmatically creating a figure and adding required graphics
        %   components for visualization of data acquired from a DAQ session (S).
        
        % Create a figure and configure a callback function (executes on window close)
        hGui.Fig = figure('Name','Live FM Plot', ...
            'NumberTitle', 'off', 'Resize', 'on', 'Position', [100 100 750 650]);
        set(hGui.Fig, 'DeleteFcn', @closeRTForce);
        uiBackgroundColor = get(hGui.Fig, 'Color');
        
        % Create the continuous data plot axes with legend
        numFM = length(myhandles.RealtimeFMResp);
        FMnames = {'SF/SE','SAB/SAD','SER/SIR','EF/EE','WFE'};
%         for i = 1:numFM
%             xlim(hGui.ax(i), [time(1,1),time(1,end)]);
% %             xlim(hGui.ax(i), [timeBuffer(firstPoint,1), timeBuffer(end,1)]);
%         end
        for i = 1:numFM
            hGui.ax(i) = subplot(numFM,1,i);
            xlim(hGui.ax(i), [0,90]);
            hGui.hal(i) = animatedline('Parent',hGui.ax(i),'LineStyle', '-','Color', [0,1,0]);
%             ylim(hGui.ax(i), [-100,100]);
%             hGui.LivePlot(i) = plot(0,0);
%                 title(emgNames{i},'FontSize',8.5)
            title(FMnames{myhandles.RealtimeFMResp(i)-3},'FontSize',8.5)
        end
    end

    function closeRT(~, ~, s)
        if isvalid(s)
            if s.IsRunning
                stop(s);
            end
        end
        try
            g = findobj('-depth',1,'type','figure','Name','Live EMG Plot');
            delete(g)
        end
    end

    function closeRTForce(source,event)
        try
            if isvalid(s)
                if s.IsRunning
                    stop(s);
                end
            end
            
            if isvalid(s3)
                if s3.IsRunning
                    stop(s3);
                end
                delete(s3);
            end
            
        catch
            warning('The GUI was shut down this first time line 2732');
            %             delete(dataListener);
            %             delete(errorListener);
        end

        try
            DisplayFM_menu.Checked ='off';
            if RTForceCB.Value == 1
                RTForceCB.Value = 0;
            end
            RTForceCB.Enable = 'off';
            g = findobj('-depth',1,'type','figure','Name','Live FM Plot');
            delete(g)
            %             TargetOptions_menu.Enable = 'Off';
        catch
            warning('The GUI was shut down for the second time line 2732');
        end
        if s.IsRunning
            %             disp('in the cancel and still running');
            stop(s);
        end
        disp('FM display off o_O');
    end

%%Zero FM Button
%This button calls the function that zeroes the JR3 data
pbZeroFM = uicontrol(targetDAQ.Fig,'Style','pushbutton','Callback',@Zero_FM_Callback,'String','Zero FM','FontWeight','Bold','FontSize',9,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.825 0.400 0.10 0.05]);

%% MENU ITEMS FOR GUI
%Setup Menu
mSetup = uimenu(targetDAQ.Fig,'Label','Setup');
mSelectJR3 = uimenu(mSetup,'Label','JR3');
mSelectJR3_1 = uimenu(mSelectJR3,'Label','45E15A-RIC-A 1000N125','Callback',@selectJR3);
mSelectJR3_2 = uimenu(mSelectJR3,'Label','45E15A-U760-A 250L1125','Callback',@selectJR3);
mSelectJR3_3 = uimenu(mSelectJR3,'Label','Amee JR3 45E15A-U760-A 250L1125','Callback',@selectJR3);
mSelectJR3_Other = uimenu(mSelectJR3,'Label','Other','Callback',@selectJR3);

mSubjInfo= uimenu(mSetup,'Label','Subject Information','Callback',@subjInfo);
mPlots = uimenu(mSetup,'Label','Plotting Options','Enable','off');
mPlots_1 = uimenu(mPlots,'Label','Plot Names','Callback',@dataCreation);
mPlots_2 = uimenu(mPlots,'Label','Number of Plots','Callback',@changePlotNum);
mChannels = uimenu(mSetup,'Label','Channel Options','Callback',@chanTypeGUI);
mSaveSetup = uimenu(mSetup,'Label','Save Setup','Callback',@saveSetup);
mLoadSetup = uimenu(mSetup,'Label','Load Setup','Callback',@loadSetup);

targetDAQ.Fig.Visible = 'on';

%Target Menu
mTarget = uimenu(targetDAQ.Fig,'Label','Target');
DisplayTarget_menu = uimenu(mTarget,'Label','Display Target','Callback',@Display_Target_Callback,'Enable','Off');
TargetOptions_menu = uimenu(mTarget,'Label','Target Options','Enable','Off','Callback',@tarOpt_Callback);

%FM Display Menu
mFMDisplay = uimenu(targetDAQ.Fig,'Label','FM Display');
DisplayFM_menu = uimenu(mFMDisplay,'Label','Display FM','Callback',@Display_FMRealtime_Callback,'Enable','Off');
FMOptions_menu = uimenu(mFMDisplay,'Label','FM Display Options','Enable','Off','Callback',@realtimeFMOpt_Callback);

%% CALLBACKS FOR GUI
    function subjInfo(source,event)
        subj_fig = figure('Name','Subject Information Menu','NumberTitle', 'off');
        subj_fig.Position = [100,100,400,500];
        
        uicontrol(subj_fig,'Style','text','FontSize',10,'String','Subject ID:','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.05,.85,.2,.125]);
        uicontrol(subj_fig,'Style','text','FontSize',10,'String','Additional Information:','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.05,.75,.4,.125]);
        
        uicontrol(subj_fig,'Style','edit','HorizontalAlignment','Left','Units','normalized','Visible','on','Position',[.25,.93125,.3125,.05],'Callback',@subjID);
        uicontrol(subj_fig,'Style','edit','HorizontalAlignment','Left','Units','normalized','Max',10,'Min',0,'Visible','on','Position',[.055,.425,.875,.4],'Callback',@addSubjInfo);
    
        uicontrol(subj_fig,'Style','pushbutton','Callback',@subjInfo_Close,'String','OK','Units','normalized','Position',[.75,.225,.15,.05]);
%         pbZeroFM = uicontrol(targetDAQ.Fig,'Style','pushbutton','Callback',@Zero_FM_Callback,'String','Zero FM','FontWeight','Bold','FontSize',9,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.825 0.400 0.10 0.05]);
    end

    function subjID(source,event)
        currentFolder = pwd;
        subjStr = source.String;
        subjDir = fullfile(currentFolder,subjStr);
        mkdir(subjDir);
        lArmPath = fullfile(subjDir,'Left');
        rArmPath = fullfile(subjDir,'Right');
        mkdir(lArmPath);
        mkdir(rArmPath);
        myhandles.subjID = subjStr;
        myhandles.lArmPath = lArmPath;
        myhandles.rArmPath = rArmPath;
        myhandles.currDir = currentFolder;
    end

    function addSubjInfo(source,event)
        addInfo = source.String;
        oldInfo = myhandles.addInfo;
        myhandles.addInfo = [oldInfo,addInfo];
    end

    function subjInfo_Close(source,event)
        try
            g = findobj('-depth',1,'type','figure','Name','Subject Information Menu');
            delete(g)
        end
    end

    function dataCreation(source,event) 
        data_figure = figure(7);
        data_figure.Position = [100,100,500,600];
        data_figure.MenuBar = 'none';
        data_figure.Name = 'Plotting Options Menu';
        
        uicontrol(data_figure,'Style','text','FontSize',10,'String','Plot #','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.025,.85,.2,.125]);
        uicontrol(data_figure,'Style','text','FontSize',10,'String','Plot Name','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.15,.85,.25,.125]);
        uicontrol(data_figure,'Style','text','FontSize',10,'String','Data Type','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.35,.85,.25,.125]);
        uicontrol(data_figure,'Style','text','FontSize',10,'String','Channel Number','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.65,.85,.25,.125]);
        
        plotNumber = myhandles.plotNumber;
        channelList = sort(myhandles.Channels);

        plotNamesArray = myhandles.plotNames;
        plotTypesArray = myhandles.plotTypes;

        for i = 1:plotNumber
            if i <= length(plotNamesArray)
                tempStr = plotNamesArray{i};
                tempVal = plotTypesArray(i);
            else
                tempStr = ['Plot',' ',num2str(i)];
                tempVal = 10;
            end
            
            uicontrol(data_figure,'Style','text','FontSize',10,'String',num2str(i),'HorizontalAlignment','Left','Units','normalized','Position',[.05,.84-(0.04*(i-1)),.1,.1]);
            plotNameTxt(i) = uicontrol(data_figure,'Style','edit','HorizontalAlignment','Left','String',tempStr,'Units','normalized','UserData',num2str(i),'Visible','on','Position',[.15,.9125-0.04*(i-1),.15,.025],'Callback',@plotNameListCreation);
            plotTypes(i) = uicontrol(data_figure,'Style','popupmenu','HorizontalAlignment','Left','Units','normalized','String',{'Fx','Fy','Fz','SFE','SAA','SEIR','EFE','WFE','Raw','EMG'},'Value',tempVal,'UserData',num2str(i),'Visible','on','Position',[.35,.9125-0.04*(i-1),.15,.025],'Callback',@plotTypeListCreation);
            plotChans(i) = uicontrol(data_figure,'Style','popupmenu','HorizontalAlignment','Left','Units','normalized','String',channelList,'Value',1,'UserData',num2str(i),'Visible','on','Enable','off','Position',[.65,.9125-0.04*(i-1),.2,.025],'Callback',@plotChanListCreation);

            if tempVal == 9 || tempVal == 10
%             if plotTypesArray(i) == 9 || plotTypesArray(i) == 10
                plotChans(i).Enable = 'on';
                if myhandles.loadFilePrev == 1
                    if tempVal == 9
                        plotChans(i).Value = myhandles.plotRawList(i);
                    elseif tempVal == 10
                        plotChans(i).Value = myhandles.plotEMGList(i);
                    end
                end
            end
        end

        chanTypes = myhandles.chanTypeList;
        
        myhandles.possibleEMGChan = [];
        
        for i = 1:length(chanTypes)
            if strcmp(chanTypes{i},'8')
                myhandles.possibleEMGChan(i) = channelList(i);
            end
        end
        
        oldLength = length(myhandles.prevPlotTypes);
        newLength = length(myhandles.plotTypes);
        
        myhandles.loadFilePrev = 0;
        
        if myhandles.pbOKdfe_Callback == 1 && (oldLength == newLength)
            for i = 1:plotNumber
                plotNameTxt(i).String = plotNamesArray{i};
                plotTypes(i).Value = plotTypesArray(i);

                if plotTypesArray(i) == 9 || plotTypesArray(i) == 10
                    plotChans(i).Enable = 'on';
                    if plotTypesArray(i) == 9
                        tempVal =  myhandles.plotRawList(i);
                    elseif plotTypesArray(i) == 10
                        tempVal =  myhandles.plotEMGList(i);
                    end
                    
                    if oldLength ~= newLength
                        disp('entered here 952');
                        tempVal = tempVal + 1;
                    end
                    plotChans(i).Value = tempVal;
                end
            end
        end
        
        pbOKdfe = uicontrol(data_figure,'Style','pushbutton','HorizontalAlignment','Left','Units','normalized','String','Ok','Callback',@pbOKdfe_Callback,'Position',[.25,.0225,.2,.025]);
        pbCanceldfe = uicontrol(data_figure,'Style','pushbutton','HorizontalAlignment','Left','Units','normalized','String','Cancel','Callback',@pbCanceldfe_Callback,'Position',[.5,.0225,.2,.025]);
        
        if strcmp(source.Checked,'off')
            source.Checked = 'on';
        else
            source.Checked = 'off';
        end
        
        myhandles.plotChansGUI= plotChans;
    end

    function pbOKdfe_Callback(source,event)        
        plotNumber = myhandles.plotNumber;
        
        for i = 1:plotNumber
            if myhandles.plotTypes(i)==0
                myhandles.plotTypes(i) = 9;
            elseif myhandles.plotTypes(i)==9 || myhandles.plotTypes(i)==10
                if myhandles.plotTypes(i)==9
                    if myhandles.plotRawList(i) == 0
                        myhandles.plotRawList(i) = 1;
                    end
                elseif myhandles.plotTypes(i)==10
                    if myhandles.plotEMGList(i) == 0
                        myhandles.plotEMGList(i) = 1;
                    end
                end
            end
        end
        
        myhandles.prevPlotTypes = myhandles.plotTypes;
        
        myhandles.pbOKdfe_Callback = 1;
        myhandles.pbCanceldfe_Callback = 0;
        close(gcf);
    end

    function pbCanceldfe_Callback(source,event)
        myhandles.plotTypes = myhandles.prevPlotTypes;
        myhandles.pbOKdfe_Callback = 0;
        myhandles.pbCanceldfe_Callback = 1;
        close(gcf);
    end

    function plotNameListCreation(source,event)
        addName = source.String;
        locStr = source.UserData;
        loc = str2num(locStr);
        myhandles.plotNames{loc} = addName;
    end

    function plotTypeListCreation(source,event)
        locStr = source.UserData;
        loc = str2num(locStr);
        type = source.Value;
        plotChans = myhandles.plotChansGUI;
        
        if type == 9 || type == 10
            plotChans(loc).Enable = 'on';
        else
            plotChans(loc).Enable = 'off';
        end
        
        myhandles.plotTypes(loc) = type;
    end

    function plotChanListCreation(source,event)
        locStr = source.UserData;
        loc = str2num(locStr);
        val = source.Value;
        channelList = sort(myhandles.Channels);
        %may need to have the below equal to val, not channelList(val)-
        %remember!!!
        if myhandles.plotTypes(loc) == 9
            myhandles.plotRawList(loc) = val;
        elseif myhandles.plotTypes(loc) == 10
            myhandles.plotEMGList(loc) = val;
        end
    end

%Editing note: if you need to add another JR3 option, or modify it such
%that you can have two selected at once, modify below
    function selectJR3(source,event)
        if strcmp(source.Checked,'off')
            source.Checked = 'on';
        else
            source.Checked = 'off';
        end
        
        label = source.Label;
        
        switch label
            %Add another case for another JR3 type if you don't want to
            %import one that's not on this list every time
            case '45E15A-RIC-A 1000N125'
                sensMatTotal = evalin('base', 'load(''JR3RICLarge.mat'')');
                myhandles.sensMat = sensMatTotal.JR3RICLarge;
                %                 load('JR3RICLarge');
                mSelectJR3_2.Checked = 'off';
                mSelectJR3_3.Checked = 'off';
                mSelectJR3_Other.Checked = 'off';
            case '45E15A-U760-A 250L1125'
                MaxLoad = 1;
                if ~MaxLoad
                    sensMatTotal = evalin('base', 'load(''JR3U760Small.mat'')');
                    myhandles.sensMat = sensMatTotal.JR3U760Small;
                else
                    sensMatTotal = evalin('base', 'load(''JR3U760Large.mat'')');
                    myhandles.sensMat = sensMatTotal.JR3U760Large;
%                     sensMat = evalin('base', 'load(''adjJR32620xV2'')');
%                     myhandles.sensMat = sensMat.adjJR32620xV2;
                end
                mSelectJR3_1.Checked = 'off';
                mSelectJR3_3.Checked = 'off';
                mSelectJR3_Other.Checked = 'off';
            case 'Amee JR3 45E15A-U760-A 250L1125'
                sensMatTotal = evalin('base', 'load(''JR3BdxMat.mat'')');
                myhandles.sensMat = sensMatTotal.JR3BdxMat;
                mSelectJR3_1.Checked = 'off';
                mSelectJR3_2.Checked = 'off';
                mSelectJR3_Other.Checked = 'off';
            case 'Other'
                sensMatTotal = uiimport;
                fnames = fieldnames(sensMatTotal);
                myhandles.sensMat = sensMatTotal.(fnames{1});
                mSelectJR3_1.Checked = 'off';
                mSelectJR3_2.Checked = 'off';
                mSelectJR3_3.Checked = 'off';
        end
        myhandles.JR3name = label;
    end

%Callbacks for Experimental Setup Panel
%Abduction Angle
    function abdAngle_Callback(source,event)
        abdAngleNum = str2num(source.String);
        source.UserData = abdAngleNum;
        myhandles.abdAngle = abdAngleNum;
    end

%Elbow Flexion Angle
    function EFAngle_Callback(source,event)
        EFAngleNum = str2num(source.String);
        source.UserData = EFAngleNum;
        myhandles.efAngle = EFAngleNum;
    end

%Arm Length
    function ArmLength_Callback(source,event)
        ALengthNum = str2num(source.String);
        source.UserData = ALengthNum;
        myhandles.aLength = ALengthNum;
    end

%Forearm length
    function FArmLength_Callback(source,event)
        FALengthNum = str2num(source.String);
        source.UserData = FALengthNum;
        myhandles.faLength = FALengthNum;
    end

%Z-offset
    function ZOffset_Callback(source,event)
        zOffNum = str2num(source.String);
        source.UserData = zOffNum;
        myhandles.zOffset = zOffNum;
    end

%Callbacks for DAQ Parameters Panel
%%These functions are going to be used to obtain information that we
%%need in order to initialize the DAQ

%# of Channels: This function will send the correct number of channels
%to read to the DAQ as well as generate the correct number of plots for
%the number of channels- this will tell us how many channels the DAQ needs
%to initialize
    function nChan_Callback(source,event)
        newNumChan = str2num(source.String);
        source.UserData = newNumChan;
        numChan = myhandles.nChan;
        totPossibleChan = myhandles.maxChannels;
        fileLoaded = myhandles.loadFile;
        initDaq = myhandles.initDaq;
        armSwitch = myhandles.armSwitched;
        %         myhandles.oldNChan = newNumChan;
        
        if newNumChan < 6 || newNumChan > totPossibleChan
            max = myhandles.maxChannels;
            warning = 'O_o. incorrect number of channels entered- min of 6 and max of %d needed for proper usage. Please re-enter appropriate value.';
            str = sprintf(warning,max);
            errordlg(str,'User Error');
        end
        
        if fileLoaded == 1 || initDaq == 1
            if numChan == newNumChan
                chGUI(numChan)
            else
                chGUI(newNumChan);
            end
        else
            chGUI(newNumChan);
        end
                
%         myhandles.Channels = [0:(newNumChan-1)];
        myhandles.nChan = newNumChan;
        myhandles.oldChanList = myhandles.Channels;
    end

    function chGUI(updatedNumChan)
        %This GUI stems off of the main GUI and allows you to create a list
        %of which channels you'd like to read from
        myhandles.placeHolder = myhandles.Channels;
        
        channelList = myhandles.Channels;
        channelNameList = myhandles.NameChannels;
        
        numChan = updatedNumChan;
        myhandles.nChan = numChan;
        totPossibleChan = myhandles.maxChannels;
        armChoice = myhandles.armChoice;
        armSwitch = myhandles.armSwitched;
        
        if armSwitch == 1
            if strcmp(armChoice,'left')
                channels = myhandles.lChannels;
                chanNames = myhandles.lNameChannels;
            else
                channels = myhandles.rChannels;
                chanNames = myhandles.rNameChannels;
            end
            
            channelList = [];
            channelNameList = {};
        else
            if numChan == 6
                if strcmp(armChoice,'left')
                    channels = myhandles.lChannels;
                    chanNames = myhandles.lNameChannels;
                else
                    channels = myhandles.rChannels;
                    chanNames = myhandles.rNameChannels;
                end
                
                chanArray = channels;
                chanList = sort(channels);
                
                myhandles.chanTypeList = cell(1,myhandles.nChan);
                
                for i = 1:numChan
                    chanVal = chanList(i);
                    if find(chanVal==chanArray)
                        ind = find(chanVal==chanArray);
                        myhandles.chanTypeList{i} = num2str(ind);
                    else
                        myhandles.chanTypeList{i} = num2str(8);
                    end
                end
                
                myhandles.noStrChanTypeList = str2double(myhandles.chanTypeList);
            else
                channels = [];
                chanNames = {};
                % || myhandles.oldNChan == 6
                if myhandles.loadFile == 1 || myhandles.initChSelect == 1
                    channels = [];
                    chanNames = [];
                else
                    if myhandles.initChSelect == 0
                        if strcmp(armChoice,'left')
                            channels = myhandles.lChannels;
                            chanNames = myhandles.lNameChannels;
                        else
                            channels = myhandles.rChannels;
                            chanNames = myhandles.rNameChannels;
                        end
                        myhandles.Channels = channels;
                    else
                        channels = [];
                        chanNames = [];
                    end
                end
            end
        end
        
        
        totChannels = channels;
        totChanNames = chanNames;
        
        if numChan > 6
            f1 = figure('Name','Channel Selection Menu','NumberTitle', 'off');
            f1.Position = [100, 100, 600, 200];
            f1.MenuBar = 'none';
            %             f1.Name = 'Channel Selection Menu';
            f1.DeleteFcn = @closeChGUI;
            
%             hLine(4)=line('Parent',targetGUI.Axes1,'Xdata',xt(:,1),'Ydata',xt(:,2),'Color','r','LineWidth',2);

            chNumber = 0;
            maxChan = myhandles.maxChannels;
            
            for i = 1:4
                for j = 1:7
                    if chNumber < maxChan
                        chButton(chNumber+1) = uicontrol(f1,'Style','checkbox','String',['Channel',' ',num2str(chNumber)],'Units','Normalized','Callback',@cSelect,'Position',[0.0125+(0.137*(j-1)),0.8675-(0.175*(i-1)), 0.125 0.15],'UserData',num2str(chNumber));
                        if find(chNumber==totChannels)
                            chButton(chNumber+1).Value = 1;
                        end
                        chNumber = chNumber + 1;
                    end
                end
            end

            myhandles.pbChSelect = uicontrol(f1,'Style','pushbutton','Callback',@pbChSelect_Callback,'String','Initialize Channels','Units','normalized','Position',[0.25 0.05 0.5 0.2]);            

            for i = 1:totPossibleChan
                button = chButton(i);
                name = button.String;
                for j = 1:length(channelNameList)
                    if strcmp(channelNameList(j),name)
                        button.Value = 1;
                    end
                end
            end       
            
            addChan = channelList;
            totChannels = [channels,addChan];
            totChanNames = [chanNames,channelNameList];
        end
        
        myhandles.Channels = totChannels;
        myhandles.NameChannels = totChanNames;
        myhandles.armSwitched = 0;
    end

    function chListMaker(value,name,channel)
        %This function is called by the GUI to update the channel list
        channelList = myhandles.Channels;
        channelNameList = myhandles.NameChannels;
        
        if value == 1
            %Need to make sure first that the channel
            %isn't already in the list of channels-
            %shouldn't be, but we should confirm
            notHere = 1;
            for i = 1:length(channelList)
                if channelList(i)==channel
                    notHere = notHere + 1;
                end
            end
            
            if notHere == 1
                %This means that the channel is not
                %already in the list, so we should add
                %it
                channelList = [channelList, channel];
                channelNameList = [channelNameList, name];
            end
        else
            %A value that is not equal to 1 means that
            %the channel is no longer clicked, which
            %means that we need to remove it from our
            %channel list
            
            %First, check if it is in the channel list
            %or not, then create a new list without it
            ind = [];
            for i = 1:length(channelList)
                if channelList(i) == channel
                    ind = [ind,i];
                end
            end
            
            for i = 1:length(ind)
                channelList = channelList(channelList~=channelList(ind(i)));
                if ind(i) == 1
                    channelNameList = channelNameList(2:length(channelNameList));
                elseif ind(i) == length(channelNameList)
                    channelNameList = channelNameList(1:length(channelNameList)-1);
                else
                    channelNameList = [channelNameList(1:ind(i)-1),channelNameList(ind(i)+1:length(channelNameList))];
                end
            end
        end
        
        myhandles.Channels = channelList;
        myhandles.NameChannels = channelNameList;
        disp('channel list after chlistmaker: ');
        disp(myhandles.Channels);
    end

    function pbChSelect_Callback(source,event)
        val = source.Value;
        
        channelList = myhandles.Channels;
        numChan = myhandles.nChan;
        
        try
            g = findobj('-depth',1,'type','figure','Name','Channel Selection Menu');
        end
        
        if length(channelList) ~= numChan
            errordlg('Your selected number of channels does not equal the number of channels inputted- please adjust and try again!');
            uiwait(g);
        else
            if val == 1
                myhandles.initChSelect = 1;
                try
                    delete(g);
                end
                
                chanTypeGUI();
            end
        end
    end

    function chanTypeGUI(source,event)
        chan_data_spec_figure = figure('Name','Channel Specification Menu','NumberTitle', 'off');
        chan_data_spec_figure.Position = [100,100,300,600];
        chan_data_spec_figure.MenuBar = 'none';
        
        cdsTxt = uicontrol(chan_data_spec_figure,'Style','text','FontSize',9.5,'String','Channel Number','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.025,.85,.4,.125]);
        cdsTxt = uicontrol(chan_data_spec_figure,'Style','text','FontSize',9.5,'String','Data Type','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.6,.85,.4,.125]);
        
        plotNumber = myhandles.plotNumber;
        channelList = sort(myhandles.Channels);
        
        typesPossible = myhandles.typesPossible;
        
        numChan = myhandles.nChan;
        
        chanList = sort(myhandles.Channels);
        oldChanList = sort(myhandles.oldChanList);
        
        armChoice = myhandles.armChoice;
        
        if strcmp(armChoice,'left')
            chanArray = myhandles.lChannels;
        else
            chanArray = myhandles.rChannels;
        end
        
        fileLoaded = myhandles.loadFile;
%         numChan = myhandles.nChan;
        
        blankChanTypeList = cell(1,myhandles.nChan);
        
        chanTypeList = myhandles.chanTypeList;
        
        for i = 1:numChan
            chanTypes(i) = uicontrol(chan_data_spec_figure,'Style','popupmenu','HorizontalAlignment','Left','Units','normalized','String',typesPossible,'UserData',num2str(i),'Position',[.525,.9125-.04*(i-1),.4,.025],'Callback',@chanTypeListCreation);
            chanTypesTxt(i) = uicontrol(chan_data_spec_figure,'Style','text','FontSize',10,'String',num2str(chanList(i)),'HorizontalAlignment','Left','Units','normalized','Position',[.2,.84-(0.04*(i-1)),.1,.1]);
        end
        
        if (myhandles.pbOKcds_Callback~=0)&&(myhandles.oldNChan ~= myhandles.nChan)&&(fileLoaded ~= 1)
            
            chanTypeList = cell(1,myhandles.nChan);
            
            for i = 1:length(chanList)
                if find(chanList(i) == oldChanList)
                    ind = find(chanList(i)==oldChanList);
                    chanTypeList{i} = myhandles.chanTypeList{ind};
                end
            end
            myhandles.chanTypeList = chanTypeList;
        end
        
        for i = 1:numChan
            chanVal = chanList(i);            
            if (fileLoaded || myhandles.pbOKcds_Callback)== 1 && (myhandles.nChan == myhandles.oldNChan)
                chanTypes(i).Value = str2num(myhandles.chanTypeList{i});
            elseif (fileLoaded || myhandles.pbOKcds_Callback)== 1
                if isempty(myhandles.chanTypeList{i})
                    chanTypes(i).Value = 8;
                else
                    chanTypes(i).Value = str2num(myhandles.chanTypeList{i});
                end
            else
                if find(chanVal==chanArray)
                    ind = find(chanVal==chanArray);
                    chanTypes(i).Value = ind;
                    blankChanTypeList{i} = num2str(ind);
                else
                    chanTypes(i).Value = 8;
                    blankChanTypeList{i} = num2str(8);
                end
                myhandles.chanTypeList = blankChanTypeList;
            end
        end
        
        pbOKcds = uicontrol(chan_data_spec_figure,'Style','pushbutton','HorizontalAlignment','Left','Units','normalized','String','Ok','Callback',@pbOKcds_Callback,'Position',[.25,.0225,.2,.025]);
        pbCancelcds = uicontrol(chan_data_spec_figure,'Style','pushbutton','HorizontalAlignment','Left','Units','normalized','String','Cancel','Callback',@pbCancelcds_Callback,'Position',[.5,.0225,.2,.025]);
        
    end

    function chanTypeListCreation(source,event)
        locStr = source.UserData;
        loc = str2num(locStr);
        val = num2str(source.Value);
        myhandles.chanTypeList{loc} = val;
    end

    function cSelect(source,event)
        value = source.Value;
        blahstr = source.UserData;
        channel = str2num(blahstr);
        name = source.String;
        chListMaker(value,name,channel);
    end

    function pbOKcds_Callback(source,event)
        chanList = sort(myhandles.Channels);
        armChoice = myhandles.armChoice;
        
        if strcmp(armChoice,'left')
            chanArray = myhandles.lChannels;
        else
            chanArray = myhandles.rChannels;
        end
        
        chanTypes = myhandles.chanTypeList;
        
        for i = 1:length(myhandles.chanTypeList)
            chanVal = chanList(i);
            
            if isempty(chanTypes{i})
                if find(chanVal==chanArray)
                    ind = find(chanVal==chanArray);
                    chanTypes{i} = num2str(ind);
                else
                    chanTypes{i} = num2str(8);
                end
            end
        end
        
        myhandles.prevChanTypeList = myhandles.chanTypeList;
        myhandles.chanTypeList = chanTypes;
        myhandles.noStrChanTypeList = str2double(myhandles.chanTypeList);
        myhandles.pbOKcds_Callback = 1;
        myhandles.pbCancelcds_Callback = 0;
        myhandles.oldNChan = myhandles.nChan;
        
        try
            g = findobj('-depth',1,'type','figure','Name','Channel Specification Menu');
            delete(g)
        end
    end

    function pbCancelcds_Callback(source,event)
        myhandles.chanTypeList = myhandles.prevChanTypeList;
        myhandles.noStrChanTypeList = str2double(myhandles.chanTypeList);
        myhandles.pbOKcds_Callback = 0;
        myhandles.pbCancelcds_Callback = 1;
        try
            g = findobj('-depth',1,'type','figure','Name','Channel Specification Menu');
            delete(g)
        end
    end

%Sampling Rate
    function SampRate_Callback(source,event)
        sampRate = str2num(source.String);
        source.UserData = sampRate;
        myhandles.sRate = sampRate;
    end

%Sampling Time
    function SampTime_Callback(source,~)
        sampTime = str2num(source.String);
        source.UserData = sampTime;
        myhandles.sTime = sampTime;
    end

% %Timer Value
%     function TimerVal_Callback(source,event)
%         %         myhandles.kinematicsDAQ
%         timeDelay = str2num(source.String);
%         source.UserData = timeDelay;
%         myhandles.Timer = timeDelay;
%     end

%File Name
    function FileName_Callback(source,event)
        myhandles.fileName = source.String;
        %         myhandles.itrial = 1;
        blah = getappdata(targetDAQ.Fig,'itrial');
        myhandles.TrialNumber = num2str(blah);
        %Check if the file already exists in your directory
        fileStr = [myhandles.fileName,myhandles.TrialNumber];
        
        testFileStr = [fileStr,'.mat'];
        newFileStr = checkFile(testFileStr);
        
        myhandles.fileName = newFileStr{1};
        myhandles.itrial = str2num(newFileStr{2});
        myhandles.TrialNumber = newFileStr{2};
        
        etNumTr.String = myhandles.TrialNumber;
        fileName_Edit.String = myhandles.fileName;
    end

    function nFileStr = checkFile(fileStr)
        existence = exist(fileStr,'file');
        if existence == 2
            choice = questdlg('This file already exists- would you like to overwrite it?','File Save Error','Yes','No','No');
            if strcmp(choice,'No')
                nFileStr = inputdlg({'Enter new file name: ','Enter trial number: '},'Change File Name',1,{'file','1'});
                myhandles.TrialNumber = nFileStr{2};
                myhandles.itrial = str2num(myhandles.TrialNumber);
                etNumTr.String = myhandles.TrialNumber;
                nFileStr = {nFileStr{1},nFileStr{2}};
            else
                blah = getappdata(targetDAQ.Fig,'itrial');
                myhandles.TrialNumber = num2str(blah);
                nFileStr = {myhandles.fileName,myhandles.TrialNumber};
            end
        else
            blah = getappdata(targetDAQ.Fig,'itrial');
            myhandles.TrialNumber = num2str(blah);
            nFileStr = {myhandles.fileName,myhandles.TrialNumber};
        end
    end

    function TrialNumber_Callback(source,event)
        myhandles.TrialNumber = source.String;
        myhandles.itrial = str2num(myhandles.TrialNumber);
        setappdata(targetDAQ.Fig,'itrial',myhandles.itrial);
        disp('myhandles.itrial: ');
        disp(myhandles.itrial);
        newFileStr = [myhandles.fileName,myhandles.TrialNumber];
        newFileStr = [newFileStr,'.mat'];
        nFileStr = checkFile(newFileStr);
        %Check if the file already exists in your directory
        
        myhandles.fileName = nFileStr{1};
        myhandles.itrial = str2num(nFileStr{2});
        disp('myhandles.itrial: ');
        disp(myhandles.itrial)
        myhandles.TrialNumber = nFileStr{2};
        setappdata(targetDAQ.Fig,'itrial',myhandles.itrial);
        blah = getappdata(targetDAQ.Fig,'itrial');
    end

%Right or Left Arm
    function rbExpCallback(rbg,event)
        sbnew = event.NewValue.String;
        sbold = event.OldValue.String;
        %         if ~strcmp(sbnew,sbold) && (initChan == 1)
        if ~strcmp(sbnew,sbold)
            myhandles.armSwitched = 1;
            myhandles.pbAcquireVal = 0;
        end
        ArmBG = rbg.SelectedObject.String;
        rbg.UserData = ArmBG;
        myhandles.armChoice = ArmBG;
    end

%Function that provides plots as feedback on the GUI
    function awesomePlotMaker(nChan,varargin)
%%Determine the number of columns we need
        %First, find out whether there is a remainder when the # of
        %channels is divided by 5
        r = rem(myhandles.plotNumber,5);
        numplots = 1;
        
        plotNames = myhandles.plotNames;
        
        posVectors = [];
        
        if nargin == 1
            if r == 0
                nFullCols = myhandles.plotNumber/5;
                colDist = 0.75/(nFullCols);
                for i = 0:(nFullCols-1)
                    for j = 1:5
                        posVect = [0.025+(colDist*i), 1-(0.1875*j), colDist-0.0375, 0.15];    % position of first subplot
                        val = j+(5*i);
                        myhandles.ax(val) = subplot('Position',posVect);
                        myhandles.LivePlot(val) = plot(0,0);
                        title(plotNames(numplots),'FontSize',8.5)
                        numplots = numplots+1;
                        j = j+1;
                        posVectors = [posVectors;posVect];
                        %This calculation below will tell us which row the
                        %last plot should be in. Since, in this case
                        %category, the number of channels is easily
                        %divisible by 5, we know that the next row a
                        %plot would be plotted on is the first one in
                        %the next column.
                        if i == nFullCols-2 && j == 5
                            rowNum = 1;
                        end
                    end
                end
            else
                plotNumber = myhandles.plotNumber;
                nFullCols = floor(plotNumber/5);
                colDist = 0.75/(nFullCols+1);
                for i = 0:(nFullCols-1)
                    for j = 1:5
                        posVect = [0.025+(colDist*i), 1-(0.1875*j), colDist-0.0375, 0.15];    % position of first subplot
                        val = j+(5*i);
                        myhandles.ax(val) = subplot('Position',posVect);
                        myhandles.LivePlot(val) = plot(0,0);
                        %                         subplot('Position',posVect)
                        title(plotNames(numplots),'FontSize',8.5)
                        numplots = numplots+1;
                        j = j+1;
                        posVectors = [posVectors;posVect];
                    end
                    i = i+1;
                end
                
                for i = 1
                    for j = 1:r
                        posVect = [0.025+(colDist*(nFullCols)), 1-(0.1875*j), colDist-0.0375, 0.15];
                        %                         subplot('Position',posVect)
                        val = j*(nFullCols);
                        myhandles.ax(val) = subplot('Position',posVect);
                        myhandles.LivePlot(val) = plot(0,0);
                        posVectors = [posVectors;posVect];
                        title(plotNames(numplots),'FontSize',8.5)
                        numplots = numplots+1;
                        if j == r
                            rowNum = j+1;
                        end
                        j = j+1;
                    end
                end
            end
            save('posVectors','posVectors');
            myhandles.oldPlotNumber = myhandles.plotNumber;
        else
            totalData = varargin{1};
            data = totalData(:,1:size(totalData,2)-1);
            time = totalData(:,size(totalData,2));
            load('posVectors');
            %             maxVals = myhandles.maxVals;
            maxVals = [];
            totPlots = myhandles.plotNumber;
            nCol = ceil(totPlots/5);
            idx = reshape([1:totPlots, zeros(1,5-rem(totPlots,5))],5,[])';
            idx = idx(:);
            idxNew = idx(find(idx~=0));
            
            figure(1);
            
            plotNamesList = myhandles.plotNames;
            plotTypeList = myhandles.plotTypes;
            
            chanTypeList = myhandles.chanTypeList;
            
            [orgData,elementArray,emgChanList] = dataOrganizer(data,chanTypeList);
            
            jr3ForceNum = elementArray(1);
            EMGForceNum = elementArray(2);
            otherForceNum = elementArray(3);
            extraDataNum = elementArray(4);
            
            convData = dataConverter(orgData,elementArray,data);
            
            FMhand = convData(:,1:7);
            meanFM=meanfilt(FMhand,0.25*myhandles.sRate);
            
            ForcePlots=[1:7];
            
            newEMGForceNum = 0;
            
            for i = 1:length(plotTypeList)
                if plotTypeList(i) == 10
                    newEMGForceNum = newEMGForceNum + 1;
                end
            end
            
            plotRawInd = jr3ForceNum+2+newEMGForceNum+otherForceNum;
            plotEMGInd = jr3ForceNum+2;

            plotRawIndList = 0*ones(1,length(plotTypeList));
            plotEMGIndList = 0*ones(1,length(plotTypeList));
            
            for i = 1:length(plotTypeList)
                if plotTypeList(i) == 9
                    plotRawIndList(i) = plotRawInd;
                    plotRawInd = plotRawInd + 1;
                elseif plotTypeList(i) == 10
                    plotEMGIndList(i) = plotEMGInd;
                    plotEMGInd = plotEMGInd + 1;
                end
            end
            
            for i = 1:(length(idxNew))
                subplot('Position',posVectors(idxNew(i),:));
                title(plotNamesList(idxNew(i)),'FontSize',8.5);
                val = plotTypeList(idxNew(i));
                
                if find(val==ForcePlots)
                    plot(time,convData(:,val),'r');
                    
                    [xpt,ypt] = plotLabelHelper();
                    if val < 8
                        txtVal2 = max(abs(meanFM(:,val)));
                    else
                        txtVal2 = max(abs(meanFM(:,(val-1))));
                    end
                    
                    txtVal1 = max(abs(convData(:,val)));
                    
                    txtVal1Str = sprintf('%.3f',txtVal1);
                    txtVal2Str = sprintf('%.3f',txtVal2);
                    str = {txtVal1Str,txtVal2Str};
                    text(xpt,ypt,str);
                    maxVals = [maxVals;[plotNamesList(idxNew(i)),txtVal2]];
                    
                elseif(val==9)
                    %plotting RAW
                    plot(time,convData(:,plotRawIndList(idxNew(i))),'g');
                    
                elseif(val==8)
                    %plot WFE
                    newInd = jr3ForceNum + newEMGForceNum + otherForceNum;
                    
%                     plot(time,convData(:,newInd+1),'c');
                    meanConvData=meanfilt(convData,0.25*myhandles.sRate);
                    plot(time,meanConvData(:,newInd+1),'c');
                    [xpt,ypt] = plotLabelHelper();
                    
                    txtVal1 = max(abs(convData(:,newInd+1)));
                    txtVal2 = max(abs(meanConvData(:,newInd+1)));
                    txtVal1Str = sprintf('%.3f',txtVal1);
                    txtVal2Str = sprintf('%.3f',txtVal2);
                    str = {txtVal1Str,txtVal2Str};
                    text(xpt,ypt,str);
                    maxVals = [maxVals;[plotNamesList(idxNew(i)),txtVal2]];
                    
                elseif(val==10)
                    %plot EMG
                    meanConvData=meanfilt(abs(convData),0.25*myhandles.sRate);
                    plot(time,convData(:,plotEMGIndList(idxNew(i))),time,meanConvData(:,plotEMGIndList(idxNew(i))),'b');
                    [xpt,ypt] = plotLabelHelper();
                    txtVal1 = max(abs(convData(:,plotEMGIndList(idxNew(i)))));
                    txtVal2 = max(abs(meanConvData(:,plotEMGIndList(idxNew(i)))));
                    txtVal1Str = sprintf('%.3f',txtVal1);
                    txtVal2Str = sprintf('%.3f',txtVal2);
                    str = {txtVal1Str,txtVal2Str};
                    text(xpt,ypt,str);
                    maxVals = [maxVals;[plotNamesList(idxNew(i)),txtVal2]];
                end
                
                title(plotNamesList(idxNew(i)),'FontSize',8.5)
                xlabel('Time (secs)');
                ylabel('Voltage');
            end
            
            myhandles.maxVals = maxVals;
        end
    end

    function [xpt,ypt] = plotLabelHelper()
        xAxlimit = xlim;
        xpt = ((xAxlimit(2)-xAxlimit(1))/2) + xAxlimit(1);
        yAxlimit = ylim;
        ypt = ((yAxlimit(2)-yAxlimit(1))/2) + yAxlimit(1);
    end

    function [orgData,elementArray,emgChanList] = dataOrganizer(data,chanTypeList)
        newData = data;
        jr3ForceData = ones(size(data,1),6);
        emgData = [];
        otherData = [];
        
        jr3ForceNum = 0;
        EMGForceNum = 0;
        otherForceNum = 0;
        extraDataNum = 0;
        emgChanList = [];
        extraData = [];
        totalChanList = sort(myhandles.Channels);
%         emgChanOptions = 0*(ones(1,myhandles.plotNumber));
        for i = 1:length(chanTypeList)
            type = chanTypeList{i};
            
            switch type
                case {'1','2','3','4','5','6'}
                    %This is for JR3 1
                    typeNoStr = str2num(type);
                    jr3ForceData(:,typeNoStr) = newData(:,i);
                    jr3ForceNum = jr3ForceNum + 1;
                case '7'
                    otherData = [otherData,newData(:,i)];
                    otherForceNum = otherForceNum + 1;
                case '8'
                    %This is for EMG data
                    emgData = [emgData,newData(:,i)];
                    EMGForceNum = EMGForceNum + 1;
                    emgChanList = [emgChanList,totalChanList(i)];
%                     emgChanOptions(i+1) = i;
                case '9'
                    %This is for "other" data
                    extraData = [extraData,newData(:,i)];
                    extraDataNum = extraDataNum + 1;
            end
        end
        
%         %added for the generic one
%         myhandles.emgChanOptions = emgChanOptions;
        elementArray = [jr3ForceNum,EMGForceNum,otherForceNum,extraDataNum];
        orgData = [jr3ForceData,emgData,otherData,extraData];
    end

    function convData = dataConverter(orgData,elementArray,collectedData)
        jr3ForceNum = elementArray(1);
        EMGForceNum = elementArray(2);
        otherForceNum = elementArray(3);
        ind2 = jr3ForceNum+1;
        ind3 = ind2+EMGForceNum-1;
        ind4 = ind3 + 1;
        ind5 = ind4 + otherForceNum - 1;
        
        forceData = orgData(:,1:jr3ForceNum);
        otherForceData = orgData(:,ind4:ind5);
        convOForceData = forceConversion(otherForceData);
        
        FMhand = forceData;
        [m,n]=size(FMhand);
        FMhandbase=FMhand-(diag(mean(FMhand(1:10,:)))*ones(n,m))';
        FMtorque=JR3toFM(FMhandbase(:,1:6),myhandles);
        FMhand = FMtorque;
        
        %         channelList = sort(myhandles.Channels);
        
        plotTypeArray = myhandles.plotTypes;
        plotNumber = myhandles.plotNumber;
        
        emgData = [];
        len = length(plotNumber); %CHANGED AS A TEST 11/26
%         len = length(plotTypeArray);
        
        indR = 0;
        indEMG = 0;
       
        for i = 1:len
            if myhandles.plotRawList(i) == 0
                indR = indR + 1;
            end
            
            if myhandles.plotEMGList(i) == 0
                indEMG = indEMG + 1;
            end
        end
        
        if (myhandles.pbOKdfe_Callback ~= 1)
            for i = 1:len
                if (plotTypeArray(i) == 9) && (indR == len)
                    myhandles.plotRawList(i) = 1;
                elseif (plotTypeArray(i) == 10) && (indEMG == len)
%                     myhandles.plotEMGList(i) = myhandles.emgChanOptions(i);
                    myhandles.plotEMGList(i) = 1;
                end
            end
        end

        newEMGnum = 0;
        
        for i = 1:length(plotTypeArray)
            if plotTypeArray(i) == 10
                newEMGnum = newEMGnum + 1;
            end
        end

        if EMGForceNum~=0 && newEMGnum~=0
            for i = 1:plotNumber
                if plotTypeArray(i)==10
                    emgChan = myhandles.plotEMGList(i)-1;
%                     disp('emgChan: ');
%                     disp(emgChan);
                    emgData = [emgData,collectedData(:,emgChan+1)];
                end
            end
            
            EMG = emgData;
            [m,n]=size(EMG);
            EMGbase=EMG-(diag(mean(EMG(1:10,:)))*ones(n,m))';%LCM 10.1.14 to baseline correct hand torques/EMG on display
            
            if otherForceNum~=0
                convData = [FMhand,EMGbase,convOForceData];
            else
                convData = [FMhand,EMGbase];
            end
            
        elseif otherForceNum~=0
            convData = [FMhand,convOForceData];
        else
            convData = FMhand;
        end
        
        for i = 1:plotNumber
            if plotTypeArray(i)==9
                rawChan = myhandles.plotRawList(i)-1;
                %channel numbering starts at 1, but channel numbering
                %for the daq starts at 0
                convData = [convData,collectedData(:,rawChan+1)];
            end
        end
        
    end

    function convForceData = forceConversion(data)
        %need to have the actual conversion of the force data here
        convForceData = data;
    end

    function y = meanfilt(x,n)
        
        %MEANFILT  One dimensional mean filter.
        %   Y = MEANFILT(X,N) returns the output of the order N, one dimensional
        %   moving average 2-sided filtering of vector X.  Y is the same length
        %   as X;
        %
        %   If you do not specify N, MEANFILT uses a default of N = 3.
        
        %   Author(s): Ana Maria Acosta, 2-26-01
        
        if nargin < 2
            n=3;
        end
        if all(size(x) > 1)
            y = zeros(size(x));
            for i = 1:size(x,2)
                y(:,i) = meanfilt(x(:,i),n);
            end
            return
        end
        
        % Two-sided filtering to avoid phase shifts in the output
        y=filter22(ones(n,1)/n,x,2);
        
        % transpose if necessary
        if size(x,1) == 1  % if x is a row vector ...
            y = y.';
        end
    end

    function y = filter22(fil,x,numsides)
        %
        %	THIS FUNCTION PERFORMS 2-SIDED AS WELL AS ONE SIDED
        % 	FILTERING.  NOTE THAT FOR A ONE-SIDED FILTER, THE
        %	FIRST length(fil) POINTS ARE GARBAGE, AND FOR A TWO
        %	SIDED FILTER, THE FIRST AND LAST length(fil)/2
        %	POINTS ARE USELESS.
        %
        %	USAGE	: y = filter22(fil,x,numsides)
        %
        % EJP Jan 1991
        %
        [ri,ci]= size(x);
        if (ci > 1)
            x = x';
        end
        numpts = length(x);
        halflen = ceil(length(fil)/2);
        if numsides == 2
            xxx=zeros(size(1:halflen))';
            x = [x ; xxx];
            y = filter(fil,1,x);
            y = y(halflen:numpts + halflen - 1);
        else
            y=filter(fil,1,x);
        end
        if (ci > 1)
            y = y';
        end
        return
    end
%% CALLBACKS FOR MENU OPTIONS

%%Editing Notes: target options- this is the function you should edit if
%%you need to make the target respond to an additional movement
    function tarOpt_Callback(source,event)
        f2 = figure(3);
        
        f2.Position = [100,100,500,400];
        f2.MenuBar = 'none';
        f2.Name = 'Target Options Menu';
        
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Cursor Options','FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.0875,.775,.2,.15]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Cursor Size (Nm)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.675,.2,.15]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Pie Width (Nm)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.6,.2,.15]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Dial Zero (Deg)','HorizontalAlignment','Left','Units','normalized','Position',[.025,.525,.2,.15]);
        etTar1 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Cursor_size_Callback,'HorizontalAlignment','Left','String',myhandles.Cursor_s,'Units','normalized','Position',[.2375,.7875,.10,.0375]);
        etTar2 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Pie_size_Callback,'HorizontalAlignment','Left','String',myhandles.Pie_size,'Units','normalized','Position',[.2375,.7125,.10,0.0375]);
        etTar3 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@theta_zero_Callback,'HorizontalAlignment','Left','String',myhandles.th_zero,'Units','normalized','Position',[.2375,.6375,.10,0.0375]);
        
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Target Options (Nm)','FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.0325,.475,.3,.1]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Size','HorizontalAlignment','Left','Units','normalized','Position',[.025,.425,.15,.05]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Horizontal','HorizontalAlignment','Left','Units','normalized','Position',[.025,.35,.15,.05]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Vertical','HorizontalAlignment','Left','Units','normalized','Position',[.025,.275,.15,.05]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Rotation','HorizontalAlignment','Left','Units','normalized','Position',[.025,.20,.15,.05]);
        tTar = uicontrol(f2,'Style','text','FontSize',9,'String','Zoom','HorizontalAlignment','Left','Units','normalized','Position',[.025,.125,.15,.05]);
        
        etTar4 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_size_Callback,'HorizontalAlignment','Left','String',myhandles.Target_s,'Units','normalized','Position',[.2375,.4375,.10,.0375]);
        etTar5 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_x_Callback,'HorizontalAlignment','Left','String',num2str(myhandles.Target_x),'Units','normalized','Position',[.2375,.3625,.10,0.0375]);
        etTar6 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_y_Callback,'HorizontalAlignment','Left','String',num2str(myhandles.Target_y),'Units','normalized','Position',[.2375,.2875,.10,0.0375]);
        etTar7 = uicontrol(f2,'Style','edit','FontSize',9,'Callback',@Target_theta_Callback,'HorizontalAlignment','Left','String',myhandles.Target_t,'Units','normalized','Position',[.2375,.2125,.10,0.0375]);
        myhandles.etTar8 = uicontrol(f2,'Style','edit','FontSize',9,'Enable','off','Callback',@Target_zoom_Callback,'HorizontalAlignment','Left','String',myhandles.Target_z,'Units','normalized','Position',[.2375,.1375,.10,0.0375]);
        
        tarZoom = uicontrol(f2,'Style','checkbox','String','Zoom Feature','Callback',@zoomEnableCB,'Units','normalized','Position',[0.5 0.06125 0.25 0.05]);
        [x,map] = imread('Target.JPG');
        tarFigButton = uicontrol(f2,'Style','pushbutton','Units','normalized','Position',[0.4,0.25,0.55,0.55],'cdata',x,'Callback',@tarPBCB);
        
        ok_button = uicontrol(f2,'Style','pushbutton','Callback',@pbOkTarMenu_Callback,'String','OK','Units','normalized','Position',[0.825 0.1 0.15 0.05]);
        cancel_button = uicontrol(f2,'Style','pushbutton','Callback',@pbCancelTarMenu_Callback,'String','Cancel','Units','normalized','Position',[0.825 0.0375 0.15 0.05]);
        
    end

    function realtimeFMOpt_Callback(source,event) 
        RTFMfig = figure('Name','Realtime FM Menu','NumberTitle', 'off');
        RTFMfig.Position = [100,100,300,200];
        
        RTFMfig.MenuBar = 'none';
        RTFMfig.DeleteFcn = @closeRTFBOptions;
%         ,'FontWeight','Bold'
        RTFMtext = uicontrol(RTFMfig,'Style','text','FontSize',12,'String','Options: ','HorizontalAlignment','Left','Units','normalized','Position',[.225,.6,.25,.15]);
        RTForceOptions = uicontrol(RTFMfig,'Style','listbox','Max',5,'Min',0,'Enable','on','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','WFE'},'Value',1,'Units','Normalized','Callback',@FMOptSelect_Callback,'Position',[0.5 0.375 0.4 0.35]); 
        
        ok_button = uicontrol(RTFMfig,'Style','pushbutton','Callback',@pbOkRTFB_Callback,'String','OK','Units','normalized','Position',[0.05 0.1 0.4 0.125]);
        cancel_button = uicontrol(RTFMfig,'Style','pushbutton','Callback',@pbCancelRTFB_Callback,'String','Cancel','Units','normalized','Position',[0.5 0.1 0.45 0.125]);    
    end

    function pbOkRTFB_Callback(source,event)
        closeRTFBOptions();
    end

    function pbCancelRTFB_Callback(source,event)
        myhandles.RealtimeFMResp = myhandles.RealtimeFMRespPrev;
        closeRTFBOptions();
    end

    function closeRTFBOptions(source,event)
        try
            g = findobj('-depth',1,'type','figure','Name','Realtime FM Menu');
            delete(g)
            disp('closed :)');
        end
    end

    function zoomEnableCB(source,event)
        val = source.Value;
        button = myhandles.etTar8;
        
        if val == 1
            button.Enable = 'on';
            myhandles.zoomOpt = 1;
        else
            button.Enable = 'off';
            myhandles.zoomOpt = 0;
        end
    end

    function tarPBCB(source,event)
        f3 = figure(4);
        f3.Position = [75,75,350,300];
        f3.MenuBar = 'none';
        f3.Name = 'More Target Options Menu';
        
        tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Horizontal','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.575,.25,.15]);
        tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Vertical','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.45,.25,.15]);
        tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Dial','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.325,.25,.15]);
        tTar = uicontrol(f3,'Style','text','FontSize',12,'String','Zoom','FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.1,.2,.25,.15]);
        
        tPopUp1 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',4,'Callback',@xtorque_Callback,'Units','normalized','Position',[0.4,0.575,0.25,0.15]);
        tPopUp2 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',1,'Callback',@ytorque_Callback,'Units','normalized','Position',[0.4,0.45,0.25,0.15]);
        tPopUp3 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',2,'Callback',@thtorque_Callback,'Units','normalized','Position',[0.4,0.325,0.25,0.15]);
        tPopUp4 = uicontrol(f3,'Style','popupmenu','String',{'SF/SE','SAB/SAD','SER/SIR','EF/EE','load_cell'},'Value',3,'Callback',@ztorque_Callback,'Units','normalized','Position',[0.4,0.20,0.25,0.15]);
        
        tOK = uicontrol(f3,'Style','pushbutton','String','OK','FontSize',11,'Callback',@moreTarOK,'Units','normalized','Position',[0.225,0.075,0.2,0.125]);
        tCancel = uicontrol(f3,'Style','pushbutton','String','Cancel','FontSize',11,'Callback',@moreTarCancel,'Units','normalized','Position',[0.525,0.075,0.2,0.125]);
        
        tCheck1 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@xlock_Callback,'Position',[.75,.6125,.25,.15]);
        tCheck2 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@ylock_Callback,'Position',[.75,.4875,.25,.15]);
        tCheck3 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@thlock_Callback,'Position',[.75,.3625,.25,.15]);
        tCheck4 = uicontrol(f3,'Style','checkbox','Units','normalized','Value',0,'Callback',@zlock_Callback,'Position',[.75,.2425,.25,.15]);
        
        tTar = uicontrol(f3,'Style','text','FontSize',12,'FontWeight','Bold','String','DOF','Units','normalized','Position',[.45,0.75,.15,.1]);
        tTar = uicontrol(f3,'Style','text','FontSize',12,'FontWeight','Bold','String','Lock','Units','normalized','Position',[.7,0.75,.15,.1]);
        
        if myhandles.moreTarOK == 1
            tPopUp1.Value = myhandles.torquemask(1);
            tPopUp2.Value = myhandles.torquemask(2);
            tPopUp3.Value = myhandles.torquemask(3);
            tPopUp4.Value = myhandles.torquemask(4);
            
            tCheck1.Value = myhandles.lockmask(1);
            tCheck2.Value = myhandles.lockmask(2);
            tCheck3.Value = myhandles.lockmask(3);
            tCheck4.Value = myhandles.lockmask(4);
            
        else
            if myhandles.moreTarCancel == 1
                tPopUp1.Value = myhandles.prevtorquemask(1);
                tPopUp2.Value = myhandles.prevtorquemask(2);
                tPopUp3.Value = myhandles.prevtorquemask(3);
                tPopUp4.Value = myhandles.prevtorquemask(4);
                
                tCheck1.Value = myhandles.prevlockmask(1);
                tCheck2.Value = myhandles.prevlockmask(2);
                tCheck3.Value = myhandles.prevlockmask(3);
                tCheck4.Value = myhandles.prevlockmask(4);
            else
                tPopUp1.Value = 4;
                tPopUp2.Value = 1;
                tPopUp3.Value = 2;
                tPopUp4.Value = 3;
                
                tCheck1.Value = 0;
                tCheck2.Value = 0;
                tCheck3.Value = 0;
                tCheck4.Value = 0;
            end
            
        end
    end

    function moreTarOK(source,event)
        setValues = [4,1,2,3];
        for i = 1:length(myhandles.torquemask)
            if myhandles.torquemask(i) == 0
                myhandles.torquemask(i) = setValues(i);
            end
        end
        myhandles.prevtorquemask = myhandles.torquemask;
        myhandles.prevlockmask = myhandles.lockmask;
        
        myhandles.moreTarOK = 1;
        myhandles.moreTarCancel = 0;
        close(gcf);
    end

    function moreTarCancel(source,event)
        myhandles.torquemask = myhandles.prevtorquemask;
        myhandles.lockmask = myhandles.prevlockmask;
        myhandles.moreTarOK = 0;
        myhandles.moreTarCancel = 1;
        close(gcf);
    end

    function Cursor_size_Callback(source,event)
        cursSize = str2num(source.String);
        source.UserData = cursSize;
        myhandles.Cursor_s = cursSize;
    end

    function Pie_size_Callback(source,event)
        pieWidth = str2num(source.String);
        source.UserData = pieWidth;
        myhandles.Pie_size = pieWidth;
    end

    function theta_zero_Callback(source,event)
        dialZero = str2num(source.String);
        source.UserData = dialZero;
        myhandles.th_zero = dialZero;
    end

    function Target_size_Callback(source,event)
        tarSize = str2num(source.String);
        source.UserData = tarSize;
        myhandles.Target_s = tarSize;
    end

    function Target_x_Callback(source,event)
        tarHorizon = str2num(source.String);
        source.UserData = tarHorizon;
        myhandles.Target_x = tarHorizon;
    end

    function Target_y_Callback(source,event)
        tarVert = str2num(source.String);
        source.UserData = tarVert;
        myhandles.Target_y = tarVert;
    end

    function Target_theta_Callback(source,event)
        tarRot = str2num(source.String);
        source.UserData = tarRot;
        myhandles.Target_t = tarRot;
    end

    function Target_zoom_Callback(source,event)
        tarZoom = str2num(source.String);
        source.UserData = tarZoom;
        myhandles.Target_z = tarZoom;
    end

    function xlock_Callback(source,event)
        myhandles.lockmask(1) = source.Value;
        source.UserData = myhandles.lockmask;
    end

    function ylock_Callback(source,event)
        myhandles.lockmask(2) = source.Value;
        source.UserData = myhandles.lockmask(2);
    end

    function thlock_Callback(source,event)
        myhandles.lockmask(3) = source.Value;
        source.UserData = myhandles.lockmask(3);
    end

    function zlock_Callback(source,event)
        myhandles.lockmask(4) = source.Value;
        source.UserData = myhandles.lockmask(4);
    end

    function xtorque_Callback(source,event)
        myhandles.torquemask(1) = source.Value;
        source.UserData = myhandles.torquemask(1);
    end

    function ytorque_Callback(source,event)
        myhandles.torquemask(2) = source.Value;
        source.UserData = myhandles.torquemask(2);
    end

    function thtorque_Callback(source,event)
        myhandles.torquemask(3) = source.Value;
        source.UserData = myhandles.torquemask(3);
    end

    function ztorque_Callback(source,event)
        myhandles.torquemask(4) = source.Value;
        source.UserData = myhandles.torquemask(4);
    end

    function pbOkTarMenu_Callback(source,event)
        myhandles.TarOK = 1;
        myhandles.TarCancel = 0;
        tempArray = [myhandles.Target_x, myhandles.Target_y];
        if length(tempArray) < 2 || length(tempArray) > 2
            errordlg('The horizontal and vertical targets should have one element each (e.g. [30 45])');
        else
            myhandles.prevTarValues = [myhandles.Cursor_s, myhandles.Pie_size, myhandles.th_zero, myhandles.Target_s, myhandles.Target_x, myhandles.Target_y, myhandles.Target_t, myhandles.Target_z];
            close(gcf);
        end
    end

    function pbCancelTarMenu_Callback(source,event)
        myhandles.TarCancel = 1;
        myhandles.TarOK = 0;
        myhandles.Cursor_size = myhandles.prevTarValues(1);
        myhandles.Pie_size = myhandles.prevTarValues(2);
        myhandles.th_zero = myhandles.prevTarValues(3);
        myhandles.Target_s = myhandles.prevTarValues(4);
        myhandles.Target_x = myhandles.prevTarValues(5);
        myhandles.Target_y = myhandles.prevTarValues(6);
        myhandles.Target_t = myhandles.prevTarValues(7);
        myhandles.Target_z = myhandles.prevTarValues(8);
        close(gcf);
    end

%% CALLBACKS FOR DAQ INITIALIZATION
%after getting the rest of this program working, test to see if you can put
%this s into the pbDaq callback and still have it work
s = daq.createSession('ni'); %Main data collection session and perhaps plot for Lindsay
s2 = daq.createSession('ni'); %RT EMG
s3 = daq.createSession('ni'); %RT Target and perhaps plot for Lindsay
s4 = daq.createSession('ni'); %Trigger

%Pushbutton DAQ callback
    function pbDaqInit_Callback(source,event)
        initDaq = myhandles.initDaq;
        armSwitch = myhandles.armSwitched;
        numChan = myhandles.nChan;
        armChoice = myhandles.armChoice;
        
        if isempty(myhandles.sensMat)
            errordlg('You never chose your JR3! Please choose and then initialize :)');
        elseif (myhandles.nChan == 0 || myhandles.sRate == 0 || myhandles.sTime == 0)
            errordlg('The DAQ initialization values were not entered properly! Please re-enter and then initialize :)');
        else
            delete(s);
            delete(s3);
            s = daq.createSession('ni');
            s3 = daq.createSession('ni');
            numChan = myhandles.nChan;
%             channels = [0:myhandles.nChan-1];
%             myhandles.Channels = channels;

            if myhandles.loadFile ~= 1 && initDaq ~= 1
                changePlotNum();
            elseif myhandles.loadFile == 1
                awesomePlotMaker(myhandles.plotNumber);
                mPlots.Enable = 'on';
            end

            if myhandles.pulseStop > 0
                DAQInit(s,2);
            else
                DAQInit(s,1);
            end
            
            if triggerCB.Value == 1
                DAQInit(s,2,s4);
            end
            
%             DAQInit(s,1);
            DAQInit(s3,1);
            
            
            myhandles.initDaq = 1;
            myhandles.loadFilePrev = myhandles.loadFile;
            myhandles.loadFile = 0;
            myhandles.initChSelect = 1;
            pbZeroFM.Enable = 'On';
        end
    end

%     function changePlotNum(source,event)
    function changePlotNum(source,event,varargin) 
        disp('change plot number called!');
        if nargin == 2
            answer = inputdlg('How many plots would you like to show?');
            myhandles.plotNumber = str2num(answer{1});
        else
            numChan = myhandles.nChan;
            disp(numChan);
            myhandles.plotNumber = numChan + 1;
        end

        myhandles.plotRawList = 0*(ones(1,myhandles.plotNumber));
        myhandles.plotEMGList = 0*(ones(1,myhandles.plotNumber));
        myhandles.plotTypes = 0*(ones(1,myhandles.plotNumber));
        possiblePTs = [1,2,3,4,5,6,7,8,10,10,10,10,10,10,9,9,9,9,9,9,9,9];
        rawChans = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,16,17,18,19,20,21,22];
        EMGChans = [0,0,0,0,0,0,0,0,9,10,11,12,13,14,0,0,0,0,0,0,0,0];
        for i = 1:myhandles.plotNumber
            myhandles.plotTypes(i) = possiblePTs(i);
            if find(i==rawChans)
                myhandles.plotRawList(i)=1;
            elseif find(i==EMGChans)
                myhandles.plotEMGList(i)=1;
            end
        end
        
        mPlots.Enable = 'on';
        awesomePlotMaker(myhandles.plotNumber);
    end

    function DAQInit(daqSession,type,varargin)
        %change the device ID to match the NIdaq that is attached- can get
        %available device IDs by typing in daq.getDevices
%         myhandles.daqDevice = 'Dev4';
%         try
%             daqTest = daqSession;
%             delete(daqTest);
%             daqSession = daq.createSession('ni');
%         end
        
        
        disp('DAQInit called');
        disp('daqSession: ');
        disp(daqSession);
        disp('type: ');
        disp(type);
        
        channelList = sort(myhandles.Channels);
%         channelListNew = channelList;
        channelListNew = floor(channelList/8)*16+rem(channelList,8);
        %         channelList = [0,channelList];
        ch = addAnalogInputChannel(daqSession,myhandles.daqDevice,channelListNew,'Voltage');
        
        if type == 2
            if nargin == 3
                chOut = addAnalogOutputChannel(varargin{1},myhandles.daqDevice,'ao1','Voltage');
            else
                chOut = addAnalogOutputChannel(daqSession,myhandles.daqDevice,'ao0','Voltage');
            end
            chOut
        end
        
        disp('Initialized channels: ');
        disp(ch);
        daqSession.Rate = myhandles.sRate;
    end

    function DAQInitOutput(daqSession)
        chOut = addAnalogOutputChannel(daqSession,myhandles.daqDevice,'ao1','Voltage');
        disp(chOut);
    end

    function pbAcquire_Callback(source,event)
        armSwitch = myhandles.armSwitched;
        source.Enable = 'off';
        
            myhandles.timeMat = [];
            myhandles.collectedData = [];
            
            [y,fs]=audioread('beep.wav');
            p=audioplayer(y,fs);
            pSampleRate = p.SampleRate;
            play(p, [1 pSampleRate*0.5]);
            
            if strcmp(DisplayTarget_menu.Checked,'off') && strcmp(DisplayFM_menu.Checked,'off') 
                s.IsContinuous = false;
                if myhandles.pulseStop > 0
                    pulseData = [zeros(myhandles.pulseStart*myhandles.sRate,1);5*ones((myhandles.pulseStop-myhandles.pulseStart)*myhandles.sRate,1)];
                    if myhandles.sTime > myhandles.pulseStop
                        extraZeros = zeros(((myhandles.sTime-myhandles.pulseStop)*myhandles.sRate),1);
                        pulseData = [pulseData;extraZeros];
                    end
                    queueOutputData(s,[pulseData;0]);
                else
                    s.DurationInSeconds = myhandles.sTime;
                end
                
                lh = addlistener(s, 'DataAvailable', @collectDataNTD);
                
                startBackground(s);
                
                s.wait();
                stop(s);
                
                [y,fs]=audioread('beep.wav');
                p=audioplayer(y,fs);
                pSampleRate = p.SampleRate;
                play(p, [1 pSampleRate*0.5]);
                
                myhandles.collectedData = myhandles.collectedData';
                myhandles.timeMat = myhandles.timeMat';
                delete(lh);
            else
                tarCheck = RTTargetcheckbox.Value;
                RTFMCheck = RTForceCB.Value;
                if tarCheck == 1
                    RTTargetcheckbox.Value = 0;
                    RTTarget_Callback(RTTargetcheckbox,0);
                    myhandles.RTTarget = 1;
                elseif RTFMCheck == 1
                    RTForceCB.Value = 0;
                    RealtimeFM_Callback(RTForceCB,0);
                    myhandles.RTForce = 1;
                end

                if triggerCB.Value == 1
                    delete(s4);
                    s4 = daq.createSession('ni');
                    DAQInitOutput(s4)
                end
                
                myhandles.trigAlready = 0;
                
                uistack(targetDAQ.Fig,'bottom')
                capture.TimeSpan = 0.45;
                capture.plotTimeSpan = 0.5;
                callbackTimeSpan = double(s.NotifyWhenDataAvailableExceeds)/s.Rate;
                capture.bufferTimeSpan = max([capture.plotTimeSpan, capture.TimeSpan * 3, callbackTimeSpan * 3]);
                capture.bufferSize =  round(capture.bufferTimeSpan * s.Rate);
                
                if strcmp(DisplayTarget_menu.Checked,'on')
                    lh = addlistener(s, 'DataAvailable', @(src,event)collectRT(src,event,capture,1,myhandles.targetGUI));
                elseif strcmp(DisplayFM_menu.Checked,'on') 
                    disp('entered here display fm');
                    lh = addlistener(s, 'DataAvailable', @(src,event)dataCapture3(src,event,capture,1,myhandles.realtimeFMGUI));
                end
                
                if myhandles.pulseStop > 0
                    pulseData = [zeros(myhandles.pulseStart*myhandles.sRate,1);5*ones((myhandles.pulseStop-myhandles.pulseStart)*myhandles.sRate,1)];
                    if myhandles.sTime > myhandles.pulseStop
                        extraZeros = zeros(((myhandles.sTime-myhandles.pulseStop)*myhandles.sRate),1);
                        pulseData = [pulseData;extraZeros];
                    end
                    queueOutputData(s,[pulseData;0]);
                else
                    s.IsContinuous = false;
                    s.DurationInSeconds = myhandles.sTime;
                end

                if triggerCB.Value == 1 
                    disp('queued the pulse data!');
                    queueOutputData(s4,myhandles.trigPulse);
                end
                
                myhandles.timeMat = [];
                myhandles.collectedData = [];
                
                uistack(targetDAQ.Fig,'bottom')
                startBackground(s);
                
                s.wait();
                stop(s);
                
                [y,fs]=audioread('beep.wav');
                p=audioplayer(y,fs);
                pSampleRate = p.SampleRate;
                play(p, [1 pSampleRate*0.5]);
                
                myhandles.collectedData = myhandles.collectedData';
                myhandles.timeMat = myhandles.timeMat';
                delete(lh);
            end
            
            blah = getappdata(targetDAQ.Fig,'itrial');
            myhandles.TrialNumber = num2str(blah);
            fileName = [myhandles.fileName,myhandles.TrialNumber,'.mat'];
            t = myhandles.timeMat;
            totalData = myhandles.collectedData;
            newData = [totalData,t];
            numChan = myhandles.nChan;
            awesomePlotMaker(numChan,newData);
            
            lArmPath = myhandles.lArmPath;
            rArmPath = myhandles.rArmPath;
            addInfo = myhandles.addInfo;
            armCh = myhandles.armChoice;
            abdAng = myhandles.abdAngle;
            efAng = myhandles.efAngle;
            aLen = myhandles.aLength;
            faLen = myhandles.faLength;
            zOff = myhandles.zOffset;
            FMoffset = myhandles.FMoffset;
            JR3name = myhandles.JR3name;
            sRate = myhandles.sRate;
            maxes = myhandles.maxVals;
            
            nFileNameParts = checkFile(fileName);
            
            nFileName = nFileNameParts{1};
            nTrialNum = nFileNameParts{2};
            nFileName = [nFileName,nTrialNum];

%             T = cell2table(maxes);
%             writetable(T,['maxes_',nFileName,'.xls']);

            nFileName = [nFileName,'.mat'];
            
            structData = struct('totalData', totalData,'t',t,'sRate',sRate,'armCh', armCh,'abdAng',abdAng,'efAng',efAng,'aLen',aLen,'faLen',faLen,'zOff',zOff,'FMoffset',FMoffset,'JR3name',JR3name,'addInfo',addInfo);
            currDir = myhandles.currDir;
            
            if isempty(currDir)
                currentFolder = pwd;
                subjStr = 'subj';
                subjDir = fullfile(currentFolder,subjStr);
                mkdir(subjDir);
                lArmPath = fullfile(subjDir,'Left');
                rArmPath = fullfile(subjDir,'Right');
                mkdir(lArmPath);
                mkdir(rArmPath);
                myhandles.lArmPath = lArmPath;
                myhandles.rArmPath = rArmPath;
                myhandles.currDir = currentFolder;
            end
            
            if strcmp(armCh,'left')
                path = lArmPath;
            else
                path = rArmPath;
            end
            
            try
                saveFile = fullfile(path,nFileName);
                save(saveFile,'structData');
            catch
                save(nFileName,'totalData','t','sRate','armCh','abdAng','efAng','aLen','faLen','zOff','FMoffset','JR3name','addInfo');
            end
            
            blah = blah + 1;
            myhandles.TrialNumber = num2str(blah);
            etNumTr.String = myhandles.TrialNumber;
            setappdata(targetDAQ.Fig,'itrial',blah);
            myhandles.maxVals = [];
            myhandles.daqAcquireVal = 1;
            myhandles.pbAcquireVal = myhandles.pbAcquireVal+1;
            myhandles.timeMat = [];
            myhandles.collectedData = [];
            
            excelFileName = [myhandles.subjID,'_MVIC_',myhandles.armChoice,'.xls'];
            if myhandles.pbAcquireVal == 1
                try
                    saveSetupStruct(myhandles);
                    titleMat = {'Trial','HAdAb','SAbAd','SEIR','Task'};
                    xlswrite(excelFileName,titleMat);
                end
            end
            
            try
                cellRow = myhandles.TrialNumber;
                cellRange = sprintf('B%s:D%s',cellRow,cellRow);
                maxArray = [maxes{6,2},maxes{7,2},maxes{2,2}];
                xlswrite(excelFileName,maxArray,cellRange);
                xlswrite(excelFileName,{nFileName},sprintf('A%s:A%s',cellRow,cellRow));
            catch
                disp('Could not save to excel file o_O');
            end

            if s4.IsRunning
                stop(s4);
            end
            
%             if triggerCB.Value == 1 
%                 delete(s4);
%             end
            
            if myhandles.RTTarget == 1
                RTTargetcheckbox.Value = 1;
                RTTarget_Callback(RTTargetcheckbox,1);
                myhandles.RTTarget = 0;
            elseif myhandles.RTForce == 1
                RTForceCB.Value = 1;
                RealtimeFM_Callback(RTForceCB,1);
                myhandles.RTForce = 0;
            end            
        
        source.Enable = 'on';
        source.Value = 0;
    end

    function saveSetupStruct(handles)
        setup.subject = struct('subjID',handles.subjID,'Notes',handles.addInfo);
        setup.daq = struct('inchan',handles.Channels,'SRate',handles.sRate,'SLength',handles.sTime);
        setup.jr3 = struct('Abd_angle',handles.abdAngle,'Elb_angle',handles.efAngle,'Larm',handles.aLength,'Lfore',handles.faLength,'ztrans',handles.zOffset,'arm',handles.armChoice,'SensorMat',handles.sensMat);
        setup.target = struct('Target_x',handles.Target_x,'Target_y',handles.Target_y,'Target_t',handles.Target_t,'Target_z',handles.Target_z,'Target_s',handles.Target_s,'Cursor_s',handles.Cursor_s,'Pie_size',handles.Pie_size,'th_zero',handles.th_zero);
        subjID = handles.subjID;
        arm = handles.armChoice;
        filename = [subjID,'_',arm,'_Setup','.mat'];
        
        try
            save(filename,'setup')
        catch
            disp('could not save');
        end
    end

global lh

    function collectRT(src,event,c,captureRequested,targetGUI)
        persistent dataBuffer timeBuffer
        % If dataCapture is running for the first time, initialize persistent vars
        if event.TimeStamps(1)==0
            dataBuffer = [];          % data buffer
            timeBuffer = [];
            prevData = [];            % last data point from previous callback execution
        else
            prevData = dataBuffer(end, :);
        end
        
        % Store continuous acquistion data in persistent FIFO buffer dataBuffer
        latestData = event.Data;
        latestTime = event.TimeStamps;
        dataBuffer = [dataBuffer; latestData];
        timeBuffer = [timeBuffer; latestTime];
        numSamplesToDiscard = size(dataBuffer,1) - c.bufferSize;
        if (numSamplesToDiscard > 0)
            dataBuffer(1:numSamplesToDiscard, :) = [];
        end
        samplesToPlot = min([round(c.plotTimeSpan * src.Rate), size(dataBuffer,1)]);
        firstPoint = size(dataBuffer, 1) - samplesToPlot + 1;
        
        data = dataBuffer(firstPoint:end,:);
        %         data = event.Data;
        newData = ones(size(data(:,1:6)));
        chanTypes = myhandles.noStrChanTypeList;
        %
        %         %         relCols = [1:6];
        for i = 1:6
            if find(chanTypes == i)
                ind = find(chanTypes == i);
                newData(:,i) = data(:,ind);
            end
        end
        
        meanLC = myhandles.meanLC;
        
        if find(chanTypes == 7)
            forceInd = find(chanTypes==7);
            forceData = data(:,forceInd);
            convForceData = forceConversion(forceData-meanLC);
        else
            convForceData = 0*ones(size(data,1),1);
        end
        
        [m,n]=size(newData(:,1:6));
        FMhandbase = newData(:,1:6) - (diag(myhandles.FMoffset)*ones(n,m))';
        FMhand = JR3toFM(FMhandbase(:,1:6),myhandles);
        FMhand = [FMhand,convForceData];
        
        trigAlready = myhandles.trigAlready;
        tarCheck = RTTargetcheckbox.Value;

        if triggerCB.Value == 1 && trigAlready == 0 && tarCheck ~= 1
            trigVal = myhandles.trigValue;
            resp = myhandles.trigResp;

            if any(FMhand(:,resp)>= trigVal)
                try
                    startBackground(s4);
%                     outputSingleScan(s4,5)
                    myhandles.trigAlready = 1;
%                     outputSingleScan(s4,0)
                    disp('outputted');
                catch
                    disp('error');
                end
            end
        end
        
        convForceData_Base = convForceData;
        
        newData = [FMhand,convForceData_Base];
        
        M=mean(newData(:,myhandles.torquemask+3)).*(~myhandles.lockmask);
        
        if strcmp(myhandles.armChoice,'right'), M(1)=-M(1); end
        
        if ~myhandles.zoomOpt
            xd=Circle(myhandles.Cursor_s,M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
            set(targetGUI.lh(1),'Xdata',myhandles.x(:,1)+M(1),'Ydata',myhandles.x(:,2)+M(2),'Color','g')
            set(targetGUI.lh(2),'Xdata',myhandles.xp(:,1)+M(1),'Ydata',myhandles.xp(:,2)+M(2))
            set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
        else
            x=Circle(myhandles.Cursor_s + M(4),M(1:2));
            xp=Circle(myhandles.Cursor_s + M(4),[0 0],[myhandles.Pie_center+myhandles.Nmtodeg*[-myhandles.Pie_size myhandles.Pie_size]/2 myhandles.th_zero]);
            xp=[0 0;xp(1,:);0 0;xp(2,:)];
            xd=Circle(myhandles.Cursor_s + M(4),M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
            set(targetGUI.lh(1),'Xdata',x(:,1),'Ydata',x(:,2),'Color','g')
            set(targetGUI.lh(2),'Xdata',xp(:,1)+M(1),'Ydata',xp(:,2)+M(2))
            set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
            set(targetGUI.lh(6),'Xdata',myhandles.xz(:,1)+M(1),'Ydata',myhandles.xz(:,2)+M(2));
        end
        %         drawnow;
        
        % Update live data plot
        %         captureRequested = get(hGui.CaptureButton, 'value');
        if captureRequested == 1
            myhandles.timeMat = [myhandles.timeMat,latestTime'];
            myhandles.collectedData = [myhandles.collectedData,latestData'];
        end
    end

    function collectDataNTD(source,event)
        myhandles.timeMat = [myhandles.timeMat,event.TimeStamps'];
        myhandles.collectedData = [myhandles.collectedData,event.Data'];
        %         time = myhandles.timeMat
        %         data = myhandles.collectedData
    end

    function Zero_FM_Callback(source,event)
        armSwitch = myhandles.armSwitched;
        %             myhandles.acquireCt = myhandles.acquireCt + 1;
        if isvalid(s)
            if s.IsRunning
                stop(s);
            end
        end

        if isvalid(s3)
            if s3.IsRunning
                stop(s3);
            end
        end
        
        myhandles.timeMat = [];
        myhandles.collectedData = [];
        s.IsContinuous = false;
        lh = addlistener(s, 'DataAvailable', @collectDataNTD);
        
        tarCheck = RTTargetcheckbox.Value;
        RTFMCheck = RTForceCB.Value;
        
        if tarCheck == 1
            RTTargetcheckbox.Value = 0;
            RTTarget_Callback(RTTargetcheckbox,0);
            myhandles.RTTarget = 1;
        elseif RTFMCheck == 1
            RTForceCB.Value = 0;
            RealtimeFM_Callback(RTForceCB,0);
            myhandles.RTForce = 1;
        end
        
        if myhandles.pulseStop > 0
            output_data = zeros(myhandles.sRate/2,1); % Amplitude of 2V
            queueOutputData(s,output_data);
        else
            s.DurationInSeconds = 1;
        end
        
        [y,fs]=audioread('beep.wav');
        p=audioplayer(y,fs);
        pSampleRate = p.SampleRate;
        play(p, [1 pSampleRate*0.5]);
        
        startBackground(s);
        
        while s.IsRunning
            pause(0.2);
        end
        
        s.wait();
        stop(s);
        
        myhandles.collectedData = myhandles.collectedData';
        myhandles.timeMat = myhandles.timeMat';
        delete(lh);
        
        [y,fs]=audioread('beep.wav');
        p=audioplayer(y,fs);
        pSampleRate = p.SampleRate;
        play(p, [1 pSampleRate*0.5]);
        
        jr3Ind = 1:6;
        lcInd = 7;
        data = myhandles.collectedData;
        newData = ones(size(data(:,1:6)));
        chanTypes = myhandles.noStrChanTypeList;
        
        for i = jr3Ind
            if find(chanTypes == i)
                ind = find(chanTypes == i);
                newData(:,i) = data(:,ind);
            end
        end
        
        for i = lcInd
            if find(chanTypes == i)
                ind = find(chanTypes == i);
                newData = [newData,ones(size(data,1),1)];
                newData(:,i) = data(:,ind);
            end
        end
        
        myhandles.FMoffset = mean(newData(:,1:6));
        
        if find(chanTypes == lcInd)
            myhandles.meanLC = mean(newData(:,lcInd));
        else
            myhandles.meanLC = 0;
        end
        
        [y,fs]=audioread('beep.wav');
        p=audioplayer(y,fs);
        pSampleRate = p.SampleRate;
        play(p, [1 pSampleRate*0.5]);
        
        DisplayTarget_menu.Enable = 'on';
        TargetOptions_menu.Enable = 'on';
        DisplayFM_menu.Enable = 'on';
        FMOptions_menu.Enable = 'on';

        RTForceCB.Enable = 'On';
        myhandles.pbAcquire.Enable = 'On';
        myhandles.pbAcquire.Value = 0;
        myhandles.timeMat = [];
        myhandles.collectedData = [];
        
%         if myhandles.pulseStop > 0
%             delete(s);
%             s = daq.createSession('ni');
%             DAQInit(s,2);
%         end
        
        if myhandles.RTTarget == 1
            RTTargetcheckbox.Value = 1;
            RTTarget_Callback(RTTargetcheckbox,1);
            myhandles.RTTarget = 0;
        elseif myhandles.RTForce == 1
            RTForceCB.Value = 1;
            RealtimeFM_Callback(RTForceCB,1);
            myhandles.RTForce = 0;
        end
    end

    function aKeyPress_Callback(source,event)
        switch event.Key
            case 'a'
                pbAcquire_Callback(myhandles.pbAcquire,[])
        end
    end

    function Display_Target_Callback(source,event)
        if strcmp(source.Checked,'off')
            source.Checked = 'on';
            %             TargetOptions_menu.Enable = 'On';
            myhandles.targetGUI = createDataCaptureUI();
            RTTargetcheckbox.Enable = 'on';
            RTForceCB.Enable = 'off';
            triggerCB.Enable = 'On';
            if isvalid(s3)
                delete(s3);
            end
            
            s3 = daq.createSession('ni');
            DAQInit(s3,1);
        else
            source.Checked = 'off';
            %             TargetOptions_menu.Enable = 'Off';
            try
                close('Target GUI');
            end
            RTTargetcheckbox.Enable = 'off';
            RTForceCB.Enable = 'on';
        end
    end

%Menu Items
    function saveSetup(source,event)
        initDaq = myhandles.initDaq;
        if initDaq ~= 1
            errordlg('Cannot save until the DAQ is initialized! Please initialize and try again.');
        else
            disp('save setup selected!');
            armCh = myhandles.armChoice;
            %             abdAng = myhandles.abdAngle;
            %             efAng = myhandles.efAngle;
            %             aLen = myhandles.aLength;
            %             faLen = myhandles.faLength;
            %             zOff = myhandles.zOffset;
            numChan = myhandles.nChan;
            sampRate = myhandles.sRate;
            sampTime = myhandles.sTime;
%             timeDelay = myhandles.Timer;
            chanList = myhandles.Channels;
            chanNameList = myhandles.NameChannels;
            chanTypeList = myhandles.chanTypeList;
            
            plotNames = myhandles.plotNames;
            plotTypes = myhandles.plotTypes;
            plotRawList = myhandles.plotRawList;
            plotEMGList = myhandles.plotEMGList;
            plotNumber = myhandles.plotNumber;
            uisave({'numChan','sampRate','sampTime','armCh','chanList','chanNameList','chanTypeList','plotNames','plotTypes','plotRawList','plotEMGList','plotNumber'},'savedSettingsui');
            %             uisave({'abdAng','efAng','aLen','faLen','zOff','chanList','chanNameList','armCh'},'savedSettingsui');
        end
    end

    function loadSetup(source,event)
        loadSettings = uiimport;
        
        myhandles.nChan = loadSettings.numChan;
        myhandles.oldNChan = myhandles.nChan;
        
        myhandles.sRate = loadSettings.sampRate;
        myhandles.sTime = loadSettings.sampTime;
%         myhandles.Timer = loadSettings.timeDelay;
        myhandles.armChoice = loadSettings.armCh;
        
        myhandles.Channels = loadSettings.chanList;
        myhandles.NameChannels = loadSettings.chanNameList;
        myhandles.chanTypeList = loadSettings.chanTypeList;
        myhandles.noStrChanTypeList = str2double(myhandles.chanTypeList);
        myhandles.plotNames = loadSettings.plotNames;
        myhandles.plotTypes = loadSettings.plotTypes;
        myhandles.plotRawList = loadSettings.plotRawList;
        myhandles.plotEMGList = loadSettings.plotEMGList;
        myhandles.plotNumber = loadSettings.plotNumber;
        
        nChan_Edit.String = myhandles.nChan;
        myhandles.sRate_Edit.String = myhandles.sRate;
        myhandles.sTime_Edit.String = myhandles.sTime;
%         myhandles.Timer_Edit.String = myhandles.Timer;
        
        myhandles.loadFile = 1;
        
        armChoice = myhandles.armChoice;
        
        armButtonR = myhandles.rbExp1;
        armButtonL = myhandles.rbExp2;
        
        if strcmp(armChoice,'right')
            armButtonR.Value = 1;
        else
            armButtonL.Value = 1;
        end
        
        guidata(targetDAQ.Fig,myhandles);
    end

    function x = Circle(r,x0,th)
        if nargin < 3
            th = (0:359)';
        end
        
        th = th(:)*pi/180;
        x(:,1) = r*cos(th)+x0(1);
        x(:,2) = r*sin(th)+x0(2);
    end

    function dataCapture(src, event, c, targetGUI)
        %         persistent dataBuffer
        
        %         If dataCapture is running for the first time, initialize persistent vars
        %         if event.TimeStamps(1)==0
        %             dataBuffer = [];          % data buffer
        %         end
        
        %         Store continuous acquistion data in persistent FIFO buffer dataBuffer
        %         latestData = [event.TimeStamps, event.Data];
        %         latestData = event.Data;
        %         dataBuffer = [dataBuffer; latestData];
        %         numSamplesToDiscard = size(dataBuffer,1) - c.bufferSize;
        %         if (numSamplesToDiscard > 0)
        %             dataBuffer(1:numSamplesToDiscard, :) = [];
        %         end
        data = event.Data;
        newData = ones(size(data(:,1:6)));
        chanTypes = myhandles.noStrChanTypeList;
        
        for i = 1:6
            if find(chanTypes == i)
                ind = find(chanTypes == i);
                newData(:,i) = data(:,ind);
            end
        end
        
        meanLC = myhandles.meanLC;
        
        if find(chanTypes == 7)
            forceInd = find(chanTypes==7);
            forceData = data(:,forceInd);
            convForceData = forceConversion(forceData-meanLC);
        else
            convForceData = 0*ones(size(data,1),1);
        end
        
        [m,n]=size(newData(:,1:6));
        FMhandbase = newData(:,1:6) - (diag(myhandles.FMoffset)*ones(n,m))';
        FMhand = JR3toFM(FMhandbase(:,1:6),myhandles);
        
        convForceData_Base = convForceData;
        
        newData = [FMhand,convForceData_Base];
        
        M=mean(newData(:,myhandles.torquemask+3)).*(~myhandles.lockmask);
        
        if strcmp(myhandles.armChoice,'right'), M(1)=-M(1); end
        
        % Update live data plot
        myhandles.timeMat = [myhandles.timeMat,event.TimeStamps'];
        myhandles.collectedData = [myhandles.collectedData,event.Data'];
        
        if ~myhandles.zoomOpt
            xd=Circle(myhandles.Cursor_s,M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
            set(targetGUI.lh(1),'Xdata',myhandles.x(:,1)+M(1),'Ydata',myhandles.x(:,2)+M(2),'Color','g')
            set(targetGUI.lh(2),'Xdata',myhandles.xp(:,1)+M(1),'Ydata',myhandles.xp(:,2)+M(2))
            set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
        else
            x=Circle(myhandles.Cursor_s + M(4),M(1:2));
            xp=Circle(myhandles.Cursor_s + M(4),[0 0],[myhandles.Pie_center+myhandles.Nmtodeg*[-myhandles.Pie_size myhandles.Pie_size]/2 myhandles.th_zero]);
            xp=[0 0;xp(1,:);0 0;xp(2,:)];
            xd=Circle(myhandles.Cursor_s + M(4),M(1:2),myhandles.Nmtodeg*M(3)+myhandles.th_zero);xd=[M(1:2);xd];
            set(targetGUI.lh(1),'Xdata',x(:,1),'Ydata',x(:,2),'Color','g')
            set(targetGUI.lh(2),'Xdata',xp(:,1)+M(1),'Ydata',xp(:,2)+M(2))
            set(targetGUI.lh(3),'Xdata',xd(:,1),'Ydata',xd(:,2))
            set(targetGUI.lh(6),'Xdata',myhandles.xz(:,1)+M(1),'Ydata',myhandles.xz(:,2)+M(2));
        end
        drawnow;
    end

    function targetGUI = createDataCaptureUI()
        %CREATEDATACAPTUREUI Create a graphical user interface for data capture.
        % Create a figure and configure a callback function (executes on window close)
        targetGUI.Fig = figure('Name','Target GUI', ...
            'NumberTitle', 'off','Resize', 'on','Position', [100 100 650 650]);
        
        set(targetGUI.Fig, 'DeleteFcn', @closeTargetGUI);
        
        % Make sure the real-time data comes to the front
        uistack(targetGUI.Fig,'top');
        
        targetGUI.Axes1 = axes;
        targetGUI.lh = plot(nan);
        
        title('Target Display');
        
        if ~isempty(targetGUI.lh)
            delete(targetGUI.lh)
            targetGUI.lh=[];
        end
        
        myhandles.x=Circle(myhandles.Cursor_s,[0 0]);
        myhandles.Pie_center=90;
        
        % Pie and dial on cursor - these objects change with time
        if myhandles.Target_t == 0
            myhandles.th_zero=90;
            myhandles.Nmtodeg=180/(5*myhandles.Pie_size);
        else
            % If the dial zero is at 90 degrees, set the pie width to 60 degrees.
            if myhandles.th_zero==90
                myhandles.Nmtodeg=60/(myhandles.Pie_size);
            else
                myhandles.Nmtodeg=abs(myhandles.Pie_center-myhandles.th_zero)/abs(myhandles.Target_t);
            end
        end
        
        xp=Circle(myhandles.Cursor_s,[0 0],[myhandles.Pie_center+myhandles.Nmtodeg*[-myhandles.Pie_size myhandles.Pie_size]/2 myhandles.th_zero]);
        myhandles.xp=[0 0;xp(1,:);0 0;xp(2,:)];
        xd=[0 0;xp(3,:)];
        
        % Plot cursor
        hLine(1)=line('Parent',targetGUI.Axes1,'Xdata',myhandles.x(:,1),'Ydata',myhandles.x(:,2),'Color','g','LineWidth',2);
        hLine(2)=line('Parent',targetGUI.Axes1,'Xdata',myhandles.xp(:,1),'Ydata',myhandles.xp(:,2),'Color','y','LineWidth',3);
        hLine(3)=line('Parent',targetGUI.Axes1,'Xdata',xd(:,1),'Ydata',xd(:,2),'Color','r','LineWidth',3);
        
        if strcmp(myhandles.armChoice,'right')
            xt=Circle(myhandles.Target_s,[-myhandles.Target_x myhandles.Target_y]);
        else
            xt=Circle(myhandles.Target_s,[myhandles.Target_x myhandles.Target_y]);
        end
        
        % Cone from cursor to target - this object is fixed
        if ((myhandles.Target_y)==0 && (myhandles.Target_x==0))
            xc=zeros(4,2);
        else
            d=norm([myhandles.Target_x myhandles.Target_y]);
            if strcmp(myhandles.armChoice,'right')
                thc=(atan2(myhandles.Target_y,-myhandles.Target_x)+[asin(myhandles.Target_s/d) -asin(myhandles.Target_s/d)])*180/pi;
            else
                thc=(atan2(myhandles.Target_y,myhandles.Target_x)+[asin(myhandles.Target_s/d) -asin(myhandles.Target_s/d)])*180/pi;
            end
            xc=Circle(d,[0 0],thc);xc=[0 0;xc(1,:);0 0;xc(2,:)];
        end
        
        hLine(4)=line('Parent',targetGUI.Axes1,'Xdata',xt(:,1),'Ydata',xt(:,2),'Color','r','LineWidth',2);
        hLine(5)=line('Parent',targetGUI.Axes1,'Xdata',xc(:,1),'Ydata',xc(:,2),'Color','m','LineWidth',2);
        
        if myhandles.zoomOpt
            % Zoom target - this object changes with time
            myhandles.xz=[Circle(1.1*myhandles.Target_z,[0 0]); Circle(0.9*myhandles.Target_z,[0 0])];
            hLine(6)=line('Parent',targetGUI.axes1,'Xdata',myhandles.xz(:,1),'Ydata',myhandles.xz(:,2),'Color','w');
        end
        lim=round(max(abs([myhandles.Target_x myhandles.Target_y]))+1.1*myhandles.Target_s);
        targetGUI.Axes1.XLim = [-lim lim];
        targetGUI.Axes1.YLim = [-lim lim];
        set(targetGUI.Fig,'color','k');
        set(gca,'Color','k');
        targetGUI.lh = hLine;
    end

    function closeChGUI(source,event)
        button = myhandles.pbChSelect;
        val = button.Value;
        if val ~= 1
            myhandles.Channels = myhandles.placeHolder;
            if myhandles.oldNChan ~= myhandles.nChan
                myhandles.nChan = myhandles.oldNChan;
                nChan_Edit.String = myhandles.nChan;
            end
        end
        
        try
            g = findobj('-depth',1,'type','figure','Name','Channel Selection Menu');
            delete(g)
        end
    end

    function closeTargetGUI(source,event)
        try
            if isvalid(s)
                if s.IsRunning
                    stop(s);
                end
            end
            
            if isvalid(s3)
                if s3.IsRunning
                    stop(s3);
                end
                delete(s3);
            end
            
        catch
            warning('The GUI was shut down this first time line 2732');
            %             delete(dataListener);
            %             delete(errorListener);
        end
        
        try
            DisplayTarget_menu.Checked ='off';
            if RTTargetcheckbox.Value == 1
                RTTargetcheckbox.Value = 0;
            end
            RTTargetcheckbox.Enable = 'off';
            RTForceCB.Enable = 'on';
            
            g = findobj('-depth',1,'type','figure','Name','Target GUI');
            delete(g)
            %             TargetOptions_menu.Enable = 'Off';
        catch
            warning('The GUI was shut down for the second time line 2732');
        end
        if s.IsRunning
            %             disp('in the cancel and still running');
            stop(s);
        end
        disp('Target off o_O');
    end

    function closeMainGUI(source,event)
        if isfield(myhandles, 'polhemus')
            fclose(myhandles.polhemus);
        end
        disp('Goodbye :)');
        fclose('all');
    end

    function stopAfterTimeLimit(src,event)
        samples = src.ScansAcquired;
        sampTime = myhandles.sTime;
        timeLimit = (sampTime*src.Rate);
        
        if samples == timeLimit
            stop(src);
        end
    end

    function FMshe=JR3toFM(FM,handles)
        abdAngle=handles.abdAngle*pi/180;  % degrees to rad
        efAngle=pi-handles.efAngle*pi/180;  % degrees to rad
        aLength=handles.aLength/1000;    % mm to m
        faLength=handles.faLength/1000;  % mm to m
        zOffset=handles.zOffset/1000;    % mm to m
        
        % Translate moments to the shoulder and elbow
        [FMsh,FMe]=JR3toSHandE(FM,abdAngle,efAngle,aLength,faLength,zOffset,handles.armChoice,handles.sensMat);
        %FMshe=[FMsh FMe(:,4:5)];%LCM modified 4/29 to include pronation/supination in feedack
        FMshe=[FMsh FMe(:,4)];
    end
end

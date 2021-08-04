function metriaGUI = KinematicsDAQ_Metria()
%KinematicsDAQ_Upgraded This GUI is used to interface with the Metria

% close all;
% s = daqSession;
metriaGUI.Fig = figure('Name','Metria Data Acquisition GUI', ...
    'NumberTitle', 'off', 'DeleteFcn',@closeMainGUI,'Resize', 'off', 'Position', [75,75,1000,800]);
metriaGUI.Visible = 'on';
metriaGUI.MenuBar = 'none';
metriaGUI.Name = 'Kinematics DAQ';
movegui(metriaGUI.Fig,'center')

metriahandles = guihandles(metriaGUI.Fig);

metriahandles.sTime = 10; % Sampling length in seconds
metriahandles.speriod = 1/100; % Timer rate set to 30 Hz. Has nothing to do with actual Polhemus sampling rate which is 120 Hz / 4 receivers = 30 Hz
metriahandles.rtflag = 0;
metriahandles.bonylandmark = 1;
metriahandles.shouldStop = 0;
metriahandles.armChoice = 'right';
metriahandles.dataReplay = [];
metriahandles.currDir = [];
metriahandles.lArmPath = [];
metriahandles.rArmPath = [];
metriahandles.subjID = 'subj';
setappdata(metriaGUI.Fig,'replayVal',1);
setappdata(metriaGUI.Fig,'replayPause',0);

% Initialize bony landmark filename
metriahandles.fileName = 'file';
metriahandles.TrialNumber = '1';
metriahandles.itrial = 1;
setappdata(metriaGUI.Fig,'itrial',1)

metriahandles.timeMat = [];
metriahandles.collectedData = [];

metriahandles.subtract = 0;
% 'Title','Shoulder Kinematics Data Acquisition',
acqPanel = uipanel(metriaGUI.Fig,'FontSize',11,'FontWeight','Bold','Position',[0,0,1,1]);
myTitle = uicontrol(acqPanel,'Style','text','String','Metria Data Acquisition GUI','FontSize',18 ,'HorizontalAlignment','center','Units','normalized','Position',[0.25,0.4975,0.5,0.5]);

% digitizeOptions = {'Thorax (SC,IJ,PX,C7,T8)','Scapula (AC,AA,TS,AI,PC)','Humerus(EM,EL)','Forearm (RS,US,OL,Hand)'};
metriahandles.digitizeOptions = {'Session A','Session B','Session C', 'Session D', 'Session E', 'Session Landmarks'};
metriahandles.options = uicontrol(acqPanel,'Style','popupmenu','String',metriahandles.digitizeOptions,'HorizontalAlignment','Left','Units','normalized','FontSize',14,'Position',[0.625,0.625,0.35,0.3],'Callback',@selectOption);

armPanel = uipanel(acqPanel,'FontSize',9,'Title','Arm','FontWeight','Bold','Position',[0.63,0.725,0.1375,0.1375]);
rbgArm = uibuttongroup('Parent',armPanel,'Visible','off','Tag','ArmBG','SelectionChangedFcn',@(rbg,event) rbArmCallback(rbg,event),'Position',[0 0 1 1]);
metriahandles.rbRArm = uicontrol(rbgArm,'Style','radiobutton','FontSize',12,'Tag','right','String','Right Arm','Value',1,'Units','normalized','Position',[0.15 0.6 0.75 0.35]);
metriahandles.rbLArm = uicontrol(rbgArm,'Style','radiobutton','FontSize',12,'Tag','left','String','Left Arm','Value',0,'Units','normalized','Position',[0.15 0.2 0.6 0.35]);
rbgArm.Visible = 'on';

rtPanel = uipanel(acqPanel,'FontSize',9,'Title','RealTime','FontWeight','Bold','Position',[0.80,0.725,0.175,0.1375]);
rbgFB = uibuttongroup('Parent',rtPanel,'Visible','off','Tag','fbBG','SelectionChangedFcn',@(rbg,event) rbFBCallback(rbg,event),'Position',[0 0 1 1]);
metriahandles.rbRTDaq = uicontrol(rbgFB,'Style','radiobutton','FontSize',12,'Tag','rtDAQ','String','Real Time DAQ','Value',0,'Enable','off','Units','normalized','Position',[0.1 0.6 0.9 0.35]);
metriahandles.rbTDisp = uicontrol(rbgFB,'Style','radiobutton','FontSize',12,'Tag','tDisp','String','Timed Collection','Value',1,'Enable','off','Units','normalized','Position',[0.1 0.2 0.9 0.35]);
rbgFB.Visible = 'on';

metriahandles.initPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','Callback',@initPB_Callback,'String','INITIALIZE','FontWeight','Bold','FontSize',11,'Enable','On','HorizontalAlignment','Center','Units','normalized','Position',[0.7195 0.65 0.125 0.05]);
metriahandles.digitPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','Callback',@digitPB_Callback,'String','DIGITIZE','Interruptible','on','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.7195 0.575 0.125 0.05]); %DIGITIZE; [0.65 0.575 0.125 0.05]
metriahandles.collectDigitPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','Callback',@digitCollectPB_Callback,'String','DIGIT POINT','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.50 0.125 0.05]);
metriahandles.backPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','BackgroundColor','blue','Callback',@backPB_Callback,'String','BACK','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.7875 0.50 0.125 0.05]);

% metriahandles.startPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','Callback',@Start_Callback,'String','START','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.425 0.125 0.05]);
% metriahandles.stopPB = uicontrol(metriaGUI.Fig,'Style','pushbutton','Callback',@Stop_Callback,'String','STOP','FontWeight','Bold','FontSize',11,'Enable','Off','HorizontalAlignment','Center','Units','normalized','Position',[0.7875 0.425 0.125 0.05]);

metriahandles.textbox1 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.71,.25,.15,.1]);
metriahandles.textbox2 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Center','Units','normalized','Position',[.58,.125,.4,.125]);
metriahandles.textbox3 = uicontrol(metriaGUI.Fig,'Style','text','FontSize',9.5,'FontWeight','Bold','HorizontalAlignment','Left','Units','normalized','Position',[.025,.0125,.9,.1]);
% metriahandles.polhemus = instrfind('Type', 'serial', 'Port', 'COM3','Tag','');

metriahandles.socket = [];
metriahandles.port = 6111;
%A.M. commenting 03/10/20: number of tags to expect data from 
%AM TO-DO: change to numLandmarks 
metriahandles.numTags = 3;
metriahandles.landmarks = {'A','B','C','D'};
metriahandles.digitizedData = {};
metriahandles.currLandmark = 1;

metriahandles.plotpanel = uipanel( ...
    'Parent', metriaGUI.Fig, ...
    'Units', 'Normalized', ...
    'Position', [0.025 0.2 0.575 0.75], ...
    'Title', 'Plotting Panel' ...
    );

    function initPB_Callback(source,event)
        port = metriahandles.port; %can add a text box for entering the port number
        socket = metriaComm_openSocket(port);
        metriahandles.socket = socket;
        
        disp('socket: ');
        disp(socket);
        %         handles.pbAcquire.Enable = 'off';
        % Call the initialization mex function that opens the port --> need
        % to have the function return a handle to the port so that we can
        % send and read from it, and close it when finished
        metriahandles.blflag=[0 0 0]; % used to indicate which segments have had landmarks digitized (thorax, scapula, humerus)
        
        [metriahandles,metriahandles.hLine,metriahandles.hText,metriahandles.hPatch]=InitDisplay(metriahandles);
        
        metriahandles.daqtimer = createTimer(metriahandles);
        
        set(metriahandles.textbox3,'String','System ready');
        metriahandles.digitPB.Enable = 'on';
        metriahandles.rbRTDaq.Enable = 'on';
        metriahandles.rbTDisp.Enable = 'on';
    end

    function backPB_Callback(source,event)
        disp('back PB clicked');
        metriahandles.subtract = metriahandles.subtract+1;
        metriahandles.currLandmark = metriahandles.currLandmark - 2;
        
        if metriahandles.currLandmark < 0
            metriahandles.currLandmark = 0;
        end
        
        if mod(metriahandles.subtract,2) || metriahandles.subtract == 0
            disp('just changed the color to green');
            source.BackgroundColor = 'green';
        else
            disp('just changed the color to blue');
            source.BackgroundColor = 'blue';
        end
    end

    function digitPB_Callback(source,event)
        disp('digitize PB clicked');
        metriahandles.collectDigitPB.Enable = 'on';
        metriahandles.backPB.Enable = 'on';
        metriahandles.digitPB.Enable = 'off';
    end
%A.M. 03/10/20 once digitization is done it gets saved in the path 
%KINDAT _BL bldata
    function digitCollectPB_Callback(source,event)
        landmarks = metriahandles.landmarks;
        totalDigitizedData = metriahandles.digitizedData;
        socket = metriahandles.socket;
        numTags = metriahandles.numTags;
        
        currLandmark = metriahandles.currLandmark;
        
%         totalDigitizedData{metriahandles.currLandmark} = metriaComm_collectPoint(socket,numTags);
        totalDigitizedData{metriahandles.currLandmark} = metriaComm_digitPoint(socket,numTags);
        metriahandles.digitizedData = totalDigitizedData;
        
        if currLandmark == length(landmarks)
            metriahandles.digitPB.Enable = 'on';
            disp('totalDigitizedData: ');
            disp(totalDigitizedData);
            currLandmark = 1;
            bldata = metriahandles.digitizedData;
            save(['KINDAT' '_BL'],'bldata');
            metriahandles.collectDigitPB.Enable = 'off';
            metriahandles.backPB.Enable = 'off';
        else
            disp(currLandmark);
            currLandmark = currLandmark + 1;
        end
        
        metriahandles.currLandmark = currLandmark;
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

    function closeMainGUI(source,event)
        disp('Goodbye :)');
        metriaComm_closeSocket(metriahandles.socket);
%         if isfield(metriahandles, 'polhemus')
%             fclose(metriahandles.polhemus);
%         end
        guidata(source,metriahandles);
    end

    function [metriahandles,hLine,hText,hPatch]=InitDisplay(metriahandles)
        % Function to initialize bony landmark display objects in hLine:
        % 1 Trunk BL - blue
        % 2 Scapula BL - green
        % 3 Humerus BL - red
        % 4 Wand tip - yellow
        % 5 Scapula medial/lateral rotation angle
        % 6 Scapula anterior/posterior tilt angle
        %         a = get(get(gcf,'children'),'type')
        disp('init display was called');
        
        title('Yay','FontSize',8.5)
        metriahandles.blah = axes('Units','normal','Position', [0.075 0.125 .875 .875], 'Parent', metriahandles.plotpanel);
        metriahandles.lh = plot(nan);
        view(3);
        
        hLine(1)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'Zdata',[],'LineWidth',2,'Marker','o','MarkerSize',12,'MarkerFaceColor','b','Color','b');
        hLine(2)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'Zdata',[],'LineWidth',2,'Marker','o','MarkerSize',12,'MarkerFaceColor','g','Color','g');
        hLine(3)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'Zdata',[],'LineWidth',2,'Marker','o','MarkerSize',12,'MarkerFaceColor','r','Color','r');
        hLine(4)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'Zdata',[],'LineWidth',2,'Marker','o','MarkerSize',12,'MarkerFaceColor','y','Color','y');
        hLine(5)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'LineWidth',2,'Color','y');
        hLine(6)=line('Parent',metriahandles.blah,'Xdata',[],'Ydata',[],'LineWidth',2,'Color','r');
        
        % Initialize text boxes
        yloc=0.8:-0.2:0.2;
        for i=1:4
            hText(i)=text('Position',[0.05 yloc(i)],'FontSize',14,'Color','r','Parent',metriahandles.blah);
        end
        
        % Initialize patch objects
        plotcube(metriahandles.blah,[],0,[0 0 0],[1 0 0]); % Humerus red
        plotcube(metriahandles.blah,[],0,[0 0 0],[0 1 0]); % Scapula green
        hPatch=plotcube(metriahandles.blah,[],0,[0 0 0],[0 0 1]); % Trunk blue
    end

    function h=plotcube(haxes,hpatch,edges,origin,clr)
        % PLOTCUBE - Display a 3D-cube in the current axes
        %
        %   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
        %   with the following properties:
        %   * EDGES : 1 or 3-element vector that defines the length of cube edges
        %   * ORIGIN: 3-element vector that defines the origin point of the cube
        %   * COLOR : 3-elements vector that defines the faces color of the cube
        %
        %   * ALPHA (constant): scalar that defines the transparency of the cube faces (from 0
        %             to 1)
        %
        % Example:
        %   >> plotcube([5 5 5],[ 2  2  2],.8,[1 0 0]);
        %   >> plotcube([5 5 5],[10 10 10],.8,[0 1 0]);
        %   >> plotcube([5 5 5],[20 20 20],.8,[0 0 1]);
        
        %         x = linspace(0,10);
        %         y1 = sin(x);
        %         posVect = [0.05, 0.05, 0.925, 0.925];    % position of first subplot
        %         subplot(1,1,1,'Position',posVect,'Parent',metriahandles.plotpanel)
        %         plot(x,y1);
        
        alpha=0.7;
        
        XYZ = { ...
            [0 0 0 0]  [0 0 1 1]  [0 1 1 0] ; ...
            [1 1 1 1]  [0 0 1 1]  [0 1 1 0] ; ...
            [0 1 1 0]  [0 0 0 0]  [0 0 1 1] ; ...
            [0 1 1 0]  [1 1 1 1]  [0 0 1 1] ; ...
            [0 1 1 0]  [0 0 1 1]  [0 0 0 0] ; ...
            [0 1 1 0]  [0 0 1 1]  [1 1 1 1]   ...
            };
        
        if size(edges)<3, edges=repmat(edges,1,3); end
        
        XYZ = mat2cell(...
            cellfun( @(x,y,z) x*y+z , ...
            XYZ , ...
            repmat(mat2cell(edges,1,[1 1 1]),6,1) , ...
            repmat(mat2cell(origin,1,[1 1 1]),6,1) , ...
            'UniformOutput',false), ...
            6,[1 1 1]);
        
        if isempty(hpatch)
            cellfun(@patch,XYZ{1},XYZ{2},XYZ{3},...
                repmat({clr},6,1),...
                repmat({'FaceAlpha'},6,1),...
                repmat({alpha},6,1),...
                repmat({'Parent'},6,1),...
                repmat({haxes},6,1)...
                );
            h=get(haxes,'Children');
        else
            cellfun(@set,mat2cell(hpatch,[1 1 1 1 1 1],1),...
                repmat({'XData'},6,1),XYZ{1},...
                repmat({'YData'},6,1),XYZ{2},...
                repmat({'ZData'},6,1),XYZ{3});
        end
        
    end

    function t = createTimer(metriahandles)
        t = timer;
        t.TimerFcn = {@localTimerFcn,metriahandles};
        t.Period = metriahandles.speriod;
        t.TasksToExecute = ceil(metriahandles.sTime/t.Period);
        t.ExecutionMode = 'fixedRate';
    end

    function localTimerFcn(mTimer,event,metriahandles)
        % Can only display real time motion OR coordinates
        
        if (mTimer.TasksExecuted==2),
            [y,fs]=audioread('beep.wav');
            p = audioplayer(y,fs);
            play(p);
        end
        
        formatspec = '%u   %4.2f  %4.2f  %4.2f\n%u   %4.2f  %4.2f  %4.2f\n%u   %4.2f  %4.2f  %4.2f\n%u   %4.2f  %4.2f  %4.2f\n';
        
        if metriahandles.rtflag
            if metriahandles.polhemus.BytesAvailable>=356
                for i=1:4
                    try
                        record(:,i)=fscanf(metriahandles.polhemus,'%*c%f');
                        if metriahandles.tdflag
                            set(metriahandles.textbox2,'String',sprintf(formatspec,record(1:4,:)));
                        else
                            recidx=record(1,i)-1 ;
                            if recidx==0
                                set(metriahandles.hLine(4),'XData',record(2,:),'YData',record(3,:),'ZData',record(4,:))
                                drawnow
                            else
                                plotcube(metriahandles.blah,metriahandles.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
                            end
                        end
                    catch
                        if metriahandles.tdflag
                            set(metriahandles.hText(i),'String',['Scan unsuccessful: ' num2str(record)]);
                        else
                            set(metriahandles.hLine(4),'XData',0,'YData',0,'ZData',0)
                        end
                    end
                end
            end
        end
    end

    function localTimerCleanup(mTimer,event,metriahandles)
        trialVal = getappdata(metriaGUI.Fig,'itrial');
        disp('entered localTimerCleanup');
        
        try
            fprintf(metriahandles.polhemus,'c'); % Stop streaming data
            if ~metriahandles.rtflag
                set(metriahandles.textbox3,'String',['Data recorded successfully. Saving data to ' [metriahandles.fileName,num2str(trialVal),'.mat']]);
            else
                set(metriahandles.textbox3,'String',['Data streaming stopped']);
            end
        catch
            set(metriahandles.textbox3,'String','Could not talk to Polhemus to stop streaming data');
        end
        toc(metriahandles.tstart)
        disp('just called toc');
        
        [y,fs]=audioread('beep.wav');
        p=audioplayer(y,fs);
        pSampleRate = p.SampleRate;
        play(p, [1 pSampleRate*0.5]);
        
        if ~metriahandles.rtflag
            %             bldata = evalin('base', 'load(''KINDAT_BL.mat'')');
            %             bldata = bldata.bldata;
            bldata = metriahandles.bldata;
            nsamples=metriahandles.sTime/metriahandles.speriod;
            counter=0;
            kindata={zeros(3,4,nsamples),zeros(3,4,nsamples),zeros(3,4,nsamples)};
            while metriahandles.polhemus.BytesAvailable>=356 %&& counter<nsamples
                counter=counter+1;
                for i=1:4,
                    try
                        record=fscanf(metriahandles.polhemus,'%*c%f');
                        recidx=record(1)-1;
                        if recidx>0 && size(record,1)==13
                            kindata{recidx}(:,:,counter)=reshape(record(2:end),3,4);
                        end
                    catch disp(record);
                    end
                end
            end
            
            if counter<nsamples, for i=1:3, kindata{i}(:,:,counter+1:nsamples)=[]; end; end% Remove the redundant zeros
            disp([nsamples counter])
            metriahandles.kindata=kindata;
            % -- Removed kinematic display for Jun's program as it is specific to the shoulder-- %
            %             localDisplayKinematicData(kindata,bldata,metriahandles)
        end
        trialVal = trialVal+1;
        metriahandles.TrialNumber = num2str(trialVal);
        etNumTr.String = num2str(trialVal);
        setappdata(metriaGUI.Fig,'itrial',trialVal)
        metriahandles.playPlotPB.Enable = 'On';
        metriahandles.pausePlotPB.Enable = 'On';
        metriahandles.rbRTDaq.Enable = 'On';
        %         disp('collected time: ');
        %         disp(metriahandles.timeMat)
        %         stopPlotPB.Enable = 'On';
    end

    function [Rx]=rotx(th)
        % vormen van een rotatiematrix voor rotaties rond de x-as
        Rx(1,1)=1;
        Rx(2,2)=cos(th);
        Rx(2,3)=-sin(th);
        Rx(3,2)= sin(th);
        Rx(3,3)= cos(th);
    end

    function [Ry]=roty(th)
        % vormen van een rotatiematrix voor rotaties rond de y-as
        Ry(1,1)=cos(th);
        Ry(1,3)=sin(th);
        Ry(2,2)=1;
        Ry(3,1)=-sin(th);
        Ry(3,3)= cos(th);
    end

    function [Rz]=rotz(th)
        % vormen van een rotatiematrix voor rotaties rond de z-as
        Rz(1,1)=cos(th);
        Rz(1,2)=-sin(th);
        Rz(2,1)= sin(th);
        Rz(2,2)= cos(th);
        Rz(3,3)=1;
    end
end
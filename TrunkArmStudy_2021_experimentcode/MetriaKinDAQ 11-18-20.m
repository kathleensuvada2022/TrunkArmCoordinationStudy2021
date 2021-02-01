function BL = MetriaKinDAQ

% marker ID is a vector for all markers used (enter as 5 including the
% probe)
addpath Metria

myhandles.met.on=1;
% myhandles.met.markerID=markerid;
myhandles.met.port=6111;
myhandles.CreateStruct=struct('Interpreter','tex','WindowStyle','modal');
myhandles.exp.dir=pwd;
myhandles.timer = timer;
myhandles.timer.period = 1/50;    % Timer frequency = 50 hz
%A.M. testing to see which line of code is causing the TimerFcn error
% myhandles.timer.Name = 'RTD';
myhandles.timer.ExecutionMode = 'fixedRate'; % Changed to 'queue' from 'fixedrate' mode so that period is on average the set period.
myhandles.timer.TasksToExecute=1/myhandles.timer.period;
myhandles.timer.StopFcn=@MET_Stop_Callback;
myhandles.met.nmarker=4; % Don't include probe here
myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};



if myhandles.met.on
    if ~isfield(myhandles.met,'socket')
        % Open port to communicate with Metria system
        myhandles.met.socket = metriaComm_openSocket(myhandles.met.port);
    end
    
%     if strcmp(myhandles.timer.Running,'on'), stop(myhandles.timer); end
    
    % Enable digitize button 
%     set(myhandles.ui.met_dig,'Enable','On');
else
    metriaComm_closeSocket(myhandles.met.socket);
    rmfield(myhandles.met,'socket')
%     myhandles.met.socket=[];
end

% above it all commented out and wil communicate with matlab lines 9-22  
MET_DigitizeBL_Callback( myhandles.met.socket,[]);



% Function to create GUI to digitize Bony Landmarks with the METria system
function MET_DigitizeBL_Callback(hObject,event)
scrsz = get(groot,'ScreenSize');
digGUI = figure('Name','ACT3D_TACS - METRIA', ...
    'NumberTitle', 'off', 'DeleteFcn',@GUI_closeDBL,'OuterPosition',[0.2*scrsz(3) 0.2*scrsz(4) 0.6*scrsz(3) 0.6*scrsz(4)]);
% digGUI.Visible = 'on';
digGUI.MenuBar = 'none';
% movegui(digGUI.Fig,'center')
myhandles.met.fig=digGUI;
myhandles.timer.TimerFcn=@MET_Timer_Callback;
dig = guihandles(digGUI);
% dig.h=digGUI;
dig.socket=myhandles.met.socket;
% Create timer
dig.currentSEG=1;
dig.currentBL=1;
dig.fname='BL';
setappdata(digGUI,'databuffer',zeros(2*myhandles.timer.TasksToExecute,43));

larm=(30+25)/100; % Convert to m
dig.blah = axes('Parent', digGUI,'Units','normal','Position', [0.05 0.2 .43 .55],'Color','k','DataAspectRatio',[1 1 1]);
set(dig.blah,'xlim',[-0.4 0.4],'ylim',[-0.2 1.2*larm],'zlim',[-1 1]); 
rotate3d(dig.blah)
% set(dig.blah.Toolbar,'Visible','on');

% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr) 
myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
% Create text and cube handles
% 1 Trunk marker - blue
% 2 Scapula marker - red
% 3 Humerus marker - yellow
% 4 Forearm/hand marker - green
% 5 Wand tip - white
% cmap=colormap(parula(5));
cmap=['b';'r';'y';'g';'w'];

% Initialize patch and text objects
for i=1:myhandles.met.nmarker+1 % Include probe
    if i<5, plotcube(dig.blah,[],0,[0 0 0],cmap(i)); % Forearm/hand - blue
    else dig.hPatch=plotcube(dig.blah,[],0,[0 0 0],cmap(i)); % Pointer tool - white
    end
end

for i=1:myhandles.met.nmarker+1 % Include probe
    hText(i)=text('String',myhandles.met.Segments{i},'FontSize',12,'Color',cmap(i),'Parent',dig.blah);
end
dig.hPatch=flip(dig.hPatch);

% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr)
p0=zeros(5,3); p0(:,2)=0.12*(0:1:4)';
lside=0.05;
for i=1:myhandles.met.nmarker+1
    plotcube(dig.blah,dig.hPatch(6*i-5:6*i),lside*ones(1,3),p0(i,:),[]);
    set(hText(i),'Position',p0(i,:)+lside*ones(1,3))
end

uicontrol(digGUI,'Style','text','String','Digitize Bony Landmarks','HorizontalAlignment','center','Units','normalized','Position',[0.2,0.85,.6,.1],'FontSize',18,'FontWeight','bold');

uicontrol(digGUI,'Style','text','String','Select Segment','HorizontalAlignment','center','Units','normalized','Position',[0.52,0.75,.2,.1],'FontSize',16);
dig.ui.segmlist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectSEG,'String',myhandles.met.Segments,'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.52,0.6,0.2,0.2]);
uicontrol(digGUI,'Style','text','String','Select Bony Landmark','HorizontalAlignment','center','Units','normalized','Position',[0.78,0.75,.2,.1],'FontSize',16);
dig.ui.bllist = uicontrol(digGUI,'Style','listbox','Callback',@MET_selectBL,'String',myhandles.met.bonylmrks{1},'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.78,0.6,0.2,0.2]);

dig.ui.digbutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_recordBL_Callback,'String','DIGITIZE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.4 0.2 0.1],'BackgroundColor','b');
dig.ui.savebutton = uicontrol(digGUI,'Style','pushbutton','Callback',@MET_saveBL_Callback,'String','SAVE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.25 0.2 0.1],'BackgroundColor','g','Enable','off');

% start(myhandles.timer);

guidata(digGUI,dig)

end

% Function to record bony landmark positions
function MET_selectSEG(hObject,event)
dig=guidata(hObject);
dig.currentSEG=get(hObject,'Value');
dig.currentBL=1;
set(dig.ui.bllist,'String',myhandles.met.bonylmrks{dig.currentSEG},'Value',dig.currentBL);
guidata(hObject,dig)
end

function MET_selectBL(hObject,event)
dig=guidata(hObject);
dig.currentBL=get(hObject,'Value');
guidata(hObject,dig)
end

% records location of all of the markers - called when click on digitize
% --> will grab and save whole row.what's in row for data coming back from
% metria 
function MET_recordBL_Callback(hObject,event)
dig=guidata(hObject);
% Initialize bl cell array the first time Digitize BL is called
if ~isfield(dig,'bl'), dig.bl=cell(1,5); set(dig.ui.savebutton,'Enable','on'); end
% Inititalize bl matrix the first time Digitize BL for current segment
% is called
if isempty(dig.bl{dig.currentSEG}),dig.bl{dig.currentSEG}=zeros(length(myhandles.met.bonylmrks{dig.currentSEG}),3+(myhandles.met.nmarker+1)*8); end
% Read single frame from Metria to digitize current bony landmark
% (dig.currentBL) in current segment (dig.currentSEG) --- UNCOMMENT READS A
% SINGLE FRAME --> communicates with metria
 [out1, out2]= metriaComm_collectPoint(dig.socket,length(myhandles.met.Segments));
%  dig.bl{dig.currentSEG}(dig.currentBL,:)
% test = metriaComm_collectPoint(dig.socket,length(myhandles.met.Segments))
% disp(dig.bl{dig.currentSEG}(:,1:3))
% disp(dig.bl{dig.currentSEG}(:,4:end))
% disp(size(test))
disp(out1)
disp(out2)
% If there are more bony landmarks to digitize, update current bony
% landmark index
if dig.currentBL<length(myhandles.met.bonylmrks{dig.currentSEG})
    dig.currentBL=dig.currentBL+1;
    set(dig.ui.bllist,'Value',dig.currentBL);
    % If there are NO more bony landmarks to digitize, set current bony
    % landmark index to 1
else
    % If there are more segments to digitize, update current segment index
    if dig.currentSEG<myhandles.met.nmarker+1
        dig.currentSEG=dig.currentSEG+1;
        dig.currentBL=1; % Re-initialize bony landmark index
        set(dig.ui.segmlist,'Value',dig.currentSEG);
        MET_selectSEG(dig.ui.segmlist,event)
    else
        % If there are NO more segments (and landmarks) to digitize, update current segment
        % and bony landmark indices
        uiwait(msgbox('\fontsize{12}All bony landmarks have been digitized','ACT3D-TACS',myhandles.CreateStruct));

    end
end
guidata(hObject,dig)

end

function MET_saveBL_Callback(hObject,event)
dig=guidata(hObject);
% Check to see if file already exists to avoid overwriting
if exist(fullfile(myhandles.exp.dir,[dig.fname '.mat']),'file')==2
    response=questdlg('The file already exists. Do you want to overwrite it?','ACT3D - Trunk Arm Coordination Study','Yes','No','No');
    if strcmp(response,'No')
        prompt={'Enter new file name:'};
        def={dig.fname};
        dlgTitle='Input File Name';
        lineNo=1;
        answer=inputdlg(prompt,dlgTitle,lineNo,def);
        dig.fname=answer{1};
    end
end
save(fullfile(myhandles.exp.dir,dig.fname),'-struct','dig','bl')
save 'test'
guidata(hObject,dig)     

end

function MET_Timer_Callback(hObject,event)
persistent counter
if isempty(counter), counter=0; end
counter=counter+1;
% disp(counter)
databuffer=getappdata(myhandles.met.fig,'databuffer');
% metriapoint1 = metriaComm_collectPoint(myhandles.met.socket,5);
% metriapoint2 = metriaComm_collectPoint(myhandles.met.socket,5);
% databuffer(2*counter-1:2*counter,:)=[metriapoint1;metriapoint2];
databuffer(counter,:) = metriaComm_collectPoint(myhandles.met.socket,5);
setappdata(myhandles.met.fig,'databuffer',databuffer)
disp(['Counter=' num2str(counter)])
disp(databuffer(counter,:))

midx=[1 2 3 4 5]; lside=0.05;
if myhandles.met.on
    metdata = metriaComm_collectPoint(dig.socket,myhandles.met.nmarker+1); % Include probe
    for i=1:myhandles.met.nmarker
        plotcube(dig.blah,dig.hPatch(6*i-5:6*i),lside*ones(1,3),metdata((8*midx(i)-7:8*midx(i))+3),[]);
        set(hText(i),'Position',metdata((8*midx(i)-7:8*midx(i))+3)+lside*ones(1,3))
    end
end

% disp(reshape(metriapoint([11 4:6 [11 4:6]+8 [11 4:6]+16 [11 4:6]+24 [11 4:6]+32]),4,5)')
end

function MET_Stop_Callback(hObject,event);
    databuffer=getappdata(myhandles.met.fig,'databuffer');
    disp(size(databuffer))
    save 'METdata' databuffer
end

function GUI_closeDBL(hObject,event)
    dig=guidata(hObject);
    if isfield(dig,'bl')
        MET_saveBL_Callback(hObject,event)
    end
    metriaComm_closeSocket(myhandles.met.socket);
    stop(myhandles.timer);
    delete(hObject)
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


end
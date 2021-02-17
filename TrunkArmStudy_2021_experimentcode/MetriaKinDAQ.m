%%
 function BL = MetriaKinDAQ(varargin)

% UPDATED BY KCS 2.4.2021 -> edited so that new longest pointer tool is the
% probe

% marker ID is a vector for all markers used (enter as 5 including the
% probe)
addpath Metria

myhandles.met.on=1;
% myhandles.met.markerID=markerid;
myhandles.met.port=6111;
myhandles.CreateStruct=struct('Interpreter','tex','WindowStyle','modal');
myhandles.timer = timer;
myhandles.timer.period = 1/50;    % Timer frequency = 50 hz
%A.M. testing to see which line of code is causing the TimerFcn error
% myhandles.timer.Name = 'RTD';
myhandles.timer.ExecutionMode = 'fixedRate'; % Changed to 'queue' from 'fixedrate' mode so that period is on average the set period.
myhandles.timer.TimerFcn=@MET_Timer_Callback;
% myhandles.timer.TasksToExecute=10/myhandles.timer.period;
% myhandles.timer.StopFcn=@MET_Stop_Callback;
myhandles.met.nmarker=4; % Don't include probe here
myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
myhandles.met.markerid=[80 19 87 73 9 11 237];
%237];% added two new pointer tool IDS 2.4.2021
myhandles.met.cameraSerials =  [24 25];% 12.4.2020 added for new Metria code via Hendrik
myhandles.met.ptip=struct('ID009',[.584 172.168 -6.889 1],'ID237',[000.141 126.202 -006.491],'ID011',[000.141 126.202 -006.491]);
pointertool='ID009';
myhandles.probeid = 9;
% getfield(myhandles.met.ptip,pointertool)
myhandles.met.pid=['ID00' num2str(myhandles.met.markerid(end))];
    
if ~isempty(varargin)
    if length(varargin)<2
        myhandles.exp.partID=varargin{1};
    else
        myhandles.exp.partID=varargin{1};
        myhandles.exp.arm=lower(varargin{2});
        myhandles.exp.dir=fullfile('D:','Kacey','data',varargin{1},varargin{2});
    end
end

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
myhandles.met.fig = figure('Name','ACT3D_TACS - METRIA', ...
    'NumberTitle', 'off', 'DeleteFcn',@GUI_closeDBL,'OuterPosition',[0.2*scrsz(3) 0.2*scrsz(4) 0.6*scrsz(3) 0.6*scrsz(4)]);
% digGUI.Visible = 'on';
myhandles.met.fig.MenuBar = 'none';
% movegui(digGUI.Fig,'center')
% myhandles.timer.TimerFcn=@MET_Timer_Callback;
dig = guihandles(myhandles.met.fig);

dig.currentSEG=1;
dig.currentBL=1;
dig.fname='BL';

% setappdata(digGUI,'databuffer',zeros(2*myhandles.timer.TasksToExecute,43));

larm=(30+25)*10; % Convert to mm
myhandles.met.blah = axes('Parent', myhandles.met.fig,'Units','normal','Position', [0.05 0.2 .43 .55],'Color','k','DataAspectRatio',[1 1 1]);
set(myhandles.met.blah,'xlim',[-400 400],'ylim',[-500 500],'zlim',[-800 800]); 
% set(myhandles.met.blah,'xlim',[-1000 1000],'ylim',[-500 500],'zlim',[-2000 2000]); 
rotate3d(myhandles.met.blah)
% set(dig.blah.Toolbar,'Visible','on');

% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr) 
% myhandles.met.markerid=[19 73 80 87];
% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};
% Create text and cube handles
% 1 Trunk marker - blue
% 2 Scapula marker - red
% 3 Humerus marker - yellow
% 4 Forearm/hand marker - green
% 5 Wand tip - white
% cmap=colormap(parula(5));
cmap=['c';'r';'y';'g';'w'];

% Initialize patch and text objects
for i=1:myhandles.met.nmarker+1 % Include probe
    if i<5, plotcube(myhandles.met.blah,[],0,[0 0 0],cmap(i)); % Forearm/hand - blue
    else myhandles.met.hPatch=plotcube(myhandles.met.blah,[],0,[0 0 0],cmap(i)); % Pointer tool - white
    end
end

for i=1:myhandles.met.nmarker+1 % Include probe
    myhandles.met.hText(i)=text('String',myhandles.met.Segments{i},'FontSize',12,'Color',cmap(i),'Parent',myhandles.met.blah);
end
myhandles.met.hPatch=flip(myhandles.met.hPatch);

% plotcube(dig.blah,dig.hPatch(6*recidx-5:6*recidx),4,record(2:4,i)'-[1 1 1],[]);
% h=plotcube(haxes,hpatch,edges,origin,clr)
% p0=zeros(5,3); p0(:,2)=0.12*(0:1:4)';
% lside=50;
% for i=1:myhandles.met.nmarker+1
%     plotcube(myhandles.met.blah,myhandles.met.hPatch(6*i-5:6*i),lside*ones(1,3),p0(i,:),[]);
%     set(myhandles.met.hText(i),'Position',p0(i,:)+lside*ones(1,3))
% end

uicontrol(myhandles.met.fig,'Style','text','String','Digitize Bony Landmarks','HorizontalAlignment','center','Units','normalized','Position',[0.2,0.85,.6,.1],'FontSize',18,'FontWeight','bold');

uicontrol(myhandles.met.fig,'Style','text','String','Select Segment','HorizontalAlignment','center','Units','normalized','Position',[0.52,0.75,.2,.1],'FontSize',16);
dig.ui.segmlist = uicontrol(myhandles.met.fig,'Style','listbox','Callback',@MET_selectSEG,'String',myhandles.met.Segments(1:4),'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.52,0.6,0.2,0.2]);
uicontrol(myhandles.met.fig,'Style','text','String','Select Bony Landmark','HorizontalAlignment','center','Units','normalized','Position',[0.78,0.75,.2,.1],'FontSize',16);
dig.ui.bllist = uicontrol(myhandles.met.fig,'Style','listbox','Callback',@MET_selectBL,'String',myhandles.met.bonylmrks{1},'HorizontalAlignment','Left','Units','normalized','FontSize',16,'Position',[0.78,0.6,0.2,0.3]);

dig.ui.digbutton = uicontrol(myhandles.met.fig,'Style','pushbutton','Callback',@MET_recordBL_Callback,'String','DIGITIZE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.4 0.2 0.1],'BackgroundColor','c');
dig.ui.savebutton = uicontrol(myhandles.met.fig,'Style','pushbutton','Callback',@MET_saveBL_Callback,'String','SAVE BL','FontWeight','Bold','FontSize',16,'HorizontalAlignment','Center','Units','normalized','Position',[0.65 0.25 0.2 0.1],'BackgroundColor','g','Enable','off');

guidata(myhandles.met.fig,dig)

start(myhandles.timer);


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

if myhandles.timer.running, stop(myhandles.timer); end
% Initialize bl cell array the first time Digitize BL is called
if ~isfield(dig,'bl'), dig.bl=cell(1,5); set(dig.ui.savebutton,'Enable','on'); end

% Inititalize bl matrix the first time Digitize BL for current segment
% is called
% if isempty(dig.bl{dig.currentSEG})
%     dig.bl{dig.currentSEG}=zeros(length(myhandles.met.bonylmrks{dig.currentSEG}),16);
% end

if isempty(dig.bl{dig.currentSEG})
    dig.bl{dig.currentSEG}=zeros(length(myhandles.met.bonylmrks{dig.currentSEG}),16);
end

% Read single frame from Metria to digitize current bony landmark
% (dig.currentBL) in current segment (dig.currentSEG) --- UNCOMMENT READS A
% SINGLE FRAME --> communicates with metria
% dig.bl{dig.currentSEG}(dig.currentBL,:) = metriaComm_collectPoint(dig.socket,length(myhandles.met.Segments));
% test = metriaComm_collectPoint(dig.socket,length(myhandles.met.Segments))
% [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker+1);
% [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.markerid,myhandles.met.cameraSerials);% Include probe
 [metdata] = metriaComm_collectPoint2(myhandles.met.socket,myhandles.met.markerid,myhandles.met.cameraSerials);% Include probe

 % metdata=[metdata1(4:end) metdata2(4:end)];

 probeidx=find(metdata==myhandles.probeid);

% end

%|metdata==9|metdata==11 ); %not sure if this is right syntax??  
if ~isempty(probeidx)
   markeridx=find(metdata==myhandles.met.markerid(dig.currentSEG));
   if isempty(markeridx)
       uiwait(msgbox('\fontsize{12}Marker not visible. Re-digitize','ACT3D-TACS',myhandles.CreateStruct));
       start(myhandles.timer)
       return
   else
    
        dig.bl{dig.currentSEG}(dig.currentBL,:)=metdata([markeridx(1)+(0:7),probeidx(1)+(0:7)]); % This is just the marker on the probe and the marker on the RB in the GCS-> want Pointer tip in LCS
        size(  dig.bl{dig.currentSEG}(dig.currentBL,:)) 
        %1X16
        
%% Need to convert from quaternion to HT matrix 
% size(metdata)
% size(metdata(markeridx(1)+(4:7)))
quat_RB =metdata(markeridx(1)+(4:7));
size(quat_RB) 
quat_pointer = metdata(probeidx(1)+(4:7));

% quat_RB = rand(1,4); % testing need to just grab quaternion not XYZ 
% quat_pointer = rand(1,4); % testing need to just grab quaternion not XYZ 

quat_RB= circshift(quat_RB,1,2); % added to compensate for quaternion shifted by 1 -- needed to update for 2014 matlab
quat_pointer = circshift(quat_pointer,1,2);

% XYZ point 
% P_RB = rand(1,3)'; % for testing comment out 
% P_pointer = rand(1,3)' % testing comment out
P_RB = metdata(:,markeridx(1)+(1:3))';
P_pointer = metdata(:,probeidx(1)+(1:3))';

% % Each quaternion represents a 3D rotation and is of the form 
% % q = [w(SCALAR REAL) qx qy qz]
% 
%  HT_UDP = quat2tform(Quat_UDP);
%  HT_UDP(1:3,4) = P;
%  HT_UDP
% 
% Now have HT matrix like is outout from MOCAP
%KCS 2.9.21 need to convert to HT from Quaternion without quat2tform for
%MATLAB 2014
% HT_marker = quat2tform(quat_RB);
HT_marker = Quaternion2tForm(quat_RB);
HT_marker(1:3,4,:) = P_RB;

HT_marker;%CONFIRMED JIVES WITH MOCAP!!!! 2.11.21



% HT_probe = quat2tform(quat_pointer) ; 
HT_probe = Quaternion2tForm(quat_pointer);
HT_probe(1:3,4,:) = P_pointer;
% confirmed makes sense with MOCAP 2.15.21        
        
        %% Transforming to get tip of pointer in LCS
        
        TRB_G = HT_marker;
        size(TRB_G);
        % 4x4 
        % But we need the inverse to get tip of pointer in LCS 
        
        HT_marker;
        
%         HT_marker  gives HT of marker in GCS;
        
        TG_RB = TRB_G'; % the GCS to RB frame
        
        size(TG_RB); % NEED THIS!!!! 
        %4x4
        
      
        TDP_G = HT_probe(:,4) %Tip of pointer in GCS % grabbing XYZ from HT
        
        %confirmed 2.15.21 TDP_G is the tip of pointer in global CS GIVES
        %CORRECT XYZ
        size(TDP_G);
        %4X1
        
        HT_probe
%         TDP_G
    
        
        %4X4 * 4X4 = 4X4
       
        TDP_RB = TG_RB* HT_probe; %transform for pointer tool tip to RB frame
        size(TDP_RB);
        %4X4
        
       
        XP = (getfield(myhandles.met.ptip,pointertool))';% offset of the tip of the pointer tool from the marker of the pointer tool % this is at top of code. can change based on which pointer
        size(XP);
       %4X1
       
       
       % 4X4 * 4x1 NEED THIS
        X_RB = TDP_RB*XP; % This should be location of tip of pointer in LCS (RB CS) 
        
%         X_RB
       % 4X1 
       
       size(dig.bl{dig.currentSEG}(dig.currentBL,:));
       % size = 1X16
       
      
       size([ X_RB' quat_RB  metdata(:,markeridx(1)+(0:7))]);
       
        dig.bl{dig.currentSEG}(dig.currentBL,:) = [X_RB' quat_RB  metdata(:,markeridx(1)+(0:7))];%gives BL in LCS and then marker in GCS
        
        
%         dig.bl{dig.currentSEG}(dig.currentBL,:)=metdata([markeridx(1)+(0:6),probeidx(1)+(0:6)]);
%         
%        disp(dig.bl{dig.currentSEG}(dig.currentBL,:))
   end
else
   uiwait(msgbox('\fontsize{12}Probe not visible. Re-digitize','ACT3D-TACS',myhandles.CreateStruct));
   start(myhandles.timer)
   return
end
% disp(dig.bl{dig.currentSEG}(:,1:3))
% disp(dig.bl{dig.currentSEG}(:,4:end))
% disp(size(test))
% If there are more bony landmarks to digitize, update current bony
% landmark index
if dig.currentBL<length(myhandles.met.bonylmrks{dig.currentSEG})
    dig.currentBL=dig.currentBL+1;
    set(dig.ui.bllist,'Value',dig.currentBL);
    % If there are NO more bony landmarks to digitize, set current bony
    % landmark index to 1
else
    % If there are more segments to digitize, update current segment index
    if dig.currentSEG<myhandles.met.nmarker
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
start(myhandles.timer)
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

% save(fullfile('C:\Users\Dewald Lab\Documents\GitHub\TrunkArmCoordinationStudy2021\TrunkArmStudy_2021_experimentcode\DIGBL2_11_21',dig.fname),'-struct','dig','bl')

guidata(hObject,dig)     

end

function MET_Timer_Callback(hObject,event)
persistent counter
if isempty(counter), counter=0; end
counter=counter+1;
% disp(counter)
% databuffer=getappdata(myhandles.met.fig,'databuffer');
% metriapoint1 = metriaComm_collectPoint(myhandles.met.socket,5);
% metriapoint2 = metriaComm_collectPoint(myhandles.met.socket,5);
% databuffer(2*counter-1:2*counter,:)=[metriapoint1;metriapoint2];
% setappdata(myhandles.met.fig,'databuffer',databuffer)
% disp(['Counter=' num2str(counter)])
% disp(databuffer(counter,:))

% Update Metria display when digitizing bony landmarks
lside=50;
if myhandles.met.on
%     [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.nmarker);
%     [metdata1,metdata2] = metriaComm_collectPoint(myhandles.met.socket,myhandles.met.markerid,myhandles.met.cameraSerials);
 [metdata] = metriaComm_collectPoint2(myhandles.met.socket,myhandles.met.markerid,myhandles.met.cameraSerials);
%     metdata=[metdata1 metdata2];
%     disp([counter metdata1(4:8:end) metdata2(4:8:end)])
    for i=1:myhandles.met.nmarker+1
        markeridx=find(metdata==myhandles.met.markerid(i),1);
        if isempty(markeridx)
%             disp('Marker not visible')
            plotcube(myhandles.met.blah,myhandles.met.hPatch(6*i-5:6*i),0,[0 0 0],[]);
            set(myhandles.met.hText(i),'Visible','off')
        else
%             disp('Marker visible')
% %             plotcube(myhandles.met.blah,myhandles.met.hPatch(6*i-5:6*i),lside*ones(1,3),50*[i i i],[]);
            plotcube(myhandles.met.blah,myhandles.met.hPatch(6*i-5:6*i),lside*ones(1,3),metdata(markeridx+(1:3)),[]);
            set(myhandles.met.hText(i),'Position',metdata(markeridx+(1:3))+lside*ones(1,3))
            set(myhandles.met.hText(i),'Visible','on')
        end
    end
end
end

function MET_Stop_Callback(hObject,event)
    databuffer=getappdata(myhandles.met.fig,'databuffer');
    disp(size(databuffer))
    save 'METdata' databuffer
end

function GUI_closeDBL(hObject,event)
    stop(myhandles.timer);
    dig=guidata(hObject);
    if isfield(dig,'bl')
        MET_saveBL_Callback(hObject,event)
    end
    metriaComm_closeSocket(myhandles.met.socket);
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
function AddGUIPanels(fighandle)
% Function to create the panels for ACT3D, DAQ, Experimental Setup, Experimental Protocol and Metria with associated callback functions
% @(hObject,eventdata)TargetDAQ('Acquire_Callback',hObject,eventdata,guidata(hObject))
% Get figure structure
myhandles = guidata(fighandle);

%% ACT3D Panel
act3dPanel = uipanel('Title','ACT3D','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Tag','numChanET','Position',[0.01,0.55,0.3,0.45]);
% State
uicontrol(act3dPanel,'Style','text','String','Current State','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.78,.4,.15],'FontSize',10);
myhandles.ui.act3d_state=uicontrol(act3dPanel,'Style','text','String','test','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.8,.6,.15],'FontSize',18,'ForegroundColor','b');
% Initialize/Normal/Fix ACT3D pushbutton 
myhandles.ui.act3d_init=uicontrol(act3dPanel,'Style','pushbutton','Callback',@ACT3D_Init_Callback,'String','Initialize ACT3D','Units','normalized','Position',[0.2 0.6 0.67 0.2],'FontSize',11,'BackgroundColor','y');
% Table on/off
uicontrol(act3dPanel,'Style','text','String','Table','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.4,.3,.1],'FontSize',10);
tablebg = uibuttongroup('Parent',act3dPanel,'Tag','TableBG','SelectionChangedFcn',@ACT3D_tablebg_Callback,'Position',[0.4 0.43 .4 .1],'BorderType','none');
myhandles.ui.act3d_table=uicontrol(tablebg,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0 0 0.45 1],'FontSize',10,'Enable','off');
offb=uicontrol(tablebg,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.5 0 0.45 1],'FontSize',10);
tablebg.SelectedObject=offb;
% Load
uicontrol(act3dPanel,'Style','text','String',sprintf('Load\n(+ up, - down)'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.16,0.3,0.1],'FontSize',10);
myhandles.ui.act3d_load = uicontrol(act3dPanel,'Style','edit','String','','Tag','load','Callback',@ACT3D_load_Callback,'Units','normalized','Position',[.4 .2 .15 .17],'HorizontalAlignment','center','FontSize',10);
% Load specified as
loadbg1 = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG1','SelectionChangedFcn',@ACT3D_loadbg1_Callback,'Position',[0.59 .2 .36 0.18],'BorderType','none');
myhandles.ui.act3d_load(1)=uicontrol(loadbg1,'Style','radiobutton','Tag','max','String','% Abduction Max','Units','normalized','Position',[0 0.66 1 0.33],'FontSize',10,'Enable','off');
myhandles.ui.act3d_load(2)=uicontrol(loadbg1,'Style','radiobutton','Tag','wgh','String','% Arm weight','Units','normalized','Position',[0 0.33 1 0.33],'FontSize',10,'Enable','off');
offb2=uicontrol(loadbg1,'Style','radiobutton','Tag','abs','String','Value in N','Units','normalized','Position',[0 0 1 0.33],'FontSize',10);
loadbg1.SelectedObject=offb2;
% Load on/off
loadbg2 = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG2','SelectionChangedFcn',@ACT3D_loadbg2_Callback,'Position',[0.4 0.05 .55 .12]);
myhandles.ui.act3d_load(3)=uicontrol(loadbg2,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0.15 0 0.45 1],'FontSize',10,'Enable','off');
offb3=uicontrol(loadbg2,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.7 0 0.45 1],'FontSize',10);
loadbg2.SelectedObject=offb3;

%% Experimental Setup Panel
expPanel = uipanel('Title','Experimental Setup','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.01,0.01,0.3,0.53]);
% Arm length
uicontrol(expPanel,'Style','text','String','Upper arm length (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.6,0.1],'FontSize',10);
myhandles.ui.exp_ualength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.armLength),'Callback',@EXP_UALength_Callback,'Tag','UALength','HorizontalAlignment','center','Units','normalized','Position',[.65 .9 .3 .1],'UserData','right','FontSize',10);
% Elbow to end effector distance
uicontrol(expPanel,'Style','text','String','Elbow to end effector (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.73,0.6,0.1],'FontSize',10);
myhandles.ui.exp_eelength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.e2eLength),'Callback',@EXP_EELength_Callback,'Tag','EELength','HorizontalAlignment','center','Units','normalized','Position',[.65 .75 .3 .1],'UserData','right','FontSize',10);
% Elbow to hand distance
uicontrol(expPanel,'Style','text','String','Elbow to hand (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.58,0.6,0.1],'FontSize',10);
myhandles.ui.exp_ehlength = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.e2hLength),'Callback',@EXP_EHLength_Callback,'Tag','EHLength','HorizontalAlignment','center','Units','normalized','Position',[.65 .6 .3 .1],'UserData','right','FontSize',10);
% Shoulder abduction angle
uicontrol(expPanel,'Style','text','String','Shoulder Abduction (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.43,.6,.1],'FontSize',10);
myhandles.ui.exp_abdangle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.abdAngle),'Callback',@EXP_abdAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .45 .3 .1],'UserData','right','FontSize',10);
% Shoulder horizontal flexion angle
uicontrol(expPanel,'Style','text','String','Shoulder Horizontal Flexion (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.28,.6,.1],'FontSize',10);
myhandles.ui.exp_shfAngle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.shfAngle),'Callback',@EXP_shfAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .3 .3 .1],'UserData','right','FontSize',10);
% Elbow flexion angle
uicontrol(expPanel,'Style','text','String','Elbow Flexion (deg)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.13,.6,0.1],'FontSize',10);
myhandles.ui.exp_elfAngle = uicontrol(expPanel,'Style','edit','String',num2str(myhandles.exp.elfAngle),'Callback',@EXP_elfAngle_Callback,'Tag','EFAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .15 .3 .1],'UserData','right','FontSize',10);
% Arm selection (right or left) button group
armbg = uibuttongroup('Parent',expPanel,'Tag','ArmBG','SelectionChangedFcn',@EXP_armbg_Callback,'Position',[0.05 0.02 0.9 0.1],'BorderType','none');
uicontrol(armbg,'Style','radiobutton','Tag','right','String','Right arm','Units','normalized','Position',[0.2 0 0.4 0.9],'FontSize',10);
uicontrol(armbg,'Style','radiobutton','Tag','left','String','Left arm','Units','normalized','Position',[0.65 0 0.4 0.9],'FontSize',10);

%% DAQ Panel
daqPanel = uipanel('Title','DAQ','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.7,0.3,0.3]);
% Number of channels
uicontrol(daqPanel,'Style','text','String','# of Channels','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.85,.5,.1],'FontSize',10);
myhandles.ui.daq_nChan = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.nChan),'Tag','numChan','Callback',@DAQ_nChan_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .84 .3 .15],'FontSize',10);
% Sampling rate
uicontrol(daqPanel,'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.65,.6,0.1],'FontSize',10);
myhandles.ui.daq_srate = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.sRate),'Tag','sampRate','Callback',@DAQ_sRate_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .64 .3 .15],'FontSize',10);
% Sampling length
uicontrol(daqPanel,'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.45,0.6,0.1],'FontSize',10);
myhandles.ui.daq_stime = uicontrol(daqPanel,'Style','edit','String',num2str(myhandles.daq.sTime),'Tag','sampTime','Callback',@DAQ_sTime_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .44 .3 .15],'FontSize',10);
% Realtime DAQ Checkbox
myhandles.ui.daq_rt = uicontrol(daqPanel,'Style','checkbox','String','Realtime DAQ','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_RT_Callback,'Position',[0.55 0.3 0.4 0.1],'FontSize',10);
myhandles.daq.rt = 0;
% TTL Checkbox
myhandles.ui.daq_ttl = uicontrol(daqPanel,'Style','checkbox','String','TTL Pulse','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_TTL_Callback,'Position',[0.15 0.3 0.3 0.1],'FontSize',10);
myhandles.daq.ttl = 0;
%% 
% Initialize DAQ pushbutton 
uicontrol(daqPanel,'Style','pushbutton','Callback',@DAQ_Init_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.2 0.02 0.6 0.24],'FontSize',11,'Enable','off');
% Timer - not enabled in this version
% tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% myhandles.Timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.Timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);

%% Protocol Panel
proPanel = uipanel('Title','Experimental Protocol','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.25,0.3,0.44]);
% File name
uicontrol(proPanel,'Style','text','String','File Name','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.5,0.1],'FontSize',10);
myhandles.ui.exp_fname = uicontrol(proPanel,'Style','edit','String',myhandles.exp.fname,'Callback',@EXP_fName_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.55 .9 .4 .1],'FontSize',10);
% Trial number
uicontrol(proPanel,'Style','text','String','Trial number','HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.73,0.5,0.1],'FontSize',10);
myhandles.ui.exp_itrial = uicontrol(proPanel,'Style','edit','String',num2str(myhandles.exp.itrial),'HorizontalAlignment','Center','Callback',@EXP_iTrial_Callback,'Units','normalized','Position',[0.55 0.75 0.4 0.1],'FontSize',10);
% Locate shoulder and weigh arm pushbutton 
uicontrol(proPanel,'Style','pushbutton','Callback',@EXP_LSWA_Callback,'HorizontalAlignment','center','String','Locate Shoulder & Weigh Arm','Units','normalized','Position',[0.2 0.5 0.67 0.17],'FontSize',11,'BackgroundColor','c','Enable','off');
% Acquire button
fighandle.KeyPressFcn = @gKeyPress_Callback;
myhandles.ui.exp_go = uicontrol(proPanel,'Style','pushbutton','Callback',@PRO_Go_Callback,'HorizontalAlignment','center','String','GO! (Press "g")','Units','normalized','Position',[0.2 0.28 0.67 0.17],'FontWeight','Bold','FontSize',10,'Enable','Off','BackgroundColor','g');
% File save directory
myhandles.ui.exp_dir = uicontrol(proPanel,'Style','text','String',sprintf('Data will be saved in %s',pwd),'HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.001,0.9,0.2],'FontSize',10);
% myhandles.ui.exp_itrial =

%% Monitor Panel
monPanel = uipanel('Title','Signal Monitor','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.01,0.3,0.23]);
% Endpoint vertical force
uicontrol(monPanel,'Style','text','String','Endpoint vertical force (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.76,.3,.2],'FontSize',10);
myhandles.ui.mon_eforce=uicontrol(monPanel,'Style','text','HorizontalAlignment','left','Units','normalized','Position',[0.46,0.75,.49,.18],'FontSize',14,'ForegroundColor','b');
% Endpoint position
uicontrol(monPanel,'Style','text','String','Endpoint position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.54,.4,.12],'FontSize',10);
myhandles.ui.mon_epos=uicontrol(monPanel,'Style','text','HorizontalAlignment','left','Units','normalized','Position',[0.46,0.5,.49,.18],'FontSize',14,'ForegroundColor','b');
% Shoulder position
uicontrol(monPanel,'Style','text','String','Shoulder position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.3,.4,.12],'FontSize',10);
myhandles.ui.mon_spos=uicontrol(monPanel,'Style','text','HorizontalAlignment','left','Units','normalized','Position',[0.46,0.26,.49,.18],'FontSize',14,'ForegroundColor','b');
% Arm weight
uicontrol(monPanel,'Style','text','String','Arm weight (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.05,.4,.12],'FontSize',10);
myhandles.ui.mon_awgt=uicontrol(monPanel,'Style','text','HorizontalAlignment','left','Units','normalized','Position',[0.46,0.01,.49,.18],'FontSize',14,'ForegroundColor','b');

%% Metria Panel
metPanel = uipanel('Title','Metria Motion Capture','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.63,0.65,0.36,0.35]);
% Motion Capture Checkbox
myhandles.ui.met_on = uicontrol(metPanel,'Style','checkbox','String','Enable Motion Capture','Units','Normalized','Enable','On','Interruptible','on','Callback',@MET_MC_Callback,'Position',[0.05 0.88 0.4 0.1],'FontSize',10);
myhandles.met.on = 0;
% Marker ID and visibility
uicontrol(metPanel,'Style','text','String','                                  Marker ID                      Visible','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.77,0.9,0.1],'FontSize',10);
uicontrol(metPanel,'Style','text','String',sprintf('Trunk'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.62,0.3,0.15],'FontSize',10);
myhandles.ui.met_markerid(1) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .65 .25 .15],'FontSize',10);
uicontrol(metPanel,'Style','text','String',sprintf('Shoulder'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.42,0.3,0.15],'FontSize',10);
myhandles.ui.met_markerid(2) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .45 .25 .15],'FontSize',10);
uicontrol(metPanel,'Style','text','String',sprintf('Arm'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.22,0.3,0.15],'FontSize',10);
myhandles.ui.met_markerid(3) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .25 .25 .15],'FontSize',10);
uicontrol(metPanel,'Style','text','String',sprintf('Forearm'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.02,0.3,0.15],'FontSize',10);
myhandles.ui.met_markerid(4) = uicontrol(metPanel,'Style','edit','HorizontalAlignment','center','Units','normalized','Position',[.35 .05 .25 .15],'FontSize',10);
myhandles.ui.met_markervis(1)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.63,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);
myhandles.ui.met_markervis(2)=uicontrol(metPanel,'Style','text','String','YES','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.43,0.3,0.15],'FontSize',16,'ForegroundColor','g');
myhandles.ui.met_markervis(3)=uicontrol(metPanel,'Style','text','String','NO','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.23,0.3,0.15],'FontSize',16,'ForegroundColor','r');
myhandles.ui.met_markervis(4)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.03,0.3,0.15],'FontSize',16,'ForegroundColor',[1 0.5 0.25]);

%% MENU ITEMS FOR GUI
% Setup Menu
setupMenu = uimenu(fighandle,'Label','Setup');
% Are the output arguments needed?
uimenu(setupMenu,'Label','Participant Information','Callback',{@EXP_partInfo_Callback,myhandles});
uimenu(setupMenu,'Label','Save Setup','Callback',@EXP_saveSetup_Callback);
uimenu(setupMenu,'Label','Load Setup','Callback',@EXP_loadSetup_Callback);

% ACT3D Menu
act3dMenu = uimenu(fighandle,'Label','ACT3D');
% Are the output arguments needed?
uimenu(act3dMenu,'Label','Power off','Callback',{@ACT3D_powerOff_Callback,myhandles});

% Save data in Figure
guidata(fighandle,myhandles)

% ACT3D Initialize Pushbutton
function ACT3D_Init_Callback(hObject,event)
    disp(hObject)
    disp('It works')
    myhandles
end

% emgDAQ.Fig.Visible = 'on';
%Right or Left Arm
function EXP_armbg_Callback(~,event)
myhandles.exp.arm = event.NewValue.Tag;
guidata(fighandle,myhandles)
disp(myhandles.exp.arm)
% sbold = event.OldValue.String;
% if ~strcmp(sbnew,sbold)
%     myhandles.armSwitched = 1;
%     myhandles.pbAcquireVal = 0;
% end
% ArmBG = source.SelectedObject.String;
% source.UserData = ArmBG;
% myhandles.armChoice = ArmBG;
end

function ACT3D_tablebg_Callback(~,event)
myhandles.act3d.table = event.NewValue.Tag;
guidata(fighandle,myhandles)
disp(myhandles.act3d.table)
end

function ACT3D_loadbg1_Callback(~,event)
myhandles.act3d.loadtype = event.NewValue.Tag;
guidata(fighandle,myhandles)
disp(myhandles.act3d.loadtype)
end

function ACT3D_loadbg2_Callback(~,event)
myhandles.act3d.loadstate = event.NewValue.Tag;
guidata(fighandle,myhandles)
disp(myhandles.act3d.loadstate)
end

end

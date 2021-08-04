if exist('act3dTACS') delete(act3dTACS); end
clear all
%% Create figure
scrsz = get(groot,'ScreenSize');
act3dTACS = figure('Name','ACT3D - Trunk Arm Coordination Study','NumberTitle','off','OuterPosition',[0.25*scrsz(3) 40 0.75*scrsz(3) scrsz(4)-40]);
act3dTACS.MenuBar = 'none';
% act3dTACS.Fig.CloseRequestFcn =  @closeMainGUI;
myhandles = guihandles(act3dTACS);

myhandles.act3d.load=10;

myhandles.daq.nChan=15;
myhandles.daq.sRate=1000;
myhandles.daq.sTime=20;

myhandles.exp.armLength=29;
myhandles.exp.e2eLength=18;
myhandles.exp.e2hLength=12;
myhandles.exp.abdAngle=90;
myhandles.exp.shfAngle=45;
myhandles.exp.elfAngle=90;
myhandles.exp.arm = 'right';
myhandles.exp.fname='trial';
myhandles.exp.itrial=1;
myhandles.exp.endforce=5.6;
myhandles.exp.endpos=[3.24 -2.31 4.56];
myhandles.exp.shpos=[-3.42 2.33 -4.51];
myhandles.exp.armwgt=15;

myhandles.met.markerID=19;

guidata(act3dTACS,myhandles)

AddGUIPanels(act3dTACS);

return
% %% Create panels
% %% ACT3D Panel
% act3dPanel = uipanel('Title','ACT3D','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Tag','numChanET','Position',[0.01,0.55,0.3,0.45]);
% % State
% uicontrol(act3dPanel,'Style','text','String','Current State','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.78,.4,.15],'FontSize',10);
% myhandles.act3d.state_Text=uicontrol(act3dPanel,'Style','text','String','test','HorizontalAlignment','left','Units','normalized','Position',[0.45,0.8,.6,.15],'FontSize',18,'ForegroundColor','b');
% % Initialize/Normal/Fix ACT3D pushbutton 
% uicontrol(act3dPanel,'Style','pushbutton','Callback',@ACT3D_Init_Callback,'String','Initialize ACT3D','Units','normalized','Position',[0.2 0.6 0.67 0.2],'FontSize',11,'BackgroundColor','y');
% % Table on/off
% uicontrol(act3dPanel,'Style','text','String','Table','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.4,.3,.1],'FontSize',10);
% tablebg = uibuttongroup('Parent',act3dPanel,'Tag','TableBG','SelectionChangedFcn',@ACT3D_tablebg_Callback,'Position',[0.4 0.43 .4 .1],'BorderType','none');
% uicontrol(tablebg,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0 0 0.45 1],'FontSize',10,'Enable','off');
% offb=uicontrol(tablebg,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.5 0 0.45 1],'FontSize',10);
% tablebg.SelectedObject=offb;
% % Load
% uicontrol(act3dPanel,'Style','text','String',sprintf('Load\n(+ up, - down)'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.16,0.3,0.1],'FontSize',10);
% myhandles.act3d.load_Edit = uicontrol(act3dPanel,'Style','edit','String',myhandles.act3d.load,'Tag','load','Callback',@ACT3D_load_Callback,'Units','normalized','Position',[.4 .2 .15 .17],'HorizontalAlignment','center','FontSize',10);
% % Load specified as
% loadbg1 = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG1','SelectionChangedFcn',@ACT3D_loadbg1_Callback,'Position',[0.59 .2 .36 0.18],'BorderType','none');
% uicontrol(loadbg1,'Style','radiobutton','Tag','max','String','% Abduction Max','Units','normalized','Position',[0 0.66 1 0.33],'FontSize',10,'Enable','off');
% uicontrol(loadbg1,'Style','radiobutton','Tag','wgh','String','% Arm weight','Units','normalized','Position',[0 0.33 1 0.33],'FontSize',10,'Enable','off');
% offb2=uicontrol(loadbg1,'Style','radiobutton','Tag','abs','String','Value in N','Units','normalized','Position',[0 0 1 0.33],'FontSize',10);
% loadbg1.SelectedObject=offb2;
% % Load on/off
% loadbg2 = uibuttongroup('Parent',act3dPanel,'Tag','LoadBG2','SelectionChangedFcn',@ACT3D_loadbg2_Callback,'Position',[0.4 0.05 .55 .12]);
% uicontrol(loadbg2,'Style','radiobutton','Tag','on','String','On','Units','normalized','Position',[0.15 0 0.45 1],'FontSize',10,'Enable','off');
% offb3=uicontrol(loadbg2,'Style','radiobutton','Tag','off','String','Off','Units','normalized','Position',[0.7 0 0.45 1],'FontSize',10);
% loadbg2.SelectedObject=offb3;
% 
% %% Experimental Setup Panel
% expPanel = uipanel('Title','Experimental Setup','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.01,0.01,0.3,0.53]);
% % Arm length
% uicontrol(expPanel,'Style','text','String','Upper arm length (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.6,0.1],'FontSize',10);
% myhandles.uaLength_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.armLength,'Callback',@EXP_UALength_Callback,'Tag','UALength','HorizontalAlignment','center','Units','normalized','Position',[.65 .9 .3 .1],'UserData','right','FontSize',10);
% % Elbow to end effector distance
% uicontrol(expPanel,'Style','text','String','Elbow to end effector (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.73,0.6,0.1],'FontSize',10);
% myhandles.eeLength_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.e2eLength,'Callback',@EXP_EELength_Callback,'Tag','EELength','HorizontalAlignment','center','Units','normalized','Position',[.65 .75 .3 .1],'UserData','right','FontSize',10);
% % Elbow to hand distance
% uicontrol(expPanel,'Style','text','String','Elbow to hand (cm)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.58,0.6,0.1],'FontSize',10);
% myhandles.ehLength_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.e2hLength,'Callback',@EXP_EHLength_Callback,'Tag','EHLength','HorizontalAlignment','center','Units','normalized','Position',[.65 .6 .3 .1],'UserData','right','FontSize',10);
% % Shoulder abduction angle
% uicontrol(expPanel,'Style','text','String','Shoulder Abduction (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.43,.6,.1],'FontSize',10);
% myhandles.exp.abdAngle_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.abdAngle,'Callback',@EXP_abdAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .45 .3 .1],'UserData','right','FontSize',10);
% % Shoulder horizontal flexion angle
% uicontrol(expPanel,'Style','text','String','Shoulder Horizontal Flexion (deg)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.28,.6,.1],'FontSize',10);
% myhandles.exp.shfAngle_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.shfAngle,'Callback',@EXP_shfAngle_Callback,'Tag','abdAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .3 .3 .1],'UserData','right','FontSize',10);
% % Elbow flexion angle
% uicontrol(expPanel,'Style','text','String','Elbow Flexion (deg)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.13,.6,0.1],'FontSize',10);
% myhandles.exp.elfAngle_Edit = uicontrol(expPanel,'Style','edit','String',myhandles.exp.elfAngle,'Callback',@EXP_elfAngle_Callback,'Tag','EFAngle','HorizontalAlignment','center','Units','normalized','Position',[.65 .15 .3 .1],'UserData','right','FontSize',10);
% % Arm selection (right or left) button group
% armbg = uibuttongroup('Parent',expPanel,'Tag','ArmBG','SelectionChangedFcn',@EXP_armbg_Callback,'Position',[0.05 0.02 0.9 0.1],'BorderType','none');
% uicontrol(armbg,'Style','radiobutton','Tag','right','String','Right arm','Units','normalized','Position',[0.2 0 0.4 0.9],'FontSize',10);
% uicontrol(armbg,'Style','radiobutton','Tag','left','String','Left arm','Units','normalized','Position',[0.65 0 0.4 0.9],'FontSize',10);
% 
% %% DAQ Panel
% daqPanel = uipanel('Title','DAQ','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.7,0.3,0.3]);
% % Number of channels
% uicontrol(daqPanel,'Style','text','String','# of Channels','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.85,.5,.1],'FontSize',10);
% myhandles.daq.nChan_Edit = uicontrol(daqPanel,'Style','edit','String',myhandles.daq.nChan,'Tag','numChan','Callback',@DAQ_nChan_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .84 .3 .15],'FontSize',10);
% % Sampling rate
% uicontrol(daqPanel,'Style','text','String','Sampling Rate (Hz)','HorizontalAlignment','left','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.65,.6,0.1],'FontSize',10);
% myhandles.daq.sRate_Edit = uicontrol(daqPanel,'Style','edit','String',myhandles.daq.sRate,'Tag','sampRate','Callback',@DAQ_sRate_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .64 .3 .15],'FontSize',10);
% % Sampling length
% uicontrol(daqPanel,'Style','text','String','Sampling Time (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.45,0.6,0.1],'FontSize',10);
% myhandles.daq.sTime_Edit = uicontrol(daqPanel,'Style','edit','String',myhandles.daq.sTime,'Tag','sampTime','Callback',@DAQ_sTime_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.65 .44 .3 .15],'FontSize',10);
% % Realtime DAQ Checkbox
% myhandles.daq.RTcheckbox = uicontrol(daqPanel,'Style','checkbox','String','Realtime DAQ','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_RT_Callback,'Position',[0.55 0.3 0.4 0.1],'FontSize',10);
% myhandles.daq.RT = 0;
% % TTL Checkbox
% myhandles.daq.TTLcheckbox = uicontrol(daqPanel,'Style','checkbox','String','TTL Pulse','Units','Normalized','Enable','Off','Interruptible','on','Callback',@DAQ_TTL_Callback,'Position',[0.15 0.3 0.3 0.1],'FontSize',10);
% myhandles.daq.TTL = 0;
% % Initialize DAQ pushbutton 
% uicontrol(daqPanel,'Style','pushbutton','Callback',@DAQ_Init_Callback,'String','Initialize DAQ','Units','normalized','Position',[0.2 0.02 0.6 0.24],'FontSize',11,'Enable','off');
% % Timer - not enabled in this version
% % tDaq = uicontrol(daqParaPanel,'Style','text','String','Timer (s)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.475,0.6,0.1]);
% % myhandles.Timer_Edit = uicontrol(daqParaPanel,'Style','edit','String',myhandles.Timer,'Tag','timeDelay','Callback',@TimerVal_Callback,'HorizontalAlignment','center','Units','normalized','Position',[.75 .5 .2 .075]);
% 
% %% Protocol Panel
% proPanel = uipanel('Title','Experimental Protocol','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.25,0.3,0.44]);
% % File name
% uicontrol(proPanel,'Style','text','String','File Name','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.88,0.5,0.1],'FontSize',10);
% myhandles.exp.fName_Edit = uicontrol(proPanel,'Style','edit','Callback',@EXP_fName_Callback,'String',myhandles.exp.fname,'HorizontalAlignment','center','Units','normalized','Position',[.55 .9 .4 .1],'FontSize',10);
% % Trial number
% uicontrol(proPanel,'Style','text','String','Trial number','HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.73,0.5,0.1],'FontSize',10);
% myhandles.exp.trNumber = uicontrol(proPanel,'Style','edit','HorizontalAlignment','Center','Callback',@EXP_trNumber_Callback,'String',num2str(myhandles.exp.itrial),'Units','normalized','Position',[0.55 0.75 0.4 0.1],'FontSize',10);
% % Locate shoulder and weigh arm pushbutton 
% uicontrol(proPanel,'Style','pushbutton','Callback',@EXP_LSWA_Callback,'HorizontalAlignment','center','String','Locate Shoulder & Weigh Arm','Units','normalized','Position',[0.2 0.5 0.67 0.17],'FontSize',11,'BackgroundColor','c','Enable','off');
% % Acquire button
% act3dTACS.Fig.KeyPressFcn = @gKeyPress_Callback;
% myhandles.exp.Go = uicontrol(proPanel,'Style','pushbutton','Callback',@PRO_Go_Callback,'HorizontalAlignment','center','String','GO! (Press "g")','Units','normalized','Position',[0.2 0.28 0.67 0.17],'FontWeight','Bold','FontSize',10,'Enable','Off','BackgroundColor','g');
% % File save directory
% myhandles.exp.currdir = uicontrol(proPanel,'Style','text','String',sprintf('Data will be saved in %s',pwd),'HorizontalAlignment','Left','Units','normalized','Position',[0.05,0.001,0.9,0.2],'FontSize',10);
% 
% %% Monitor Panel
% monPanel = uipanel('Title','Signal Monitor','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.32,0.01,0.3,0.23]);
% % Endpoint vertical force
% uicontrol(monPanel,'Style','text','String','Endpoint vertical force (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.76,.3,.2],'FontSize',10);
% myhandles.mon.efor_Text=uicontrol(monPanel,'Style','text','String',num2str(myhandles.exp.endforce),'HorizontalAlignment','left','Units','normalized','Position',[0.46,0.75,.49,.18],'FontSize',14,'ForegroundColor','b');
% % Endpoint position
% uicontrol(monPanel,'Style','text','String','Endpoint position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.54,.4,.12],'FontSize',10);
% myhandles.mon.epos_Text=uicontrol(monPanel,'Style','text','String',mat2str(myhandles.exp.endpos),'HorizontalAlignment','left','Units','normalized','Position',[0.46,0.5,.49,.18],'FontSize',14,'ForegroundColor','b');
% % Shoulder position
% uicontrol(monPanel,'Style','text','String','Shoulder position (m)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.3,.4,.12],'FontSize',10);
% myhandles.mon.spos_Text=uicontrol(monPanel,'Style','text','String',mat2str(myhandles.exp.shpos),'HorizontalAlignment','left','Units','normalized','Position',[0.46,0.26,.49,.18],'FontSize',14,'ForegroundColor','b');
% % Arm weight
% uicontrol(monPanel,'Style','text','String','Arm weight (N)','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.05,.4,.12],'FontSize',10);
% myhandles.mon.awgt_Text=uicontrol(monPanel,'Style','text','String',num2str(myhandles.exp.armwgt),'HorizontalAlignment','left','Units','normalized','Position',[0.46,0.01,.49,.18],'FontSize',14,'ForegroundColor','b');
% 
% %% Metria Panel
% metPanel = uipanel('Title','Metria Motion Capture','FontSize',12,'FontWeight','Bold','HighlightColor','[0.5 0 0.9]','Position',[0.63,0.65,0.36,0.35]);
% % Motion Capture Checkbox
% myhandles.met.MCcheckbox = uicontrol(metPanel,'Style','checkbox','String','Enable Motion Capture','Units','Normalized','Enable','On','Interruptible','on','Callback',@MET_MC_Callback,'Position',[0.05 0.88 0.4 0.1],'FontSize',10);
% myhandles.met.MC = 0;
% % Marker ID and visibility
% uicontrol(metPanel,'Style','text','String','                                  Marker ID                      Visible','HorizontalAlignment','left','Units','normalized','Position',[0.05,0.77,0.9,0.1],'FontSize',10);
% uicontrol(metPanel,'Style','text','String',sprintf('Trunk'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.62,0.3,0.15],'FontSize',10);
% myhandles.met.markerID_Edit(1) = uicontrol(metPanel,'Style','edit','Callback',@MET_mID_Callback,'String',myhandles.met.markerID,'HorizontalAlignment','center','Units','normalized','Position',[.35 .65 .25 .15],'FontSize',10);
% uicontrol(metPanel,'Style','text','String',sprintf('Shoulder'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.42,0.3,0.15],'FontSize',10);
% myhandles.met.markerID_Edit(2) = uicontrol(metPanel,'Style','edit','Callback',@MET_mID_Callback,'String',myhandles.met.markerID,'HorizontalAlignment','center','Units','normalized','Position',[.35 .45 .25 .15],'FontSize',10);
% uicontrol(metPanel,'Style','text','String',sprintf('Arm'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.22,0.3,0.15],'FontSize',10);
% myhandles.met.markerID_Edit(3) = uicontrol(metPanel,'Style','edit','Callback',@MET_mID_Callback,'String',myhandles.met.markerID,'HorizontalAlignment','center','Units','normalized','Position',[.35 .25 .25 .15],'FontSize',10);
% uicontrol(metPanel,'Style','text','String',sprintf('Forearm'),'HorizontalAlignment','left','Units','normalized','Position',[0.05,0.02,0.3,0.15],'FontSize',10);
% myhandles.met.markerID_Edit(4) = uicontrol(metPanel,'Style','edit','Callback',@MET_mID_Callback,'String',myhandles.met.markerID,'HorizontalAlignment','center','Units','normalized','Position',[.35 .05 .25 .15],'FontSize',10);
% myhandles.met.markerVIS(1)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.63,0.3,0.15],'FontSize',16,'ForegroundColor','y');
% myhandles.met.markerVIS(2)=uicontrol(metPanel,'Style','text','String','YES','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.43,0.3,0.15],'FontSize',16,'ForegroundColor','g');
% myhandles.met.markerVIS(3)=uicontrol(metPanel,'Style','text','String','NO','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.23,0.3,0.15],'FontSize',16,'ForegroundColor','r');
% myhandles.met.markerVIS(4)=uicontrol(metPanel,'Style','text','String','N/A','HorizontalAlignment','center','Units','normalized','Position',[0.65,0.03,0.3,0.15],'FontSize',16,'ForegroundColor','y');
% 
% %% MENU ITEMS FOR GUI
% % Setup Menu
% act3dTACS.menu.Setup = uimenu(act3dTACS.Fig,'Label','Setup');
% % Are the output arguments needed?
% mPartInfo= uimenu(act3dTACS.menu.Setup,'Label','Participant Information','Callback',{@EXP_partInfo_Callback,myhandles});
% mSaveSetup = uimenu(act3dTACS.menu.Setup,'Label','Save Setup','Callback',@EXP_saveSetup_Callback);
% mLoadSetup = uimenu(act3dTACS.menu.Setup,'Label','Load Setup','Callback',@EXP_loadSetup_Callback);
% 
% % ACT3D Menu
% act3dTACS.menu.ACT3D = uimenu(act3dTACS.Fig,'Label','ACT3D');
% % Are the output arguments needed?
% mACT3DOff= uimenu(act3dTACS.menu.ACT3D,'Label','Power off','Callback',{@ACT3D_powerOff_Callback,myhandles});

% emgDAQ.Fig.Visible = 'on';
%Right or Left Arm
% function EXP_armbg_Callback(~,event)
% myhandles.exp.arm = event.NewValue.Tag;
% disp(myhandles.exp.arm)
% % sbold = event.OldValue.String;
% % if ~strcmp(sbnew,sbold)
% %     myhandles.armSwitched = 1;
% %     myhandles.pbAcquireVal = 0;
% % end
% % ArmBG = source.SelectedObject.String;
% % source.UserData = ArmBG;
% % myhandles.armChoice = ArmBG;
% end
% 
% function ACT3D_tablebg_Callback(~,event)
% myhandles.act3d.table = event.NewValue.Tag;
% disp(myhandles.act3d.table)
% end
% 
% function ACT3D_loadbg1_Callback(~,event)
% myhandles.act3d.loadtype = event.NewValue.Tag;
% disp(myhandles.act3d.loadtype)
% end
% 
% function ACT3D_loadbg2_Callback(~,event)
% myhandles.act3d.loadstate = event.NewValue.Tag;
% disp(myhandles.act3d.loadstate)
% end

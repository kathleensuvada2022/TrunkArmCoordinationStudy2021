% TO RUN 

%% RTIS 2001 - RT ( Line 45)  and UT ( line 60)  
% RTIS2001
partid='RTIS2001';
% RT - 
emgval = PlotKinematicData4(partid,'RTIS2001_000000','Target_',1);
print('-f3','-djpeg',[partid '_RT_NRSA'])
% UT - 
emgval = PlotKinematicData4(partid,'2001tf_final_000000','Target_',3)
print('-f3','-djpeg',[partid '_UT_NRSA'])

emgval = PlotKinematicData4(partid,'2001tf_final_000000','Target_',4)





%% Control1
partid='Control';
filename='091919_Test_000000';
flpathmaxes = '/Users/kcs762/Desktop/Strokedata/Control1/maxes/';

% RT - 
% PlotKinematicData(partid,'/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002','2002tr_000000',4:5);

% COMMENTING OUT THE PORTIONS FOR METRIA BC NO HAND MARKER OR BL MARKER
PlotKinematicData4(partid,filename,'Target_',1);
% PlotKinematicData3(partid,filename,'Target_',1);
%title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])

% % RL --> didn't enter these bc didn't get SABD MAX.. 
% PlotKinematicData3(partid,filename,'Target_',2);
% title([partid ' Trunk restrained - load']);

% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData3(partid,filename,'Target_',3)
%title([partid ' Trunk unrestrained - table'])

% print('-f3','-djpeg',[partid '_UT'])
% UL - clse
% % PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
% PlotKinematicData3(partid,filename,'Target_',4)
% title([partid ' Trunk unrestrained - 5% Max SABD'])
% % print('-f3','-djpeg',[partid '_RL'])

%% RTIS2001
partid='RTIS2001';
flpathmaxes = '/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes';


% RT - 
 emgval = PlotKinematicData4(partid,'RTIS2001_000000','Target_',1);
% PlotKinematicData2(partid,'RTIS2001_000000','/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes','Target_',1)
%/users/kcs762/desktop/strokedata/rtis2001/metria/trunkrestrained
%title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_EMGs_RT'])

% RL
emgval = PlotKinematicData4(partid,'RTIS2001_000000','Target_',2);
% print('-f3','-djpeg',[partid '_EMGs_RL'])
 %PlotKinematicData2(partid,'RTIS2001_000000','/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes','Target_',2)

% title([partid ' Trunk restrained - load']);

% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
emgval = PlotKinematicData4(partid,'2001tf_final_000000','Target_',3)
% print('-f3','-djpeg',[partid '_EMGs_UT'])
% PlotKinematicData2(partid,'RTIS2001_000000','/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes','Target_',3)


% UL - 
emgval = PlotKinematicData4(partid,'2001tf_final_000000','Target_',4)
% print('-f3','-djpeg',[partid '_EMGs_UL'])
 %PlotKinematicData2(partid,'2001tf_final_000000','/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes','Target_',4)


% title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])

%% RTIS2002
partid='RTIS2002';
flpathmaxes = '/Users/kcs762/Desktop/Strokedata/RTIS2002/maxes';


%PlotKinematicData2(partid,metriafname,act3dfname,expcond)
% RT - 
emgval = PlotKinematicData4(partid,'2002_tr_000000','Target_',1);
% title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid 'EMGs_RT'])

% RL
PlotKinematicData4(partid,'2002_tr_000000','Target_',2);
% title([partid ' Trunk restrained - load']);
% print('-f3','-djpeg',[partid 'EMGs_RL'])

% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
emgval =PlotKinematicData4(partid,'2002tf_000000','Target_',3)
% title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid 'EMGs_UT'])
% print('-f3','-djpeg',[partid '_UT'])

% UL - 
PlotKinematicData4(partid,'2002tf_000000','Target_',4)
% figure(3)
% title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])
% print('-f3','-djpeg',[partid 'EMGs_UL'])
%% RTIS 1001
partid='RTIS1001';
flpathmaxes = '/Users/kcs762/Box/KACEY/Data/RTIS1001/maxes';
basename = 'MAXES';
setfname = 'savedsetupKacey';
plotflag =1 ;
GetMaxMusAct3(flpathmaxes,basename,setfname,partid,plotflag)

% Use to run through EMGS for all trials
% TR - table 
flpath = '/Users/kcs762/Box/KACEY/Data/RTIS1001/Trunkrestrained/Table';
basename = 'trial';
trials=dir([flpath '/*'  '*.mat']);
    for i = 1:length(trials)
    load([flpath '/' trials(i)
    end 
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PlotKinematicData2(partid,metriafname,act3dfname,expcond)
% RT - 
emgval = PlotKinematicData4(partid,'2002_tr_000000','Target_',1);
% title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid 'EMGs_RT'])

% RL
PlotKinematicData4(partid,'2002_tr_000000','Target_',2);
% title([partid ' Trunk restrained - load']);
% print('-f3','-djpeg',[partid 'EMGs_RL'])

% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
emgval =PlotKinematicData4(partid,'2002tf_000000','Target_',3)
% title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid 'EMGs_UT'])
% print('-f3','-djpeg',[partid '_UT'])

% UL - 
PlotKinematicData4(partid,'2002tf_000000','Target_',4)
% figure(3)
% title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])
% print('-f3','-djpeg',[partid 'EMGs_UL'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Current Analysis - 1.18.21 
 
 % RTIS2001
partid='RTIS2001';
% RT - 
emgval = PlotKinematicData6(partid,'RTIS2001_000000','Target_',1);

% UT - 
emgval = PlotKinematicData6(partid,'2001tf_final_000000','Target_',3)

% UL
emgval = PlotKinematicData6(partid,'2001tf_final_000000','Target_',4)




% RTIS 2003 - EMG data all seems noise 2.25.21

partid = 'RTIS2003';

%RT
 avg_emg_maxvel=PlotKinematicData6(partid,'trial','trial',1);

%R25
avg_emg_maxvel = PlotKinematicData6(partid,'trial','trial',2);


%R50
avg_emg_maxvel = PlotKinematicData6(partid,'trial','trial',3);

%uT
avg_emg_maxvel = PlotKinematicData6(partid,'trial','trial',4);

%U25
avg_emg_maxvel = PlotKinematicData6(partid,'trial','trial',5);

%U50
avg_emg_maxvel= PlotKinematicData6(partid,'trial','trial',6);






% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}
%RTIS 2005
partid = 'RTIS2005';

%RT
emgval = PlotKinematicData6(partid,'trial','trial',1);

%R25
emgval = PlotKinematicData6(partid,'trial','trial',2);


%R50
emgval = PlotKinematicData6(partid,'trial','trial',3);

%UT
emgval = PlotKinematicData6(partid,'trial','trial',4);

%U25
emgval = PlotKinematicData6(partid,'trial','trial',5);


%U50
emgval = PlotKinematicData6(partid,'trial','trial',6);



 

%% Control1
partid='Control1';
filename='091919_Test_000000';
% RT - 
% PlotKinematicData(partid,'/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002','2002tr_000000',4:5);
partid='Control1';
PlotKinematicData2(partid,filename,'Target_',1);
title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])

% RL
PlotKinematicData2(partid,filename,'Target_',2);
title([partid ' Trunk restrained - load']);

% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData2(partid,filename,'Target_',3)
title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid '_UT'])
% UL - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
PlotKinematicData2(partid,filename,'Target_',4)
title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])

%% RTIS2001
partid='RTIS2001';
flpathmaxes = '/Users/kcs762/Desktop/Strokedata/RTIS2001/maxes';


% RT - 
% PlotKinematicData(partid,'/Users/kcs762/Desktop/Strokedata/RTIS2002','2002tr_000000',4:5);
%/users/kcs762/desktop/strokedata/rtis2001/metria/trunkrestrained
PlotKinematicData3(partid,'RTIS2001_000000','Target_',1);
title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])

%% RL
PlotKinematicData2(partid,'RTIS2001_000000','Target_',2);
title([partid ' Trunk restrained - load']);

%% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData3(partid,'2001tf_final_000000','Target_',3)
title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid '_UT'])
%% UL - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
PlotKinematicData2(partid,'2001tf_final_000000','Target_',4)
title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])

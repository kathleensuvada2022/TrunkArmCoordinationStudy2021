partid='RTIS2001';
%% RT - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkrestrained\','RTIS2001_000000',4:5);
PlotKinematicData2new(partid,'RTIS2001_000000','Target_',1);
title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])
%% UT - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData2new(partid,'2001tf_final_000000','Target_',3)
title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid '_UT'])
%% UL - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
PlotKinematicData2new(partid,'2001tf_final_000000','Target_',4)
title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])

%% RTIS2002
partid='RTIS2002';
%% RT - 
% PlotKinematicData(partid,'/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002','2002tr_000000',4:5);
PlotKinematicData2new(partid,'2002_tr_000000','Target_',1);
title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])

%% RL
PlotKinematicData2new(partid,'2002_tr_000000','Target_',2);
title([partid ' Trunk restrained - load']);

%% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData2new(partid,'2002_tf_000000','Target_',3)
title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid '_UT'])
%% UL - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
PlotKinematicData2new(partid,'2002_tf_000000','Target_',4)
title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])
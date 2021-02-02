%% RUN BEFORE REST

partid='RTIS2001';
flpathmaxes = '/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2001/maxes';
maxesname = '/maxes';
maxfilename = 'maxes'


%% RT - 
% PlotKinematicData(partid,'/Users/kcs762/Desktop/StrokeSubjectsData/RTIS2002','2002tr_000000',4:5);
partid='RTIS2001';
PlotKinematicData2(partid,'RTIS2001_000000','Target_',1);
title([partid ' Trunk restrained - table']);
% print('-f3','-djpeg',[partid '_RT'])

%% RL
PlotKinematicData2(partid,'RTIS2001_000000','Target_',2);
title([partid ' Trunk restrained - load']);

%% UT - /
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[2 5 7 10 11])
PlotKinematicData2(partid,'2001tf_final_000000','Target_',3)
title([partid ' Trunk unrestrained - table'])
% print('-f3','-djpeg',[partid '_UT'])
%% UL - 
% PlotKinematicData(partid,'RTIS2001\metria\trunkfree\','2001tf_final_000000',[1 3 4 6 8])
PlotKinematicData2(partid,'2001tf_final_000000','Target_',4)
title([partid ' Trunk unrestrained - 5% Max SABD'])
% print('-f3','-djpeg',[partid '_RL'])


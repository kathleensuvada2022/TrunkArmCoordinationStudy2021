% Participant log file
% RTIS2001
% Marker IDs: 
%    Trunk 2032 2080
%    Shoulder 2051 019
%    Lower arm: 2032 087
%    Upper arm 2032 073
%    Hand 2051 051
% markerid=[Trunk Shoulder Arm Forearm Hand]
setup.markerid=[80 19 73 87 51];

% Add the information regarding trial condition for metria and act3d data
% {TR table, TR load, TU table, TU load}
% Trunk or shoulder marker was blocked in TR load trials [1:3 7 10]
% Hand marker was out of range at end of movement in most U trials
% --> used forearm marker to compute hand position
% Metria data for trial 10 was missing the trunk and shoulder markers
setup.mtrial={4:5,[1:3 7],[2 5 7 10 11],[1 3 4 6 8]}; %RTIS2001_0000000#.hts / 2001tf_final_0000000#.hts
setup.atrial={26:27,[23:25 29],[1 4 6 9 10],[0 2 3 5 7]};%Target_0#_2_table_nidaq_emg.mat

save('RTIS2001_setup','setup');
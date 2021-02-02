% Participant log file
% RTIS2003
% Marker IDs: 

% markerid=[Trunk Shoulder Arm Forearm ]
setup.markerid=[80 19 87 73];

% Add the information regarding trial conditions

% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}

setup.trial={[8 9 10 11 12],[20 21 22 23 24],[15 16 17 18 19],[30 31 32 33 34 35],[25 26 27 28 29],[36 37 38 39 40]}; 

save('RTIS2003_setup','setup');

%% For Bony Landmark Analysis
% in same order as the marker in same order as above trunk shoulder forearm ** only shoulder and forearm 
                % SHOULDER:AA,GH,AC
                             
       % make changes to this find other BL script..
       % don't need BL.trial? See how organized now with new BL
       % digitization --> use from rtis 2003 and use test data from 1.28.21
               
 % P in LCS spit out in this order                
setup.bl.trial = {[],[7,9],[],[1,2,3,6]};
setup.bl.pointerid = {[],[237,237,237],[],[235,235,235,237]};
setup.bl.markerid = [80 19 73 87]; 

save('RTIS2003_setup','setup');



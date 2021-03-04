% Participant log file
% RTIS2003
% Marker IDs: 

% markerid=[Trunk Shoulder Arm Forearm ]
setup.markerid=[80 19 87 73];

% Add the information regarding trial conditions

% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}

setup.trial={[1 2 3 4 5 6],[7 8 9 10 11],[12 13 14 15 16],[17 18 19 20 21],[27 29 34 35],[22 23 24 25 26]}; 

save('RTIS2005_setup','setup');

%% For Bony Landmark Analysis
% in same order as the marker in same order as above trunk shoulder forearm ** only shoulder and forearm 
                % SHOULDER:AA,GH,AC
                             
       % make changes to this find other BL script..
       % don't need BL.trial? See how organized now with new BL
       % digitization --> use from rtis 2003 and use test data from 1.28.21
               
 % P in LCS spit out in this order                
setup.bl.trial = {'trunk','scap','humfore','MCP3'}; % later won't need this hopefully because will just be one BL file
setup.bl.pointerid = 237;
setup.bl.markerid = [80 19 87 73];

save('RTIS2005_setup','setup');



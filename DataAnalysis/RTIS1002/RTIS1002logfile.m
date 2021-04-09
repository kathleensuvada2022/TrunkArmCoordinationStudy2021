% Participant log file
% RTIS1003
% Marker IDs: 

% load('rtsi1002_Setup.mat')

% markerid=[Trunk Shoulder Arm Forearm ]
setup.markerid=[80 19 87 73];

% Add the information regarding trial conditions

% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}

setup.trial={[1 2 3 4 5],[12 13 14 15 16],[6 7 8 9 10 11],[17 18 19 20 21 22],[30 31 32 33 34 35 36],[29 23 24 25 26 27 28]}; 



%% For Bony Landmark Analysis
% in same order as the marker in same order as above trunk shoulder forearm ** only shoulder and forearm 
                % SHOULDER:AA,GH,AC
                             
       % make changes to this find other BL script..
       % don't need BL.trial? See how organized now with new BL
       % digitization --> use from rtis 2003 and use test data from 1.28.21
               

       
       
setup.bl.trial = {'trunk','scap','humfore','MCP3'}; % later won't need this hopefully because will just be one BL file
setup.bl.pointerid = 9;
setup.bl.markerid = [80 19 87 73];


%need to load BL file from experiment prior to running this

% Saving BLS from the LCS to setupfile
setup.bl.lcs{1,1}= bl{1,1}(:,1:3);
setup.bl.lcs{1,1} = setup.bl.lcs{1,1}';
setup.bl.lcs{1,1} = [setup.bl.lcs{1,1};1 1 1 1 1];

setup.bl.lcs{1,2}= bl{1,2}(:,1:3);
setup.bl.lcs{1,2} = setup.bl.lcs{1,2}';
setup.bl.lcs{1,2} = [setup.bl.lcs{1,2};1 1 1 1 1];

setup.bl.lcs{1,3}= bl{1,3}(:,1:3);
setup.bl.lcs{1,3} = setup.bl.lcs{1,3}';
setup.bl.lcs{1,3} = [setup.bl.lcs{1,3};1 1 1];

setup.bl.lcs{1,4}= bl{1,4}(:,1:3);
setup.bl.lcs{1,4} = setup.bl.lcs{1,4}';
setup.bl.lcs{1,4} = [setup.bl.lcs{1,4};1 1 1 1];


save('RTIS1003_setup','setup');
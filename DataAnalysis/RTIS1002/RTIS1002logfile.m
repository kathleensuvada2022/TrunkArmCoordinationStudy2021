% Participant log file
% RTIS1002
% Marker IDs: 

% markerid=[Trunk Shoulder Arm Forearm ]
setup.markerid=[80 19 87 73];

% Add the information regarding trial conditions

% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}

setup.trial={[1 2 3 4 5 6 7],[12 13 14 15],[8 9 10 11],[25 26 28 29 30 35],[16 17 18 19 20 45 46 47 ],[21 22 23 24 36 37]}; 

% save('RTIS1002_setup','setup');

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


save('RTIS1002_setup','setup');
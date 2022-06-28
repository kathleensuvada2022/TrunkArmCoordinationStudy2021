%% K. Suvada- May 2022

% Stroke-Paretic and can use for NP
% Edits June 2022 - hard coded results in before, but now can edit easily
% if numbers change.


%% Loading into Data File
%RTIS 2001-2011 Paretic
load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Stroke_Paretic.mat')
%%
%RTIS 2001-2011 Non-Paretic
load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Stroke_NonParetic.mat')
%%

% Finding the Rows for each participant in a given condition
% RTIS2001
% Condition 1:
cond1_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond1_2001_final = find(cell2mat(DataMatrix(cond1_2001,2))== 1);
     
cond1_2001 = cond1_2001(cond1_2001_final); % Rows of Matrix for 2001 condition 1

% Condition 2:
cond2_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond2_2001_final = find(cell2mat(DataMatrix(cond2_2001,2))== 2);
     
cond2_2001 = cond2_2001(cond2_2001_final); % Rows of Matrix for 2001 condition 2

% Condition 3:
cond3_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond3_2001_final = find(cell2mat(DataMatrix(cond3_2001,2))== 3);
     
cond3_2001 = cond3_2001(cond3_2001_final); % Rows of Matrix for 2001 condition 3

% Condition 4:
cond4_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond4_2001_final = find(cell2mat(DataMatrix(cond4_2001,2))== 4);
     
cond4_2001 = cond4_2001(cond4_2001_final); % Rows of Matrix for 2001 condition4

% Condition 5:
cond5_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond5_2001_final = find(cell2mat(DataMatrix(cond5_2001,2))== 5);
     
cond5_2001 = cond5_2001(cond5_2001_final); % Rows of Matrix for 2001 condition 5

% Condition 6:
cond6_2001 = find(strcmp(DataMatrix(:,1),'RTIS2001'));

cond6_2001_final = find(cell2mat(DataMatrix(cond6_2001,2))== 6);
     
cond6_2001 = cond6_2001(cond6_2001_final); % Rows of Matrix for 2001 condition 6


% RTIS2002
% Condition 1:
cond1_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond1_2002_final = find(cell2mat(DataMatrix(cond1_2002,2))== 1);
     
cond1_2002 = cond1_2002(cond1_2002_final); % Rows of Matrix for 2002 condition 1

% Condition 2:
cond2_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond2_2002_final = find(cell2mat(DataMatrix(cond2_2002,2))== 2);
     
cond2_2002 = cond2_2002(cond2_2002_final); % Rows of Matrix for 2002 condition 2

% Condition 3:
cond3_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond3_2002_final = find(cell2mat(DataMatrix(cond3_2002,2))== 3);
     
cond3_2002 = cond3_2002(cond3_2002_final); % Rows of Matrix for 2002 condition 3

% Condition 4:
cond4_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond4_2002_final = find(cell2mat(DataMatrix(cond4_2002,2))== 4);
     
cond4_2002 = cond4_2002(cond4_2002_final); % Rows of Matrix for 2002 condition4

% Condition 5:
cond5_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond5_2002_final = find(cell2mat(DataMatrix(cond5_2002,2))== 5);
     
cond5_2002 = cond5_2002(cond5_2002_final); % Rows of Matrix for 2002 condition 5

% Condition 6:
cond6_2002 = find(strcmp(DataMatrix(:,1),'RTIS2002'));

cond6_2002_final = find(cell2mat(DataMatrix(cond6_2002,2))== 6);
     
cond6_2002 = cond6_2002(cond6_2002_final); % Rows of Matrix for 2002 condition 6


% RTIS2003
% Condition 1:
cond1_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond1_2003_final = find(cell2mat(DataMatrix(cond1_2003,2))== 1);
     
cond1_2003 = cond1_2003(cond1_2003_final); % Rows of Matrix for 2003 condition 1

% Condition 2:
cond2_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond2_2003_final = find(cell2mat(DataMatrix(cond2_2003,2))== 2);
     
cond2_2003 = cond2_2003(cond2_2003_final); % Rows of Matrix for 2003 condition 2

% Condition 3:
cond3_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond3_2003_final = find(cell2mat(DataMatrix(cond3_2003,2))== 3);
     
cond3_2003 = cond3_2003(cond3_2003_final); % Rows of Matrix for 2003 condition 3

% Condition 4:
cond4_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond4_2003_final = find(cell2mat(DataMatrix(cond4_2003,2))== 4);
     
cond4_2003 = cond4_2003(cond4_2003_final); % Rows of Matrix for 2003 condition4

% Condition 5:
cond5_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond5_2003_final = find(cell2mat(DataMatrix(cond5_2003,2))== 5);
     
cond5_2003 = cond5_2003(cond5_2003_final); % Rows of Matrix for 2003 condition 5

% Condition 6:
cond6_2003 = find(strcmp(DataMatrix(:,1),'RTIS2003'));

cond6_2003_final = find(cell2mat(DataMatrix(cond6_2003,2))== 6);
     
cond6_2003 = cond6_2003(cond6_2003_final); % Rows of Matrix for 2003 condition 6

% RTIS2006
% Condition 1:
cond1_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond1_2006_final = find(cell2mat(DataMatrix(cond1_2006,2))== 1);
     
cond1_2006 = cond1_2006(cond1_2006_final); % Rows of Matrix for 2006 condition 1

% Condition 2:
cond2_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond2_2006_final = find(cell2mat(DataMatrix(cond2_2006,2))== 2);
     
cond2_2006 = cond2_2006(cond2_2006_final); % Rows of Matrix for 2006 condition 2

% Condition 3:
cond3_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond3_2006_final = find(cell2mat(DataMatrix(cond3_2006,2))== 3);
     
cond3_2006 = cond3_2006(cond3_2006_final); % Rows of Matrix for 2006 condition 3

% Condition 4:
cond4_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond4_2006_final = find(cell2mat(DataMatrix(cond4_2006,2))== 4);
     
cond4_2006 = cond4_2006(cond4_2006_final); % Rows of Matrix for 2006 condition4

% Condition 5:
cond5_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond5_2006_final = find(cell2mat(DataMatrix(cond5_2006,2))== 5);
     
cond5_2006 = cond5_2006(cond5_2006_final); % Rows of Matrix for 2006 condition 5

% Condition 6:
cond6_2006 = find(strcmp(DataMatrix(:,1),'RTIS2006'));

cond6_2006_final = find(cell2mat(DataMatrix(cond6_2006,2))== 6);
     
cond6_2006 = cond6_2006(cond6_2006_final); % Rows of Matrix for 2006 condition 6

% RTIS2007
% Condition 1:
cond1_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond1_2007_final = find(cell2mat(DataMatrix(cond1_2007,2))== 1);
     
cond1_2007 = cond1_2007(cond1_2007_final); % Rows of Matrix for 2007 condition 1

% Condition 2:
cond2_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond2_2007_final = find(cell2mat(DataMatrix(cond2_2007,2))== 2);
     
cond2_2007 = cond2_2007(cond2_2007_final); % Rows of Matrix for 2007 condition 2

% Condition 3:
cond3_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond3_2007_final = find(cell2mat(DataMatrix(cond3_2007,2))== 3);
     
cond3_2007 = cond3_2007(cond3_2007_final); % Rows of Matrix for 2007 condition 3

% Condition 4:
cond4_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond4_2007_final = find(cell2mat(DataMatrix(cond4_2007,2))== 4);
     
cond4_2007 = cond4_2007(cond4_2007_final); % Rows of Matrix for 2007 condition4

% Condition 5:
cond5_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond5_2007_final = find(cell2mat(DataMatrix(cond5_2007,2))== 5);
     
cond5_2007 = cond5_2007(cond5_2007_final); % Rows of Matrix for 2007 condition 5

% Condition 6:
cond6_2007 = find(strcmp(DataMatrix(:,1),'RTIS2007'));

cond6_2007_final = find(cell2mat(DataMatrix(cond6_2007,2))== 6);
     
cond6_2007 = cond6_2007(cond6_2007_final); % Rows of Matrix for 2007 condition 6

% RTIS2008
% Condition 1:
cond1_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond1_2008_final = find(cell2mat(DataMatrix(cond1_2008,2))== 1);
     
cond1_2008 = cond1_2008(cond1_2008_final); % Rows of Matrix for 2008 condition 1

% Condition 2:
cond2_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond2_2008_final = find(cell2mat(DataMatrix(cond2_2008,2))== 2);
     
cond2_2008 = cond2_2008(cond2_2008_final); % Rows of Matrix for 2008 condition 2

% Condition 3:
cond3_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond3_2008_final = find(cell2mat(DataMatrix(cond3_2008,2))== 3);
     
cond3_2008 = cond3_2008(cond3_2008_final); % Rows of Matrix for 2008 condition 3

% Condition 4:
cond4_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond4_2008_final = find(cell2mat(DataMatrix(cond4_2008,2))== 4);
     
cond4_2008 = cond4_2008(cond4_2008_final); % Rows of Matrix for 2008 condition4

% Condition 5:
cond5_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond5_2008_final = find(cell2mat(DataMatrix(cond5_2008,2))== 5);
     
cond5_2008 = cond5_2008(cond5_2008_final); % Rows of Matrix for 2008 condition 5

% Condition 6:
cond6_2008 = find(strcmp(DataMatrix(:,1),'RTIS2008'));

cond6_2008_final = find(cell2mat(DataMatrix(cond6_2008,2))== 6);
     
cond6_2008 = cond6_2008(cond6_2008_final); % Rows of Matrix for 2008 condition 6

% RTIS2009
% Condition 1:
cond1_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond1_2009_final = find(cell2mat(DataMatrix(cond1_2009,2))== 1);
     
cond1_2009 = cond1_2009(cond1_2009_final); % Rows of Matrix for 2009 condition 1

% Condition 2:
cond2_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond2_2009_final = find(cell2mat(DataMatrix(cond2_2009,2))== 2);
     
cond2_2009 = cond2_2009(cond2_2009_final); % Rows of Matrix for 2009 condition 2

% Condition 3:
cond3_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond3_2009_final = find(cell2mat(DataMatrix(cond3_2009,2))== 3);
     
cond3_2009 = cond3_2009(cond3_2009_final); % Rows of Matrix for 2009 condition 3

% Condition 4:
cond4_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond4_2009_final = find(cell2mat(DataMatrix(cond4_2009,2))== 4);
     
cond4_2009 = cond4_2009(cond4_2009_final); % Rows of Matrix for 2009 condition4

% Condition 5:
cond5_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond5_2009_final = find(cell2mat(DataMatrix(cond5_2009,2))== 5);
     
cond5_2009 = cond5_2009(cond5_2009_final); % Rows of Matrix for 2009 condition 5

% Condition 6:
cond6_2009 = find(strcmp(DataMatrix(:,1),'RTIS2009'));

cond6_2009_final = find(cell2mat(DataMatrix(cond6_2009,2))== 6);
     
cond6_2009 = cond6_2009(cond6_2009_final); % Rows of Matrix for 2009 condition 6
% RTIS2010
% Condition 1:
cond1_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond1_2010_final = find(cell2mat(DataMatrix(cond1_2010,2))== 1);
     
cond1_2010 = cond1_2010(cond1_2010_final); % Rows of Matrix for 2010 condition 1

% Condition 2:
cond2_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond2_2010_final = find(cell2mat(DataMatrix(cond2_2010,2))== 2);
     
cond2_2010 = cond2_2010(cond2_2010_final); % Rows of Matrix for 2010 condition 2

% Condition 3:
cond3_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond3_2010_final = find(cell2mat(DataMatrix(cond3_2010,2))== 3);
     
cond3_2010 = cond3_2010(cond3_2010_final); % Rows of Matrix for 2010 condition 3

% Condition 4:
cond4_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond4_2010_final = find(cell2mat(DataMatrix(cond4_2010,2))== 4);
     
cond4_2010 = cond4_2010(cond4_2010_final); % Rows of Matrix for 2010 condition4

% Condition 5:
cond5_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond5_2010_final = find(cell2mat(DataMatrix(cond5_2010,2))== 5);
     
cond5_2010 = cond5_2010(cond5_2010_final); % Rows of Matrix for 2010 condition 5

% Condition 6:
cond6_2010 = find(strcmp(DataMatrix(:,1),'RTIS2010'));

cond6_2010_final = find(cell2mat(DataMatrix(cond6_2010,2))== 6);
     
cond6_2010 = cond6_2010(cond6_2010_final); % Rows of Matrix for 2010 condition 6

% RTIS2011
% Condition 1:
cond1_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond1_2011_final = find(cell2mat(DataMatrix(cond1_2011,2))== 1);
     
cond1_2011 = cond1_2011(cond1_2011_final); % Rows of Matrix for 2011 condition 1

% Condition 2:
cond2_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond2_2011_final = find(cell2mat(DataMatrix(cond2_2011,2))== 2);
     
cond2_2011 = cond2_2011(cond2_2011_final); % Rows of Matrix for 2011 condition 2

% Condition 3:
cond3_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond3_2011_final = find(cell2mat(DataMatrix(cond3_2011,2))== 3);
     
cond3_2011 = cond3_2011(cond3_2011_final); % Rows of Matrix for 2011 condition 3

% Condition 4:
cond4_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond4_2011_final = find(cell2mat(DataMatrix(cond4_2011,2))== 4);
     
cond4_2011 = cond4_2011(cond4_2011_final); % Rows of Matrix for 2011 condition4

% Condition 5:
cond5_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond5_2011_final = find(cell2mat(DataMatrix(cond5_2011,2))== 5);
     
cond5_2011 = cond5_2011(cond5_2011_final); % Rows of Matrix for 2011 condition 5

% Condition 6:
cond6_2011 = find(strcmp(DataMatrix(:,1),'RTIS2011'));

cond6_2011_final = find(cell2mat(DataMatrix(cond6_2011,2))== 6);
     
cond6_2011 = cond6_2011(cond6_2011_final); % Rows of Matrix for 2011 condition 6

%% Participant Averages -Reaching + Trunk Distance - Normalized to Limb Length

% RTIS2001
Reaching_Dist_2001_1 = mean(cell2mat(DataMatrix(cond1_2001,5))); % Condition 1
Trunk_Dist_2001_1 = mean(cell2mat(DataMatrix(cond1_2001,9))); % Condition 1

Reaching_Dist_2001_2 = mean(cell2mat(DataMatrix(cond2_2001,5))); % Condition 2
Trunk_Dist_2001_2 = mean(cell2mat(DataMatrix(cond2_2001,9))); % Condition 2

Reaching_Dist_2001_3 = mean(cell2mat(DataMatrix(cond3_2001,5))); % Condition 3
Trunk_Dist_2001_3 = mean(cell2mat(DataMatrix(cond3_2001,9))); % Condition 3

Reaching_Dist_2001_4 = mean(cell2mat(DataMatrix(cond4_2001,5))); % Condition 4
Trunk_Dist_2001_4 = mean(cell2mat(DataMatrix(cond4_2001,9))); % Condition 4

Reaching_Dist_2001_5 = mean(cell2mat(DataMatrix(cond5_2001,5))); % Condition 5
Trunk_Dist_2001_5 = mean(cell2mat(DataMatrix(cond5_2001,9))); % Condition 5

Reaching_Dist_2001_6 = mean(cell2mat(DataMatrix(cond6_2001,5))); % Condition 6
Trunk_Dist_2001_6 = mean(cell2mat(DataMatrix(cond6_2001,9))); % Condition 6

% RTIS2002
Reaching_Dist_2002_1 = mean(cell2mat(DataMatrix(cond1_2002,5))); % Condition 1
Trunk_Dist_2002_1 = mean(cell2mat(DataMatrix(cond1_2002,9))); % Condition 1

Reaching_Dist_2002_2 = mean(cell2mat(DataMatrix(cond2_2002,5))); % Condition 2
Trunk_Dist_2002_2 = mean(cell2mat(DataMatrix(cond2_2002,9))); % Condition 2

Reaching_Dist_2002_3 = mean(cell2mat(DataMatrix(cond3_2002,5))); % Condition 3
Trunk_Dist_2002_3 = mean(cell2mat(DataMatrix(cond3_2002,9))); % Condition 3

Reaching_Dist_2002_4 = mean(cell2mat(DataMatrix(cond4_2002,5))); % Condition 4
Trunk_Dist_2002_4 = mean(cell2mat(DataMatrix(cond4_2002,9))); % Condition 4

Reaching_Dist_2002_5 = mean(cell2mat(DataMatrix(cond5_2002,5))); % Condition 5
Trunk_Dist_2002_5 = mean(cell2mat(DataMatrix(cond5_2002,9))); % Condition 5

Reaching_Dist_2002_6 = mean(cell2mat(DataMatrix(cond6_2002,5))); % Condition 6
Trunk_Dist_2002_6 = mean(cell2mat(DataMatrix(cond6_2002,9))); % Condition 6

% RTIS2003
Reaching_Dist_2003_1 = mean(cell2mat(DataMatrix(cond1_2003,5))); % Condition 1
Trunk_Dist_2003_1 = mean(cell2mat(DataMatrix(cond1_2003,9))); % Condition 1

Reaching_Dist_2003_2 = mean(cell2mat(DataMatrix(cond2_2003,5))); % Condition 2
Trunk_Dist_2003_2 = mean(cell2mat(DataMatrix(cond2_2003,9))); % Condition 2

Reaching_Dist_2003_3 = mean(cell2mat(DataMatrix(cond3_2003,5))); % Condition 3
Trunk_Dist_2003_3 = mean(cell2mat(DataMatrix(cond3_2003,9))); % Condition 3

Reaching_Dist_2003_4 = mean(cell2mat(DataMatrix(cond4_2003,5))); % Condition 4
Trunk_Dist_2003_4 = mean(cell2mat(DataMatrix(cond4_2003,9))); % Condition 4

Reaching_Dist_2003_5 = mean(cell2mat(DataMatrix(cond5_2003,5))); % Condition 5
Trunk_Dist_2003_5 = mean(cell2mat(DataMatrix(cond5_2003,9))); % Condition 5

Reaching_Dist_2003_6 = mean(cell2mat(DataMatrix(cond6_2003,5))); % Condition 6
Trunk_Dist_2003_6 = mean(cell2mat(DataMatrix(cond6_2003,9))); % Condition 6

% RTIS2006
Reaching_Dist_2006_1 = mean(cell2mat(DataMatrix(cond1_2006,5))); % Condition 1
Trunk_Dist_2006_1 = mean(cell2mat(DataMatrix(cond1_2006,9))); % Condition 1

Reaching_Dist_2006_2 = mean(cell2mat(DataMatrix(cond2_2006,5))); % Condition 2
Trunk_Dist_2006_2 = mean(cell2mat(DataMatrix(cond2_2006,9))); % Condition 2

Reaching_Dist_2006_3 = mean(cell2mat(DataMatrix(cond3_2006,5))); % Condition 3
Trunk_Dist_2006_3 = mean(cell2mat(DataMatrix(cond3_2006,9))); % Condition 3

Reaching_Dist_2006_4 = mean(cell2mat(DataMatrix(cond4_2006,5))); % Condition 4
Trunk_Dist_2006_4 = mean(cell2mat(DataMatrix(cond4_2006,9))); % Condition 4

Reaching_Dist_2006_5 = mean(cell2mat(DataMatrix(cond5_2006,5))); % Condition 5
Trunk_Dist_2006_5 = mean(cell2mat(DataMatrix(cond5_2006,9))); % Condition 5

Reaching_Dist_2006_6 = mean(cell2mat(DataMatrix(cond6_2006,5))); % Condition 6
Trunk_Dist_2006_6 = mean(cell2mat(DataMatrix(cond6_2006,9))); % Condition 6

% RTIS2007
Reaching_Dist_2007_1 = mean(cell2mat(DataMatrix(cond1_2007,5))); % Condition 1
Trunk_Dist_2007_1 = mean(cell2mat(DataMatrix(cond1_2007,9))); % Condition 1

Reaching_Dist_2007_2 = mean(cell2mat(DataMatrix(cond2_2007,5))); % Condition 2
Trunk_Dist_2007_2 = mean(cell2mat(DataMatrix(cond2_2007,9))); % Condition 2

Reaching_Dist_2007_3 = mean(cell2mat(DataMatrix(cond3_2007,5))); % Condition 3
Trunk_Dist_2007_3 = mean(cell2mat(DataMatrix(cond3_2007,9))); % Condition 3

Reaching_Dist_2007_4 = mean(cell2mat(DataMatrix(cond4_2007,5))); % Condition 4
Trunk_Dist_2007_4 = mean(cell2mat(DataMatrix(cond4_2007,9))); % Condition 4

Reaching_Dist_2007_5 = mean(cell2mat(DataMatrix(cond5_2007,5))); % Condition 5
Trunk_Dist_2007_5 = mean(cell2mat(DataMatrix(cond5_2007,9))); % Condition 5

Reaching_Dist_2007_6 = mean(cell2mat(DataMatrix(cond6_2007,5))); % Condition 6
Trunk_Dist_2007_6 = mean(cell2mat(DataMatrix(cond6_2007,9))); % Condition 6

% RTIS2008
Reaching_Dist_2008_1 = mean(cell2mat(DataMatrix(cond1_2008,5))); % Condition 1
Trunk_Dist_2008_1 = mean(cell2mat(DataMatrix(cond1_2008,9))); % Condition 1

Reaching_Dist_2008_2 = mean(cell2mat(DataMatrix(cond2_2008,5))); % Condition 2
Trunk_Dist_2008_2 = mean(cell2mat(DataMatrix(cond2_2008,9))); % Condition 2

Reaching_Dist_2008_3 = mean(cell2mat(DataMatrix(cond3_2008,5))); % Condition 3
Trunk_Dist_2008_3 = mean(cell2mat(DataMatrix(cond3_2008,9))); % Condition 3

Reaching_Dist_2008_4 = mean(cell2mat(DataMatrix(cond4_2008,5))); % Condition 4
Trunk_Dist_2008_4 = mean(cell2mat(DataMatrix(cond4_2008,9))); % Condition 4

Reaching_Dist_2008_5 = mean(cell2mat(DataMatrix(cond5_2008,5))); % Condition 5
Trunk_Dist_2008_5 = mean(cell2mat(DataMatrix(cond5_2008,9))); % Condition 5

Reaching_Dist_2008_6 = mean(cell2mat(DataMatrix(cond6_2008,5))); % Condition 6
Trunk_Dist_2008_6 = mean(cell2mat(DataMatrix(cond6_2008,9))); % Condition 6

% RTIS2009
Reaching_Dist_2009_1 = mean(cell2mat(DataMatrix(cond1_2009,5))); % Condition 1
Trunk_Dist_2009_1 = mean(cell2mat(DataMatrix(cond1_2009,9))); % Condition 1

Reaching_Dist_2009_2 = mean(cell2mat(DataMatrix(cond2_2009,5))); % Condition 2
Trunk_Dist_2009_2 = mean(cell2mat(DataMatrix(cond2_2009,9))); % Condition 2

Reaching_Dist_2009_3 = mean(cell2mat(DataMatrix(cond3_2009,5))); % Condition 3
Trunk_Dist_2009_3 = mean(cell2mat(DataMatrix(cond3_2009,9))); % Condition 3

Reaching_Dist_2009_4 = mean(cell2mat(DataMatrix(cond4_2009,5))); % Condition 4
Trunk_Dist_2009_4 = mean(cell2mat(DataMatrix(cond4_2009,9))); % Condition 4

Reaching_Dist_2009_5 = mean(cell2mat(DataMatrix(cond5_2009,5))); % Condition 5
Trunk_Dist_2009_5 = mean(cell2mat(DataMatrix(cond5_2009,9))); % Condition 5

Reaching_Dist_2009_6 = mean(cell2mat(DataMatrix(cond6_2009,5))); % Condition 6
Trunk_Dist_2009_6 = mean(cell2mat(DataMatrix(cond6_2009,9))); % Condition 6

% RTIS2010
Reaching_Dist_2010_1 = mean(cell2mat(DataMatrix(cond1_2010,5))); % Condition 1
Trunk_Dist_2010_1 = mean(cell2mat(DataMatrix(cond1_2010,9))); % Condition 1

Reaching_Dist_2010_2 = mean(cell2mat(DataMatrix(cond2_2010,5))); % Condition 2
Trunk_Dist_2010_2 = mean(cell2mat(DataMatrix(cond2_2010,9))); % Condition 2

Reaching_Dist_2010_3 = mean(cell2mat(DataMatrix(cond3_2010,5))); % Condition 3
Trunk_Dist_2010_3 = mean(cell2mat(DataMatrix(cond3_2010,9))); % Condition 3

Reaching_Dist_2010_4 = mean(cell2mat(DataMatrix(cond4_2010,5))); % Condition 4
Trunk_Dist_2010_4 = mean(cell2mat(DataMatrix(cond4_2010,9))); % Condition 4

Reaching_Dist_2010_5 = mean(cell2mat(DataMatrix(cond5_2010,5))); % Condition 5
Trunk_Dist_2010_5 = mean(cell2mat(DataMatrix(cond5_2010,9))); % Condition 5

Reaching_Dist_2010_6 = mean(cell2mat(DataMatrix(cond6_2010,5))); % Condition 6
Trunk_Dist_2010_6 = mean(cell2mat(DataMatrix(cond6_2010,9))); % Condition 6

% RTIS2011
Reaching_Dist_2011_1 = mean(cell2mat(DataMatrix(cond1_2011,5))); % Condition 1
Trunk_Dist_2011_1 = mean(cell2mat(DataMatrix(cond1_2011,9))); % Condition 1

Reaching_Dist_2011_2 = mean(cell2mat(DataMatrix(cond2_2011,5))); % Condition 2
Trunk_Dist_2011_2 = mean(cell2mat(DataMatrix(cond2_2011,9))); % Condition 2

Reaching_Dist_2011_3 = mean(cell2mat(DataMatrix(cond3_2011,5))); % Condition 3
Trunk_Dist_2011_3 = mean(cell2mat(DataMatrix(cond3_2011,9))); % Condition 3

Reaching_Dist_2011_4 = mean(cell2mat(DataMatrix(cond4_2011,5))); % Condition 4
Trunk_Dist_2011_4 = mean(cell2mat(DataMatrix(cond4_2011,9))); % Condition 4

Reaching_Dist_2011_5 = mean(cell2mat(DataMatrix(cond5_2011,5))); % Condition 5
Trunk_Dist_2011_5 = mean(cell2mat(DataMatrix(cond5_2011,9))); % Condition 5

Reaching_Dist_2011_6 = mean(cell2mat(DataMatrix(cond6_2011,5))); % Condition 6
Trunk_Dist_2011_6 = mean(cell2mat(DataMatrix(cond6_2011,9))); % Condition 6
%% Group Means and Standard Error for Reaching Distance - Don't run if doing Trunk Displacement

%Condition 1 Average RD and Standard Error
RD_Cond1 = mean([Reaching_Dist_2001_1 Reaching_Dist_2002_1 Reaching_Dist_2003_1 Reaching_Dist_2006_1 Reaching_Dist_2007_1 Reaching_Dist_2008_1 Reaching_Dist_2009_1 Reaching_Dist_2010_1 Reaching_Dist_2011_1]);
Individ_Means_1 = [Reaching_Dist_2001_1 Reaching_Dist_2002_1 Reaching_Dist_2003_1 Reaching_Dist_2006_1 Reaching_Dist_2007_1 Reaching_Dist_2008_1 Reaching_Dist_2009_1 Reaching_Dist_2010_1 Reaching_Dist_2011_1];
SE_Cond1 = std([Reaching_Dist_2001_1 Reaching_Dist_2002_1 Reaching_Dist_2003_1 Reaching_Dist_2006_1 Reaching_Dist_2007_1 Reaching_Dist_2008_1 Reaching_Dist_2009_1 Reaching_Dist_2010_1 Reaching_Dist_2011_1])/2;
%Condition 2 Average RD and Standard Error
RD_Cond2 = mean([Reaching_Dist_2001_2 Reaching_Dist_2002_2 Reaching_Dist_2003_2 Reaching_Dist_2006_2 Reaching_Dist_2007_2 Reaching_Dist_2008_2 Reaching_Dist_2009_2 Reaching_Dist_2010_2 Reaching_Dist_2011_2]);
Individ_Means_2 =[Reaching_Dist_2001_2 Reaching_Dist_2002_2 Reaching_Dist_2003_2 Reaching_Dist_2006_2 Reaching_Dist_2007_2 Reaching_Dist_2008_2 Reaching_Dist_2009_2 Reaching_Dist_2010_2 Reaching_Dist_2011_2];
SE_Cond2 = std([Reaching_Dist_2001_2 Reaching_Dist_2002_2 Reaching_Dist_2003_2 Reaching_Dist_2006_2 Reaching_Dist_2007_2 Reaching_Dist_2008_2 Reaching_Dist_2009_2 Reaching_Dist_2010_2 Reaching_Dist_2011_2])/2;
%Condition 3 Average RD and Standard Error
RD_Cond3 = mean([Reaching_Dist_2001_3 Reaching_Dist_2002_3 Reaching_Dist_2003_3 Reaching_Dist_2006_3 Reaching_Dist_2007_3 Reaching_Dist_2008_3 Reaching_Dist_2009_3 Reaching_Dist_2010_3 Reaching_Dist_2011_3]);
Individ_Means_3 =[Reaching_Dist_2001_3 Reaching_Dist_2002_3 Reaching_Dist_2003_3 Reaching_Dist_2006_3 Reaching_Dist_2007_3 Reaching_Dist_2008_3 Reaching_Dist_2009_3 Reaching_Dist_2010_3 Reaching_Dist_2011_3];
SE_Cond3 = std([Reaching_Dist_2001_3 Reaching_Dist_2002_3 Reaching_Dist_2003_3 Reaching_Dist_2006_3 Reaching_Dist_2007_3 Reaching_Dist_2008_3 Reaching_Dist_2009_3 Reaching_Dist_2010_3 Reaching_Dist_2011_3])/2;
%Condition 4 Average RD and Standard Error
RD_Cond4 = mean([Reaching_Dist_2001_4 Reaching_Dist_2002_4 Reaching_Dist_2003_4 Reaching_Dist_2006_4 Reaching_Dist_2007_4 Reaching_Dist_2008_4 Reaching_Dist_2009_4 Reaching_Dist_2010_4 Reaching_Dist_2011_4]);
Individ_Means_4 =[Reaching_Dist_2001_4 Reaching_Dist_2002_4 Reaching_Dist_2003_4 Reaching_Dist_2006_4 Reaching_Dist_2007_4 Reaching_Dist_2008_4 Reaching_Dist_2009_4 Reaching_Dist_2010_4 Reaching_Dist_2011_4];
SE_Cond4 = std([Reaching_Dist_2001_4 Reaching_Dist_2002_4 Reaching_Dist_2003_4 Reaching_Dist_2006_4 Reaching_Dist_2007_4 Reaching_Dist_2008_4 Reaching_Dist_2009_4 Reaching_Dist_2010_4 Reaching_Dist_2011_4])/2;
%Condition 5 Average RD and Standard Error
RD_Cond5 = mean([Reaching_Dist_2001_5 Reaching_Dist_2002_5 Reaching_Dist_2003_5 Reaching_Dist_2006_5 Reaching_Dist_2007_5 Reaching_Dist_2008_5 Reaching_Dist_2009_5 Reaching_Dist_2010_5 Reaching_Dist_2011_5]);
Individ_Means_5 = [Reaching_Dist_2001_5 Reaching_Dist_2002_5 Reaching_Dist_2003_5 Reaching_Dist_2006_5 Reaching_Dist_2007_5 Reaching_Dist_2008_5 Reaching_Dist_2009_5 Reaching_Dist_2010_5 Reaching_Dist_2011_5];
SE_Cond5 = std([Reaching_Dist_2001_5 Reaching_Dist_2002_5 Reaching_Dist_2003_5 Reaching_Dist_2006_5 Reaching_Dist_2007_5 Reaching_Dist_2008_5 Reaching_Dist_2009_5 Reaching_Dist_2010_5 Reaching_Dist_2011_5])/2;
%Condition 6 Average RD and Standard Error
RD_Cond6 = mean([Reaching_Dist_2001_6 Reaching_Dist_2002_6 Reaching_Dist_2003_6 Reaching_Dist_2006_6 Reaching_Dist_2007_6 Reaching_Dist_2008_6 Reaching_Dist_2009_6 Reaching_Dist_2010_6 Reaching_Dist_2011_6]);
Individ_Means_6 = [Reaching_Dist_2001_6 Reaching_Dist_2002_6 Reaching_Dist_2003_6 Reaching_Dist_2006_6 Reaching_Dist_2007_6 Reaching_Dist_2008_6 Reaching_Dist_2009_6 Reaching_Dist_2010_6 Reaching_Dist_2011_6];
SE_Cond6 = std([Reaching_Dist_2001_6 Reaching_Dist_2002_6 Reaching_Dist_2003_6 Reaching_Dist_2006_6 Reaching_Dist_2007_6 Reaching_Dist_2008_6 Reaching_Dist_2009_6 Reaching_Dist_2010_6 Reaching_Dist_2011_6])/2;

%% Group Means and Standard Error for Trunk Distance

%Condition 1 Average TD and Standard Error
TD_Cond1 = mean([Trunk_Dist_2001_1 Trunk_Dist_2002_1 Trunk_Dist_2003_1 Trunk_Dist_2006_1 Trunk_Dist_2007_1 Trunk_Dist_2008_1 Trunk_Dist_2009_1 Trunk_Dist_2010_1 Trunk_Dist_2011_1]);
Individ_Means_1 = [Trunk_Dist_2001_1 Trunk_Dist_2002_1 Trunk_Dist_2003_1 Trunk_Dist_2006_1 Trunk_Dist_2007_1 Trunk_Dist_2008_1 Trunk_Dist_2009_1 Trunk_Dist_2010_1 Trunk_Dist_2011_1];
SE_Cond1 = std([Trunk_Dist_2001_1 Trunk_Dist_2002_1 Trunk_Dist_2003_1 Trunk_Dist_2006_1 Trunk_Dist_2007_1 Trunk_Dist_2008_1 Trunk_Dist_2009_1 Trunk_Dist_2010_1 Trunk_Dist_2011_1])/2;
%Condition 2 Average TD and Standard Error
TD_Cond2 = mean([Trunk_Dist_2001_2 Trunk_Dist_2002_2 Trunk_Dist_2003_2 Trunk_Dist_2006_2 Trunk_Dist_2007_2 Trunk_Dist_2008_2 Trunk_Dist_2009_2 Trunk_Dist_2010_2 Trunk_Dist_2011_2]);
Individ_Means_2 =[Trunk_Dist_2001_2 Trunk_Dist_2002_2 Trunk_Dist_2003_2 Trunk_Dist_2006_2 Trunk_Dist_2007_2 Trunk_Dist_2008_2 Trunk_Dist_2009_2 Trunk_Dist_2010_2 Trunk_Dist_2011_2];
SE_Cond2 = std([Trunk_Dist_2001_2 Trunk_Dist_2002_2 Trunk_Dist_2003_2 Trunk_Dist_2006_2 Trunk_Dist_2007_2 Trunk_Dist_2008_2 Trunk_Dist_2009_2 Trunk_Dist_2010_2 Trunk_Dist_2011_2])/2;
%Condition 3 Average TD and Standard Error
TD_Cond3 = mean([Trunk_Dist_2001_3 Trunk_Dist_2002_3 Trunk_Dist_2003_3 Trunk_Dist_2006_3 Trunk_Dist_2007_3 Trunk_Dist_2008_3 Trunk_Dist_2009_3 Trunk_Dist_2010_3 Trunk_Dist_2011_3]);
Individ_Means_3 =[Trunk_Dist_2001_3 Trunk_Dist_2002_3 Trunk_Dist_2003_3 Trunk_Dist_2006_3 Trunk_Dist_2007_3 Trunk_Dist_2008_3 Trunk_Dist_2009_3 Trunk_Dist_2010_3 Trunk_Dist_2011_3];
SE_Cond3 = std([Trunk_Dist_2001_3 Trunk_Dist_2002_3 Trunk_Dist_2003_3 Trunk_Dist_2006_3 Trunk_Dist_2007_3 Trunk_Dist_2008_3 Trunk_Dist_2009_3 Trunk_Dist_2010_3 Trunk_Dist_2011_3])/2;
%Condition 4 Average TD and Standard Error
TD_Cond4 = mean([Trunk_Dist_2001_4 Trunk_Dist_2002_4 Trunk_Dist_2003_4 Trunk_Dist_2006_4 Trunk_Dist_2007_4 Trunk_Dist_2008_4 Trunk_Dist_2009_4 Trunk_Dist_2010_4 Trunk_Dist_2011_4]);
Individ_Means_4 =[Trunk_Dist_2001_4 Trunk_Dist_2002_4 Trunk_Dist_2003_4 Trunk_Dist_2006_4 Trunk_Dist_2007_4 Trunk_Dist_2008_4 Trunk_Dist_2009_4 Trunk_Dist_2010_4 Trunk_Dist_2011_4];
SE_Cond4 = std([Trunk_Dist_2001_4 Trunk_Dist_2002_4 Trunk_Dist_2003_4 Trunk_Dist_2006_4 Trunk_Dist_2007_4 Trunk_Dist_2008_4 Trunk_Dist_2009_4 Trunk_Dist_2010_4 Trunk_Dist_2011_4])/2;
%Condition 5 Average TD and Standard Error
TD_Cond5 = mean([Trunk_Dist_2001_5 Trunk_Dist_2002_5 Trunk_Dist_2003_5 Trunk_Dist_2006_5 Trunk_Dist_2007_5 Trunk_Dist_2008_5 Trunk_Dist_2009_5 Trunk_Dist_2010_5 Trunk_Dist_2011_5]);
Individ_Means_5 = [Trunk_Dist_2001_5 Trunk_Dist_2002_5 Trunk_Dist_2003_5 Trunk_Dist_2006_5 Trunk_Dist_2007_5 Trunk_Dist_2008_5 Trunk_Dist_2009_5 Trunk_Dist_2010_5 Trunk_Dist_2011_5];
SE_Cond5 = std([Trunk_Dist_2001_5 Trunk_Dist_2002_5 Trunk_Dist_2003_5 Trunk_Dist_2006_5 Trunk_Dist_2007_5 Trunk_Dist_2008_5 Trunk_Dist_2009_5 Trunk_Dist_2010_5 Trunk_Dist_2011_5])/2;
%Condition 6 Average TD and Standard Error
TD_Cond6 = mean([Trunk_Dist_2001_6 Trunk_Dist_2002_6 Trunk_Dist_2003_6 Trunk_Dist_2006_6 Trunk_Dist_2007_6 Trunk_Dist_2008_6 Trunk_Dist_2009_6 Trunk_Dist_2010_6 Trunk_Dist_2011_6]);
Individ_Means_6 = [Trunk_Dist_2001_6 Trunk_Dist_2002_6 Trunk_Dist_2003_6 Trunk_Dist_2006_6 Trunk_Dist_2007_6 Trunk_Dist_2008_6 Trunk_Dist_2009_6 Trunk_Dist_2010_6 Trunk_Dist_2011_6];
SE_Cond6 = std([Trunk_Dist_2001_6 Trunk_Dist_2002_6 Trunk_Dist_2003_6 Trunk_Dist_2006_6 Trunk_Dist_2007_6 Trunk_Dist_2008_6 Trunk_Dist_2009_6 Trunk_Dist_2010_6 Trunk_Dist_2011_6])/2;




%% Stroke Paretic - HARD CODED NUMBERS
% 
% %% Cumulative Group data
% % RD
% 
% %R Table
% RTRD_total = [RTRD_01 RTRD_02 RTRD_03 RTRD_06 RTRD_07 RTRD_08 RTRD_09 RTRD_10 RTRD_11];
% RTRD_total_mean = mean(RTRD_total);
% RTRD_total_err = std(RTRD_total);
% RTRD_total_SE = std(RTRD_total)/3
% 
% %R25
% R25RD_total = [R25RD_01 R25RD_02 R25RD_03 R25RD_06 R25RD_07 R25RD_08 R25RD_09 R25RD_10 R25RD_11];
% R25RD_total_mean = mean(R25RD_total);
% R25RD_total_err = std(R25RD_total);
% R25RD_total_SE = std(R25RD_total)/3
% 
% % R50
% R50RD_total = [R50RD_01 R50RD_02 R50RD_03 R50RD_06 R50RD_07 R50RD_08 R50RD_09 R50RD_10 R50RD_11];
% R50RD_total_mean = mean(R50RD_total);
% R50RD_total_err = std(R50RD_total);
% R50RD_total_SE = std(R50RD_total)/3
% 
% %UT
% UTRD_total = [UTRD_01 UTRD_02 UTRD_03 UTRD_06 UTRD_07 UTRD_08 UTRD_09 UTRD_10 UTRD_11];
% UTRD_total_mean = mean(UTRD_total);
% UTRD_total_err = std(UTRD_total);
% UTRD_total_SE = std(UTRD_total)/3
% %U25
% U25RD_total = [U25RD_01 U25RD_02 U25RD_03 U25RD_06 U25RD_07 U25RD_08 U25RD_09 U25RD_10 U25RD_11];
% U25RD_total_mean = mean(U25RD_total);
% U25RD_total_err = std(U25RD_total);
% U25RD_total_SE = std(U25RD_total)/3
% 
% %U50
% U50RD_total = [U50RD_01 U50RD_02 U50RD_03 U50RD_06 U50RD_07 U50RD_08 U50RD_09 U50RD_10 U50RD_11];
% U50RD_total_mean = mean(U50RD_total);
% U50RD_total_err = std(U50RD_total);
% U50RD_total_SE = std(U50RD_total)/3
% %% Trunk Displacement
% 
% 
% %RT
% RTTD_total = [RTTD_01 RTTD_02 RTTD_03 RTTD_06 RTTD_07 RTTD_08 RTTD_09 RTTD_10 RTTD_11];
% RTTD_total_mean   = mean(RTTD_total);
% RTTD_total_SE = std(RTTD_total)/sqrt(9) %  Standard Error: Where N is 9 for 9 participants so 3... 
% 
% 
% %R25
% R25TD_total = [R25TD_01 R25TD_02 R25TD_03 R25TD_06 R25TD_07 R25TD_08 R25TD_09 R25TD_10 R25TD_11];
% R25TD_total_mean = mean(R25TD_total);
% % R25TD_total_err = std(R25TD_total);
% R25TD_total_SE = std(R25TD_total)/3
% 
% %R50
% R50TD_total= [R50TD_01 R50TD_02 R50TD_03 R50TD_06 R50TD_07 R50TD_08 R50TD_09 R50TD_10 R50TD_10];
% R50TD_total_mean = mean(R50TD_total);
% % R50TD_total_err = std(R50TD_total);
% R50TD_total_SE = std(R50TD_total)/3
% 
% %UT
% UTTD_total= [UTTD_01 UTTD_02 UTTD_03 UTTD_06 UTTD_07 UTTD_08 UTTD_01 UTTD_09 UTTD_01 UTTD_10 UTTD_11];
% UTTD_total_mean = mean(UTTD_total);
% % UTTD_total_err = std(UTTD_total);
% UTTD_total_SE = std(UTTD_total)/3
% 
% %U25
% U25TD_total= [U25TD_01 U25TD_02 U25TD_03 U25TD_06 U25TD_07 U25TD_08 U25TD_09 U25TD_10 U25TD_11];
% U25TD_total_mean = mean(U25TD_total);
% % U25TD_total_err = std(U25TD_total); 
% U25TD_total_SE = std(U25TD_total)/3
% %U50
% U50TD_total= [U50TD_01 U50TD_02 U50TD_03 U50TD_06 U50TD_07 U50TD_08 U50TD_09 U50TD_10 U50TD_11];
% U50TD_total_mean = mean(U50TD_total);
% % U50TD_total_err = std(U50TD_total);
% U50TD_total_SE  =  std(U50TD_total)/3
% 
% 
% %% T_Angle
% 
% %RT
% RTANG_total = [RTANG_01 RTANG_02 RTANG_03 RTANG_06 RTANG_07 RTANG_08 RTANG_09 RTANG_10 RTANG_11];
% RTANG_total_mean= mean(RTANG_total);
% RTANG_total_err = std(RTANG_total);
% RTANG_total_SE =std(RTANG_total)/3
% %R25
% R25ANG_total = [R25ANG_01 R25ANG_02 R25ANG_03 R25ANG_06 R25ANG_07 R25ANG_08 R25ANG_09 R25ANG_10 R25ANG_11];
% R25ANG_total_mean = mean(R25ANG_total);
% R25ANG_total_err = std(R25ANG_total);
% R25ANG_total_SE = std(R25ANG_total)/3
% %R50
% R50ANG_total = [R50ANG_01 R50ANG_02 R50ANG_03 R50ANG_06 R50ANG_07 R50ANG_08 R50ANG_09 R50ANG_10 R50ANG_11];
% R50ANG_total_mean = mean(R50ANG_total);
% R50ANG_total_err = std(R50ANG_total);
% R50ANG_total_SE = std(R50ANG_total)/3
% %UT
% UTANG_total = [UTANG_01  UTANG_02 UTANG_03 UTANG_06 UTANG_07 UTANG_08 UTANG_09 UTANG_02 UTANG_10 UTANG_11];
% UTANG_total_mean = mean(UTANG_total);
% UTANG_total_err = std(UTANG_total);
% UTANG_total_SE = std(UTANG_total)/3
% %U25
% U25ANG_total = [U25ANG_01 U25ANG_02 U25ANG_03 U25ANG_06 U25ANG_07 U25ANG_08 U25ANG_09 U25ANG_10 U25ANG_11];
% U25ANG_total_mean = mean(U25ANG_total);
% U25ANG_total_err  = std(U25ANG_total);
% U25ANG_total_SE = std(U25ANG_total)/3
% %U50
% U50ANG_total = [U50ANG_01 U50ANG_02 U50ANG_03 U50ANG_06 U50ANG_07 U50ANG_08 U50ANG_09 U50ANG_10 U50ANG_11];
% U50ANG_total_mean = mean(U50ANG_total);
% U50ANG_total_err = std(U50ANG_total);
% U50ANG_total_SE = std(U50ANG_total)/3
% %% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% RTIS2001
% 
% % RD
% % RTRD_01 = 95.26; % Old MEAN
% RTRD_01 = 93.77;
% %  errRT = 1.57;
% 
% UTRD_01 = 89.65;
% % errUT = 2.79;
% 
% R25RD_01= 74.45;
% % errR25 = 1.38;
% 
% U25RD_01=67.18;
% % errU25= 2.55;
% 
% R50RD_01=72.78;
% % errR50 =1.38;
% 
% U50RD_01 = 66.89;
% % errU50 = 2.39;
% %% TD
% RTTD_01 = 2.62;
% % errRT = 1.14;
% 
% R25TD_01= 2.76;
% % errR25 =1.14;
% 
% R50TD_01=2.69;
% % errR50 =.78;
% 
% 
% UTTD_01 = 4.59;
% % errUT = 2.28;
% 
% 
% U25TD_01= 6.22;
% % errU25= 1.55;
% 
% 
% U50TD_01 = 6.94;
% % errU50 = 1.42;
% 
% %% Trunk Angle
% RTANG_01 = -1.04;
% % errRT_01 = 2.08;
% 
% R25ANG_01= 4.17;
% % errR25 = 2.00;
% 
% R50ANG_01=4.39;
% % errR50_01 =1.76;
% 
% 
% UTANG_01 = -.60;
% % errUT_01 = 3.53;
% 
% 
% U25ANG_01= 6.61;
% % errU25_01= 1.66;
% 
% 
% U50ANG_01 = 7.09;
% % errU50_01 = 1.48;
% 
% 
% %%
% % RTIS2002
% 
% RTRD_02 = 72.55;
% % errRT = 2.24;
% 
% R25RD_02 = 66.55;
% % errR25_02 = 1.13;
% 
% R50RD_02 = 65.56;
% % errR50 = 1.18;
% 
% UTRD_02 = 77.90;
% % errUT = 1.20;
% 
% U25RD_02 = 64.02;
% % errU25 = 1.82;
% 
% U50RD_02 = 65.24;
% % errU50 = 1.49;
% 
% %% TD
% 
% RTTD_02 = 1.28;
% % errRT = .48;
% 
% R25TD_02= .79;
% % errR25 =.41;
% 
% R50TD_02= .68;
% % errR50 = .40;
% 
% 
% UTTD_02 = 4.60;
% % errUT =1.57;
% 
% 
% U25TD_02= 3.39;
% % errU25= .95;
% 
% 
% U50TD_02 = 2.07;
% % errU50 = .88;
% 
% %% Trunk Angle
% 
% RTANG_02 =2.72;
% %errRT = 1.00;
% 
% R25ANG_02= .32;
% %errR25 = .51;
% 
% R50ANG_02=.51;
% %errR50 =.32;
% 
% 
% UTANG_02 = -4.80;
% %errUT =1.76;
% 
% 
% U25ANG_02= -.70;
% %errU25= 1.08;
% 
% 
% U50ANG_02 =.61;
% %errU50 = .33;
% %% RTIS 2003
% 
% RTRD_03 = 94.35;
% errRT = 2.57;
% 
% R25RD_03 = 90.92;
% errR25 =1.09;
% 
% R50RD_03 =92.00 ;
% errR50  =2.65;
% 
% UTRD_03 = 87.13;
% errUT= 2.87;
% 
% U25RD_03 = 89.02 ;
% errU25= 1.56;
% 
% U50RD_03 =87.54 ;
% errU50 = 2.32;
% 
% %% TD
% RTTD_03 = 2.88;
% errRT = .53;
% 
% R25TD_03= 2.41;
% errR25 = .82;
% 
% R50TD_03= 3.11;
% errR50 = .72; 
% 
% 
% UTTD_03 = 1.35;
% errUT = .76;
% 
% 
% U25TD_03= 3.77;
% errU25= 2.04;
% 
% 
% U50TD_03 = 3.46;
% errU50 = 1.90;
% 
% %% Trunk Angle
% 
% RTANG_03 =3.34;
% errRT = 2.11;
% 
% R25ANG_03=6.85;
% errR25 = 1.43;
% 
% R50ANG_03=6.65;
% errR50 =1.09;
% 
% 
% UTANG_03 = .26;
% errUT =.98;
% 
% 
% U25ANG_03= 4.07;
% errU25= 2.02;
% 
% 
% U50ANG_03 =2.84;
% errU50 = 2.71;
% %% RTIS2006 
% 
% RTRD_06 = 78.06;
% errRT =1.41;
% 
% R25RD_06 = 74.93;
% errR25 =1.32;
% 
% R50RD_06 = 73.77;
% errR50 = 2.55;
% 
% UTRD_06 = 79.59;
% errUT=1.05;
% 
% U25RD_06 = 71.14 ;
% errU25=.86;
% 
% U50RD_06 = 71.59;
% errU50=1.52;
% %% TD
% 
% RTTD_06 = 2.05;
% errRT = 1.08;
% 
% R25TD_06= 1.35;
% errR25 = .36;
% 
% R50TD_06= .84;
% errR50 = .27;
% 
% 
% UTTD_06 = 4.93;
% errUT = 1.71;
% 
% 
% U25TD_06= 4.31;
% errU25= 1.41;
% 
% 
% U50TD_06 = 3.28;
% errU50 = .78;
% 
% %% Trunk Angle
% 
% RTANG_06 = 3.43;
% errRT = .67;
% 
% R25ANG_06=.87;
% errR25 =1.29;
% 
% R50ANG_06=.99;
% errR50 =.46;
% 
% 
% UTANG_06 = -1.90;
% errUT =.91;
% 
% 
% U25ANG_06= 1.11;
% errU25=1.15;
% 
% 
% U50ANG_06 =.92;
% errU50 = .58;
% %% RTIS2007
% RTRD_07 = 82.71;
% errRT=1.02;
% 
% R25RD_07 = 65.93 ;
% errR25 = 1.88;
% 
% R50RD_07 = 65.82;
% errR50 = 1.00;
% 
% UTRD_07 = 82.85;
% errUT = 1.21;
% 
% U25RD_07 = 67.68 ;
% errU25= 2.79;
% 
% U50RD_07 =65.21 ;
% errU50 =1.57;
% %% TD
% 
% RTTD_07 = 2.50;
% errRT = 1.09;
% 
% R25TD_07=.36;
% errR25 = .17;
% 
% R50TD_07= .58;
% errR50 = .32;
% 
% 
% UTTD_07 = 2.76;
% errUT = 1.13;
% 
% 
% U25TD_07= 2.92;
% errU25= 1.93;
% 
% 
% U50TD_07 = 2.32;
% errU50 = 2.49;
% 
% %% Trunk Angle
% 
% RTANG_07 = -.67;
% errRT = 1.08;
% 
% R25ANG_07= -.44;
% errR25 = .81;
% 
% R50ANG_07=-.83;
% errR50 = 1.72;
% 
% 
% UTANG_07 = -1.90;
% errUT =.97;
% 
% 
% U25ANG_07= -.78;
% errU25=1.25;
% 
% 
% U50ANG_07 =2.02;
% errU50 = 1.51;
% %% RTIS2008
% 
% RTRD_08 =99.20;
% errRT = 1.95;
% 
% R25RD_08 = 99.30 ;
% errR25= 1.05;
% 
% R50RD_08 = 99.52;
% errR50 = 1.92;
% 
% UTRD_08 = 95.45;
% errUT = 2.20;
% 
% U25RD_08 = 93.56 ;
% errU25=2.23;
% 
% U50RD_08 =94.19 ;
% errU50= 2.10;
% 
% %%
% %% TD
% 
% RTTD_08 = .83;
% errRT = .71;
% 
% R25TD_08=2.56;
% errR25 = .67;
% 
% R50TD_08= 2.05;
% errR50 = .56;
% 
% 
% UTTD_08 = 3.87;
% errUT = 2.32;
% 
% 
% U25TD_08= 4.86;
% errU25= 1.92;
% 
% 
% U50TD_08 = 4.62;
% errU50 = 1.49;
% %% Trunk Angle
% 
% RTANG_08 = -1.53;
% errRT = 1.01;
% 
% R25ANG_08=-1.53;
% errR25 =.33;
% 
% R50ANG_08=-.97;
% errR50 = .85;
% 
% 
% UTANG_08 = -4.31;
% errUT =2.85;
% 
% 
% U25ANG_08= -3.85;
% errU25=1.78;
% 
% 
% U50ANG_08 =-4.63;
% errU50 = 2.03;
% %% RTIS2009
% RTRD_09 =82.89;
% errRT =1.14;
% 
% R25RD_09 = 78.28 ;
% errR25 =.98;
% 
% R50RD_09 = 78.36 ;
% errR50 = 1.47;
% 
% UTRD_09 = 79.49;
% errUT =1.11;
% 
% U25RD_09 = 74.81 ;
% errU25= 2.45;
% 
% U50RD_09 = 75.19 ;
% errU50=1.02;
% %% TD
% 
% RTTD_09 =1.62;
% errRT = .26;
% 
% R25TD_09=.95;
% errR25 = .28;
% 
% R50TD_09= 1.20;
% errR50 = .71;
% 
% 
% UTTD_09 = 2.58;
% errUT = 1.27;
% 
% 
% U25TD_09= 3.21;
% errU25= 2.00;
% 
% 
% U50TD_09 = 2.95;
% errU50 =1.38;
% %% Trunk Angle
% 
% RTANG_09 = 2.11;
% errRT = 1.34;
% 
% R25ANG_09=.13;
% errR25 =.43;
% 
% R50ANG_09=-.58;
% errR50 =1.00;
% 
% 
% UTANG_09 = -.67;
% errUT =1.20;
% 
% 
% U25ANG_09= .95;
% errU25=1.61;
% 
% 
% U50ANG_09 =1.55;
% errU50 = 1.07;
% 
% %% RTIS2010
% RTRD_10 =103.83;
% errRT = .49;
% 
% R25RD_10 =  95.40;
% errR25=1.28;
% 
% R50RD_10 = 93.51;
% errR50 = 1.40;
% 
% UTRD_10 =103.89;
% errUT = .36;
% 
% U25RD_10 =  89.90;
% errU25= 5.65;
% 
% U50RD_10  =  91.48;
% errU50 = .81;
% %% TD
% 
% RTTD_10  =1.01;
% errRT = .19;
% 
% R25TD_10 =.84;
% errR25 = .21;
% 
% R50TD_10 = .50;
% errR50 = .31;
% 
% 
% UTTD_10  = .81;
% errUT = .46;
% 
% 
% U25TD_10 = 2.32;
% errU25= .87;
% 
% 
% U50TD_10  = 1.58;
% errU50  =.56;
% 
% %% Trunk Angle
% 
% RTANG_10  = -.46;
% errRT = .32;
% 
% R25ANG_10 =.55;
% errR25 =.24;
% 
% R50ANG_10=.63;
% errR50 =.33;
% 
% 
% UTANG_10 = -.52;
% errUT = .77;
% 
% 
% U25ANG_10= -.34;
% errU25=.99;
% 
% 
% U50ANG_10=-.24;
% errU50 = .85;
% %% RTIS2011
% 
% RTRD_11 =57.19;
% errRT= 1.32;
% 
% R25RD_11 = 50.17 ;
% errR25 = 1.44;
% 
% R50RD_11 =45.39;
% errR50 = .98;
% 
% UTRD_11 =53.41;
% errUT = 1.79;
% 
% U25RD_11 = 43.57 ;
% errU25= .52;
% 
% U50RD_11 =  42.81;
% errU50 = 1.44;
% 
% %% TD
% 
% RTTD_11 =.21;
% errRT = .16;
% 
% R25TD_11= .28;
% errR25 = .23;
% 
% R50TD_11= .26;
% errR50 = .16;
% 
% 
% UTTD_11 = 1.22;
% errUT = .51;
% 
% 
% U25TD_11= .84;
% errU25= .66;
% 
% 
% U50TD_11 = .84;
% errU50 =.52;
% 
% %% Trunk Angle
% 
% RTANG_11 = .09;
% errRT = .74;
% 
% R25ANG_11=-.23;
% errR25 =.27;
% 
% R50ANG_11=.09;
% errR50 =.31;
% 
% 
% UTANG_11 = -.1;
% errUT =.54;
% 
% 
% U25ANG_11= -2.10;
% errU25= 1.54;
% 
% 
% U50ANG_11 = -.83;
% errU50 = 1.13;

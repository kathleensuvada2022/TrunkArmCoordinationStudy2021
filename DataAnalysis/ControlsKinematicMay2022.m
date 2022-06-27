%% K. Suvada- June 2022 -Updated
% Kacey Updated so now just data- call function 'BarPlotandErr' with these
% variables

%% Controls
% June 2022
% Want to Organize Data by condition (1-6) so that have all trials in given
% condition for all participants. Load in Data matrix: 


%% RTIS1003
% Condition 1:
cond1_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond1_1003_final = find(cell2mat(DataMatrix(cond1_1003,2))== 1);
     
cond1_1003 = cond1_1003(cond1_1003_final); % Rows of Matrix for 1003 condition 1

% Condition 2:
cond2_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond2_1003_final = find(cell2mat(DataMatrix(cond2_1003,2))== 2);
     
cond2_1003 = cond2_1003(cond2_1003_final); % Rows of Matrix for 1003 condition 2

% Condition 3:
cond3_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond3_1003_final = find(cell2mat(DataMatrix(cond3_1003,2))== 3);
     
cond3_1003 = cond3_1003(cond3_1003_final); % Rows of Matrix for 1003 condition 3

% Condition 4:
cond4_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond4_1003_final = find(cell2mat(DataMatrix(cond4_1003,2))== 4);
     
cond4_1003 = cond4_1003(cond4_1003_final); % Rows of Matrix for 1003 condition4

% Condition 5:
cond5_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond5_1003_final = find(cell2mat(DataMatrix(cond5_1003,2))== 5);
     
cond5_1003 = cond5_1003(cond5_1003_final); % Rows of Matrix for 1003 condition 5

% Condition 6:
cond6_1003 = find(strcmp(DataMatrix(:,1),'RTIS1003'));

cond6_1003_final = find(cell2mat(DataMatrix(cond6_1003,2))== 6);
     
cond6_1003 = cond6_1003(cond6_1003_final); % Rows of Matrix for 1003 condition 6

%% RTIS1004
% Condition 1:
cond1_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond1_1004_final = find(cell2mat(DataMatrix(cond1_1004,2))== 1);
     
cond1_1004 = cond1_1004(cond1_1004_final); % Rows of Matrix for 1004 condition 1

% Condition 2:
cond2_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond2_1004_final = find(cell2mat(DataMatrix(cond2_1004,2))== 2);
     
cond2_1004 = cond2_1004(cond2_1004_final); % Rows of Matrix for 1004 condition 2

% Condition 3:
cond3_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond3_1004_final = find(cell2mat(DataMatrix(cond3_1004,2))== 3);
     
cond3_1004 = cond3_1004(cond3_1004_final); % Rows of Matrix for 1004 condition 3

% Condition 4:
cond4_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond4_1004_final = find(cell2mat(DataMatrix(cond4_1004,2))== 4);
     
cond4_1004 = cond4_1004(cond4_1004_final); % Rows of Matrix for 1004 condition4

% Condition 5:
cond5_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond5_1004_final = find(cell2mat(DataMatrix(cond5_1004,2))== 5);
     
cond5_1004 = cond5_1004(cond5_1004_final); % Rows of Matrix for 1004 condition 5

% Condition 6:
cond6_1004 = find(strcmp(DataMatrix(:,1),'RTIS1004'));

cond6_1004_final = find(cell2mat(DataMatrix(cond6_1004,2))== 6);
     
cond6_1004 = cond6_1004(cond6_1004_final); % Rows of Matrix for 1004 condition 6


%% RTIS1005
% Condition 1:
cond1_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond1_1005_final = find(cell2mat(DataMatrix(cond1_1005,2))== 1);
     
cond1_1005 = cond1_1005(cond1_1005_final); % Rows of Matrix for 1005 condition 1

% Condition 2:
cond2_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond2_1005_final = find(cell2mat(DataMatrix(cond2_1005,2))== 2);
     
cond2_1005 = cond2_1005(cond2_1005_final); % Rows of Matrix for 1005 condition 2

% Condition 3:
cond3_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond3_1005_final = find(cell2mat(DataMatrix(cond3_1005,2))== 3);
     
cond3_1005 = cond3_1005(cond3_1005_final); % Rows of Matrix for 1005 condition 3

% Condition 4:
cond4_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond4_1005_final = find(cell2mat(DataMatrix(cond4_1005,2))== 4);
     
cond4_1005 = cond4_1005(cond4_1005_final); % Rows of Matrix for 1005 condition4

% Condition 5:
cond5_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond5_1005_final = find(cell2mat(DataMatrix(cond5_1005,2))== 5);
     
cond5_1005 = cond5_1005(cond5_1005_final); % Rows of Matrix for 1005 condition 5

% Condition 6:
cond6_1005 = find(strcmp(DataMatrix(:,1),'RTIS1005'));

cond6_1005_final = find(cell2mat(DataMatrix(cond6_1005,2))== 6);
     
cond6_1005 = cond6_1005(cond6_1005_final); % Rows of Matrix for 1005 condition 6

%% RTIS1006
% Condition 1:
cond1_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond1_1006_final = find(cell2mat(DataMatrix(cond1_1006,2))== 1);
     
cond1_1006 = cond1_1006(cond1_1006_final); % Rows of Matrix for 1006 condition 1

% Condition 2:
cond2_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond2_1006_final = find(cell2mat(DataMatrix(cond2_1006,2))== 2);
     
cond2_1006 = cond2_1006(cond2_1006_final); % Rows of Matrix for 1006 condition 2

% Condition 3:
cond3_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond3_1006_final = find(cell2mat(DataMatrix(cond3_1006,2))== 3);
     
cond3_1006 = cond3_1006(cond3_1006_final); % Rows of Matrix for 1006 condition 3

% Condition 4:
cond4_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond4_1006_final = find(cell2mat(DataMatrix(cond4_1006,2))== 4);
     
cond4_1006 = cond4_1006(cond4_1006_final); % Rows of Matrix for 1006 condition4

% Condition 5:
cond5_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond5_1006_final = find(cell2mat(DataMatrix(cond5_1006,2))== 5);
     
cond5_1006 = cond5_1006(cond5_1006_final); % Rows of Matrix for 1006 condition 5

% Condition 6:
cond6_1006 = find(strcmp(DataMatrix(:,1),'RTIS1006'));

cond6_1006_final = find(cell2mat(DataMatrix(cond6_1006,2))== 6);
     
cond6_1006 = cond6_1006(cond6_1006_final); % Rows of Matrix for 1006 condition 6

%% Averages -Reaching Distance - Normalized to Limb Length

% RTIS1003
Reaching_Dist_1003_1 = mean(cell2mat(DataMatrix(cond1_1003,5))); % Condition 1
Reaching_Dist_1003_2 = mean(cell2mat(DataMatrix(cond2_1003,5))); % Condition 2
Reaching_Dist_1003_3 = mean(cell2mat(DataMatrix(cond3_1003,5))); % Condition 3
Reaching_Dist_1003_4 = mean(cell2mat(DataMatrix(cond4_1003,5))); % Condition 4
Reaching_Dist_1003_5 = mean(cell2mat(DataMatrix(cond5_1003,5))); % Condition 5
Reaching_Dist_1003_6 = mean(cell2mat(DataMatrix(cond6_1003,5))); % Condition 6
% RTIS1004
Reaching_Dist_1004_1 = mean(cell2mat(DataMatrix(cond1_1004,5))); % Condition 1
Reaching_Dist_1004_2 = mean(cell2mat(DataMatrix(cond2_1004,5))); % Condition 2
Reaching_Dist_1004_3 = mean(cell2mat(DataMatrix(cond3_1004,5))); % Condition 3
Reaching_Dist_1004_4 = mean(cell2mat(DataMatrix(cond4_1004,5))); % Condition 4
Reaching_Dist_1004_5 = mean(cell2mat(DataMatrix(cond5_1004,5))); % Condition 5
Reaching_Dist_1004_6 = mean(cell2mat(DataMatrix(cond6_1004,5))); % Condition 6
% RTIS1005
Reaching_Dist_1005_1 = mean(cell2mat(DataMatrix(cond1_1005,5))); % Condition 1
Reaching_Dist_1005_2 = mean(cell2mat(DataMatrix(cond2_1005,5))); % Condition 2
Reaching_Dist_1005_3 = mean(cell2mat(DataMatrix(cond3_1005,5))); % Condition 3
Reaching_Dist_1005_4 = mean(cell2mat(DataMatrix(cond4_1005,5))); % Condition 4
Reaching_Dist_1005_5 = mean(cell2mat(DataMatrix(cond5_1005,5))); % Condition 5
Reaching_Dist_1005_6 = mean(cell2mat(DataMatrix(cond6_1005,5))); % Condition 6
% RTIS1006
Reaching_Dist_1006_1 = mean(cell2mat(DataMatrix(cond1_1006,5))); % Condition 1
Reaching_Dist_1006_2 = mean(cell2mat(DataMatrix(cond2_1006,5))); % Condition 2
Reaching_Dist_1006_3 = mean(cell2mat(DataMatrix(cond3_1006,5))); % Condition 3
Reaching_Dist_1006_4 = mean(cell2mat(DataMatrix(cond4_1006,5))); % Condition 4
Reaching_Dist_1006_5 = mean(cell2mat(DataMatrix(cond5_1006,5))); % Condition 5
Reaching_Dist_1006_6 = mean(cell2mat(DataMatrix(cond6_1006,5))); % Condition 6


%% Group Means and Standard Error for Reaching Distance 

%Condition 1 Average RD and Standard Error
RD_Cond1 = mean([Reaching_Dist_1003_1 Reaching_Dist_1004_1 Reaching_Dist_1005_1 Reaching_Dist_1006_1]);
SE_Cond1 = std([Reaching_Dist_1003_1 Reaching_Dist_1004_1 Reaching_Dist_1005_1 Reaching_Dist_1006_1])/2;
%Condition 2 Average RD and Standard Error
RD_Cond2 = mean([Reaching_Dist_1003_2 Reaching_Dist_1004_2 Reaching_Dist_1005_2 Reaching_Dist_1006_2]);
SE_Cond2 = std([Reaching_Dist_1003_2 Reaching_Dist_1004_2 Reaching_Dist_1005_2 Reaching_Dist_1006_2])/2;
%Condition 3 Average RD and Standard Error
RD_Cond3 = mean([Reaching_Dist_1003_3 Reaching_Dist_1004_3 Reaching_Dist_1005_3 Reaching_Dist_1006_3]);
SE_Cond3 = std([Reaching_Dist_1003_3 Reaching_Dist_1004_3 Reaching_Dist_1005_3 Reaching_Dist_1006_3])/2;
%Condition 4 Average RD and Standard Error
RD_Cond4 = mean([Reaching_Dist_1003_4 Reaching_Dist_1004_4 Reaching_Dist_1005_4 Reaching_Dist_1006_4]);
SE_Cond4 = std([Reaching_Dist_1003_4 Reaching_Dist_1004_4 Reaching_Dist_1005_4 Reaching_Dist_1006_4])/2;
%Condition 5 Average RD and Standard Error
RD_Cond5 = mean([Reaching_Dist_1003_5 Reaching_Dist_1004_5 Reaching_Dist_1005_5 Reaching_Dist_1006_5]);
SE_Cond5 = std([Reaching_Dist_1003_5 Reaching_Dist_1004_5 Reaching_Dist_1005_5 Reaching_Dist_1006_5])/2;
%Condition 6 Average RD and Standard Error
RD_Cond6 = mean([Reaching_Dist_1003_6 Reaching_Dist_1004_6 Reaching_Dist_1005_6 Reaching_Dist_1006_6]);
SE_Cond6 = std([Reaching_Dist_1003_6 Reaching_Dist_1004_6 Reaching_Dist_1005_6 Reaching_Dist_1006_6])/2;








%% OLD hard coded numbers- use above because more efficient if need to change results in data matrix
% 
% %% Cumulative Group data
% % RD
% 
% %RTable
% RTRD_total = [RTRD_03 RTRD_04 RTRD_05 RTRD_06];
% RTRD_total_mean = mean(RTRD_total);
% RTRD_total_err = std(RTRD_total);
% RTRD_total_SE = std(RTRD_total)/2
% 
% %R25
% R25RD_total = [R25RD_03 R25RD_04 R25RD_05 R25RD_06 ];
% R25RD_total_mean = mean(R25RD_total);
% R25RD_total_err = std(R25RD_total);
% R25RD_total_SE = std(R25RD_total)/2
% 
% % R50
% R50RD_total = [R50RD_03 R50RD_04 R50RD_05 R50RD_06 ];
% R50RD_total_mean = mean(R50RD_total);
% R50RD_total_err = std(R50RD_total);
% R50RD_total_SE = std(R50RD_total)/2
% 
% %UT
% UTRD_total = [UTRD_03 UTRD_04 UTRD_05 UTRD_06 ];
% UTRD_total_mean = mean(UTRD_total);
% UTRD_total_err = std(UTRD_total);
% UTRD_total_SE = std(UTRD_total)/2
% 
% %U25
% U25RD_total = [U25RD_03 U25RD_04 U25RD_05 U25RD_06];
% U25RD_total_mean = mean(U25RD_total);
% U25RD_total_err = std(U25RD_total);
% U25RD_total_SE = std(U25RD_total)/2
% 
% %U50
% U50RD_total = [U50RD_03 U50RD_04 U50RD_05 U50RD_06];
% U50RD_total_mean = mean(U50RD_total);
% U50RD_total_err = std(U50RD_total);
% U50RD_total_SE = std(U50RD_total)/2
% %% Trunk Displacement
% 
% %RT
% RTTD_total = [RTTD_03 RTTD_04 RTTD_05 RTTD_06];
% RTTD_total_mean   = mean(RTTD_total);
% RTTD_total_err = std(RTTD_total);
% RTTD_total_SE = std(RTTD_total)/2
% 
% %R25
% R25TD_total = [R25TD_03 R25TD_04 R25TD_05 R25TD_06 ];
% R25TD_total_mean = mean(R25TD_total);
% R25TD_total_err = std(R25TD_total);
% R25TD_total_SE = std(R25TD_total)/2
% 
% %R50
% R50TD_total= [R50TD_03 R50TD_04 R50TD_05 R50TD_06];
% R50TD_total_mean = mean(R50TD_total);
% R50TD_total_err = std(R50TD_total);
% R50TD_total_SE = std(R50TD_total)/2
% 
% %UT
% UTTD_total= [UTTD_03 UTTD_04 UTTD_05 UTTD_06 ];
% UTTD_total_mean = mean(UTTD_total);
% UTTD_total_err = std(UTTD_total);
% UTTD_total_SE = std(UTTD_total)/2
% 
% %U25
% U25TD_total= [U25TD_03 U25TD_04 U25TD_05 U25TD_06];
% U25TD_total_mean = mean(U25TD_total);
% U25TD_total_err = std(U25TD_total);
% U25TD_total_SE = std(U25TD_total)/2
% 
% %U50
% U50TD_total= [U50TD_03 U50TD_04 U50TD_05 U50TD_06 ];
% U50TD_total_mean = mean(U50TD_total);
% U50TD_total_err = std(U50TD_total);
% U50TD_total_SE = std(U50TD_total)/2
% %% ANGLE 
% %RT
% RTANG_total = [RTANG_03 RTANG_04 RTANG_05 RTANG_06];
% RTANG_total_mean= mean(RTANG_total);
% RTANG_total_err = std(RTANG_total);
% RTANG_total_SE = std(RTANG_total)/2
% 
% %R25
% R25ANG_total = [R25ANG_03 R25ANG_04 R25ANG_05 R25ANG_06 ];
% R25ANG_total_mean = mean(R25ANG_total);
% R25ANG_total_err = std(R25ANG_total);
% R25ANG_total_SE = std(R25ANG_total)/2
% %R50
% R50ANG_total = [R50ANG_03 R50ANG_04 R50ANG_05 R50ANG_06];
% R50ANG_total_mean = mean(R50ANG_total);
% R50ANG_total_err = std(R50ANG_total);
% R50ANG_total_SE = std(R50ANG_total)/2
% 
% %UT
% UTANG_total = [UTANG_03  UTANG_04 UTANG_05 UTANG_06];
% UTANG_total_mean = mean(UTANG_total);
% UTANG_total_err = std(UTANG_total);
% UTANG_total_SE = std(UTANG_total)/2
% %U25
% U25ANG_total = [U25ANG_03 U25ANG_04 U25ANG_05 U25ANG_06];
% U25ANG_total_mean = mean(U25ANG_total);
% U25ANG_total_err  = std(U25ANG_total);
% U25ANG_total_SE  = std(U25ANG_total)/2
% %U50
% U50ANG_total = [U50ANG_03 U50ANG_04 U50ANG_05 U50ANG_06];
% U50ANG_total_mean = mean(U50ANG_total);
% U50ANG_total_err = std(U50ANG_total);
% U50ANG_total_SE = std(U50ANG_total)/2
% 
% 
% 
% %% RTIS1003
% 
% %RD
% RTRD_03 = 101.70;
% errRT = .55;
% 
% R25RD_03= 101.23;
% errR25 =.27;
% 
% R50RD_03=103.26;
% errR50 = 1.76;
% 
% UTRD_03 = 89.58;
% errUT = 4.76;
% 
% U25RD_03= 93.85;
% errU25=2.13;
% 
% U50RD_03 = 87.91;
% errU50 = 1.02;
% 
% %% TD
% RTTD_03 = 5.01;
% errRT = 2.42;
% 
% R25TD_03= 3.05;
% errR25 =.88;
% 
% R50TD_03=4.49;
% errR50 = 1.18;
% 
% 
% UTTD_03 = 2.81;
% errUT = 2.27;
% 
% 
% U25TD_03= 3.74;
% errU25= 1.60;
% 
% 
% U50TD_03 = 2.36;
% errU50 = .41;
% 
% %% Trunk Angle
% RTANG_03 = 7.75;
% errRT = 2.95;
% 
% R25ANG_03= 6.06;
% errR25 = 2.57;
% 
% R50ANG_03= 1.75;
% errR50 = 1.24;
% 
% 
% UTANG_03 =-1.50;
% errUT = 2.04;
% 
% 
% U25ANG_03= -2.27;
% errU25= .93;
% 
% 
% U50ANG_03 = -.71;
% errU50 = 3.46;
% %% RTIS1004
% 
% %RD
% RTRD_04 = 88.94;
% errRT = 1.75;
% 
% R25RD_04= 93.16;
% errR25 = 1.04;
% 
% R50RD_04=92.93;
% errR50 =1.07;
% 
% UTRD_04 = 86.16;
% errUT = .76;
% 
% U25RD_04= 92.38;
% errU25= 1.09;
% 
% U50RD_04 =90.91;
% errU50 = 1.11;
% 
% %% TD
% RTTD_04 = .46;
% errRT = .35;
% 
% R25TD_04= 1.11;
% errR25 =.70;
% 
% R50TD_04=1.48;
% errR50 = .70;
% 
% 
% UTTD_04 = .71;
% errUT = .44;
% 
% 
% U25TD_04= 1.94;
% errU25= .93;
% 
% 
% U50TD_04 = 1.98;
% errU50 = .86;
% 
% %% Trunk Angle
% RTANG_04 = -1.93;
% errRT = 1.26;
% 
% R25ANG_04= -3.12;
% errR25 = .88;
% 
% R50ANG_04= -1.82;
% errR50 = .72;
% 
% 
% UTANG_04 =-.64;
% errUT = .47;
% 
% 
% U25ANG_04= -1.75;
% errU25= 1.21;
% 
% 
% U50ANG_04 = -1.01;
% errU50 = .80;
% 
% %% RTIS1005
% 
% %RD
% RTRD_05 = 101.99;
% errRT = 2.49;
% 
% R25RD_05= 102.48;
% errR25 = 1.33;
% 
% R50RD_05=101.98;
% errR50 = 1.17;
% 
% UTRD_05 = 97.36;
% errUT = 1.69;
% 
% U25RD_05= 98.96;
% errU25=1.75;
% 
% U50RD_05 =99.79;
% errU50 = .83;
% 
% %% TD
% RTTD_05 =2.08;
% errRT_05 = 1.16;
% 
% R25TD_05= 1.73;
% errR25 =1.02;
% 
% R50TD_05=1.45;
% errR50 = .75;
% 
% 
% UTTD_05 = 2.78;
% errUT = .93;
% 
% 
% U25TD_05= 2.61;
% errU25= .63;
% 
% 
% U50TD_05 = 4.04;
% errU50 = .88;
% 
% %% Trunk Angle
% RTANG_05 = -1.14;
% errRT = 2.12;
% 
% R25ANG_05= 1.58;
% errR25 = 3.91;
% 
% R50ANG_05= .94;
% errR50 = 1.03;
% 
% 
% UTANG_05 =- 2.84;
% errUT = 1.47;
% 
% 
% U25ANG_05= -1.84;
% errU25= 1.03;
% 
% 
% U50ANG_05 = -2.36;
% errU50 = .81;
% 
% %% RTIS1006
% 
% %RD
% RTRD_06 = 93.03;
% errRT = 1.73;
% 
% R25RD_06= 91.61;
% errR25 = 1.38;
% 
% R50RD_06=92.08;
% errR50 =1.51;
% 
% UTRD_06 = 90.80;
% errUT = 1.89;
% 
% U25RD_06= 87.91;
% errU25=2.80;
% 
% U50RD_06 = 88.95;
% errU50 = 3.82;
% 
% %% TD
% RTTD_06 = .31;
% errRT = .17;
% 
% R25TD_06= 1.16;
% errR25 =.27;
% 
% R50TD_06=1.07;
% errR50 =.30;
% 
% 
% UTTD_06 = 1.41;
% errUT = .76;
% 
% 
% U25TD_06= 1.63;
% errU25= .62;
% 
% 
% U50TD_06 = 2.35;
% errU50 = .65;
% 
% %% Trunk Angle
% RTANG_06 = -.22;
% errRT = .47;
% 
% R25ANG_06= 1.13;
% errR25 = .300;
% 
% R50ANG_06=.69;
% errR50_06 =.26;
% 
% 
% UTANG_06 =1.61;
% errUT_06 = .97;
% 
% 
% U25ANG_06= -1.21;
% errU25= 1.07;
% 
% 
% U50ANG_06 = -1.07;
% errU50 = .69;

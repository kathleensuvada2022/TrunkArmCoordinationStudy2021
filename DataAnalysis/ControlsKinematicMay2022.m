%% K. Suvada- May 2022 
% Kacey Updated so now just data- call function 'BarPlotandErr' with these
% variables

%%Controls


%% Cumulative Group data
% RD

%RTable
RTRD_total = [RTRD_03 RTRD_04 RTRD_05 RTRD_06];
RTRD_total_mean = mean(RTRD_total);
RTRD_total_err = std(RTRD_total);


%R25
R25RD_total = [R25RD_03 R25RD_04 R25RD_05 R25RD_06 ];
R25RD_total_mean = mean(R25RD_total)
R25RD_total_err = std(R25RD_total)

% R50
R50RD_total = [R50RD_03 R50RD_04 R50RD_05 R50RD_06 ];
R50RD_total_mean = mean(R50RD_total)
R50RD_total_err = std(R50RD_total)

%UT
UTRD_total = [UTRD_03 UTRD_04 UTRD_05 UTRD_06 ];
UTRD_total_mean = mean(UTRD_total)
UTRD_total_err = std(UTRD_total)

%U25
U25RD_total = [U25RD_03 U25RD_04 U25RD_05 U25RD_06];
U25RD_total_mean = mean(U25RD_total)
U25RD_total_err = std(U25RD_total)

%U50
U50RD_total = [U50RD_03 U50RD_04 U50RD_05 U50RD_06];
U50RD_total_mean = mean(U50RD_total)
U50RD_total_err = std(U50RD_total)

%% Trunk Displacement

%RT
RTTD_total = [RTTD_03 RTTD_04 RTTD_05 RTTD_06];
RTTD_total_mean   = mean(RTTD_total);
RTTD_total_err = std(RTTD_total);
RTTD_total_SE = std(RTTD_total)/2

%R25
R25TD_total = [R25TD_03 R25TD_04 R25TD_05 R25TD_06 ];
R25TD_total_mean = mean(R25TD_total);
R25TD_total_err = std(R25TD_total);
R25TD_total_SE = std(R25TD_total)/2

%R50
R50TD_total= [R50TD_03 R50TD_04 R50TD_05 R50TD_06];
R50TD_total_mean = mean(R50TD_total);
R50TD_total_err = std(R50TD_total);
R50TD_total_SE = std(R50TD_total)/2

%UT
UTTD_total= [UTTD_03 UTTD_04 UTTD_05 UTTD_06 ];
UTTD_total_mean = mean(UTTD_total);
UTTD_total_err = std(UTTD_total);
UTTD_total_SE = std(UTTD_total)/2

%U25
U25TD_total= [U25TD_03 U25TD_04 U25TD_05 U25TD_06];
U25TD_total_mean = mean(U25TD_total);
U25TD_total_err = std(U25TD_total);
U25TD_total_SE = std(U25TD_total)/2

%U50
U50TD_total= [U50TD_03 U50TD_04 U50TD_05 U50TD_06 ];
U50TD_total_mean = mean(U50TD_total);
U50TD_total_err = std(U50TD_total);
U50TD_total_SE = std(U50TD_total)/2
%% ANGLE 
%RT
RTANG_total = [RTANG_03 RTANG_04 RTANG_05 RTANG_06];
RTANG_total_mean= mean(RTANG_total)
RTANG_total_err = std(RTANG_total)

%R25
R25ANG_total = [R25ANG_03 R25ANG_04 R25ANG_05 R25ANG_06 ];
R25ANG_total_mean = mean(R25ANG_total)
R25ANG_total_err = std(R25ANG_total)

%R50
R50ANG_total = [R50ANG_03 R50ANG_04 R50ANG_05 R50ANG_06];
R50ANG_total_mean = mean(R50ANG_total)
R50ANG_total_err = std(R50ANG_total)

%UT
UTANG_total = [UTANG_03  UTANG_04 UTANG_05 UTANG_06];
UTANG_total_mean = mean(UTANG_total)
UTANG_total_err = std(UTANG_total)

%U25
U25ANG_total = [U25ANG_03 U25ANG_04 U25ANG_05 U25ANG_06];
U25ANG_total_mean = mean(U25ANG_total)
U25ANG_total_err  = std(U25ANG_total)

%U50
U50ANG_total = [U50ANG_03 U50ANG_04 U50ANG_05 U50ANG_06];
U50ANG_total_mean = mean(U50ANG_total)
U50ANG_total_err = std(U50ANG_total)




%% RTIS1003

%RD
RTRD_03 = 101.70;
errRT = .55;

R25RD_03= 101.23;
errR25 =.27;

R50RD_03=103.26;
errR50 = 1.76;

UTRD_03 = 89.58;
errUT = 4.76;

U25RD_03= 93.85;
errU25=2.13;

U50RD_03 = 87.91;
errU50 = 1.02;

%% TD
RTTD_03 = 5.01;
errRT = 2.42;

R25TD_03= 3.05;
errR25 =.88;

R50TD_03=4.49;
errR50 = 1.18;


UTTD_03 = 2.81;
errUT = 2.27;


U25TD_03= 3.74;
errU25= 1.60;


U50TD_03 = 2.36;
errU50 = .41;

%% Trunk Angle
RTANG_03 = 7.75;
errRT = 2.95;

R25ANG_03= 6.06;
errR25 = 2.57;

R50ANG_03= 1.75;
errR50 = 1.24;


UTANG_03 =-1.50;
errUT = 2.04;


U25ANG_03= -2.27;
errU25= .93;


U50ANG_03 = -.71;
errU50 = 3.46;
%% RTIS1004

%RD
RTRD_04 = 88.94;
errRT = 1.75;

R25RD_04= 93.16;
errR25 = 1.04;

R50RD_04=92.93;
errR50 =1.07;

UTRD_04 = 86.16;
errUT = .76;

U25RD_04= 92.38;
errU25= 1.09;

U50RD_04 =90.91;
errU50 = 1.11;

%% TD
RTTD_04 = .46;
errRT = .35;

R25TD_04= 1.11;
errR25 =.70;

R50TD_04=1.48;
errR50 = .70;


UTTD_04 = .71;
errUT = .44;


U25TD_04= 1.94;
errU25= .93;


U50TD_04 = 1.98;
errU50 = .86;

%% Trunk Angle
RTANG_04 = -1.93;
errRT = 1.26;

R25ANG_04= -3.12;
errR25 = .88;

R50ANG_04= -1.82;
errR50 = .72;


UTANG_04 =-.64;
errUT = .47;


U25ANG_04= -1.75;
errU25= 1.21;


U50ANG_04 = -1.01;
errU50 = .80;

%% RTIS1005

%RD
RTRD_05 = 101.99;
errRT = 2.49;

R25RD_05= 102.48;
errR25 = 1.33;

R50RD_05=101.98;
errR50 = 1.17;

UTRD_05 = 97.36;
errUT = 1.69;

U25RD_05= 98.96;
errU25=1.75;

U50RD_05 =99.79;
errU50 = .83;

%% TD
RTTD_05 =2.08;
errRT_05 = 1.16;

R25TD_05= 1.73;
errR25 =1.02;

R50TD_05=1.45;
errR50 = .75;


UTTD_05 = 2.78;
errUT = .93;


U25TD_05= 2.61;
errU25= .63;


U50TD_05 = 4.04;
errU50 = .88;

%% Trunk Angle
RTANG_05 = -1.14;
errRT = 2.12;

R25ANG_05= 1.58;
errR25 = 3.91;

R50ANG_05= .94;
errR50 = 1.03;


UTANG_05 =- 2.84;
errUT = 1.47;


U25ANG_05= -1.84;
errU25= 1.03;


U50ANG_05 = -2.36;
errU50 = .81;

%% RTIS1006

%RD
RTRD_06 = 93.03;
errRT = 1.73;

R25RD_06= 91.61;
errR25 = 1.38;

R50RD_06=92.08;
errR50 =1.51;

UTRD_06 = 90.80;
errUT = 1.89;

U25RD_06= 87.91;
errU25=2.80;

U50RD_06 = 88.95;
errU50 = 3.82;

%% TD
RTTD_06 = .31;
errRT = .17;

R25TD_06= 1.16;
errR25 =.27;

R50TD_06=1.07;
errR50 =.30;


UTTD_06 = 1.41;
errUT = .76;


U25TD_06= 1.63;
errU25= .62;


U50TD_06 = 2.35;
errU50 = .65;

%% Trunk Angle
RTANG_06 = -.22;
errRT = .47;

R25ANG_06= 1.13;
errR25 = .300;

R50ANG_06=.69;
errR50_06 =.26;


UTANG_06 =1.61;
errUT_06 = .97;


U25ANG_06= -1.21;
errU25= 1.07;


U50ANG_06 = -1.07;
errU50 = .69;

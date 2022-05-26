%% K. Suvada- May 2022 
% Kacey Updated so now just data- call function 'BarPlotandErr' with these
% variables

%% Stroke Non-Paretic 


%% Cumulative Group data
% RD

%R Table
RTRD_total = [RTRD_01 RTRD_02 RTRD_03 RTRD_06 RTRD_07 RTRD_08 RTRD_09 RTRD_10 RTRD_11];
RTRD_total_mean = mean(RTRD_total);
RTRD_total_err = std(RTRD_total);

%R25
R25RD_total = [R25RD_01 R25RD_02 R25RD_03 R25RD_06 R25RD_07 R25RD_08 R25RD_09 R25RD_10 R25RD_11];
R25RD_total_mean = mean(R25RD_total);
R25RD_total_err = std(R25RD_total);

% R50
R50RD_total = [R50RD_01 R50RD_02 R50RD_03 R50RD_06 R50RD_07 R50RD_08 R50RD_09 R50RD_10 R50RD_11];
R50RD_total_mean = mean(R50RD_total);
R50RD_total_err = std(R50RD_total);

%UT
UTRD_total = [UTRD_01 UTRD_02 UTRD_03 UTRD_06 UTRD_07 UTRD_08 UTRD_09 UTRD_10 UTRD_11];
UTRD_total_mean = mean(UTRD_total);
UTRD_total_err = std(UTRD_total);

%U25
U25RD_total = [U25RD_01 U25RD_02 U25RD_03 U25RD_06 U25RD_07 U25RD_08 U25RD_09 U25RD_10 U25RD_11];
U25RD_total_mean = mean(U25RD_total);
U25RD_total_err = std(U25RD_total);

%U50
U50RD_total = [U50RD_01 U50RD_02 U50RD_03 U50RD_06 U50RD_07 U50RD_08 U50RD_09 U50RD_10 U50RD_11];
U50RD_total_mean = mean(U50RD_total);
U50RD_total_err = std(U50RD_total);


%% Trunk Displacement


%RT
RTTD_total = [RTTD_01 RTTD_02 RTTD_03 RTTD_06 RTTD_07 RTTD_08 RTTD_09 RTTD_10 RTTD_11];
RTTD_total_mean   = mean(RTTD_total)
RTTD_total_err = std(RTTD_total)

%R25
R25TD_total = [R25TD_01 R25TD_02 R25TD_03 R25TD_06 R25TD_07 R25TD_08 R25TD_09 R25TD_10 R25TD_11];
R25TD_total_mean = mean(R25TD_total)
R25TD_total_err = std(R25TD_total)

%R50
R50TD_total= [R50TD_01 R50TD_02 R50TD_03 R50TD_06 R50TD_07 R50TD_08 R50TD_09 R50TD_10 R50TD_10];
R50TD_total_mean = mean(R50TD_total)
R50TD_total_err = std(R50TD_total)

%UT
UTTD_total= [UTTD_01 UTTD_02 UTTD_03 UTTD_06 UTTD_07 UTTD_08 UTTD_01 UTTD_09 UTTD_01 UTTD_10 UTTD_11];
UTTD_total_mean = mean(UTTD_total)
UTTD_total_err = std(UTTD_total)

%U25
U25TD_total= [U25TD_01 U25TD_02 U25TD_03 U25TD_06 U25TD_07 U25TD_08 U25TD_09 U25TD_10 U25TD_11];
U25TD_total_mean = mean(U25TD_total)
U25TD_total_err = std(U25TD_total)

%U50
U50TD_total= [U50TD_01 U50TD_02 U50TD_03 U50TD_06 U50TD_07 U50TD_08 U50TD_09 U50TD_10 U50TD_11];
U50TD_total_mean = mean(U50TD_total)
U50TD_total_err = std(U50TD_total)


%% ANGLE 
%RT
RTANG_total = [RTANG_01 RTANG_02 RTANG_03 RTANG_06 RTANG_07 RTANG_08 RTANG_09 RTANG_10 RTANG_11];
RTANG_total_mean= mean(RTANG_total)
RTANG_total_err = std(RTANG_total)

%R25
R25ANG_total = [R25ANG_01 R25ANG_02 R25ANG_03 R25ANG_06 R25ANG_07 R25ANG_08 R25ANG_09 R25ANG_10 R25ANG_11];
R25ANG_total_mean = mean(R25ANG_total)
R25ANG_total_err = std(R25ANG_total)

%R50
R50ANG_total = [R50ANG_01 R50ANG_02 R50ANG_03 R50ANG_06 R50ANG_07 R50ANG_08 R50ANG_09 R50ANG_10 R50ANG_11];
R50ANG_total_mean = mean(R50ANG_total)
R50ANG_total_err = std(R50ANG_total)

%UT
UTANG_total = [UTANG_01  UTANG_02 UTANG_03 UTANG_06 UTANG_07 UTANG_08 UTANG_09 UTANG_02 UTANG_10 UTANG_11];
UTANG_total_mean = mean(UTANG_total)
UTANG_total_err = std(UTANG_total)

%U25
U25ANG_total = [U25ANG_01 U25ANG_02 U25ANG_03 U25ANG_06 U25ANG_07 U25ANG_08 U25ANG_09 U25ANG_10 U25ANG_11];
U25ANG_total_mean = mean(U25ANG_total)
U25ANG_total_err  = std(U25ANG_total)

%U50
U50ANG_total = [U50ANG_01 U50ANG_02 U50ANG_03 U50ANG_06 U50ANG_07 U50ANG_08 U50ANG_09 U50ANG_10 U50ANG_11];
U50ANG_total_mean = mean(U50ANG_total)
U50ANG_total_err = std(U50ANG_total)



%% RTIS2001

%RD
RTRD_01 = 93.42;
% errRT = .97;

R25RD_01= 95.73;
errR25 = .43;

R50RD_01=95.37;
errR50 =.60;

UTRD_01 = 91.72;
errUT = .42;

U25RD_01= 89.09;
errU25=1.94;

U50RD_01 = 88.46;
errU50 = 1.68;

%% TD
RTTD_01 =2.18; 
errRT = 1.19;

R25TD_01= 1.25;
errR25 =.79;

R50TD_01=1.33;
errR50 =.30;


UTTD_01 = 3.23;
errUT = 1.38;


U25TD_01= 2.64;
errU25= 1.59;


U50TD_01 = 3.53;
errU50 = 1.53;

%% Trunk Angle
RTANG_01 = .40;
errRT = 1.21;

R25ANG_01= 5.56;
errR25 =2.23;

R50ANG_01=4.17;
errR50 =1.35;


UTANG_01 = 2.38;
errUT = 1.22;


U25ANG_01= 1.44;
errU25= 2.16;


U50ANG_01 = 3.39;
errU50 = 3.06;


%% RTIS2002

%RD
RTRD_02 = 94.15;
errRT =1.45;

R25RD_02= 93.94;
errR25 = 1.85;

R50RD_02= 93.50;
errR50 = 1.30;

UTRD_02 = 93.08;
errUT = .76;

U25RD_02= 94.84;
errU25=1.14;

U50RD_02 = 95.01;
errU50 = .50;

%% TD
RTTD_02 = 1.52;
errRT = .25;

R25TD_02= .63;
errR25 =.38;

R50TD_02=.57;
errR50 =.34;


UTTD_02 = 3.13;
errUT = 1.25;


U25TD_02= 2.78;
errU25= .82;


U50TD_02 = 2.43;
errU50 = .95;

%% Trunk Angle
RTANG_02 =-2.70;
errRT = .45;

R25ANG_02= -2.31;
errR25 =.63;

R50ANG_02= -2.18;
errR50 =.58;


UTANG_02 = -4.28;
errUT = 1.33;


U25ANG_02= -4.65;
errU25=.75;


U50ANG_02 = -4.31;
errU50 = .88;



%% RTIS2003
%RD
RTRD_03 = 97.39;
errRT = 2.34;

R25RD_03= 98.69;
errR25 = 2.28;

R50RD_03= 96.85;
errR50 =1.27;

UTRD_03 = 96.03;
errUT = 2.00;

U25RD_03= 97.29;
errU25= 1.26;

U50RD_03 = 96.45;
errU50 = .65;

%% TD
RTTD_03 = 1.93;
errRT = .66;

R25TD_03= 1.54;
errR25 =.66;

R50TD_03= 1.61;
errR50 = .37;


UTTD_03 = 2.65;
errUT = 1.15;


U25TD_03= 3.16;
errU25= .97;


U50TD_03 = 3.17;
errU50 = .79;

%% Trunk Angle
RTANG_03 = -.58;
errRT = 1.05;

R25ANG_03= -.71;
errR25 = 1.50;

R50ANG_03= -.64;
errR50 = 1.04;


UTANG_03 = -.25;
errUT = 1.50;


U25ANG_03= -.35;
errU25=.47;


U50ANG_03 = 1.26;
errU50 = 1.02;


%% RTIS2006
%RD
RTRD_06 = 100.64;
errRT = .44;

R25RD_06= 100.61;
errR25 = .44;

R50RD_06=99.85;
errR50 =.67;

UTRD_06 = 100.36;
errUT = .44;

U25RD_06= 99.20;
errU25=1.43;

U50RD_06 = 99.72;
errU50 = .52;

%% TD
RTTD_06 = 2.18;
errRT = .68;

R25TD_06= 1.66;
errR25 =.54;

R50TD_06=1.59;
errR50 =.64;


UTTD_06 = 1.03;
errUT = .35;


U25TD_06= 1.53;
errU25= .78;


U50TD_06 = 1.73;
errU50 = .95;

%% Trunk Angle
RTANG_06 =1.11;
errRT = 1.53;

R25ANG_06= -.52;
errR25 =1.24;

R50ANG_06=1.49;
errR50 =1.00;


UTANG_06 = -.26;
errUT = 1.12;


U25ANG_06= 1.07;
errU25=1.18;


U50ANG_06 = .25;
errU50 = 1.10;


%% RTIS2007
%RD
RTRD_07 = 90.28;
errRT =.71;

R25RD_07= 88.26;
errR25 = 1.33;

R50RD_07=88.88;
errR50 = .92;

UTRD_07 = 89.04;
errUT = .98;

U25RD_07= 88.40;
errU25=.49;

U50RD_07 = 88.28;
errU50 = .59;

%% TD
RTTD_07 = 1.51;
errRT = .39;

R25TD_07= .79;
errR25 =.33;

R50TD_07=.98;
errR50 =.23;


UTTD_07 = 1.61;
errUT = .50;


U25TD_07= 3.11;
errU25= .97;


U50TD_07 = 3.61;
errU50 = 1.14;

%% Trunk Angle
RTANG_07 =.95;
errRT = 1.17;

R25ANG_07= 1.75;
errR25 =1.09;

R50ANG_07=1.43;
errR50 =.65;


UTANG_07 = 1.77;
errUT = .67;


U25ANG_07= 3.97;
errU25=1.37;


U50ANG_07 = 5.53;
errU50 = 1.10;

%% RTIS2008
%RD
RTRD_08 = 97.25;
errRT =.85;

R25RD_08 = 100.08;
errR25 = .81;

R50RD_08 =99.63;
errR50 =.78;

UTRD_08  = 93.04;
errUT = 1.81;

U25RD_08 = 97.98;
errU25=.95;

U50RD_08  = 96.47;
errU50 = 1.87;

%% TD
RTTD_08  = 1.43;
errRT = .58;

R25TD_08 = 2.56;
errR25 =.58;

R50TD_08 =1.70;
errR50 =.43;


UTTD_08  = .88;
errUT = .39;


U25TD_08 = 3.76;
errU25= 1.13;


U50TD_08  = 3.72;
errU50 = 1.32;

%% Trunk Angle
RTANG_08  = 1.60;
errRT = 1.15;

R25ANG_08 = .55;
errR25 =.87;

R50ANG_08 =1.51;
errR50 =.49;


UTANG_08  = .1;
errUT = .67;


U25ANG_08 = -2.60;
errU25=.94;


U50ANG_08  = 2.24;
errU50 = 1.62;


%% RTIS2009
%RD
RTRD_09 = 94.97;
errRT =1.29;

R25RD_09 = 98.13;
errR25 = .38;

R50RD_09 =97.28;
errR50 =1.06;

UTRD_09  = 94.24;
errUT = .52;

U25RD_09 = 96.78;
errU25=.40;

U50RD_09  = 96.58;
errU50 = .59;

%% TD
RTTD_09  = 2.00;
errRT = .80;

R25TD_09 = 1.48;
errR25 =.60;

R50TD_09 =2.04;
errR50 =.59;


UTTD_09  = 2.20;
errUT = 1.19;


U25TD_09 = 2.23;
errU25= .96;


U50TD_09  = 2.01;
errU50 = 1.37;

%% Trunk Angle
RTANG_09  =.07;
errRT = 1.53;

R25ANG_09 = 2.18;
errR25 =.94;

R50ANG_09 =3.26;
errR50 =.53;

UTANG_09  = -4.29;
errUT = 1.09;


U25ANG_09 = 2.45;
errU25=1.42;


U50ANG_09  = -1.80;
errU50 = 1.95;


%% RTIS2010
%RD
RTRD_10 = 95.18;
errRT =.53;

R25RD_10= 95.77;
errR25 = .67;

R50RD_10=94.35;
errR50 =.53;

UTRD_10 = 93.79;
errUT = .67;

U25RD_10= 94.13;
errU25=.77;

U50RD_10 = 93.24;
errU50 = .85;

%% TD
RTTD_10 = .83;
errRT = .52;

R25TD_10= 2.54;
errR25 =.93

R50TD_10=1.06;
errR50 =.48;


UTTD_10 = 4.71;
errUT = .66;


U25TD_10= 4.15;
errU25= 1.46;


U50TD_10 = 2.47;
errU50 = .69;

%% Trunk Angle
RTANG_10 =.88;
errRT = .87;

R25ANG_10= 3.21;
errR25 =.47;

R50ANG_10=1.61;
errR50 =.64;


UTANG_10 = -.56;
errUT = 1.04;


U25ANG_10= .43;
errU25=1.47;


U50ANG_10 = -1.16;
errU50 = .80;



%% RTIS2011
%RD
RTRD_11 = 93.90;
errRT =1.19;

R25RD_11= 92.79;
errR25 = .66;

R50RD_11= 91.74;
errR50 =.81;

UTRD_11 = 90.61;
errUT = 1.76;

U25RD_11= 88.81;
errU25=.87;

U50RD_11 = 87.64;
errU50 = 1.83;

%% TD
RTTD_11 = .85;
errRT_11 = .35;

R25TD_11= .65;
errR25 =.39;

R50TD_11= 1.50;
errR50 = .62;


UTTD_11 = 1.39;
errUT = 1.06;


U25TD_11= 1.09;
errU25= 1.02;


U50TD_11 = 3.02;
errU50 = 2.05;

%% Trunk Angle
RTANG_11 =-1.36;
errRT = .84;

R25ANG_11= -.78;
errR25 =1.72;

R50ANG_11=-1.28;
errR50 =.900;


UTANG_11 = -2.01;
errUT = 1.21;


U25ANG_11= -.93;
errU25=.98;


U50ANG_11 = -2.15;
errU50 = 2.15;

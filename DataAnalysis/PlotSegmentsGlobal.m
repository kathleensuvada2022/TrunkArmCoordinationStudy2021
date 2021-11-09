% November 1 2021 K.Suvada
% Function for plotting segments after a trial. Used to double check and
% see if angles make sense based on ComputeEulerAngles. Input is the
% BonyLandmarks in the Global CS. 

% Testing
% Run ComputeEulerAngles First then use outputs and plot the segments
%PlotSegmentsGlobal(BLs_G,BL_names_all)

% Order of BonyLandmarks
% {BL_G_t,BL_G_s,BL_G_h,BL_G_f}; 
% Trunk Shoulder Humerus Forearm
function PlotSegmentsGlobal(BLs_G,BL_names_all,i)
HumNames = BL_names_all{1,3}; 
ForeNames = BL_names_all{1,4}; 
ShldrNames= BL_names_all{1,2}; 
TrkNames= BL_names_all{1,1}; 

%Finding indices of Humerus BLs
GH_IDX = find(HumNames=='GH');
EL_IDX=  find(HumNames=='EL');
EM_IDX=  find(HumNames=='EM');

%Finding indices of Forearm BLs
OL_IDX = find(ForeNames=='OL');
RS_IDX = find(ForeNames=='RS');
US_IDX = find(ForeNames=='US');

%Shoulder BLS 
AA_IDX = find(ShldrNames=='AA');
AI_IDX = find(ShldrNames=='AI');
TS_IDX = find(ShldrNames=='TS');
AC_IDX = find(ShldrNames=='AC');

%Trunk BLS
IJ_IDX = find(TrkNames=='IJ');
PX_IDX = find(TrkNames=='PX');
C7_IDX = find(TrkNames=='C7');
T8_IDX = find(TrkNames=='T8');


%Aligning BL data in GCS and creating Variables 

%Humerus
[GH,EL,EM] = deal(BLs_G{1,3}(:,GH_IDX,:), BLs_G{1,3}(:,EL_IDX,:),BLs_G{1,3}(:,EM_IDX,:));
EL = squeeze(EL)';
EM = squeeze(EM)';
GH = squeeze(GH)';

%Forearm
[OL,RS,US] = deal(BLs_G{1,4}(:,OL_IDX,:), BLs_G{1,4}(:,RS_IDX,:),BLs_G{1,4}(:,US_IDX,:));
OL = squeeze(OL)';
RS=squeeze(RS)';
US = squeeze(US)';

%Shoulder 
[AA,AI,TS,AC] = deal(BLs_G{1,2}(:,AA_IDX,:), BLs_G{1,2}(:,AI_IDX,:),BLs_G{1,2}(:,TS_IDX,:),BLs_G{1,2}(:,AC_IDX,:));
AA = squeeze(AA)';
AI=squeeze(AI)';
TS = squeeze(TS)';
AC = squeeze(AC)';

%TRUNK 
[IJ,PX,C7,T8] = deal(BLs_G{1,1}(:,IJ_IDX,:), BLs_G{1,1}(:,PX_IDX,:),BLs_G{1,1}(:,C7_IDX,:),BLs_G{1,1}(:,T8_IDX,:));
IJ = squeeze(IJ)';
PX=squeeze(PX)';
C7 = squeeze(C7)';
T8 = squeeze(T8)';

%%

    %Humerus
     H_Mid_H(i,1:3) =(EL(i,1:3)+EM(i,1:3))'/2;

if i ==1   
    % Plotting GH, midpoint between EL and EM
    figure (1)
    plot3(H_Mid_H(i,1),H_Mid_H(i,2),H_Mid_H(i,3),'*');
    hold on
     text(H_Mid_H(i,1),H_Mid_H(i,2),H_Mid_H(i,3),'MID_E_M_E_L');

    plot3(EM(i,1),EM(i,2),EM(i,3),'*');
    text(EM(i,1),EM(i,2),EM(i,3),'EM');
    hold on
    plot3(EL(i,1),EL(i,2),EL(i,3),'*');
    text(EL(i,1),EL(i,2),EL(i,3),'EL');

    plot3(GH(i,1),GH(i,2),GH(i,3),'*');
    text(GH(i,1),GH(i,2),GH(i,3),'GH');

    % shoulder 
    plot3(AA(i,1),AA(i,2),AA(i,3),'*');
    text(AA(i,1),AA(i,2),AA(i,3),'AA');
    plot3(AI(i,1),AI(i,2),AI(i,3),'*');
    text(AI(i,1),AI(i,2),AI(i,3),'AI');
    plot3(TS(i,1),TS(i,2),TS(i,3),'*');
    text(TS(i,1),TS(i,2),TS(i,3),'TS');
    plot3(AC(i,1),AC(i,2),AC(i,3),'*');
    text(AC(i,1),AC(i,2),AC(i,3),'AC');
    
    %trunk
    %figure(2)
    plot3(IJ(i,1),IJ(i,2),IJ(i,3),'*');
    hold on
    text(IJ(i,1),IJ(i,2),IJ(i,3),'IJ');
    plot3(PX(i,1),PX(i,2),PX(i,3),'*');
    text(PX(i,1),PX(i,2),PX(i,3),'PX');
    plot3(C7(i,1),C7(i,2),C7(i,3),'*');
    text(C7(i,1),C7(i,2),C7(i,3),'C7');
    plot3(T8(i,1),T8(i,2),T8(i,3),'*');
    text(T8(i,1),T8(i,2),T8(i,3),'T8');
    

end
  
%Line from GH to MidPnt between Epicondyles
figure(1)
plot3([GH(i,1) H_Mid_H(i,1)],[GH(i,2) H_Mid_H(i,2)],[GH(i,3) H_Mid_H(i,3)])
  hold on  
%Forearm
H_Mid_f(i,1:3) =(RS(i,1:3)+US(i,1:3))'/2;

% Plotting GH, midpoint between RS and US
figure (1)
plot3(H_Mid_f(i,1),H_Mid_f(i,2),H_Mid_f(i,3),'*');
% plot3(RS(i,1),RS(i,2),RS(i,3),'*');
% text(RS(i,1),RS(i,2),RS(i,3),'RS');
% plot3(US(i,1),US(i,2),US(i,3),'*')
% text(US(i,1),US(i,2),US(i,3),'RS');
hold on
if i ==1
text(H_Mid_f(i,1),H_Mid_f(i,2),H_Mid_f(i,3),'Midpnt RS/US');


plot3(OL(i,1),OL(i,2),OL(i,3),'*');
text(OL(i,1),OL(i,2),OL(i,3),'OL');
end

title('Humerus/Forearm BLs in Global','FontSize',16)
xlabel('X axis')
ylabel('Y axis')
zlabel('Z axis')
%Line from GH to MidPnt between Epicondyles
 plot3([H_Mid_H(i,1) H_Mid_f(i,1)],[H_Mid_H(i,2) H_Mid_f(i,2)],[H_Mid_H(i,3) H_Mid_f(i,3)])

 
 %view(0,90)  % XY




end 









 
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
function PlotSegmentsGlobal(BLs_G,BL_names_all)
HumNames = BL_names_all{3,1}; 
ForeNames = BL_names_all{4,1}; 

%Finding indices of Humerus BLs
GH_IDX = find(HumNames=='GH');
EL_IDX=  find(HumNames=='EL');
EM_IDX=  find(HumNames=='EM');

%Finding indices of Forearm BLs
OL_IDX = find(ForeNames=='OL');
RS_IDX = find(ForeNames=='RS');
US_IDX = find(ForeNames=='US');

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
%%
for i = 1:250 
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
end
  
%Line from GH to MidPnt between Epicondyles
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
 view(0,90)  % XY
 pause()
end


end 









 
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

%Forearm
[OL,RS,US] = deal(BLs_G{1,4}(:,OL_IDX,:), BLs_G{1,4}(:,RS_IDX,:),BLs_G{1,4}(:,US_IDX,:));
%%
for i = 50:100 
    %Humerus
     H_Mid_H(i,1:3) =squeeze(EL(1:3,1,i)+EM(1:3,1,i))'/2;

if i ==50   
    % Plotting GH, midpoint between EL and EM
    figure (1)
    plot3(H_Mid_H(i,1),H_Mid_H(i,2),H_Mid_H(i,3),'*');
    hold on
     text(H_Mid_H(1,1),H_Mid_H(1,2),H_Mid_H(1,3),'MID_E_M_E_L');

    plot3(EM(1,1,i),EM(2,1,i),EM(3,1,i),'*');
   text(EM(1,1,i),EM(2,1,i),EM(3,1,i),'EM');
    hold on
    plot3(EL(1,1,i),EL(2,1,i),EL(3,1,i),'*');
   text(EL(1,1,i),EL(2,1,i),EL(3,1,i),'EL');

    plot3(GH(1,1,i),GH(2,1,i),GH(3,1,i),'*');

    text(GH(1,1,i),GH(2,1,i),GH(3,1,i),'GH');
end
  
%Line from GH to MidPnt between Epicondyles
plot3([GH(1,1,i) H_Mid_H(1)],[GH(2,1,i) H_Mid_H(2)],[GH(3,1,i) H_Mid_H(3)])
  hold on  
%Forearm
H_Mid_f(i,1:3) =squeeze(RS(1:3,1,i)-US(1:3,1,i))'/2;

% Plotting GH, midpoint between RS and US
figure (1)
plot3(H_Mid_f(i,1),H_Mid_f(i,2),H_Mid_f(i,3),'*');
hold on
if i ==50
text(H_Mid_f(i,1),H_Mid_f(i,2),H_Mid_f(i,3),'Midpnt RS/US');

plot3(OL(1,1,i),OL(2,1,i),OL(3,1,i),'*');
text(OL(1,1,i),OL(2,1,i),OL(3,1,i),'OL');
end

title('Humerus/Forearm BLs in Global','FontSize',16)

%Line from GH to MidPnt between Epicondyles
 plot3([OL(1,1,i) H_Mid_f(1)],[OL(2,1,i) H_Mid_f(2)],[OL(3,1,i) H_Mid_f(3)])
 
 pause()
end


end 









 
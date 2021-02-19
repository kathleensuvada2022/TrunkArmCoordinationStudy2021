%% SCRIPT for making plots of known points 

%   HT_marker % gives HT of marker in GCS
%% *NOTE THIS IS GRABBING THE MARKER OF THE POINTER TOOL NOT THE TIP OF IT

% HT =
%    1.0e+02 *
%   Columns 1 through 3
% 
%    0.009974577250615   0.000583450886642  -0.000409137793886                 
%   -0.000544623572142   0.009944216583374   0.000903294917300
%    0.000459558305524  -0.000878715884589   0.009950711761376
%                    0                   0                   0
% 
%   Column 4
% 
%    1.209811172485352
%   -0.541967926025391
%    0.029733953475952
%    0.010000000000000
%  


HT_marker =[0.009974577250615 0.000583450886642 -0.000409137793886 1.209811172485352;-0.000544623572142 0.009944216583374 0.000903294917300 -0.541967926025391;0.000459558305524 -0.000878715884589 0.009950711761376 0.029733953475952;0 0 0 1];
HT_marker =HT_marker*10^2; 
HT_marker(4,4) = 1;

% 
% HT_probe =
% 
%    1.0e+02 *
% 
%   Columns 1 through 3
% 
%   -0.008472358621040   0.000091498731631  -0.005311380929532
%   -0.000629539017062  -0.009945351029403   0.000832870654989
%   -0.005274734118653   0.001040010040363   0.008431818255481
%                    0                   0                   0
% 
%   Column 4
% 
%    2.391045684814453
%   -0.481037788391113
%    0.147910709381104
%    0.010000000000000
%    
 HT_probe1 = [-0.008472358621040 0.000091498731631 -0.005311380929532 2.391045684814453;-0.000629539017062 -0.009945351029403  0.000832870654989 -0.481037788391113;-0.005274734118653 0.001040010040363 0.008431818255481 0.147910709381104;0 0 0 1];
 HT_probe1 = HT_probe1*10^2;
 HT_probe1(4,4)=1;

% 
% HT_probe =
% 
%    1.0e+02 *
% 
%   -0.009998957530032   0.000054825273849  -0.000133575828538   1.263274536132813
%   -0.000071342811058  -0.009918858471452   0.001269313525734  -1.238341598510742
%   -0.000125532927683   0.001270134171121   0.009918215599160   0.174238567352295
%                    0                   0                   0   0.010000000000000
                   
 HT_probe2=[-0.009998957530032 0.000054825273849 -0.000133575828538 1.263274536132813;-0.000071342811058 -0.009918858471452 0.001269313525734 -1.238341598510742;-0.000125532927683 0.001270134171121 0.009918215599160 0.174238567352295;0 0 0 1]*10^2;
 HT_probe2(4,4) =1;
 
 
 
 
% HT_probe =
% 
%   -0.999302782323201   0.026871031373058   0.025920974404091  -3.947761774063110
%   -0.024344378729772  -0.995340407118003   0.093299652638316 -40.604423522949219
%    0.028307251109403   0.092603572453319   0.995300596756333  11.295743942260742
%                    0                   0                   0   1.000000000000000

HT_probe3 = [-0.999302782323201   0.026871031373058   0.025920974404091  -3.947761774063110;-0.024344378729772  -0.995340407118003   0.093299652638316 -40.604423522949219; 0.028307251109403   0.092603572453319   0.995300596756333  11.295743942260742;0 0 0 1];
 



% HT_probe =
% 
%    1.0e+02 *
% 
%   -0.000051153073344  -0.009999855310579   0.000016647239379   1.221812667846680
%    0.009600678823753  -0.000053767691372  -0.002797154832773   0.230246334075928
%    0.002797203869264   0.000001674173227   0.009600814950353   0.056256632804871
%                    0                   0                   0   0.010000000000000


HT_probe4 = [-0.000051153073344  -0.009999855310579   0.000016647239379   1.22181266784668; 0.009600678823753  -0.000053767691372  -0.002797154832773   0.230246334075928; 0.002797203869264   0.000001674173227   0.009600814950353   0.056256632804871;0 0 0 1]*10^2;
HT_probe4(4,4) =1;




% 2D PLOT FOR MARKER 
% Quiver(Xpnt Xpnt,Ypnt Ypnt,Xmag1, Xmag2,Ymag1 Ymag2)
quiver(HT_marker([1 1],4)',HT_marker([2 2],4)',HT_marker(1,1:2),HT_marker(2,1:2))
text(HT_marker(1,4)+HT_marker(1,1:2),HT_marker(2,4)+HT_marker(2,1:2),{'x','y'})
title('2D location of marker in GCS')




%3D PLOT FOR MARKER 
quiver3(HT_marker([1 1 1],4)',HT_marker([2 2 2],4)',HT_marker([3 3 3],4)',HT_marker(1,1:3),HT_marker(2,1:3),HT_marker(3,1:3))
text(HT_marker(1,4)+HT_marker(1,1:3),HT_marker(2,4)+HT_marker(2,1:3),HT_marker(3,4)+HT_marker(3,1:3),{'x','y','z'})
title('3D location of marker in GCS')

 
% 2D PLOT OF MARKER LOCATION AND DIGITIZED POINTS
plot(HT_marker(1,4)/10,HT_marker(2,4)/10,'x')
hold on
plot(HT_probe1(1,4)/10,HT_probe1(2,4)/10,'x')
plot(HT_probe2(1,4)/10,HT_probe2(2,4)/10,'x')
plot(HT_probe3(1,4)/10,HT_probe3(2,4)/10,'x')
plot(HT_probe4(1,4)/10,HT_probe4(2,4)/10,'x')
xlim([-2 25])
ylim([-15 15])
title('Marker and Respective Points in GCS')
xlabel('X position in cm')
ylabel('Y position in cm')


        %% Transforming to get tip of pointer in LCS
        
        
        %This if for when tip is 10cm in x and 5cm in down in y away fronm
        %GCS
        
        %Tip is about same in x and -5 y as lCS
        
        
        
        %    1.0e+02 *
% 
%    0.009975976794355   0.000572612187871  -0.000389874698840   1.207168350219727
%   -0.000537520656239   0.009948634712389   0.000857752239030  -0.541205215454102
%    0.000436988034861  -0.000834735072790   0.009955513990530   0.029542670249939
%                    0                   0                   0   0.010000000000000

     
  HT_marker =[0.009975976794355   0.000572612187871  -0.000389874698840   1.207168350219727;  -0.000537520656239   0.009948634712389   0.000857752239030  -0.541205215454102;   0.000436988034861  -0.000834735072790   0.009955513990530   0.029542670249939;0 0 0 1]*10^2;
  HT_marker(4,4) =1 ;

% 
% HT_probe =
% 
%    1.0e+02 *
% 
%    0.009997543049848   0.000221583560696   0.000005804485998   1.205878829956055
%   -0.000220237049375   0.009900356631282   0.001390839392424  -3.002082824707031
%    0.000025072066349  -0.001390625506405   0.009902804253969   0.407292633056641
%                    0                   0                   0   0.010000000000000


      
 HT_probe = [0.009997543049848   0.000221583560696   0.000005804485998   1.205878829956055; -0.000220237049375   0.009900356631282   0.001390839392424  -3.002082824707031;0.000025072066349  -0.001390625506405   0.009902804253969   0.407292633056641;0 0 0 1]*10^2;
 HT_probe(4,4)=1;

 
 
% XP =
% 
%    1.0e+02 *
% 
%    0.005840000000000
%    1.721680000000000
%   -0.068890000000000
%    0.010000000000000
%         
%         
         
XP= [ 0.005840000000000;1.721680000000000;-0.068890000000000;1]*10^2;
   

      
    



%% TESTING QUAT,BL HTs

load('MetriaData')

metdata = metdata1;

markeridx = find(metdata==73);

probeidx = find(metdata==9);

quat_RB =metdata(markeridx(1)+(4:7));
size(quat_RB) ;
quat_pointer = metdata(probeidx(1)+(4:7));

quat_RB= circshift(quat_RB,1,2); % added to compensate for quaternion shifted by 1 -- needed to update for 2014 matlab
quat_pointer = circshift(quat_pointer,1,2);

% XYZ point 
% P_RB = rand(1,3)'; % for testing comment out 
% P_pointer = rand(1,3)' % testing comment out
P_RB = metdata(:,markeridx(1)+(1:3))';
P_pointer = metdata(:,probeidx(1)+(1:3))';

% % Each quaternion represents a 3D rotation and is of the form 
% % q = [w(SCALAR REAL) qx qy qz]
% 
%  HT_UDP = quat2tform(Quat_UDP);
%  HT_UDP(1:3,4) = P;
%  HT_UDP
% 
% Now have HT matrix like is outout from MOCAP
%KCS 2.9.21 need to convert to HT from Quaternion without quat2tform for
%MATLAB 2014
% HT_marker = quat2tform(quat_RB);
HT_marker = Quaternion2tForm(quat_RB);
HT_marker(1:3,4,:) = P_RB;

HT_marker %CONFIRMED JIVES WITH MOCAP!!!! 2.11.21


% HT_probe = quat2tform(quat_pointer) ; 
HT_probe = Quaternion2tForm(quat_pointer);
HT_probe(1:3,4,:) = P_pointer;
HT_probe
% confirmed with MOCAP 2.15.21        
        




 %HT marker in GCS
  TRB_G = HT_marker;
        
  % offset of the tip of the pointer tool from the marker in that
  % markers cs
  
  load('Marker9Offset.mat');
 
  XP = ID9;

  %Getting tip of pointer tool in GCS -CORRECT!!!!
  Ptip_G =HT_probe*XP;
       
  %GCS to RB frame
   TG_RB = TRB_G';
        
   %Tip of pointer tool in LCS - DOES NOT MAKE SENSE
    Ptip_RB = TG_RB*Ptip_G
        
   %Getting RB marker in it's own CS IE LCS
    PRB_RB = TG_RB*TRB_G(:,4);
       







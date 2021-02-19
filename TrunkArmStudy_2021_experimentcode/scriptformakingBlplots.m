%% SCRIPT for making plots of known points 

%   HT_marker % gives HT of marker in GCS
%% 

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
%% 




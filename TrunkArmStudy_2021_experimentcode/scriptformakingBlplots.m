%% SCRIPT for making plots of known points 

%   HT_marker % gives HT of marker in GCS
%% 
% 
% 
% HT_marker =
% 
%    1.0e+02 *
% 
%   -0.000654743414347   0.009820289841634   0.001770089965981   1.198563385009766
%   -0.009978481261399  -0.000638139345697  -0.000150631641397  -0.484770622253418
%   -0.000034968232513  -0.001776143463173   0.009840939570028  -0.267241516113281
% %                    0                   0                   0   0.010000000000000
% % 
% % HT_probe1 =
% 
%    1.0e+02 *
% 
%   -0.009268580879365  -0.000284798680313  -0.003743300441371   2.387471008300781
%    0.000149419523860  -0.009991267523385   0.000390188521156  -0.469989967346191
%   -0.003751144130604   0.000305717169692   0.009264742561107  -0.380061416625977
%                    0                   0                   0   0.010000000000000
% 
% HT_probe2 =
% 
%    1.0e+02 *
% 
%   -0.009761817700496  -0.000227948860101  -0.002157534356495   1.188160324096680
%    0.000080586481292  -0.009975885250640   0.000689361505371  -1.202484130859375
%   -0.002168045433405   0.000655555324311   0.009740114281437  -0.183494586944580
%                    0                   0                   0   0.010000000000000
% 
%                    

%                    
%   HT_probe4 =
% 
%    1.0e+02 *
% 
%    0.000507982515199  -0.009815910321245   0.001841156791130   1.241983261108399
%    0.009421740935100  -0.000140450975948  -0.003348293785679   0.249796485900879
%    0.003312514379759   0.001904777700580   0.009241161744892  -0.207185153961182
%                    0                   0                   0   0.010000000000000
% 
% 
% HT_probe =
% 
%   -0.975198975060845   0.049525304935994   0.215717878747388   3.173547506332398
%   -0.053151396147325  -0.998525468175685  -0.011037141483095 -40.681392669677734
%    0.214853178072529  -0.022229115491279   0.976393352239050   2.539394378662109
%                    0                   0                   0   1.000000000000000

%plot(11.99,-4.85,'x')
quiver(11.99,-4.85,-.06,-1)
 quiver(11.99,-4.85,1,-.06)
 quiver(11.99,-4.85,.17,-.015)
% 
% plot(23.9,-4.7,'x') 
% quiver(23.9,-4.7,-.9,.01)
% quiver(23.9,-4.7,-.02,-.9)
% quiver(23.9,-4.7,-.4,.03)
% 
% 
% plot(11.9,-12,'x') 
% quiver(11.9,-12,-.9,.008) 
% quiver(11.9,-12,-.02,-.9) 
% quiver(11.9,-12,-.2,.06)
% 
% 
% plot(.32,-4.07,'x')
% quiver(.32,-4.07,.05,.94) 
% quiver(.32,-4.07,-.9,-.01)
% quiver(.32,-4.07,.1,-.3)
%  
%  
% plot(12.4,2.5,'x')
% quiver(12.4,2.5,-.97,-.05)
% quiver(12.4,2.5,-.05,-.1)
% quiver(12.4,2.5,.216,-.01)
% 
%  axis([0 25 -15 10])
title('Marker and Respective Points in GCS')
%% 

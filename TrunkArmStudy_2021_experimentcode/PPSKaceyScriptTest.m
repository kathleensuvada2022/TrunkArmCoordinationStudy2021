%% Script for PPS system

%after initialize data
    % Plot baseline (contourf)

    % 11.6.2020 to reshape and transpose data matrix so elements
    %arranged in order and orientation as the pressure mat
    
    %mat 1 myhandles.pps.

newdatamat1 = ans.data_out(1:5000,1:256);
avgbaselinemat1 = mean(newdatamat1);
avgbaselinemat1 = reshape(avgbaselinemat1,16,16);
avgbaselinemat1 = reshape(avgbaselinemat1',16,16);
avgbaselinemat1 =flip(avgbaselinemat1);


    %mat 2

newdatamat2 =ans.data_out(1:5000,257:end);
avgbaselinemat2 = mean(newdatamat2);
avgbaselinemat2 = reshape(avgbaselinemat2,16,16);
avgbaselinemat2 = reshape(avgbaselinemat2',16,16);
avgbaselinemat2 =flip(avgbaselinemat2);


figure
subplot(2,1,1)
contourf(avgbaselinemat1,'--')
title('Pressure Mat 1')
colorbar
subplot(2,1,2)
contourf(avgbaselinemat2,'--')
title('Pressure Mat 2')
colorbar
    
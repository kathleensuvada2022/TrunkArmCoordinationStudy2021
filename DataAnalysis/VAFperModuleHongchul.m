
% Computation for variance accounted for per module 

Recon1 = nmf(4).W(:,1)*nmf(4).C(1,:);
EMG;
err = EMG - Recon1;
VAF1 = (1-sum(sum(err.^2))/sum(sum(EMG.^2)))*100;
function ursqr = rsqr_uncentered(data,data_rec)
% This function calculates the uncetered correlation coefficient using "Cluster" method.  
%
% Syntax:   r_sqr = rsqr_uncentered(data,data_rec)
%
% Input:
% data      Array   matrix of observed data  (e.g., data = [mus pert_dir])
% data_rec  Array   matrix of reconstructed/predicted data (e.g., data_rec = [mus pert_dir])
%
% Output:
% ursqr     Array   matrix with uncentered correlation coefficients
%
% Calls:
% std_mean0.m 
%       
% Created: May 24, 2006 (Gelsy Torres-Oviedo)
% Last Modified: July 10, 2006 (Torrence Welch)
% Last Modification: fix ursqr calculation

% Shift dimensions for regression purposes data magnitudes in rows and data channels in columns
warning off
data = data';
data_rec = data_rec';

% Zar book method p. 334
dim_data = size(data);
for i = 1:dim_data(2)
    X = [data(:,i) data_rec(:,i)];
    n = length(X);
    ursqr(i) = sum(prod(X,2))^2 / (sum(data(:,i).^2)*sum(data_rec(:,i).^2)); %regression sum of squares/total sum of squares
end

ursqr = ursqr';
return
%========================
end %rsqr_uncentered.m
function y = meanfilt(x,n)

%MEANFILT  One dimensional mean filter.
%   Y = MEANFILT(X,N) returns the output of the order N, one dimensional 
%   moving average 2-sided filtering of vector X.  Y is the same length
%   as X;
%
%   If you do not specify N, MEANFILT uses a default of N = 3.

%   Author(s): Ana Maria Acosta, 2-26-01

if nargin < 2
   n=3;
end
if all(size(x) > 1)
    y = zeros(size(x));
    for i = 1:size(x,2)
        y(:,i) = meanfilt(x(:,i),n);
    end
    return
end

% Two-sided filtering to avoid phase shifts in the output
y=filter22(ones(n,1)/n,x,2);

% transpose if necessary
if size(x,1) == 1  % if x is a row vector ...
    y = y.';
end

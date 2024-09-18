function [W,H,err,stdev]=NNMF_stacie_May2013(V,r,flag)
% NNMF: Given a nonnegative matrix V, NNMF finds nonnegative matrix W 
%       and nonnegative coefficient matrix H such that V~WH. 
%       The algorithm solves the problem of minimizing (V-WH)^2 by varying W and H
%       Multiplicative update rules developed by Lee and Seung were used to solve 
%       optimization problem. (see reference below) 
%          D. D. Lee and H. S. Seung. Algorithms for non-negative matrix
%          factorization. Adv. Neural Info. Proc. Syst. 13, 556-562 (2001)
% Input: 
%
% V Matrix of dimensions n x m  Nonnegative matrix to be factorized   
% r Integer                     Number of basis vectors to be used for factorization
%                               usually r is chosen to be smaller than n or m so that 
%                               W and H are smaller than original matrix V
% flag                flag == 1; scale the input data to have unit variance 
%                     flag == 2; scale the input data to the unit variance scaling of a different data set
% 
% Output:
%
% W    Matrix of dimensions n x r  Nonnegative matrix containing basis vectors
% H    Matrix of dimensions r x m  Nonnegative matrix containing coefficients
% err  Integer                     Least square error (V-WH)^2 after optimization convergence  
% 
% Created: May 14, 2013 by SAC
% Last modified:
% Last modification: 

V = V.*(V>0); % Any potential negative entrie in data matrix will be set to zero

test=sum(V,2); % Any potential muscle channnel with only zeros is not included in the iteration 
index=find(test~=0);
ind=find(test==0);
Vnew_m=V(index,:);

test_cond=sum(V,1); % Any potential condition with only zeros is not included in the iteration 
index_cond=find(test_cond~=0);
ind_cond=find(test_cond==0);
Vnew=Vnew_m(:,index_cond);

%If attempting to extract more synergies than remaining
%muscles, extract only the number of synergies equal to number of muscles
[nummus,dum]=size(Vnew);
if r>nummus
    difference=r-nummus;
    rtemp=r-difference;
    r=rtemp;
end

% Scale the input data to have unit variance %%%%%%%%%
if flag ==1;
    stdev = std(Vnew'); %scale the data to have unit variance of this data set
elseif flag ==2;
    global stdev % use this if you want to use the stdev (unit variance scaling) from a different data set
end

Vnew = diag(1./stdev)*Vnew;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = statset('MaxIter',1000,'TolFun',1e-6,'TolX',1e-4);
[W,H,err] = nnmf(Vnew,r,'alg','mult','rep',50,'options',opts);
% [W,H,err] = nnmf(Vnew,r,'alg','mult','rep',50);


% Re-scale the original data and the synergies; add in zero rows; calculate 
% final error.

%undo the unit variance scaling so synergies are back out of unit variance
%space and in the same scaling as the input data was
Vnew = diag(stdev)*Vnew;
W = diag(stdev)*W;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Synergy vectors normalization  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m=max(W);% vector with max activation values 
for i=1:r
    H(i,:)=H(i,:)*m(i);
    W(:,i)=W(:,i)/m(i);
end


% Set to zero the columns or rows that were not included in the iteration
[n_o,m_o]=size(V);

Hnew=[];
Wnew=[];
for l=1:length(ind_cond)
    if ind_cond(l)==1
        Hnew=[zeros(r,1) H];
        H=Hnew;
    elseif ind_cond(l)==m_o
        Hnew=[H zeros(r,1)];
        H=Hnew;
    else 
        for k=1:m_o
            if ind_cond(l)==k
                Hnew=[H(:,1:k-1) zeros(r,1) H(:,k:end)];
                H=Hnew; break
            else
                Hnew=H;
            end
        end
    end
end
for l=1:length(ind)
    if ind(l)==1
        Wnew=[zeros(1,r); W];
        W=Wnew;
    elseif ind(l)==n_o
        Wnew=[W; zeros(1,r)];
        W=Wnew;
    else 
        for k=1:n_o
            if ind(l)==k
                Wnew=[W(1:k-1,:); zeros(1,r); W(k:end,:)];
                W=Wnew; break
            else
                Wnew=W;
            end
        end
    end
end
end % function NNMF_stacie_May2013.m
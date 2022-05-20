% K. Suvada. May 2022 

% CleanupCOP: Function to omit COP values that deviate beyond the average
% of the samples until the start of the reach. Also omits if negative. mat
% 2

function [CleanCOP] = CleanupCOP(COP,startSamp)


[Omit_COP col]  = find(abs(COP)< nanmean(COP(1:startSamp,:))/2);
[Omit_COP2 col]  = find(abs(COP)> 1.5*nanmean(COP(1:startSamp,:)));
[Omit_COP3 col]  = find(COP <0);

Omit_COP = [Omit_COP; Omit_COP2;Omit_COP3];

if isempty(Omit_COP)
  CleanCOP= COP;

    
else 
  COP(Omit_COP,:) =nan;
  CleanCOP= COP;

end

end


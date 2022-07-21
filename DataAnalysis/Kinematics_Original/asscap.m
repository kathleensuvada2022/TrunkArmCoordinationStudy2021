  function[S] =  asscap(aa,ts,ai)
% function[S] =  asscap(aa,ts,ai)                                          %
% In deze functie wordt het lokale assenstelsel berekend van de scapula.   %
% Input :                                                                  %
%        aa,ts & ai in kolomvectoren                                       %
% Output :                                                                 %
%        S = [Xs,Ys,Zs] in kolomvectoren                                   %
%                                                                          %
% Oorsprong   : AA-gewricht.                                               %
% Lokale X-as : as door TS en Aa.                                          %
% Lokale Z-as : as loodrecht op X-as  uit het vlak (AA,TS,AI).              %
% Resultaat is weergegeven in kolomvectoren
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[m,n] = size(aa);

S=[];

for I=1:n

    AA = aa(1:3,I);
    TS = ts(1:3,I);
    AI = ai(1:3,I);

    xs = (AA-TS) / norm(AA-TS);
    zhulp = cross(xs,(AA-AI));
    zs = zhulp/norm(zhulp);
    ys = cross(zs,xs);

    s = [xs,ys,zs];

    [S]=[S;s];
end



%%
S=[];
    AC = ac(1:3,I);
    TS = ts(1:3,I);
    AI = ai(1:3,I);

    xs = (AC-TS) / norm(AC-TS);
    zhulp = cross(xs,(AC-AI));
    zs = zhulp/norm(zhulp);
    ys = cross(zs,xs);

    s = [xs,ys,zs];

    [S]=[S;s];
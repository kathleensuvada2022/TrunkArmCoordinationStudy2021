  function gh=ghest(ac,aa,ts,ai)
% function gh=ghest(ac,aa,ts,ai)
% schatten van de positie van GH uit de posities van AC,AA,TS & AI
% met behulp van regressie vergelijkingen
% door Leonard Rozendaal

Rsca=asscap(ac,ts,ai);
Rsca=Rsca*diag([-1 -1 1]);
Osca=(ac+aa)/2;

ac=Rsca'*(ac-Osca);
aa=Rsca'*(aa-Osca);
ts=Rsca'*(ts-Osca);
ai=Rsca'*(ai-Osca);

lacaa=norm(ac-aa);
lacts=norm(ac-ts);
lacai=norm(ac-ai);
ltsai=norm(ts-ai);

% ghrel=[ ...
%   [  lacaa lacts       ltsai]*[     0.45 -0.28        0.18]';
%   [1       lacts lacai      ]*[-70        0.73 -0.28      ]';
%   [        lacts lacai ltsai]*[          -0.51  0.42 -0.38]'];

  ghrel=[ ...
    [1       lacts lacai      ]*[  9.8       -0.399  0.223      ]';
    [1       lacts lacai      ]*[-69.6        0.731 -0.277      ]';
    [1       lacts lacai      ]*[ -2.7       -0.297  0.065      ]'];

  ghrel=[ ...
    [1       lacts lacai      ]*[ 10       -0.40  0.22      ]';
    [1       lacts lacai      ]*[-70        0.73 -0.28      ]';
    [1       lacts lacai      ]*[ -3       -0.30  0.06      ]'];

gh=(Rsca*ghrel)+Osca;

%% Kacey Added Below to convert BLS back - July 2022


ac=(Rsca*ac)+Osca;
aa=(Rsca*aa)+Osca;
ts=(Rsca*ts)+Osca;
ai=(Rsca*ai)+Osca;

  
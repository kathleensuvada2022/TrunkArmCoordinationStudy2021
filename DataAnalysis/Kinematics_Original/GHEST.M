  function gh=ghest(ac,aa,ts,ai)
% function gh=ghest(ac,aa,ts,ai)
% schatten van de positie van GH uit de posities van AC,AA,TS & AI
% met behulp van regressie vergelijkingen
% door Leonard Rozendaal

Rsca=asscap(ac,ts,ai);

Rsca=Rsca*diag([-1 -1 1]);%Rotate 180 about Z axis

%%
Osca=(ac+aa)/2;

ac=Rsca'*(ac-Osca);
aa=Rsca'*(aa-Osca);
ts=Rsca'*(ts-Osca);
ai=Rsca'*(ai-Osca);
pc=Rsca'*(pc-Osca); %Kacey added
gh_dig=Rsca'*(gh_dig-Osca); %Kacey added

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

%% Kacey Plotting - in BONE

figure(31)
plot3(ghrel(1), ghrel(2),ghrel(3),'*')
text(ghrel(1), ghrel(2),ghrel(3),'GH NOPC')
hold on 
plot3(pc(1),pc(2),pc(3),'o')
text(pc(1),pc(2),pc(3),'PC')
hold on
plot3(aa(1),aa(2),aa(3),'o')
text(aa(1),aa(2),aa(3),'AA')
plot3(ai(1),ai(2),ai(3),'o')
text(ai(1),ai(2),ai(3),'AI')
plot3(ac(1),ac(2),ac(3),'o')
text(ac(1),ac(2),ac(3),'AC')
plot3(ts(1),ts(2),ts(3),'o')
text(ts(1),ts(2),ts(3),'TS')
plot3(gh_dig(1),gh_dig(2),gh_dig(3),'o')
text(gh_dig(1),gh_dig(2),gh_dig(3),'GhDIG')

%Plotting the Scapular Polygon
plot3([ai(1) ts(1)],[ai(2) ts(2)],[ai(3) ts(3)],'r') % line between AI and TS
plot3([ai(1) aa(1)],[ai(2) aa(2)],[ai(3) aa(3)],'r') % line between AI and AA
plot3([ts(1) ac(1)],[ts(2) ac(2)],[ts(3) ac(3)],'r') % line between TS and AC
 plot3([ac(1) aa(1)],[ac(2) aa(2)],[ac(3) aa(3)],'r') % line between AC and AA
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

%% Kacey Added Below to convert BLS back - July 2022

gh=(Rsca*ghrel)+Osca; 
ac=(Rsca*ac)+Osca;
aa=(Rsca*aa)+Osca;
ts=(Rsca*ts)+Osca;
ai=(Rsca*ai)+Osca;

  



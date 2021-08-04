%%
mypps = PPS('TactArray_Trunk',pwd);
mypps.Initialize(pwd);
mypps.StartPPS;

%%
tic
while toc<2; end
[~,ppst,ppsdata]=mypps.ReadData;

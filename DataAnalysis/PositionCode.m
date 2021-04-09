%% ACT 3D position Data x and y plane

% open target_nsakjtable.mat

x = trialdata(4,:);
y = trialdata(5,:);

y = y(2:497);
x = x(2:497);

x = cell2mat(x);
y = cell2mat(y);




%% End point position data 


%loading in the table condition
load('Target_03_1_table.mat')
tfdata = trialData;
load('Target_06_1_table.mat')
trdata = trialData;
xtf = tfdata(3,2:497);

%loading in the loading condition
load('Target_06_1_table.mat')

ytf = tfdata(4,2:497);
xtf = cell2mat(xtf);
ytf = cell2mat(ytf);

plot(-xtf,-ytf)
hold on
xtr = trdata(3,2:438);
ytr = trdata(4,2:438);
xtr= cell2mat(xtr);
ytr= cell2mat(ytr);
plot(-xtr,-ytr);
xtfl = cell2mat(xtfl);



ytfl = cell2mat(ytfl);
xtrl = cell2mat(xtrl);
ytrl = cell2mat(ytrl);
plot(-xtfl,-ytfl)
plot(-xtrl,-ytrl);
title('Reach on the table condition')
xlabel('X position')
ylabel('Y position')
legend('Trunk Free Table','Trunk Restrained Table','Trunk Free Load','Trunk Restrained Load')



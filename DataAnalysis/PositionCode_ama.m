%% ACT 3D position Data x and y plane

% open target_nsakjtable.mat

x = trialdata(4,:);
y = trialdata(5,:);

y = y(2:497);
x = x(2:497);

x = cell2mat(x);
y = cell2mat(y);


%% End point position data 
% idx=3:4; % End effector position
idx=16:17; % Finger tip position


%loading in the table condition
load('Target_03_1_table.mat')
n=length(trialData)-1;
data=zeros(900,12);

data(1:n,1:2)=cell2mat(trialData(3:4,2:end))';

load('Target_06_1_table.mat')
n=length(trialData)-1;
data(1:n,3:4)=cell2mat(trialData(3:4,2:end))';

%loading in the loading condition
load('Target_04_1_mvt_20.mat')
n=length(trialData)-1;
data(1:n,5:6)=cell2mat(trialData(3:4,2:end))';
data2=cell2mat(trialData(3:4,2:end))';

%loading in the loading condition
load('Target_07_1_mvt_20.mat')
n=length(trialData)-1;disp(n)
data(1:n,7:8)=cell2mat(trialData(3:4,2:end))';
data3=cell2mat(trialData(3:4,2:end))';

%loading in the loading condition
load('Target_05_1_mvt_40.mat')
n=length(trialData)-1;
data(1:n,9:10)=cell2mat(trialData(3:4,2:end))';

%loading in the loading condition
load('Target_08_1_mvt_40.mat')
n=length(trialData)-1;
data(1:n,11:12)=cell2mat(trialData(3:4,2:end))';

figure(1)
idx1=200:269; data(:,1:2)=data(:,1:2)-repmat(data(idx1(1),1:2),900,1);
idx2=137:195; data(:,3:4)=data(:,3:4)-repmat(data(idx2(1),3:4),900,1);
subplot(1,3,1),plot(-data(idx1,1),-data(idx1,2),'b',-data(idx2,3),-data(idx2,4),'r','LineWidth',2)
title('Table')
xlabel('x')
ylabel('y')
axis 'equal'

idx1=120:200; data(:,[1 2]+4)=data(:,[1 2]+4)-repmat(data(idx1(1),[1 2]+4),900,1);
idx2=580:650; data(:,[3 4]+4)=data(:,[3 4]+4)-repmat(data(idx2(1),[3 4]+4),900,1);
subplot(1,3,2),plot(-data(idx1,5),-data(idx1,6),'b',-data(idx2,7),-data(idx2,8),'r','LineWidth',2)
title('20% SABD')
xlabel('x')
% ylim([-0.05 0.3])
axis 'equal'

idx1=126:194; data(:,[1 2]+8)=data(:,[1 2]+8)-repmat(data(idx1(1),[1 2]+8),900,1);
idx2=186:287; data(:,[3 4]+8)=data(:,[3 4]+8)-repmat(data(idx2(1),[3 4]+8),900,1);
subplot(1,3,3),plot(-data(idx1,9),-data(idx1,10),'b',-data(idx2,11),-data(idx2,12),'r','LineWidth',2)
title('40% SABD')
xlabel('x')
% ylim([-0.05 0.3])
axis 'equal'
legend('Trunk Free','Trunk Restrained')

figure(2)
subplot(321),plot(data(:,[1 2]))
subplot(322),plot(data(:,[3 4]))
subplot(323),plot(data(:,[1 2]+4))
subplot(324),plot(data(:,[3 4]+4))
subplot(325),plot(data(:,[1 2]+8))
subplot(326),plot(data(:,[3 4]+8))




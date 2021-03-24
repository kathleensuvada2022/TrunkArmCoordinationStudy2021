
% ACT-3D data saved
% Column 1 time in s
% Column 2-4 hand position (3rd MCP)
% Column 5-7 robot.endEffectorPosition
% Column 8 robot.endEffectorRotation(1);
% Column 9-11 robot.endEffectorVelocity;
% Column 12-14 robot.endEffectorForce;
% Column 15-17 robot.endEffectorTorque;

% myhandles.exp.origin(1)=myhandles.exp.midpos(1);
% myhandles.exp.origin(2:3)=myhandles.exp.hometar(2:3)-[0.05;0];

% % load('D:\usr\Ana Maria Acosta\Box Sync\KACEY\Data\RTIS1002\AMA3521\Trials\rtsi1002_Setup')
% load('/Users/kcs762/Northwestern University/Anamaria Acosta - TACS/Data/RTIS1002/AMA3521/Trials/rtsi1002_Setup') %for Kacey's Comp
% load('/Users/kcs762/Northwestern University/Anamaria Acosta - TACS/Data/RTIS1002/AMA3521/Trials/trials3')%For Kacey Comp
% % load('D:\usr\Ana Maria Acosta\Box Sync\KACEY\Data\RTIS1002\AMA3521\Trials\trials3')
% % setup.exp.arm='left';
% % load('D:\usr\Ana Maria Acosta\Box Sync\KACEY\Data\RTIS1003\Right\RTIS1001_setup')
% % load('D:\usr\Ana Maria Acosta\Box Sync\KACEY\Data\RTIS1003\Right\trials1')
% 
% figure(1)
% subplot(311),plot(data.act(:,1),data.act(:,2:4))
% ylabel('MCP3 Position(m)'); legend('x','y','z')
% subplot(312),plot(data.act(:,1),data.act(:,5:7))
% ylabel('EE Position (m)'); 
% % subplot(313),plot(data.act(:,1),data.act(:,8))
% subplot(313),plot(data.act(:,1),rad2deg(unwrap(data.act(:,8))))
% ylabel('Forearm angle (deg)'); 

%%
Pmcp=gethandpos(data.act(:,5:7),unwrap(data.act(:,8)),setup.exp);

figure(2)
if strcmp(setup.exp.arm,'right')
plot(data.act(:,2),-data.act(:,3),'c.',data.act(1,2),-data.act(1,3),'r+',...
    data.act(:,5),-data.act(:,6),'.',Pmcp(:,1),-Pmcp(:,2),'r.',...
    setup.exp.shpos(1),-setup.exp.shpos(2),'r^',setup.exp.hometar(1),-setup.exp.hometar(2),'ro')
else
plot(data.act(:,2),data.act(:,3),'c.',data.act(1,2),data.act(1,3),'r+',...
    data.act(:,5),data.act(:,6),'.',Pmcp(:,1),Pmcp(:,2),'r.');
%     setup.exp.shpos(1),setup.exp.shpos(2),'r^',setup.exp.hometar(1),setup.exp.hometar(2),'ro')
end
axis 'equal'
% legend('MCP3','Start','End effector','MCP3 Computed','Shoulder','Home')
legend('MCP3','Start','End effector','MCP3 Computed')

return

%%
figure(3)
plot(data.act(:,5),-data.act(:,6),'.',Pmcp(:,1),-Pmcp(:,2),'r.')
axis 'equal'
legend('End effector','MCP3 Computed')



%% FUNCTIONS
function p=gethandpos(x,th,exp)
% x - ACT3D end effector position
% th - ACT3D end effector rotation
% exp - structure with experiment variables
% p - hand position column vector

[m,n]=size(x);
for i=1:m
    if strcmp(exp.arm,'right')
        p(i,:)=x(i,:)+transpose(rotz(th(i)+pi/2)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]');
        %     p=x(:)-rotz(th-3*pi/2)*[0 (exp.e2hLength-exp.ee2eLength)/100 0]';
    else
        p(i,:)=x(i,:)+transpose(rotz(th(i)-pi/2)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]');
        %     p=x(:)-rotz(th-2*pi)*[(exp.e2hLength-exp.ee2eLength)/100 0 0]';
    end
end
% p=p-exp.origin; % Correct for the origin once it's set


end

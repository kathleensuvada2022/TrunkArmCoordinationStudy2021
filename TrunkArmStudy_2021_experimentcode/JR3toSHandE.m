function [FMsh,FMe]=JR3toSHandE(FMraw,abd_angle,elb_angle,arm_length,fore_length,z_offset,arm,JR3mat)
% Function to transform the forces and moments from the JR3 coordinate system in volts to the
% shoulder and elbow coordinate systems in N, Nm
% Modified 11/9/05 by Ana Maria Acosta. Included JR3 model number information
% to determine the correct calibration matrix to use.
%
% USAGE
%   [FMsh,FMe]=JR3toSHandE(FMjr,abd_angle,elb_angle,arm_length,fore_length,z_offset,arm,sensmod,maxload)
% Inputs:
%   FMjr: [nsamp x 6] matrix with the raw forces and torques
%   abd_angle: arm abduction angle in radians.
%   elb_angle: elbow flexion angle in radians (from full extension).
%   arm_length: distance from elbow center of rotation to humerus center of rotation
%   fore_length: distance from middle of load cell to elbow center of rotation
%   z_offset: distance from middle of load cell to pro-supination axis of the forearm
%   arm: 'right' or 'left'
%   JR3mat: JR3 calibration matrix

% Decouple FM
[frows,fcol]=size(FMraw);
if (frows>fcol) FMraw=FMraw'; end

FMjr=(JR3mat*FMraw)';

% Convert to N and Nm if using old JR3
if JR3mat(4,4) > JR3mat(1,1)
    %             disp('just went into the converter A!');
    FMjr(:,1:3)=FMjr(:,1:3)*9.81/2.2;
    FMjr(:,4:6)=FMjr(:,4:6)*9.81/2.2*2.54/100;
end

% Convert to right hand coordinate system
FMjr(:,[3 6])=-FMjr(:,[3 6]);

% Rotated JR3
 FMjr(:,[1,2,4,5])=-FMjr(:,[1,2,4,5]);

% R = rotz(-pi/2)*rotx(-pi/2)*roty(pi);
% R = rotz(pi);
% newR = [R zeros(3,3);zeros(3,3) R];
% FMjr = FMjr*newR;

% Flip coordinate system to right arm if necessary
if strcmp(arm,'left')
    FMjr(:,[2 4 6])=-FMjr(:,[2 4 6]);
end

% Calculate the Jacobian to translate the forces from the center of the JR3 to the middle
% of the epicondyles by distance z_offset
Jjtoe=[eye(3), Px([0 0 -z_offset]);
    zeros(3,3) eye(3)];
FMjr=(Jjtoe'*FMjr')';

% Two step transformation: first to elbow coordinate system and then to shoulder coordinate system
% Retojr = Ry(pi/2-abd)*Rz(pi)
% Rstoe = Rx(pi/2-elbow)
% Calculate the jacobian from elbow coordinates to JR3 coordinates
% JR3 coordinates: x - down, y - along forearm toward hand, z - away from forearm
% Elbow coordinates: x - flexion, y - pronation
R=roty(pi/2-abd_angle)*rotz(pi);
%           R=roty(-abd_angle)*rotz(pi);
J=[R		Px([0 -fore_length 0])*R;
    zeros(3,3)  R];

FMe=(J'*FMjr')';

% Calculate the jacobian from shoulder coordinates to elbow coordinates
% Shoulder coordinates: x - flexion, y - abduction, z - external rotation
R=rotx(pi/2-elb_angle);
J=[R		Px([0 arm_length*sin(pi/2-elb_angle) -arm_length*cos(pi/2-elb_angle)])*R;
    zeros(3,3)  R];
FMsh=(J'*FMe')';

    function P=Px(r)
        P=[0 -r(3) r(2);
            r(3) 0  -r(1);
            -r(2) r(1) 0];
    end
    function [Rx]=rotx(th)
        % vormen van een rotatiematrix voor rotaties rond de x-as
        Rx(1,1)=1;
        Rx(2,2)=cos(th);
        Rx(2,3)=-sin(th);
        Rx(3,2)= sin(th);
        Rx(3,3)= cos(th);
    end

    function [Ry]=roty(th)
        % vormen van een rotatiematrix voor rotaties rond de y-as
        Ry(1,1)=cos(th);
        Ry(1,3)=sin(th);
        Ry(2,2)=1;
        Ry(3,1)=-sin(th);
        Ry(3,3)= cos(th);
    end

    function [Rz]=rotz(th)
        % vormen van een rotatiematrix voor rotaties rond de z-as
        Rz(1,1)=cos(th);
        Rz(1,2)=-sin(th);
        Rz(2,1)= sin(th);
        Rz(2,2)= cos(th);
        Rz(3,3)=1;
    end

end


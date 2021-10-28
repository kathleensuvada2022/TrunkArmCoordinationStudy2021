%% October 2021

% Don't use!!!! ADDED BACK TO ComputeEulerAngles_KS

% ADDED FROM ORIGINAL COMPUTE EULER ANGLES
% CODE FOR KACEY COMPUTES THE SEGMENTS RELATIVE 
% TO EACH OTHER THEN PASS INTO CALCEULERANGLES FUNCTION. GOAL TO OBTAIN
% ELBOW ANGLE BASED ON RELATIVE JOINT SEGMENTS (FOREARM AND HUMERUS)
  
AS = [


    if strcmp(reffr,'frame')
        %Use the frame as reference- makes rotation matrix for trunk all
        %ones, so it doesn't take into account rotations of trunk
        AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
        if strcmp(arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
    end
    
    gR = rotbones(AS); %absolute angles
    jR = rotjoint(AS); %relative angles
    
    %     blah = CalcEulerAng(TrunkCS,'XYZ')
    [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ',0); % Trunk
    [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX',0);  % Clavicle
    [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX',0);  % Scapula
    [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY',0); % Humerus
   
    [jANGLES(1:3,:,i)]=CalcEulerAng(jR(:,1:3),'XYZ',0); % Trunk
    [jANGLES(4:6,:,i)]=CalcEulerAng(jR(:,4:6),'YZX',0);  % Clavicle
    [jANGLES(7:9,:,i)]=CalcEulerAng(jR(:,7:9),'YZX',0);  % Scapula
    [jANGLES(10:12,:,i)]=CalcEulerAng(jR(:,10:12),'YZY',0); % Humerus
    %     [jANGLES(13:15,:,i)]=CalcEulerAng(jR(:,13:15),2);    % Forearm
    
    
    % **************************************************************
    if strcmp(reffr,'trunk')
        eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
    elseif strcmp(reffr,'frame')
        eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
    end


%Moved this outside the for loop because the direction was changing after
%every sample
if strcmp(arm,'left'),
    %     if strcmp(datast(1).arm,'left'),
    % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
    %         gANGLES = gANGLES';
    %         gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
    gANGLES([1,3,4,6,7,9,10,12],:)=-gANGLES([1,3,4,6,7,9,10,12],:);
    %         jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
end


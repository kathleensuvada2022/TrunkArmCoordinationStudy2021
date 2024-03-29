%% Trunk CS

% Function to create Trunk CS based on Kacey's Definition. 
% For the right arm, x is to the right, z is up and y is forwards. Using
% the Bls of the scapula in the marker cs, create a cs for the scapula in
% the marker frame. 

% Inputs: 
% - blmat: full bonylandmark data from participant's setup file. These are
% saved in the coordinate frame of the marker. 
% - arm: CS has two different definitions depending on if we are
% looking at the right or the left hand. Notice changed definition for left
% hand to mimic right hand. 

% Outputs:
% - TrunkCS: created CS of the Trunk for the participant. This is in
% MARKER frame or local CS.

% K. Suvada - 2022-2023


function TrunkCS = asthorho_K2022(blmat,arm,flag,partid)
%% Edited based on shifted CS for K.Suvada's Experiments
% Trunk BLS in Trunk Marker Frame

blmat= blmat{1,1}; %Grabbing just the trunk BLS from the BL file. 

BLnames_t = ["SC","IJ","PX","C7","T8"];

IJidx = find(BLnames_t=='IJ');
[SC,IJ,PX,C7,T8]=deal(blmat(:,IJidx-1),blmat(:,IJidx),blmat(:,IJidx+1),blmat(:,IJidx+2),blmat(:,IJidx+3)); % in Marker Local CS


BLs_lcs_t ={SC,IJ,PX,C7,T8};

%%
zt = (IJ(1:3)+C7(1:3))/2 - (PX(1:3)+T8(1:3))/2;
zt = zt/norm(zt);

blmat_th =[IJ(1:3);PX(1:3);C7(1:3);T8(1:3)]'; %For making a plane out of IJ, PX, C7,T8


% [A,DATAa,nvector,e]=vlak(blmat);
% xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end
% zt = cross(xhulp,yt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP
% % zt = cross(xhulp,yt);
% zt=zt/norm(zt);
% xt = cross(yt,zt); %SABEEN CHANGE: NEED DIM OF 3 FOR CP

[A,DATAa,nvector,e]=vlak(blmat_th); 


%xhulp is vector normal to the plane
xhulp = nvector;  if xhulp(1)<0 xhulp = -nvector;end
% yt = cross(xhulp,zt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 


%% For some participants, XHULP not pointing towards right- flip 

if strcmp(partid,'RTIS1003')
    
xhulp = -xhulp;

end


if strcmp(partid,'RTIS2001')
    if strcmp(arm,'Right')
        
        xhulp = -xhulp;
    end
end



if strcmp(partid,'RTIS2003')
    if strcmp(arm,'Left')
        
        xhulp = rotz(-90)*xhulp ; % KACEY- WHAT IS THIS?? PLS CHECK MAY 2023
    end
    
    if strcmp(arm,'Right')
        xhulp = -xhulp;
        
        
    end
end


if strcmp(partid,'RTIS2006')
    if strcmp(arm,'Right')
        
        xhulp = -xhulp;
    end
end


if strcmp(partid,'RTIS2007')
    if strcmp(arm,'Right')
        
        xhulp = -xhulp;
    end
end

if strcmp(partid,'RTIS2008')
    if strcmp(arm,'Right')
        
        xhulp = -xhulp;
    end
end

%%

%Kacey 10.4.21 flipping order of cross product for Y into the page 
% yt = cross(xhulp,zt(1:3)); %SABEEN CHANGE: NEED DIM OF 3 FOR CP???? 

yt = cross(zt(1:3),xhulp); %Kacey changed July 2022 (original line 31)
% zt = cross(xhulp,yt);

yt=yt/norm(yt);


%xt = cross(yt(1:3),zt);

%Redefined for Kacey 10.4.21
xt = cross(yt,zt);


%%
% t = [xt,yt,zt];
t = [xt,yt,zt];



% yt = (IJ + C7)/2 - (T8 + PX)/2;  yt = yt/norm(yt);
% xt = cross(yt,T8-PX);  xt = xt/norm(xt);
% zt = cross(xt,yt);


%%
diff=norm(t)-1>=10*eps;
if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal to 1'), disp(diff), return; end

t = [t;0 0 0];
orign_trunk = [IJ(1:4)];

%Trunk Coordinate System in Marker CS
TrunkCS = [t orign_trunk];



%% Plotting Trunk CS and Bls in Marker Frame
if flag ==1
  figure(35)
%Plotting the BonyLandmarks and their Labels
for i = 1:length(BLnames_t)
    plot3(BLs_lcs_t{1,i}(1),BLs_lcs_t{1,i}(2),BLs_lcs_t{1,i}(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(BLs_lcs_t{1,i}(1),BLs_lcs_t{1,i}(2),BLs_lcs_t{1,i}(3),BLnames_t(i),'FontSize',14)
end

% Plotting Trunk CS
quiver3(TrunkCS ([1 1 1],4)',TrunkCS ([2 2 2],4)',TrunkCS ([3 3 3],4)',50*TrunkCS (1,1:3),50*TrunkCS (2,1:3),50*TrunkCS (3,1:3))
text(TrunkCS (1,4)+50*TrunkCS (1,1:3),TrunkCS (2,4)+50*TrunkCS (2,1:3),TrunkCS (3,4)+50*TrunkCS (3,1:3),{'X_T','Y_T','Z_T'})

plot3(0,0,0,'o')
text(0,0,0,'Marker','FontSize',14)
axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

title('Trunk CS and BLs in Marker CS','FontSize',16)  
    
end


end
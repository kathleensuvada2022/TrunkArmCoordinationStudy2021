%% RTIS2010 Redigitization 2021 Data

% Had participant who had the EM/EL/GH_dig on the wrong arm. Right Paretic
% arm needs to have EM/EL redone and created in Forearm CS. Then converted
% into Forearm Marker CS from Day 1--> convert to GCS Day 1. Creating
% Humerus CS in GCS at every time point of trial. Have code to center at
% EM/EL midpoint and compute in Forearm CS, but need to center at OL.

% K. Suvada 
% August,2023


%% Loading in BLs from Redigitization 2021 in their original marker CS
load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/RTIS2010/Right/BL.mat')

% Loading in Forearm BLS
Fore_Bls_ForeMarker = bl{1,4} ;
RS = Fore_Bls_ForeMarker(1,1:4)';
US = Fore_Bls_ForeMarker(2,1:4)';
OL = Fore_Bls_ForeMarker(3,1:4)';

%% Loading in EM/EL in Humerus Marker CS 
Hum_Bls_HumMarker = bl{1,3} ;
EM = Hum_Bls_HumMarker(1,1:4)';
EL = Hum_Bls_HumMarker(2,1:4)';
GH_Dig = Hum_Bls_HumMarker(3,1:4)';
%% Computing EM/EL in Forearm Coords - Need for Creating Forearm CS-Only Use if Centering at EM/EL Midpoint

% Setup File
partid = 'RTIS2010';
arm = 'Right';
filepath = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data','/',partid,'/',arm];
load([filepath '/' partid,'_','setup']);

% Loading in 2023 Trial Data
load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/RTIS2010_BLsRedoing/Right/trial1.mat')

x = data.met;

x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 
%% Only Use if Centering at EM/EL Midpoint
t = (x(:,2)-x(1,2))/89; 

[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  % forearm marker in GCS

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xhum=x(:,aidx:(aidx+6)); % humerus marker in GCS

%Forearm
Tftom = zeros(4,4,length(xfore));   
for i=1:length(xfore)
% forearm marker HT
Tftom(:,:,i) = quat2tform(circshift(xfore(i,4:7),1,2)); 
Tftom(1:3,4,i) = xfore(i,1:3)';  
end

%Humerus
Thtom=zeros(4,4,length(xhum));
for i =1:length(xhum)  
Thtom(:,:,i)= quat2tform(circshift(xhum(i,4:7),1,2));      
Thtom(1:3,4,i) = xhum(i,1:3)';    
end

%Finding when neither is NAN
idx=find(~isnan(Tftom(1,1,10:20)) & ~isnan(Thtom(1,1,10:20)));
idx = idx(1)+9; %finding where both NOT NANs

HT_Hum2Fore = inv(Tftom(:,:,idx))*Thtom(:,:,idx); % Hum to Fore Marker 
HT_Fore2Hum = inv(Thtom(:,:,idx))*Tftom(:,:,idx); % Hum to Fore Marker 

% Computing EM/EL in Forearm CS
%EM_ForearmCS = HT_Hum2Fore* EM;
%EL_ForearmCS = HT_Hum2Fore* EL;

% Redefining EM and EL to be the ones in Forearm CS
% 
% EM = EM_ForearmCS;
% EL = EL_ForearmCS;
%% Creating Forearm CS in Forearm Marker Frame


H_mid=(RS(1:3)+US(1:3))/2; %midpnt between RS and US
% H_mid_2=(EL(1:3)+EM(1:3))/2; % midpnt between EM and EL

zf = (OL(1:3)-H_mid) / norm(OL(1:3)-H_mid);

x= (RS(1:3)-US(1:3))/norm(RS(1:3)-US(1:3)); % from US to RS
yf =cross(zf,x); %flipped order because z in opposite direction
yf=(yf/norm(yf));

xf = cross (yf,zf);
xf = xf/norm(xf);

f = [xf yf zf];

f = [f;0 0 0];

org_fore = [OL(1:3) ;1]; %centering at OL bc EM and EL incorrect in original CS

%Forearm Coordinate System in Forearm Marker CS
ForeCS = [f org_fore]; % This is HT from F1 to MF1 (Forearm Bone CS to Forearm Marker CS Day 1)

%% Plotting Forearm CS with Humerus and Forearm BLs in Forearm Marker Frame

  figure(44)
%Plotting the BonyLandmarks and their Labels

    plot3(EL(1),EL(2),EL(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    text(EL(1),EL(2),EL(3),'EL','FontSize',14)


    plot3(EM(1),EM(2),EM(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(EM(1),EM(2),EM(3),'EM','FontSize',14)

    plot3(US(1),US(2),US(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(US(1),US(2),US(3),'US','FontSize',14)

    hold on
    plot3(RS(1),RS(2),RS(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(RS(1),RS(2),RS(3),'RS','FontSize',14)

    plot3(OL(1),OL(2),OL(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(OL(1),OL(2),OL(3),'OL','FontSize',14)

    plot3(MCP3(1),MCP3(2),MCP3(3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    text(MCP3(1),MCP3(2),MCP3(3),'MCP3','FontSize',14)

% % Plotting FORE CS at given Frame
% quiver3(ForeCS ([1 1 1],4)',ForeCS ([2 2 2],4)',ForeCS ([3 3 3],4)',50*ForeCS (1,1:3),50*ForeCS (2,1:3),50*ForeCS (3,1:3))
% text(ForeCS (1,4)+50*ForeCS (1,1:3),ForeCS (2,4)+50*ForeCS (2,1:3),ForeCS (3,4)+50*ForeCS (3,1:3),{'X_F','Y_F','Z_F'})

title('BLs with New EM and EL in Forearm Marker Frame 2021','FontSize',24)

% line between styloids
plot3([RS(1) US(1)],[RS(2) US(2)],[RS(3) US(3)])

axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')
%% Getting EM/EL in Humerus Day 1 - via trial data


EM_HumerusDay1 = HT_Fore2Hum*EMDay1; 
EL_HumerusDay1 = HT_Fore2Hum*ElDay1;

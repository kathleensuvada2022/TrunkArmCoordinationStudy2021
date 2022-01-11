%% NOV 2nd, 2021 - K. Suvada
% Script to Get EM and EL in Forearm CS based on trial data and BL file.
% Can be used then to created forearm CS and have the origin of the forearm
% cs be at the midpoint between medial and lateral epicondyles. 



partid = 'RTIS1006';
arm='Right';
trial ='trial4';
%
function [EM_Fore,EL_Fore]= ComputeEMELinForearmCS(partid,arm,trial)

filepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data','/',partid,'/',arm];

%loading in metria data 
trialdata = load([filepath '/' trial]);
x = trialdata.data.met;

load([filepath '/' partid,'_','setup']);

load([filepath '/' 'BL']);

%Organizing data by marker/bone and converting to HT instead of quaternions
%%
x(x==0)=NaN; %h Replace zeros with NaN
x = x(:,3:end); %omitting time and the camera series number
[nimag,nmark]=size(x);
nmark=(nmark)/8; 

t = (x(:,2)-x(1,2))/89; 
%% Getting HT in marker to global (during trial data) 
%Organizing Trial Data by Marker Number/ Bone 
[ridx,cidx]=find(x==setup.markerid(4));
fidx =cidx(1)+1;
xfore=x(:,fidx:(fidx+6));  

[ridx,cidx]=find(x==setup.markerid(3));
aidx =cidx(1)+1;
xhum=x(:,aidx:(aidx+6)); %extracting humerus marker

[ridx,cidx]=find(x==setup.markerid(2));
sidx=cidx(1)+1;
xshoulder=x(:,sidx:(sidx+ 6)); % extracting shoulder marker

[ridx,cidx]=find(x==setup.markerid(1)); 
tidx=cidx(1)+1;
xtrunk=x(:,tidx:(tidx+6)); %if ~isempty(tidx), xtrunk=x(:,tidx+7); else xtrunk=zeros(size(xhand));end


% Need to reshape 4X4XN
%Forearm
Tftom = zeros(4,4,length(xfore));   
for i=1:length(xfore)
% forearm marker HT
Tftom(:,:,i) = quat2tform(circshift(xfore(i,4:7),1,2)); 
Tftom(1:3,4,i) = xfore(i,1:3)';  
end

%Humerus
Thtom=zeros(4,4,length(xhum));
for i =1:length(xtrunk)  
Thtom(:,:,i)= quat2tform(circshift(xhum(i,4:7),1,2));      
Thtom(1:3,4,i) = xhum(i,1:3)';    
end

%% Getting the HT from Humerus MARKER to Forearm MARKER

%kacey's more complicated way
% for i = 10:20 % looping through frames 10-20 of trial until not NANs
%     
% if (isnan(Tftom(1,1,i))==0) %checking if first element is a NAN
%     if(isnan(Tftom(1,1,i))==0)%checking if first element is a NAN
%         HT_Hum2Fore = inv(Tftom(:,:,i))*Thtom(:,:,i); % Hum Marker in Forearm Marker CS
%     else 
%         break
%     end
% else 
%     break
% end 
%     
% end

%Better way to compare elements of the two vectors when neither is NAN
idx=find(~isnan(Tftom(1,1,10:20)) & ~isnan(Thtom(1,1,10:20)));
idx = idx(1)+9; %finding where both ~NANs

HT_Hum2Fore = inv(Tftom(:,:,idx))*Thtom(:,:,idx); % Hum Marker in Forearm Marker CS

%% Computing Medial and Lateral Epicondyles in Forearm CS

% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

%Need Medial and Lateral Epicondyles in Humerus CS (Raw Data from BL file)
Hum_BLs = bl{1,3};

EM_idx = 1;
EL_idx = 2;

EM = Hum_BLs(EM_idx,1:4);
EM=EM';
EL = Hum_BLs(EL_idx,1:4);
EL=EL';

% Getting the EM and EL in Forearm Marker CS

EM_Fore = HT_Hum2Fore*EM;

EL_Fore= HT_Hum2Fore*EL;

% Save to BonyLandmarks BL file in forearm 'RS';'US';'OL';'MCP3';'EM';'EL'
bl{1,4}(5:6,:) = zeros;
bl{1,4}(5,1:4) = EM_Fore;
bl{1,4}(6,1:4) = EL_Fore;
%%
%saving to file
save('BL.mat','bl')
end
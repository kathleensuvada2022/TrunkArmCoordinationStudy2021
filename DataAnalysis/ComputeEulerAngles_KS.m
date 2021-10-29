
% Function based off of "ComputeEulerAngles". Created October 2021 for
% Kacey's Project. Used to get Metria Data into Local Coordinate systems of
% markers and then to the global coordinate system. Creates bone coordinate
% systems for the 1)trunk 2)shoulder 3) Forearm 4) Humerus.

% Use Flag ==1 if want to plot local coordinate systems individually and
% BLs in the created Bone CS. 

% Use Flag ==0 if want all trial data in the global coordinate system. 


% Order the Coord. Sys are Output in:  TRUNK SHOULDER  HUM  FORE 
%Use Below for Testing 
%[BLs_G,BL_names_all,CS_G,PMCP_G,jANGLES,elbowangle] = ComputeEulerAngles_KS('trial10','Right','RTIS1006',1)


function [BLs_G,BL_names_all,CS_G,PMCP_G,jANGLES,elbowangle] = ComputeEulerAngles_KS(filename,arm,partid,flag)

% Function to process bony landmark data to compute bone and joint rotations (adapted from Dutch program CalcInputKinem).
% Right now we are inputting bldata as the global coordinates of the
% system, but I think we actually want the local coordinates and the data
% instead
% Use :	[gANGLES,jANGLES]=ComputeEulerAngles(bldata,arm,reffr)
%			bldata = bony landmark coordinates over nsamples for
%                    (1)trunk [4x5xnsamples] (SC,IJ,PX,C7,T8),
%                    (2)scapula [4x5xnsamples] (AC,AA,TS,AI,PC) and
%                    (3)humerus[4x3xnsamples] (EM,EL,GH)
%                    cell array {1x3}
% AMA 9/29/21 For Kacey's data, inputs can be BL in local CSs(bldata) + HT for each
% segment (marker)(HT_seg) over nsamples.
%           arm = right or left
%			reffr = trunk('T') or room ('R') frame of reference
%
%			gAngles = bone angles in global coordinates
%			jAngles = joint angles
%

% August 12, 1996, Frans van der Helm
% March 11, 1997 Ana Maria Acosta
% May 8, 1998	Ana Maria Acosta
% October 26, 2015 Ana Maria Acosta - adapted program to run with Amee
% Seitz's data acquisition program.
% June 22, 2016 Allie Johnson - Modified GH calculation to match the Helical Axes method.
% September 25, 2018 (v10) Ana Maria Acosta - added comments and cleaned up code
% based on Sabeen Admani's additions to the code over 2017-18.
% September 29, 2021 Kacey Suvada - edited code to match experimental
% protocol:
% 1) Modifying inputs: BL and HT
% 2) Modifying outputs: adding Pmcp in G, Trunk and Humerus CSs
% 3) Modifying Global and Local CS so that x is to the right, y is anterior
%    and z is up.
% 4) Ignore Clavicle for now


%%
%if nargin<3, reffr='trunk'; end
%% Loading in the BL data (Digitization) and the BLs Names

datafilepath = ['/Users/kcs762/OneDrive - Northwestern University/TACS/Data','/',partid,'/',arm];
load([datafilepath '/' partid,'_','setup']);

%From Kacey's MetriaKinDAQ 10.2021
% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm'};
bonylmrks = ["SC" "IJ" "PX" "C7" "T8" "AC" "AA" "TS" "AI" "PC" "EM" "EL" "GH" "RS" "US" "OL" "MCP"]';  % IN THIS ORDER
%% Concatenate the bony landmarks into one cell array 
load([datafilepath '/BL.mat']) %loading in BL file 
bldata=bl;
blmat=cat(1,bldata{1},bldata{2},bldata{3},bldata{4}); %coordinates in the frame of the marker
nland=size(blmat,1);
% Using GH from Digitization %%%%%%%%%
GHIDX = find(bonylmrks=='GH');
GH = blmat(GHIDX ,1:3); %XYZ coordinate of GH from Digitization in meantime
GH = [GH 1];

%% Loading in trial Data 
load([datafilepath,'/', filename]) %loading in trial data 

x = data.met;
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

Tftom = zeros(4,4,length(xfore));   

% Need to reshape 4X4XN

%Forearm
for i=1:length(xfore)
% forearm marker HT
Tftom(:,:,i) = quat2tform(circshift(xfore(i,4:7),1,2)); 
Tftom(1:3,4,i) = xfore(i,1:3)';  
end

%Shoulder
Tstom= zeros(4,4,length(xshoulder));
for i = 1:length(xshoulder)
Tstom(:,:,i)= quat2tform(circshift(xshoulder(i,4:7),1,2));
Tstom(1:3,4,i) = xshoulder(i,1:3)'; 
end 

%Trunk
Tttom=zeros(4,4,length(xtrunk));
for i =1:length(xtrunk)  
Tttom(:,:,i)= quat2tform(circshift(xtrunk(i,4:7),1,2));      
Tttom(1:3,4,i) = xtrunk(i,1:3)';    
end

%Humerus
Thtom=zeros(4,4,length(xhum));
for i =1:length(xtrunk)  
Thtom(:,:,i)= quat2tform(circshift(xhum(i,4:7),1,2));      
Thtom(1:3,4,i) = xhum(i,1:3)';    
end

%               TRUNK SHOULDER HUMERUS FOREARM
TmarkertoGlob = {Tttom Tstom Thtom Tftom}; % HT(marker) in GCS during trial ******
%%
%Swap out the definition for the GH joint center that we estimated earlier
%for the one calculated using the helical axes method
% BLlocal{13}

% BLlocal{3}(1:3,3) = GH;

% AMA - the data in BLglobal is already in the global coordinate system!
% Use the rotation matrix for each of the receivers to the transmitter CS
% to transform the locally defined bony landmark points to points in the
% transmitter CS
% bldata={zeros(4,5,nsamples),zeros(4,5,nsamples),zeros(4,3,nsamples)};
% 
% for i = 1:3
%     for j = 1:nsamples
%         bldata{i}(:,:,j)=data{i}(:,:,j)*BLlocal{i};
%     end
% end

% blmat=cat(2,bldata{3},bldata{1},bldata{2}); %coordinates in the global frame
%blmat3 = blmat;

% R=(rotx(pi/2)*roty(pi/2)*rotz(pi/2)); %fix so that the rotations already take the (-) sign into account
%use Amee's guide to determine rotation
    % 1) Transform data to the global coordinate system with IJ as the origin
    %    (X: left-right, Y: upwards, Z: backwards)
    %    Note that the data is in the transmitter coordinate system
    %    (X: forward, Y: left-right, Z: downwards)
    %     disp('entered the for loop');
% R = rotx(pi/2);
%R = [0 0 -1;1 0 0;0 -1 0];
% R=rotx(pi/2)*rotz(-pi/2); %should be correct
% R = -R; %double check that the (-) sign is actually needed

  
    % ****************************************************************************
%     pVectTot = blmat(1:3,5,i);
%     T=[[R;zeros(1,3)] [(R*pVectTot(1:3));1]]; % Transformation matrix to go from experimentally defined CS to DSEL CS 
%     blmat2 = T*blmat(:,:,i);
%     blmat3(:,:,i) = blmat2;
    
    % **************************************************************
    % 2) Calculate the local coordinate system for each bone
    %    Replaces [AS] = asfunc(X,datast(1).arm);
    % 	 BL = | IJ  SC  AC  EM  RS
    %         | PX  AC  AA  EL  US |
    %         | C7  0   TS  GH  OL |
    %         | T8  0   AI  0   0  |
    % 1  2  3  4  5  6  7  8  9  10 11 12 13
    % EM EL GH SC IJ PX C7 T8 AC AA TS AI PC
%%   Getting EL and EM in Forearm Marker CS to set as origin for Forearm CS

%HT_MarkforetoGlob= Tftom;  % HT of the forearm marker to global CS

%P_EM_markHum = 

    % Can't get with my data Kacey 10.21
    
    %%   
%Trunk CS
[TrunkCS,BLnames_t,BLs_lcs_t ] = asthorho(blmat,bonylmrks);

%Do we need this??? Kacey 10.2021
%if strcmp(arm,'left'), TrunkCS=roty(pi)*TrunkCS; end

%Scapula CS
[ScapCoord,BLnames_s,BLs_lcs_s ] =  asscap(blmat,bonylmrks);

%Forearm CS
[ForeCS,BLs_lcs_f,BLnames_f] =  asfore(blmat,bonylmrks);

% Compute location of GH joint using Regression Function   
% GH=ghest(bl,Rscap); %need to do this!!! 
    
%Humerus CS

[Hum_CS,BLs_lcs_h,BLnames_h] =  ashum(blmat,GH,bonylmrks);
   
%%
% Coordinate system for each bone in LCS (marker) -- 1 frame because during
% digitzation 
B_CS_marker = {TrunkCS,ScapCoord,Hum_CS,ForeCS};

%Using FLAG==1 if wanting to plot local CS 
if flag ==1 
    plotBLandCS(BLs_lcs_f,BLnames_f,ForeCS,'Forearm CS')
    plotBLandCS(BLs_lcs_h,BLnames_h,Hum_CS,'Humerus CS')
    plotBLandCS(BLs_lcs_t,BLnames_t,TrunkCS,'Trunk CS')
    plotBLandCS(BLs_lcs_s,BLnames_s,ScapCoord,'Shoulder CS')
end 

%% Looping through all frames in trial for each HT (marker in global)   

for j = 1:length(xtrunk) %artibitrary choosing xtrunk just needs to go through frames 
  % TRUNK SHOULDER HUMERUS FOREARM
%Trunk
%Trunk_Global CS
TtoG(:,:,j)=TmarkertoGlob{1}(:,:,j).*B_CS_marker{1};

% Trunk Bonylandmarks in GCS
for k = 1:length(BLs_lcs_t)
BL_G_t(:,k,j) = TtoG(:,:,j)*inv(cell2mat(B_CS_marker(1)))*(BLs_lcs_t{1,k}(1:4)');
end


%Shoulder
StoG(:,:,j) = TmarkertoGlob{2}(:,:,j)*B_CS_marker{2};

% Shoulder Bonylandmarks in GCS
for k = 1:length(BLs_lcs_s)
BL_G_s(:,k,j) = StoG(:,:,j)*inv(cell2mat(B_CS_marker(2)))*(BLs_lcs_s{1,k}(1:4)');
end


%Humerus
HtoG(:,:,j) = TmarkertoGlob{3}(:,:,j)*B_CS_marker{3};

% Humerus Bonylandmarks in GCS
for k = 1:length(BLs_lcs_h)
BL_G_h(:,k,j) = HtoG(:,:,j)*inv(cell2mat(B_CS_marker(3)))*(BLs_lcs_h{1,k}(1:4)');
end

%Forearm
FtoG(:,:,j) = TmarkertoGlob{4}(:,:,j)*B_CS_marker{4};

% Forearm Bonylandmarks in GCS
for k = 1:length(BLs_lcs_f) 
BL_G_f(:,k,j) = FtoG(:,:,j)*inv(cell2mat(B_CS_marker(4)))*(BLs_lcs_f{1,k}(1:4)');
end

%% Creating matrix AS for a given time point j to get ELBOW ANGLE
%      TRUNK SHOULDER  HUM  FORE

% Need 3x3 rotation matrix for the bones 
AS =[TtoG(1:3,1:3,j) StoG(1:3,1:3,j) HtoG(1:3,1:3,j) FtoG(1:3,1:3,j)];

%Kacey need this? not for elbow angle but if want trunk disp?
%     if strcmp(reffr,'frame')
%         %Use the frame as reference- makes rotation matrix for trunk all
%         %ones, so it doesn't take into account rotations of trunk
%         AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
%         if strcmp(arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
%     end
    
%     gR = rotbones(AS); %absolute angles
    jR = rotjoint(AS); %relative angles
    
    %     blah = CalcEulerAng(TrunkCS,'XYZ')
%     [gANGLES(1:3,:,i)]=CalcEulerAng(TrunkCS,'XYZ',0); % Trunk
%     [gANGLES(4:6,:,i)]=CalcEulerAng(gR(:,4:6),'YZX',0);  % Clavicle
%     [gANGLES(7:9,:,i)]=CalcEulerAng(gR(:,7:9),'YZX',0);  % Scapula
%     [gANGLES(10:12,:,i)]=CalcEulerAng(gR(:,10:12),'YZY',0); % Humerus
%    
%     [jANGLES(1:3,:,i)]=CalcEulerAng(jR(:,1:3),'XYZ',0); % Trunk
%     [jANGLES(4:6,:,i)]=CalcEulerAng(jR(:,4:6),'YZX',0);  % Clavicle
%     [jANGLES(7:9,:,i)]=CalcEulerAng(jR(:,7:9),'YZX',0);  % Scapula
%     [jANGLES(10:12,:,i)]=CalcEulerAng(jR(:,10:12),'YZY',0); % Humerus
    
    [jANGLES(:,:,j)]=CalcEulerAng(jR,'XZY',0);    % Forearm
    
    
    % **************************************************************
%     if strcmp(reffr,'trunk')
%         eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
%     elseif strcmp(reffr,'frame')
%         eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
%     end


%Moved this outside the for loop because the direction was changing after
% %every sample
% if strcmp(arm,'left')
%     %     if strcmp(datast(1).arm,'left'),
%     % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
%     %         gANGLES = gANGLES';
%     %         gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
%     gANGLES([1,3,4,6,7,9,10,12],:)=-gANGLES([1,3,4,6,7,9,10,12],:);
%     %         jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
% end


end
%% Calculating Elbow Angle
for k = 1:length(jANGLES)
elbowangle(k,1) = jANGLES(1,1,k);
end


%% OUTPUTS of Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        TRUNK SHOULDER  HUM  FORE

BLs_G = {BL_G_t,BL_G_s,BL_G_h,BL_G_f}; % MAIN OUTPUT BLS in GLOBAL *******  

CS_G = {TtoG,StoG,HtoG,FtoG}; %%%% MAIN OUTPUT HTs of BONES IN GLOBAL At all points in time during trial 

BL_names_all = {BLnames_t;BLnames_s;BLnames_h;BLnames_f};
% ***THE CSs created above are BONE CS in Global CS every point in time ***********

% Want the PMCP to be output in GCS
PMCP_G_test = BL_G_f(:,4,:); % MCP3 in GCS for all time points in trial
PMCP_G = zeros(4,250);

%Reorganizing so that 4 rows by 250 columns
for i = 1:length(xtrunk)
PMCP_G(:,i) = cat(1,PMCP_G_test(:,1,i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag==0 

% Calling Function to plot all the data in Global Coord. 
plotCoord_Global(BLs_G,BL_names_all,CS_G)
end 
end
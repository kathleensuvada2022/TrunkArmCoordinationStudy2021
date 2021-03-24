
%% Shows what we are saving from MetriaKinDAQ

%     dig.bl{dig.currentSEG}(dig.currentBL,:) =[Ptip_RB' quat_pointer PRB_RB' quat_RB]; 
%Gives XYZ of pointer tool tip in LCS ,quaterion of pointer marker in GCS, then the RGB marker in LCS (this should always be about 001), then quaternion for RGB marker in GCS


% myhandles.met.Segments = {'Trunk';'Scapula';'Humerus';'Forearm';'Probe'};
% myhandles.met.bonylmrks = {{'SC';'IJ';'PX';'C7';'T8'},{'AC';'AA';'TS';'AI';'PC'},{'EM';'EL';'GH'},{'RS';'US';'OL';'MCP3'}};

%% ANALYSIS FILE FOR BL 
% Use this for participants from Fall/winter 2020--> using pointer tool 237

% We should not need this going forward as the data from the experiment
% will already be in the LCS of the RGB metria marker

%% This part for finding Ps in the local Coordinate Frame
%choose the bony landmark file we are using

% % load('RTIS2001_setup');

partid='RTIS1002';
filename = 'BL.mat';
%This is the file from registration not during the trial

filepath = '/Users/kcs762/Documents/GitHub/TrunkArmCoordinationStudy2021/DataAnalysis/RTIS1002';

load([filepath '/' partid '_setup'])

load(filename) %loads in BL for all the RGBs ( for RTIS2003 created new merged structure since had saving issues)


%Creating empty cell array to occupy space 
P_LCS = {};

for i = 1:4 
    %cycling through the rigid body markers
    rigidbodymarker = setup.bl.markerid(i);
%  %           COMMENTED OUT KCS   mBLfiles = length(setup.bl.trial{i}); % THIS IS WRONG getting the length of the string !!!! CHANGE to get number of bony landmarks 
    P_LCS{i} = zeros(4,7);
    
     
%     mBLfilenum = setup.bl.trial{i}; % which rigid body _trunk/arm etc
%        mBLfilenum=    
%     mfname =[filename mBLfilenum '.mat']; 
%     
    
    %KCS ADDED HERE 2/16/21
    
        blfilepath = '/Users/kcs762/Documents/GitHub/TrunkArmCoordinationStudy2021/DataAnalysis/RTIS1002/BLs';

        markerdata_cell = load([blfilepath '/' filename]);
       
        markerdata = markerdata_cell.BL{1,i};
        
        markerdata(markerdata==0)=NaN; % Replace zeros with NaN

        [nmark]=size(markerdata,2); 
        nimag =1 ;
        nmark=(nmark)/8;
 
    mBLfiles = size(markerdata,1); %  to get number of bony landmarks for given RGB 
    
    
    for j = 1:mBLfiles
        %choose the index of the pointer tool marker id
%         pointertoolmarker = setup.bl.pointerid{i}(j); 
          pointertoolmarker = setup.bl.pointerid;
%         mBLfilenum = setup.bl.trial{i}(j);
%         
%     %           COMMENTED OUT KCS      mBLfilenum = setup.bl.trial{i}; % which rigid body _trunk/arm

%     
%         
%       %           COMMENTED OUT KCS   mfname =[filename mBLfilenum '.mat']; 
%         
        %2.2.21 no longer need 
%         if mBLfilenum< 10
%         %       000000                  % number that goes after 0s
%         mfname=[filename '0' num2str(mBLfilenum) '.hts']; 
%         else
%         mfname=[filename num2str(mBLfilenum) '.hts'];
%         end
        
        %Loading in marker data from rigid body KACEY COMMENTED lines 61-74
% 
%         blfilepath = '/Users/kcs762/Documents/GitHub/TrunkArmCoordinationStudy2021/DataAnalysis/RTIS2003/Data/Trials';
% 
%         markerdata_cell = load([blfilepath '/' mfname]);
%        
%         markerdata = markerdata_cell.bl(i);
%         
%         markerdata = cell2mat(markerdata); 
%        
%         markerdata(markerdata==0)=NaN; % Replace zeros with NaN
% 
%         [nmark]=size(markerdata,2); 
%         nimag =1 ;
%         nmark=(nmark)/8;

        % Build the time vector
%         t=markerdata(:,1)-markerdata(1,1);

        % row and column of marker 
%         [im,jm] = find(markerdata==rigidbodymarker);
        
%% Transforming the Quaternion organization to the HT - 1.28.21

quat = markerdata(j,5:8); %just want j for a given BL for a RGB


quat= circshift(quat,1); % added to compensate for quaternion shifted by 1

% XYZ point 
 P = markerdata(j,2:4)'; % just want j row for whichever BL we are on

% % Each quaternion represents a 3D rotation and is of the form 
% % q = [w(SCALAR REAL) qx qy qz]
% 
% Now have HT matrix like is outout from MOCAP - outputs HT for each BL for
% a given RGB
HT_marker = quat2tform(quat); HT_marker(1:3,4,:) = P;
%%

% 2.2.21 no longer need this 
%         %Grabbing the HT for the marker
%         HT_marker = markerdata(:,jm+2:jm+13);
% 
%         %Average across time
% 
%         HT_marker = nanmean(HT_marker);
% 
%         %reshape 3X4 add 0001
% 
%         HT_marker = reshape(HT_marker,4,3)';
% 
%         HT_marker = inv([HT_marker;0 0 0 1]);
%     
       
%row and column of bonylandmark 
%         [ibl,jbl] = find(markerdata==pointertoolmarker);



%         % Grabbing the pointer tool X HT(1,4), HT(2,4) HT(3,4)
%     
%         HT_bonylandmark = markerdata(:,jbl+2:jbl+13);
% 
%         HT_bonylandmark = nanmean(HT_bonylandmark);
% 
%         HT_bonylandmark = reshape(HT_bonylandmark,4,3)';

% getting the HT of RGB marker in global HT but need inverse (transpose)[
% Step 2 on sheet

        HT_lcs_inT2 = HT_marker';

        %grabbing the last column that is the point P of the pointer tool -
        %think this was wrong.. need to use tPu the tip in Pointer tool
        %marker frame. 

%         P = HT_bonylandmark(:,4);
%   
% ID:237, Size:20, Thickness:000.647, tPu:[-001.323 +071.946 -004.697]

          P = [.584 172.168 -6.889 1]'; % units of this in MM  For marker ID 9

        % point needs to be 4X1

        P = [P; 1];

        %Multiplying to get P of the bony landmark in the frame of the metria
        %marker 
        P_LCS{i}(:,j) = HT_marker * P; % ERROR "index in position 1 exceeds array bounds"
       

    end
    
 
 
end 

setup.bl.lcs = P_LCS;
% save([partid '/' partid '_setup'],'setup')
save([partid '_setup'],'setup')


%% Getting into Global CS


%GetHandShoulderTrunkPosition('/Users/kcs762/Desktop/Strokedata/RTIS2001/metria/trunkrestrained/','RTIS2001_00000001.hts','RTIS2001')

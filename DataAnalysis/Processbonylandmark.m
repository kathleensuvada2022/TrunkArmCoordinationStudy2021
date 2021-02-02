
%% ANALYSIS FILE FOR BL 

% Metria Trial 			Bony Landmark       Marker on Body             Pointer Toool
% 1                   	third metacarpal    (Forearm)87/4                  235
% 2                     ulnar styloid       (Forearm)87                    235
% 3                     radial styloid      (Forearm)87                    235
% 4                     lateral epicondyle  (humerus)73/3                  237
% 5                     medial epicondyle   (humerus)73                    237
% 6                     olecranon           (forearm)87                    237
% 7                     anterior acromion   (shoudler)19/2                 237
% 8                     glenohumeral joint  (Humerus) 87                   237
% 9                     A/c joint           (shoulder)19                   237
% 10                    c7                  (sternum)80/1                  237
% 11       cant do      jugular notch       (sternum)80                    237
% 12                    xipod process       (sternum)80                    237

%% This part for finding Ps in the local Coordinate Frame
%choose the bony landmark file we are using

% load('RTIS2001_setup');
filename = '2001tf_reg_000000'; 
filepath =  '/Users/kcs762/Desktop/Strokedata/RTIS2001/bonylandmark/'; 
partid='RTIS2001';

load([partid '/' partid '_setup'])



%Creating empty cell array to occupy space 
P_LCS = {};

for i = [2,4]
    %cycling through the rigid body markers
    rigidbodymarker = setup.bl.markerid(i);
    mBLfiles = length(setup.bl.trial{i});
    P_LCS{i} = zeros(4,7);
    
    for j = 1:mBLfiles
        %choose the index of the pointer tool marker id
        pointertoolmarker = setup.bl.pointerid{i}(j); 
    
        % Building the filename 
        mBLfilenum = setup.bl.trial{i}(j);
        
        if mBLfilenum< 10
        %       000000                  % number that goes after 0s
        mfname=[filename '0' num2str(mBLfilenum) '.hts']; 
        else
        mfname=[filename num2str(mBLfilenum) '.hts'];
        end
        
        %Loading in marker data from rigid body

        % Matrix size = [Nimages x (2 + Nmarkers*14)]
        % [FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
        markerdata = dlmread([filepath mfname],',',18,1);
        %x=dlmread([filepath filename],',',18,1);
        markerdata(markerdata==0)=NaN; % Replace zeros with NaN
        markerdata(:,end)=[]; % Remove last column

        [nimag,nmark]=size(markerdata); 
        nmark=(nmark-1)/14;

        % Build the time vector
        t=markerdata(:,1)-markerdata(1,1);

        % row and column of marker 
        [im,jm] = find(markerdata==rigidbodymarker);

        %Grabbing the HT for the marker
        HT_marker = markerdata(:,jm+2:jm+13);

        %Average across time

        HT_marker = nanmean(HT_marker);

        %reshape 3X4 add 0001

        HT_marker = reshape(HT_marker,4,3)';

        HT_marker = inv([HT_marker;0 0 0 1]);
    
        %row and column of bonylandmark 
        [ibl,jbl] = find(markerdata==pointertoolmarker);


        % Grabbing the pointer tool X HT(1,4), HT(2,4) HT(3,4)
    
        HT_bonylandmark = markerdata(:,jbl+2:jbl+13);

        HT_bonylandmark = nanmean(HT_bonylandmark);

        HT_bonylandmark = reshape(HT_bonylandmark,4,3)';

        
        %grabbing the last column that is the point P of the pointer tool

        P = HT_bonylandmark(:,4);
   
        % point needs to be 4X1

        P = [P; 1];

        %Multiplying to get P of the bony landmark in the frame of the metria
        %marker 
        P_LCS{i}(:,j) = HT_marker * P;
       

    end
    
 
 
end 

setup.bl.lcs = P_LCS;
save([partid '/' partid '_setup'],'setup')


%% Getting into Global CS


%GetHandShoulderTrunkPosition('/Users/kcs762/Desktop/Strokedata/RTIS2001/metria/trunkrestrained/','RTIS2001_00000001.hts','RTIS2001')

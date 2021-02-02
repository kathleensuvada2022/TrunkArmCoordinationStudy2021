%% Global Coordinate Frame Calculation 
%function [Gp]=GlobalCoordinateFrame(filepath,filename)
% Want to take previous P {x,y,z} of bony landmar, 
%in a local reference frame of the Metria marker (for given bony landmark see
% BLtransformedDataPoint) in the Global Coordinate frame ( ie that of the
% metria camera)

% Gp = T*P 

%choose the trial file we are using
filename = 'RTIS2001_000000'; 
filepath =  '/Users/kcs762/Desktop/Strokedata/RTIS2001/metria/trunkrestrained';

%Creating empty cell array to occupy space 
P_GCS = {};
P_GCS{j} = zeros(4,7);

for i = 1:10 % loop 1:10 that builds the filename for the reaching trial 
     
        if i< 10
        mfname=[filename '0' num2str(i) '.hts']; 
        else
        mfname=[filename num2str(i) '.hts'];
        end
        
        %Matrix size = [Nimages x (2 + Nmarkers*14)]
        %[FrameTime,Marker,ST,HT(1,1:4),HT(2,1:4),HT(3,1:4)]
        markerdata = dlmread(mfname,',',18,1);
        markerdata(markerdata==0)=NaN; % Replace zeros with NaN
        markerdata(:,end)=[]; % Remove last column

        [nimag,nmark]=size(markerdata); 
        nmark=(nmark-1)/14;

        % Build the time vector
        t=markerdata(:,1)-markerdata(1,1);
    
    for j = [2,4] %which rigid body are we choosing 
    
       mBLfiles = length(setup.bl.trial{j});
  
    for k = 1:mBLfiles
        Plocal = P_LCS{j}(:,k);  %choose the index of the transformed BL data (x,y,z) in LCS
       
        rigidbodymarker = setup.bl.markerid(j);
        % row and column of marker 
        [im,jm] = find(markerdata==rigidbodymarker);
        %Grabbing the HT for the marker
        HT_marker = markerdata(:,jm+2:jm+13);



 
    P_GCS = zeros(4,t); % 1000 variable size(trial) 
    
    for k = 1:1000
    % add in [0001] and 1 to Pi
    HT = [reshape(HT_marker(k,1:12),4,3)';[0 0 0 1]];
    P_GCS(:,k) =HT*Pi; 
    end 
    % Save gp for each BL and change Gp_# based on which BL %Gp_3 = Gp;
    end 
    
end 
end 
% Thomas-
% This was used to created a global coordinate system, but may help with
% your processing as I had to use the pointer tool to digitize points in a
% plane. I used the MOCAP software from metria too.

%% Loading in Files 

Xaxis_filepath ='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/Xaxis';
X_filename = '_Series2s24'; 
X_mfname=[X_filename '.hts'];

Origin_filepath ='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/Origin';
Origin_filename = '_Series2s24'; 
Origin_mfname=[Origin_filename '.hts'];

XY_filepath ='/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/XYplane';
XY_filename = '_Series2s24'; 
XY_mfname=[XY_filename '.hts'];
%% Organizing Data for X,XY,Origin

% X-Axis
cd '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/Xaxis'
        Xmarkerdata = dlmread(X_mfname ,',',18,1);
        Xmarkerdata(Xmarkerdata==0)=NaN; % Replace zeros with NaN
        Xmarkerdata(:,end)=[]; % Remove last column
        
        [nimag,nmark]=size(Xmarkerdata); 
        nmark=(nmark-1)/14;

        % Build the time vector
        t=Xmarkerdata(:,1)-Xmarkerdata(1,1);
        
        pointID= 9;
        
        % row and column of marker 
        [im,jm] = find(Xmarkerdata==pointID);
        %Grabbing the HT for the marker
        HT_Pointer = Xmarkerdata(:,jm+2:jm+13);
        
        HT_Pointer = mean(HT_Pointer); %Taking the average HT across time
        
        %Shaping HT (Pointer Marker in Camera CS) 
        HT = [reshape(HT_Pointer(1,1:12),4,3)';[0 0 0 1]];
        
        tPu=[.584 172.168 -6.889 1]; %Pointer tool tip in Pointer Marker CS
        tPu= tPu';
        
        CPx = HT*tPu; %Location of tip of pointer (on X-Axis) tool in Camera CS 
        
      
%% Origin        

cd '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/Origin'

        Origin_markerdata = dlmread(Origin_mfname ,',',18,1);
        Origin_markerdata(Origin_markerdata==0)=NaN; % Replace zeros with NaN
        Origin_markerdata(:,end)=[]; % Remove last column
   
        [nimag,nmark]=size(Origin_markerdata); 
        nmark=(nmark-1)/14;

        % Build the time vector
        t=Origin_markerdata(:,1)-Origin_markerdata(1,1);
        
        pointID= 9;
        
        % row and column of marker 
        [im,jm] = find(Origin_markerdata==pointID);
        %Grabbing the HT for the marker
        HT_Pointer = Origin_markerdata(:,jm+2:jm+13);
        
        HT_Pointer = mean(HT_Pointer); %Taking the average HT across time
        
        %Shaping HT (Pointer Marker in Camera CS) 
        HT = [reshape(HT_Pointer(1,1:12),4,3)';[0 0 0 1]];
        
        tPu=[.584 172.168 -6.889 1]; %Pointer tool tip in Pointer Marker CS
        tPu= tPu';
        
        CPorigin = HT*tPu; %Location of tip of pointer (at origin) tool in Camera CS 
               
        
%% XYPlane   
cd '/Users/kcs762/OneDrive - Northwestern University/TACS/Data/RTIS1006/Right/MetriaGCS/XYplane'
        XYmarkerdata = dlmread(XY_mfname ,',',18,1);
        XYmarkerdata(XYmarkerdata==0)=NaN; % Replace zeros with NaN
        XYmarkerdata(:,end)=[]; % Remove last column
        
        [nimag,nmark]=size(XYmarkerdata); 
        nmark=(nmark-1)/14;

        % Build the time vector
        t=XYmarkerdata(:,1)-XYmarkerdata(1,1);
        
        pointID= 9;
        
        % row and column of marker 
        [im,jm] = find(XYmarkerdata==pointID);
        %Grabbing the HT for the marker
        HT_Pointer = XYmarkerdata(:,jm+2:jm+13);
        
        HT_Pointer = mean(HT_Pointer); %Taking the average HT across time
        
        %Shaping HT (Pointer Marker in Camera CS) 
        HT = [reshape(HT_Pointer(1,1:12),4,3)';[0 0 0 1]];
        
        tPu=[.584 172.168 -6.889 1]; %Pointer tool tip in Pointer Marker CS
        tPu= tPu';
        
        CPXY = HT*tPu; %Location of tip of pointer (on XY plane) tool in Camera CS 
                             
%% Finding X, Y, Z in the Room Coordinates
 
Xr = (CPx-CPorigin)/norm(CPx-CPorigin); % Normalized X vector

X2r=(CPXY-CPorigin)/norm(CPXY-CPorigin); %XY point

Zr = cross(Xr(1:3),X2r(1:3));

Zr = Zr/norm(Zr);

Zr = [Zr;0]; % Normalized Z vector

Yr =cross(Zr(1:3),Xr(1:3));

Yr = Yr/norm(Yr);

Yr = [Yr;0]; % Normalized Y vector

%% Creating HT from room to camera CS

HTrC = [Xr Yr Zr CPorigin];

%Plotting the Room CS in Camera Coordinate Frame
H=quiver3(HTrC([1 1 1],4)',HTrC([2 2 2],4)',HTrC([3 3 3],4)',10*HTrC(1,1:3),10*HTrC(2,1:3),10*HTrC(3,1:3));
text(HTrC([1 1 1],4)'+10*HTrC(1,1:3),HTrC([2 2 2],4)'+10*HTrC(2,1:3),HTrC([3 3 3],4)'+10*HTrC(3,1:3),{'X','Y','Z'})
xlabel('x') 
ylabel('y')
zlabel('z')
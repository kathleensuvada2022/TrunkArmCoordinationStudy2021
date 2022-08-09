%% Glenohumeral Joint Estimation 2022

% Function used to estimate the location of the Glenohumeral Joint Rotation
% Center (GHr). This method was based off of the (Meskers,1998) regression model
% but has been modified (Campell,2009) to include less bonylandmarks to
% reduced error of potential incorrect BL locations. Gives location of GHr
% in shoulder marker frame to mimic the digitized Bls at the time of the
% experiment.

% Inputs:
% - BLs: Bonylandmarks for the participant. All included for each segment.
% These are in the reference frame of the respective marker.
% - ScapCoord: Created scapular CS (Kacey's defintions) in shoulder marker
% frame.

% Output:
% - gh_est: the estimated GHj based on (Meskers,1998) linear regression
% model. The output of the function gives GHr in the marker CS to be treated
% as the other digitized BLs.

% K. Suvada - August 2022.


function gh_est = Ghest_2022(ScapCoord,BLs,flag)

% Selecting the Scapular BLs
blmat= BLs{1,2};

% Converting Bls to Bone coordinate frame
Bls_bone_AC = inv(ScapCoord)* blmat;

% Rotating to align BLs with Mesker's defintion
Bls_bone_AC(1:3,:) = rotx(-90)*Bls_bone_AC(1:3,:);

BlNames = ["AC","AA","TS","AI","PC"];


%% Plotting the BonyLandmarks and their Labels
if flag ==  1
    
    figure(31)
    
    for i = 1:length(BlNames)
        plot3(Bls_bone_AC(1,i),Bls_bone_AC(2,i),Bls_bone_AC(3,i),'-o','Color','b','MarkerSize',10,...
            'MarkerFaceColor','#D9FFFF')
        hold on
        text(Bls_bone_AC(1,i),Bls_bone_AC(2,i),Bls_bone_AC(3,i),BlNames(i),'FontSize',14)
    end
    
    %Plotting the Scapular Polygon
    plot3([Bls_bone_AC(1,4) Bls_bone_AC(1,3)],[Bls_bone_AC(2,4) Bls_bone_AC(2,3)],[Bls_bone_AC(3,4) Bls_bone_AC(3,3)],'r') % line between AI and TS
    plot3([Bls_bone_AC(1,4) Bls_bone_AC(1,2)],[Bls_bone_AC(2,4) Bls_bone_AC(2,2)],[Bls_bone_AC(3,4) Bls_bone_AC(3,2)],'r') % line between AI and AA
    plot3([Bls_bone_AC(1,3) Bls_bone_AC(1,1)],[Bls_bone_AC(2,3) Bls_bone_AC(2,1)],[Bls_bone_AC(3,3) Bls_bone_AC(3,1)],'r') % line between TS and AC
    plot3([Bls_bone_AC(1,1) Bls_bone_AC(1,2)],[Bls_bone_AC(2,1) Bls_bone_AC(2,2)],[Bls_bone_AC(3,1) Bls_bone_AC(3,2)],'r') % line between AC and AA
    
    axis equal
    xlabel('X axis (mm)')
    ylabel('Y axis (mm)')
    zlabel('Z axis (mm)')
    
    title('Bls in Bone CS','FontSize',16)
    
end
%% Renaming Variables st they are in bone CS (Meskers)
ac = Bls_bone_AC(:,1);
aa = Bls_bone_AC(:,2);
ts = Bls_bone_AC(:,3);
ai = Bls_bone_AC(:,4);
pc = Bls_bone_AC(:,5);
%% Linear Regression - Modified Meskers Model

laipc=norm(ai(1:3)-pc(1:3));
laapc=norm(aa(1:3)-pc(1:3));

scx=[1 ts(1) laipc]';
scy=[1 ac(2) pc(3)]';
scz=[1 laapc ts(1)]';

thx=[26.896 .61 .295];
thy=[-16.307 .825 .293];
thz=[-1.740 -.899 -.229];


GHx = thx*scx;
GHy = thy*scy;
GHz = thz*scz;

gh_b=[GHx;GHy;GHz]; %gh in bone CS but Meskers definition
%%

% Adding Estimated GH to Figure

if flag ==1
    figure(31)
    plot3(gh_b(1), gh_b(2),gh_b(3),'*')
    text(gh_b(1), gh_b(2),gh_b(3),'GH PC MOD')
end

% Rotating back to Kacey's Defintion of Scap CS
gh_b = rotx(90)*gh_b;

% Converting Back to Marker CS
gh_m=(ScapCoord*[gh_b;1]);

if flag ==1
    figure(29)
    plot3(gh_m(1),gh_m(2),gh_m(3),'o')
    text(gh_m(1),gh_m(2),gh_m(3),'GHPC MOD')
    
end

% Output of function: GH estimate in scapular Marker frame
gh_est = gh_m;



end


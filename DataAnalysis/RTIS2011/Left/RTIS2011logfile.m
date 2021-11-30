% Participant log file
% RTIS2011
% Marker IDs: 

% markerid=[Trunk Shoulder Arm Forearm ]
setup.markerid=[80 19 87 73];

% Add the information regarding trial conditions

% {TRtable,  TR25,  TR50,  TUtable, TU25, TU50}

setup.trial={4:15,16:26,27:37,[38:41 64:68],[48:52 53:57],[44:46 58:62]}; 

setup.bl = bl;


%%
for i =1:4
setup.bl{1,i} = bl{1,i}(:,1:4);
setup.bl{1,i} =setup.bl{1,i}';
end



%%
bldata=setup.bl;
blmat=cat(2,bldata{1},bldata{2},bldata{3},bldata{4}); %coordinates in the frame of the marker
bonylmrks = ["SC" "IJ" "PX" "C7" "T8" "AC" "AA" "TS" "AI" "PC" "EM" "EL" "GH" "RS" "US" "OL" "MCP","EL","EM"]';  % IN THIS ORDER
GHIDX = find(bonylmrks=='GH');
GH = blmat(1:3 ,GHIDX); %XYZ coordinate of GH from Digitization in meantime
GH = [GH;1];

arm='Left';
%Trunk CS
[TrunkCS,BLnames_t,BLs_lcs_t ] = asthorho(blmat,bonylmrks,arm);
setup.BoneCSinMarker{1,1} = TrunkCS;

%Do we need this??? Kacey 10.2021
%if strcmp(arm,'left'), TrunkCS=roty(pi)*TrunkCS; end

%Scapula CS
[ScapCoord,BLnames_s,BLs_lcs_s ] =  asscap(blmat,bonylmrks);
setup.BoneCSinMarker{1,2} = ScapCoord;

%Forearm CS
[ForeCS,BLs_lcs_f,BLnames_f] =  asfore(blmat,bonylmrks);
setup.BoneCSinMarker{1,3} = ForeCS;

%Humerus CS
[Hum_CS,BLs_lcs_h,BLnames_h] =  ashum(blmat,GH,bonylmrks);
setup.BoneCSinMarker{1,4} = Hum_CS;

%%

save('RTIS2011_setup','setup');
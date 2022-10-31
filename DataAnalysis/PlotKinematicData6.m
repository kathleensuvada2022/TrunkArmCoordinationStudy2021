%% Plotting Kinematic Data- Main Function

% Main function that calls other functions for analysis. This function
% calls 'ComputeReachStart2021', 'GetHandShoulderTrunkPosition8', EMG functions,
% interpolates missing Metria data and then resamples Metria Data
% More samples per second. Ultimately plots filled data,
% distance, velocity, and overhead plot .Use to confirm reach start/end
% times and interpolation is valid.

% Inputs:
% - expcond: 1:6 for condition (see summary sheet)
% - partid: string participant ID
% - metriafname: Metria file name as string
% - act3dfname : act3d file name. Same as metria file name. Same now
% - hand: which hand as string

% Outputs:
%- avgshouldertrunk: Average shoulder and trunk position across all trials
%- std_shldtr: std dev shoulder and trunk
%- avgmaxreach: average reach across trials
%- std_maxreach: std deviation of max reach.
%- avgemg_vel: average emg at max vel (check this)
%- avgemg_start: average EMG at the start of the reach. (check this)


% K.SUVADA 2019-2022
%%
function [avgshouldertrunk std_shldtr  avgmaxreach std_maxreach,avgemg_vel,avgemg_start] = PlotKinematicData6(partid,hand,metriafname,act3dfname,expcond,flag)
% File path and loading setupfile

%For Mac
datafilepath = ['/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data','/',partid,'/',hand];
% For PC
%datafilepath = ['C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\','\',partid,'\',hand];
load(fullfile(datafilepath,[partid '_setup.mat'])); %load setup file



%% Loading and setting file name and condition
expcondname={'RT','R25','R50','UT','U25','U50'};

% all the same file path now
afilepath = datafilepath;
afilepath2 = afilepath;
mfilepath = afilepath2;

%
% %updated for new data structure 1.28.21
mtrials=setup.trial{expcond};
atrials=setup.trial{expcond};
ntrials=length(mtrials);

%% Initializing Variables

maxreach_current_trial=zeros(ntrials,1);

maxhandexcrsn_current_trial =zeros(ntrials,1);

shex_current_trial=zeros(ntrials,1);

sh_Z_ex_current_trial =zeros(ntrials,1);

trex_current_trial=zeros(ntrials,1);



% TrunkAng_current_trial=zeros(ntrials,1); % Commented out for Now until
% adding back Kinematics

% NOT SURE ABOUT ONES BELOW
% maxreach=zeros(ntrials,1);
% emgstart = zeros(ntrials,15);
%
% emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
% % rdist = zeros(ntrials,1);
% maxreach=zeros(ntrials,1);
% emgstart = zeros(ntrials,15);
%
% emgval = zeros(ntrials,6,15); % 15 emgs ->Now 6 conditions
% rdist = zeros(ntrials,1);
%
% % maxreach_current_trial =zeros(ntrials,1);
% % maxTrunk_current_trial=zeros(ntrials,1);
% % emgsmaxvel_vals = zeros(ntrials,15);
%
%
% maxreach_current_trial =zeros(ntrials,1);
% shtrdisp_current_trial=zeros(ntrials,2);
%
% emgvel_trial= zeros(length(mtrials),15);
% emgstart_trial= zeros(length(mtrials),15);

%% Loading in BonyLandmark File
BLs = setup.bl; % BLs in marker CS

%% Creating Scapular CS

% From BL Digitization File- creating Scapular CS in MARKER frame.
ScapCoord_forGH = Asscap_K_GH(BLs,hand,0); % switching for left arm st Ghest works
ScapCoord = Asscap_K(BLs,hand,0); % Not switching for left arm
setup.BoneCSinMarker{2} = ScapCoord ; % overwriting old version bc incorrect

%% Creating Trunk CS
TrunkCoord = asthorho_K2022(BLs,hand,0,partid); %Returns Trunk CS in Marker CS HT from T to M during digitization
setup.BoneCSinMarker{1} = TrunkCoord ; % overwriting old version bc incorrect
%%  Computing GH estimate
 gh_est = Ghest_2022(ScapCoord_forGH,BLs,0);


% Saving Gh_est to BLs setup file creating new column
setup.bl{1,2}(:,length(setup.bl{1,2})+1) = gh_est;

BLs = setup.bl; % BLs in marker CS now including GH estimate in LCS with Shoulder BLs


%% Main loop

for i=1: length(mtrials)
    
    % For mass data sheet saving data
    if i==1
        
        %    for mac
%                  load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Stroke_Paretic.mat')
%                   load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Controls.mat')
        
               % load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Stroke_Paretic.mat')
       load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Controls.mat')
        
                %       load('/Users/kcs762/Library/CloudStorage/OneDrive-NorthwesternUniversity/TACS/Data/AllData_Stroke_NonParetic.mat')
        
        % for pc
        %        load('C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\AllData_Stroke_Paretic.mat')
        %        load('C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\AllData_Controls.mat')
        %    load('C:\Users\kcs762\OneDrive - Northwestern University\TACS\Data\AllData_Stroke_NonParetic.mat')
        
        
    end
    
    mfname = ['/' metriafname num2str(mtrials(i)) '.mat'];
    afname =  mfname;
    afname2 = mfname;
    
    mfname
    
    if strcmp(partid,'RTIS1002')
        if strcmp(mfname,'/trials1.mat')
            continue
        end
        
        if strcmp(mfname,'/trials3.mat')
            continue
        end
        if strcmp(mfname,'/trials4.mat')
            continue
        end
        
        if strcmp(mfname,'/trials13.mat')
            continue
        end
        
        if strcmp(mfname,'/trials15.mat')
            continue
        end
        %
        if strcmp(mfname,'/trials9.mat')
            continue
        end
        % %
        if strcmp(mfname,'/trials11.mat')
            continue
        end
        
        if strcmp(mfname,'/trials26.mat')
            continue
        end
        
        if strcmp(mfname,'/trials29.mat')
            continue
        end
        
        %
        if strcmp(mfname,'/trials31.mat')
            continue
        end
        
        if strcmp(mfname,'/trials34.mat')
            continue
        end
        
        if strcmp(mfname,'/trials30.mat')
            continue
        end
        
        if strcmp(mfname,'/trials16.mat')
            continue
        end
        if strcmp(mfname,'/trials17.mat')
            continue
        end
        
        if strcmp(mfname,'/trials18.mat')
            continue
        end
        
        if strcmp(mfname,'/trials19.mat')
            continue
        end
        
        if strcmp(mfname,'/trials20.mat')
            continue
        end
        
        if strcmp(mfname,'/trials41.mat')
            continue
        end
        
        if strcmp(mfname,'/trials43.mat')
            continue
        end
        
        if strcmp(mfname,'/trials47.mat')
            continue
        end
        
        if strcmp(mfname,'/trials22.mat')
            continue
        end
        
        if strcmp(mfname,'/trials23.mat')
            continue
        end
        
        
        if strcmp(mfname,'/trials24.mat')
            continue
        end
    end
    
    
    
    
    if strcmp(partid,'RTIS1003')
        if strcmp(mfname,'/trials14.mat')
            continue
        end
        if strcmp(mfname,'/trials1.mat')
            continue
        end
        if strcmp(mfname,'/trials6.mat')
            continue
        end
        if strcmp(mfname,'/trials17.mat')
            continue
        end
        
        if strcmp(mfname,'/trials18.mat')
            continue
        end
        if strcmp(mfname,'/trials22.mat')
            continue
        end
        if strcmp(mfname,'/trials33.mat')
            continue
        end
        if strcmp(mfname,'/trials32.mat')
            continue
        end
        if strcmp(mfname,'/trials31.mat')
            continue
        end
        if strcmp(mfname,'/trials36.mat')
            continue
        end
        if strcmp(mfname,'/trials24.mat')
            continue
        end
        if strcmp(mfname,'/trials25.mat')
            continue
        end
        if strcmp(mfname,'/trials28.mat')
            continue
        end
        if strcmp(mfname,'/trials29.mat')
            continue
        end
    end
    
    
    
    if strcmp(partid,'RTIS1004')
        if strcmp(mfname,'/trial21.mat')
            continue
        end
        
    end
    
    
    if strcmp(partid,'RTIS1005')
        if strcmp(mfname,'/trial21.mat')
            continue
        end
        if strcmp(mfname,'/trial31.mat')
            continue
        end
        
        
        if strcmp(mfname,'/trial34.mat')
            continue
        end
        
        if strcmp(mfname,'/trial36.mat')
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS1006')
        if strcmp(mfname,'/trial58.mat')
            continue
        end
        
        if strcmp(mfname,'/trial78.mat')
            continue
        end
        
    end
    
    
    
    if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial8.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial9.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial10.mat')
            maxhandexcrsn_current_trial(i) = 0;
            shex_current_trial(i) =0;
            trex_current_trial(i) =0;
            continue
        end
        
        if strcmp(mfname,'/trial24.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
        if strcmp(mfname,'/trial51.mat')
            
            continue
        end
        if strcmp(mfname,'/trial34.mat')
            
            continue
        end
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        if strcmp(mfname,'/trial33.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2001') && strcmp(hand,'Left')
        
        % These were empty matrices metria data
        if strcmp(mfname,'/trial66.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial68.mat')
            
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        if strcmp(mfname,'/trial24.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial45.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial49.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial52.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial53.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial54.mat')
            
            continue
        end
    end
    
    
    if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
        
        
        if strcmp(mfname,'/trial3.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial5.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial64.mat')
            
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial17.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial20.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial21.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial39.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial25.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial31.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial46.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial47.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial28.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial74.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial78.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial71.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial82.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial85.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial57.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial60.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial49.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial70.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial71.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial82.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial85.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial73.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial72.mat')
            
            continue
        end
        
        
        
        if strcmp(mfname,'/trial76.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial87.mat')
            
            continue
        end
        
        
        %         if strcmp(mfname,'/trial79.mat')
        %
        %             continue
        %         end
        %
        
        if strcmp(mfname,'/trial81.mat')
            
            continue
        end
        %
        if strcmp(mfname,'/trial92.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial95.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial96.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
        
        
        if strcmp(mfname,'/trial25.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial39.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial40.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial43.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial46.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial47.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial63.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial69.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial59.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial66.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial68.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2006') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial16.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial17.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial18.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial23.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial24.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial12.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial13.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial36.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial38.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial42.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial43.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial56.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial64.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial65.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial45.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial46.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial52.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial53.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2007') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial1.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial7.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial9.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial11.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial37.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial41.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial30.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial32.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial14.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial15.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial17.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial19.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial42.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial45.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial64.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial67.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial68.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial12.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial49.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial54.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial55.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2007') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial8.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial9.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial26.mat')
            
            continue
        end
        
        
        
        if strcmp(mfname,'/trial59.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2008') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial3.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial4.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial7.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial11.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial12.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial13.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial19.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial21.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial22.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial23.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial24.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2008') && strcmp(hand,'Left')
        
        
        if strcmp(mfname,'/trial13.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial15.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial28.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial37.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial38.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial39.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial41.mat')
            
            continue
        end
    end
    
    
    if strcmp(partid,'RTIS2009') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial18.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial29.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial32.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial33.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial41.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial60.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2009') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial6.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial7.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial10.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial13.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial14.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial38.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial59.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial60.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial62.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial66.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2010') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial40.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial41.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial42.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
        
        
        if strcmp(mfname,'/trial45.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial56.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial57.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial60.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial61.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial75.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial76.mat')
            
            continue
        end
        
    end
    
    if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial26.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial29.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial30.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial16.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial31.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial33.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial34.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial37.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial41.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial42.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial43.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial44.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2011') && strcmp(hand,'Right')
        
        if strcmp(mfname,'/trial15.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial17.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial18.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial38.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial50.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial52.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial55.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial58.mat')
            
            continue
        end
    end
    
    if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')
        
        if strcmp(mfname,'/trial27.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial31.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial35.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial42.mat')
            
            continue
        end
        
        if strcmp(mfname,'/trial66.mat')
            
            continue
        end
    end
    
    %
    % % Kacey added to call new function to plot in GCS
    % bl = load('/Users/kcs762/Box/KACEY/Data/RTIS1002/BLs/BL.mat');
    % datafile =load([mfilepath '/' mfname]);
    % PlotGCS(datafile,bl,setup)
    %
    %     figure(2),clf
    %     if strcmp(partid,'RTIS2001') && (mtrials(i)==8)
    %         [xhand,xshoulder,xtrunk,maxreach(i)]=GetHandShoulderPosition(mfilepath,mfname,partid);
    %     else
    %
    %
    
    %%%%%%%%%%% Getting Metria Data %%%%%%%%%%%%%%%%%%%
    
    
    % Metria Trial Data - traces of 3rd MCP, acromion, jugular notch, and GH_est during trial
    
    [t,xhand,xshoulder,xtrunk,xshldr,xac,xts,xai,xpc,xarm,xjug,xsc,xxp,xc7,xt8,x,xghest,HTttog,HTstog,EM_GCS,EL_GCS,GH_Dig_GCS,RS_GCS,US_GCS,OL_GCS]=GetHandShoulderTrunkPosition8(mfilepath,mfname,partid,hand,setup,gh_est,TrunkCoord,ScapCoord);
    

    figure(19)
    plot(xshldr(:,1),xshldr(:,2),'Linewidth',2) % Computed Acromion
    hold on
    plot(EM_GCS(:,1),EM_GCS(:,2),'Linewidth',2) % Computed EM
    plot(EL_GCS(:,1),EL_GCS(:,2),'Linewidth',2) % Computed EL
    
    plot(RS_GCS(:,1),RS_GCS(:,2),'Linewidth',2) % Computed RS
    plot(US_GCS(:,1),US_GCS(:,2),'Linewidth',2) % Computed US
    plot(OL_GCS(:,1),OL_GCS(:,2),'Linewidth',2) % Computed OL
    
    %   plot(xshoulder(:,1),xshoulder(:,2),'Linewidth',2) % Computed Acromion
    plot(xhand(:,1),xhand(:,2),'Linewidth',2) % Computed 3rd MCP
    plot(xjug(:,1),xjug(:,2),'Linewidth',2) % Computed Jug Notch
    plot(xtrunk(:,1),xtrunk(:,2),'Linewidth',2)
    
    plot(xghest(:,1),xghest(:,2),'Linewidth',2) %esimated GH
    axis equal
    %         legend('Acromion','3rd MCP','Jug Notch','Trunk Marker','Estimated GH','FontSizƒe',14)
    title('Overhead View of Reach- GCS Raw' ,'FontSize',16)
    xlabel('X position (mm)','FontSize',14)
    ylabel('Y position (mm)','FontSize',14)
    legend('AA','EM','EL','RS','US','OL','3rdMCP','JUG','trunkMarker','estGH','FontSize',14)
%     
% % Plotting TRUNK CS XY plane in GCS
% quiver(HTttog([1 1],4)',HTttog([2 2],4)',50*HTttog(1,1:2),50*HTttog(2,1:2))
% text(HTttog(1,4)+50*HTttog(1,1:2),HTttog(2,4)+50*HTttog(2,1:2),{'X_T_t_o_G','Y_T_t_o_G'})
% 
% for h = 1:250
% HT_trunkinG  = HTttog(:,:,h);
% quiver(HT_trunkinG([1 1],4)',HT_trunkinG([2 2],4)',50*HT_trunkinG(1,1:2),50*HT_trunkinG(2,1:2))
% if h ==1
% text(HT_trunkinG(1,4)+50*HT_trunkinG(1,1:2),HT_trunkinG(2,4)+50*HT_trunkinG(2,1:2),{'X_T_t_o_G','Y_T_t_o_G'})
% end
% pause
% end
    



    %% If Coordinate System Off (couldn't REG to room)
%     if strcmp(partid,'RTIS2009')
%         if strcmp(hand,'Right')
%             % Rotating xhand by -50 deg
%             xhand_transp = xhand';
%             RotMat = rotz(-50);
%             xhand_Rot50 = RotMat*xhand_transp;
%             xhand_Rot50 =xhand_Rot50';
%             xhand_Rot50(:,1) = -xhand_Rot50(:,1);
%             
%             xhand = xhand_Rot50;
%             
%             
%             % Rotating xjug by -50 deg
%             xjug_transp = xjug';
%             RotMat = rotz(-50);
%             xjug_Rot50 = RotMat*xjug_transp;
%             xjug_Rot50 =xjug_Rot50';
%             xjug_Rot50(:,1) = -xjug_Rot50(:,1);
%             
%             xjug = xjug_Rot50;
%             
%             % Rotating xtrunk by -50 deg
%             xtrunk_transp = xtrunk(:,1:3)';
%             RotMat = rotz(-50);
%             xtrunk_Rot50 = RotMat*xtrunk_transp;
%             xtrunk_Rot50 =xtrunk_Rot50';
%             xtrunk_Rot50(:,1) = -xtrunk_Rot50(:,1);
%             
%             xjug = xjug_Rot50;
%             
%             % Rotating xshldr by -50 deg
%             xshldr_transp = xshldr';
%             RotMat = rotz(-50);
%             xshldr_Rot50 = RotMat*xshldr_transp ;
%             xshldr_Rot50 =xshldr_Rot50';
%             xshldr_Rot50(:,1) = -xshldr_Rot50(:,1);
%             
%             xshldr = xshldr_Rot50;
%             
%             
%             % Rotating gh by -50 deg
%             xghest_transp = xghest';
%             RotMat = rotz(-50);
%             xghest_Rot50 = RotMat*xghest_transp ;
%             xghest_Rot50 =xghest_Rot50';
%             xghest_Rot50(:,1) = -xghest_Rot50(:,1);
%             
%             xghest = xghest_Rot50;
%             
%         end
%     end
    
    
    
    %
    %%
%     if strcmp(partid,'RTIS1006') % fixing that kacey switched x and y in
%     GCS creation -

% no longer needed because now in trunk CS - SEPT 2022
%         
%         xhandfix(:,1) = xhand(:,2);
%         xhand(:,2) = -xhand(:,1);
%         
%         xhand(:,1) =  xhandfix(:,1);
%         
%         
%         xghestfix(:,1) = xghest(:,2);
%         xghest(:,2) = -xghest(:,1);
%         
%         xghest(:,1) =  -xghestfix(:,1);
%         
%         xshldrfix(:,1) = xshldr(:,2);
%         xshldr(:,2) = -xshldr(:,1);
%         
%         xshldr(:,1) =  -xshldrfix(:,1);
%         
%         
%         
%     end
%     %
    
%     
%     if strcmp(partid,'RTIS1006')
%         
%         xjugfix(:,1) = xjug(:,2);
%         xjug(:,2) = -xjug(:,1);
%         
%         xjug(:,1) =  xjugfix(:,1);
%         
%         
%         xjug(:,1) = -xjug(:,1);
%     end
%     
    
    
    %%   Not sure what this is
    load([mfilepath mfname]);
    
    %% Loading in ACT3D Data for Reach Start Thresholding
    act3d_data = data.act;
    
    Xpos_act = -act3d_data(:,2);
    
    Ypos_act = -act3d_data(:,3);
    Zpos_act = act3d_data(:,4);
    
    % Kacey don't use t vector for ACT data... this is incorrect the METRIA
    % time is correct
    %     t_act = length(Ypos_act)/ 50; % time in seconds
    %     t_act = 0:.02:5;
    %     t_act = t_act(2:end)';
    
    
    %% Checking NANS and Interpolating Prior to Resampling
    HTttognewCol1 = zeros(length(HTttog),4);
    HTttognewCol2 =zeros(length(HTttog),4);
    HTttognewCol3 =zeros(length(HTttog),4);
    HTttognewCol4 =zeros(length(HTttog),4);
    
 
    
    if sum(sum(isnan(xhand)))>0 || sum(sum(isnan(xjug)))>0 %
        
        if sum(sum(isnan(xhand)))>0 %checking if  xhand has NANs
            
            'NANS PRESENT IN XHAND'
            
            filled_data =   find(isnan(xhand(1:250)));
            
            if strcmp(partid,'RTIS1006') &&  expcond >3
                
                [xhandnew,TF] = fillmissing(xhand,'nearest');
                
            elseif strcmp(partid,'RTIS1002')
                %                 if strcmp(mfname,'/trials10.mat')
                %                     [xhandnew,TF] = fillmissing(xhand,'linear');
                %                 end
                %                 if strcmp(mfname,'/trials9.mat')
                %                     [xhandnew,TF] = fillmissing(xhand,'linear');
                %                 end
                %                 if strcmp(mfname,'/trials10.mat')
                %                     [xhandnew,TF] = fillmissing(xhand,'nearest');
                %                 end
                if strcmp(mfname,'/trials11.mat')
                    [xhandnew,TF] = fillmissing(xhand,'nearest','SamplePoints',t);
                end
                if strcmp(mfname,'/trials22.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials23.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                end
                if strcmp(mfname,'/trials24.mat')
                    [xhandnew,TF] = fillmissing(xhand,'nearest');
                end
                if strcmp(mfname,'/trials37.mat')
                    [xhandnew,TF] = fillmissing(xhand,'linear');
                    
                else
                    [xhandnew,TF] = fillmissing(xhand,'spline','SamplePoints',t);
                end
                
            elseif strcmp(partid,'RTIS2010') && strcmp(hand,'Right') &&  expcond ==6
                [xhandnew,TF] = fillmissing(xhand,'nearest');
            else
                
                [xhandnew,TF] = fillmissing(xhand,'spline','SamplePoints',t);
                
            end
            
            if flag == 1
                figure(9)
                clf
                %Plotting the Original Data then the Filled Samples
                subplot(3,1,1)
                plot(t(filled_data),xhandnew(filled_data,1),'ro')
                hold on
                plot(t,xhand(:,1),'b','Linewidth',1)
                % legend('Interpolated Data','Original Data','Location','northwest','FontSize',13)
                title('3D 3rd MCP Position','FontSize',18)
                xlabel('Time (s)','FontSize',14)
                ylabel('X Position (mm)','FontSize',14)
                %                 xlim([0 5])
                xlim([0 t(end)])
                %                 if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %                     xlim([0 t(end)])
                %                 end
                % %
                subplot(3,1,2)
                plot(t(filled_data),xhandnew(filled_data,2),'ro')
                hold on
                plot(t,xhand(:,2),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Y Position (mm)','FontSize',14)
                xlim([0 t(end)])
                %
                % if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %     xlim([0 10])
                % end
                %
                % if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %     xlim([0 10])
                % end
                %
                % if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %     xlim([0 t(end)])
                % end
                
                subplot(3,1,3)
                plot(t(filled_data),xhandnew(filled_data,3),'ro')
                hold on
                plot(t,xhand(:,3),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Z Position (mm)','FontSize',14)
                xlim([0 t(end)])
                %                if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %                      xlim([0 10])
                %                end
                %
                %                 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %                     xlim([0 t(end)])
                %                 end
                %
                
                'User Check Interpolation Accuracy'
                pause
                
            end
            xhand = xhandnew; %Replacing with interpolated data
            
        end
        
        
        
        if sum(sum(isnan(xjug)))>0  % Checking if Trunk has NANS
            'NANS PRESENT in XJUG'
            filled_data =   find(isnan(xjug(1:250)));
            
            if strcmp(partid,'RTIS1006') &&  expcond >3
                [xjugnew,TF] = fillmissing(xjug,'spline');
            elseif strcmp(partid,'RTIS2010') && strcmp(hand,'Right') &&  expcond ==6
                [xjugnew,TF] = fillmissing(xjug,'spline');
                
            else
                [xjugnew,TF] = fillmissing(xjug,'spline','SamplePoints',t);
            end
            
            if flag ==1
                figure(10)
                clf
                %Plotting the Original Data then the Filled Samples
                subplot(3,1,1)
                plot(t(filled_data),xjugnew(filled_data,1),'ro')
                hold on
                plot(t,xjug(:,1),'b','Linewidth',1)
                %  legend('Interpolated Data','Original Data','FontSize',13)
                title(['3D Trunk Position' mfname],'FontSize',18)
                xlabel('Time (s)','FontSize',14)
                ylabel('X Position (mm)','FontSize',14)
                xlim([0 t(end)])
                %
                %                 if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %                     xlim([0 t(end)])
                %                 end
                
                subplot(3,1,2)
                plot(t(filled_data),xjugnew(filled_data,2),'ro')
                hold on
                plot(t,xjug(:,2),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Y Position (mm)','FontSize',14)
                xlim([0 t(end)])
                
                
                %                 if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %                     xlim([0 t(end)])
                %                 end
                
                subplot(3,1,3)
                plot(t(filled_data),xjugnew(filled_data,3),'ro')
                hold on
                plot(t,xjug(:,3),'b','Linewidth',1)
                %             legend('Interpolated Data','Original Data','FontSize',13)
                xlabel('Time (s)','FontSize',14)
                ylabel('Z Position (mm)','FontSize',14)
                xlim([0 t(end)])
                %
                %                 if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==6
                %                     xlim([0 10])
                %                 end
                %
                %                 if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
                %                     xlim([0 t(end)])
                %                 end
                
                
                'User Check Interpolation Accuracy'
                
                pause
            end
            xjug= xjugnew;
            
            % Filling in HTttog Matrix and use method 'Nearest' so will
            % duplicate whichever sample is closest and not NAN. 
           
            
            % Interpolation function doesn't like HT with 4x4xN samples - break up
            % each column then put back together. 
            
            % Grabbing Closest non NAN sample 
            
            % Sept. 2022
           
            % Col 1 of HT
            [HTttognewCol1,TF] = fillmissing(squeeze(HTttog(:,1,:))','nearest','SamplePoints',t); %First Column at every point in time
           
            % Resampling 
            [HTttognewCol1,t2]=resampledata(HTttognewCol1,t,89,100);
            
            % Col 2 of HT
            [HTttognewCol2,TF] = fillmissing(squeeze(HTttog(:,2,:))','nearest','SamplePoints',t); %2nd Column at every point in time 
            
            % Resampling
            [HTttognewCol2,t2]=resampledata(HTttognewCol2,t,89,100);
            
           
            % Col 3 of HT
            [HTttognewCol3,TF] = fillmissing(squeeze(HTttog(:,3,:))','nearest','SamplePoints',t); %3rd Column at every point in time
            
            % Resampling
            [HTttognewCol3,t2]=resampledata(HTttognewCol3,t,89,100);
            
            
            % Col 4 of HT
            [HTttognewCol4,TF] = fillmissing(squeeze(HTttog(:,4,:))','nearest','SamplePoints',t); %4th Column at every point in time
            
            % Resampling
            [HTttognewCol4,t2]=resampledata(HTttognewCol4,t,89,100);
            
            %Initializing 
            HTtognew = zeros(4,4,length(HTttognewCol4));
             
            % Concate Columns Now that no NANs and put HT back together
            
            HTtognew(:,1,:) = HTttognewCol1';
            HTtognew(:,2,:) = HTttognewCol2';
            HTtognew(:,3,:) = HTttognewCol3';
            HTtognew(:,4,:) = HTttognewCol4';
            
            % Now replace original HT matrix with filled Matrix - Resampled
          
            % HT Trunk to Global CS
            HTttog = HTtognew;
            
           
            % Need HT G to T for converting Xhand to Trunk CS 
         
            for w = 1:length(HTttog)
                HTgtot(:,:,w) = inv(HTttog(:,:,w));
            end

% Adding other Trunk BLS / filling NANs and Resampling 
   
    [xsc,TF] = fillmissing(xsc,'nearest','SamplePoints',t); 
    [xxp,TF] = fillmissing(xxp,'nearest','SamplePoints',t);
    [xc7,TF] = fillmissing(xc7,'nearest','SamplePoints',t); 
    [xt8,TF] = fillmissing(xt8,'nearest','SamplePoints',t); 

    [xsc,t2]=resampledata(xsc,t,89,100);
    [xxp,t2]=resampledata(xxp,t,89,100);
    [xc7,t2]=resampledata(xc7,t,89,100);
    [xt8,t2]=resampledata(xt8,t,89,100);


        else % If there are no NANs in TRUNK, still need to separate columns to resample
            
            HTttognewCol1 = squeeze(HTttog(:,1,:))';
            HTttognewCol2 = squeeze(HTttog(:,2,:))';
            HTttognewCol3 = squeeze(HTttog(:,3,:))';
            HTttognewCol4 = squeeze(HTttog(:,4,:))';
            
            % Resampling
            [HTttognewCol1,t2]=resampledata(HTttognewCol1,t,89,100);
            % Resampling
            [HTttognewCol2,t2]=resampledata(HTttognewCol2,t,89,100);
            % Resampling
            [HTttognewCol3,t2]=resampledata(HTttognewCol3,t,89,100);
            % Resampling
            [HTttognewCol4,t2]=resampledata(HTttognewCol4,t,89,100);
            
         
            %Initializing
            HTtognew = zeros(4,4,length(HTttognewCol4));
             
            % Concate Columns Now that no NANs and put HT back together
            
            HTtognew(:,1,:) = HTttognewCol1';
            HTtognew(:,2,:) = HTttognewCol2';
            HTtognew(:,3,:) = HTttognewCol3';
            HTtognew(:,4,:) = HTttognewCol4';
            
            % Now replace original HT matrix with filled Matrix - Resampled
            
            % HT Trunk to Global CS
            HTttog = HTtognew;
            
            
            % Need HT G to T for converting Xhand to Trunk CS
            for w = 1:length(HTttog)
                HTgtot(:,:,w) = inv(HTttog(:,:,w));
            end
      
            % Adding other Trunk BLS and Resampling 


            [xsc,t2]=resampledata(xsc,t,89,100);
            [xxp,t2]=resampledata(xxp,t,89,100);
            [xc7,t2]=resampledata(xc7,t,89,100);
            [xt8,t2]=resampledata(xt8,t,89,100);

        end
      
        
        
        
    else % If there are no nans in trunk or hand, still need to do this step
        
        HTttognewCol1 = squeeze(HTttog(:,1,:))';
        HTttognewCol2 = squeeze(HTttog(:,2,:))';
        HTttognewCol3 = squeeze(HTttog(:,3,:))';
        HTttognewCol4 = squeeze(HTttog(:,4,:))';
        
        % Resampling
        [HTttognewCol1,t2]=resampledata(HTttognewCol1,t,89,100); 
        % Resampling
        [HTttognewCol2,t2]=resampledata(HTttognewCol2,t,89,100);
        % Resampling
        [HTttognewCol3,t2]=resampledata(HTttognewCol3,t,89,100);
        % Resampling
        [HTttognewCol4,t2]=resampledata(HTttognewCol4,t,89,100);
        
        
        %Initializing
        HTtognew = zeros(4,4,length(HTttognewCol4));
             
        % Concate Columns Now that no NANs and put HT back together
        
        HTtognew(:,1,:) = HTttognewCol1';
        HTtognew(:,2,:) = HTttognewCol2';
        HTtognew(:,3,:) = HTttognewCol3';
        HTtognew(:,4,:) = HTttognewCol4';
        
        % Now replace original HT matrix with filled Matrix - Resampled
        
        % HT Trunk to Global CS
        HTttog = HTtognew;
        
        
        % Need HT G to T for converting Xhand to Trunk CS
      
        for w = 1:length(HTttog)
        HTgtot(:,:,w) = inv(HTttog(:,:,w));
        end 


        % Adding other Trunk BLS and Resampling 
            [xsc,t2]=resampledata(xsc,t,89,100);
            [xxp,t2]=resampledata(xxp,t,89,100);
            [xc7,t2]=resampledata(xc7,t,89,100);
            [xt8,t2]=resampledata(xt8,t,89,100);


    end
    

    
    
    %% Computing Dist/Vel/Angles With Original Data
    
    Xo= nanmean(xhand(1:5,1));
    Yo = nanmean(xhand(1:5,2));
    Zo = nanmean(xhand(1:5,3));
    
    %dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2 + (xhand(:,3)-Zo).^2);
    dist = sqrt((xhand(:,1)-Xo).^2 +(xhand(:,2)-Yo).^2);
    
    % Computing Velocity and resampling
    vel = ddt(smo(dist,3),1/89);
    
    velx= ddt(smo(xhand(:,1),3),1/89);
    vely= ddt(smo(xhand(:,2),3),1/89);
    
    
    theta_vel2 = atan2(vely,velx);
    theta_vel2 = rad2deg(theta_vel2);
    
    %% RESAMPLE
    
    % Resample variables before feeding into the ComputeReachStart
    
    
    [xhand,t2]=resampledata(xhand,t,89,100);
    
    [xjug,t2]=resampledata(xjug,t,89,100);
    
    [dist,t2]=resampledata(dist,t,89,100);
    
    
    [vel,t2]=resampledata(vel,t,89,100);
    [velx,t2]=resampledata(velx,t,89,100);
    [vely,t2]=resampledata(vely,t,89,100);
    
    [theta_vel2,t2]=resampledata(theta_vel2,t,89,100);
    
    % Resampling ACT3D Data - use time vector and the 89 HZ for metria. - not 50HZ
    [Ypos_act,t2]=resampledata(Ypos_act, t,89,100);
    [Zpos_act,t2]=resampledata(Zpos_act, t,89,100);
    
    %% Metria Trial by Trial Kinematic Data (computed BLS)
    
    %     if flag
    %         figure(1),clf
    %         subplot(2,1,1)
    %         plot([(xhand(:,1)-xjug(1,1)) (xshldr(:,1)-xjug(1,1)) (xjug(:,1)-xjug(1,1))],[(xhand(:,2)-xjug(1,2)) (xshldr(:,2)-xjug(1,2)) (xjug(:,2)-xjug(1,2))],'LineWidth',1);
    %         hold on
    %
    %         plot(xhand(mridx,1),xhand(mridx,2),'o','MarkerSize',10,'MarkerFaceColor','r');
    %
    %         % % p1=plot(-[xshldr(:,1) xtrunk(:,1) xfore(:,1)],-[xshldr(:,2) xtrunk(:,2) xfore(:,2)],'LineWidth',2); hold on
    %         % hold on
    %         % p2=plot(gca,nanmean([xhand(1:10,1) xshoulder(1:10,1) xtrunk(1:10,1) xfore(1:10,1) xarm(1:10,1)]),nanmean([xhand(1:10,2) xshoulder(1:10,2) xtrunk(1:10,2) xfore(1:10,2) xarm(1:10,2)]),'o','MarkerSize',10,'MarkerFaceColor','g');
    %         % % p3 = plot([xee*1000 xhnd*1000],[yee*1000 yhnd*1000],'LineWidth',4);  % added to add act 3d data
    %         % % p3 = plot([xactee(:,1) xactha(:,1)],[xactee(:,2) xactha(:,2)],'LineWidth',4);  % added to add act 3d data
    %         % %p3 = plot([xactee(:,1) p(:,1)],[xactee(:,2) p(:,2)],'LineWidth',4);  % added to add act 3d data
    %         % p4=plot(gca,[setup.exp.hometar(1) setup.exp.shpos(1)]*1000,[setup.exp.hometar(2) setup.exp.shpos(2)]*1000,'o','MarkerSize',10,'MarkerFaceColor','r');
    %         %
    %         %
    %         % %p5=quiver(gca,xfore([1 1 40 40],1),xfore([1 1 40 40],2),lcsfore([1 2 79 80],1),lcsfore([1 2 79 80],2),'LineWidth',2);
    %         % % p3=plot([xhand(mridx,1) xshldr(mridx,1) xtrunk(mridx,1)],-[xhand(mridx,3) xshldr(mridx,3) xtrunk(mridx,3)],'s','MarkerSize',10,'MarkerFaceColor','r');
    %
    %         % % phandles=[p1' p2 p3];
    %         axis 'equal'
    %         legend('Hand','Shoulder','Trunk')
    %         xlabel('x (mm)')
    %         ylabel('y (mm)')
    %         title(mfname)
    %
    %         %Metria Distance Plot with Max Distance Marked
    %         subplot(2,1,2)
    %         plot(t,rdist)
    %         hold on
    %         p1 = line('Color','b','Xdata',[t(mridx) t(mridx)],'Ydata',[400 650], 'LineWidth',.5); % start reach
    %         % co=get(lax1,'ColorOrder');
    %         % set(lax1,'ColorOrder',co(end-1:-1:1,:))
    %         xlabel('Time')
    %         ylabel('Distance')
    %         % legend('Distance','Max Dist')
    %         axis equal
    %         %
    %         pause
    %     end
    
    
    %% Loading in EMGS
    
    % Normalized EMGS
    %     load([afilepath afname])
    %     emg= data.daq{1,2};
    %     emg=abs(detrend(emg(:,1:15)))./maxEMG(ones(length(emg(:,1:15)),1),:); % Detrend and rectify EMG
    %
    %% Computing the start of the reach
    
    
    [dist,vel,idx,timestart, timedistmax,xhand,rangeZ]= ComputeReachStart_2021(Zpos_act,Ypos_act,t2,xhand,xjug,dist,vel,velx,vely,theta_vel2,setup,expcond,partid,mfname,hand);
    
    
    %% Saving Variables from ComputeReachStart_2021 to .mat file 10.2021
    
    %Saves file for each trial
    %     extention='.mat';
    %     filepath_times=datafilepath;
    %     name_times = ['Times_Trial' num2str(mtrials(i)) '.mat'];
    %     matname = fullfile(filepath_times, [name_times extention]);
    %
    % save(matname,'dist','vel','distmax','idx','timestart','timevelmax', 'timedistmax','t_vector')
    
    %save(['Times_trial' num2str(i) '.mat'],'dist','vel','distmax','idx','timestart','timevelmax', 'timedistmax')
    


    %%  Computing Trunk Angle in GCS - Add back in when want Kinematics
    
    % Uncomment everything below to add back Kinematics  - SUMMER 2022
    
    
%     metdata =  x;
%         %
%         TrunkAng_GCS= zeros(3,length(metdata));
%     
%         for k = 1:length(metdata)
%             TrunkAng_GCS_frame = ComputeEulerAngles_AMA_K(mfname,hand,partid,k); % Gives Trunk Angle in GCS
%             TrunkAng_GCS(:,k) =TrunkAng_GCS_frame(1:3);
%         end
%     
% %     
%     
    
    
    % Trunk Angle Interpolation / Resampling
    
    % April 2022 - K. Suvada
    % No need to check interpolation (how many missing NaNs) bc will have checked in missing trunk data
    % for displacement
    %     if sum(sum(isnan(TrunkAng_GCS)))>0
    %         TrunkAng_GCS = TrunkAng_GCS';
    %         [TrunkAng_GCS_new,TF] = fillmissing(TrunkAng_GCS,'spline','SamplePoints',t);
    %
    %         TrunkAng_GCS = TrunkAng_GCS_new; % Trunk 1) trunk flexion/extension 2) trunk rotation 3) lateral bending
    %     else
    %         TrunkAng_GCS = TrunkAng_GCS';
    %     end
    %
    
    %     if strcmp(partid,'RTIS2002')
    %         if strcmp(hand,'Left')
    %             for m = 1:length(TrunkAng_GCS)
    %                 if (TrunkAng_GCS(m,1) <0)
    %                     TrunkAng_GCS(m,1) = TrunkAng_GCS(m,1)+180;
    %                 elseif (TrunkAng_GCS(m,1) >0)
    %                     TrunkAng_GCS(m,1) = TrunkAng_GCS(m,1)-180;
    %                 end
    %             end
    %         end
    %     end
    
    %     if strcmp(partid,'RTIS2002') || strcmp(partid,'RTIS2001') || strcmp(partid,'RTIS2003') || strcmp(partid,'RTIS2006')|| strcmp(partid,'RTIS2007')|| strcmp(partid,'RTIS2008')|| strcmp(partid,'RTIS2009')|| strcmp(partid,'RTIS2010')|| strcmp(partid,'RTIS2011')|| strcmp(partid,'RTIS1003')|| strcmp(partid,'RTIS1004')
    %         if strcmp(hand,'Left')
    %             for m = 1:length(TrunkAng_GCS)
    %                 if (TrunkAng_GCS(m,1) <0)
    %                     TrunkAng_GCS(m,1) = -TrunkAng_GCS(m,1);
    %                 elseif (TrunkAng_GCS(m,1) >0)
    %                     TrunkAng_GCS(m,1) = -TrunkAng_GCS(m,1);
    %                 end
    %             end
    %         end
    %     end
    %
    
    
    
    % !!!!!Convention for both arms now + angle means back extension - angle
    % means forward flexion!!!!
    
    %Resampling Trunk Angle
    
    %[TrunkAng_GCS,t2]=resampledata(TrunkAng_GCS,t,89,100);
    %%
    %% MISC GH Computations from OLD GH estimation
    
    %     gh = gh';%Flipping so organized by columns (time = rows) like other variables
    %
    %     if strcmp(hand,'Left') % need to flip back since rotated 180 about Z axis in 'ComputeEulerAngles'
    %         gh(:,1) = -gh(:,1);
    %         gh(:,2) = -gh(:,2);
    %
    %     end
    %     %
    
    
    %  GH computed rotated 90 (Compared to Marker data) - June 2022 -- WRONG
    %     if strcmp(partid,'RTIS2001')
    %         if strcmp(hand,'Right')
    %             if expcond==1
    %                 %                 if strcmp(mfname,'/trial1.mat')
    %
    %                 ghflipped = gh';
    %                 ghflipped = ghflipped (1:3,:);
    %
    %                 gh2 = zeros(3,length(gh));
    %
    %                 for l= 1: length(gh)
    %                     gh2(:,l) = rotz(-45)*ghflipped(:,l);
    %                 end
    %
    %                 gh2 = gh2';
    %
    %                 meanx_gh = mean(gh(1:10,1));
    %                 meany_gh = mean(gh(1:10,2));
    %
    %                 meanx_gh_2 = mean(gh2(1:10,1));
    %                 meany_gh_2 = mean(gh2(1:10,2));
    %
    %                 x_transl =  meanx_gh - meanx_gh_2;
    %                 y_transl =  meany_gh - meany_gh_2;
    %
    %                 gh(:,1) = gh2(:,1)+x_transl;
    %                 gh(:,2) = gh2(:,2)+y_transl;
    %
    %
    %                 %                 end
    %             end
    %         end
    %     end
    %
    %
    %
    
    % * NOTE all this GH stuff is wrong... Kacey Corrected GH Linear Reg so
    % now don't need this **
    %     if strcmp(partid,'RTIS1006')  %flipping x and y issue with kacey GCS digitization fixed now
    %
    %         ghfix(:,1) = gh(:,2);
    %         gh(:,2) = -gh(:,1);
    %
    %         gh(:,1) =  ghfix(:,1);
    %
    %         gh(:,1) = -gh(:,1);
    %     end
    %
    %
    %
    %
    %
    %     if strcmp(partid,'RTIS2009')
    %         if strcmp(hand,'Right')
    %             % Rotating GH by -50 deg
    %             GH_transp = gh(:,1:3)';
    %             RotMat = rotz(-50);
    %             GH_Rot50 = RotMat* GH_transp;
    %             GH_Rot50 =GH_Rot50';
    %             GH_Rot50(:,1) = -GH_Rot50(:,1);
    %
    %             gh(:,1:3) = GH_Rot50(:,1:3);
    %         end
    %     end
    
    %     if strcmp(partid,'RTIS2009')
    %         if strcmp(hand,'Left')
    %
    %             gh(:,1) = -gh(:,1);
    %             gh(:,2) = -gh(:,2);
    %         end
    %
    %     end
    
    
    
    %% Filling in Missing Data and Resampling of GH
    
    
    % Adding in August 2022 with new GHr linear regression Model
    % gh_est is from GetHandShoulderTrunkPosition8. Gh in global at all
    % points of trial.
    
    gh = xghest;
    
    if sum(sum(isnan(gh)))>0  % Checking if GH has NANS
        'NANS PRESENT in GH'
        
        filled_data =   find(isnan(gh(1:250))); %rows of NANs
        if strcmp(partid,'RTIS1006') &&  expcond >3
            [ghNew,TF] = fillmissing(gh,'spline');
            
        elseif strcmp(partid,'RTIS1004') % Trial 26 weird interp so just use constant
            
            if strcmp(mfname,'/trial26.mat')
                
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            else
                [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
            end
            
        elseif strcmp(partid,'RTIS1002')
            if strcmp(mfname,'/trials4.mat')
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            end
            
            if strcmp(mfname,'/trials5.mat')
                ghNew = fillmissing(gh,'linear','EndValues','nearest');
            else
                [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
                
            end
        elseif strcmp(partid,'RTIS2010') && strcmp(hand,'Right') &&  expcond ==6
            ghNew = fillmissing(gh,'linear','EndValues','nearest');
        else
            [ghNew,TF] = fillmissing(gh,'spline','SamplePoints',t);
        end
        
        
        if flag ==1
            figure(11)
            clf
            %Plotting the Original Data then the Filled Samples
            subplot(3,1,1)
            plot(t(filled_data),ghNew(filled_data,1),'ro')
            hold on
            plot(t,gh(:,1),'b','Linewidth',1)
            %   legend('Interpolated Data','Original Data','FontSize',13)
            title(['3D GH Position' mfname],'FontSize',18)
            xlabel('Time (s)','FontSize',14)
            ylabel('X Position (mm)','FontSize',14)
            xlim([0 t(end)])
            %         if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
            %             xlim([0 t(end)])
            %         end
            
            subplot(3,1,2)
            plot(t(filled_data),ghNew(filled_data,2),'ro')
            hold on
            plot(t,gh(:,2),'b','Linewidth',1)
            %         legend('Interpolated Data','Original Data','FontSize',13)
            xlabel('Time (s)','FontSize',14)
            ylabel('Y Position (mm)','FontSize',14)
            xlim([0 t(end)])
            %         if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
            %             xlim([0 t(end)])
            %         end
            
            subplot(3,1,3)
            plot(t(filled_data),ghNew(filled_data,3),'ro')
            hold on
            plot(t,gh(:,3),'b','Linewidth',1)
            %         legend('Interpolated Data','Original Data','FontSize',13)
            xlabel('Time (s)','FontSize',14)
            ylabel('Z Position (mm)','FontSize',14)
            xlim([0 t(end)])
            %         if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2003') && strcmp(hand,'Left') && expcond==3
            %             xlim([0 10])
            %         end
            %
            %         if strcmp(partid,'RTIS2007') && strcmp(hand,'Right') && expcond==2 || 3 || 5 || 6
            %             xlim([0 t(end)])
            %         end
            
            'User Check Interpolation Accuracy'
            
            
            pause
        end
        
        gh= ghNew;


            % Filling in HTttog Matrix and use method 'Nearest' so will
            % duplicate whichever sample is closest and not NAN. 
           
            
            % Interpolation function doesn't like HT with 4x4xN samples - break up
            % each column then put back together. 
            
            % Grabbing Closest non NAN sample 
            
            % Oct. 2022
           
            % Col 1 of HT
            [HTstognewCol1,TF] = fillmissing(squeeze(HTstog(:,1,:))','nearest','SamplePoints',t); %First Column at every point in time
           
            % Resampling 
            [HTstognewCol1,t2]=resampledata(HTstognewCol1,t,89,100);
            
            % Col 2 of HT
            [HTstognewCol2,TF] = fillmissing(squeeze(HTstog(:,2,:))','nearest','SamplePoints',t); %2nd Column at every point in time 
            
            % Resampling
            [HTstognewCol2,t2]=resampledata(HTstognewCol2,t,89,100);
            
           
            % Col 3 of HT
            [HTstognewCol3,TF] = fillmissing(squeeze(HTstog(:,3,:))','nearest','SamplePoints',t); %3rd Column at every point in time
            
            % Resampling
            [HTstognewCol3,t2]=resampledata(HTstognewCol3,t,89,100);
            
            
            % Col 4 of HT
            [HTstognewCol4,TF] = fillmissing(squeeze(HTstog(:,4,:))','nearest','SamplePoints',t); %4th Column at every point in time
            
            % Resampling
            [HTstognewCol4,t2]=resampledata(HTstognewCol4,t,89,100);
            
            %Initializing 
            HTstognew = zeros(4,4,length(HTstognewCol4));
             
            % Concate Columns Now that no NANs and put HT back together
            
            HTstognew(:,1,:) = HTstognewCol1';
            HTstognew(:,2,:) = HTstognewCol2';
            HTstognew(:,3,:) = HTstognewCol3';
            HTstognew(:,4,:) = HTstognewCol4';
            
            % Now replace original HT matrix with filled Matrix - Resampled
          
            % HT Scap to Global CS
            HTstog = HTstognew;
            
           
  
            
        else % If there are no NANs in Scap, still need to separate columns to resample
            
            HTstognewCol1 = squeeze(HTstog(:,1,:))';
            HTstognewCol2 = squeeze(HTstog(:,2,:))';
            HTstognewCol3 = squeeze(HTstog(:,3,:))';
            HTstognewCol4 = squeeze(HTstog(:,4,:))';
            
            % Resampling
            [HTstognewCol1,t2]=resampledata(HTstognewCol1,t,89,100);
            % Resampling
            [HTstognewCol2,t2]=resampledata(HTstognewCol2,t,89,100);
            % Resampling
            [HTstognewCol3,t2]=resampledata(HTstognewCol3,t,89,100);
            % Resampling
            [HTstognewCol4,t2]=resampledata(HTstognewCol4,t,89,100);
            
         
            %Initializing
            HTstognew = zeros(4,4,length(HTstognewCol4));
             
            % Concate Columns Now that no NANs and put HT back together
            
            HTstognew(:,1,:) = HTstognewCol1';
            HTstognew(:,2,:) = HTstognewCol2';
            HTstognew(:,3,:) = HTstognewCol3';
            HTstognew(:,4,:) = HTstognewCol4';
            
            % Now replace original HT matrix with filled Matrix - Resampled
            
            % HT Scap to Global CS
            HTstog = HTstognew;
            
       
    end
    
    
    % Resampling GH
    [gh,t2]=resampledata(gh,t,89,100);
 
    % Filling Missing Acromion Data - need this to resample it
    [xshldrnew,TF] = fillmissing(xshldr,'Nearest','SamplePoints',t);
  
    xshldr = xshldrnew;

    %Filling other missing BLs of scapula
    [xac,TF] = fillmissing(xac,'Nearest','SamplePoints',t);
    [xts,TF] = fillmissing(xts,'Nearest','SamplePoints',t);
    [xai,TF] = fillmissing(xai,'Nearest','SamplePoints',t);
    [xpc,TF] = fillmissing(xpc,'Nearest','SamplePoints',t);

    %Resampling Acromion and other BLs Data for Comparison
    [xshldr,t2]=resampledata(xshldr,t,89,100);
    [xac,t2]=resampledata(xac,t,89,100);
    [xts,t2]=resampledata(xts,t,89,100);
    [xai,t2]=resampledata(xai,t,89,100);
    [xpc,t2]=resampledata(xpc,t,89,100);
 %%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% BELOW SECTIONS ARE UPDATED KINEMATICS Fall 2022%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
% ARM KINEMATICS
% - Creation of Humerus and Forearm CS in the GCS. 
% - Humerus Coordinate system updated to have GH est
% - Computed Elbow angles (elbow extension/pronation/supination)

%%  Humerus 

% Filling in the NANs and resampling Humerus BLS

% EM_GCS
 [EM_GCS,TF] = fillmissing(EM_GCS,'nearest','SamplePoints',t); % Interpolation using nearest data point 

 [EM_GCS,t2h]=resampledata(EM_GCS,t,89,100); % Resampling

% EL_GCS
 [EL_GCS,TF] = fillmissing(EL_GCS,'nearest','SamplePoints',t); % Interpolation using nearest data point 
 [EL_GCS,t2h]=resampledata(EL_GCS,t,89,100); % Resampling

    if strcmp (partid, 'RTIS1003') %Flipped EM AND EL 

        EL_GCS2 = EM_GCS;

        EM_GCS = EL_GCS;

        EL_GCS = EL_GCS2;

    end
    
Hum_CS_G = zeros(4,4,length(gh));

% Creating Humerus CS with interpolated and resampled data
for h = 1:length(gh) 
Hum_CS_G(:,:,h) =  ashum_K_2022(EM_GCS(h,:),EL_GCS(h,:),gh(h,:),hand,h,0);

end


%% Forearm

%Filling in the NANS and resampling Forearm BLS

%RS_GCS
[RS_GCS,TF] = fillmissing(RS_GCS,'nearest','SamplePoints',t); % Interpolation using nearest data point 
[RS_GCS,t2h]=resampledata(RS_GCS,t,89,100); % Resampling

 %US_GCS
[US_GCS,TF] = fillmissing(US_GCS,'nearest','SamplePoints',t); % Interpolation using nearest data point 
[US_GCS,t2h]=resampledata(US_GCS,t,89,100); % Resampling

 %OL_GCS
[OL_GCS,TF] = fillmissing(OL_GCS,'nearest','SamplePoints',t); % Interpolation using nearest data point 
[OL_GCS,t2h]=resampledata(OL_GCS,t,89,100); % Resampling

% Creating Forearm CS
Fore_CS_G= zeros(4,4,length(OL_GCS));

for h = 1:length(OL_GCS) %samples


    Fore_CS_G(:,:,h) =  asfore_K_2022(RS_GCS(h,:),US_GCS(h,:),OL_GCS(h,:),EM_GCS(h,:),EL_GCS(h,:),hand,h,0);


end 


%% MASTER PLOT OF BLS CS in GCS

% Plot goes through all frames showing all CS of segments (in gCS) and the
% respective BLs in GCS.


close all
figure()


for b = 1:50:length(EL_GCS)


    plot3(EL_GCS(b,1),EL_GCS(b,2),EL_GCS(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    hold on
    if b==1
    text(EL_GCS(b,1),EL_GCS(b,2),EL_GCS(b,3),'EL','FontSize',14)
    end

    plot3(EM_GCS(b,1),EM_GCS(b,2),EM_GCS(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    if b==1
    text(EM_GCS(b,1),EM_GCS(b,2),EM_GCS(b,3),'EM','FontSize',14)
    end

    plot3(gh(b,1),gh(b,2),gh(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    if b==1
    text(gh(b,1),gh(b,2),gh(b,3),'GH','FontSize',14)
    end

% Plotting HUM CS at given Frame
quiver3(Hum_CS_G ([1 1 1],4,b)',Hum_CS_G ([2 2 2],4,b)',Hum_CS_G ([3 3 3],4,b)',50*Hum_CS_G (1,1:3,b),50*Hum_CS_G (2,1:3,b),50*Hum_CS_G (3,1:3,b))
text(Hum_CS_G (1,4,b)+50*Hum_CS_G (1,1:3,b),Hum_CS_G (2,4,b)+50*Hum_CS_G (2,1:3,b),Hum_CS_G (3,4,b)+50*Hum_CS_G (3,1:3,b),{'X_H','Y_H','Z_H'})
 
H_Mid_H =(EM_GCS(b,1:3)+EL_GCS(b,1:3))/2;



    plot3(US_GCS(b,1),US_GCS(b,2),US_GCS(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    if b==1
    text(US_GCS(b,1),US_GCS(b,2),US_GCS(b,3),'US','FontSize',14)
    end
    plot3(RS_GCS(b,1),RS_GCS(b,2),RS_GCS(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    if b==1
    text(RS_GCS(b,1),RS_GCS(b,2),RS_GCS(b,3),'RS','FontSize',14)
    end

    plot3(OL_GCS(b,1),OL_GCS(b,2),OL_GCS(b,3),'-o','Color','b','MarkerSize',10,...
        'MarkerFaceColor','#D9FFFF')
    if b==1
    text(OL_GCS(b,1),OL_GCS(b,2),OL_GCS(b,3),'OL','FontSize',14)
    end

H_Mid_F =(RS_GCS(b,1:3)+US_GCS(b,1:3))/2;    

% Plotting FORE CS at given Frame
quiver3(Fore_CS_G ([1 1 1],4,b)',Fore_CS_G ([2 2 2],4,b)',Fore_CS_G ([3 3 3],4,b)',50*Fore_CS_G (1,1:3,b),50*Fore_CS_G (2,1:3,b),50*Fore_CS_G (3,1:3,b))
text(Fore_CS_G (1,4,b)+50*Fore_CS_G (1,1:3,b),Fore_CS_G (2,4,b)+50*Fore_CS_G (2,1:3,b),Fore_CS_G (3,4,b)+50*Fore_CS_G (3,1:3,b),{'X_F','Y_F','Z_F'})
 
% line between midpoint of forearm to midpoint of humerus.
plot3([H_Mid_F(1) H_Mid_H(1)],[H_Mid_F(2) H_Mid_H(2)],[H_Mid_F(3) H_Mid_H(3)])

% line between GH midpoint of humerus.
plot3([gh(b,1) H_Mid_H(1)],[gh(b,2) H_Mid_H(2)],[gh(b,3) H_Mid_H(3)])

%Line between styloids
plot3([RS_GCS(b,1) US_GCS(b,1)],[RS_GCS(b,2) US_GCS(b,2)],[RS_GCS(b,3) US_GCS(b,3)])


% Plotting Trunk CS
quiver3(HTttog ([1 1 1],4,b)',HTttog ([2 2 2],4,b)',HTttog ([3 3 3],4,b)',50*HTttog (1,1:3,b),50*HTttog (2,1:3,b),50*HTttog (3,1:3,b))
text(HTttog (1,4,b)+50*HTttog (1,1:3,b),HTttog (2,4,b)+50*HTttog (2,1:3,b),HTttog (3,4,b)+50*HTttog (3,1:3,b),{'X_T','Y_T','Z_T'})
 
% Plotting Scapular CS

quiver3(HTstog ([1 1 1],4,b)',HTstog ([2 2 2],4,b)',HTstog ([3 3 3],4,b)',50*HTstog (1,1:3,b),50*HTstog (2,1:3,b),50*HTstog (3,1:3,b))
text(HTstog (1,4,b)+50*HTstog (1,1:3,b),HTstog (2,4,b)+50*HTstog (2,1:3,b),HTstog (3,4,b)+50*HTstog (3,1:3,b),{'X_S','Y_S','Z_S'})
 
% Computing and Plotting GCS

GCS_GCS(:,:,b) = HTttog(:,:,b)*inv(HTttog(:,:,b));
quiver3(GCS_GCS ([1 1 1],4,b)',GCS_GCS ([2 2 2],4,b)',GCS_GCS ([3 3 3],4,b)',50*GCS_GCS (1,1:3,b),50*GCS_GCS (2,1:3,b),50*GCS_GCS (3,1:3,b))
text(GCS_GCS (1,4,b)+50*GCS_GCS (1,1:3,b),GCS_GCS (2,4,b)+50*GCS_GCS (2,1:3,b),GCS_GCS (3,4,b)+50*GCS_GCS (3,1:3,b),{'X_GCS','Y_GCS','Z_GCS'})
 


% Plotting Trunk BLs
  
% JUG Notch
plot3(xjug(b,1),xjug(b,2),xjug(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')

if b==1
text(xjug(b,1),xjug(b,2),xjug(b,3),'IJ','FontSize',14)
end
% XP
plot3(xxp(b,1),xxp(b,2),xxp(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xxp(b,1),xxp(b,2),xxp(b,3),'XP','FontSize',14)
end

%SC
plot3(xsc(b,1),xsc(b,2),xsc(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xsc(b,1),xsc(b,2),xsc(b,3),'SC','FontSize',14)
end

%t8
plot3(xt8(b,1),xt8(b,2),xt8(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xt8(b,1),xt8(b,2),xt8(b,3),'T8','FontSize',14)
end

%c7
plot3(xc7(b,1),xc7(b,2),xc7(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xc7(b,1),xc7(b,2),xc7(b,3),'C7','FontSize',14)
end
% Shoulder BLs

% AC
plot3(xac(b,1),xac(b,2),xac(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xac(b,1),xac(b,2),xac(b,3),'AC','FontSize',14)
end

% AI
plot3(xai(b,1),xai(b,2),xai(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xai(b,1),xai(b,2),xai(b,3),'AI','FontSize',14)
end

%PC
plot3(xpc(b,1),xpc(b,2),xpc(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xpc(b,1),xpc(b,2),xpc(b,3),'PC','FontSize',14)
end 

%TS
plot3(xts(b,1),xts(b,2),xts(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xts(b,1),xts(b,2),xts(b,3),'TS','FontSize',14)
end

%AA
plot3(xshldr(b,1),xshldr(b,2),xshldr(b,3),'-o','Color','b','MarkerSize',10,...
    'MarkerFaceColor','#D9FFFF')
if b==1
text(xshldr(b,1),xshldr(b,2),xshldr(b,3),'AA','FontSize',14)
end

axis equal
xlabel('X axis (mm)')
ylabel('Y axis (mm)')
zlabel('Z axis (mm)')

%title(['Humerus CS and Respective BLS in GCS During Trial. FRAME:' num2str(frame)],'FontSize',16)  
   


pause(.005) 
end

pause
%%
  % Now have recreated t for resampled data
    t = t2;



%% TRUNK KINEMATICS
% - HTttog created earlier, resampled 
% - HTgtot also created ,resampled
% - First angle: forward flexion
% - Second angle: Lateral Bending
% - Third angle: Axial Twisting

% Rot Mat for Trunk in GCS 
gR_trunk = HTttog(1:3,1:3,:);


% Rotmat for Trunk in Trunk Inital CS

jR_trunk = zeros(3,3,length(t));


%Rot Mat Trunk in Trunk Inital Position (at reach start)

for b = 1:length(t)
jR_trunk(:,:,b) = HTgtot(1:3,1:3,idx(1))*HTttog(1:3,1:3,b);
end


%% HUMERUS KINEMATICS 
% - HThtog created earlier, resampled 
% - Hum in GCS, HUM in Trunk at start, Hum in Trunk

% - First angle: Pole Angle 
% - Second angle: SABD 

% gR - Rotation Matrix for Hum CS in GCS for all time during trial 
gR_Hum = Hum_CS_G(1:3,1:3,:);

% jR - Rotation Matrix for Hum in Trunk_initial
jr_Hum_ti = zeros(3,3,length(t));

for b = 1:length(t)
  jr_Hum_ti(:,:,b)=  HTgtot(1:3,1:3,idx(1))*Hum_CS_G(1:3,1:3,b);
end

% jR - Rotation Matrix for Hum in Trunk
jr_Hum_T = zeros(3,3,length(t));

for b = 1:length(t)
  jr_Hum_T(:,:,b)=  HTgtot(1:3,1:3,b)*Hum_CS_G(1:3,1:3,b);
end

%% Scapular Kinematics
% - HTstoG computed during all frames of trial earlier

% gR - Rotation Matrix for Scap CS in GCS for all time during trial 

gR_Scap =HTstog(1:3,1:3,:);

% jR - Rotation Matrix for Scap in Trunk_initial
jr_Scap_ti = zeros(3,3,length(t));

for b = 1:length(t)
  jr_Scap_ti(:,:,b)=  HTgtot(1:3,1:3,idx(1))*HTstog(1:3,1:3,b);
end

% jR - Rotation Matrix for Scap in Trunk (all frames)
jr_Scap_T = zeros(3,3,length(t));

for b = 1:length(t)
  jr_Scap_T(:,:,b)=  HTgtot(1:3,1:3,b)*HTstog(1:3,1:3,b);
end


%% Passing into ComputeEulerANgles
Scap_Ang_T = zeros(3,length(t));
ScapAng_Ti=zeros(3,length(t)); 
ScapAng_G= zeros(3,length(t)); 
Hum_Ang_T = zeros(3,length(t));
HumAng_Ti=zeros(3,length(t)); 
HumAng_G= zeros(3,length(t)); 
Trunk_ANG_Ti = zeros(3,length(t)); 
Trunk_ANG_G = zeros(3,length(t));
ELB_ANG = zeros(3,length(t)); % rows are angles  and cols are frames

for k = 1:length(t)
 [ELB_ANG(1:3,k),Trunk_ANG_G(1:3,k),Trunk_ANG_Ti(1:3,k),HumAng_G(1:3,k),HumAng_Ti(1:3,k),Hum_Ang_T(1:3,k),ScapAng_G(1:3,k),ScapAng_Ti(1:3,k),Scap_Ang_T(1:3,k)] = ComputeEulerAngles_2022(Fore_CS_G(:,:,k),Hum_CS_G(:,:,k),gR_trunk(:,:,k),jR_trunk(:,:,k),gR_Hum(:,:,k),jr_Hum_ti(:,:,k),jr_Hum_T(:,:,k),gR_Scap(:,:,k),jr_Scap_ti(:,:,k),jr_Scap_T(:,:,k),k);

end


%% Plotting Angles - Oct 2022


% RIGHT ARM
% First angle (about x axis): Extension: -  Flexion: + 
% Second angle : pro/supination. Supination: -  Pronation:+


%LEFT ARM
% First angle (about x axis): Extension: + Flexion: - 
% Second angle : pro/supination. Supination: -  Pronation:+ ? or flipped?

%close all

% Plotting Elbow Angles 
figure()
plot(ELB_ANG(1,:),'Linewidth',1.75) %Plotting Elbow Flex/Ext angle 
hold on
plot(ELB_ANG(2,:),'Linewidth',1.75) % Plotting Elbow Pronation/Supination angle
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Flex/Ext','Pro/Sup','Reach Start','Reach End','Fontsize',16)
title ('Elbow Angle','Fontsize',24)

% Trunk angles in GCS
figure()
plot(Trunk_ANG_G(1,:),'Linewidth',1.75) %Flexion
hold on
plot(Trunk_ANG_G(2,:),'Linewidth',1.75) % Lateral Bend
plot(Trunk_ANG_G(3,:),'Linewidth',1.75) % Twist
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Flex-/Ext+','LatBendR+/L-','TwistingR+/L-','Reach Start','Reach End','Fontsize',16)
title ('Trunk Angle in GCS ','Fontsize',24)

% Trunk angles in Ti
figure()
plot(Trunk_ANG_Ti(1,:),'Linewidth',1.75) %Flexion
hold on
plot(Trunk_ANG_Ti(2,:),'Linewidth',1.75) % Lateral Bend
plot(Trunk_ANG_Ti(3,:),'Linewidth',1.75) % Twist
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Flex-/Ext+','LatBendR+/L-','TwistingR+/L-','Reach Start','Reach End','Fontsize',16)
title ('Trunk Angle in Ti','Fontsize',24)


% Humerus angles in GCS
figure()
plot(HumAng_G(1,:),'Linewidth',1.75) %POLE
hold on
plot(HumAng_G(2,:),'Linewidth',1.75) % SABD
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Pole Angle','SABD','Reach Start','Reach End','Fontsize',16)
title ('Humerus Angle in GCS','Fontsize',24)

% Humerus angles in TI
figure()
plot(HumAng_Ti(1,:),'Linewidth',1.75) %POLE
hold on
plot(HumAng_Ti(2,:),'Linewidth',1.75) % SABD
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Pole Angle','SABD','Reach Start','Reach End','Fontsize',16)
title ('Humerus Angle in Ti','Fontsize',24)

% Humerus angles in T
figure()
plot(Hum_Ang_T(1,:),'Linewidth',1.75) %POLE
hold on
plot(Hum_Ang_T(2,:),'Linewidth',1.75) % SABD
xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Pole Angle','SABD','Reach Start','Reach End','Fontsize',16)
title ('Humerus Angle in T','Fontsize',24)


% Scap angles in GCS
figure()
plot(ScapAng_G(1,:),'Linewidth',1.75) %Lateral Rotation
hold on
plot(ScapAng_G(2,:),'Linewidth',1.75) % Forward backward tilt
plot(ScapAng_G(3,:),'Linewidth',1.75) % Pro/Re Traction

xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Lateral Rotation','Forward backward tilt','Pro/Re Traction','Reach Start','Reach End','Fontsize',16)
title ('Scap Angle in GCS','Fontsize',24)


% Scap angles in TI
figure()
plot(ScapAng_Ti(1,:),'Linewidth',1.75) %Lateral Rotation
hold on
plot(ScapAng_Ti(2,:),'Linewidth',1.75) % Forward backward tilt
plot(ScapAng_Ti(3,:),'Linewidth',1.75) % Pro/Re Traction

xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Lateral Rotation','Forward backward tilt','Pro/Re Traction','Reach Start','Reach End','Fontsize',16)
title ('Scap Angle in Ti','Fontsize',24)

% Scap angles in T
figure()
plot(Scap_Ang_T(1,:),'Linewidth',1.75) %Lateral Rotation
hold on
plot(Scap_Ang_T(2,:),'Linewidth',1.75) % Forward backward tilt
plot(Scap_Ang_T(3,:),'Linewidth',1.75) % Pro/Re Traction

xline(idx(1),'g','Linewidth',2)
xline(idx(3),'r','Linewidth',2)
legend('Lateral Rotation','Forward backward tilt','Pro/Re Traction','Reach Start','Reach End','Fontsize',16)
title ('Scap Angle in T','Fontsize',24)

pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Checking to see if GH has NANs via missing shoulder marker
    %OLD way prior to resampling
    %     if isnan(gh(idx(1),1)) || isnan(gh(idx(3),1))  %returns t- NAN start/end
    %         'NAN SHLDR present Start/End Trial'
    %
    %         num_real_sh = find(~isnan(gh(:,1))); %Finding indices where not NAN
    %
    %         if isnan(gh(idx(1),1))
    %         % for start index
    %         Locs1_start= find(num_real_sh<idx(1));
    %         Locs1_start = Locs1_start(length(Locs1_start));
    %
    %         Locs2_start= find(num_real_sh>idx(1),1);
    %         Locs2_start = num_real_sh(Locs2_start);
    %
    %         if abs(Locs2_start-Locs2_start)-1 <=5 % seeing if NANs consecutive
    %             [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %         else
    %             if abs(Locs2_start-Locs2_start)-1  ==6 % allowing if it's just 1 over
    %                 [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %             else
    %                 'CHECK GH DATA- NUM_NANS CONSEC START >5'
    %                 %            abs(NANLocations_2-NANLocations_1)-1
    %                 %             mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %         else
    %
    %         % end index
    %         Locs1_end= find(num_real_sh<idx(3));
    %         Locs1_end = Locs1_end(length(Locs1_end));
    %
    %         Locs2_end= find(num_real_sh>idx(3),1);
    %         Locs2_end = num_real_sh(Locs2_end);
    %
    %         if abs(Locs2_end-Locs1_end)-1  <=5 % seeing if NANs consecutive
    %             [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %         else
    %             if abs(Locs2_end-Locs2_end)-1  ==6 % allowing if it's just 1 over
    %                 [gh,TF] = fillmissing(gh,'spline','SamplePoints',t);
    %             else
    %                 'CHECK GH DATA- NUM_NANS CONSEC END >5'
    %                 %            abs(NANLocations_2-NANLocations_1)-1
    %                 %             mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %        end
    %
    %   end
    %     %% Checking to see where Trunk has NANs
    %     if isnan(xjug(idx(1),1)) || isnan(xjug(idx(3),1))  %returns true now if any element is NAN
    %         'NAN TRUNK present Start/End Trial'
    %         num_real_tr = find(~isnan(xjug(:,1))); %Finding # of reals
    %
    %         % for start index
    %         if isnan(xjug(idx(1),1))
    %         Locs1_start= find(num_real_tr<idx(1));
    %         Locs1_start = Locs1_start(length(Locs1_start));
    %
    %         Locs2_start= find(num_real_tr>idx(1),1);
    %         Locs2_start = num_real_tr(Locs2_start);
    %
    %         if abs(Locs2_start-Locs2_start)-1 <=5 % seeing if NANs consecutive
    %             %     if length(num_NANS_tr) <= 5 %threshold 5 NANS
    %             [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %         else
    %
    %             if abs(Locs2_start-Locs2_start)-1 ==6 % allowing if it's just 1 over
    %                 [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %             else
    %                 'CHECK Trunk DATA- NUM_NANS CONSEC START >5'
    %                 % mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %
    %         else
    %         % For end index
    %         Locs1_end= find(num_real_tr <idx(3));
    %         Locs1_end = Locs1_end(length(Locs1_end));
    %
    %         Locs2_end= find(num_real_tr>idx(3),1);
    %         Locs2_end = num_real_tr(Locs2_end);
    %
    %         if abs(Locs2_end-Locs1_end)-1 <=5 % seeing if NANs consecutive
    %             %     if length(num_NANS_tr) <= 5 %threshold 5 NANS
    %             [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %         else
    %
    %             if abs(Locs2_end-Locs2_end)-1 ==6 % allowing if it's just 1 over
    %                 [xjug,TF] = fillmissing(xjug,'spline','SamplePoints',t);
    %             else
    %                 'CHECK Trunk DATA- NUM_NANS CONSEC END >5'
    %                 % mfname
    %                 pause
    %                 continue
    %             end
    %         end
    %         end
    %     end
    
    %% Plotting Kinematic Data to Verify before outcome measures
    %
%     figure(9)
%     %
%     plot(xshldr(:,1),xshldr(:,2),'Linewidth',2) % Computed Acromion
%     hold on
%     %   plot(xshoulder(:,1),xshoulder(:,2),'Linewidth',2) % Computed Acromion
%     plot(xhand(:,1),xhand(:,2),'Linewidth',2) % Computed 3rd MCP
%     plot(xjug(:,1),xjug(:,2),'Linewidth',2) % Computed Jug Notch
%     
%     plot(gh(:,1),gh(:,2),'Linewidth',2) %esimated GH
%     
%     plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
%     plot(gh(idx(1),1),gh(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(gh(idx(3),1),gh(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
%     plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
%     plot(xshldr(idx(1),1),xshldr(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(xshldr(idx(3),1),xshldr(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
%     axis equal
%     legend('Acromion','3rd MCP','Jug Notch','Estimated GH','Start','End','FontSize',14)
%     title('Overhead View of Reach- GCS Raw' ,'FontSize',16)
%     xlabel('X position (mm)','FontSize',14)
%     ylabel('Y position (mm)','FontSize',14)
%     % pause
%   
%     







%%
 % September 2022
 
 % Below gives multiple ways to get data into trunk coordinate system. 
 % Current Method uses the HT matrix of TRUNK to include not just translation but
 % orientation ST data is in the frame of the TRUNK CS at the start of the
 % reach idx(1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    %% September 2022 - Using Trunk HT matrix to convert Hand, Shoulder, Trunk idx(1)- not just translation but rotation too
    
    
    % HAND
    
    xhand = [xhand repmat(1,length(xhand),1)]; 
    xhand = xhand';
  
    xhand = HTgtot(:,:,idx(1))* xhand; %Getting Hand in Trunk Frame at idx(1)
    
    xhand = xhand';
    
    
    % Shoulder 
        
    gh = [gh repmat(1,length(gh),1)]; 
    gh = gh';
  
    gh_start = HTgtot(:,:,idx(1))* gh; %Getting GH in Trunk Frame at 1 at idx(1)
    gh_end = HTgtot(:,:,idx(3))* gh; %Getting GH in Trunk Frame at 1 at idx(3)
   
    gh = HTgtot(:,:,idx(1))* gh; %Getting gh in Trunk Frame at 1 at idx(1)

    gh_start=  gh_start'; %Accounting for trunk rotation at the start 
    gh_end = gh_end'; % Accounting for trunk rotation at the end
    
    gh = gh';
    
    % Trunk 
    
    xjug = [xjug repmat(1,length(xjug),1)];
    xjug = xjug';
    
    xjug = HTgtot(:,:,idx(1))* xjug; %Getting Hand in Trunk Frame at idx(1)
    
    xjug = xjug';
    

    %% Subtracting Trunk at idx(1) frame From Hand, Arm Length, and Shoulder
%  
%     % Centering at the Trunk  (idx(1))
%     xhand = xhand-xjug(idx(1),:);
%     xjug_origin = xjug-xjug(idx(1),:);
%     xshldr = xshldr - xjug(idx(1),:);
%     
%     % for GH need to also account for trunk contributing to shoulder 
%   
%     gh = gh-xjug(idx(1),:);
%     
%     gh = gh - xjug_origin;% Subtracting trunk from shoulder so Shoulder not including trunk movement
%        
%     
    
    %% Subtracting Trunk at first frame of trial From Hand, Arm Length, and Shoulder
%  
%     %Centering at the Trunk CS (first time point)
%     xhand = xhand-xjug(1,:);
%     xjug_origin = xjug-xjug(1,:);
%     xshldr = xshldr - xjug(1,:);
%     
%     % for GH need to also account for trunk contributing to shoulder 
%   
%     gh = gh-xjug(1,:); %Centering Sh at the Trunk CS (first time point)
%     
%     gh = gh - xjug_origin;% Subtracting trunk from shoulder so Shoulder not including trunk movement
%     
    %% Fixing CS issue. Need to flip about trunk - Had to flip BL plot
    %     RTIS 2008- Left
    xhandnew = zeros(3,length(xhand));
    ghnew =zeros(3,length(xhand));
    xshldrnew =zeros(3,length(xshldr));
%     
%     if strcmp(partid,'RTIS2008')
%         if strcmp(hand,'Left')
%             
%             for p = 1:length(gh)
%                 ghnew(:,p) = roty(pi)*gh(p,:)';
%                 xhandnew(:,p) = roty(pi)*xhand(p,:)';
%                 xshldrnew(:,p) = roty(pi)*xshldr(p,:)';
%             end
%             
%             ghnew = ghnew';
%             xhandnew= xhandnew';
%             xshldrnew= xshldrnew';
%             
%             gh = ghnew;
%             xhand = xhandnew;
%             xshldr = xshldrnew;
%         end
%     end
    
    %RTIS 2010- Left
    
%     if strcmp(partid,'RTIS2010')
%         if strcmp(hand,'Left')
%             for p = 1:length(gh)
%                 ghnew(:,p) = roty(pi)*gh(p,:)';
%                 xhandnew(:,p) = roty(pi)*xhand(p,:)';
%                 xshldrnew(:,p) = roty(pi)*xshldr(p,:)';
%                 
%             end
%             
%             ghnew = ghnew';
%             xhandnew= xhandnew';
%             xshldrnew= xshldrnew';
%             
%             
%             gh = ghnew;
%             xhand = xhandnew;
%             xshldr = xshldrnew;
%             
%         end
%     end
    
    %%  Plots Post Subtraction of Initial Trunk Position - final data for outcome measures
    
    
%     figure(35)
%     plot(xhand(:,1),xhand(:,2),'Linewidth',2) % Computed 3rd MCP
%     hold on
%     plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
%     plot(xjug(:,1),xjug(:,2),'Linewidth',2)  % Computed Jug Notch
%     
%     plot(gh(:,1),gh(:,2),'Linewidth',2)
%     % plot(xshldr(:,1),xshldr(:,2),'Linewidth',3)
%     
%     plot(gh(idx(1),1),gh(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     plot(gh(idx(3),1),gh(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking shoulder start
%     
% 
%     plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking trunk start
%     plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); %marking trunk end
%       
%     plot(0,0,'o','MarkerEdgeColor','g','MarkerSize',10); %trunk start which will always be at 0,0 --> centered at trunk start
% 
%     axis equal
%     legend('3rd MCP','Reach Start','Reach End', 'Trunk',' Computed Gh','FontSize',14)
%     title('Overhead View of Reach- HT Trunk Initial Position' ,'FontSize',16)
%     xlabel('X position (mm)','FontSize',14)
%     ylabel('Y position (mm)','FontSize',14)
%     

    
 %% OUTCOME MEASURES   
    %% Compute reaching distance
    
    % Def: between 3rd MCP and Computed Glenohumeral Joint Location at end
    % of reach (timepoint idx(3))
    
    % XY Definition
   % maxreach = sqrt((xhand(idx(3),1)-gh(idx(3),1))^2+(xhand(idx(3),2)-gh(idx(3),2))^2); 
   
   % XYZ Definition
   %                             X                              Y                              Z        
     maxreach = sqrt((xhand(idx(3),1)-gh(idx(3),1))^2+(xhand(idx(3),2)-gh(idx(3),2))^2+(xhand(idx(3),3)-gh(idx(3),3))^2);
    %% Max Hand Excursion
    
    % Def: difference in hand final - initial. xhand(idx3) - xhand(idx1)
    % 3rd MCP
    
    % XY Definition
   % maxhandexcrsn = sqrt((xhand(idx(3),1)-xhand(idx(1),1))^2 +(xhand(idx(3),2)-xhand(idx(1),2))^2);
    
   % XYZ Definition
   %                             X                                   Y                                      Z
   maxhandexcrsn = sqrt((xhand(idx(3),1)-xhand(idx(1),1))^2 +(xhand(idx(3),2)-xhand(idx(1),2))^2+(xhand(idx(3),3)-xhand(idx(1),3))^2);

    
    %% Compute shoulder and trunk displacement at maximum reach
    
    % Trunk
    % Based on jugular notch difference idx(3) - idx(1)
    
    % XY PLANE
    %trunk_exc =  sqrt((xjug(idx(3),1)-xjug(idx(1),1))^2 +(xjug(idx(3),2)-xjug(idx(1),2))^2);
    
    % XYZ PLANE
    trunk_exc =  sqrt((xjug(idx(3),1)-xjug(idx(1),1))^2 +(xjug(idx(3),2)-xjug(idx(1),2))^2+(xjug(idx(3),3)-xjug(idx(1),3))^2);

    % Shoulder
    %Def: difference in gh final - gh initial. gh(idx3) - gh(idx1)
    
    %sh_exc =  sqrt((gh(idx(3),1)-gh(idx(1),1))^2 +(gh(idx(3),2)-gh(idx(1),2))^2);
    
   % XY PLANE
   % sh_exc =  sqrt((gh_end(idx(3),1)-gh_start(idx(1),1))^2 +(gh_end(idx(3),2)-gh_start(idx(1),2))^2);

   % XYZ PLANE
   sh_exc =  sqrt((gh_end(idx(3),1)-gh_start(idx(1),1))^2 +(gh_end(idx(3),2)-gh_start(idx(1),2))^2+(gh_end(idx(3),3)-gh_start(idx(1),3))^2);


   % Z Shoulder Excursion
   sh_Z_ex = gh_end(idx(3),3)-gh_start(idx(1),3); %only Z component
    
    % Trunk Ang Disp : based on ComputeEulerAngles - flexion extension
    %TrunkAng_GCS_Disp = TrunkAng_GCS(idx(3),1)-TrunkAng_GCS(idx(1),1);
   
    %% Trunk, Shoulder, Hand Excursion, and reaching distance for the current trial
    maxhandexcrsn_current_trial(i) = maxhandexcrsn; %hand excursion defined as difference between hand at every point and inital shoudler position
    
    maxreach_current_trial(i) =maxreach; % reaching distance in mm difference hand and shoudler
    
    shex_current_trial(i) = sh_exc;
    sh_Z_ex_current_trial(i) = sh_Z_ex;
    
    trex_current_trial(i) = trunk_exc;
    
    % TrunkAng_current_trial(i) = TrunkAng_GCS_Disp;
    
    %% Plotting EMGS
    %  [emg_timevel emg_timestart]= PlotEMGsCleanV2(emg,timestart,timevelmax,timedistmax,i)% disp([partid ' ' expcondname{expcond} ' trial ' num2str(i)])
    %
    %  emgvel_trial(i,:) = emg_timevel;
    %  emgstart_trial(i,:) = emg_timestart;
    
    

    %% Main Cumulative Metria Figure
  
    
%     % Uncomment everything below once for plotting 
%     figure(4)
% 
% 
%         if strcmp(partid,'RTIS1003')
%              
%             if expcond ==1
%                 circle(-136.867,374.745,50)
%                 hold on
%             end
%                      
%             if expcond ==2
%                 circle(-216.974,434.737,50)
%                 hold on
%             end
%                      
%             if expcond ==3
%                 circle(-211.473,419.337,50)
%                 hold on
%             end
%                                  
%             if expcond ==4
%                  circle(-117,241,50)
%                 hold on
%             end
%                                              
%             if expcond ==5
%                  circle(-209,342,50)
%                 hold on
%             end
%                                             
%             if expcond ==6
%                   circle(-125,274,50)
%                 hold on
%             end
% 
% 
%         end
% %         
%         if strcmp(partid,'RTIS1004')
%             %             
%             if expcond ==1
%                 circle(-139,341,50)
%                 hold on
%             end
%             if expcond ==2
%                 circle(-64,442,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-91,355,50)
%                 hold on
%             end
%             
%                         
%             if expcond ==4
%                 circle(-126,419,50)
%                 hold on
%             end
%                  
%                                    
%             if expcond ==5
%                 circle(-111,443,50)
%                 hold on
%             end
%                                               
%             if expcond ==6
%                 circle(-104,416,50)
%                 hold on
%             end
%                      
% 
%         end
%         
%         if strcmp(partid,'RTIS1005')
% 
%             if expcond ==1
%                 circle(162,315,50)
%                 hold on
%             end
%             if expcond ==2
%                 circle(161,408,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(156,408,50)
%                 hold on
%             end
%             
%                         
%             if expcond ==4
%                 circle(186,340,50)
%                 hold on
%             end
%                  
%                                    
%             if expcond ==5
%                 circle(144,360,50)
%                 hold on
%             end
%                                               
%             if expcond ==6
%                 circle(154,356,50)
%                 hold on
%             end
% 
% 
% 
%         end
%         
%         if strcmp(partid,'RTIS1006')
% 
%             if expcond ==1
%                 circle(109,280,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(87,287,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(95,274,50)
%                 hold on
%             end
%             
%                         
%             if expcond ==4
%                 circle(96,236,50)
%                 hold on
%             end
%                  
%                                    
%             if expcond ==5
%                 circle(95,253,50)
%                 hold on
%             end
%                                               
%             if expcond ==6
%                 circle(71,250,50)
%                 hold on
%             end
%             
%         end
%         
% 
%      
%         if strcmp(partid,'RTIS2001') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                  circle(-234,331,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-282,312,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-282,312,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-234,331,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-232,265,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-232,265,50)
%                 hold on
%             end
%             
%         end   
% 
%         if strcmp(partid,'RTIS2002') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                 circle(-179,290,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-77,307,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-70,285,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-145,291,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-111,298,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-108,309,50)
%                 hold on
%             end
%             
%         end
%         
%         
%         if strcmp(partid,'RTIS2002') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                  circle(185,367,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(185,367,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(185,367,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(185,367,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(142,403,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(142,403,50)
%                 hold on
%             end
%             
%         end
%               
%                 
%         if strcmp(partid,'RTIS2003') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                 circle(-139,332,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-154,331,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-132,316,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-72,281,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-58,301,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-79,288,50)
%                 hold on
%             end
%             
%         end
%                         
%         if strcmp(partid,'RTIS2003') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                  circle(196,278,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(196,278,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(196,278,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(196,278,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(196,278,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(196,278,50)
%                 hold on
%             end
%             
%         end
%         
%                         
%         if strcmp(partid,'RTIS2006') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                 circle(23,349,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(12,305,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(12,305,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-37,359,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-19,294,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-19,294,50)
%                 hold on
%             end
%             
%         end
%         
%                                 
%         if strcmp(partid,'RTIS2006') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                 circle(-83,259,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-59,296,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-59,296,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-71,212,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-91,270,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-91,270,50)
%                 hold on
%             end
%             
%         end
%                                 
%         if strcmp(partid,'RTIS2007') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                  circle(23,301,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-40,209,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-39,213,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(12,305,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-53,207,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-53,207,50)
%                 hold on
%             end
%             
%         end
%                                         
%         if strcmp(partid,'RTIS2007') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                   circle(-252,337,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-252,337,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-252,337,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-268,289,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-308,339,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-308,339,50)
%                 hold on
%             end
%             
%         end
%         
%         
%         if strcmp(partid,'RTIS2008') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                   circle(227,356,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(227,356,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(273,332,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(227,356,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(225,304,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(225,304,50)
%                 hold on
%             end
%             
%         end
%                 
%         if strcmp(partid,'RTIS2008') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                    circle(-123,441,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-128,394,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-128,394,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-122,370,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-122,370,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-122,370,50)
%                 hold on
%             end
%             
%         end
%                 
%         if strcmp(partid,'RTIS2009') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                   circle(-100,305,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-100,305,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-100,305,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-60,266,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-60,266,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-55,315,50)
%                 hold on
%             end
%             
%         end
%                        
%         if strcmp(partid,'RTIS2009') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                    circle(216,415,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(189,362,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(189,362,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(198,359,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(198,359,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(198,320,50)
%                 hold on
%             end
%             
%         end
%          
%                         
%         if strcmp(partid,'RTIS2010') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                    circle(219,377,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(173,282,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(173,282,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(168,419,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(116,325,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(116,325,50)
%                 hold on
%             end
%             
%         end
%         
%                 
%                         
%         if strcmp(partid,'RTIS2010') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                     circle(-68,340,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-68,340,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-68,340,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-89,315,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-65,368,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(-65,368,50)
%                 hold on
%             end
%             
%         end
%                                  
%         if strcmp(partid,'RTIS2011') && strcmp(hand,'Left')
%             
%             if expcond ==1
%                     circle(-49,320,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(-4,282,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(-4,232,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(-32,290,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(-22,252,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(5,241,50)
%                 hold on
%             end
%             
%         end
%         
%                                          
%         if strcmp(partid,'RTIS2011') && strcmp(hand,'Right')
%             
%             if expcond ==1
%                      circle(182,415,50)
%                 hold on
%             end
%             
%             if expcond ==2
%                 circle(182,415,50)
%                 hold on
%             end
%             
%             if expcond ==3
%                 circle(182,415,50)
%                 hold on
%             end
%             
%             
%             if expcond ==4
%                 circle(218,380,50)
%                 hold on
%             end
%             
%             
%             if expcond ==5
%                 circle(218,380,50)
%                 hold on
%             end
%             
%             if expcond ==6
%                 circle(218,380,50)
%                 hold on
%             end
%             
%         end
% 
%         
% 
%  
% 
% 
%    p1=plot( [xhand(idx(1):idx(3),1) gh(idx(1):idx(3),1) xjug(idx(1):idx(3),1)],[xhand(idx(1):idx(3),2) gh(idx(1):idx(3),2) xjug(idx(1):idx(3),2)],'LineWidth',3);% not subtracting trunk
% 
%    hold on
%    c1= plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10);
%    c2= plot(xhand(idx(3),1),xhand(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10);
%     % %      c4 = plot(xhand(rangeZ,1),xhand(rangeZ,2),'ro');
%     %     %%
%     %     %      c1= viscircles([xhand(idxreachstart,1),xhand(idxreachstart,2)],5,'Color','g');
%     %     %          c1= plot(xhand(idx(1),1),xhand(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10);
%     %
%     %     %         plot(xshldr(idx(1),1),xshldr(idx(1),2),'o','MarkerEdgeColor','g','MarkerSize',10); %marking shoulder start
%     %     %         plot(xshldr(idx(3),1),xshldr(idx(3),2),'o','MarkerEdgeColor','r','MarkerSize',10); % marking shoulder end
%     %     %%
%     %     %          plot(gh(idx(1),1)-xjug(1,1),gh(idx(1),2)-xjug(1,2),'o','MarkerFaceColor','g','MarkerSize',10); %marking shoulder start
%     %     %          plot(gh(idx(3),1)-xjug(1,1),gh(idx(3),2)-xjug(1,2),'o','MarkerFaceColor','r','MarkerSize',10); % marking shoulder end
%     %     %
%     %     %
%     %     %         plot(xjug(idx(1),1)-xjug(1,1),xjug(idx(1),2)-xjug(1,2),'o','MarkerFaceColor','g','MarkerSize',10); %marking trunk start
%     %     %         plot(xjug(idx(3),1)-xjug(1,1),xjug(idx(3),2)-xjug(1,2),'o','MarkerFaceColor','r','MarkerSize',10); % marking trunk end
%     %
%     
%     
%    plot(gh(idx(1),1),gh(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); %marking shoulder start
%    plot(gh(idx(3),1),gh(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10); % marking shoulder end
%     
%     
%    plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); %marking trunk start
%    plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10); % marking trunk end
%     
%    set(p1(1),'Color',[0 0.4470 0.7410]); set(p1(2),'Color',[0.4940 0.1840 0.5560]); set(p1(3),'Color',[0.8500 0.3250 0.0980]);
%     
%     
%     
%    xlabel('X (mm)','FontSize',16)
%    ylabel('Y (mm)','FontSize',16)
%     
% 
%     
% if expcond== 1 || 3   
%     legend([p1' c1 c2],'Hand','Shoulder','Trunk','Start','End','Home Target','Location','northeast','FontSize',15)
%  end  
% 
%         
%         if expcond== 1
%             title(['Restrained Table' '-' partid],'FontSize',18)
%         end
%         
%         if expcond== 2
%             title(['Restrained 25% MVT' '-' partid],'FontSize',18)
%         end
%         
%         if expcond== 3
%             title(['Restrained 50% MVT' '-' partid],'FontSize',18)
%         end
%         
%         if expcond== 4
%             title(['Unrestrained Table' '-' partid],'FontSize',18)
%         end
%         
%         if expcond== 5
%             title(['Unrestrained 25% MVT' '-' partid],'FontSize',18)
%         end
%         
%         if expcond== 6
%             title(['Unrestrained 50% MVT' '-' partid],'FontSize',18)
%         end

        
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Not currently using%%%%%%%%
    
    %     % Plotting Trunk Angulation
    %     figure(4)
    % %
    % %     if i ==1
    % %         ax2 = axes('Position',[0.05 0.04 0.4 0.20]);
    % %         if strcmp(partid,'RTIS2001') && strcmp(hand,'Right')
    % %             ylim(ax2,[-5 15])
    % %             xlim(ax2,[0 5])
    % %         end
    % %     end
    % % %
    % %
    %       if i ==StartingTrial
    %         ax2 = axes('Position',[0.05 0.04 0.4 0.20]);
    %
    %       end
    
    % %
    %     hold(ax2,'on')
    %     p2 = plot(ax2,t(idx(1):idx(3)),TrunkAng_GCS(idx(1):idx(3),1),'LineWidth',3,'Color',[0.8500 0.3250 0.0980]);
    %       hold(ax2,'on')
    %
    %     c3 =plot(ax2,t(idx(1)),TrunkAng_GCS(idx(1)),'o','MarkerFaceColor','g','MarkerSize',10);
    %     c4 = plot(ax2,t(idx(3)),TrunkAng_GCS(idx(3)),'o','MarkerFaceColor','r','MarkerSize',10);
    %     legend([p2 c3 c4],'Trunk Angle (Deg)','Reach Start','Reach End','Location','northwest','FontSize',12)
    %
    %     xlabel('Time (s)','FontSize',14)
    %     ylabel('Trunk Angle (Deg)','FontSize',14)
    %     legend('Trunk Angle (Deg)','Reach Start','Reach End','FontSize',12,'Location','NorthWest')
    %
    % %
    %     if i ==StartingTrial
    %         ax3 = axes('Position',[0.52 0.04 0.4 0.20]);
    % %
    %     end
    % % %
    % % figure(20)
    % % %     hold(ax3,'on')
    % %    p3 =  plot(xjug(idx(1):idx(3),1),xjug(idx(1):idx(3),2),'LineWidth',3,'Color',[0.8500 0.3250 0.0980]);
    % % %      hold(ax3,'on')
    % % hold on
    % %     c5 = plot(xjug(idx(1),1),xjug(idx(1),2),'o','MarkerFaceColor','g','MarkerSize',10); %marking trunk start
    % %     c6 = plot(xjug(idx(3),1),xjug(idx(3),2),'o','MarkerFaceColor','r','MarkerSize',10); % marking trunk end
    % %     hold on
    % %
    % % %         legend([p3 c5 c6],'Trunk Angle (Deg)','Reach Start','Reach End','Location','northwest','FontSize',12)
    % %
    % %     legend('Trunk Position (mm)','Reach Start','Reach End','FontSize',12,'Location','NorthWest')
    % %     xlabel('X (mm)','FontSize',14)
    % %     ylabel('Y (mm)','FontSize',14)
    % %
    % %
    % %           axis equal
    %          end
    %pause
    %% Calling COP Function
    %        ppsdata =data.pps;
    %        tpps = data.pps{1,1};
    %        ppsdata= ppsdata{1,2};
    %
    %        %Getting start and end time in seconds
    %        t_start = t(idx(1));
    %        t_end = t(idx(3));
    
    
    % Use if plotting small multiples
    %        if i ==1
    %            [sm sm2] = Process_PPS(ppsdata,tpps,t_start,t_end,hand,partid,i,mfname);
    %        else
    %            [sm sm2] = Process_PPS(ppsdata,tpps,t_start,t_end,hand,partid,i,mfname,sm,sm2);
    %        end
    
    
    %Process_PPS(ppsdata,tpps,t_start,t_end,hand,partid,i,mfname,expcond);
    % ComputeCOP(ppsdata,tpps,t_start,t_end,hand,partid,i)
    
    %% Saving Kinematic Position Data to Large Matrix
    
    
    armlength = (setup.exp.armLength+setup.exp.e2hLength)*10;
    
    % Lines below if adding a new participant to sheet
    %         nextrow = size(DataMatrix,1);
    %         DataMatrix{nextrow+1,1} = partid;
    %         DataMatrix{nextrow+1,2} = expcond;
    %         DataMatrix{nextrow+1,3} = mfname;
    %         DataMatrix{nextrow+1,4} = maxreach_current_trial(i);
    %         DataMatrix{nextrow+1,5} = maxreach_current_trial(i)/armlength*100 ;
    
    %         DataMatrix{nextrow+1,6} = maxhandexcrsn_current_trial(i);
    %         DataMatrix{nextrow+1,7}= maxhandexcrsn_current_trial(i)/armlength*100;
    %        DataMatrix{nextrow+1,8} =  trex_current_trial(i);
    %         DataMatrix{nextrow+1,9} = trex_current_trial(i)/armlength*100;
    %         DataMatrix{nextrow+1,10} = shex_current_trial(i);
    %         DataMatrix{nextrow+1,11} = shex_current_trial(i)/armlength*100;
    
    % Adding Outcome Measures to Data Matrix - USE if already have
    % participant data matrix and want to update - MAKE SURE TO CHANGE AT
    % START OF CODE WHICH DATA MATRIX LOADING IN --> PARETIC/NP/CONTROLS
    
    trialrow =   find(strcmp(DataMatrix(:,3),mfname)); %Finding File name
    Currentrow =  find(strcmp(DataMatrix(trialrow,1),partid)); %Finding Participant with that filename
    FinalRow = trialrow(Currentrow);
    
    %
    %     'Check Data Matrix Repopulation'
    

%     % Updating the Data Matrix with Outcome Measures
%     DataMatrix{1,13}= 'ShEx_Z mm'; %ONCE ALL  gone through can remove
%     DataMatrix{1,14}= 'ShEx_Z %LL'; %ONCE ALL  gone through can remove
% 
% 
%     DataMatrix{FinalRow,14} = sh_Z_ex_current_trial(i)/armlength*100; %Shoulder Z component excursion - Norm to LL
%     DataMatrix{FinalRow,13} = sh_Z_ex_current_trial(i); %Shoulder Z component excursion - Raw in MM
% 
%     %     DataMatrix{FinalRow,12} = TrunkAng_current_trial(i);
%     DataMatrix{FinalRow,11} = shex_current_trial(i)/armlength*100;
%     DataMatrix{FinalRow,10} = shex_current_trial(i);
%     DataMatrix{FinalRow,9} = trex_current_trial(i)/armlength*100;
%     DataMatrix{FinalRow,8} =  trex_current_trial(i);
%     DataMatrix{FinalRow,7}= maxhandexcrsn_current_trial(i)/armlength*100;
%     DataMatrix{FinalRow,6} = maxhandexcrsn_current_trial(i);
%     DataMatrix{FinalRow,5} = maxreach_current_trial(i)/armlength*100 ;
%     DataMatrix{FinalRow,4} = maxreach_current_trial(i);
    %     DataMatrix{FinalRow,2} = expcond;
    %     %
    %
    %      pause
    
    %     close all
    
    
end



%  DataMatrix = AllData;
%save FullDataMatrix.mat DataMatrix

%% Printing out the max reach, std, shoulder and trunk displacement and std

% UPDATED KCS Jan 2022 -- to fix large standard dev issue
% Need to change 0s from skipped trials to NANs-- this is averages per
% condition..... don't use if want every single trial

for k = 1:length(maxreach_current_trial)
    
    if maxreach_current_trial(k)== 0
        maxreach_current_trial(k) = nan;
    end
    if maxhandexcrsn_current_trial(k) ==0
        maxhandexcrsn_current_trial(k) = nan;
    end
    if shex_current_trial(k) ==0
        shex_current_trial(k) = nan;
    end
    
    if trex_current_trial(k) ==0
        trex_current_trial(k) = nan;
    end
    
    %     if TrunkAng_current_trial(k) ==0
    %         TrunkAng_current_trial(k)= nan;
    %     end
end


avgmaxreach =nanmean(maxreach_current_trial);
std_maxreach = nanstd(maxreach_current_trial);

avgmaxhand = nanmean(maxhandexcrsn_current_trial);
std_maxhand= nanstd(maxhandexcrsn_current_trial);

%Updated based on GH computation
avgshldr = nanmean(shex_current_trial);
stdshldr = nanstd(shex_current_trial);

%Trunk Displacement
avgtrunk = nanmean(trex_current_trial);
stdtrunk = nanstd(trex_current_trial);

%Trunk Angle
% avgtrunk_ANG = nanmean(TrunkAng_current_trial);
% stdtrunk_ANG = nanstd(TrunkAng_current_trial);


end
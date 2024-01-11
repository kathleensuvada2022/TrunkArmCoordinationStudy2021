function maxEMG=GetMaxMusAct2024(flpath,basename,setfname,partid,plotflag,hand)
% Function to get the maximum EMGs from the MVC Torques data. The output is a .mat file (*MaxEMG.mat)
% which contains the following matrices:
% Inputs: basename: triacleal file name (before index)
%         setfname: setup filename.
%         plotflag: 1-plot torques, 0-do not plot torques
% Outputs: maxEMG: [1 x nEMG]. Maximum EMG for each channel
%          maxidx: [1 x nEMG]. Trial index where max EMG occurred
% 7/19 AMA - updated routine for Kacey's trunk-arm reaching data
% Updated 10.2019
% Dec 2023
% Usage example:
%    [maxEMG]=GetMaxMusAct('/Users/kcs762/Documents/MATLAB/Data/AIM1/MaxEMGS/owen061819maxemgs/Left','max','savedsetupKacey',1)


load([flpath '/' setfname]);

sampRate= setup.daq.sRate;

% Specify the width of the averaging window in seconds
avgwindow=0.25; ds=sampRate*avgwindow;
trials=dir([flpath '/*' basename '*.mat']);


%emgchan = chanList(1:15);
emgchan = {'LES','RES','LRA','RRA','LEO','REO','LIO','RIO','UT','MT','LD','PM','BIC','TRI','IDEL'};
nEMG= length(emgchan);
maxTEMG=zeros(length(trials),nEMG);
Tlength=zeros(length(trials),1);
%%
for j=1:length(trials)
    disp([flpath 'maxes' num2str(j)])

    %Replace this line with however you load your data. Important to
    %include the code that selects the jth file

     load([flpath basename num2str(j)]);
        %         data= Totaldata.data %updated 10.2019
%     catch maxTEMG(j,:)=zeros(1,nEMG); continue % make comment about error after catch
    
    %     Tlength(j)=length(data);

    emg=detrend(data(:,1:15)); %updated 12.2023- using raw not filtered maxes
    % Rectify EMG

     emg=abs(emg);

    emg = emg-repmat(mean(emg(1:250,:)),length(emg),1); %removes baseline
    %% SETTING NOISE FILLED CHANNELS TO 0

    % For use when entire trial is bad and need to set values to 0 for
    % given channel.

    if strcmp(partid,'RTIS2001')  && strcmp(hand,'Right')
        if j==34 %trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
            iemg=7;% LIO
            emg(:,iemg) = 0;
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j ==2
            iemg=2;% RES
            emg(:,iemg) = 0;
        elseif j ==1
            iemg=13;% BIC
            emg(:,iemg) = 0;
        elseif j ==31
%             iemg=7;% LIO
%             emg(:,iemg) = 0;
        elseif j ==32
%             iemg=7;% LIO
%             emg(:,iemg) = 0;
        elseif j ==33
            iemg=2;% RES
            emg(:,iemg) = 0;
            iemg=7;% LIO
            emg(:,iemg) = 0;
        elseif j ==20
            iemg=2;% RES
            emg(:,iemg) = 0;
%             iemg=7;% LIO
%             emg(:,iemg) = 0;
        elseif j==21 % trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
%             iemg=7;% LIO
%             emg(:,iemg) = 0;
        elseif j==19 % trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
            iemg=7;% LIO
            emg(:,iemg) = 0;
        end
    end
    %% RTIS2001 Left Non-Paretic
    if strcmp(partid,'RTIS2001')  && strcmp(hand,'Left')
        if j==1 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==2 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==3 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==4 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==5 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==6 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==7 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==8 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==9 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==10 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==11 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==12 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==13 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==14 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==15 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==16 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==17 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==18 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
%             iemg=15;% IDEL
%             emg(:,iemg) = 0;
        elseif j==19 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
%             iemg=15;% IDEL
%             emg(:,iemg) = 0;
        elseif j==20 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
%             iemg=15;% IDEL
%             emg(:,iemg) = 0;
        elseif j==21 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==22 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==23 %trial num
            iemg=8;% RIO
            emg(:,iemg) = 0;
        elseif j==27 %trial num
            iemg=12;% PM
            emg(:,iemg) = 0;
        elseif j==29 %trial num
            iemg=12;% PM
            emg(:,iemg) = 0;
            iemg=13;% BIC
            emg(:,iemg) = 0;
        end
    end

    %% RTIS2002 Paretic Left
    if strcmp(partid,'RTIS2002')  && strcmp(hand,'Left')
        if j ==4
            iemg=7;% LIO
            emg(:,iemg) = 0;
        elseif j==33 %trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
        elseif j ==27
            iemg=2;% RES
            emg(:,iemg) = 0;
        elseif j ==32
            iemg=7;% LIO
            emg(:,iemg) = 0;
        elseif j ==34
            iemg=7;% LIO
            emg(:,iemg) = 0;
        end
    end

    if strcmp(partid,'RTIS2002')  && strcmp(hand,'Right')
        if j ==28
            iemg=1;% LES
            emg(:,iemg) = 0;
        end
    end

    %% RTIS2003
    if strcmp(partid,'RTIS2003')  && strcmp(hand,'Left')

        if j==35 %trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
        end
    end

    %% RTIS2006
    if strcmp(partid,'RTIS2006')  && strcmp(hand,'Right')

        if j==2 %trial num
            iemg=2;% RES
            emg(:,iemg) = 0;

        elseif j==7 %trial num
            iemg=2;% RES
            emg(:,iemg) = 0;
        end
    end

    if strcmp(partid,'RTIS2006')  && strcmp(hand,'Left')

        if j<=21 %trial num
            iemg=6;% REO
            emg(:,iemg) = 0;

            iemg=7;% LIO
            emg(:,iemg) = 0;

            if j==7 %trial num
                iemg=2;% RES
                emg(:,iemg) = 0;
            end
        end
    end


    if strcmp(partid,'RTIS2007')  && strcmp(hand,'Right')

        if j<30 %trial num
            iemg=8;% RIO
             emg(:,iemg) = 0;

        elseif j==7 %trial num
    
        end
    end


    if strcmp(partid,'RTIS2007')  && strcmp(hand,'Left')

        if j==34 %trial num
            iemg=1;% LES
            emg(:,iemg) = 0;

            iemg=2;% RES
            emg(:,iemg) = 0;
        end
        if j <24
            iemg=3;% LRA
            emg(:,iemg) = 0;

            iemg=4;% RRA
            emg(:,iemg) = 0;
                    
            if j ==5
           
                iemg=5;% LEO
                emg(:,iemg) = 0;

            end  
            if j ==6
                iemg=4;% RRA
                emg(:,iemg) = 0;
                iemg=5;% LEO
                emg(:,iemg) = 0;

            end
            if j==7
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j==8
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j==14
                iemg=3;% LRA
                emg(:,iemg) = 0;
            end

            if j ==16
                iemg=4;% RRA
                emg(:,iemg) = 0;
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j ==17
                iemg=4;% RRA
                emg(:,iemg) = 0;
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j ==18
                iemg=4;% RRA
                emg(:,iemg) = 0;
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j==19
                iemg=5;% LEO
                emg(:,iemg) = 0;
            end
            if j==20
                iemg=4;% RRA
                emg(:,iemg) = 0;

      
            end

            if j==21
                iemg=3;% RRA
                emg(:,iemg) = 0;
            end
            if j==22
                iemg=3;% LRA
                emg(:,iemg) = 0;
            end
            if j==23
                iemg=3;% LRA
                emg(:,iemg) = 0;
            end
        end

      if j==33 %trial num
            iemg=1;% LES
            emg(:,iemg) = 0;

            iemg=2;% RES
            emg(:,iemg) = 0;
      end
    end

   

%% Computing Mean and Maxes after setting bad trials to 0 

% Compute the mean EMG
meanEMG=movmean(emg,ds);
% Find maximum EMG
[maxTEMG(j,:),maxtidx(j,:)]=max(meanEMG);

%% Skipping Samples where Artifacts Occur 2024

if strcmp(partid,'RTIS2001')  && strcmp(hand,'Right') % Participant and Arm

    % KACEY 2024- NOTE TRIAL !!! JUST USE j! Not trials.j

    if j==1 % Trial containing artifact
        % In order to exclude the artifact from the analysis, set upid
        % and dnid to the beginning sample and final sample of the
        % trial that excludes the artifact. iemg is the EMG channel
        % that has the artifact.
                    upid=1; dnid=3500; iemg=4;% RRA
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
                    
                    upid=2000; dnid=5000; iemg=6;% REO
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
% 
                    upid=3300; dnid=5000; iemg=11;% LD
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    end

end

if strcmp(partid,'RTIS2001')  && strcmp(hand,'Left') % Participant and Arm

    if j==15 % Trial containing artifact
        % In order to exclude the artifact from the analysis, set upid
        % and dnid to the beginning sample and final sample of the
        % trial that excludes the artifact. iemg is the EMG channel
        % that has the artifact.
                    upid=2200; dnid=4000; iemg=5;% LEO
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
                    
%                     upid=2000; dnid=5000; iemg=6;% REO
%                     [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%                     maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
% 
%                     upid=3300; dnid=5000; iemg=11;% LD
%                     [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
%                     maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==27
                    upid=3800; dnid=5000; iemg=11; %LD
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==28
        upid=1250; dnid=4500; iemg=12; %PM
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==29
                    upid=3800; dnid=5000; iemg=11; %LD
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==34
                    upid=2200; dnid=3600; iemg=12; %PM
                    [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
                    maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    end

end

if strcmp(partid,'RTIS2002')  && strcmp(hand,'Left') % Participant and Arm
    if j==8
        upid=1; dnid=2900; iemg=8;% RIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    
       elseif j==13
        upid=1; dnid=2200; iemg=8;% RIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==17 % Trial containing artifact
        % In order to exclude the artifact from the analysis, set upid
        % and dnid to the beginning sample and final sample of the
        % trial that excludes the artifact. iemg is the EMG channel
        % that has the artifact.
        upid=2050; dnid=5000; iemg=5;% LEO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        %                     upid=2000; dnid=5000; iemg=6;% REO
        %                     [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        %                     maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        %
        %                     upid=3300; dnid=5000; iemg=11;% LD
        %                     [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        %                     maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==26
        upid=1; dnid=3400; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        upid=1; dnid=3200; iemg=8; %RIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==27
        upid=1; dnid=4200; iemg=8; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==29
        upid=2000; dnid=5000; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        upid=1800; dnid=5000; iemg=8; %RIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==33
        upid=4400; dnid=5000; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==34
        upid=1900; dnid=2400; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==35
        upid=1; dnid=1900; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==36
        upid=2200; dnid=3200; iemg=7; %LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    end

end

if strcmp(partid,'RTIS2002')  && strcmp(hand,'Right') % Participant and Arm
    if j==8


    elseif j==13


    elseif j==17 % Trial containing artifact

        %         upid=2050; dnid=5000; iemg=5;% LEO
        %         [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        %         maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==25
        upid=1; dnid=2800; iemg=11;% LD
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==26
        upid=2800; dnid=5000; iemg=12;% PM
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==27
        upid=2300; dnid=5000; iemg=12;% PM
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==28
        upid=1900; dnid=2600; iemg=2;% RES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    
        upid=1; dnid=4500; iemg=7;% LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        upid=2200; dnid=5000; iemg=12;% PM
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==29
        upid=1600; dnid=3400; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        upid=2500; dnid=5000; iemg=12;% PM
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==30
        upid=1500; dnid=3500; iemg=2;% RES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==33

    elseif j==34

    elseif j==35
        upid=1; dnid=2550; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==37
        upid=1200; dnid=2600; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
        
        upid=1700; dnid=2300; iemg=2;% RES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==38
        upid=1; dnid=3500; iemg=7;% LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif  j==39
        upid=1500; dnid=5000; iemg=2;% RES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    end

end

if strcmp(partid,'RTIS2003')  && strcmp(hand,'Left') % Participant and Arm
    if j==8



    elseif j==17 % Trial containing artifact

        %         upid=2050; dnid=5000; iemg=5;% LEO
        %         [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        %         maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;


    end
end

if strcmp(partid,'RTIS2006')  && strcmp(hand,'Right') % Participant and Arm
    if j==10
        upid=1; dnid=3500; iemg=6;% REO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
       
        upid=1; dnid=3500; iemg=7;% REO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;


    elseif j==17 % Trial containing artifact

        upid=1; dnid=1800; iemg=6;% REO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        upid=2400; dnid=5000; iemg=7;%LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
 
    elseif j==21 % Trial containing artifact

        upid=1800; dnid=3200; iemg=7;% LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==22 % Trial containing artifact
        upid=2000; dnid=5000; iemg=6;% REO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
  
        upid=1800; dnid=3200; iemg=7;% LIO
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    end
end

if strcmp(partid,'RTIS2006')  && strcmp(hand,'Left') % Participant and Arm
    if j==38
        upid=1500; dnid=4000; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

    elseif j==17 % Trial containing artifact

 
    elseif j==21 % Trial containing artifact

    elseif j==22 % Trial containing artifact
        upid=1; dnid=4500; iemg=2;% RES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

        upid=1; dnid=4500; iemg=3;% LRA
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    end
end
%

if strcmp(partid,'RTIS2007')  && strcmp(hand,'Right') % Participant and Arm
    if j==22
        upid=1; dnid=2400; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j ==24
        upid=1; dnid=2400; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==38 % Trial containing artifact
        upid=1700; dnid=2100; iemg=1;% LES
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;

 
    end
end

if strcmp(partid,'RTIS2007')  && strcmp(hand,'Left') % Participant and Arm
    if j==17
        upid=1600; dnid=3600; iemg=3;% LRA
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j ==25
        upid=2800; dnid=4000; iemg=4;% RRA
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    elseif j==20 % Trial containing artifact
        upid=1000; dnid=5000; iemg=5;% LEo
        [maxTEMG(j,iemg),maxtidx(j,iemg)]=max(meanEMG(upid:dnid,iemg));
        maxtidx(j,iemg)=maxtidx(j,iemg)+upid-1;
    end
end
    %% Plotting Individual Trials
    % if 0 % change to 1 to plot individual trials

    if 0
%         pause
        figure(2)
        clf
        t=(0:length(emg) - 1)/sampRate;

        rax = axes('position',[0.1,0.05,0.75,0.9]);
        set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');

        title(['Maximum EMGs -' basename num2str(j)],'FontSize',24)
        memg=max(emg);
        yspacing=cumsum([0 emg(2:nEMG)+0.1]);
        %             set(rax,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(ylabels),...
        %                 'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
        set(rax,'YTick',fliplr(-yspacing),'YTickLabel',flipud(strcat(emgchan')),...
            'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
        lax=axes('position',[0.1,0.05,0.75,0.9]);
        plot(t,emg-yspacing(ones(length(t),1),:),t(maxtidx(j,:)),maxTEMG(j,:)-yspacing,'k*'),hold on;
        %             line([t([upid,upid]) t([dnid,dnid])],repmat([-yspacing(end) memg(1)]',1,2),'Color','b')
        co=get(lax,'ColorOrder');
        set(lax,'ColorOrder',co([2:end 1],:),'YLim',[-yspacing(end) memg(1)])
        plot(t,meanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
        ylabel 'V'
         pause
    end
end
%% Finding the Max of all trials and which trial this occurs

Tlength(j)=size(data,1);

[maxEMG,maxidx]=max(maxTEMG);% Max of all trials and max trial max occurs
maxTlength=max(Tlength);


%% Grabbing the trials where the max occurs per muscle
if plotflag
    newemg=zeros(length(data),nEMG);
    t=(0:maxTlength - 1)/sampRate;
    for k=1:nEMG
        load([flpath basename num2str(maxidx(k))]);
        %         load([flpath trials(maxidx(k)).name]);
        newemg(:,k)=data(:,k);  % Each column is muscle and rows are whole trial over time where max occurs
    end
end
%% Plotting the trial where the max occurs per Muscle
figure(1), clf
newemg=abs(detrend(newemg));
newemg = newemg-repmat(mean(newemg(1:250,:)),length(newemg),1); %removes baseline
newmeanEMG=movmean(newemg,ds);
memg=max(newemg);
yspacing=cumsum([0 memg(2:nEMG)+.1]);
rax = axes('position',[0.1,0.05,0.75,0.9]);
set(rax,'YAxisLocation','right','color','none','xgrid','off','ygrid','off','box','off');
set(rax,'TickLabelInterpreter','none')
set(rax,'YTick',fliplr(-yspacing),'YTickLabel',fliplr(strcat(emgchan,'-maxes',cellstr(string(maxidx)))),...
    'YLim',[-yspacing(end) memg(1)],'XTick',[],'XTickLabel',[])
lax=axes('position',[0.1,0.05,0.75,0.9]);
plot(t,newemg-yspacing(ones(length(t),1),:),t(diag(maxtidx(maxidx,1:nEMG))),maxEMG-yspacing,'k*'),hold on;
co=get(lax,'ColorOrder');
set(lax,'ColorOrder',co(end-1:-1:1,:),'YLim',[-yspacing(end) memg(1)])
plot(t,newmeanEMG-yspacing(ones(length(t),1),:),'LineWidth',2)
ylabel 'V'
title(['Maximum EMGs across all trials - ' flpath(1:end)],'Interpreter','none')
print('-f1','-djpeg',[flpath '\MaxEMGs']) % Saving Figure 


%% Save maximum EMG file 
save([flpath '/maxEMG'],'maxEMG','maxidx')

end


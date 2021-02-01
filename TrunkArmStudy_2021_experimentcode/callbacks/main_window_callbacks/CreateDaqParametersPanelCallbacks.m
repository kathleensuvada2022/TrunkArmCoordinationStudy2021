%% function declaring the callback functions for each component
function mainWindow = CreateDaqParametersPanelCallbacks( mainWindow, emgChannels, experiment, trialParameters, nidaq, ttl, quanser  )

daqParametersPanel = mainWindow.daqParametersPanel;

set(daqParametersPanel.daqSwitchCheckBox,'Callback',{@daqSwitchCheckBox_Callback,mainWindow,nidaq,ttl,quanser});

set(daqParametersPanel.daqChannelsEditBox,'Callback',{@daqChannelsEditBox_Callback,mainWindow});
set(daqParametersPanel.samplingRateEditBox,'Callback',{@samplingRateEditBox_Callback,mainWindow});
%set(daqParametersPanel.samplingTimeEditBox,'Callback',{@samplingTimeEditBox_Callback,mainWindow});
set(daqParametersPanel.maxPreTrialTimeEditBox,'Callback',{@maxPreTrialTimeEditBox_Callback,mainWindow});

%set(daqParametersPanel.emgMaxesCheckBox,'Callback',{@emgMaxesCheckBox_Callback,mainWindow,experiment, emgChannels});

set(daqParametersPanel.filenameEditBox,'Callback',{@filenameEditBox_Callback,mainWindow});

set(daqParametersPanel.initializeDaqPushButton,'Callback',{@initializeDaqPushButton_Callback,mainWindow,trialParameters,emgChannels,nidaq,ttl,quanser});
set(daqParametersPanel.recordEmgMaxesPushButton,'Callback',{@recordEmgMaxesPushButton_Callback,mainWindow,emgChannels,experiment,daqParametersPanel, trialParameters,nidaq,ttl,quanser});

end


%% callbacks
function daqSwitchCheckBox_Callback(hObject, eventdata, mainWindow, nidaq, ttl, quanser)
% turn on all components in the daq parameters panel
% when checked, require daq to be initialized to start a trial

isDaqSwitchChecked = get(hObject,'Value');

daqParametersPanel = mainWindow.daqParametersPanel;
isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');

if isDaqSwitchChecked == 1
    % don't allow trial to start if daq isn't initialized
    if ( isNidaqChecked && nidaq.isInitialized == 0)  ||...
        ( isTtlChecked && ttl.isInitialized == 0 ) ||...
		( isQuanserChecked && quanser.isInitialized == 0 )
        
        set( mainWindow.trialConditionsPanel.startTrialPushButton, 'Enable', 'off' );
        set( mainWindow.trialConditionsPanel.startSetPushButton, 'Enable', 'off' );
        
        % allow trial to start if daq is initialized
    else
        set( mainWindow.trialConditionsPanel.startTrialPushButton, 'Enable', 'on' );
        set( mainWindow.trialConditionsPanel.startSetPushButton, 'Enable', 'on' );
        
    end
    
    % enable daq buttons
    set( mainWindow.daqParametersPanel.initializeDaqPushButton, 'Enable', 'on' );
    set( mainWindow.daqParametersPanel.recordEmgMaxesPushButton, 'Enable', 'on' );
    set( mainWindow.daqParametersPanel.nidaqCheckbox, 'Enable', 'on' );
    set( mainWindow.daqParametersPanel.ttlCheckbox, 'Enable', 'on' );
	set( mainWindow.daqParametersPanel.quanserCheckbox, 'Enable', 'on' );
    
else
    % if daq is not being used, allow trial to start
    set( mainWindow.trialConditionsPanel.startTrialPushButton, 'Enable', 'on' );
    set( mainWindow.trialConditionsPanel.startSetPushButton, 'Enable', 'on' );
    
    % disable daq buttons
    set( mainWindow.daqParametersPanel.initializeDaqPushButton, 'Enable', 'off' );
    set( mainWindow.daqParametersPanel.recordEmgMaxesPushButton, 'Enable', 'off' );
    set( mainWindow.daqParametersPanel.nidaqCheckbox, 'Enable', 'off' );
    set( mainWindow.daqParametersPanel.ttlCheckbox, 'Enable', 'off' );
	set( mainWindow.daqParametersPanel.quanserCheckbox, 'Enable', 'off' );
    
end

end

function daqChannelsEditBox_Callback(hObject, eventdata, mainWindow)

end

function samplingRateEditBox_Callback(hObject, eventdata, mainWindow)
end

function maxPreTrialTimeEditBox_Callback(hObject, eventdata, mainWindow)
end

%{
function emgMaxesCheckBox_Callback(hObject, eventdata, mainWindow, experiment, emgChannels )

% write emg channel labels to excel file
if get(hObject,'Value')
    %currentTrial = str2double(get( mainWindow.statusPanel.secondColumn(5), 'String' ));
    experiment.emgMaxesExcelHandle = ddeinit( 'excel', 'Sheet1' );
    while experiment.emgMaxesExcelHandle==0, 
        uiwait( warndlg( 'Open the MS Excel Program and then click OK', 'Copy EMG maxes to Excel', 'modal' ) );
        experiment.emgMaxesExcelHandle = ddeinit( 'excel', 'Sheet1' );   
    end
    
    rc = ddepoke( experiment.emgMaxesExcelHandle, 'r1c1:r1c1','EMG Ch' );
    totalDaqChannels = str2double( get( mainWindow.daqParametersPanel.daqChannelsEditBox, 'String' ) );
    for i=1:totalDaqChannels
        emgChannelName = char( get( emgChannels.labels(i), 'String' ) );
        location = ['r' num2str(i+1) 'c1:r' num2str(i+1) 'c1'];
        rc = ddepoke( experiment.emgMaxesExcelHandle, location, emgChannelName );
    end
else
    ddeterm(experiment.emgMaxesExcelHandle);
end

end
%}

function filenameEditBox_Callback(hObject, eventdata, mainWindow)
end

function initializeDaqPushButton_Callback(hObject, eventdata, mainWindow, trialParameters, emgChannels, nidaq, ttl, quanser)

daqParametersPanel = mainWindow.daqParametersPanel;

samplingRate = str2double( get( daqParametersPanel.samplingRateEditBox, 'String' ) );
maxPreTrialTime = str2double( get( daqParametersPanel.maxPreTrialTimeEditBox, 'String' ) );
maxTrialDuration = str2double( get( trialParameters.maxTrialDurationEditBox, 'String' ) );
samplingTime = maxPreTrialTime + maxTrialDuration; %<- check this, might be the problem!
totalEmgChannels = str2double( get( daqParametersPanel.daqChannelsEditBox, 'String' ) );

% try
%     if nidaq.isInitialized == 0
%         nidaq.Initialize( daqParametersPanel, samplingRate, samplingTime );
%         nidaq.AddChannels( totalEmgChannels, emgChannels );
%         nidaq.isInitialized = 1;
%         disp('nidaq initialized');
%     end
%     if ttl.isInitialized == 0
%         ttl.Initialize( daqParametersPanel, samplingRate, samplingTime );
%         ttl.AddChannels( totalEmgChannels, emgChannels );
%         ttl.isInitialized = 1;
%         disp('TTL ready');
% 
%         % initialize all TTL values to 0
%         ttlData = [ 0 0 0 0 ];
%         ttl.Toggle(ttlData);
%     end
%     if quanser.isInitialized == 0
%         quanser.samples = samplingTime * samplingRate;
%     	quanser.channels = (0 : totalEmgChannels-1);
%     	quanser.frequency = samplingRate;
%     	quanser.Initialize;
%     	quanser.isInitialized = 1;
%         disp('Quanser initialized');
%     end
% catch
%     disp('Could not initialize DAQs. Check connection and device ID');
%     return;
% end

isDaqSwitchChecked = get(hObject,'Value');

daqParametersPanel = mainWindow.daqParametersPanel;
isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
isTtlChecked = get(daqParametersPanel.ttlCheckbox,'Value');
isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');

if isDaqSwitchChecked ==1
    
    if isNidaqChecked == 1 
        try 
            %if nidaq.isInitialized == 0
                nidaq.Initialize( daqParametersPanel, samplingRate, samplingTime );
                nidaq.AddChannels( totalEmgChannels, emgChannels );
                nidaq.isInitialized = 1;
                disp('nidaq initialized');
            %end
        catch
            disp('Could not initialize nidaq. Check connection and device ID');
            return;
        end
    end
    if isTtlChecked ==1
        try
            if ttl.isInitialized == 0
                ttl.Initialize( daqParametersPanel, samplingRate, samplingTime );
                ttl.AddChannels( totalEmgChannels, emgChannels );
                ttl.isInitialized = 1;
                disp('TTL ready');

                % initialize all TTL values to 0
                ttlData = [ 0 0 0 0 ];
                ttl.Toggle(ttlData);
            end
        catch
            disp('Could not initialize TTL. Check connection and device ID');
            return;
        end
    end
           
    if isQuanserChecked == 1 
        try
            if quanser.isInitialized == 0
            quanser.samples = samplingTime * samplingRate;
            quanser.channels = (0 : totalEmgChannels-1);
            quanser.frequency = samplingRate;
            quanser.Initialize;
            quanser.isInitialized = 1;
            disp('Quanser initialized');
            end
       catch
            disp('Could not initialize Quanser. Check connection and device ID');
            return;
        end
    end      
   
end

set( mainWindow.trialConditionsPanel.startTrialPushButton, 'Enable', 'on' );
set( mainWindow.trialConditionsPanel.startSetPushButton, 'Enable', 'on' );

%disp('DAQ initialized');

end



function recordEmgMaxesPushButton_Callback(hObject, eventdata, mainWindow,emgChannels, experiment, daqParametersPanel, trialParameters, nidaq, ttl, quanser)
if quanser.isInitialized == 0  &&  nidaq.isInitialized == 0
    disp('Please initialize DAQ first');
    return;
end

statusPanel = mainWindow.statusPanel;
daqParametersPanel = mainWindow.daqParametersPanel;

% set filename
trialNumber = get(statusPanel.secondColumn(5),'String');
if iscell(trialNumber)
    trialNumber = trialNumber{1};
end

filename = [ 'emg_maxes_' trialNumber ];

%folder = get( statusPanel.secondColumn(11), 'String');
%save( [folder '\' filename '.daq']);

%%% begin recording EMG data and wait for the specified sampling time
%isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
%if isNidaqChecked == 0
%    error('Please check NI-DAQ to record data');
%    return;
%end

%set(nidaq.analogInputObject, 'LogFileName', [ filename '.daq' ] );
%nidaq.Start;

%% begin recording EMG data and wait for the specified sampling time
isNidaqChecked = get(daqParametersPanel.nidaqCheckbox,'Value');
isQuanserChecked = get(daqParametersPanel.quanserCheckbox,'Value');
samplingRate = str2double( get( daqParametersPanel.samplingRateEditBox, 'String' ) );
samplingTime = str2double( get( trialParameters.maxTrialDurationEditBox, 'String' ) );
totalEmgChannels = str2double( get( daqParametersPanel.daqChannelsEditBox, 'String' ) );

if isNidaqChecked == 1
    % Reinitialize the nidaq in order to record maxes for a maxTrialDuration
    nidaq.Initialize(daqParametersPanel, samplingRate, samplingTime);
    nidaq.AddChannels( totalEmgChannels, emgChannels );
    % Disables start buttons until daq is re initalized to the longer
    % sampling time
    set( mainWindow.trialConditionsPanel.startTrialPushButton, 'Enable', 'off' );
    set( mainWindow.trialConditionsPanel.startSetPushButton, 'Enable', 'off' );
    
    % No longer saving all DAQ files but this saves a log file each time (6/6/14)
    folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
    if iscell(folder)
        folder = folder{1};
    end
    %set(nidaq.analogInputObject, 'LogFileName', [folder '\' filename '.daq' ] );
    set(nidaq.analogInputObject, 'LogFileName', [folder '\logfile_maxes.daq' ] );
	nidaq.Start;
elseif isQuanserChecked == 1
    quanser.Start;
else %(isNidaqChecked == 0 && isQuanserChecked == 0)
	error('Please check NI-DAQ or Quanser to record data');
    return;
end

%pauseTime = str2double(get( daqParametersPanel.samplingTimeEditBox, 'String' ));
%pause(pauseTime);
maxTrialDuration = str2double( get( trialParameters.maxTrialDurationEditBox, 'String' ) );
pause(maxTrialDuration);

%% plot emgs
if isQuanserChecked == 1
    quanser.Stop;
    [ data, samples_read ] = quanser.ReadData;
    data = data';
    t = (1:length(data(:,1))) / quanser.frequency;
    
    % save data
    % folder
    folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
    if iscell(folder)
        folder = folder{1};
    end

    save( [folder '\' filename ], 'data' );

else % nidaq
	nidaq.Stop;
    [data,t] = getdata(nidaq.analogInputObject,nidaq.analogInputObject.SamplesAcquired);
    
	%folder	
	%folder = get( statusPanel.secondColumn(11), 'String');
	
	%save
	%save( [folder '\' filename '.mat']);
    
    %added 6-6-14
    %folder	
    folder = get( mainWindow.statusPanel.secondColumn(11), 'String');
    if iscell(folder)
        folder = folder{1};
    end
    %save
    save( [folder '\' filename '.mat' ], 'data' );
end
samplingRate = str2double( get( daqParametersPanel.samplingRateEditBox, 'String' ) );
meandata = experiment.meanfilt( abs(data), 0.25*samplingRate );

for i=1:size(data,2)

    % clear selected axes
    cla(emgChannels.axis(i));

    % plot data on axes using line
    axes(emgChannels.axis(i));
    line(t,data(:,i));
    drawnow
     
    % label axes with max of data and max of filtered data
    maxRawData = max(abs(data(:,i)));
    maxFilteredData = max(meandata(:,i));
    x = length(data(:,1))/samplingRate*0.4;
    y = maxRawData;
    text( x,y, num2str(maxRawData,'%6.4f') );
    x = length(data(:,1))/samplingRate*0.8;
    text( x,y, num2str(maxFilteredData,'%6.4f') );
end


%% trials completed is incremented and replaced
newTrialNumber = experiment.IncrementTrialNumber( str2double(trialNumber), statusPanel.secondColumn(5) );

%% Determine whether to conduct more trials
totalTrialsNumber = str2double( get(statusPanel.totalTrialsEditBox,'String') );
if newTrialNumber >= totalTrialsNumber
    experiment.RunMoreTrials( trialParameters.figureHandle, statusPanel.secondColumn(5) );
end

disp('EMG maxes trial complete');

end


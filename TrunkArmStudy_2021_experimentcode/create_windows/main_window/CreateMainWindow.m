function mainWindow = CreateMainWindow( mainWindow, deviceId )

%% Create main window figure
mainWindow.figureHandle = CreateWindowFigure( mainWindow.name,...
    mainWindow.figureWidth, mainWindow.figureHeight );

%add menu bar
mainWindow.experimentMenubar = uimenu('Label','Experiment');
mainWindow.viewMenubar = uimenu('Label','View');

% Create choices
uimenu(mainWindow.experimentMenubar,'Label','Initialize Robot');
uimenu(mainWindow.experimentMenubar,'Label','Participant Parameters');
uimenu(mainWindow.experimentMenubar,'Label','Set Targets');
uimenu(mainWindow.experimentMenubar,'Label','Trial Parameters');

uimenu(mainWindow.viewMenubar,'Label','Top Down');
uimenu(mainWindow.viewMenubar,'Label','Side');
uimenu(mainWindow.viewMenubar,'Label','Standard');


%% Create panels in the main window
[ mainWindow.statusPanel, mainWindow.protocolPanel, mainWindow.daqParametersPanel, mainWindow.trialConditionsPanel ]...
    = CreatePanels( mainWindow.figureHandle );

%% Create components (text boxes, etc.) in the main window
% Create status panel
mainWindow.statusPanel = CreateStatusPanelComponents( mainWindow.statusPanel, deviceId );

% Create protocol panel
mainWindow.protocolPanel = CreateProtocolPanelComponents( mainWindow.protocolPanel );

% Create daq parameters panel
mainWindow.daqParametersPanel = CreateDaqParametersPanelComponents( mainWindow.daqParametersPanel );

% Create trial conditions panel
mainWindow.trialConditionsPanel = CreateTrialConditionsPanelComponents( mainWindow.trialConditionsPanel );

end

function [ statusPanel, protocolPanel, daqParametersPanel, trialConditionsPanel ] = CreatePanels( figureHandle )

%numberOfPanels = 3;
panelEdge = 0.001;    % normalized
statusPanel.panelEdge = panelEdge;
protocolPanel.panelEdge = panelEdge;
trialConditionsPanel.panelEdge = panelEdge;

%% create status panel
panelWidth = 0.3208;    
panelHeight = 0.999;
biggestPanelHeight = panelHeight;
statusPanel.panelPosition =...
    [ panelEdge, panelEdge, panelWidth, panelHeight ];    % [left bottom width height]

statusPanel.panelTitle = 'Status';

statusPanel.handle = CreatePanel( ...
    statusPanel.panelPosition,...
    figureHandle,...
    statusPanel.panelTitle );


%% create protocol panel
previousPanelWidth = panelWidth;
panelFromLeft = previousPanelWidth + panelEdge*2;
panelWidth = 0.365;
panelHeight = 0.4333;
panelFromBottom = ( biggestPanelHeight - panelHeight ) + panelEdge;
protocolPanel.panelPosition =...
    [ panelFromLeft, panelFromBottom, panelWidth, panelHeight];

panelTitle = 'Protocol';

protocolPanel.handle = CreatePanel(...
    protocolPanel.panelPosition,...
    figureHandle,...
    panelTitle );

%% create DAQ parameters panel
panelHeight = 0.54;
panelFromBottom = panelEdge;
daqParametersPanel.panelPosition =...
    [ panelFromLeft, panelFromBottom, panelWidth, panelHeight];

panelTitle = 'DAQ Parameters';

daqParametersPanel.handle = CreatePanel(...
    daqParametersPanel.panelPosition,...
    figureHandle,...
    panelTitle );


%% create trial conditions panel
previousPanelFromLeft = panelFromLeft;
previousPanelWidth = panelWidth;
panelFromLeft = previousPanelFromLeft + previousPanelWidth + panelEdge;
panelWidth = 0.31;
panelHeight = 0.999;
panelFromBottom = ( biggestPanelHeight - panelHeight ) + panelEdge;
trialConditionsPanel.panelPosition =...
    [ panelFromLeft, panelFromBottom, panelWidth, panelHeight ];

trialConditionsPanel.panelTitle = 'Trial Conditions';

trialConditionsPanel.handle = CreatePanel(...
    trialConditionsPanel.panelPosition,...
    figureHandle,...
    trialConditionsPanel.panelTitle );


end

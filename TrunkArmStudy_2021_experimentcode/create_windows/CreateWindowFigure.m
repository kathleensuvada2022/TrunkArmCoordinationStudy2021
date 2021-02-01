% Create Figure Window
function [ figureHandle ] = CreateWindowFigure( name, figureWidth, figureHeight )

%% create figure
figureHandle=figure;

%% set window position (function is below)
figureHandle = SetWindowPosition( figureHandle, figureWidth, figureHeight );

%% set properties for the figure
set( figureHandle, 'MenuBar', 'none' );         % hide default Matlab Menu Bar
%set( figureHandle, 'label', '/remove');
set( figureHandle, 'NumberTitle','off' );       % hide figureHandle number
set( figureHandle, 'Name', name );

if strcmp('Visual Feedback Additional',name) %Added for Kacey's additional feedback window
    set( figureHandle, 'Resize', 'on' );
else
    set( figureHandle, 'Resize', 'off' );     
end

defaultBackground = get(0,'defaultUicontrolBackgroundColor');
set( figureHandle, 'Color', defaultBackground);

end


function figureHandle = SetWindowPosition( figureHandle, figureWidth, figureHeight )

screenSize = get(0,'ScreenSize');
screenWidth = screenSize(3);
screenHeight = screenSize(4);

% Place window in the middle of the screen
figureFromLeft = ( screenWidth - figureWidth ) / 2;    
figureFromBottom = ( screenHeight - figureHeight ) / 2;

figurePosition = [ figureFromLeft, figureFromBottom, figureWidth, figureHeight ]; 

set( figureHandle, 'Position', figurePosition );

end


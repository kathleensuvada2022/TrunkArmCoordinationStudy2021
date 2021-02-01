function CloseMainWindow_Callback(hObject, eventData, mainWindow, window1,...
    window2, window3, window4, window5, timerObject, display, judp, haptic,...
    robot, experiment, nidaq, ttl, quanser )

% stop and delete the timer that updates the visual feedback
stop(timerObject);
delete(timerObject);

arm = get( mainWindow.statusPanel.secondColumn(6), 'String' );

% delete all windows on main window exit
delete(hObject);
delete(window1);
delete(window2);
delete(window3);
delete(window4);
delete(window5);
%delete(display.figureHandle);

% delete class objects
delete(display,arm,judp);
delete(judp);
delete(haptic);
delete(robot);
delete(experiment);
delete(nidaq);
delete(ttl);
delete(quanser);

end

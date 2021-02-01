% the robot is fixed when the 'f' key is pressed on the keyboard

function Keypress(object,event,robot,mainWindow)
if event.Character == 'f'
    robot.SwitchState('fixed');
    set(mainWindow.trialConditionsPanel.statePopUpMenu,'String',{'fixed','normal','off'});
end

end
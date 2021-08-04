function timerObject = SetTimerProperties( timerObject, display, robot, mainWindow,...
    experiment, timerFrequency, trialParameters, setTargets, emgChannels,...
    addDisplay, nidaq, ttl, quanser, judp )
%function timerObject = SetTimerProperties( timerObject, robot, timerFrequency)

%// A.M. TO-DO: to remove the TimerFcn error. Can check the input
%arguments for this function
% disp('got to line 8 in set timer properties');
set( timerObject, 'TimerFcn',{@TimerCallback,display, robot, mainWindow,...
    experiment, timerFrequency, trialParameters, setTargets, emgChannels,...
    addDisplay, nidaq, ttl, quanser, judp});
% disp('got to line 12 in set timer properties');
%set( timerObject, 'TimerFcn',{@TimerCallback, robot, timerFrequency});

%timerObject.StopFcn = @vf.CloseDisplay;
%A.M. testing to see which line of code is causing the TimerFcn error
set( timerObject, 'Name','timer for arm visualization' );
%  disp('got to line 18 in set timer properties');
set( timerObject, 'ExecutionMode','fixedrate' );
%  disp('got to line 20 in set timer properties');
set( timerObject, 'Period',1/timerFrequency );  %50 hz currently

end
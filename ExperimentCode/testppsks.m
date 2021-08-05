obj.BufferSize = 10000;
% obj.cfgFile = 'D:\Kacey\TrunkArmStudy\setup\PN7931R1-STA-NorthwesternDual.cfg';
% obj.cfgFile = 'D:\Kacey\TrunkArmStudy\setup\T4500-Northwestern.cfg';
% obj.cfgFile = 'D:\Nayo_Folder\Nayo_HandArmExperiment_Current\setup\T4500-Northwestern.cfg';
% 
% addpath 'C:\ProgramData\PPS\Chameleon 2018\1.13.8.49\';
% obj.cfgFile = 'setup\PN7931R1-STA-NorthwesternDual.cfg';
obj.cfgFile = 'C:\ProgramData\PPS\Chameleon 2018\1.13.8.49\setup\PN7931R1-STA-NorthwesternDual.cfg';

[out1,warnings]=loadlibrary( 'PPSDaqAPI','PPSDaq.h' );
calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile,0);
disp('PPS system Initialized');
obj.FrameSize = calllib('PPSDaqAPI','ppsGetRecordSize');
str = sprintf('Recording is %d elements', obj.FrameSize);
disp(str);

%%
obj.time = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
obj.data = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
obj.time_out = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
obj.data_out = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
IsCalibrated = calllib('PPSDaqAPI', 'ppsIsCalibrated');

unloadlibrary( 'PPSDaqAPI' );



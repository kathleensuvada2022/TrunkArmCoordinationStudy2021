function obj = testPPS(name)

obj.Name=name;
% obj.cfgFile_trunk = 'setup\PN7931R1-STA-NorthwesternDual.cfg'; 
% obj.cfgFile_trunk = 'setup\T4500-Northwestern.cfg'; 
obj.CreateStruct = struct('Interpreter','tex','WindowStyle','modal');
obj.cfgFile_trunk = 'D:\Kacey\TrunkArmStudy\setup\PN7931R1-STA-NorthwesternDual.cfg';
obj.BufferSize = 10000;
disp(obj)
% load TactArray library
disp('In PPS')
if ( libisloaded('PPSDaqAPI') )
    unloadlibrary('PPSDaqAPI');
end
[~,~]=loadlibrary( 'PPSDaqAPI','PPSDaq.h' );
calllib('PPSDaqAPI','ppsInitialize',obj.cfgFile_trunk,0);
%             disp('Line 56')
msgbox('\fontsize{12}PPS system Initialized','ACT3D-TACS',obj.CreateStruct)
%             disp('Line 58')
%
%             % disp('PPS system Initialized');
obj.FrameSize = calllib('PPSDaqAPI','ppsGetRecordSize');
%             disp('Line 62')
msgbox(['\fontsize{12}Recording is %d elements',num2str(obj.FrameSize)],'ACT3D-TACS',obj.CreateStruct)

%             str = sprintf('Recording is %d elements', obj.FrameSize);
%             disp(str);
obj.time = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
obj.data = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));
obj.time_out = libpointer('ulongPtr', zeros(obj.BufferSize, 1));
obj.data_out = libpointer('singlePtr', zeros(obj.FrameSize, obj.BufferSize));

% test if data is calibrated (CreateDaqParametersPanelCallback.m)
IsCalibrated = calllib('PPSDaqAPI', 'ppsIsCalibrated');
if IsCalibrated
    msgbox('\fontsize{12}Data is calibrated','ACT3D-TACS',obj.CreateStruct)
    %               disp('Data is calibrated')
else
    warndlg('\fontsize{12}Data is not calibrated','ACT3D-TACS',obj.CreateStruct);
    %disp('Data is not calibrated');
end

end
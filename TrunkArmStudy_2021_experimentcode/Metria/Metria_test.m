% Compile collectPoint c++ code
% mex -lws2_32 metriaComm_collectPoint.cpp
% mex -lws2_32 metriaComm_openSocket.cpp %Added this to the compiler as I had to change the IP address for some reason. Maybe I set up the Metria wrong somehow?

port=6111;

socket = metriaComm_openSocket(port);

% Original format (pre 11/24/2020)
%numMarkers = 3;
%[metdata1,metdata2] = metriaComm_collectPoint(socket,numMarkers);

% New format
markerIDs = [019 073 080 087 237];
cameraSerials = [24 25];

% For testing timing differences
% metdata = cell(1,10*10);
% for i=1:10*10
%     [metdata{i}] = metriaComm_collectPoint(socket,markerIDs,cameraSerials);
%     pause(.1);
%     if i~=1
%         timeDifferences(i) = (metdata{i}(12)+metdata{i}(13)*10^(-9))-(metdata{i-1}(12)+metdata{i-1}(13)*10^(-9));
%     end
% end
% (metdata{end}(12)+metdata{end}(13)*10^(-9))-(metdata{1}(12)+metdata{1}(13)*10^(-9))

[metdata1] = metriaComm_collectPoint2(socket,markerIDs,cameraSerials);

metriaComm_closeSocket(socket);
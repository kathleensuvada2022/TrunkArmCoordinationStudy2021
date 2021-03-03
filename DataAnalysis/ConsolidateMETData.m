% Function to consolidate Metria data that contains duplicate information
% for each marker when using two cameras
function newdata=ConsolidateMETData(data)
% Input: data - Metria data merged between the two cameras
% Output: newdata - consolidated data (returns NaN when marker is not
% visible)
% There is something weird with the time information returned by Metria, it
% doesn´t jive with the trial timing. Use the ACT3D time vector as it´s the
% same length and the Metria image frames were acquired in the same
% interrupts.

markerid=[80 19 87 73];

newdata=zeros(length(data),35);
newdata(:,1:3)=data(:,1:3);
time=zeros(length(data),2);
t0=data(1,[3 38]);
for i=1:length(data)
    for j=1:length(markerid)
        idx=find(data(i,:)==markerid(j),1);
        if isempty(idx)
            newdata(i,3+(8*j-7:8*j))=NaN;
        else
            newdata(i,[1:3 3+(8*j-7:8*j)]) = data(i,[35*fix(idx/35)+(1:3) idx+(0:7)]);
        end
    end
    [~,camidx]=min(data(i,[1 36]));
    if camidx==1, time(i,:)=data(i,[2 37])+data(i,[3 38])*1e-9;
    else time(i,:)=data(i,[37 2])+data(i,[38 3])*1e-9;
    end
end
time=time-time(1,:);
end


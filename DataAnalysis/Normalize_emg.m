if exist([flpath '/maxEMG.mat'])==2, load([flpath '/maxEMG']);disp(maxEMG)
else
    disp('Computing Maximum Muscle EMGs. Make sure you check them')
    [maxEMG]=GetMaxMusAct2(flpath,fname,setfname,0);
end

emg = daqdata;
emg=abs(detrend(emg))./maxEMG(ones(length(t),1),:); % Detrend and rectify EMG


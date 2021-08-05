% load test
data_out=mypps.data_out;
time_out=mypps.time_out;
for i=1:length(time_out)
    data1=reshape(data_out(i,1:256),16,16)';
    data2=reshape(data_out(i,257:512),16,16);
    contourf([data1 data2]) 
   pause(0.2)
end
 axes 'equal'
 

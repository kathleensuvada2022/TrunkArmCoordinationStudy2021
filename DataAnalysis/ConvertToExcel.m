%% Writing workspace variable to EXCEL Sheet
filename = 'testdata.xlsx';
%Loading in Data Matrix
A= zeros(5001,16);
A= num2cell(A);
% Creating Time Vector
Tlength=size(cleandata,1);
maxTlength=max(Tlength);
sampRate=1000;
t=(0:maxTlength - 1)/sampRate;
%Making time vector first column of matrix 
A(2:5001,1)=num2cell(t);
%Creating Row with Names of Muscles 
names=["LES","RES","LRA","RRA","LEO","REO","LIO","RIO","UT","MT","LD","PM","BIC","TRI","IDEL"];
names = cellstr(names);
A(1,2:16)=names;

%Adding the data to matrix
A(2:5001,2:16) = num2cell(cleandata);

%Writing Cell array to Excel file
writecell(A,'variables.xls')
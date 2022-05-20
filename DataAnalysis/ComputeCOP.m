% May 2022 K. Suvada

% ComputeCoP: Function used to compute Center of Pressure given data matrix
% and plot trajectory and heat mat.

% Input Arguments

% -  DataMatrix: Matrix with values to find the COP of
% -  XposMatrix: Position of elements in x direction
% -  YposMatrix: Position of elements in y direction
% -  numframes:  Number of frames 
% -  numelements: Total number of elements in the matrix. 

% Output Arguments: 
% - CoP: Center of pressure in x and y position. 

function CoP = ComputeCoP(DataMatrix,XposMatrix,YPosMatrix,numframes,numelements)

% Total Pressure of Data Matrix
TotalPressure= sum(DataMatrix ,2); 

% Computing COP -For Pressure Mat Data and Layout of Mat
CoP=[sum(DataMatrix(:,1:numelements).*XposMatrix,2)./TotalPressure sum(DataMatrix(:,1:numelements).*YPosMatrix,2)./TotalPressure];
CoP(:,2) = 16- CoP(:,2); 


end


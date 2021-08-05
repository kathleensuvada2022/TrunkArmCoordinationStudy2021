%% COP SCRIPT KCS 11.12.20
% 
% QUESTIONS For Ana Maria 11/16
% 1) Loading in the files so can easily run trial by trial? 
% 2) Y Position Vector
% 3) Show plot 

% fileList = dir('*.mat');
% 
% % fileList.name; 
% 
% for i = 1:10
% data(i) = fileList(i)
% end 

trial1 = load('Trial1LeaningForward');
trial2 = load('Trial2KneelingFrontofMat');
trial3 = load('Trial3sittingonfronteddgeofmat');
trial4 = load('Trial5Rockingforwardandback');
trial5 = load('Trial5Rockingforwardandback');
trial6 = load('Trial6Rockingallover');
trial7 = load('Trial7');
trial8 = load('Trial8');
trial9 = load('Trial9');
trial10 = load('Trial10');


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Trial Number


Data1 =trial6.ans.data_out; %data matrix of all elements and all frames (ie Both mats)

%% Mat 1

TotalPressureMat1 = sum(ppsdata,2); %takes sum of Pressures Mat1 for each frame
% 
% frame 1 [e1 e2 e3 e4 e5 e6 e7 e8 e9] [0.5 1.5 2.5 0.5 1.5 2.5 0.5 1.5 2.5
% frame 2  e1 e2 e3 e4 e5 e6 e7 e8 e9   0.5 1.5 2.5 0.5 1.5 2.5 0.5 1.5 2.5 
% frame 3  e1 e2 e3 e4 e5 e6 e7 e8 e9]  0.5 1.5 2.5 0.5 1.5 2.5 0.5 1.5 2.5]

% frame 1 [e1 e2 e3 e4 e5 e6 e7 e8 e9] [0.5 0.5 0.5 1.5 1.5 1.5 2.5 2.5 2.5
% frame 2  e1 e2 e3 e4 e5 e6 e7 e8 e9   0.5 0.5 0.5 1.5 1.5 1.5 2.5 2.5 2.5 
% frame 3  e1 e2 e3 e4 e5 e6 e7 e8 e9]  0.5 0.5 0.5 1.5 1.5 1.5 2.5 2.5 2.5]

% X COP
% XcopMat1 = zeros(size(Data1,1),1);

xcop=sum(ppsdata.*repmat((0:15)+0.5,nframes,16),2);
rm=repmat((0:15)'+0.5,1,16); rm=rm'; rm=rm(:);
ycop=sum(ppsdata.*repmat(rm',nframes,1),1)./TotalPressure;

% make into a loop for all frames 
for i = 1:size(Data1,1) % getting the number of rows in Data or frames 

elem_Pres_1 = Data1(i,1:256)'; % pressure values for Mat1

xpos = (.5:15.5)'; 
XposVec = repmat(xpos,16,1); % repeats positions across all rows for mat 

XP_1 = (elem_Pres_1.*XposVec); %X*P for mat 1

XcopMat1(i) = sum(XP_1)/TotalPressureMat1(i);
end 

% Y COP
ypos1 = repmat(.5,16,1);
ypos2 = repmat(1.5,16,1);
ypos3 = repmat(2.5,16,1);
ypos4 = repmat(3.5,16,1);
ypos5 = repmat(4.5,16,1);
ypos6 = repmat(5.5,16,1);
ypos7 = repmat(6.5,16,1);
ypos8 = repmat(7.5,16,1);
ypos9 = repmat(8.5,16,1);
ypos10 = repmat(9.5,16,1);
ypos11 = repmat(10.5,16,1);
ypos12 = repmat(11.5,16,1);
ypos13 = repmat(12.5,16,1);
ypos14 = repmat(13.5,16,1);
ypos15 = repmat(14.5,16,1);
ypos16 = repmat(15.5,16,1);

YposVec = [ypos1; ypos2; ypos3; ypos4; ypos5; ypos6; ypos7; ypos8; ypos9; ypos10; ypos11; ypos12; ypos13; ypos14; ypos15; ypos16;];
YposVec = YposVec*.0254; % y positions of elements in meters 

YcopMat1 = zeros(size(Data1,1),1);

% make into a loop for all frames 
for i = 1:size(Data1,1) % getting the number of frames 

elem_Pres_1 = Data1(i,1:256)'; % pressure values for Mat1 

YP_1 = (elem_Pres_1.*YposVec); %Y*P for mat 2 

YcopMat1(i) = sum(YP_1)/TotalPressureMat1(i)*1000; % Position of COP in MM
end 

%Printing out X and Y COP for mat 1 
XcopMat1,YcopMat1
%% Mat 2

TotalPressureMat2 = sum(Data1(:,257:end),2); %takes sum of Pressures Mat2 for each frame

%Xcop
XcopMat2 = zeros(size(Data1,1),1);

% make into a loop for all frames 
for i = 1:size(Data1,1) % getting the number of rows in Data or frames 

elem_Pres_2 = Data1(i,257:end)'; % pressure values for Mat2 

xpos = (.5:15.5)'; 
xpos = xpos*.0254; % x positions of elements in meters 
XposVec = repmat(xpos,16,1); % repeats positions across all rows for mat 

XP_2 = (elem_Pres_2.*XposVec); %X*P for mat 2 

XcopMat2(i) = sum(XP_2)/TotalPressureMat2(i)*1000; % Position of COP in MM
end 

%YCOP
ypos1 = repmat(.5,16,1);
ypos2 = repmat(1.5,16,1);
ypos3 = repmat(2.5,16,1);
ypos4 = repmat(3.5,16,1);
ypos5 = repmat(4.5,16,1);
ypos6 = repmat(5.5,16,1);
ypos7 = repmat(6.5,16,1);
ypos8 = repmat(7.5,16,1);
ypos9 = repmat(8.5,16,1);
ypos10 = repmat(9.5,16,1);
ypos11 = repmat(10.5,16,1);
ypos12 = repmat(11.5,16,1);
ypos13 = repmat(12.5,16,1);
ypos14 = repmat(13.5,16,1);
ypos15 = repmat(14.5,16,1);
ypos16 = repmat(15.5,16,1);

YposVec = [ypos1; ypos2; ypos3; ypos4; ypos5; ypos6; ypos7; ypos8; ypos9; ypos10; ypos11; ypos12; ypos13; ypos14; ypos15; ypos16;];
YposVec = YposVec*.0254; % y positions of elements in meters 

YcopMat2 = zeros(size(Data1,1),1);

% make into a loop for all frames 
for i = 1:size(Data1,1) % getting the number of frames 

elem_Pres_2 = Data1(i,257:end)'; % pressure values for Mat2  

YP_2 = (elem_Pres_2.*YposVec); %Y*P for mat 2 

YcopMat2(i) = sum(YP_2)/TotalPressureMat2(i)*1000; % Position of COP in MM
end 

%Printing out Xcop and Ycop mat 2

XcopMat2 
YcopMat2

% 
% total = zeros(256,1);
% for i= 1:16 
%     ypos = repmat(i+.5,16,1);
%     total(i:i+15) = ypos;
% end
% 
% YposVec = zeros(256,1);
% for j = 1:256
%     for i =0:15
%     YposVec(j:j+15,1) = repmat(i+.5,16,1);
%     end
% end 
% 
% testArray= zeros(256,1);
% tempArray= zeros(16,1);
% for i =.5:15.5
%     tempArray = i;
%     testArray = [testArray; TempArray];
% end 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% 
% 
%  Plot for COP Mat 1

subplot(2,1,1)
axis([0 400 0 400])
plot(XcopMat1,YcopMat1,'o')
hold on
plot(XcopMat1(1),YcopMat1(1),'+') % plotting start % ADD START AND END TIMES green and red circle
title('Mat 1 COP-Mat View','FontSize', 16)
xlabel('X COP position (mm)','FontSize', 12)
ylabel('Y COP position (mm)','FontSize', 12)
subplot(2,1,2)
plot(XcopMat1,YcopMat1,'o')
plot(XcopMat1(1),YcopMat1(1),'g')
title('Mat 1 COP-Scaled','FontSize', 16)
xlabel('X COP position (mm)','FontSize', 12)
ylabel('Y COP position (mm)','FontSize', 12)


% Plot COP for Mat 2 
subplot(2,1,1)
axis([0 400 0 400])
hold on
plot(XcopMat2,YcopMat2,'o')
title('Mat 2 COP-Mat View','FontSize', 16)
xlabel('X COP position (mm)','FontSize', 12)
ylabel('Y COP position (mm)','FontSize', 12)
subplot(2,1,2)
plot(XcopMat2,YcopMat2,'o')
title('Mat 2 COP-Scaled','FontSize', 16)
xlabel('X COP position (mm)','FontSize', 12)
ylabel('Y COP position (mm)','FontSize', 12)



% 
% % NEED TO ADD CODE TO TRANSPOSE DATA SO CORRECT THEN CAN PLOT
% 
% 
% Datastruct.trial1 =Trials(1).ans.data_out; 
% 
% for i = 1:10
%   
% DataMat1(i) = Trials(i).ans.data_out;  
% 
% %mat 1
% newdatamat1 = ans.data_out(:,1:256);
% avgbaselinemat1 = mean(newdatamat1);
% avgbaselinemat1 = reshape(avgbaselinemat1,16,16);
% avgbaselinemat1 = reshape(avgbaselinemat1',16,16);
% 
% 
% %mat2 
% 
% 
% end
% 
% 
% 
% 
% 
% for i = 1:10
%     figure 
% surf(Trials(1).ans.data_out)
% pause 
% colorbar
% end
% 

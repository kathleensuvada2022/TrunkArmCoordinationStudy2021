% Testing with Interpolation for missing Data
%% Jan 2022 K. Suvada

x = [-4*pi:0.1:0, 0.1:0.2:4*pi];
A = sin(x);

A(A < 0.75 & A > 0.5) = NaN;


% Fill the missing data using linear interpolation return filled vector F
% and the logical vector TF. The value 1 (true) in entries of TF 
% corresponds to the values of F that were filled.

%[F,TF] = fillmissing(A,'linear','SamplePoints',x);
[F,TF] = fillmissing(A,'spline','SamplePoints',x);


% Plotting original data and filled in data
plot(x,A,'.', x(TF),F(TF),'o')
xlabel('x');
ylabel('sin(x)')
legend('Original Data','Filled Missing Data')

%% Testing with Dist/Vel 

% TF is logical where true when there is a NAN
[F,TF] = fillmissing(dist,'spline','SamplePoints',t);

% Plotting original data and filled in data
plot(t,dist,'LineWidth',.75)
hold on
plot(t(TF),F(TF),'o')
xlabel('Time','FontSize',14);
ylabel('Distance','FontSize',14);
legend('Original Data','Filled Missing Data')
title('Filling Missing Position Data','FontSize',16)
xlim([0 5])

%%
%plotting new Distance data that is filled 
figure()
plot(t,F,'LineWidth',.75)
xlabel('Time','FontSize',14);
ylabel('Distance','FontSize',14);
title('New Distance Filled','FontSize',16)
xlim([0 5])

%% Redefining vel using filled Distance

vel2 = ddt(smo(F,3),1/89);

%% Comparing Ab ove with Computing Vel then filling in

[Vel_F,TF] = fillmissing(vel,'spline','SamplePoints',t);

%% Plotting Vel (from filled dist) and then filled vel

figure()
plot(t,vel2,'LineWidth',.75)
hold on 
plot(t,Vel_F,'LineWidth',.75)
xlabel('Time','FontSize',14);
ylabel('Vel','FontSize',14);
legend('Filled Dist','Filled Vel','FontSize',14)
title('New Velocity Filled','FontSize',16)
xlim([0 5])
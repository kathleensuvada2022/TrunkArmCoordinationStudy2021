% Tiled Layout Script

    
    tiledlayout(1,6)

% First plot
ax1 = nexttile;


% Second plot
ax2 = nexttile;


% Third plot
ax3 = nexttile;

   
% 4th plot
ax4 = nexttile;

% 5th Plot
ax5 = nexttile;

% 6th Plot
ax6 = nexttile;

% Command that syncs up all the axes 

linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'xy')

%RTIS1003
axis([ax1 ax2 ax3 ax4 ax5 ax6],[-300 300 -300 1000])
axis equal

%RTIS1004
axis([ax1 ax2],[-600 300 -500 1400])
axis equal

 %RTIS1005
 axis([ax1 ax2],[-50 350 -100 1000])
axis equal

 %RTIS1006
 axis([ax1 ax2],[-50 200 -100 700])
axis equal

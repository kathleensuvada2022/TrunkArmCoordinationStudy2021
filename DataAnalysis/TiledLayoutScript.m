% Tiled Layout Script

    
    tiledlayout(1,6)

% First plot
ax1 = nexttile;
x1 = linspace(0,6);
y1 = sin(x1);
plot(x1,y1)

% Second plot
ax2 = nexttile;
x2 = linspace(0,10);
y2 = 2*sin(2*x2);
plot(x2,y2)

% Third plot
ax3 = nexttile;
x3 = linspace(0,12,200);
y3 = 4*sin(6*x3);
plot(x3,y3)
   
% 4th plot
ax4 = nexttile;

% 5th Plot
ax5 = nexttile;

% 6th Plot
ax6 = nexttile;

 linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'xy')

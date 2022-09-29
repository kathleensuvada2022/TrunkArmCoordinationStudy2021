% Tiled Layout Script
% September 2022

% Script to Create Plots that are synced
% Can adjust axes manually and one axis changes them all. 
    figure(4)
tiledlayout(1,2)

% First plot
ax1 = nexttile;


%% Second plot
ax2 = nexttile;


%% Third plot
ax3 = nexttile;

   
%% 4th plot
ax4 = nexttile;

%% 5th Plot
ax5 = nexttile;

%% 6th Plot
ax6 = nexttile;

%% Command that syncs up all the axes 

linkaxes([ax1 ax2],'xy')

%%
%RTIS1003
axis([ax1 ax2 ax3 ax4 ax5 ax6],[-300 300 -300 1000])
axis equal

%% RTIS1004
axis([ax1 ax2],[-400 300 -200 1000])
axis equal

 %% RTIS1005
 axis([ax1 ax2],[-50 350 -100 1000])
axis equal

 %% RTIS1006
 axis([ax1 ax2],[-50 300 -100 700])
axis equal


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stroke Paretic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RTIS2002 - Left
 axis([ax1 ax2],[-400 200 -100 800])
axis equal
%% RTIS2003 - Left
  axis([ax1 ax2],[-300 300 -100 900])
axis equal
%% RTIS2006 - Right
  axis([ax1 ax2],[-200 300 -100 800])
axis equal
%% RTIS2007 - Right
   axis([ax1 ax2],[-200 200 -200 700])
axis equal
%% RTIS2008 - Right
    axis([ax1 ax2],[-200 600 -300 1000])
axis equal
%% RTIS2009 - Left
    axis([ax1 ax2],[-200 200 -300 1000])
    axis equal
%% RTIS2010- Right
    axis([ax1 ax2],[-100 375 -200 925])
    axis equal
%% RTIS2011- Left
    axis([ax1 ax2],[-300 200 -200 625])
    axis equal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Stroke Non- Paretic %%%%%%%%%%%%%%%%%%%%%
%% RTIS2001 - Left
  axis([ax1 ax2],[-500 200 -100 800])
axis equal
%% RTIS2002 - Right
  axis([ax1 ax2],[-100 300 -100 800])
axis equal
%% RTIS2003 - Right
  axis([ax1 ax2],[-100 300 -100 800])
axis equal
%% RTIS2006 - Left
  axis([ax1 ax2],[-100 300 -100 800])
axis equal
%% RTIS2007- Left
  axis([ax1 ax2],[-400 100 -100 800])
axis equal
%% RTIS2008- Left
  axis([ax1 ax2],[-300 100 -100 900])
axis equal
%% RTIS2009- Right
  axis([ax1 ax2],[-100 450 -100 1000])
axis equal
%% RTIS2010- Left
  axis([ax1 ax2],[-200 200 -100 900])
axis equal
%% RTIS2011- Right
  axis([ax1 ax2],[-200 400 -100 1000])
axis equal
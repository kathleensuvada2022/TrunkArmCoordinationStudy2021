function structure = CreateAddDisplayComponents( structure, participantParams )
% function to create the graphics for Kacey Suvada's trunk arm experiments
 
 disp('called create add display components');
 %addtolim = 50;
 %armlength = 500; %Get this from the main values
 upperArmLength = str2double(get( participantParams.upperArmLengthEditBox, 'String' ));
 lowerArmLength = str2double(get( participantParams.lowerArmLengthEditBox, 'String'));
 handLength = str2double(get( participantParams.handLengthEditBox, 'String'));

 % Arm length in cm
armlength = (upperArmLength + lowerArmLength + handLength)*100;
%armlength = 80;
%//Edited by AMA
scrsz = get(groot,'ScreenSize'); % 3 - horizontal, 4 - vertical
fh = figure('Name','TRUNK-ARM REACHING','OuterPosition',[0.25*scrsz(3) 40 0.75*scrsz(3) scrsz(4)-40],'Color','k','MenuBar','none');


%creates the axes and removes the ticks
structure.Axes1 = axes('visible','on','XTickLabel','','YTickLabel','','XTick',[],'YTick',[],'Color','k','Position',[0.01 0.01 0.98 0.98],'DataAspectRatio',[1 1 1]);
set(structure.Axes1,'xlim',[-0.4 0.4],'ylim',[-0.05 0.75]); %Want both axes to be 0-centered

structure.baseLine = line([-0.4,0.4],[0 0],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color',[0 1 0.5],'Parent',structure.Axes1);

% structure.Axes1 = axes;
% structure.lh = plot(nan);
% axis equal;

structure.shoulderXVal = 0; %Converting to cm
structure.shoulderYVal = 0;
structure.totalArmLength = armlength;


%Kacey Modificiation 7/3/19 setting background color to black
% set(gca,'color',[0 0 0])

%// AM edits
% set(structure.Axes1,'visible','on')
% set(structure.Axes1,'xtick',[])
% set(structure.Axes1,'YTick',[])
%// A.M edits : trying to change BG to black
%//set(structure.Axes1,'color','white');
%//


% % removes background and makes it all white
% set(structure.Axes1,'visible','off')
% set(structure.Axes1,'xtick',[])
% set(structure.Axes1,'YTick',[])
% set(structure.Axes1,'color','white');
% set(structure.Axes1,'xlim',[-325 325]); %Want both axes to be 0-centered
% set(structure.Axes1,'ylim',[-450 450]);
% set(structure.Axes1,'xlim',[-50 50]); %Want both axes to be 0-centered

%//AM editing 10.4.19
% tempXLim_neg = -1.1;
% tempXLim_pos = 1.1;


% set(structure.Axes1,'xlim',[tempXLim_neg tempXLim_pos]); %Want both axes to be 0-centered
% set(structure.Axes1,'ylim',[-0.2 1.2]); %Want both axes to be 0-centered


%set(structure.Axes1,'ylim',[-50 50]); %Comment out to try making the y axis from 0 to 1 instead
% set(structure.Axes1,'ylim',[-1 1.2]); %Comment out to try making the y axis from 0 to 1 instead

% structure.baseLine = line([-25 25],[10 10],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color',[1 0 0],'Parent',structure.Axes1);
% structure.baseLine = line([(tempXLim_neg/2)+0.25 (tempXLim_pos/2)-0.25],[0 0],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','k','Parent',structure.Axes1);

% The first bracket is the x coordinates the second coordinates are the y
% coordinates 
% structure.cone1 = line([-25 -35],[10 45],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','b','Parent',structure.Axes1);
% structure.cone2 = line([25 35],[10 45],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','g','Parent',structure.Axes1);


% structure.cone1 = line([(tempXLim_neg/2)+0.25 (tempXLim_neg/2)-0.1],[0 0.75],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','k','Parent',structure.Axes1);
% structure.cone2 = line([(tempXLim_pos/2)-0.25 (tempXLim_pos/2)+0.1],[0 0.75],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','k','Parent',structure.Axes1);

% making the cross hairs for the marker for the arm
structure.cpx = 0;
structure.cpy = 0;
% horizontal 
% structure.hline1=line([structure.cpx-0.1 structure.cpx+0.1],[structure.cpy structure.cpy],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0.5],'Parent',structure.Axes1);
% %vertical
% structure.hline2=line([structure.cpx structure.cpx],[structure.cpy-0.1 structure.cpy+0.1],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0.5],'Parent',structure.Axes1);

structure.hline1=line([-0.1 0.1],[0 0],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0.5],'Parent',structure.Axes1);
%vertical
structure.hline2=line([0 0],[0.1 0.1],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0.5],'Parent',structure.Axes1);


% %KCS 7.8.19 circle so it looks like cross hair

%%7.15 cross hair moving but circle is not 

%//AM editing 10.4.19
%pos = [structure.cpy-0.1 structure.cpy-.1 .2 .2]; 
%rectangle('Position',pos,'Curvature',[1 1],'EdgeColor',[0 1 0.5],'LineWidth',2)
%//

% Kacey edit 7/8/19 vertical line
% Align with person's midline
structure.hline3=line([0 0],[0 0.7],'Marker','.','LineStyle','--','LineWidth',2, 'Color',[0 1 0.5],'Parent',structure.Axes1);

%% TARGET CIRCLE
% circRect = rectangle('Position',[0-(3*r) 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor',[0 1 0.5]); %green = [0 1 0.5]; red = [1 0 0.5]

%A.M. Commenting this out to check if TimerFcn non-handle error gets fixed

%A.M. 10.04.19 Need to display 'REACH!' only when the home circle is
%reached
% circstr = 'REACH!';
% circRect.UserData.str = circstr;
% circRect.UserData.t = text(0+r+(6.5*r)/2,(1-r)+(2*r)/2, circRect.UserData.str, 'HorizontalAlignment','center', 'Color','white','FontSize',16,'Visible','off')
structure.reachsign = text(0.20,0.65, 'REACH', 'HorizontalAlignment','center', 'Color','white','FontSize',16,'Visible','off')


r=0.06;
structure.newCircle = rectangle('Position',[-0.2-r 0.65-r 2*r 2*r],'Curvature',[1 1],'EdgeColor',[0 1 0.5],'LineWidth',3); %green = [0 1 0.5]; red = [1 0 0.5]
structure.homeCircle = rectangle('Position',[-r -r 2*r 2*r],'Curvature',[1 1],'Visible','on', 'EdgeColor','b', 'LineWidth',3); %green = [0 1 0.5]; red = [1 0 0.5]

r=0.05;
structure.shoulderRect = rectangle('Position',[-0.2 0 r r],'Curvature',[1 1],'EdgeColor','r', 'Visible','on', 'LineWidth',1); %green = [0 1 0.5]; red = [1 0 0.5]




% Making the circle outside of the reach
% structure.x = Circle(50,[0,450]);
% structure.x = Circle(5,[20,40]);
r = 0.07;
% structure.x = Circle(r,[.3,1]);


%circRect is our target circle just beyond the participant's reach
%// AM edit
%circRect = rectangle(structure.Axes1,'Position',[0+(r) 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor',[0 1 0.5]); %green = [0 1 0.5]; red = [1 0 0.5]
%Kacey edit changed to negative sign for position 9/13/19
%circRect = rectangle('Position',[0+(r) 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor',[0 1 0.5]); %green = [0 1 0.5]; red = [1 0 0.5]



% AM edit to try and change the position of green outline of circle with REACH text
% 9.23.19 - changes here did not change it
%circRect = rectangle('Position',[0-(3*r) 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor',[0 1 0.5]); %green = [0 1 0.5]; red = [1 0 0.5]


%homeRect is our home circle that disppears when the participant holds
%their hand there for a little bit of time

%% 15.7.19 AM TO-DO: create homeCircle but do not display it, so that it only gets
%%displayed when Save Participant Parameters is clicked


% KCS 7.8.19 The home circle is set to be 25% of the total arm length away from
% shoulder

%//AM: 12th Aug TESTING

%//AM: This is not actually affecting the appearance of the home circle,
%but needs to be created so that it can be modified later - so visibility
%is OFF here --> go to createParticipantParametersCallback file to change
%appearance and position

%Edited by KACEY 9/13/19 made position negative. Have negative sign in
%front of position sign
%homeRect = rectangle('Position',[0+r .25 2*r 2*r],'Curvature',[1 1],'FaceColor','b', 'Visible','off'); %green = [0 1 0.5]; red = [1 0 0.5]
%homeRect = rectangle('Position',[0-r .25 2*r 2*r],'Curvature',[1 1],'FaceColor','b', 'Visible','off'); %green = [0 1 0.5]; red = [1 0 0.5]

% homeRect = rectangle('Position',[0-r .25 2*r 2*r],'Curvature',[1 1],'FaceColor','b', 'Visible','off'); %green = [0 1 0.5]; red = [1 0 0.5]
%homeRect = rectangle('Position',[-0.3 .4 2*r 2*r],'Curvature',[1 1],'FaceColor','r', 'Visible','off'); %green = [0 1 0.5]; red = [1 0 0.5]
% str = 'HOME';
% %text('Position',[0+r 0.25],'string',str)
% homeRect.UserData.str = str;
% homeRect.UserData.t = text(0+r+(6.5*r)/2,0.25+(2*r)/2, homeRect.UserData.str, 'HorizontalAlignment','center', 'Color','white','FontSize',16,'Visible','off')
% 
% structure.homeCircle = homeRect;
%set(structure.homeCircle,'visible','off')

%%AM testing 9.23.19 ----> THIS IS THE OUTLINE OF THE GREEN CIRCLE,
%%commenting out to hide it for now
%structure.hline3=line('Parent',structure.Axes1,'Xdata',structure.x(:,1),'Ydata',structure.x(:,2),'Color','g','LineWidth',2);



%A.M. Is this homeCircle used to turn whole target circle blue when home is
%reached, since position is same as circRect (?)
% homeRect = rectangle('Position',[0-r 1-r 2*r 2*r],'Curvature',[1 1],'FaceColor','b'); %green = [0 1 0.5]; red = [1 0 0.5]
% structure.homeCircle = homeRect;
% 
% %//AM edit: tried to remove duplicate homeCircle
% set(structure.homeCircle,'Visible','off')
% 
% structure.hline3=line('Parent',structure.Axes1,'Xdata',structure.x(:,1),'Ydata',structure.x(:,2),'Color','g','LineWidth',2);

% [structure.x_circle,structure.y_circle,structure.circles] = Circle(30,(armlength+addedValue),5.5,'b');

    function x = Circle(r,x0,th)
        if nargin < 3
            th = (0:359)';
        end
        
        th = th(:)*pi/180;
        x(:,1) = r*cos(th)+x0(1);
        x(:,2) = r*sin(th)+x0(2);
    end
end
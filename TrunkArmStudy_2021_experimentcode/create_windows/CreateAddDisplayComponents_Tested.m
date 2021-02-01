function structure = CreateAddDisplayComponents( structure, participantParams )
disp('called create add display components');
% addtolim = 50;
% armlength = 500; %Get this from the main values
upperArmLength = str2double(get( participantParams.upperArmLengthEditBox, 'String' ));
lowerArmLength = str2double(get( participantParams.lowerArmLengthEditBox, 'String'));
handLength = str2double(get( participantParams.handLengthEditBox, 'String'));

armlength = (upperArmLength + lowerArmLength + handLength)*100;

structure.Axes1 = axes;
structure.lh = plot(nan);
axis square;

% removes background and makes it all white
set(structure.Axes1,'visible','off')
set(structure.Axes1,'xtick',[])
set(structure.Axes1,'YTick',[])
set(structure.Axes1,'color','white');
% set(structure.Axes1,'xlim',[0 650]);
% set(structure.Axes1,'ylim',[0 900]);
set(structure.Axes1,'xlim',[-325 325]); %Want both axes to be 0-centered
% set(structure.Axes1,'ylim',[-450 450]);
set(structure.Axes1,'ylim',[0 900]);

% structure.baseLine = line([225 425],[50 50],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color',[1 0 0]);
structure.baseLine = line([-100 125],[50 50],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color',[1 0 0]);

% The first bracket is the x coordinates the second coordinates are the y
% coordinates 

% line([225 100],[50 550],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','b')
% line([425 550],[50 550],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','g')
line([-100 -225],[50 550],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','b')
line([125 225],[50 550],'Marker','.','LineStyle','-','LineWidth',1.5, 'Color','g')


% making the cross hairs for the marker for the arm
% structure.cpx = 325;
% structure.cpy = 75;
structure.cpx = 0;
structure.cpy = 0;
% horizontal 
structure.hline1=line([structure.cpx-10 structure.cpx+10],[structure.cpy structure.cpy],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);
%vertical
structure.hline2=line([structure.cpx structure.cpx],[structure.cpy-10 structure.cpy+10],'Marker','.','LineStyle','-','LineWidth',4, 'Color',[0 1 0]);

% Making the circle outside of the reach
structure.x = Circle(50,[0,450]);
structure.hline3=line('Parent',structure.Axes1,'Xdata',structure.x(:,1),'Ydata',structure.x(:,2),'Color','g','LineWidth',2);

%%Just added for debugging
r = 0.15;
homeRect = rectangle('Position',[0+r .25 2*r 2*r],'Curvature',[1 1],'FaceColor','b', 'Visible','off'); %green = [0 1 0.5]; red = [1 0 0.5]
% str = 'HOME';
% %text('Position',[0+r 0.25],'string',str)
% homeRect.UserData.str = str;
% homeRect.UserData.t = text(0+r+(6.5*r)/2,0.25+(2*r)/2, homeRect.UserData.str, 'HorizontalAlignment','center', 'Color','white','FontSize',16,'Visible','off')
% 
structure.homeCircle = homeRect;
%%end debug section

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
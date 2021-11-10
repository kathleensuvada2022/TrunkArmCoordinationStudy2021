function t = asthorho(IJ,PX,C7,T8)
persistent cnt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
% In deze functie wordt het lokale assenstelsel berekend van de thorax,    %
% volgens de nieuwe definities van het isb-proposal                        %
% De richtingsvectoren van de assen worden vertikaal in de matrix gebracht.%
% Oorsprong   : IJ.                                                        %
% Lokale Y-as : as door midden T8-PX en midden c7 en IJ.                   %
% Lokale Z-as : as loodrecht op X-as en normaal door vlak (IJ,PX,C7,T8)    %
% Lokale X-as : as loodrecht op Y-as en Z-as                               %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    yt = (IJ+C7)/2 - (PX+T8)/2; yt = yt/norm(yt);
    [A,DATAa,nvector,e]=vlak([IJ';PX';C7';T8']);
    xhulp = nvector; % if xhulp(1)<0 xhulp = -nvector;end 
    zt = cross(xhulp,yt);zt=zt/norm(zt);
    xt = cross(yt,zt);

%    xt,yt,zt,pause
    t = [xt,yt,zt];
    diff=norm(t)-1>=10*eps;
    if diff>=10*eps, disp('WARNING ASTHOR: norm rotation matrix not equal 1'),disp(diff),return,end
    
    return
    
    if isempty(cnt), clf; end
    BL=(t'*[IJ PX C7 T8])';
%     disp([size(BL);size(t)])
    plot3(BL(:,1),-BL(:,3),BL(:,2),'o'); hold on; 
    if isempty(cnt),
        text(BL(:,1),-BL(:,3),BL(:,2),{'IJ','PX','C7','T8'}); 
        xlabel 'x', ylabel '-z', zlabel 'y'
    end
    tp=t'*t;
    line([0 200*tp(1,1)],-[0 200*tp(3,1)],[0 200*tp(2,1)],'Color','b')
    line([0 200*tp(1,2)],-[0 200*tp(3,2)],[0 200*tp(2,2)],'Color','r')
    line([0 200*tp(1,3)],-[0 200*tp(3,3)],[0 200*tp(2,3)],'Color','g')
%     plot3(t(1,:),t(2,:),t(3,:),'r*');text(t(1,:),t(2,:),t(3,:),{'x','y','z'})
    cnt=1;


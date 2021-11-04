function[h] =  ashum(H1,H2,GH)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function[H] =  ashum(h1,h2,gh)                                           %
%  
% h1: EM
% h2: EL
% In deze functie wordt het lokale assenstelsel berekend van de humerus.   %
% De richtingsvectoren van de assen worden vertikaal in de matrix gebracht.%
% Eerst wordt bepaald welke combinatie punten is gebruikt.                 %
%                                                                          %
% Met de variabele 'zijde' wordt de gemeten zijde aangegeven.              %
%               rechts=r links=l                                           %
%                                                                          %
% Lokale X-as : loodrecht op X-as en epi_l -> epi_m                        %
% Lokale Y-as : lenteriching van hum door midden epicondylen & GH          %
% Lokale Z-as : as loodrecht op lokale X-as en Y-as.                       %
% GH wordt bepaald mbv regressie vergelijkingen in GHEST.M                 %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   bepalen van X-, Y-, en Z-as van de humerus:
    H_mid=(H1+H2)/2;
    y = ( (GH-H_mid) / norm(GH-H_mid));
    xh= (H2-H1)/norm(H2-H1);
    
    
    z =cross(xh,y);z=z/norm(z);
    x =cross(y,z);

    h=[x,y,z];


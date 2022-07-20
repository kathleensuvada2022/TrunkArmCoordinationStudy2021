function [gANGLES,jANGLES,X,gDATA,AS,gR] = CalcInputKinem(flpath,namedatst,reffr)
%
% Main program to process palpation data to bone and joint
% rotations (adapted from palphans.m).
%
% Use :	[gANGLES,jANGLES]=CalcInputKinem(flpath,namedatst)
%			flpath : directory where the experiment data structure is located (DOS path - no spaces)
% 			namedatst : data structure which contains all the information about the experiment
%			reffr: trunk or room frame of reference
%
%			gAngles = bone angles in global coordinates
%			jAngles = joint angles 
%
% August 12, 1996, Frans van der Helm
% March 11, 1997 Ana Maria Acosta
% May 8, 1998	Ana Maria Acosta
% First load the palpation data and put it in a matrix [nplanes*npos*nland x 3] named DATA which
% contains the bony landmarks in the following order. nland=12
% 1)  EM
% 2)  EL
% 3)  SC
% 4)  IJ
% 5)  PX
% 6)  C7
% 7)  T8
% 8)  AC
% 9)  AA
% 10) TS
% 11) AI
% 12) PC
% 13) RS		% Added these to the analysis April 2, 2001
% 14) US
% 15) OL

if nargin<3, reffr='trunk'; end

eval(['load ''' flpath namedatst '''']);
eval(['datast= ' namedatst ';']);

if isempty(datast(1).Mdata)
   ExtractBL(flpath,namedatst);
   eval(['load ' flpath namedatst]);
   eval(['datast= ' namedatst ';']);
end

% The order in which the BL must be in the DATA matrix is:

BL={'EM', 'EL', 'SC', 'IJ', 'PX', 'C7', 'T8', 'AC', 'AA', 'TS', 'AI', 'PC', 'RS', 'US', 'OL'};

% Check to see if additional BLs were included in the arm or forearm
% The corresponding order in the data structure is:
BLdat={datast(1).bonyland(1).landmks.BL datast(1).bonyland(2).landmks.BL datast(1).bonyland(3).landmks.BL datast(1).bonyland(4).landmks.BL};
for i=1:length(BL)
    BLidx(i)=strmatch(BL{i},BLdat,'exact');
end
% disp(BLidx)    

nland=length(BL);
BLidx=3*(BLidx-1) + 1;
BLidx=reshape([BLidx;BLidx+1;BLidx+2],1,3*nland);
% disp(BLidx)
nplanes=length(datast);
DATA=[];
for i=1:nplanes
   DATA=[DATA; datast(i).Mdata(:,BLidx)];
end
DATA=DATA(sum(DATA')~=0,:);	 	% Remove the rows that were padded with zeros
% disp(find(isnan(sum(DATA'))))
nanidx=find(isnan(sum(DATA')));
disp(['Rows ' mat2str(nanidx) ' will be removed'])
DATA=DATA(~isnan(sum(DATA')),:); % Remove the rows that had rigid bodies out of view
npos=size(DATA,1);
DATA=reshape(DATA',3,npos*nland)';
%***********************************************************
% this program will process palpation data to bone and joint
% rotations. The data should be a [npos*nland x 3] npos includes
% nplanes
% matrix named DATA. Results will be presented in the same 
% order.                             
% The following steps will be executed:                    
%                                                         
% 1) transformation to the global coordinate system        
%    (X: left-right, Y: upwards, Z: backwards)             
% 2) calculation of local coordinate systems               
% 3) estimation of axial rotation of the clavicula         
% 4) calculation of rotation matrices w.r.t. the global    
%    coordinate system (bone rotations) and the local      
%    coordinate system of the proximal bone (joint          
%    rotations)                                            
% 5) parameterization of rotation matrices by Euler angles 
%    (order can be chosen)                                 
%                                                          
%************************************************************


% **************************************************************
% 1) transformation to the global coordinate system 
%    (X: left-right, Y: upwards, Z: backwards)
% Data are already in global coordinate system
% gDATA contains the raw data transformed to global coordinate system
% using ABC, and IJ as origin

nDATA=length(DATA)/nland;								%npos
gDATA=zeros(size(DATA));
for i = 1:nDATA
    temp = DATA(nland*(i-1)+1:nland*i,:);
    IJ = temp(strmatch('IJ',BL),:)';
    temp = temp - (diag(IJ)*ones(size(temp))')';
    gDATA(nland*(i-1)+1:nland*i,:) = temp;
end
%clear IJ gDATA;

% **************************************************************
% 2) calculation of local coordinate systems
%
% 		X = | IJ  SC  AC  EM  RS |   
%     	 | PX  AC  AA  EL  US |
%     	 | C7  0   TS  GH  OL |
%     	 | T8  0   AI  0   0  |

X=[];
for i = 1:nDATA
   [x] = data2x(gDATA(nland*(i-1)+1:nland*i,:));
   [X] = [X;x];
end
% EXCLUDING GH TRANSLATION
% Fix the 3D coordinates of the center of the head of the
% humerus (GH) to those measured in the first position
% X(3:4:28,10:12)=X(3*ones(7,1),10:12);
% X(31:4:56,10:12)=X(31*ones(7,1),10:12);
% X(59:4:120,10:12)=X(59*ones(16,1),10:12);
% Indices for WRS
% X(3:4:17*4,10:12)=X(3*ones(17,1),10:12);
% X(17*4+3:4:39*4,10:12)=X((17*4+3)*ones(22,1),10:12);
% X(39*4+3:4:54*4,10:12)=X((39*4+3)*ones(15,1),10:12);

% AS (#measurements x (3x12)) matrix: contains 4 local
% coordinate systems (3x3 matrices) of thorax, clavicle, scapula and
% humerus, respectively

[AS] = asfunc(X,datast(1).arm);

if strcmp(reffr,'frame')
   %Use the frame as reference
   AS(:,1:3)=repmat(eye(3),length(AS)/3,1);
   if strcmp(datast(1).arm,'left'), AS(:,1:3)=repmat(roty(pi)*eye(3),length(AS)/3,1); end
end

% **************************************************************
% 3) estimation of axial rotation of the clavicle         
%    AS (#measurements x (3x12)) matrix: contains 4 local
%    coordinate systems (3x3 matrices) of thorax, clavicle, scapula and
%    humerus, respectively. Clavicle LCS corrected with estimated axial
%    rotation

T = AS(:,1:3);
C = AS(:,4:6);
S = AS(:,7:9);
[Cn,ROTr,ROTg]=axclav(C,S);
AS(1:3*nDATA,4:6) = Cn;
clear C S Cn;

% **************************************************************
% 4) calculation of rotation matrices w.r.t. the thorax 
%    coordinate system (bone rotations) and the local      
%    coordinate system of the proximal bone (joint          
%    rotations)                                            

%    Bone rotations w.r.t. thorax (or G):                  
%    G*Rti = Ti  -> Rti = G'*Ti                            
%    Ti*Rci = Ci  -> Rci = Ti'*Ci                          
%    Ti*Rsi = Si  -> Rsi = Ti'*Si                          
%    Ti*Rhi = Hi  -> Rhi = Ti'*Hi                          
%                                                         
%    Joint rotations w.r.t. proximal bone (or G):          
%    G*Rti = Ti  -> Rti = G'*Ti                            
%    Ti*Rci = Ci  -> Rci = Ti'*Ci                          
%    Ci*Rsi = Si  -> Rsi = Ci'*Si                          
%    Si*Rhi = Hi  -> Rhi = Si'*Hi                         

%	  gR (#measurements x (3 x 12) ) matrix, containing the 
% 	  rotation matrices from global to thoracic LCS (corrected for initial position),
% 	  and thoracic LCS to clavicular, scapular and humeral LCS, respectively
% 	  outputfile: jR (#measurements x (3 x 12) ) matrix, containing the
% 	  rotation matrices from global to thoracic LCS, and thoracic LCS to clavicular
%	  LCS (rotations of sternoclavicular joint), clavicular LCS to scapular LCS
%	  (rotations of acromioclavicular joint), scapular LCS to humeral LCS (glenohumeral
%	  joint).

[gR]=rotbones(AS);
[jR]=rotjoint(AS);

% **************************************************************
% 5) parameterization of rotation matrices by Euler angles (in degrees)

% gANGLES (#measurements x (1 x 12) matrix); (gR
% parameterized in Euler angles, order xyz (thorax), 
% yzx (clavicle), yzx (scapula) and yzy (humerus)
%
% jANGLES (#measurements x (1 x 12) matrix); (jR parameterized 
% in Euler angles, order xyz (thoracic movements), yzx (SC joint),
% yzx (AC joint) and yzy (GH joint)

% Rotation order:                                   
%             1          XYZ    (thor)                                      
%             2          XZY    (fore)                                            
%             3          YZX    (clav,scap)                                 
%             4          ZYX                                                
%             5          ZXY                                                
%             6          YZY    (hum)                                       
[gANGLES(1:nDATA,1:3)]=roteuler(gR(:,1:3),1);
[gANGLES(1:nDATA,4:6)]=roteuler(gR(:,4:6),3);
[gANGLES(1:nDATA,7:9)]=roteuler(gR(:,7:9),3);
[gANGLES(1:nDATA,10:12)]=roteuler(gR(:,10:12),6);

[jANGLES(1:nDATA,1:3)]=roteuler(jR(:,1:3),1);
[jANGLES(1:nDATA,4:6)]=roteuler(jR(:,4:6),3);
[jANGLES(1:nDATA,7:9)]=roteuler(jR(:,7:9),3);
[jANGLES(1:nDATA,10:12)]=roteuler(jR(:,10:12),6);
[jANGLES(1:nDATA,13:15)]=roteuler(jR(:,13:15),2);

if strcmp(datast(1).arm,'left'),
   % The coordinates for THx, THz, SCy, SCx, ACy, ACx, GHy, GHya, ELx, ELy are inverted
   gANGLES(:,[1,3,4,6,7,9,10,12])=-gANGLES(:,[1,3,4,6,7,9,10,12]);
   jANGLES(:,[13:15])=-jANGLES(:,[13:15]);
end
return
% **************************************************************
if strcmp(reffr,'trunk')
   eval(['save ' flpath 'EulerAngles X gANGLES jANGLES'])
elseif strcmp(reffr,'frame')
   eval(['save ' flpath 'EulerAngles2 X gANGLES jANGLES'])
end

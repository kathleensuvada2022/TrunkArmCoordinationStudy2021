load /home/w700/acosta/dasp/totalac.rot -mat
scale=pi/180;

for j=1:6

mean_gANGLES2=mean_gANGLES;

for (i=1:7)
    a1=mean_gANGLES(i,10)*scale;
    a2=mean_gANGLES(i,11)*scale;
    a3=mean_gANGLES(i,12)*scale;

%    R=rotx(a1)*rotz(a2)*roty(a3);
%    R=rotz(a1)*roty(a2)*rotx(a3);
if j==1,  R=rotx(a1)*roty(a2)*rotz(a3); end
if j==2,  R=rotx(a1)*rotz(a2)*roty(a3); end
if j==3,  R=roty(a1)*rotx(a2)*rotz(a3); end
if j==4,  R=roty(a1)*rotz(a2)*rotx(a3); end
if j==5,  R=rotz(a1)*rotx(a2)*roty(a3); end
if j==6,  R=rotz(a1)*roty(a2)*rotz(a3); end
%if j==8,  R=rotz(a1)*rotx(a2)*roty(a3); end
%if j==9,  R=rotz(a1)*rotx(a2)*roty(a3); end

    
    [y,z,ya]=rotyzy(R);
    
    mean_gANGLES2(i,10)=y/scale;
    mean_gANGLES2(i,11)=z/scale;
    mean_gANGLES2(i,12)=ya/scale;

end

mean_gANGLES2
pause

end

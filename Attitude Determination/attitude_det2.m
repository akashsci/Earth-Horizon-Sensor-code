function [rolll,pitchh,Nadir] = attitude_det2(A,B,C,D,E,F,x,y,xs,ys,FOV)
% A,B,C,D,E,F: paramets of the hyperbola equation
% x,y: edge points
% xs,ys: image size
R=6378; %radius of the earth km
H=500; % height of the satellite km
B=B/2;
D=D/2;
E=E/2;
p=asin(R/(H+R));
apix=9; %size of one pixel micrometeres
f=apix/(tand(FOV/ys)); %focal lenght micrometers
cx=xs/2;
cy=ys/2;
Dm=A*C-B*B;
Cxp=-(1/Dm)*(D*C-B*E);
Cx=Cxp-cx;
Cyp=-(1/Dm)*(A*E-D*B);
Cy=-(Cyp-cy);
[ V11x,V11y ] = findvertex( x,y,Cxp,Cyp );
V1x=V11x-cx;
V1y=-(V11y-cy);
roll=atan3(Cx,Cy,V1x,V1y)+pi/2;
[ minx,miny,dis ]=findmindist( x,y,cx,cy);
Pp=sqrt((minx)^2+(miny)^2);
Pd=Pp*apix;
Be=atan(Pd/f);
if V1y >0
    if Cy>V1y
        if ((V1x/V1y)<-5)
        pitch=Be;
        elseif (V1x/V1y)>5
            pitch=Be;
        else
        pitch=-Be;
        end
    elseif Cy<V1y
        pitch=Be;
    end
elseif V1y<0
    if Cy<V1y
        if ((V1x/V1y)>5)
            pitch=Be;
        elseif (V1x/V1y)<(-5) 
            pitch=Be;
        else
        pitch=-Be;
        end
    elseif Cy>V1y
        pitch=Be;
    end
elseif V1y==0
    if V1x>0
        if V1x>Cx 
            pitch=Be;
        else
            pitch=-Be;
        end        
    else
        if V1x>Cx 
            pitch=-Be;
        else
            pitch=Be;
        end   
    end
end
Nadir=[-sin(-roll)*sin(pitch),cos(-roll)*sin(pitch),-cos(pitch)];
rolll=roll*360/(2*pi);
pitchh=pitch*360/(2*pi);
end

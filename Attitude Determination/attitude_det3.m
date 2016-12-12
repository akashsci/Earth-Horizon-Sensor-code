function [rolll,pitchh,Nadir] = attitude_det3(x,y,xs,ys,FOV)
R=6378; %radius of the earth km
H=500; % height of the satellite km
% B=B/2;
% D=D/2;
% E=E/2;
p=asin(R/(H+R));
apix=9; %size of one pixel micrometeres
f=apix/(tand(FOV/ys)); %focal lenght micrometers
cx=xs/2;
cy=ys/2;
% Dm=A*C-B*B;
% Cxp=-(1/Dm)*(D*C-B*E);
Cx=Cxp-cx;
Cyp=-(1/Dm)*(A*E-D*B);
Cy=-(Cyp-cy);
[ V11x,V11y ] = findvertex( x,y,Cxp,Cyp );
V1x=V11x-cx;
 V1y=-(V11y-cy);
%[ V1x,V1y,dis ] = findver( x,y,cx,cy );
roll=atan3(0,0,V1x,V1y)+pi/2;
%roll=atan2(V1y,V1x);
%% ang=0.5*acot(B/(A-C));

% for k=1:4
%     alph2(k)=ang+(k-1)*pi/2;
%     err(k)=abs(alph2(k)-(alph));
% end
% pos=find(err == min(err));
% roll=alph2(pos);
Pp=sqrt((V1x)^2+(V1y)^2);
Pd=Pp*apix;
Be=atan(Pd/f);
if V1y >0
    if Cy>V1y
        pitch=-Be;
        elseif Cy<V1y
        pitch=Be;
    end
elseif V1y<0
    if Cy<V1y
        pitch=-Be;
        elseif Cy>V1y
        pitch=Be;
    end
end
Nadir=[-sin(-roll)*sin(pitch),cos(-roll)*sin(pitch),-cos(pitch)];
rolll=roll*360/(2*pi);
pitchh=pitch*360/(2*pi);
end

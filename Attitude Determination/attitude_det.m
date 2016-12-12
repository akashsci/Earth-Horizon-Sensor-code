function [rolll,pitchh,Nadir,alph22,alph] = attitude_det(A,B,C,D,E,F,x,y,xs,ys)
R=6378; %radius of the earth km
H=500; % height of the satellite km
B=B/2;
D=D/2;
E=E/2;
p=asin(R/(H+R));
apix=9; %size of one pixel micrometeres
f=5000; %focal lenght mi_det(A,B,C,D,E,F)crometers
cx=xs/2;
cy=ys/2;
Dm=A*C-B*B;
Cxp=-(1/Dm)*(D*C-B*E)
Cx=Cxp-cx;
Cyp=-(1/Dm)*(A*E-D*B)
Cy=-(Cyp-cy);
g=[A,B,D;B,C,E;D,E,F];
gr=det(g);
l1=((A+C)+sqrt((A+C)^2-4*Dm))/2;
l2=((A+C)-sqrt((A+C)^2-4*Dm))/2;
sma=sqrt(-(gr/Dm)*1/l1);
smin=sqrt(-(gr/Dm)*1/l2);
Smin=min(sma,smin);
alph=atan2((Cy),(-Cx));
%[ V11x,V11y ] = findvertex( x,y,Cxp,Cyp )
V111x=Smin*cosh(alph);
V1x=V11x-cx;
V111y=Smin*sin(alph);
V1y=-(V11y-cy);
V222x=Smin*cos(alph+pi);
V2x=V22x-cx;
V222y=Smin*sin(alph+pi);
V2y=-(V22y-cy);
ang=0.5*acot(B/(A-C));
for k=1:2
    alph22(k)=ang+(k-1)*pi;
    alph2(k)=ang+(k-1)*pi;
    err(k)=abs(abs(alph2(k))-abs(alph));
end
pos=find(err == min(err));
if (abs(alph2(pos))>pi/2)&&alph2(pos)<0
    alph2(pos)=-(pi-abs(alph2(pos)));
elseif (abs(alph2(pos))>pi/2)&&alph2(pos)>0
     alph2(pos)=pi-abs(alph2(pos));
    
end

roll=alph2(pos);
Pp=sqrt((V1x)^2+(V1y)^2);
Pd=Pp*apix;
Be=atan2(Pd,f);
if Cy>V1y
   pitch=p+Be;%falta centro imagen
elseif Cy<V1y
    pitch=-(p+Be);
end
Nadir=[-sin(-roll)*sin(pitch),cos(-roll)*sin(pitch),-cos(pitch)];
rolll=roll*360/(2*pi);
pitchh=pitch*360/(2*pi);
end


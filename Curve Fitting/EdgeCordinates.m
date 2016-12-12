close all
%parameters
%parametres equació del pla
A=1;
B=3;
C=-1;
D=0;
%parametres elipsoide (3 axes)
a=6378137;
b=6378137;
c=6356752;

%/////////////////////////////
[Aye,Bye,q1,q2,q3]=EllipsoidPlaneIntersection(A,B,C,D,a,b,c)
figure
subplot(1,2,1),
plotintersec(A,B,C,D,a,b,c);
%pitch = asin(4/3);
%yaw = asin( -1 /(cos(pitch)*3)); 
%roll = 0;
%[ellipseCoords, h]=Ellipse_3D(
%Aye,Bye,q1,q2,q3,100,pitch,roll,yaw,1,'r')%no se com calcular el roll 
[X,Y] = calculateEllipse(q1, q2, Aye,Bye,0, 100);
subplot(1,2,2),
%numero de punts que agafem
r = -1000 + (2000).*rand(round(length(X)/8)-1,1);
x=X(1:1:length(X)/8)+r;
y=Y(1:1:length(Y)/8)+r;
ellip = fit_ellipse( x,y,gca,'0')
hold on
plot (X,Y,'r')
hold off
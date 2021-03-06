function [lx,ly] = ellip2D(elli_point,err,div)
%INPUTS:
%elli_point: number of points of the ellipse
%err: maximum error respect the real data
%div: each 'div' points we take on
%OUTPUTS:
%lx= length of points used for calculate the ellip ( x axis)
%ly= length of points used for calculate the ellip ( y axis)
%close all
%parameters
%parametres equaci� del pla
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
[X,Y] = calculateEllipse(q1, q2, Aye,Bye,0, elli_point);
subplot(1,2,2),
r = err.*rand(round(length(X)/div),1);%random noise creation
%number of points we get
x=X(1:1:round(length(X)/div))+r;
y=Y(1:1:round(length(Y)/div))+r;
lx=length(x);
ly=length(y);
ellip = fit_ellipse( x,y,gca,'0')
hold on
plot (X,Y,'r')
axis equal
hold off
legend('calculated','real')
end
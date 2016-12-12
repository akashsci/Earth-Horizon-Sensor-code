function [lx,ly] = hyp2D(err,div)
%INPUTS:
%elli_point: number of points of the hyp
%err: maximum error respect the real data
%div: each 'div' points we take on
%OUTPUTS:
%lx= length of points used for calculate the hyp ( x axis)
%ly= length of points used for calculate the hyp ( y axis)
%close all
%parameters
%parametres del pla
A=0.5;
B=-0.25;
C=0.3;
%/////////////////////////////
[l,k,w1,w2,y1,y2]=conicplaneintersec(A,B,C);
er = err.*rand(1,round(length(l)/div)+1);%random noise creation
r=l((round(length(l)/div)+25):1:(round(length(l)/div)+25+round(length(l)/div)))+er;
p=k((round(length(k)/div)+25):1:(round(length(k)/div)+25+round(length(k)/div)))+er;
lx=length(r);
ly=length(p);
%ellip = fit_ellipse( x,y,gca,'0')
[ell,hyp]=fitEllipsAndHyperbola(r',p');
[A,B,C,D,E,F]=deal(hyp(1),hyp(2),hyp(3),hyp(4),hyp(5),hyp(6));
figure,
[x,y] = meshgrid(-7:0.1:7);   %# Create a mesh of x and y points
fxy=A*x.^2 + B*x.*y + C*y.^2 + D*x + E*y + F ;
contour(x,y,fxy,[0 0],'y');  %# Generate the contour plot
xlabel('x');                    %# Add an x label
ylabel('y');  
hold on
plot (r,p,'r')
axis equal
hold off
legend('estimated','real')
figure,
contour(x,y,fxy,[0 0],'b');
hold on
plot(w1,y1,'g')
hold on
plot(w2,y2,'g')
hold off
axis equal
legend('calculated','real')
end
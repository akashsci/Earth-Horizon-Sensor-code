[l,k,w1,w2,y1,y2]=conicplaneintersec(0.5,-0.25,0.1);
A=1;
B=3;
C=-1;
D=0;
a=6000;
b=5000;
c=1000;
%/////////////////////////////
%[Aye,Bye,q1,q2,q3]=EllipsoidPlaneIntersection(A,B,C,D,a,b,c)
%figure
%[X,Y] = calculateEllipse(q1, q2, Aye,Bye,0, 100);

%x=X(1:2:length(X)/8);
%y=Y(1:2:length(Y)/8);
%plot(x,y)
%axis([0 6000 -3000 3000])
%figure
%ellip = fit_ellipse( x,y,'0')
[a,b,c,d,e,f]=hyptest2(w2,y2)
hold on
plot (l,k,'r'); hold off
%hold on
%plot(l,k); hold off
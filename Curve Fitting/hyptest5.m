[l,k,w1,w2,y1,y2]=conicplaneintersec(0.5,-0.25,0.3);
[ell,hyp]=fitEllipsAndHyperbola(w1',y1');
[A,B,C,D,E,F]=deal(hyp(1),hyp(2),hyp(3),hyp(4),hyp(5),hyp(6));
[x,y] = meshgrid(-7:0.1:7);   %# Create a mesh of x and y points
fxy=A*x.^2 + B*x.*y + C*y.^2 + D*x + E*y + F ;
contour(x,y,fxy,[0 0],'b');  %# Generate the contour plot
xlabel('x');                    %# Add an x label
ylabel('y');  

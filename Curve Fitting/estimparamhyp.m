clear all
close all
[l,k,w1,w2,y1,y2]=conicplaneintersec(0.5,-0.25,0.1);
r=w1';
t=y1';
N=[ r t ones(size(t))];
c = sqrt(r.^2 + t.^2);
p=pinv(N)*c
err= r.^2+t.^2-(p(1).*r+p(2).*t+p(3)).^2;
figure,
plot(err)
xlabel('point'); ylabel('error');
[A B D]=deal(p(1),p(2),p(3));
figure,
plot(w1,y1,'b'); hold on
plot(w2,y2,'b'); hold on
[x,y] = meshgrid(-7:0.5:7);   %# Create a mesh of x and y points
fxy= (x.^2)*(A^2-1) +(y.^2)*(B^2-1)+2*A*B*x.*y+2*A*x+2*B*y+2*D+D^2;
contour(x,y,fxy,[0 0],'r');%# Generate the contour plot
xlabel('x');                    %# Add an x label
ylabel('y');
axis equal
legend('real data','real data','estimated data')
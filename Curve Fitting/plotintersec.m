function plotintersec( A,B,C,D,a,b,c )
% draw intersection ellipsoid and a planeE 
% Plane equation A.x + B.y + C.z + D = 0 
% Ellipsoid equation (x/a)^2 + (y/b)^2 + (z/c)^2 = 1 
a=6378137;b=6378137;c=6356752; 
A=-1;B=0;C=2;D=0;
v=[1/a^2 1/b^2 1/c^2 0 0 0 0 0 0 -1];
axis equal 
maxd = 1.1*max( [ a b c ] );

[x,y]=meshgrid(-maxd:10000:maxd); 
zv=@(x,y)(A*x+B*y+D)/-C; 
r=zv(x,y);

%figure 
surf(x,y,r) 
%shading flat 
hold on 
xlabel('x'); ylabel('y'); zlabel('z')
step = maxd/10; 
[ x, y, z ] = meshgrid( -maxd:step:maxd +0, -maxd:step:maxd +0, -maxd:step:maxd +0 );

Ellipsoid = v(1) *x.*x + v(2) * y.*y + v(3) * z.*z + ... 
2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ... 
2*v(7) *x + 2*v(8)*y + 2*v(9) * z;

p = patch( isosurface( x, y, z, Ellipsoid, 1 ) ); 
set( p, 'FaceColor', 'g', 'EdgeColor', 'y' ); 
view( -70, 40 ); 
axis vis3d; 
%camlight; 
lighting phong;
%/////////////////////////////////////////////////////////////////
end


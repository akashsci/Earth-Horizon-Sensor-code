function elipsoidegen(a,b,c)
[x, y, z] = ellipsoid(0,0,0,a,b,c,30);
figure
surf(x, y, z)
axis equal
end

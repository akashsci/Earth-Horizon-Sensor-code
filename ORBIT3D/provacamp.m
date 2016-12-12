[x, y, z] = ellipsoid(0,0,0,10,10,10,30);
figure
surf(x, y, z)
%campos('manual')
axis vis3d off
campos([10,10,10])
camtarget([-6,11.5,-3])
camroll(0)





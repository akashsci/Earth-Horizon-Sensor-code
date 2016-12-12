function planegen(a,b,c,d)

[x y] = meshgrid(-6378137:round(6378137/100):6378137); % Generate x and y data
z = -1/c*(a*x + b*y + d);
%[%r,t] = meshgrid([-2:.2:2]);
%p = r.*exp(-r.^2-t.^2);

surf(x,y,z)



end
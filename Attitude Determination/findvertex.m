function [ Vx,Vy,dis ] = findvertex( x,y,Cx,Cy )
for n=1:length(x)
    dist(n)=sqrt((x(n)-Cx)^2+(y(n)-Cy)^2);
end
pos = find(dist==min(dist));
dis=dist(pos);
Vx=x(pos);
Vy=y(pos);

end


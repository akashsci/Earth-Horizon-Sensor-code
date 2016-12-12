function [ Cx,Cy,dis ] = findmindist( x,y,xcen,ycen )
x=x-xcen;
y=-(y-ycen);
for n=1:length(x)
    dist(n)=sqrt((x(n))^2+(y(n))^2);
end
pos = find(dist==min(dist));
dis=dist(pos);
Cx=x(pos);
Cy=y(pos);
end


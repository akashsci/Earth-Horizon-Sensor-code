for j=0:1:20
    mat_rol(:,j/1+1)=(-180:5:180)';
end
t=1;
for i=-180:5:180
    mat_pitch((i+180)/5+1,:)=0:1:20;
end
function [rolll,pitchh]=test_def(roll,pitch,FOV) 
close all
addpath(genpath('C:\Users\Guille\Documents\UNI\PAE\MATLABcode'));
cd 'C:\Users\Guille\Documents\UNI\PAE\MATLABcode'
getearthim(1,roll,pitch,FOV);
name='re';
print(name,'-djpeg');
name2=strcat(name,'.jpg');
i=imread(name2); 
Fov=FOV;
Im = rgb2gray(i);
I=imrotate(Im,0);
[ys,xs] = size(I);
%figure, imshow(I)
im = binarize(I);
%figure, imshow(im)
ii=medfilt2(im);
[x,y]=size(im);
P = round(x*y/40);
BW2 = bwareaopen(im,P);
%BW= edge(BW2,'Canny'); it cuould be used instead of createimage
BW = createimage(BW2); %Heinrich algorithm
figure, imshow(BW2)
figure, imshow(I)
[a,b] = EdgeCord(BW);
[ell,hyp]=fitEllipsAndHyperbola(b,a);
[A,B,C,D,E,F]=deal(hyp(1),hyp(2),hyp(3),hyp(4),hyp(5),hyp(6));
hold on
[x,y] = meshgrid(-max(x,y)-50:max(x,y)/100:max(x,y)+50);   %# Create a mesh of x and y points
fxy=A*x.^2 + B*x.*y + C*y.^2 + D*x + E*y + F ;
contour(x,y,fxy,[0 0],'r');  %# Generate the contour plot
hold off
figure,
contour(x,y,fxy,[0 0],'r');
hold on;
imshow(BW)
[rolll,pitchh,Nadir] = attitude_det2(A,B,C,D,E,F,b,a,xs,ys,Fov)
figure,
imshow(BW)
hold on
cxx=round(xs/2)+1;
cyy=floor(ys/2);
plot(1:xs,cyy*ones(1,(xs)),'Color','y','LineStyle','--');
hold on
plot(cxx*ones(1,ys),1:ys,'Color','y','LineStyle','--');
BB=B/2;
DD=D/2;
EE=E/2;
Dm=A*C-BB*BB;
CX=-(1/Dm)*(DD*C-BB*EE);
CY=-(1/Dm)*(A*EE-DD*BB);%points of hyperbola center
plot(CX,CY,'Color','r','LineWidth',2);%hyperbola center
[ VX,VY ] = findvertex( b,a,CX,CY );
xlim = get(gca,'XLim');
m = (CY-VY)/(CX-VX)
n=-CX*m+CY;
y1 = m*xlim(1) + n;
y2 = m*xlim(2) + n;
plot(0,0,'ro')
hold on
line([xlim(1) xlim(2)],[y1 y2])
hold on
plot([CX VX],[CY VY],'*')
hold on
contour(x,y,fxy,[0 0],'r');
u1=[1,0,0];
u2=[0,1,0];
prnad=(u1*Nadir'/(u1*u1'))*u1+(u2*Nadir'/(u2*u2'))*u2;
mp=prnad(2)/prnad(1);
n=-CX*mp+CY;
y1 = mp*xlim(1) + n;
y2 = mp*xlim(2) + n;
hold on
line([xlim(1) xlim(2)],[y1 y2])

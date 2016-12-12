close all
addpath(genpath('C:\Users\Guille\Documents\UNI\PAE\MATLABcode'));
cd 'C:\Users\Guille\Documents\UNI\PAE\MATLABcode'
Fov=60;
step1=1;
step2=5;
% rol_rand=360*rand(1,30)-180;
% pitch_rand=20*rand(1,30);
for j=-180:step2:180
for i=0:step1:20
getearthim(1,j,i,60)%fov=60
st=int2str(i);
name=strcat('c',st);
print(name,'-djpeg');
close all
name2=strcat(name,'.jpg');
imm=imread(name2); %input image
I = rgb2gray(imm);
[ys,xs] = size(I);
im = binarize(I);
ii=medfilt2(im);
[x,y]=size(im);
P = round(x*y/50);
BW2 = bwareaopen(im,P);
BW= edge(BW2,'Canny');
%BW = createimage(BW2);
[a,b] = EdgeCord(BW);
[ell,hyp]=fitEllipsAndHyperbola(b,a);
[A,B,C,D,E,F]=deal(hyp(1),hyp(2),hyp(3),hyp(4),hyp(5),hyp(6));
[rolll,pitchh,Nadir] = attitude_det2(A,B,C,D,E,F,b,a,xs,ys,60);%fov=60
rol(1+(j+180)/step2,1+i/step1)=rolll;
pitch(1+(j+180)/step2,1+i/step1)=pitchh;
end
end

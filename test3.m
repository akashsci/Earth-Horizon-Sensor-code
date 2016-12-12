close all
clc,clear all
addpath(genpath('C:\Users\Guille\Documents\UNI\PAE\MATLABcode'));
cd 'C:\Users\Guille\Documents\UNI\PAE\MATLABcode'
i=imread('test6.jpg'); %posar la imatge desitjada
I = rgb2gray(i);
%figure, imshow(I)
im = binarize(I);
%figure, imshow(im)
ii=medfilt2(im);
[x,y]=size(im);
P = round(x*y/10);
BW2 = bwareaopen(im,P);
%BW= edge(BW2,'Canny');
BW = createimage(BW2)
figure
subplot(2,2,1),imshow(im)
subplot(2,2,2), imshow(I)
%subplot(2,2,3),
figure, imshow(BW2)
%subplot(2,2,4), 
figure, imshow(BW)
[x,y] = EdgeCord(BW);
[elip,a,b,c,d,e,f] = ellipsefit_direct(y,x,BW)
hold on
[cent,rad,res] = circlefit(y,x,BW);
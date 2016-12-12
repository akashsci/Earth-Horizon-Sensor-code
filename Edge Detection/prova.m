close all
i=imread('test5.jpg'); %posar la imatge desitjada
I = rgb2gray(i);
%figure, imshow(I)
im = binarize(I);
%figure, imshow(im)
ii=medfilt2(im);
[x,y]=size(ii);
P = round(x*y/10);
BW2 = bwareaopen(ii,P);
%tic
%BW= edge(BW2,'Sobel');
%toc
BW = createimage(BW2);
figure,imshow(BW2)
figure,imshow(BW)

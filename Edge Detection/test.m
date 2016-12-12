close all; clc;

I = rgb2gray(imread('test2.jpg'));
figure, imshow(I)
im = binarize(I);
figure, imshow(im)
createimage(im)

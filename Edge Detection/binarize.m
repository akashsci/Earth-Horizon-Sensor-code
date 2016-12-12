function [BW ] = binarize( im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
level = graythresh(im);
BW = im2bw(im,1.7*level);
imshow(BW)

end


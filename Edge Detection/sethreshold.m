function [thold,col,row] = sethreshold(image)

[col,row] = size(image);
 tot = sum(sum(image));
 av = tot/(col*row);
 thold = 0.7*av;
end

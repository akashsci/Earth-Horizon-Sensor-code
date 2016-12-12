function [x, y, v] = contoursconvert(C)

%Converts the output of CONTOURS to a form usable by PLOT
%
% C = [info1 line1 info2 line2 ...]
% where info# are 2-by-1 vectors of information about line# in the form
% [ignore; N#], and line# is the 2-by-N# vector of [x; y] data
%
%Converts to the form:
%
% [x y] where the columns of x and y each define a different line.  For
% lines where N# is less than the max(N#), NaN values fill the remainder of
% the columns.
%
% v is the number of data points for each line.

limit = size(C,2);
i = 1;
n = 0;
while(i < limit)
    n = n + 1;
    I(n) = i;
    v(n) = C(2,i);
    i = i + 1 + C(2, i);
end
x = NaN*ones(n, max(v));
y = x;
for n = 1:length(v)
    x(n,1:v(n)) = C(1,I(n)+1:I(n)+v(n));
    y(n,1:v(n)) = C(2,I(n)+1:I(n)+v(n));
end
x = x.'; y = y.';
end
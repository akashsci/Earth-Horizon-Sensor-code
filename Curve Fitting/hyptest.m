function hyptest
close all
clear all
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
[y,x] = EdgeCord(BW);
x = x(:);
y = y(:);

% normalize data
mean_x = mean(x);
mean_y = mean(y);
sx = (max(x)-min(x))/2;
sy = (max(y)-min(y))/2;
smax = max(sx,sy);
sx = smax;
sy = smax;
x = (x-mean_x)/sx;
y = (y-mean_y)/sy;

% build design matrix
D = [ x.^2  x.*y  y.^2  x  y  ones(size(x)) ];

% build scatter matrix
S = D'*D;

% build 6x6 constraint matrix
C = zeros(6,6);
C(1,3) = -2;
C(2,2) = 1;
C(3,1) = -2;

if 1
    p = ellipsefit_robust(S,-C);
elseif 0
    % solve eigensystem
    [gevec, geval] = eig(S,C);
    geval = diag(geval);

    % extract eigenvector corresponding to unique negative (nonpositive) eigenvalue
    p = gevec(:,geval < 0 & ~isinf(geval));
    r = geval(geval < 0 & ~isinf(geval));
elseif 0
    % formulation as convex optimization problem
    gamma = 0; %#ok<*UNRCH>
	cvx_begin sdp
        variable('gamma');
        variable('lambda');
        maximize(gamma);
        lambda >= 0; %#ok<*VUNUS>
        %[ S + lambda*C,       zeros(size(S,1),1) ...
        %; zeros(1,size(S,2)), lambda - gamma ...
        %] >= 0;
        S + lambda*C >= 0;
        lambda - gamma >= 0;
    cvx_end
    
    % recover primal optimal values from dual
    [evec, eval] = eig(S + lambda*C);
    eval = diag(eval);
    [~,ix] = min(abs(eval));
    p = evec(:,ix);
end 
    [ParG, code] = AtoG([p(1),p(2),p(3),p(4),p(5),p(6)]');
     [Xcenter, Ycenter, a, b, AngleOfTilt] = deal(ParG(1),ParG(2),ParG(3),ParG(4),ParG(5));
     points = create_hyperbola( a,b,AngleOfTilt,Xcenter,Ycenter,1,200 ); 
end
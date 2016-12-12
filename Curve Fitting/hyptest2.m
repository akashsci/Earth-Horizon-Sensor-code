function [A,B,C,D,E,F] = hyptest2(x,y) 
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

% unnormalize
p(:) = ...
[ p(1)*sy*sy ...
; p(2)*sx*sy ...
; p(3)*sx*sx ...
; -2*p(1)*sy*sy*mean_x - p(2)*sx*sy*mean_y + p(4)*sx*sy*sy ...
; -p(2)*sx*sy*mean_x - 2*p(3)*sx*sx*mean_y + p(5)*sx*sx*sy ...
; p(1)*sy*sy*mean_x*mean_x + p(2)*sx*sy*mean_x*mean_y + p(3)*sx*sx*mean_y*mean_y - p(4)*sx*sy*sy*mean_x - p(5)*sx*sx*sy*mean_y + p(6)*sx*sx*sy*sy ...
];

p = p ./ norm(p);

[A,B,C,D,E,F] = deal(p(1),p(2),p(3),p(4),p(5),p(6));
[x,y] = meshgrid(-7:0.1:7);   %# Create a mesh of x and y points
fxy=A*x.^2 + B*x.*y + C*y.^2 + D*x + E*y + F ;
contour(x,y,fxy,[0 0],'b');  %# Generate the contour plot
xlabel('x');                    %# Add an x label
ylabel('y');  

   % [ParG, code] = AtoG([p(1),p(2),p(3),p(4),p(5),p(6)]');
    
    %[Xcenter, Ycenter, a, b, AngleOfTilt] = deal(ParG(1),ParG(2),ParG(3),ParG(4),ParG(5));
     %points = create_hyperbola( a,b,AngleOfTilt-pi/4,Xcenter,Ycenter,1,800 ); 
     
end
function [ellipse_t,a,b,c,d,e,F] = ellipsefit_direct(x,y,IM)
% Direct least squares fitting of ellipses.
%
% Input arguments:
% x,y;
%    x and y coodinates of 2D points
%
% Output arguments:
% p:
%    a 6-parameter vector of the algebraic ellipse fit with
%    p(1)*x^2 + p(2)*x*y + p(3)*y^2 + p(4)*x + p(5)*y + p(6) = 0
%
% References:
% Andrew W. Fitzgibbon, Maurizio Pilu and Robert B. Fisher, "Direct Least
%    Squares Fitting of Ellipses", IEEE Trans. PAMI 21, 1999, pp476-480.

% Copyright 2011 Levente Hunyadi

% initialize
orientation_tolerance = 1e-3;
validateattributes(x, {'numeric'}, {'real','nonempty','vector'});
validateattributes(y, {'numeric'}, {'real','nonempty','vector'});
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

% extract parameters from the conic equation
[a,b,c,d,e,f] = deal( p(1),p(2),p(3),p(4),p(5),p(6) );

% check if conic equation represents an ellipse
test = a*c-b^2;
switch (1)
case (test>0),  status = '';
case (test==0), status = 'Parabola found';  warning( 'fit_ellipse: Did not locate an ellipse' );
case (test<0),  status = 'Hyperbola found'; warning( 'fit_ellipse: Did not locate an ellipse' );
end

% if we found an ellipse return it's data
if (test>0)
    % remove the orientation from the ellipse
if ( min(abs(b/a),abs(b/c)) > orientation_tolerance )
    %orientation_rad =0;
    orientation_rad = 1/2 * atan( b/(c-a) );
    cos_phi = cos( orientation_rad);
    sin_phi = sin( orientation_rad);
    [a,b,c,d,e] = deal(...
        a*cos_phi^2 - b*cos_phi*sin_phi + c*sin_phi^2,...
        0,...
        a*sin_phi^2 + b*cos_phi*sin_phi + c*cos_phi^2,...
        d*cos_phi - e*sin_phi,...
        d*sin_phi + e*cos_phi );
    [mean_x,mean_y] = deal( ...
        cos_phi*mean_x - sin_phi*mean_y,...
        sin_phi*mean_x + cos_phi*mean_y );
else
    orientation_rad = 0;
    cos_phi = cos(orientation_rad );
    sin_phi = sin(orientation_rad );
end
    
    % make sure coefficients are positive as required
    if (a<0), [a,c,d,e] = deal( -a,-c,-d,-e ); end
    
    % final ellipse parameters
    X0          = mean_x - d/2/a;
    Y0          = mean_y - e/2/c;
    F           = 1 + (d^2)/(4*a) + (e^2)/(4*c);
    [a,b]       = deal( sqrt( F/a ),sqrt( F/c ) );    
    long_axis   = 2*max(a,b);
    short_axis  = 2*min(a,b);

    % rotate the axes backwards to find the center point of the original TILTED ellipse
    R           = [ cos_phi sin_phi; -sin_phi cos_phi ];
    P_in        = R * [X0;Y0];
    X0_in       = P_in(1);
    Y0_in       = P_in(2);
    
    % pack ellipse into a structure
    ellipse_t = struct( ...
        'a',a,...
        'b',b,...
        'phi',orientation_rad,...
        'X0',X0,...
        'Y0',Y0,...
        'X0_in',X0_in,...
        'Y0_in',Y0_in,...
        'long_axis',long_axis,...
        'short_axis',short_axis,...
        'status','' );

    % rotation matrix to rotate the axes with respect to an angle phi
    R = [ cos_phi sin_phi; -sin_phi cos_phi ];
    
    % the axes
    ver_line        = [ [X0 X0]; Y0+b*[-1 1] ];
    horz_line       = [ X0+a*[-1 1]; [Y0 Y0] ];
    new_ver_line    = R*ver_line;
    new_horz_line   = R*horz_line;
    
    % the ellipse
    theta_r         = linspace(0,2*pi);
    ellipse_x_r     = X0 + a*cos( theta_r );
    ellipse_y_r     = Y0 + b*sin( theta_r );
    rotated_ellipse = R * [ellipse_x_r;ellipse_y_r];
    
    % draw    
    %hold_state = get( axis_handle,'NextPlot' );
    %set( axis_handle,'NextPlot','add' );
    if IM~='0'
        figure,
    end
   %plot( new_ver_line(1,:),new_ver_line(2,:),'r' );
    %plot( new_horz_line(1,:),new_horz_line(2,:),'r' );
   
    plot( rotated_ellipse(1,:),rotated_ellipse(2,:),'b' );
   % set( axis_handle,'NextPlot',hold_state );
   if IM~='0'
   hold on
   imshow(IM)
   hold off
   end
   
elseif test <0
     [ParG, code] = AtoG([a,b,c,d,e,f]');
     [Xcenter, Ycenter, a, b, AngleOfTilt] = deal(ParG(1),PargG(2),ParG(3),ParG(4),ParG(5));
     points = create_hyperbola( a,b,AngleOfTilt,Xcenter,Ycenter,1,200 );   
        
end

end 



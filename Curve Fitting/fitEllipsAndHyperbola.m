function [ellipse, hyperbola]=fitEllipsAndHyperbola(x, y);
%x and y should be column vectors
x2=x.^2;
y2=y.^2;
xy=x.*y;
%Set up the design and scatter matrices
D1=[x2,xy,y2];
D2=[x,y,ones(size(x))];
S1=D1'*D1;
S2=D1'*D2;
S3=D2'*D2;
%% test the rank of S3
[Us3, Ss3, Vs3]=svd( S3 );
condNrs=diag( Ss3 )/Ss3(1,1);
epsilon=eps;
if condNrs(3)<epsilon
warning('S3 is degenerate');
return;
end;
%%define the constraint matrix and its inverse
C=[0, 0, -2;0, 1, 0;-2, 0, 0];
Ci=inv(C);
%%Setup and solve the generalized eigenvectorproblem
T=-inv( S3 )*S2';
S=Ci*(S1+S2*T);
[evec,eval]=eig( S );
%% evaluate and sort resulting constraint values
cond=evec(2,:).^2-4*(evec(1,:).*evec(3,:));
[condVals index]=sort( cond );
%% Pick up the elliptical solution
eValE=condVals( 1 );
alpha1=evec( :,index(1) );
alpha2=T*alpha1;
ellipse=[alpha1;alpha2];
%% Pick up the hyperbolic solution
possibleHs=condVals(2:3)+condVals(1);
[minDiffVal, minDiffAt]=min( abs( possibleHs ) );
eValH=possibleHs(minDiffAt);
alpha1=evec( :,index(minDiffAt+1) );
alpha2=T*alpha1;
hyperbola=[alpha1; alpha2];
end
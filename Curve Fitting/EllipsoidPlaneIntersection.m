function[Aye,Bye,q1,q2,q3]=EllipsoidPlaneIntersection(A,B,C,D,a,b,c)

% Inputs -----------------------------------------------------------------
%   A,B,C,D    :Plane equation's coefficients  
%                
%   a,b,c      : Semi-axes of ellipsoid 
%                
% Outputs ----------------------------------------------------------------
%   Aye:  Semi-major axis of intersection ellipse

%   Bye:  Semi-minor axis of intersection ellipse

%
% q1,q2,q3 : Cartesian coordinates of intersection ellipse's center
%elipsoidegen(a,b,c)
%hold on
%planegen(A,B,C,D)
car=A*B*C*D;
if car~=0
kx2=1/a^2 + (A^2)/(C^2*c^2);
ky2=1/b^2 + (B^2)/(C^2*c^2);
kxy=(2*A*B)/(C^2*c^2);
kx=+ (2*A*D)/(C^2*c^2);
ky=+ (2*B*D)/(C^2*c^2) ;
ksab=D^2/(C^2*c^2)- 1;
ParA=[kx2  kxy  ky2  kx  ky  ksab];
G=AtoG(ParA);

q1=G(1);q2=G(2);q3=(A*q1+B*q2+D)/-C;
    end

if C==0 & A~=0
ParA=[(1/b^2 + (B/A/a)^2) 0  1/c^2 (2*D*B/(A*a)^2)  0  (-1+(D/A/a)^2)];G=AtoG(ParA);

q2=G(1);q3=G(2);q1=(D+B*q2+C*q3)/-A;    
end

if C==0 & B~=0
ParA=[(1/a^2 + (A/B/b)^2) 0  1/c^2 (2*D*A/(B*b)^2)  0  (-1+(D/B/b)^2)];G=AtoG(ParA);

q1=G(1);q3=G(2);q2=(D+A*q1+C*q3)/-B;    
end

if A==0 & B==0 ,    q1=0;q2=0;q3=-D/C;end 
if D==0,    q1=0;q2=0;q3=0;

end 
 
quz=sqrt(q1^2+q2^2+q3^2);
n1=A/sqrt(A^2+B^2+C^2);
n2=B/sqrt(A^2+B^2+C^2);
n3=C/sqrt(A^2+B^2+C^2);
kap=(q1*A+B*q2+C*q3)/sqrt(A^2+B^2+C^2);
d= kap^2*(A^2+B^2+C^2)/(a^2*A^2+b^2*B^2+c^2*C^2);

ak=1;
bk=-(n1^2*(1/b^2+1/c^2)+n2^2*(1/c^2+1/a^2)+n3^2*(1/b^2+1/a^2));
ck=(n1/b/c)^2+(n2/a/c)^2+(n3/b/a)^2;
p=[ak bk ck];
kok=roots(p);
Bye=sqrt((1-d)/kok(1));
Aye=sqrt((1-d)/kok(2));


end

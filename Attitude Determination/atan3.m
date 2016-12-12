function [ alph ] = atan3( Cx,Cy,Vx,Vy )
    alph = atan2(Vy-Cy,Vx-Cx);
    if (alph+pi/2)>pi
        alph=alph-2*pi;
    end
end


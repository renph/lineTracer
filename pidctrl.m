function [vL, vR, du] = pidctrl( err )
persistent base u err1
% ³õÊ¼»¯
if nargin<1 || nargout == 0
    base=12.5;
    err1=0;
    u = 0;
    return
end

du = 0.75 * err + 0.375 * (err - err1);
u = u + du;

if u > base
    u = base;
elseif u < -base
    u = -base;
end

vL = base - u ;
vR = base + u ;
err1 = err;

end


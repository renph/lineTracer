function [vL, vR, du] = nnctrl( err )
persistent base u err1
% ��ʼ��
if nargin<1 || nargout == 0
    base=12.5;
    err1=0;
    u = 0;
    return
end

du = nnPID([err;err1]);
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


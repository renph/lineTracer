function [ vL,vR ] = nnctrl2( err )
%NNCTRL2 nerual network controller(end to end network)

persistent err1
if nargin<1
    err1 =0;
    return
end

nnOut=nnAppr([err; err1]);

vL=nnOut(1);
vR=nnOut(2);

err1 = err;
end

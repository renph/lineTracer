function [mpx, mpy,mapsize] = mapGen( )

% t1 = linspace(pi/2, -pi/2,100);
% t2 = linspace(-pi/2, -3*pi/2,100);
% % 去除端点重合的点
% mpx = [linspace(-20,20,100)  20+10*cos(t1(2:end-1)) linspace(20,-20,100) -20+10*cos(t2(2:end))];
% mpy = [zeros(1,100)         -10+10*sin(t1(2:end-1)) -20*ones(1,100)      -10+10*sin(t2(2:end))];

[mpx, mpy,mapsize] = map1();
end
function [mpx, mpy,mapsize] = map1()

[lx1,ly1] = genLine(-20,0,20,0);
[cx1,cy1] = genCircle(20,-10,10,pi/2,-pi/2);
[lx2,ly2] = genLine(20,-20,-20,-20);
[cx2,cy2] = genCircle(-20,-10,10,-pi/2,-3*pi/2);
% 去除端点重合的点
mpx = [lx1(1:end-1) cx1(1:end-1) lx2(1:end-1) cx2(1:end)];
mpy = [ly1(1:end-1) cy1(1:end-1) ly2(1:end-1) cy2(1:end)];

% 轨迹要首尾相连
mapsize = length(mpx) - 1;% 最后一点与第一点重合，故不计
end

function [mpx, mpy,mapsize] = map2()

[lx1,ly1] = genLine(-20,0,20,0);
[cx1,cy1] = genCircle(20,-20,20,pi/2,0);
[cx2,cy2] = genCircle(30,-20,10,0,-pi);
[cx3,cy3] = genCircle(10,-20,10,0,pi);
[cx4,cy4] = genCircle(-20,-20,20,0,-3*pi/2);

% [lx2,ly2] = genLine(20,-20,-20,-20);
% [cx2,cy2] = genCircle(-20,-10,10,-pi/2,-3*pi/2);
% 去除端点重合的点
mpx = [lx1(1:end-1) cx1(1:end-1) cx2(1:end-1) cx3(1:end-1) cx4(1:end)];
mpy = [ly1(1:end-1) cy1(1:end-1) cy2(1:end-1) cy3(1:end-1) cy4(1:end)];

% 轨迹要首尾相连
mapsize = length(mpx) - 1;% 最后一点与第一点重合，故不计
end



function [lx,ly] = genLine(x1,y1,x2,y2,sampleRate)
% generate lines
if nargin<5
    sampleRate = 0.1;
end
samples = max([ceil(abs(x1-x2)/sampleRate)  ceil(abs(y1-y2)/sampleRate)]);
lx = linspace(x1, x2, samples);
ly = linspace(y1, y2, samples);
end

function [cx,cy] = genCircle(x,y,r,t1,t2,sampleRate)
% generate circles
if nargin < 6
    sampleRate = 0.1;
end

t = linspace(t1, t2,ceil(abs(t1-t2)*r/sampleRate));

cx = x + r * cos(t);
cy = y + r * sin(t);
end




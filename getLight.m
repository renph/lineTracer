function [light ] = getLight(dummy)
% 查找轨迹与光线传感器的最小距离，将距离区间[0,4]映射到[30,70]
global mpx mpy mapsize sensorX sensorY
persistent closest

% 计算传感器与地图第i个点距离的函数
foffset = @(id)(sensorX-mpx(id))^2+(sensorY-mpy(id))^2;
% 初始化
if nargout == 0
    % 查找与传感器最近的点在mpx与mpy中的序号
    minDis = foffset(mapsize);
    closest = mapsize;
    for ii=1:mapsize-1
        if foffset(ii)<minDis
            minDis = foffset(ii);
            closest = ii;
        end
    end
    return
end

% 向后查找最近的点
inc=0;
minDis = foffset(closest);
while 1
    idx=mod(closest+inc,mapsize)+1;
    tempdis = foffset(idx);
    if tempdis > minDis
        closest = mod(closest+inc-1,mapsize)+1;
        break;
    else
        minDis = tempdis;
        inc = inc+1;
    end
end
% 若向后查找没有结果，则向前查找
if inc < 1
    inc=-1;
    while 1
        idx=mod(closest+inc,mapsize)+1;
        tempdis = foffset(idx);
        if tempdis > minDis
            closest = mod(closest+inc-1,mapsize)+1;
            break;
        else
            minDis = tempdis;
            inc = inc-1;
        end
    end
end
% 数值处理
if minDis > 4
    light = 70;
else
    light = 30+20*sqrt(minDis);
end
end


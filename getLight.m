function [light,minDis ] = getLight()
% 查找轨迹与光线传感器的最小距离，将距离区间[0,4]映射到[30,70]
global mpx mpy sensorX sensorY

% 计算传感器与地图所有点的距离
% foffset = (mpx-sensorX).^2+(mpy-sensorY).^2;
foffset = (sensorX-mpx).^2+(sensorY-mpy).^2;
minDis = min(foffset);

% 数值处理
if minDis > 4
    light = 70;
else
    light = 30+20*sqrt(minDis);
end
end

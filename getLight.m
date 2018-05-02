function [light,minDis ] = getLight()
% ���ҹ켣����ߴ���������С���룬����������[0,4]ӳ�䵽[30,70]
global mpx mpy sensorX sensorY

% ���㴫�������ͼ���е�ľ���
% foffset = (mpx-sensorX).^2+(mpy-sensorY).^2;
foffset = (sensorX-mpx).^2+(sensorY-mpy).^2;
minDis = min(foffset);

% ��ֵ����
if minDis > 4
    light = 70;
else
    light = 30+20*sqrt(minDis);
end
end

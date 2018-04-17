function [light ] = getLight(dummy)
% ���ҹ켣����ߴ���������С���룬����������[0,4]ӳ�䵽[30,70]
global mpx mpy mapsize sensorX sensorY
persistent closest

% ���㴫�������ͼ��i�������ĺ���
foffset = @(id)(sensorX-mpx(id))^2+(sensorY-mpy(id))^2;
% ��ʼ��
if nargout == 0
    % �����봫��������ĵ���mpx��mpy�е����
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

% ����������ĵ�
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
% ��������û�н��������ǰ����
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
% ��ֵ����
if minDis > 4
    light = 70;
else
    light = 30+20*sqrt(minDis);
end
end


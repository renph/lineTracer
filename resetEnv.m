function resetEnv()
% reset simulator environment

global mpx mpy mapsize
global posX posY th 
global wheelD wheelW wheelDis sensorDis

% 生成地图
[mpx,mpy,mapsize] = mapGen();

% 小车参数
wheelD = 5.6;%轮子直径
wheelW = 2;%轮宽
wheelDis = 13;%两轮间距
sensorDis = 6.5;%传感器与车轴中心的距离

% 小车初始化
posX = 0;
posY = -1;
th =0;%小车航向角 以x轴为正向,单位rad
updatePos(0,0,0);% 计算传感器的位置

end
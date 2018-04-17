close all

%% sim setting
FPS = 60;
steps=1500;% 仿真步数
dt = 0.07; % 仿真步长，单位:s，依据控制频率调整
method = 'pid'% 设定控制方法，可选bangbang,pid,fuzzy,nn其中之一
%% sim initilize
resetEnv();% 重设仿真环境
animCar(25);% 设定轨迹数据缓冲区大小
controller(method);
%% sim
tStart = tic;
tElapsed = tStart;
frame = 0;

while 1
    tCur = toc(tStart);
    dt = tCur - tElapsed;
    if tCur > 10
        break
    end
    
    
    
    if tCur > frame/FPS
        frame = frame +1;
        % 绘制车体与轨迹
        animCar();
    end
    for ii=1:steps
        light = getLight();
        [vL, vR] = controller(light-50);
        % 更新小车位置信息
        updatePos(vL,vR,dt);
        
    end
end
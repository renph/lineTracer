close all

%% sim setting
simTime = 10;% 秒，仿真时长
FPS = 30;
dt = 0.07; % 秒，控制周期（采样周期）
method = 'fuzzy';% 设定控制方法，可选bangbang,pid,fuzzy,nn 其中之一
%% sim initilize
resetEnv();% 重设仿真环境
animCar(200);% 设定轨迹数据缓冲区大小
controller(method);
%% sim
tStart = tic;
tElapsed = 0;
frame = 0;

while 1
    tCur = toc(tStart);
    
    if tCur > simTime
        break
    end
    
    if tCur > frame / FPS
        % 绘制车体与轨迹
        animCar();
        frame = frame +1;
    end
    dt = tCur - tElapsed;
    light = getLight();
    [vL, vR] = controller(light-50);
    % 更新小车位置信息
    updatePos(vL,vR,(dt));
    tElapsed = tCur;
end
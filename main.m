close all

%% sim setting
simTime = 100;% 秒，仿真时长
dt = 0.07; % 秒，控制周期（采样周期）
method = 'pid';% 设定控制方法，可选bangbang,pid,fuzzy,nn 其中之一
%% sim initilize
resetEnv();% 重设仿真环境
animCar(100);% 设定轨迹数据缓冲区大小为100
controller(method);
%% simulation
for ii = 1:ceil(simTime/dt)
    light = getLight();
    [vL, vR] = controller(light-50);
    updatePos(vL,vR,(dt));% 更新小车位置信息
    animCar();% 绘制车体与轨迹
%     pause(0.02) % slow down the animation
end
load handel;
player = audioplayer(y, Fs); 
play(player);
close all

%% sim setting
simTime = 100;% �룬����ʱ��
dt = 0.07; % �룬�������ڣ��������ڣ�
method = 'pid';% �趨���Ʒ�������ѡbangbang,pid,fuzzy,nn ����֮һ
%% sim initilize
resetEnv();% ������滷��
animCar(100);% �趨�켣���ݻ�������СΪ100
controller(method);
%% simulation
for ii = 1:ceil(simTime/dt)
    light = getLight();
    [vL, vR] = controller(light-50);
    updatePos(vL,vR,(dt));% ����С��λ����Ϣ
    animCar();% ���Ƴ�����켣
%     pause(0.02) % slow down the animation
end
load handel;
player = audioplayer(y, Fs); 
play(player);
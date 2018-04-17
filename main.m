close all

%% sim setting
FPS = 60;
steps=1500;% ���沽��
dt = 0.07; % ���沽������λ:s�����ݿ���Ƶ�ʵ���
method = 'pid'% �趨���Ʒ�������ѡbangbang,pid,fuzzy,nn����֮һ
%% sim initilize
resetEnv();% ������滷��
animCar(25);% �趨�켣���ݻ�������С
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
        % ���Ƴ�����켣
        animCar();
    end
    for ii=1:steps
        light = getLight();
        [vL, vR] = controller(light-50);
        % ����С��λ����Ϣ
        updatePos(vL,vR,dt);
        
    end
end
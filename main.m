close all

%% sim setting
simTime = 10;% �룬����ʱ��
FPS = 30;
dt = 0.07; % �룬�������ڣ��������ڣ�
method = 'fuzzy';% �趨���Ʒ�������ѡbangbang,pid,fuzzy,nn ����֮һ
%% sim initilize
resetEnv();% ������滷��
animCar(200);% �趨�켣���ݻ�������С
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
        % ���Ƴ�����켣
        animCar();
        frame = frame +1;
    end
    dt = tCur - tElapsed;
    light = getLight();
    [vL, vR] = controller(light-50);
    % ����С��λ����Ϣ
    updatePos(vL,vR,(dt));
    tElapsed = tCur;
end
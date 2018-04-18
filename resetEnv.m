function resetEnv()
% reset simulator environment

global mpx mpy mapsize
global posX posY th 
global wheelD wheelW wheelDis sensorDis

% ���ɵ�ͼ
[mpx,mpy,mapsize] = mapGen();

% С������
wheelD = 5.6;%����ֱ��
wheelW = 2;%�ֿ�
wheelDis = 13;%���ּ��
sensorDis = 6.5;%�������복�����ĵľ���

% С����ʼ��
posX = 0;
posY = -1;
th =0;%С������� ��x��Ϊ����,��λrad
updatePos(0,0,0);% ���㴫������λ��

end
function updatePos(vL,vR,dt)
% ����С��λ����̬
global posX posY th sensorX sensorY 
global wheelDis sensorDis

theta = (vR-vL) / wheelDis * dt;% ת���ĽǶȣ�Բ�Ľ�
v_base =  (vL+vR)/2;
ratio = abs(sqrt((1-cos(theta))*2)/theta);  %Բ�ĽǶ�Ӧ���ҳ��뻡��֮��
if isnan(ratio)
    ratio = 1;
end
posX = posX+ ratio * v_base * dt * cos(th+theta/2);
posY = posY+ ratio * v_base * dt * sin(th+theta/2);
th = th + theta;
sensorX = posX+sensorDis*cos(th);
sensorY = posY+sensorDis*sin(th);
end


function updatePos(vL,vR,dt)
% 更新小车位置姿态
global posX posY th sensorX sensorY 
global wheelDis sensorDis

theta = (vR-vL) / wheelDis * dt;% 转过的角度，圆心角
v_base =  (vL+vR)/2;
ratio = abs(sqrt((1-cos(theta))*2)/theta);  %圆心角对应的弦长与弧长之比
if isnan(ratio)
    ratio = 1;
end
posX = posX+ ratio * v_base * dt * cos(th+theta/2);
posY = posY+ ratio * v_base * dt * sin(th+theta/2);
th = th + theta;
sensorX = posX+sensorDis*cos(th);
sensorY = posY+sensorDis*sin(th);
end


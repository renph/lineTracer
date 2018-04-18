function  animCar(nRec)
global posX posY th sensorX sensorY
global wheelD wheelW wheelDis
global mpx mpy AxesH Fig

body=rectCord(posX, posY, th,wheelDis,1.4*wheelD);
wheelL = rectCord(posX + wheelDis/2*sin(th), posY-wheelDis/2*cos(th) , th,wheelW,wheelD);
wheelR = rectCord(posX - wheelDis/2*sin(th), posY+wheelDis/2*cos(th) , th,wheelW,wheelD);

if nargin > 0
    
    Fig = figure(...
        'Name',            'map',...
        'NumberTitle',     'off',...
        'IntegerHandle',   'off');
    AxesH = axes(...
        'Parent',  Fig,...        
        'Xlim',    [-40 40],...
        'Ylim',    [-40 10],...
        'XGrid',   'on',...
        'YGrid',   'on',...
        'DataAspectRatio', [1 1 1],...
        'Visible', 'on');
    set(gcf,'outerposition',get(0,'screensize'));% 设置窗口大小
    % 绘制地图
    line(AxesH, mpx,mpy,'linewidth',20,'color',[1 1 0.7]);
    drawCar(body, wheelL ,wheelR,AxesH);
    drawSensor(sensorX,sensorY,AxesH);
    drawTrace(sensorX,sensorY,AxesH,nRec);
    posDisp(AxesH);
    drawnow
    return
end

posDisp();
drawCar(body, wheelL ,wheelR);
drawSensor(sensorX,sensorY);
drawTrace(sensorX,sensorY);
drawnow limitrate
end

function  posDisp(AxesH)
global posX posY th
persistent textH

str = {sprintf('X,Y = %3.1f, %3.1f',posX,posY),...
    sprintf(' theta = %3.1f  ',- mod(180-th/pi*180,360)+180)};

if nargin>0
    textH = text(AxesH,'Position',[30 5 0 ]);
end

set(textH,'String',str);
end

function [ p ] = rectCord( x, y, theta,width, length )
% 计算长方形四个顶点位置
r = (width^2/4 + length^2/4)^(1/2);
th = atan(width/length);
p1x = r*cos(theta + th);
p1y = r*sin(theta + th);
p2x = r*cos(theta - th);
p2y = r*sin(theta - th);

p = [x+p1x y+p1y;
    x+p2x y+p2y;
    x-p1x y-p1y;
    x-p2x y-p2y;
    ];
end

function  drawCar(body, wheelL ,wheelR,AxesH)
persistent carH
if nargin>3
    S.Parent = AxesH;
    S.Vertices = [body; wheelL ;wheelR];
    S.Faces = [1 2 3 4;5 6 7 8;9 10 11 12];
    S.FaceVertexCData = [0; 1;0.5];
    S.FaceColor = 'flat';
    S.EdgeColor = 'none';
    S.LineWidth = 2;
    carH = patch(S);
end
set(carH,'Vertices',[body; wheelL ;wheelR]);
end

function  drawSensor(sensorX,sensorY,AxesH)
persistent sensorH c s

if nargin>2
    t=linspace(0,2*pi,20);
    c = cos(t);
    s = sin(t);
    sensorH = line(AxesH,sensorX+c,sensorY+s ,'color','r');
end

set(sensorH,'XData',sensorX+c,'YData',sensorY+s);
end

function  drawTrace(sensorX,sensorY,AxesH,nrec)
persistent  traceH 

if nargin>2
    traceH = animatedline(AxesH,'Color',[0 0 1],'MaximumNumPoints',nrec);
end

addpoints(traceH,sensorX,sensorY);

end
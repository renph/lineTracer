function figs()
clc;close all
resetEnv();
global figpath figfmt
figpath = 'D:\Kivy\Desktop\lego\report\fig\';
figfmt = 'pdf';
% fig1()
fig2()
% fig3();
end
function fig3()
Fig = figure(...
    'Units',           'pixels',...
    'Name',            'move',...
    'NumberTitle',     'off',...
    'IntegerHandle',   'off');
AxesH = axes(...
    'Parent',  Fig,...
    'Xlim',    [-10 50],...
    'Ylim',    [-10 40],...
    'XGrid',   'off',...
    'YGrid',   'off',...
    'DataAspectRatio', [1 1 1],...
    'Visible', 'off');
%     set(gcf,'outerposition',get(0,'screensize'));% 设置窗口大小
drawCircle(AxesH,0,0,3)
% global figpath figfmt
% saveas(Fig,[figpath Fig.Name],figfmt)
end
function fig2()
Fig = figure(...
    'Units',           'pixels',...
    'Name',            'move2',...
    'NumberTitle',     'off',...
    'IntegerHandle',   'off');
AxesH = axes(...
    'Parent',  Fig,...
    'Xlim',    [-10 50],...
    'Ylim',    [-10 40],...
    'XGrid',   'on',...
    'YGrid',   'on',...
    'DataAspectRatio', [1 1 1],...
    'Visible', 'on');
%     set(gcf,'outerposition',get(0,'screensize'));% 设置窗口大小
t = linspace(0,45,101)*pi/180;
x = 40*cos(t);
y = 40*sin(t);
realtrace = line(AxesH,x , y,'linewidth',2);
line(AxesH,[x(1) 0  x(end)],[y(1) 0 y(end)],'color',[0.9 0.9 0.9],'linewidth',2,'linestyle','--');
precisetrace = line(AxesH,[x(1) x(end)] ,[y(1) y(end)],'color','g','linewidth',2,'linestyle','--');


setCar(x(1),y(1),pi/2);
drawCar(AxesH);

setCar(x(51),y(51),pi/2+pi/8);
drawCar(AxesH);


legend(AxesH,[realtrace,precisetrace],...
    '真实运动轨迹','精确模型的运动轨迹',...
    'location','northwest');

global  sensorDis
line(AxesH,[x(1) x(1)+sensorDis] ,[y(1) y(1)],'color','k','linewidth',1,'linestyle','--');
line(AxesH,[x(51) x(51)+sensorDis] ,[y(51) y(51)],'color','k','linewidth',1,'linestyle','--');

offx=0.5;
offy=1;
textfontsize = 10;
text(AxesH,x(1)+offx,y(1)+offy,'$\theta (t)$','fontsize',textfontsize,'Interpreter','latex')
text(AxesH,x(51)+offx,y(51)+offy,'$\theta (t) +\frac{\Delta \theta}{2}$','fontsize',textfontsize,'Interpreter','latex')

text(AxesH,1+offx,0+offy,'$\Delta \theta$','fontsize',textfontsize,'Interpreter','latex')
text(AxesH,x(1)-offx,y(1)-2*offy,'$A$','fontsize',textfontsize,'Interpreter','latex')
text(AxesH,x(end)+offx,y(end)+offy,'$B$','fontsize',textfontsize,'Interpreter','latex')

global figpath figfmt
saveas(Fig,[figpath Fig.Name],figfmt)
end
function fig1()
Fig = figure(...
    'Units',           'pixels',...
    'Name',            'move',...
    'NumberTitle',     'off',...
    'IntegerHandle',   'off');
AxesH = axes(...
    'Parent',  Fig,...
    'Xlim',    [-10 50],...
    'Ylim',    [-10 40],...
    'XGrid',   'on',...
    'YGrid',   'on',...
    'DataAspectRatio', [1 1 1],...
    'Visible', 'on');
%     set(gcf,'outerposition',get(0,'screensize'));% 设置窗口大小
t = linspace(0,45,101)*pi/180;
x = 40*cos(t);
y = 40*sin(t);
realtrace = line(AxesH,x , y,'linewidth',2);
line(AxesH,[x(1) 0  x(end)],[y(1) 0 y(end)],'color',[0.9 0.9 0.9],'linewidth',2,'linestyle','--');
precisetrace = line(AxesH,[x(1) x(end)] ,[y(1) y(end)],'color','g','linewidth',2,'linestyle','--');
simpletrace = line(AxesH,[x(1) x(1)] ,[y(1) pi/4*40],'color','y','linewidth',2,'linestyle',':');

setCar(x(1),y(1),pi/2);
drawCar(AxesH);

setCar(x(end),y(end),3/4*pi);
drawCar(AxesH);

setCar(x(1),y(1)+40*pi/4,3/4*pi);
drawCar(AxesH);

legend([realtrace,precisetrace,simpletrace],...
    '真实运动轨迹','精确模型的运动轨迹','简单模型的运动轨迹',...
    'location','northwest');

global  sensorDis
line(AxesH,[x(1) x(1)+sensorDis] ,[y(1) y(1)],'color','k','linewidth',1,'linestyle','--');
line(AxesH,[x(end) x(end)+sensorDis] ,[y(end) y(end)],'color','k','linewidth',1,'linestyle','--');

offx=0.5;
offy=1;
textfontsize = 10;
text(AxesH,x(1)+offx,y(1)+offy,'$\theta ( t)$','fontsize',textfontsize,'Interpreter','latex')
text(AxesH,x(end)+offx,y(end)+offy,'$\theta (t+\Delta t)$','fontsize',textfontsize,'Interpreter','latex')
global figpath figfmt
saveas(Fig,[figpath Fig.Name],figfmt)
end
function drawCircle(AxesH,cx,cy,r)
t=linspace(0,2*pi,30);
x = cx+r*cos(t);
y = cy+r*sin(t);

patch(AxesH,x,y,[1 1 1])
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

function  drawCar(AxesH)
global posX posY th sensorX sensorY
global wheelD wheelW wheelDis

body=rectCord(posX, posY, th,wheelDis,1.4*wheelD);
wheelL = rectCord(posX + wheelDis/2*sin(th), posY-wheelDis/2*cos(th) , th,wheelW,wheelD);
wheelR = rectCord(posX - wheelDis/2*sin(th), posY+wheelDis/2*cos(th) , th,wheelW,wheelD);

S.Parent = AxesH;
S.Vertices = [body; wheelL ;wheelR];
S.Faces = [1 2 3 4;5 6 7 8;9 10 11 12];
S.FaceVertexCData = [0; 1;0.5];
S.FaceColor = 'none';
S.FaceAlpha = 1;
S.EdgeColor = [0.1 0.1 0.1]*8;
S.LineWidth = 2;
patch(S);

line(AxesH,[posX sensorX],[posY sensorY], 'color','r','linestyle',':','linewidth',2);
end

function setCar(px,py,t)
global posX posY th 

posX = px;
posY = py;
th = t;
updatePos(0,0,0);

end
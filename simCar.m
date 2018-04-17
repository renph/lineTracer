function simCar(method)
% agv simulator
% gather training data for nerual network
close all
% default control method
if nargin<1,
    method = 'pid';
end

%% initialize
resetEnv();
controller(method);

%% simulator setting
steps=320;
dt = 0.1;% control interval 0.05s

% allocate memory for training data
% global errs dvs ii
errs = zeros(1,steps);
dvs = zeros(2,steps);
%%
% figure;
% h=line(gca);
for ii=1:steps
    light = getLight();
    [vL,vR] = controller(light-50);
    updatePos(vL,vR,dt);
    errs(ii)=light;
    dvs(:, ii)=[vL; vR];
%     set(h,'XData',errs(1:ii),'YData',dvs(1, 1:ii)-dvs(2, 1:ii));
end
save('traindata','errs','dvs');
disp('training data saved in file traindata.mat')

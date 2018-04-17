% network training

clc;clear

load('traindata.mat','errs','dvs')
datalength = length(errs);
x = zeros(2,datalength);
x(1,:)= errs;
x(2,2:end)= errs(1,1:end-1);
x = x(:, 2:end);
t =dvs(:,2:end);

x = (x-50);
% Create a Fitting Network
hiddenLayerSize = [20 10];
net = fitnet(hiddenLayerSize);
net.layers{1}.transferFcn='poslin';
net.layers{2}.transferFcn='poslin';

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows'};%,'mapminmax'
net.output.processFcns = {'removeconstantrows'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotwb'};

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
net.trainFcn = 'trainlm';
net.trainParam.max_fail = 0.1*datalength;
net.trainParam.epochs = 5000;
net.trainParam.goal = 1e-2;
net.trainParam.min_grad = 1e-6;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y)
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotconfusion(t,y)
%figure, plotroc(t,y)

% Deployment
if (testPerformance < 0.2)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'nnAppr','MatrixOnly','yes');

end

% save('net.mat','net')
% disp('net saved in net.mat')
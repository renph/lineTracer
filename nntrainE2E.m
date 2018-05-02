% training End to End network 

clc;clear

datalength = 1000;
% generate random error data ranging from -20 to 20
x = rand(1,datalength)*40-20;
x(2,2:end) = x(1:end-1);
t = zeros(2,datalength);
% gather target data by call function pidctrl
pidctrl();% initialize before called
for ii = 1:datalength
    [vL,vR] = pidctrl(x(1,ii));
    t(:,ii) = [vL;vR];
end

% Create a Fitting Network
hiddenLayerSize = [20 15];
net = fitnet(hiddenLayerSize);
net.layers{1}.transferFcn='poslin';
% net.layers{2}.transferFcn='poslin';

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
net.trainFcn = 'traingda';
net.trainParam.max_fail = datalength*0.05;
net.trainParam.epochs = 50000;
net.trainParam.goal = 1e-5;
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

% Deployment
if (testPerformance < 0.02)
    % Generate a matrix-only MATLAB function for neural network code
    % generation with MATLAB Coder tools.
    genFunction(net,'nnEnd2End','MatrixOnly','yes');

end


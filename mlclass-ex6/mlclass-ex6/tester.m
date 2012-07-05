
% Load from ex6data3: 
% You will have X, y in your environment
load('ex6data3.mat');

% Try different SVM Parameters here
%[C, sigma] = dataset3Params(X, y, Xval, yval);

C = [0.01;0.03;0.1;0.3;1;3;10;30];
sigma = .1;


for i=1:8

		% Train the SVM
		model= svmTrain(Xval, yval, C(i), @(x1, x2) gaussianKernel(x1, x2, sigma));
		visualizeBoundary(Xval, yval, model);

		fprintf('Program paused. Press enter to continue.\n');
		C(i)
		pause;

end


function [model, pred, accuracy, p] = trainSVM(class, features)

%%%%%%%%%%%%%%%%%%%%%%%%%%% SVM Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file contains code that will train an SVM model that will be used
%  to classify URLs, as to if they have the desired features of the sought
%  after site. It will reference known "good" and "bad" URLs for the training
%  and output a model, and the accuracy of that training.  It will call the
%  following functions:
%
%     extraction.m
%     svmpredict.o
%     svmtrain.o
%
%  This code will also call the following files:
%
%  /data/svmModel/model.binsev
%  /data/svmModel/pred.binsev
%  /data/svmModel/accuracy.binsev
%  /data/svmModel/p.binsev
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n===================Training Linear SVM for Site Classification===================\n')
fprintf('(this may take a bit)\n')


% TODO: REMOVE OLD CODE
%[class, dictionary_words, dictionary_pairs, features, urls] = extraction(regenModel);
tic

%%%%%%%%%%%%
% The last string argument tells LIBSVM to train using the options
% -s 0, SVM classification
% -t 0, a linear kernel, because we want a linear decision boundary
% -c 1, a cost factor of 10 (this is up for debate/modification)
%%%%%%%%%%%%

model = svmtrain(class', features','-s 0 -t 0 -c 10');

tlv = rand(size(features',1),1);
[pred, accuracy, p] = svmpredict(tlv, features', model);

% TODO: 2/2/2014 -> commented out for test. Figure out and uncomment.
fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

fprintf('\n');
toc


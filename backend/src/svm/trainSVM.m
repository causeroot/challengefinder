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


addpath(regexprep(pwd,'/src/\w*','/src/featureGeneration'));
addpath(regexprep(pwd,'/src/\w*','/src/termExtraction'));
addpath(regexprep(pwd,'/src/\w*','/src/siteRetrieval'));
addpath(regexprep(pwd,'/src/\w*','/src/svm'));
addpath(regexprep(pwd,'/src/\w*','/libsvm-3.17/matlab'));

pathFeatures = regexprep(pwd,'/src/\w*','/data/features');
pathUrlTerms = regexprep(pwd,'/src/\w*','/data/urlTerms');
pathRawSiteData = regexprep(pwd,'/src/\w*','/data/rawSiteData');
pathModel = regexprep(pwd,'/src/\w*','/data/svmModel');

modelFile = regexprep(pwd,'/src/\w*','/data/svmModel/model.binsev');
predFile = regexprep(pwd,'/src/\w*','/data/svmModel/pred.binsev');
accuracyFile = regexprep(pwd,'/src/\w*','/data/svmModel/accuracy.binsev');
pFile = regexprep(pwd,'/src/\w*','/data/svmModel/p.binsev');

% TODO: Write in a clause here where svmTrain


%if regenModel == 1;
    fprintf('\n===================Training Linear SVM for Site Classification===================\n')
    fprintf('(this may take a bit)\n')

    %[class, dictionary_words, dictionary_pairs, features, urls] = extraction(regenModel);
    tic

    C = 0.1;

    model = svmtrain(class', features');

    tlv = rand(size(features',1),1);
    [pred, accuracy, p] = svmpredict(tlv, features', model);

    fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

    fprintf('\n');
    toc

%    tic
%    fprintf('\n\nSaving Dictionary Files: \n')
%    save("-mat7-binary", modelFile, "model")
%    fprintf('\n     Successful Save to model.binsev');
%    save("-mat7-binary", predFile, "pred")
%    fprintf('\n     Successful Save to pred.binsev');
%    save("-mat7-binary", accuracyFile, "accuracy")
%    fprintf('\n     Successful Save to accuracy.binsev');
%    save("-mat7-binary", pFile, "p")
%    fprintf('\n     Successful Save to p.binsev\n');
%    toc

% elseif regenModel == 0
%    fprintf('\nModel Files Loaded: ');
%     load("-v7",modelFile,"model")
%     fprintf('\n     Successful Load from model.binsev');
%     load("-v7",predFile, "pred")
%     fprintf('\n     Successful Load from pred.binsev');
%     load("-v7",accuracyFile, "accuracy")
%     fprintf('\n     Successful Load from accuracy.binsev');
%     load("-v7",pFile, "p")
%     fprintf('\n     Successful Load from p.binsev\n');
% end

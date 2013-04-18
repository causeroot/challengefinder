function [model, pred, accuracy, p] = trainSVM(regenModel = 0)

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


addpath(strrep(pwd, "/src/svm", "/src/featureGeneration"));
addpath(strrep(pwd, "/src/svm", "/src/termExtraction"));
addpath(strrep(pwd, "/src/svm", "/src/siteRetrieval"));
addpath(strcat(pwd, "/svm"));

pathFeatures = strrep(pwd, "/src/svm", "/data/features");
pathUrlTerms = strrep(pwd, "/src/svm", "/data/urlTerms");
pathRawSiteData = strrep(pwd, "/src/svm", "/data/rawSiteData");
pathModel = strrep(pwd, "/src/svm", "/data/svmModel");

modelFile = strrep(pwd, "/src/svm", "/data/svmModel/model.binsev");
predFile = strrep(pwd, "/src/svm", "/data/svmModel/pred.binsev");
accuracyFile = strrep(pwd, "/src/svm", "/data/svmModel/accuracy.binsev");
pFile = strrep(pwd, "/src/svm", "/data/svmModel/p.binsev");

if regenModel == 1;
    fprintf('\n===================Training Linear SVM for Site Classification===================\n')
    fprintf('(this may take a bit)\n')

    [class, dictionary_words, dictionary_pairs, features, urls] = extraction(regenModel);
    tic

    C = 0.1;

    model = svmtrain(class', features');

    tlv = rand(size(features',1),1);
    [pred, accuracy, p] = svmpredict(tlv, features', model);

    fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

    fprintf('\n');
    toc

    tic
    fprintf('\n\nSaving Dictionary Files: \n')
    save("-mat7-binary", modelFile, "model")
    fprintf('\n     Successful Save to model.binsev');
    save("-mat7-binary", predFile, "pred")
    fprintf('\n     Successful Save to pred.binsev');
    save("-mat7-binary", accuracyFile, "accuracy")
    fprintf('\n     Successful Save to accuracy.binsev');
    save("-mat7-binary", pFile, "p")
    fprintf('\n     Successful Save to p.binsev\n');
    toc

 elseif regenModel == 0
    fprintf('\nModel Files Loaded: ');
     load("-v7",modelFile,"model")
     fprintf('\n     Successful Load from model.binsev');
     load("-v7",predFile, "pred")
     fprintf('\n     Successful Load from pred.binsev');
     load("-v7",accuracyFile, "accuracy")
     fprintf('\n     Successful Load from accuracy.binsev');
     load("-v7",pFile, "p")
     fprintf('\n     Successful Load from p.binsev\n');
 end
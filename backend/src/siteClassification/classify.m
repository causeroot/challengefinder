function classify()

%%%%%%%%%%%%%%%%%%%%%% Website Classification with SVMs %%%%%%%%%%%%%%%%
%
%  This file contains code that will allow the user to classify URLs
%  as belonging to a particular class based upon word, word pair, and
%  word frequencies.  The following files will be used by this file:
%
%     svmpredict.o
%     extract_data_2.m
%
%  This code will evaluate the site data for an evaluation file, and output
%  a file containing the URL names and the fitness criteria for that analysis.
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
dictionaryWordsFile = regexprep(pwd,'/src/\w*','/data/urlTerms/dictionary_words_file.binsev');
dictionaryPairsFile = regexprep(pwd,'/src/\w*','/data/urlTerms/dictionary_pairs_file.binsev');

eval_file = regexprep(pwd,'/src/\w*','/data/rawSiteData/toEvaluate/URLs_4.url.out');
eval_output_file = regexprep(pwd,'/src/\w*','/data/fitness/evalout.txt');

fprintf('\nFiles Loaded: ');
load("-v7",modelFile,"model")
fprintf('\n     Successful Load from model.binsev');
load("-v7",dictionaryWordsFile, "dictionary_words")
fprintf('\n     Successful Load from dictionary_words_file.binsev');
load("-v7",dictionaryPairsFile, "dictionary_pairs")
fprintf('\n     Successful Load from dictionary_pairs_file.binsev\n');

[eval_urls,eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs] = extract_data_2(eval_file, dictionary_words, dictionary_pairs);

f = vertcat(eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs);

fprintf('\n========================== Classifying New URLs ===========================\n');

tlv = ones(size(f',1),1);
[pred, accuracy, p] = svmpredict(tlv, f', model);

toc
fprintf('======================== Classifying New URLs Complete ===================\n\n');
fprintf('============================ Writing Output Files ========================\n');
fprintf('Processed %s URL Classification to %s\n', char(eval_file),char(eval_output_file));
fprintf('Number of (likely) new Challenges: %i\n', sum(pred));

tic
fileID = fopen(eval_output_file,'w');
for i = 1:size(eval_urls,1)
    fprintf(fileID,"%s",char(eval_urls(i)));
    fprintf(fileID," ");
    fprintf(fileID,"%6.4f  %d",p(i),pred(i));
    fprintf(fileID," \n");
end
fclose(fileID);
toc

fprintf('==========================================================================\n');
fprintf('=================================== DONE!!! ==============================\n');
fprintf('==========================================================================\n\n');
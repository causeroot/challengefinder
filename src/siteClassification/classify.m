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


addpath(strrep(pwd, "/src/siteClassification", "/src/featureGeneration"));
addpath(strrep(pwd, "/src/siteClassification", "/src/termExtraction"));
addpath(strrep(pwd, "/src/siteClassification", "/src/siteRetrieval"));

pathFeatures = strrep(pwd, "/src/siteClassification", "/data/features");
pathUrlTerms = strrep(pwd, "/src/siteClassification", "/data/urlTerms");
pathRawSiteData = strrep(pwd, "/src/siteClassification", "/data/rawSiteData");

eval_file = strrep(pwd, "/src/siteClassification", "/data/rawSiteData/toEvaluate/URLs_4.url.out");
eval_output_file = strrep(pwd, "/src/siteClassification", "/data/fitness/evalout.txt");

modelFile = strrep(pwd, "/src/siteClassification", "/data/svmModel/model.binsev");
dictionaryWordsFile = strrep(pwd, "/src/siteClassification", "/data/urlTerms/dictionary_words_file.binsev");
dictionaryPairsFile = strrep(pwd, "/src/siteClassification", "/data/urlTerms/dictionary_pairs_file.binsev");

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
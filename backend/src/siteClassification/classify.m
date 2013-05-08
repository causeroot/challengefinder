function  [eval_urls,p,pred] = classify(eval_file,model,dictionary_words, dictionary_pairs)

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

[eval_urls,eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs] = extract_data_2(eval_file, dictionary_words, dictionary_pairs);

f = vertcat(eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs);

fprintf('\n========================== Classifying New URLs ===========================\n');

tlv = ones(size(f',1),1);
[pred, accuracy, p] = svmpredict(tlv, f', model);
toc

fprintf('\n========================== Classification Complete ===========================\n\n');
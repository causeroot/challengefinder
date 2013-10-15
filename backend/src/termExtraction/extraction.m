function [class, dictionary_words, dictionary_pairs, features, urls] = extraction(good_file,bad_file)

%%%%%%%%%%%%%%%%%%%%%%%%%%% Feature Extraction %%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file contains code that will extract features from files containing urls
%  and the words in those URL's. It will call the following scripts:
%
%     dictionary_gen.m
%     extract_data_2.m
%
%  It will also call the following master files:
%
%  /data/features/dictionary_features_file.binsev
%  /data/features/dictionary_classes_file.binsev
%  /data/urlTerms/dictionary_words_file.binsev
%  /data/urlTerms/dictionary_pairs_file.binsev
%  /data/urlTerms/urls_file.binsev
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: Fix all the code comment subheadings to remove all the SPAM whatnots

fprintf('\n\n======================= Starting Site Classification ======================\n');
fprintf('\n')

fprintf('Prepared to Extract Data and Build Dictionary from "POSITIVE" Urls in File: ');
fprintf(good_file);
fprintf('\nPrepared to Extract Data and Build Dictionary from "NEGATIVE" Urls in File: ');
fprintf(bad_file);
fprintf('\n\n===========================================================================\n')

%% ==================== Part 1: Dictionary Generation ====================
%  The following is used to generate the dictionary of words and word pairs
%  that is used in the analysis.

[dictionary_words, dictionary_pairs] = dictionary_gen(good_file,bad_file);


%% ==================== Part 2: Feature Extraction ====================
%  The following is used to extract feature set

[u,dw,dp,fw,fp] = extract_data_2(good_file, dictionary_words, dictionary_pairs);


% TODO: Make this code less ... ugly ...
urls = u;
dataset_words = dw;
dataset_pairs = dp;
freq_words = fw;
freq_pairs = fp;

class = ones(1,size(u,1));

[u,dw,dp,fw,fp] = extract_data_2(bad_file, dictionary_words, dictionary_pairs);

class = horzcat(class, -1*ones(1, size(u,1)));

urls = vertcat(urls,u);
dataset_words = horzcat(dataset_words,dw);
dataset_pairs = horzcat(dataset_pairs,dp);
freq_words = horzcat(freq_words,fw);
freq_pairs = horzcat(freq_pairs,fp);

features = vertcat(dataset_words,dataset_pairs,freq_words,freq_pairs);

% PRINT STATISTICS
fprintf('Number of URLs in extracted dataset: ');
fprintf("%i",size(urls,1));
fprintf('\n');


fprintf('\n====================== Dictionary Complete and Loaded ===========================\n\n');


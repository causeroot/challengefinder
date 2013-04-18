
function [class, dictionary_words, dictionary_pairs, features, urls] = extraction(regen = 0)

% function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs] = extraction(regen = 0)
% function extraction(regen = 0)

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

addpath(strrep(pwd, "/src/termExtraction", "/src/featureGeneration"));
addpath(strrep(pwd, "/src/termExtraction", "/src/termExtraction"));
addpath(strrep(pwd, "/src/termExtraction", "/src/siteRetrieval"));
addpath(strrep(pwd, "/src/termExtraction", "/src/svm"));

pathFeatures = strrep(pwd, "/src/termExtraction", "/data/features");
pathUrlTerms = strrep(pwd, "/src/termExtraction", "/data/urlTerms");
pathRawSiteData = strrep(strrep(pwd, "/src/termExtraction", "/data/rawSiteData"), "/src/svm", "/data/rawSiteData");

eval_file = strrep(pwd, "/src/termExtraction", "/data/rawSiteData/toEvaluate/URLs_4.url.out");
eval_output_file = strrep(pwd, "/src/termExtraction", "/data/fitness/evalout.txt");
search_string_out_file = strrep(pwd, "/src/termExtraction", "/data/searchTerms/new_sstrings.txt");

featuresFile = strrep(pwd, "/src/termExtraction", "/data/features/dictionary_features_file.binsev");
classFile = strrep(pwd, "/src/termExtraction", "/data/features/dictionary_classes_file.binsev");
dictionaryWordsFile = strrep(pwd, "/src/termExtraction", "/data/urlTerms/dictionary_words_file.binsev");
dictionaryPairsFile = strrep(pwd, "/src/termExtraction", "/data/urlTerms/dictionary_pairs_file.binsev");
urlsFile = strrep(pwd, "/src/termExtraction", "/data/urlTerms/urls_file.binsev");

%TODO: %%%% ERROR HANDLING %%%%%%%%%
good_file = strcat(pathRawSiteData,'/goodBucket/Good_Challenges_List.out');
% Change this to the bad file, to speed up the run
% bad_file = strcat(pathRawSiteData,'/goodBucket/Good_Challenges_List.out');
bad_file = strcat(pathRawSiteData,'/badBucket/random_url_word_list.txt');
% TODO: %%%%%%% remove " or ' %%%%%%%

% TODO: Fix all the code comment subheadings to remove all the SPAM whatnots

fprintf('\n\n======================= Starting Site Classification ======================\n');
fprintf('\n')

good_file = '';
bad_file = '';

tic
if regen == 0
    tic
    fprintf('\nDictionary Files Loaded: ');
    load("-v7",featuresFile,"features")
    fprintf('\n     Successful Load from dictionary_features_file.binsev');
    load("-v7",classFile, "class")
    fprintf('\n     Successful Load from dictionary_classes_file.binsev');
    load("-v7",dictionaryWordsFile, "dictionary_words")
    fprintf('\n     Successful Load from dictionary_words_file.binsev');
    load("-v7",dictionaryPairsFile, "dictionary_pairs")
    fprintf('\n     Successful Load from dictionary_pairs_file.binsev');
    load("-v7",urlsFile, "urls")
    fprintf('\n     Successful Load from urls_file.binsev\n');
    toc

elseif regen == 1

    fprintf('\n');

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

    urls = u;
    dataset_words = dw;
    dataset_pairs = dp;
    freq_words = fw;
    freq_pairs = fp;

    class = ones(1,size(u,1));

    [u,dw,dp,fw,fp] = extract_data_2(bad_file, dictionary_words, dictionary_pairs);


    class = horzcat(class, zeros(1, size(u,1)));

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

    tic
    fprintf('\n\nSaving Dictionary Files: \n')
    save("-mat7-binary", classFile, "class")
    fprintf('\n     Successful Save to dictionary_classes_file.binsev');
    save("-mat7-binary", dictionaryWordsFile, "dictionary_words")
    fprintf('\n     Successful Save to dictionary_words_file.binsev');
    save("-mat7-binary", dictionaryPairsFile, "dictionary_pairs")
    fprintf('\n     Successful Save to dictionary_pairs_file.binsev');
    save("-mat7-binary", featuresFile, "features")
    fprintf('\n     Successful Save to dictionary_features_file.binsev\n');
    save("-mat7-binary", urlsFile, "urls")
    fprintf('\n     Successful Save to urls_file.binsev\n');
    toc
    pause;

end;

fprintf('\n====================== Dictionary Complete and Loaded ===========================\n\n');

% TEST POINT: Uncomment to Pause Here
% fprintf('Program paused. Press enter to continue actively training the SVM Model.\n');
% pause;

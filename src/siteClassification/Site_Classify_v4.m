function Site_Classify_v4()

%%%%%%%%%%%%%%%%%%%%%% Website Classification with SVMs %%%%%%%%%%%%%%%%
%
%  This file contains code that will allow the user to classify URLs
%  as belonging to a particular class based upon word, word pair, and
%  word frequencies.  The following files will be used by this file:
%
%     TODO: UPDATE THE FILES BELOW
%     gaussianKernel.m
%     dataset3Params.m  ?????
%     dictionary_gen.m
%     extract_data_2.m
%     SVM_URL_Predict.m
%     svmTrain.m
%     svmPredict.m
%     readFile.m
%
%  This code will evaluate the site data for an evaluation file, and output
%  a file containing the URL names and the fitness criteria for that analysis,
%  as well as the search string parameters output from the data evaluation.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Add the required paths for the file functions and files in question %%%%%%%%%%%

addpath(strrep(pwd, "/src/siteClassification", "/src/featureGeneration"));
addpath(strrep(pwd, "/src/siteClassification", "/src/termExtraction"));
addpath(strrep(pwd, "/src/siteClassification", "/src/siteRetrieval"));
addpath(strcat(pwd, "/svm"));

pathFeatures = strrep(pwd, "/src/siteClassification", "/data/features");
pathUrlTerms = strrep(pwd, "/src/siteClassification", "/data/urlTerms");
pathRawSiteData = strrep(pwd, "/src/siteClassification", "/data/rawSiteData");

eval_file = strrep(pwd, "/src/siteClassification", "/data/rawSiteData/toEvaluate/URLs_4.url.out");
eval_output_file = strrep(pwd, "/src/siteClassification", "/data/fitness/evalout.txt");
search_string_out_file = strrep(pwd, "/src/siteClassification", "/data/searchTerms/new_sstrings.txt");

featuresFile = strrep(pwd, "/src/siteClassification", "/data/features/dictionary_features_file.binsev");
classFile = strrep(pwd, "/src/siteClassification", "/data/features/dictionary_classes_file.binsev");
dictionaryWordsFile = strrep(pwd, "/src/siteClassification", "/data/urlTerms/dictionary_words_file.binsev");
dictionaryPairsFile = strrep(pwd, "/src/siteClassification", "/data/urlTerms/dictionary_pairs_file.binsev");

% TODO: Fix all the code comment subheadings to remove all the SPAM whatnots

fprintf('\n\n======================= Starting Site Classification ======================\n');
fprintf('\n')

fprintf('Welcome to Site Classification!!! Press ENTER to start Classifying the Sites:\n\n');
pause;

good_file = '';
bad_file = '';

prmpt = yes_or_no('Do you want to generate a whole new Dicitonary?: ');
tic
if prmpt == 0
    tic
    fprintf('\nDictionary Files Loaded: ');
    load("-v7",featuresFile,"features")
    fprintf('\n     Successful Load from dictionary_features_file.binsev');
    load("-v7",classFile, "class")
    fprintf('\n     Successful Load from dictionary_classes_file.binsev');
    load("-v7",dictionaryWordsFile, "dictionary_words")
    fprintf('\n     Successful Load from dictionary_words_file.binsev');
    load("-v7",dictionaryPairsFile, "dictionary_pairs")
    fprintf('\n     Successful Load from dictionary_pairs_file.binsev\n');

    toc
    
elseif prmpt == 1
    
    fprintf('\n');
    %TODO: %%%% ERROR HANDLING %%%%%%%%%

    good_file = strcat(pathRawSiteData,'/goodBucket/Good_Challenges_List.out')
    %Change this to the bad file, to speed up the run
    %bad_file = strcat(pathRawSiteData,'/goodBucket/Good_Challenges_List.out')
    bad_file = strcat(pathRawSiteData,'/badBucket/random_url_word_list.txt')

    % TODO: %%%%%%% remove " or ' %%%%%%%

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
    toc
    pause;  
    
end

fprintf('\n====================== Dictionary Complete and Loaded ===========================\n\n');

% TEST POINT: Uncomment to Pause Here
% fprintf('Program paused. Press enter to continue actively training the SVM Model.\n');
% pause;


%% =========== Part 3: Train Linear SVM for File Classification ========
%  In this section, you will train a linear classifier to determine how
%  well a website fits the search criteria.

fprintf('\n===================Training Linear SVM for Site Classification===================\n')
fprintf('(this may take a bit)\n')
tic

C = 0.1;

model = svmtrain(class', features');

tlv = rand(size(features',1),1); 
[pred, accuracy, p] = svmpredict(tlv, features', model);

fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

fprintf('\n');
toc

%% =================== Part 4: Test Classification ================
%  After training the classifier, we can evaluate it on a test set. We have
%  included a test set in spamTest.mat

% TODO: Input Test either here or make sure that its being thrown in Jenkins

%% ================= Part 5: Top Predictors of a Good Challenge URL ====================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier 'thinks'
%  that these words are the most likely indicators of a good challenge URL.

model_w = ((model.sv_coef)'*(model.SVs))';

[weight, id] = sort(model_w, 'descend');

thresh = 0.018;
pos_word = '';
neg_word = '';
parm = '';
insert = {''};

neg = weight<0;

new_strs = horzcat(id, neg, abs(weight));
new_strings = sortrows(new_strs,3);

idx = new_strings(:,1);
negative_weights = new_strings(:,2);
weightx = new_strings(:,3);

num_distinctifiers = 30;
fprintf('\nTop predictors for applicable URLs: \n');

for i = 1:num_distinctifiers
    if negative_weights(length(idx)-i+1)==1
        insert = {'-'};
    end
    if idx(length(idx)-i+1) < size(dictionary_words,1)+1
        parm = dictionary_words{idx(length(idx)-i+1)};
        fprintf('Word: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
        % Delete the above 2 lines to go back to add the Freq into the algorithm qualifiers
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)+size(dictionary_pairs,1)+1)
        parm = dictionary_pairs{idx(length(idx)-i+1)-size(dictionary_words,1)};
        fprintf('Pair: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
        % Delete the above 2 lines to go back to add the Freq into the algorithm qualifiers
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)+1)
        % parm = dictionary_words{idx(length(idx)-i+1)-(size(dictionary_words,1)+size(dictionary_pairs,1))};
        % fprintf('Word Freq: %-15s \t\t(%s%f) \n',parm, char(insert), weightx(length(idx)-i+1));
        % Add back in the above two lines to go back to add the Freq into the algorithm qualifiers  
        num_distinctifiers = num_distinctifiers +1;
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)*2+1)
        % parm = dictionary_pairs{idx(length(idx)-i+1)-(size(dictionary_words,1)*2+size(dictionary_pairs,1))};
        % fprintf('Pair Freq: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
        % Add back in the above two lines to go back to add the Freq into the algorithm qualifiers   
        num_distinctifiers = num_distinctifiers+1;
    end
    pos_word = strcat(pos_word,{'+'},insert,{'"'},parm,{'"'});
    insert = {''};
end
fprintf('\n=================================== SVM Training Complete ===================================\n')


%% ==================== Part 6: Classify New URLS ======================


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
fprintf('=========================== New URL Data Written =========================\n');
fprintf('Newly Search String Paramenters Written to: %s\n',char(search_string_out_file));
tic
pos_word = regexprep(pos_word,'_','+');
fileID2 = fopen(search_string_out_file,'w');
fprintf(fileID2,'%s',char(pos_word));
fclose(fileID2);
toc
fprintf('=============== Optimal Search String Parameter Data Written =============\n\n\n');
fprintf('==========================================================================\n');
fprintf('=================================== DONE!!! ==============================\n');
fprintf('==========================================================================\n\n');
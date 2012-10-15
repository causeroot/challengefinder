function Site_Classify_v4(eval_file,eval_output_file,search_string_out_file)

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
%     extract_data.m  ???? Update v2
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

% TODO: Fix all the code comment subheadings to remove all the SPAM whatnots

% OLD CODE:
%% Initialization
%% clear; close all; clc
%% done = ('Done!');

fprintf('\n\n======================= Starting Site Classification ======================\n');
fprintf('\n')

fprintf('Welcome to Site Classification!!! Press ENTER to start Classifying the Sites:\n\n');
pause;

% OLD CODE
% dictionary_features_file = 'dictionary_features_file.binsev';
% dictionary_class_file = 'dictionary_class_file.binsev';
% dictionary_words_file = 'dictionary_words_file.binsev';
% dictionary_pairs_file = 'dictionary_pairs_file.binsev';
% fileID_f = fopen(dictionary_features_file,'w');
% fileID_c = fopen(dictionary_class_file,'w');
% fileID_w = fopen(dictionary_words_file,'w');
% fileID_p = fopen(dictionary_pairs_file,'w');

good_file = '';
bad_file = '';

prmpt = yes_or_no('Do you want to generate a whole new Dicitonary?: ');
tic
if prmpt == 0
    tic
    fprintf('\nDictionary Files Successfully Loaded: ');
    load -v7 dictionary_features_file.binsev features;
    fprintf('\n     Successful Load from dictionary_features_file.binsev');
    load -v7 dictionary_classes_file.binsev class;
    fprintf('\n     Successful Load from dictionary_classes_file.binsev');
    load -v7 dictionary_words_file.binsev dictionary_words;
    fprintf('\n     Successful Load from dictionary_words_file.binsev');
    load -v7 dictionary_pairs_file.binsev dictionary_pairs;
    fprintf('\n     Successful Load from dictionary_pairs_file.binsev\n');
    
% OLD CODE: Not accurate display of file we are loading from    
%    
%    fprintf(dictionary_words_file);
%    fprintf('\n');
%    fprintf(dictionary_pairs_file);
%    fprintf('\n');
%    fprintf(dictionary_features_file);
%    fprintf('\n');
%    fprintf(dictionary_class_file);
%    fprintf('\n\n');
    toc
    
elseif prmpt == 1
    
    fprintf('\n');
    % TODO: %%%% ERROR HANDLING %%%%%%%%%
    good_file = input("Input Good Challenge File: ", "s");
    bad_file = input("Input Bad Challenge File: ", "s");
    % TODO: %%%%%%% remove " or ' %%%%%%%

    % TEST POINT: Uncomment to Pause Here
    % fprintf('\nProgram paused. Press enter to start the dictionary and feature extration.\n\n');
    % pause;

    % OLD CODE:
    %good_file = 'site_data.txt';
    %bad_file = 'site_data.txt';
    %eval_file = 'site_data.txt';
    %eval_output_file = 'output_data.txt';
    %search_string_out_file = 'search_string_out_file.txt';

    fprintf('Prepared to Extract Data and Build Dictionary from "POSITIVE" Urls in File: ');
    fprintf(good_file);
    fprintf('\nPrepared to Extract Data and Build Dictionary from "NEGATIVE" Urls in File: ');
    fprintf(bad_file);
    fprintf('\n\n===========================================================================\n')

    %% ==================== Part 1: Dictionary Generation ====================
    %  The following is used to generate the dictionary of words and word pairs
    %  that is used in the analysis.

    [dictionary_words, dictionary_pairs] = dictionary_gen(good_file,bad_file);
    % fprintf('\nDictionary Complete.\n\n');

    % TEST POINT: Uncomment to Pause Here
    % fprintf('Program paused. Press enter to continue actively extracting data.\n');
    % pause;

    %% ==================== Part 2: Feature Extraction ====================
    %  The following is used to extract feature set 

    [u,dw,dp,fw,fp] = extract_data_2(good_file, dictionary_words, dictionary_pairs);

    % TEST POINT: Uncomment to Pause Here
    % fprintf('Program paused. Press enter to continue actively extracting data.\n');
    % pause;

    urls = u;
    dataset_words = dw;
    dataset_pairs = dp;
    freq_words = fw;
    freq_pairs = fp;

    class = ones(1,size(u,1));

    [u,dw,dp,fw,fp] = extract_data_2(bad_file, dictionary_words, dictionary_pairs);

    % TEST POINT: Uncomment to Pause Here
    % fprintf('Program paused. Press enter to continue saving the extracted data.\n');
    % pause;
    
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
    save -mat7-binary dictionary_classes_file.binsev class
    fprintf('\n     Successful Save to dictionary_classes_file.binsev');
    save -mat7-binary dictionary_words_file.binsev dictionary_words
    fprintf('\n     Successful Save to dictionary_words_file.binsev');
    save -mat7-binary dictionary_pairs_file.binsev dictionary_pairs
    fprintf('\n     Successful Save to dictionary_pairs_file.binsev');
    save -mat7-binary dictionary_features_file.binsev features
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

% OLD COMMENTS:
% Load the Spam Email dataset
% You will have X, y in your environment
% load('spamTrain.mat');

fprintf('\n===================Training Linear SVM for Site Classification===================\n')
fprintf('(this may take a bit)\n')
tic

C = 0.1;

% OLD CODE:
%model = svmTrain(X, y, C, @linearKernel);
%model = svmTrain(features', class', C, @linearKernel);

model = svmtrain(class', features');

% OLD CODE:
%[pred, p] = SVM_URL_Predict(model, features');

tlv = rand(size(features',1),1); 
[pred, accuracy, p] = svmpredict(tlv, features', model);

fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

fprintf('\n');
toc

%% =================== Part 4: Test Spam Classification ================
%  After training the classifier, we can evaluate it on a test set. We have
%  included a test set in spamTest.mat

% OLD COMMENTS:
% Load the test dataset
% You will have Xtest, ytest in your environment
% load('spamTest.mat');

% OLD CODE:
%fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')
%p = svmPredict(model, Xtest);
%fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);
%pause;
%fprintf('\nEvaluating the Trained Linear SVM on a the new set of URLs in:');
%fprintf(eval_file);

%% ================= Part 5: Top Predictors of Spam ====================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier
%  'thinks' that these words are the most likely indicators of spam.


% OLD CODE:
%fprintf('\n\n');
% Sort the weights and obtin the vocabulary list
%fprintf('\nfeatures\n');
%size(features) 72582,63
%fprintf('\nclass\n');
%size(class) 1, 63
%fprintf('\sv_coef\n');
%size(model.sv_coef) 54,1
%fprintf('\SVs\n');
%size(model.SVs) 54, 72582
%model_w = ((model.sv_coef.*class')'*features')';
%model_w = ((model.sv_coef)'*(model.SVs))'.*(features*class');

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

% OLD CODE:
%num_distinctifiers = sum(weightx>thresh);

num_distinctifiers = 20;
fprintf('\nTop predictors for applicable URLs: \n');

for i = 1:num_distinctifiers
    if negative_weights(length(idx)-i+1)==1
        insert = {'-'};
    end
    if idx(length(idx)-i+1) < size(dictionary_words,1)+1
        parm = dictionary_words{idx(length(idx)-i+1)};
        fprintf('Word: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)+size(dictionary_pairs,1)+1)
        parm = dictionary_pairs{idx(length(idx)-i+1)-size(dictionary_words,1)};
        fprintf('Pair: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)+1)
        parm = dictionary_words{idx(length(idx)-i+1)-(size(dictionary_words,1)+size(dictionary_pairs,1))};
        fprintf('Word Freq: %-15s \t\t(%s%f) \n',parm, char(insert), weightx(length(idx)-i+1));    
    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)*2+1)
        parm = dictionary_pairs{idx(length(idx)-i+1)-(size(dictionary_words,1)*2+size(dictionary_pairs,1))};
        fprintf('Pair Freq: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
    end

    pos_word = strcat(pos_word,{'+'},insert,{'"'},parm,{'"'});
    insert = {''};
end
fprintf('\n=================================== SVM Training Complete ===================================\n')

% OLD CODE:
%fprintf('\n\nTop Negative predictors for applicable URLs: \n');
%parm = '';
%
%for i = 1:15
%     if idx(length(idx)-i+1) < size(dictionary_words,1)+1
%        parm = dictionary_words{idx(length(idx)-i+1)};
%        fprintf('Word: %-15s (%f) \n', parm, weight(length(idx)-i+1));
%    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)+size(dictionary_pairs,1)+1)
%        parm = dictionary_pairs{idx(length(idx)-i+1)-size(dictionary_words,1)};
%        fprintf('Pair: %-15s (%f) \n', parm, weight(length(idx)-i+1));
%    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)+1)
%        parm = dictionary_words{idx(length(idx)-i+1)-(size(dictionary_words,1)+size(dictionary_pairs,1))};
%        fprintf('Word Freq: %-15s (%f) \n',parm,weight(length(idx)-i+1));     
%    elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)*2+1)
%        parm = dictionary_pairs{idx(length(idx)-i+1)-(size(dictionary_words,1)*2+size(dictionary_pairs,1))};
%        fprintf('Pair Freq: %-15s (%f) \n', parm, weight(length(idx)-i+1));
%    end
%    neg_word = strcat(neg_word,{' '},parm);
%end

% TEST POINT: Uncomment to Pause Here
% fprintf('\n\nProgram paused. Press enter to continue and evaluate new URLS.\n');
% pause;


%% ==================== Part 6: Try Your Own Emails ======================
%  Now that you've trained the spam classifier, you can use it on your own
%  emails! In the starter code, we have included spamSample1.txt,
%  spamSample2.txt, emailSample1.txt and emailSample2.txt as examples. 
%  The following code reads in one of these emails and then uses your 
%  learned SVM classifier to determine whether the email is Spam or 
%  Not Spam



[eval_urls,eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs] = extract_data_2(eval_file, dictionary_words, dictionary_pairs);

f = vertcat(eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs);

fprintf('\n========================== Classifying New URLs ===========================\n');

% OLD CODE
%fprintf('(>0 indicates Good URL, <0 indicates Bad URL)\n');
% Read and predict
% file_contents = readFile(filename);
% word_indices  = processEmail(file_contents);
% x             = emailFeatures(word_indices);
% [pred, p] = SVM_URL_Predict(model, f');
% [pred, p] = svmpredict(model, f');

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
%fprintf(fileID2,"\n");
%fprintf(fileID2,'%s',char(neg_word));
fclose(fileID2);
toc
fprintf('=============== Optimal Search String Parameter Data Written =============\n\n\n');
fprintf('==========================================================================\n');
fprintf('=================================== DONE!!! ==============================\n');
fprintf('==========================================================================\n\n');
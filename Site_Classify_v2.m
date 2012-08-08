function Site_Classify(good_file,bad_file,eval_file,eval_output_file,search_string_out_file)

%%%%%%%%%%%%%%%%%%%%%% Website Classification with SVMs %%%%%%%%%%%%%%%%
%
%  This file contains code that will allow the user to classify URLs
%  as belonging to a particular class based upon word, word pair, and
%  word frequencies.  The following files will be used by this file:
%
%     gaussianKernel.m
%     dataset3Params.m  ?????
%     dictionary_gen.m
%     extract_data.m
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

%% Initialization
%% clear; close all; clc
%% done = ('Done!');

fprintf('======================= Starting Site Classification ======================\n');
fprintf('Program paused. Press enter to start the dictionary and feature extration.\n\n');
pause;

%good_file = 'site_data.txt';
%bad_file = 'site_data.txt';
%eval_file = 'site_data.txt';
%eval_output_file = 'output_data.txt';
%search_string_out_file = 'search_string_out_file.txt';

fprintf('Extracting data and features from "POSITIVE" Urls in File: ');
fprintf(good_file);
fprintf('\nExtracting data and features from "NEGATIVE" Urls in File: ');
fprintf(bad_file);
fprintf('\n===========================================================================\n')

%% ==================== Part 1: Dictionary Generation ====================
%  The following is used to generate the dictionary of words and word pairs
%  that is used in the analysis.

[dictionary_words, dictionary_pairs] = dictionary_gen(good_file,bad_file);

%% ==================== Part 2: Feature Extraction ====================
%  The following is used to extract feature set 

[u,dw,dp,fw,fp] = extract_data(good_file, dictionary_words, dictionary_pairs);

urls = u;
dataset_words = dw;
dataset_pairs = dp;
freq_words = fw;
freq_pairs = fp;

class = ones(1,size(u,1));

[u,dw,dp,fw,fp] = extract_data(bad_file, dictionary_words, dictionary_pairs);

class = horzcat(class, zeros(1, size(u,1)));

urls = vertcat(urls,u);
dataset_words = horzcat(dataset_words,dw);
dataset_pairs = horzcat(dataset_pairs,dp);
freq_words = horzcat(freq_words,fw);
freq_pairs = horzcat(freq_pairs,fp);

features = vertcat(dataset_words,dataset_pairs,freq_words,freq_pairs);

% Print Stats
fprintf('\nNumber of URLs in extracted dataset: ');
fprintf("%i",size(urls,1));
fprintf('\n\n');

fprintf('Program paused. Press enter to continue actively training the SVM Model.\n');
pause;

%% =========== Part 3: Train Linear SVM for File Classification ========
%  In this section, you will train a linear classifier to determine if an
%  email is Spam or Not-Spam.

% Load the Spam Email dataset
% You will have X, y in your environment
% load('spamTrain.mat');

fprintf('\nTraining Linear SVM (Spam Classification)\n')
fprintf('(this may take a bit)\n')
tic

C = 0.1;
%model = svmTrain(X, y, C, @linearKernel);
%model = svmTrain(features', class', C, @linearKernel);
model = svmtrain(class', features');

%[pred, p] = SVM_URL_Predict(model, features');
tlv = rand(size(features',1),1); 
[pred, accuracy, p] = svmpredict(tlv, features', model);

toc
fprintf('\nTraining Accuracy: %f', mean(double(pred == class')) * 100);

%% =================== Part 4: Test Spam Classification ================
%  After training the classifier, we can evaluate it on a test set. We have
%  included a test set in spamTest.mat

% Load the test dataset
% You will have Xtest, ytest in your environment
%load('spamTest.mat');

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

fprintf('\n\n');
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
model_w = ((model.sv_coef)'*(model.SVs))';
%model_w = ((model.sv_coef)'*(model.SVs))'.*(features*class');



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

fprintf('\n\nProgram paused. Press enter to continue and evaluate new URLS.\n');
pause;

%% ==================== Part 6: Try Your Own Emails ======================
%  Now that you've trained the spam classifier, you can use it on your own
%  emails! In the starter code, we have included spamSample1.txt,
%  spamSample2.txt, emailSample1.txt and emailSample2.txt as examples. 
%  The following code reads in one of these emails and then uses your 
%  learned SVM classifier to determine whether the email is Spam or 
%  Not Spam

% Set the file to be read in (change this to spamSample2.txt,
% emailSample1.txt or emailSample2.txt to see different predictions on
% different emails types). Try your own emails as well!
%filename = 'spamSample1.txt';


[eval_urls,eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs] = extract_data(eval_file, dictionary_words, dictionary_pairs);

f = vertcat(eval_dataset_words,eval_dataset_pairs,eval_freq_words,eval_freq_pairs);

fprintf('\n========================== Classifying New URLs ===========================\n');
%fprintf('(>0 indicates Good URL, <0 indicates Bad URL)\n');

% Read and predict
%file_contents = readFile(filename);
%word_indices  = processEmail(file_contents);
%x             = emailFeatures(word_indices);
%[pred, p] = SVM_URL_Predict(model, f');
%[pred, p] = svmpredict(model, f');

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
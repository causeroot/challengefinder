%% Website Classification with SVMs
%
%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  exercise. You will need to complete the following functions:
%
%     gaussianKernel.m
%     dataset3Params.m
%     processEmail.m
%     emailFeatures.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.

%% Initialization
clear; close all; clc


good_file = 'site_data.txt';
bad_file = 'site_data.txt';
eval_file = 'site_data.txt';
%good_file = 'site_data1.txt';
%bad_file = 'site_data2.txt';
%eval_file = 'eval_data.txt';
output_file = 'output_data.txt';

fprintf('\nExtracting data and features from "GOOD" Urls in File: ');
fprintf(good_file);
fprintf('\nExtracting data and features from "BAD" Urls in File: ');
fprintf(bad_file);

% Create Dictionary
[dictionary_words, dictionary_pairs] = dictionary_gen(good_file,bad_file);

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
fprintf('Number of URLs in extracted dataset: \n');
fprintf(' %s',size(urls,1));
fprintf('\n\n');

toc
fprintf('Program paused. Press enter to continue actively training the SVM.\n');
pause;

%% ==================== Part 2: Feature Extraction ====================
%  Now, you will convert each email into a vector of features in R^n. 
%  You should complete the code in emailFeatures.m to produce a feature
%  vector for a given email.

% Extract Features
%file_contents = readFile('emailSample1.txt');
%word_indices  = processEmail(file_contents);
%features      = emailFeatures(word_indices); features is just word presence which we have

% Print Stats
%fprintf('Length of feature vector: %d\n', length(features));
%fprintf('Number of non-zero entries: %d\n', sum(features > 0));
%fprintf('Program paused. Press enter to continue.\n');

%% =========== Part 3: Train Linear SVM for Spam Classification ========
%  In this section, you will train a linear classifier to determine if an
%  email is Spam or Not-Spam.

% Load the Spam Email dataset
% You will have X, y in your environment
% load('spamTrain.mat');

fprintf('\nTraining Linear SVM (Spam Classification)\n\n')
fprintf('(this may take a bit) ...\n')
tic

C = 0.1;
%model = svmTrain(X, y, C, @linearKernel);
model = svmTrain(features', class', C, @linearKernel);

[pred, p] = SVM_URL_Predict(model, features');

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
%

fprintf('\n\n');
% Sort the weights and obtin the vocabulary list
[weight, idx] = sort(model.w, 'descend');
%vocabList = getVocabList();

fprintf('\nTop predictors for applicable URLs: \n');

for i = 1:15
    if idx(i) < size(dictionary_words,1)+1
        fprintf('Word: %-15s (%f) \n', dictionary_words{idx(i)}, weight(i));
    elseif idx(i) < (size(dictionary_words,1)+size(dictionary_pairs,1)+1)
        fprintf('Pair: %-15s (%f) \n', dictionary_pairs{idx(i)-size(dictionary_words,1)}, weight(i));
    elseif idx(i) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)+1)
        fprintf('Word Freq: %-15s (%f) \n', dictionary_words{idx(i)-(size(dictionary_words,1)+size(dictionary_pairs,1))}, weight(i));   
    elseif idx(i) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)*2+1)
        fprintf('Pair Freq: %-15s (%f) \n', dictionary_pairs{idx(i)-(size(dictionary_words,1)*2+size(dictionary_pairs,1))}, weight(i));
    end
end

%features = vertcat(dataset_words,dataset_pairs,freq_words,freq_pairs);

fprintf('\n\n');
fprintf('\nProgram paused. Press enter to continue and evaluate new URLS.\n');
pause;
tic

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

% Read and predict
%file_contents = readFile(filename);
%word_indices  = processEmail(file_contents);
%x             = emailFeatures(word_indices);
[pred, p] = SVM_URL_Predict(model, f');

fprintf('\nProcessed %s URL Classification into %s', eval_file,output_file);
fprintf('\n(>0 indicates Good URL, <0 indicates Bad URL)\n\n');

toc

fileID = fopen(output_file,'w');
for i = 1:size(eval_urls,1)
    fprintf(fileID,'%s',char(eval_urls(i)));
    fprintf(fileID,' ');
    fprintf(fileID,'%d',p(i));
    fprintf(fileID,' \n');
end

fclose(fileID);

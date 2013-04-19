function genSearchStrings()

addpath(strrep(pwd, "/src/searchTermGeneration", "/src/featureGeneration"));
addpath(strrep(pwd, "/src/searchTermGeneration", "/src/termExtraction"));
addpath(strrep(pwd, "/src/searchTermGeneration", "/src/siteRetrieval"));

pathFeatures = strrep(pwd, "/src/searchTermGeneration", "/data/features");
pathUrlTerms = strrep(pwd, "/src/searchTermGeneration", "/data/urlTerms");
pathRawSiteData = strrep(pwd, "/src/searchTermGeneration", "/data/rawSiteData");
pathModel = strrep(pwd, "/src/searchTermGeneration", "/data/svmModel");

modelFile = strrep(pwd, "/src/searchTermGeneration", "/data/svmModel/model.binsev");
predFile = strrep(pwd, "/src/searchTermGeneration", "/data/svmModel/pred.binsev");
accuracyFile = strrep(pwd, "/src/searchTermGeneration", "/data/svmModel/accuracy.binsev");
pFile = strrep(pwd, "/src/searchTermGeneration", "/data/svmModel/p.binsev");
search_string_out_file = strrep(pwd, "/src/searchTermGeneration", "/data/searchTerms/new_sstrings.txt");

dictionaryWordsFile = strrep(pwd, "/src/searchTermGeneration", "/data/urlTerms/dictionary_words_file.binsev");
dictionaryPairsFile = strrep(pwd, "/src/searchTermGeneration", "/data/urlTerms/dictionary_pairs_file.binsev");


%% ================= Part 5: Top Predictors of a Good Challenge URL ====================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier 'thinks'
%  that these words are the most likely indicators of a good challenge URL.

%%%%%%%%% Load the dictionary model, words, and pairs %%%%%%%%%%%%%%%%%

fprintf('\nFiles Loaded: ');
load("-v7",modelFile,"model")
fprintf('\n     Successful Load from model.binsev');
load("-v7",dictionaryWordsFile, "dictionary_words")
fprintf('\n     Successful Load from dictionary_classes_file.binsev');
load("-v7",dictionaryPairsFile, "dictionary_pairs")
fprintf('\n     Successful Load from dictionary_words_file.binsev');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

fprintf('Newly Search String Paramenters Written to: %s\n',char(search_string_out_file));
tic
pos_word = regexprep(pos_word,'_','+');
fileID2 = fopen(search_string_out_file,'w');
fprintf(fileID2,'%s',char(pos_word));
fclose(fileID2);
toc
fprintf('=============== Optimal Search String Parameter Data Written =============\n\n\n');


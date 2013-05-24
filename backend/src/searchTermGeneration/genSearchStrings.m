function pos_word = genSearchStrings(model,dictionary_words,dictionary_pairs)

%% ================= Part 5: Top Predictors of a Good Challenge URL ====================
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier 'thinks'
%  that these words are the most likely indicators of a good challenge URL.

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
        pos_word = strcat(pos_word,{'+'},insert,{'"'},parm,{'"'});
        insert = {''};
        % Delete the above 2 lines to go back to add the Freq into the algorithm qualifiers
     elseif idx(length(idx)-i+1) < (size(dictionary_words,1)+size(dictionary_pairs,1)+1)
        parm = dictionary_pairs{idx(length(idx)-i+1)-size(dictionary_words,1)};
        fprintf('Pair: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
        pos_word = strcat(pos_word,{'+'},insert,{'"'},parm,{'"'});
        insert = {''};
        % Delete the above 2 lines to go back to add the Freq into the algorithm qualifiers
    % elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)+1)
        % parm = dictionary_words{idx(length(idx)-i+1)-(size(dictionary_words,1)+size(dictionary_pairs,1))};
        % fprintf('Word Freq: %-15s \t\t(%s%f) \n',parm, char(insert), weightx(length(idx)-i+1));
        % Add back in the above two lines to go back to add the Freq into the algorithm qualifiers
        % i = i+1;
        %num_distinctifiers = num_distinctifiers +1;
    % elseif idx(length(idx)-i+1) < (size(dictionary_words,1)*2+size(dictionary_pairs,1)*2+1)
        % parm = dictionary_pairs{idx(length(idx)-i+1)-(size(dictionary_words,1)*2+size(dictionary_pairs,1))};
        % fprintf('Pair Freq: %-15s \t\t(%s%f) \n', parm, char(insert), weightx(length(idx)-i+1));
        % Add back in the above two lines to go back to add the Freq into the algorithm qualifiers
        % i = i+1;
        % num_distinctifiers = num_distinctifiers+1;
    end
end

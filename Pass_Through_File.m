function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs, dictionary_words, dictionary_pairs] = Pass_Through_File(file_contents)

%PROCESSEFILE *** Need to describe what the file does here ***

% ========================== Preprocess File ===========================

% Find the Headers ( \n\n and remove )
% Uncomment the following lines if you are working with raw emails with the
% full headers

%hdrstart = strfind(file_contents, ([char(10) char(10)]));
%file_contents = file_contents(hdrstart(1):end);

% Lower case
%file_contents = lower(file_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
%file_contents = regexprep(file_contents, '<[^<>]+>', ' ');

% Handle Numbers
% Look for one or more characters between 0-9
%file_contents = regexprep(file_contents, '[0-9]+', 'number');

% Handle URLS
% Look for strings starting with http:// or https://
%file_contents = regexprep(file_contents, ...
%                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses
% Look for strings with @ in the middle
%file_contents = regexprep(file_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign
%file_contents = regexprep(file_contents, '[$]+', 'dollar');
% ======================= End Preprocess File ===========================
% ========================== Tokenize File ===========================

%fprintf('\n==== Processed File ====\n\n');
% Process file
l = 0;
u_num = 0;
urls = [];
words = [];
pairs = [];
dictionary_words = [];
dictionary_pairs = [];
temp_file = file_contents;

while ~isempty(temp_file)

    % Tokenize and also get rid of any punctuation
    [url_dataset, temp_file] = strtok(temp_file, ',');
   
    words = [];
    pairs = [];
    u_num = u_num+1;
    temp_words = strsplit(url_dataset,' ');
    u = temp_words(1); 
    temp_words(1) = [];
    words = temp_words;
    temp_words(1) = [];
    pairs = strcat(words(1:size(words,2)-1),'_',temp_words);

    if u_num == 1
        dictionary_words = words';
        dictionary_pairs = pairs';
        urls = u'; 
    else
        dictionary_words = vertcat(dictionary_words, words');
        dictionary_pairs = vertcat(dictionary_pairs, pairs');
        urls = vertcat(urls,u'); 
    end
end

dictionary_words = unique(dictionary_words);
dictionary_pairs = unique(dictionary_pairs);

dataset_words = zeros(size(dictionary_words,1),u_num);
dataset_pairs = zeros(size(dictionary_pairs,1),u_num);
freq_words = zeros(size(dictionary_words,1),u_num);
freq_pairs = zeros(size(dictionary_pairs,1),u_num);

last_word = [];
u_num = 0;
junk = 0;

while ~isempty(file_contents)

    u_num = u_num+1;
    [url_dataset, file_contents] = strtok(file_contents, ',');
   
    words = [];
    pairs = [];
    temp_words = strsplit(url_dataset,' ');
    temp_words(1) = [];
    words = temp_words;
    temp_words(1) = [];
    pairs = strcat(words(1:size(words,2)-1),'_',temp_words);
     
    dataset_words(:,u_num) = ismember(dictionary_words,words);
    dataset_pairs(:,u_num) = ismember(dictionary_pairs,pairs);
    
    freq_words(:,u_num) = countmember(dictionary_words,words);
    freq_pairs(:,u_num) = countmember(dictionary_pairs,pairs);
    
    fprintf('\n\n========== Pass Through Complete ===============\n');

end

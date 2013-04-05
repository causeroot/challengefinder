function word_indices = processEmail(file_contents)

%PROCESSEMAIL preprocesses a the body of an email and
%returns a list of word_indices 
%   word_indices = PROCESSEMAIL(file_contents) preprocesses 
%   the body of an email and returns a list of indices of the 
%   words contained in the email.

% Load Vocabulary
vocabList = getVocabList();

% Init return value
word_indices = [];

% ========================== Preprocess Email ===========================

% Find the Headers ( \n\n and remove )
% Uncomment the following lines if you are working with raw emails with the
% full headers

%hdrstart = strfind(file_contents, ([char(10) char(10)]));
%file_contents = file_contents(hdrstart(1):end);

% Lower case
file_contents = lower(file_contents);

% Strip all HTML
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space
file_contents = regexprep(file_contents, '<[^<>]+>', ' ');

% Handle Numbers
% Look for one or more characters between 0-9
file_contents = regexprep(file_contents, '[0-9]+', 'number');

% Handle URLS
% Look for strings starting with http:// or https://
file_contents = regexprep(file_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses
% Look for strings with @ in the middle
file_contents = regexprep(file_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign
file_contents = regexprep(file_contents, '[$]+', 'dollar');


% ========================== Tokenize File ===========================

% Output the file to screen as well
fprintf('\n==== Processed File ====\n\n');

% Process file
l = 0;

while ~isempty(file_contents)

    % Tokenize and also get rid of any punctuation
    [str, file_contents] = ...
       strtok(file_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    % Stem the word 
    % (the porterStemmer sometimes has issues, so we use a try catch block)
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end

    % Look up the word in the dictionary and add to word_indices if
    % found
    % ====================== YOUR CODE HERE ======================
    % Instructions: Fill in this function to add the index of str to
    %               word_indices if it is in the vocabulary. At this point
    %               of the code, you have a stemmed word from the email in
    %               the variable str. You should look up str in the
    %               vocabulary list (vocabList). If a match exists, you
    %               should add the index of the word to the word_indices
    %               vector. Concretely, if str = 'action', then you should
    %               look up the vocabulary list to find where in vocabList
    %               'action' appears. For example, if vocabList{18} =
    %               'action', then, you should add 18 to the word_indices 
    %               vector (e.g., word_indices = [word_indices ; 18]; ).
    % 
    % Note: vocabList{idx} returns a the word with index idx in the
    %       vocabulary list.
    % 
    % Note: You can use strcmp(str1, str2) to compare two strings (str1 and
    %       str2). It will return 1 only if the two strings are equivalent.
    %

for i=1:size(vocabList,1)
	if strcmp(str, vocabList(i))
		word_indices = [word_indices; i];
	end
end

    % =============================================================
    % Print to screen, ensuring that the output lines are not too long
    if (l + length(str) + 1) > 78
        fprintf('\n');
        l = 0;
    end
    fprintf('%s ', str);
    l = l + length(str) + 1;

end

% Print footer
fprintf('\n\n=========================\n');

end

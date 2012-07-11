function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs] = extract_data(filename, dictionary_words, dictionary_pairs)

%extract_data *** Need to describe what the file does here ***
fprintf('\n\n============ Beginning Data Extraction for ')
fprintf(filename)
fprintf('===================\n');
tic

file_contents = readFile(filename);

dataset_words = zeros(size(dictionary_words,1),1);
dataset_pairs = zeros(size(dictionary_pairs,1),1);
freq_words = zeros(size(dictionary_words,1),1);
freq_pairs = zeros(size(dictionary_pairs,1),1);

u_num = 0;

while ~isempty(file_contents) % ***** Parse per line in the file ****

    u_num = u_num+1;
    [url_dataset, file_contents] = strtok(file_contents, "\n");
   
    words = [];
    pairs = [];
    temp_words = strsplit(url_dataset,' ');
    u = temp_words(1); 
    temp_words(1) = [];
    words = temp_words;
    temp_words(1) = [];
    pairs = strcat(words(1:size(words,2)-1),'_',temp_words);
    
    if u_num == 1
        urls = u';
        dataset_words = ismember(dictionary_words,words);
        dataset_pairs = ismember(dictionary_pairs,pairs);
        
        freq_words = countmember(dictionary_words,words);
        freq_pairs = countmember(dictionary_pairs,pairs);  
       
    else
        urls = vertcat(urls,u');
        dataset_words = horzcat(dataset_words,ismember(dictionary_words,words));
        dataset_pairs = horzcat(dataset_pairs,ismember(dictionary_pairs,pairs));
        
        freq_words = horzcat(freq_words,countmember(dictionary_words,words));
        freq_pairs = horzcat(freq_pairs,countmember(dictionary_pairs,pairs));       
    end

end

freq_words = freq_words./max(max(freq_words));
freq_pairs = freq_pairs./max(max(freq_pairs));

toc
fprintf('=============== Extract Data for ')
fprintf(filename)
fprintf(' Complete ===================\n');
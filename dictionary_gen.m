function [dictionary_words, dictionary_pairs] = dictionary_gen(filename1,filename2)

% Dictionary_gen *** Need to describe what the function does here ***
fprintf('\n\n====================== Begin Processing Dictionary ========================\n');
    tic
    file_contents1 = readFile(filename1);
    file_contents2 = readFile(filename2);

    dictionary_words = [];
    dictionary_pairs = [];
    temp_words = [];
    u_num = 0;
    
    while ~isempty(file_contents1)
    
        u_num = u_num+1;
        [url_dataset1, file_contents1] = strtok(file_contents1, "\n");
        wordlist1 = strsplit(url_dataset1,' ');
  %%%%%%%%%%%%%%%%%%%%%%%%      
        words1 = wordlist1; % This step will be modified to potentially include word processing
  %%%%%%%%%%%%%%%%%%%%%%%%      
        words1(1) = [];
        temp_words = words1;
        temp_words(1) = [];
        pairs1 = strcat(words1(2:size(words1,2)-1),'_',temp_words(2:size(temp_words,2)));
        if u_num == 1
            dictionary_words = words1';
            dictionary_pairs = pairs1';
        else
            dictionary_words = vertcat(dictionary_words, words1');
            dictionary_pairs = vertcat(dictionary_pairs, pairs1');
        end
    end
    
    u_num =0;
    
    while ~isempty(file_contents2)
    
        u_num = u_num+1;
        [url_dataset2, file_contents2] = strtok(file_contents2,"\n");
        wordlist2 = strsplit(url_dataset2,' ');
        
   %%%%%%%%%%%%%%%%%%%%%%%%     
        words2 = wordlist2; % This step will be modified to potentially include word processing
   %%%%%%%%%%%%%%%%%%%%%%%%     
        words2(1) = [];
        temp_words = words2;
        temp_words(1) = [];
        pairs2 = strcat(words2(2:size(words2,2)-1),'_',temp_words(2:size(temp_words,2)));

        dictionary_words = vertcat(dictionary_words, words2');
        dictionary_pairs = vertcat(dictionary_pairs, pairs2');

    end

    dictionary_words = unique(dictionary_words);
    dictionary_pairs = unique(dictionary_pairs);

    toc
fprintf('========================== Dictionary Processed ===========================\n');

end
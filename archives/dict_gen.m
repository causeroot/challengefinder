function [dictionary_words, dictionary_pairs] = dictionary_gen(filename1,filename2)

% Dictionary_gen *** Need to describe what the function does here ***
fprintf('\n====================== Begin Processing Dictionary ========================\n');
    tic
    
    % TODO: %%%%% ERROR HANDLING %%%%%%%%%
    filename1 = input("Input Good Challenge File: ", "s");
    filename2 = input("Input Bad Challenge File: ", "s");
    % TODO: %%%%%% remove " or ' %%%%%%%

    fprintf('\nProgram paused. Press enter to start the dictionary and feature extration.\n\n');
    pause;
    
    % OLD CODE:
    %good_file = 'site_data.txt';
    %bad_file = 'site_data.txt';
    %eval_file = 'site_data.txt';
    %eval_output_file = 'output_data.txt';
    %search_string_out_file = 'search_string_out_file.txt';

    fprintf('Extracting data and features from "POSITIVE" Urls in File: ');
    fprintf(filename1);
    fprintf('\nExtracting data and features from "NEGATIVE" Urls in File: ');
    fprintf(filename2);
    fprintf('\n===========================================================================\n')

    %% ==================== Part 1: Dictionary Generation ====================
    %  The following is used to generate the dictionary of words and word pairs
    %  that is used in the analysis.
    
    % OLD CODE:
    % [dictionary_words, dictionary_pairs] = dictionary_gen(good_file,bad_file);
    
    fileID1 = fopen(filename1,'r');
    fileID2 = fopen(filename2,'r');
    
    dictionary_words = [];
    dictionary_pairs = [];
    temp_words = [];
    u_num = 0;
    
    while (!feof(fileID1))
    
        file_contents1 = fgetl(fileID1);
        u_num = u_num+1;
        [url_dataset1, file_contents1] = strtok(file_contents1, "\n");
        wordlist1 = strsplit(url_dataset1,' ');
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        % TODO: This step will be modified to potentially include word processing      
        words1 = wordlist1; 
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
    
    while (!feof(fileID2))
        
        file_contents2 = fgetl(fileID2);
        u_num = u_num+1;
        [url_dataset2, file_contents2] = strtok(file_contents2,"\n");
        wordlist2 = strsplit(url_dataset2,' ');
        
        %%%%%%%%%%%%%%%%%%%%%%%%   
        % TODO: This step will be modified to potentially include word processing  
        words2 = wordlist2; 
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

fclose(fileID1);
fclose(fileID2);

%% ==================== Part 2: Feature Extraction ====================
%  The following is used to extract feature set 

[u,dw,dp,fw,fp] = extract_data(good_file, dictionary_words, dictionary_pairs);
function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs] = extract_data(filename, dictionary_words, dictionary_pairs)
  
% TODO: Add more comments here

fprintf('\n============ Beginning Data Extraction for ')
fprintf(good_file)
fprintf('===================\n');
tic

fileID = fopen(good_file,'r');

dataset_words_1 = zeros(size(dictionary_words,1),1);
dataset_pairs_1 = zeros(size(dictionary_pairs,1),1);
freq_words_1 = zeros(size(dictionary_words,1),1);
freq_pairs_1 = zeros(size(dictionary_pairs,1),1);

u_num = 0;

while (!feof(fileID))

    file_contents = fgetl(fileID);
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
        urls = u;
        dataset_words = ismember(dictionary_words,words);
        dataset_pairs = ismember(dictionary_pairs,pairs);
        
        freq_words = countmember(dictionary_words,words);
        freq_pairs = countmember(dictionary_pairs,pairs);  
       
    else
        urls = vertcat(urls,u);
        dataset_words = horzcat(dataset_words,ismember(dictionary_words,words));
        dataset_pairs = horzcat(dataset_pairs,ismember(dictionary_pairs,pairs));
        
        freq_words = horzcat(freq_words,countmember(dictionary_words,words));
        freq_pairs = horzcat(freq_pairs,countmember(dictionary_pairs,pairs));       
    end

end

freq_words = freq_words./max(max(freq_words));
freq_pairs = freq_pairs./max(max(freq_pairs));

toc
fclose(fileID);
fprintf('=============== Data Extraction for ')
fprintf(good_file)
fprintf(' Complete ===================\n');

    % OLD CODE:
    %urls = u;
    %dataset_words = dw;
    %dataset_pairs = dp;
    %freq_words = fw;
    %freq_pairs = fp;

class = ones(1,size(u,1));

% OLD CODE:
%    [u,dw,dp,fw,fp] = extract_data(bad_file, dictionary_words, dictionary_pairs);
%    function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs] = extract_data(filename, dictionary_words, dictionary_pairs)
  
% TODO: ADD COMMENTS

fprintf('\n============ Beginning Data Extraction for ')
fprintf(bad_file)
fprintf('===================\n');
tic

 fileID = fopen(bad_file,'r');

dataset_words = zeros(size(dictionary_words,1),1);
dataset_pairs = zeros(size(dictionary_pairs,1),1);
freq_words = zeros(size(dictionary_words,1),1);
freq_pairs = zeros(size(dictionary_pairs,1),1);

u_num = 0;

while (!feof(fileID))

    file_contents = fgetl(fileID);
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
        urls = u;
        dataset_words = ismember(dictionary_words,words);
        dataset_pairs = ismember(dictionary_pairs,pairs);
        
        freq_words = countmember(dictionary_words,words);
        freq_pairs = countmember(dictionary_pairs,pairs);  
       
    else
        urls = vertcat(urls,u);
        dataset_words = horzcat(dataset_words,ismember(dictionary_words,words));
        dataset_pairs = horzcat(dataset_pairs,ismember(dictionary_pairs,pairs));
        
        freq_words = horzcat(freq_words,countmember(dictionary_words,words));
        freq_pairs = horzcat(freq_pairs,countmember(dictionary_pairs,pairs));       
    end

end

freq_words = freq_words./max(max(freq_words));
freq_pairs = freq_pairs./max(max(freq_pairs));

toc
fclose(fileID);
fprintf('=============== Data Extraction for ')
fprintf(bad_file)
fprintf(' Complete ===================\n');

    class = horzcat(class, zeros(1, size(u,1)));

    urls = vertcat(urls,u);
    dataset_words = horzcat(dataset_words,dw);
    dataset_pairs = horzcat(dataset_pairs,dp);
    freq_words = horzcat(freq_words,fw);
    freq_pairs = horzcat(freq_pairs,fp);

    features = vertcat(dataset_words,dataset_pairs,freq_words,freq_pairs);
    
    save -hdf5 dictionary_features_file.hdf5 features
    save -hdf5 dictionary_classes_file.hdf5 class
    save -hdf5 dictionary_words_file.hdf5 dictionary_words
    save -hdf5 dictionary_pairs_file.hdf5 dictionary_pairs
        
    % PRINT STATISTICS
    fprintf('\nNumber of URLs in extracted dataset: ');
    fprintf("%i",size(urls,1));
    fprintf('\n\n');
    toc
end
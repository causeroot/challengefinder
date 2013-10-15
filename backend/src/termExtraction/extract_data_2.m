function [urls, dataset_words, dataset_pairs, freq_words, freq_pairs] = extract_data_2(filename, dictionary_words, dictionary_pairs)

% TODO: *** Need to describe what the file does here!!! ***


fprintf('\n============ Beginning Data Extraction for ')
fprintf(filename)
fprintf('==================\n');
tic

fileID_pre = fopen(filename,'r');

while (!feof(fileID_pre))
    total_lines = fskipl(fileID_pre,Inf); % May want to change this from Inf to something practical
total_lines = total_lines+1;
end


fclose (fileID_pre);

fileID = fopen(filename,'r');

% OLD CODE 
%dw_l = size(dictionary_words,1);
%dp_l = zeros(size(dictionary_pairs,1));

dataset_words = spalloc(size(dictionary_words,1),total_lines,10000000);
dataset_pairs = spalloc(size(dictionary_pairs,1),total_lines,10000000);
freq_words = spalloc(size(dictionary_words,1),total_lines,10000000);
freq_pairs = spalloc(size(dictionary_pairs,1),total_lines,10000000);

u_num = 0;

% OLD CODE
%w_cnt = 1;
%p_cnt = 1;


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
        % OLD CODE
        %dataset_words = ismember(dictionary_words,words);
        %dataset_pairs = ismember(dictionary_pairs,pairs);
        %freq_words = countmember(dictionary_words,words);
        %freq_pairs = countmember(dictionary_pairs,pairs);  
       
    else
        urls = vertcat(urls,u);
    end
    
        dataset_words(:,u_num) = ismember(dictionary_words,words);
        dataset_pairs(:,u_num) = ismember(dictionary_pairs,pairs);
        freq_words(:,u_num) = ismember(dictionary_words,words);
        freq_pairs(:,u_num) = ismember(dictionary_pairs,pairs);
        
        % OLD CODE
        %w_cnt = w_cnt+dw_l;
        %p_cnt = p_cnt+dp_l;
        %dataset_words = horzcat(dataset_words,ismember(dictionary_words,words));
        %dataset_pairs = horzcat(dataset_pairs,ismember(dictionary_pairs,pairs));
        %freq_words = horzcat(freq_words,countmember(dictionary_words,words));
        %freq_pairs = horzcat(freq_pairs,countmember(dictionary_pairs,pairs));       

%%%% BUILT IN TEST: Uncomment to display the number of words per URL %%%%
%    fprintf('\n');      
%    fprintf('%i', u_num);
%    fprintf('\n');
%    fprintf('%i', size(words,2));
%    fprintf('\n');
%    fprintf('\n\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

freq_words = freq_words./max(max(freq_words));
freq_pairs = freq_pairs./max(max(freq_pairs));

toc
fclose(fileID);
fprintf('=============== Extract Data for ')
fprintf(filename)
fprintf(' Complete ==================\n');
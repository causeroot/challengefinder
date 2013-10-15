function file_contents = readFile(filename)
%READFILE reads a file and returns its entire contents 
%   file_contents = READFILE(filename) reads a file and returns its entire
%   contents in file_contents
%

% Load File
fid = fopen(filename);
if fid > 0
    file_contents = fscanf(fid, '%c', Inf);
    #file_contents = fscanf(fid);
    fclose(fid);
else
    file_contents = '';
    fprintf('Unable to open %s\n', filename);
end

end


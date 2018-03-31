function lines = loadfilelines(path)
% loadfilelines.m: load each line of a given file into a cell element
%
% Syntax:
%    1) lines = loadfilelines(path)
%
% Description:
%    1) lines = loadfilelines(path) loads a file into a cell variable. Each
%       line of the file will correspond to a cell element.
%
% Inputs:
%    1) path: path to file
%
% Outputs:
%    1) lines: cell of file lines
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180331: original version

% Remove editor warning 
%#ok<*AGROW>

% Open file for reading
fid = fopen(path);

fileNotFinished = true;

% Get first line
firstLine = fgetl(fid);
lines{1}  = firstLine;
lineCount = 1;

% Get remaining lines
while fileNotFinished
    
    % Increment line counter
    lineCount = lineCount + 1;
    
    % Read and store next line
    lines{lineCount} = fgetl(fid);
    
    % Check if we reached the end of the file
    if lines{lineCount} == -1
        fileNotFinished = false;
        lines(lineCount) = [];  % remove -1 from lines
    end
    
end

% Close file
fclose(fid);

end
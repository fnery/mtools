function scriptdoc
% scriptdoc.m: prints script documentation template to command window
%   
% Syntax:
%    1) scriptdoc
%
% Description:
%    1) scriptdoc prints template for scripts documentation (comment lines 
%       in the file "scriptdoc.txt")
%
% Inputs:
%    []
%
% Outputs:
%    [] (just prints in command window)
%
% Notes/Assumptions: 
%    1) Assumes "scriptdoc.txt" is in the same directory as this function
%
% References:
%    []
%
% Required functions:
%    1) getabovedir.m
%    2) authstr.m
%
% Required files:
%    1) scriptdoc.txt
% 
% Examples:
%    []
%
% fnery, 20170321: original version

EXPECTED_FILE_FOLDER  = 'aux_files'; 
EXPECTED_FILE_NAME = 'scriptdoc.txt';

masterDir = getabovedir(mfilename('fullpath'), 2);

expectedFileDir = fullfile(masterDir, EXPECTED_FILE_FOLDER);

% Open file
f = fopen(fullfile(expectedFileDir, EXPECTED_FILE_NAME));

% Read and print each comment line (starting with '%')
tLine = fgetl(f);
while ischar(tLine)
    isCommentLine = (~isempty(tLine)) && (strcmp('%', tLine(1)));
    if isCommentLine
        disp(tLine)
    end
    tLine = fgetl(f);
end

% Print original version string
disp(authstr)

% Close file
fclose(f);

end
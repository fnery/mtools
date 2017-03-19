function fxdoc
% fxdoc.m: prints function documentation template to command window
%   
% Syntax:
%    1) fxdoc
%
% Description:
%    1) fxdoc prints template for function's documentation (comment lines 
%       in the file "fxdoc.txt")
%
% Inputs:
%    []
%
% Outputs:
%    [] (just prints in command window)
%
% Notes/Assumptions: 
%    1) Assumes "fxdoc.txt" is in the same directory as this function
%
% References:
%    []
%
% Required functions:
%    1) getabovedirectory.m
%    2) authstr.m
%
% Required files:
%    1) fxdoc.txt
% 
% Examples:
%    []
%
% fnery, 20160301: original version
% fnery, 20160530: now prints 'original version' string at the end
% fnery, 20170319: now indents = 4 spaces

EXPECTED_FILE_FOLDER  = 'aux_files'; 
EXPECTED_FILE_NAME = 'fxdoc.txt';

masterDir = getabovedirectory(mfilename('fullpath'), 2);

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
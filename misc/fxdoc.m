function fxdoc(auth)
% fxdoc.m: prints function documentation template to command window
%   
% Syntax:
%    1) fxdoc
%    2) fxdoc(auth)
%
% Description:
%    1) fxdoc prints template for function's documentation (comment lines 
%       in the file "fxdoc.txt")
%    2) fxdoc(auth) does the same as 1) but allows to specify the author's id
%
% Inputs:
%    []
%
% Outputs:
%    [] (just prints in command window)
%
% Notes/Assumptions: 
%    1) Assumes "fxdoc.txt" is in mtools\aux
%
% References:
%    []
%
% Required functions:
%    1) getabovedir.m
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
% fnery, 20170323: added auth argin

EXPECTED_FILE_FOLDER  = 'aux'; 
EXPECTED_FILE_NAME = 'fxdoc.txt';

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

% Print author string
if nargin == 0
    disp(authstr)
elseif nargin == 1
    disp(authstr('', auth))
else
    error('Error: Too many input arguments');
end

% Close file
fclose(f);

end
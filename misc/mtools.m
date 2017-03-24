function mtools
% mtools.m: displays index of functions in mtools in the command window
%
% Syntax:
%    1) mtools
%
% Description:
%    1) mtools displays mtools\aux\mtools.txt in the command window, 
%       providing a quick index of the functions available in this toolbox
%
% Inputs:
%    []
% 
% Outputs:
%    [] (prints text in the command window)
%
% Notes/Assumptions: 
%    1) Assumes "mtools.txt" is in mtools\aux
%
% References:
%    []
%
% Required functions:
%    1) getabovedir.m
%
% Required files:
%    1) mtools.txt
% 
% Examples:
%    []
%
% fnery, 20150525: original version

EXPECTED_FILE_FOLDER  = 'aux'; 
EXPECTED_FILE_NAME = 'mtools.txt';

masterDir = getabovedir(mfilename('fullpath'), 2);

expectedFileDir = fullfile(masterDir, EXPECTED_FILE_FOLDER);

% Load 'mtools.txt' file (located at mtools\aux)
f = fopen(fullfile(expectedFileDir, EXPECTED_FILE_NAME), 'r');
tmp = textscan(f, '%s', 'delimiter', '\n');
tmp = tmp{1};

% Display 'mtools.txt' in the command window
heading = sprintf('%s - function index', masterDir);
heading = sprintf('%s\n%s', heading, repmat('-', [1 length(heading)]));
disp(heading);
for iLine = 1:size(tmp, 1)
    cLine = tmp{iLine};
    if ~strcmp(cLine(1), '%');
        fprintf('%s\n', cLine)
    end
end

end
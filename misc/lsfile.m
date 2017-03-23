function [fullPath] = lsfile(searchDir)
% lsfile.m: list files in dir and pick according to file # index
%   
% Syntax:
%    1) [fullPath] = lsfile
%    2) [fullPath] = lsfile(searchDir)
%
% Description:
%    1) [fullPath] = lsfile lists files in the current directory and asks for
%       user to pick one of the files according to the file # index. The full
%       path of the chosen file is saved in 'fullPath'
%    2) [fullPath] = lsfile(searchDir) does the same as 1) but displays the
%       files in 'searchDir'
%
% Inputs:
%    1) searchDir: path of directory to search for files
%
% Outputs:
%    1) fullPath: full path of the chosen file
%
% Notes/Assumptions: 
%    1) Directory names are shown within []
%
% Required functions:
%    1) fdir.m
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20150216: original version
% fnery, 20150818: 0 argins option added, documentation improved
% fnery, 20170323: now uses fdir.m instead of getdirfiles.m

% If no input arguments are used, we search in the current directory
if nargin == 0
    searchDir = pwd;
end

[List, nFiles] = fdir('in', searchDir, 'silent', true);

% Create string with list of files and directories in 'searchDir'
listPickStr = sprintf('Files in ''%s'':\n', searchDir);
for iFile = 1:nFiles
    if List(iFile).isdir
        % If cFile is a directory, show its name with [] 
        listPickStr = sprintf('%s%d) [%s]\n', listPickStr, iFile, List(iFile).name);
    else
        listPickStr = sprintf('%s%d) %s\n', listPickStr, iFile, List(iFile).name);
    end
end

disp(listPickStr)

prompt = 'Select one of the files in the list: ';
fileIdx = input(prompt);

% Save the full path of the chosen file or directory
fullPath = fullfile(searchDir, List(fileIdx).name);

end
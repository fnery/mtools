function out = copyfiles(old, new)
% copyfiles.m: copies multiple files (MATLAB's copyfile wrapper)
%
% Syntax:
%    1) copyfiles(old, new)
%
% Description:
%    1) copyfiles(old, new) calls MATLAB's copyfile.m in a loop to copy
%       several files
%
% Inputs:
%    1) old: cell of strings (source file paths)
%    2) new: can be two things:
%       i)  cell of strings (destination file paths)
%       ii) string (char) (fullpath to directory to which files will be copied)
%
% Outputs:
%    1) out: cell of strings (full paths of files after copying)
%
% Notes/Assumptions: 
%    1) If 'new' is a directory (char) the file names will be the same
%       after copying, whereas if providing 'new' as a cell of strings the
%       file names after copying can be different from the source files
%
% References:
%    []
%
% Required functions:
%    1) exist2.m
%    2) fileparts2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180801: original version
%                  now also accepts destination directory as input

if ischar(new)
    % assume:
    % 1) 'new' is a directory    
    % 2) we want to copy the files in 'old' into it
    % therefore I need to generate the destination paths to all the files
    
    % Check 'new' directory exists
    exist2(new, 'dir', true);
    
    % Generate destination paths
    [~, n, e] = fileparts2(old);
    new = fullfile(new, strcat(n, e));
    
    % Now proceed as if the user had provided a cell of strings in 'new'
end   

% Error checks
nOld = length(old);
nNew = length(new);

if ~iscell(old)
    error('Error: ''old'' must be a cell of strings (source paths of files to be copied)');
end
if ~iscell(new)
    error(['Error: ''new'' must be either 1) a cell of strings (destination paths of files to be copied)', ...
     '\n                            2) a string (full path to directory to which files will be copied)'], []);
end

if ~isequal(nOld, nNew)
    error('Error: number of paths in old must be the same as number of paths in new');
else
    nPaths = nOld;
end

% copyfile loop
for iPath = 1:nPaths
    
    % Paths of file in current iteration
    cOldPath = old{iPath};
    cNewPath = new{iPath};
    
    % Ensure cOldPath corresponds to existing file 
    exist2(cOldPath, 'file', true);
    
    % Ensure cNewPath corresponds to non-existing file (before copying)
    cNewPathExists = exist2(cNewPath, 'file', false);
    if cNewPathExists
        error('Error: ''%s'' already exists before copying, this function will not overwrite it', cNewPath)
    end
        
    % Copy file and throw error if unsuccessful
    cCopySuccess = copyfile(cOldPath, cNewPath);
    if ~cCopySuccess
        error('Error: couldn''t copy ''%s'' to ''%s'' (file #%d/%d)', ...
            cOldPath, cNewPath, iPath, nPaths)
    end

end

out = new;

end
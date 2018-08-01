function copyfiles(old, new)
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
%    2) new: cell of strings (destination file paths)
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) exist2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180801: original version

% Error checks
nOld = length(old);
nNew = length(new);

if ~iscell(old)
    error('Error: ''old'' must be a cell of strings (source paths of files to be copied)');
end
if ~iscell(new)
    error('Error: ''new'' must be a cell of strings (destination paths of files to be created)');
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

end
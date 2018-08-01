function movefiles(old, new)
% movefiles.m: moves multiple files (MATLAB's movefile wrapper)
%
% Syntax:
%    1) movefiles(old, new)
%
% Description:
%    1) movefiles(old, new) calls MATLAB's movefile.m in a loop to move
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
    error('Error: ''old'' must be a cell of strings (source paths of files to be moved)');
end
if ~iscell(new)
    error('Error: ''new'' must be a cell of strings (destination paths of files to be moved)');
end

if ~isequal(nOld, nNew)
    error('Error: number of paths in old must be the same as number of paths in new');
else
    nPaths = nOld;
end

% movefile loop
for iPath = 1:nPaths
    
    % Paths of file in current iteration
    cOldPath = old{iPath};
    cNewPath = new{iPath};
    
    % Ensure cOldPath corresponds to existing file 
    exist2(cOldPath, 'file', true);
    
    % Ensure cNewPath corresponds to non-existing file (before moving)
    cNewPathExists = exist2(cNewPath, 'file', false);
    if cNewPathExists
        error('Error: ''%s'' already exists before moving, this function will not overwrite it', cNewPath)
    end
        
    % Move file and throw error if unsuccessful
    cMoveSuccess = movefile(cOldPath, cNewPath);
    if ~cMoveSuccess
        error('Error: couldn''t move ''%s'' to ''%s'' (file #%d/%d)', ...
            cOldPath, cNewPath, iPath, nPaths)
    end

end

end
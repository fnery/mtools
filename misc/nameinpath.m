function [out] = nameinpath(in, nDirsBeforeName)
% nameinpath.m: isolates name of file(s) from its complete path(s)
%
% Syntax:
%    1) [out] = nameinpath(in)
%    2) [out] = nameinpath(in, nDirsBeforeName)
%
% Description:
%    1) [out] = nameinpath(in) isolates the name of one or more files from
%        their complete paths.
%    2) [out] = nameinpath(in, nDirsBeforeName) does the same as 1) but allows
%       to include a number of directories before the name of the files, e.g.
%           nDirsBeforeName: 0 --> out = filename.ext
%           nDirsBeforeName: 1 --> out = dir/filename.ext
%           nDirsBeforeName: 2 --> out = predir/dir/filename.ext
%
% Inputs:
%    1) in:
%       - char: full path to a single file
%       - cell: "1D" cell with paths to multiple files
%    2) nDirsBeforeName: number of directories before the name of the file
%       (integer scalar)
%
% Outputs:
%    1) out: same format as in:
%       - char: name of the single file
%       - cell: "1D" cell with names of the multiple files
%
% Notes/Assumptions:
%    1) Note that the file extension will be included in the output
%
% Required functions:
%    []
%
% Required files:
%    []
%
% See also:
%    1) folderinpath.m
%    2) isint.m
%
% Examples:
%    []
%
% fnery, 20150725: original version
% fnery, 20160212: fixed documentation
% fnery, 20170318: now also accepts a cell of multiple paths as input
% fnery, 20190924: new input argument, nDirsBeforeName

N_DIRS_BEFORE_NAME_DEFAULT = 0;

if nargin == 1
    nDirsBeforeName = N_DIRS_BEFORE_NAME_DEFAULT;
else
    if ~isint(nDirsBeforeName)
        error('Error: ''nDirsBeforeName'' has to be an integer scalar');
    end
end

if ischar(in)
    out = getname(in, nDirsBeforeName);
elseif iscell(in) && is1d(in)
    nPaths = length(in);
    out = cell(size(in));
    for iPath = 1:nPaths
        out{iPath} = getname(in{iPath}, nDirsBeforeName);
    end
else
    error('Error: ''in'' must be: path to file OR cell of paths to files');
end

end

function name = getname(pathToSingleFile, nDirsBeforeName)
% Get name of file in path (including nDirsBeforeName, i.e. a number of
% directories in the path before the actual filename)

% Get number of file separators and check if valid nDirsBeforeName
nSeps = length(strfind(pathToSingleFile, filesep));

if nDirsBeforeName > nSeps
    error('Error: The maximum number of directories before the filename is %d', nSeps);
end

% Main algorithm
nIterations = nDirsBeforeName + 1;
token = cell(nIterations, 1);
remainder = cell(nIterations, 1);
name = fliplr(pathToSingleFile);
for i = 1:nIterations
    if i == 1
        [token{i}, remainder{i}] = strtok(name, filesep);
    else
        [token{i}, remainder{i}] = strtok(remainder{i-1}, filesep);
    end
end

name = fliplr(fullfile(token{:}));

end
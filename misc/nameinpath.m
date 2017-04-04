function [out] = nameinpath(in)
% nameinpath.m: isolates name of file(s) from its complete path(s)
%   
% Syntax:
%    1) [out] = nameinpath(in)
%
% Description:
%    1) [out] = nameinpath(in) isolates the name of one or more files from
%        their complete paths. 
%
% Inputs:
%    1) in:
%       - char: full path to a single file
%       - cell: "1D" cell with paths to multiple files
%
% Outputs:
%    1) out: same format as in:
%       - char: name of the single file
%       - cell: "1D" cell with names of the multiple files
%
% Notes/Assumptions: 
%    1) Note that the file extension will be attached to the file name
%
% Required functions:
%    []
%
% Required files:
%    []
%
% See also:
%    1) folderinpath.m
% 
% Examples:
%    []
%
% fnery, 20150725: original version
% fnery, 20160212: fixed documentation
% fnery, 20170318: now also accepts a cell of multiple paths as input

if ischar(in)
    out = getname(in);
elseif iscell(in) && is1d(in)
    nPaths = length(in);
    out = cell(size(in));
    for iPath = 1:nPaths
        out{iPath} = getname(in{iPath});
    end
else
    error('Error: ''in'' must be: path to file OR cell of paths to files');
end

end

function name = getname(pathToSingleFile)
name = fliplr(strtok(fliplr(pathToSingleFile), filesep));
end

end
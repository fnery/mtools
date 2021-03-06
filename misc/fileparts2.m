function [pathStr, name, ext] = fileparts2(in)
% fileparts2.m: extends fileparts.m
%
% Syntax:
%    1) [pathStr, name, ext] = fileparts2(in)
%
% Description:
%    1) [pathStr, name, ext] = fileparts2(in) extends fileparts.m providing
%        two additional features:
%        - works with .nii.gz files
%        - works with .tar.gz files
%        - accepts a cell of strings as input
%
% Inputs:
%    1) in: string corresponding to the complete file path or name
%           OR
%           cell of strings with multiple file paths
%
% Outputs:
%    1) pathStr: directory where the file lives
%    2) name   : file name, excluding extension
%    3) ext    : file extension
%    (strings or cells depending on input)
%
% Notes/Assumptions: 
%    1) Created specifically for some file types which have two extensions,
%       such as ".nii.gz" or ".tar.gz" files
%    2) Simply wraps around fileparts.m
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20170922: original version
% fnery, 20180511: bugfix
% fnery, 20180514: now works with .tar.gz files

if iscell(in)
    [pathStr, name, ext] = cellfun(@filepartswrap, in, 'UniformOutput', 0);
elseif ischar(in)
    [pathStr, name, ext] = filepartswrap(in);
else
    error('Error: input must be a string or a cell of strings');
end

end

function [pathStr, name, ext] = filepartswrap(in)

[pathStr , name  , ext ] = fileparts(in);
[      ~ , name2 , ext2] = fileparts(name);

if ~isempty(ext2) && (strcmp(ext2, '.nii') || strcmp(ext2, '.tar'))
    name = name2;
    ext = [ext2 ext];
end

end
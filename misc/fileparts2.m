function [pathStr, name, ext] = fileparts2(in)
% fileparts2.m: extends fileparts.m to work in files with 2 exts (e.g. .nii.gz)
%
% Syntax:
%    1) [pathStr, name, ext] = fileparts2(in)
%
% Description:
%    1) [pathStr, name, ext] = fileparts2(in) extends fileparts.m to work in
%        files with 2 exts (e.g. .nii.gz)
%
% Inputs:
%    1) in: string corresponding to the complete file path or name
%
% Outputs:
%    1) pathStr: directory where the file lives
%    2) name   : file name, excluding extension
%    3) ext    : file extension
%
% Notes/Assumptions: 
%    1) Created specifically for ".nii.gz" files
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

[pathStr , name  , ext ] = fileparts(in);
[      ~ , name2 , ext2] = fileparts(name);

if ~isempty(ext2)
    name = name2;
    ext = [ext2 ext];
end

end
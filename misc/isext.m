function out = isext(in, ext)
% isext.m: check if file matches extension(s)
%
% Syntax:
%    1) out = isext(in, ext)
%
% Description:
%    1) out = isext(in, ext) checks whether the file given in 'in' matches
%       the format(s) (i.e. extension(s)) given in 'ext'
%
% Inputs:
%    1) in: string (file path OR name+extension)
%    2) ext: can be:
%       - string (if one extension e.g. ext = '.jpg')
%       - cell   (if 2+ extensions e.g. ext = {'jpg', 'png'})
%
% Outputs:
%    1) out: logical scalar
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) fileparts2.m
%
% Required files:
%    []
%
% Examples:
%    % Check if files are .jpg only
%    isext('file.jpg', '.jpg')
%    isext('file.png', '.jpg')
%    isext('file.doc', '.jpg')
%    % Check if files are either .jpg or .png
%    isext('file.jpg', {'.jpg', '.png'})
%    isext('file.png', {'.jpg', '.png'})
%    isext('file.doc', {'.jpg', '.png'})
%    % OUTPUT 
%    %    a = 1
%    %    a = 0
%    %    a = 0
%    %    a = 1
%    %    a = 1
%    %    a = 0
%
% fnery, 20171103: original version

if ~ischar(in);
    error('Error: ''in'' must be a file path');
end

if ~ischar(ext) && ~iscell(ext);
    error('Error: ''ext'' must be a string or a cell of strings');
elseif ischar(ext)
    ext = {ext};
end

[~, ~, actualExt] = fileparts2(in);

if isempty(actualExt)
    error('Error: ''in'' must contain the file extension')
end
    
dotsIdxs = cellfun(@(c) strfind(c, '.'), ext, 'UniformOutput', false);
extsWithoutDots = any(cellfun(@isempty,dotsIdxs));

if extsWithoutDots
    error('Error: must include dots (.) in ''ext'' (i.e. ''.jpg'' not ''jpg''');
end

% Check how many of the EXPECTED_FILE_EXTS ext matches
matchingExt = cellfun(@(c) strcmp(c, actualExt), ext, 'UniformOutput', false);
nMatches = sum(cell2mat(matchingExt));

if nMatches == 1
    out = true;
else
    out = false;
end

end

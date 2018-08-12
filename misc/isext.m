function tf = isext(in, ext, throwError)
% isext.m: check if file matches extension(s)
%
% Syntax:
%    1) tf = isext(in, ext)
%    2) tf = isext(in, ext, throwError)
%
% Description:
%    1) tf = isext(in, ext)
%    2) tf = isext(in, ext, throwError) checks whether the file given in
%       'in' matches the format(s) (i.e. extension(s)) given in 'ext'.
%       If it matches: this function returns 'tf' = true
%       If it does not match, and:
%       - 'throwError' true: this throws an error.
%       - 'throwError' not provided or false: this returns 'tf' = false
%
% Inputs:
%    1) in: string (full filepath OR name+extension)
%    2) ext: can be:
%       - string (if one extension e.g. ext = '.jpg')
%       - cell   (if 2+ extensions e.g. ext = {'jpg', 'png'})
%    3) throwError (optional): logical scalar (default: false)
%
% Outputs:
%    1) tf: logical scalar
%
% Notes/Assumptions:
%    []
%
% References:
%    []
%
% Required functions:
%    1) fileparts2.m
%    2) cell2str.m
%
% Required files:
%    []
%
% Examples:
%    % Check if files are .jpg only
%    isext('file.jpg', '.jpg')                  % Ex 1
%    isext('file.png', '.jpg')                  % Ex 2
%    isext('file.doc', '.jpg')                  % Ex 3
%    % Check if files are either .jpg or .png
%    isext('file.jpg', {'.jpg', '.png'})        % Ex 4
%    isext('file.png', {'.jpg', '.png'})        % Ex 5
%    isext('file.doc', {'.jpg', '.png'})        % Ex 6
%    isext('file.doc', {'.jpg', '.png'}, true)  % Ex 7
%    % OUTPUT
%        >> a = 1                                              % Ex 1
%        >> a = 0                                              % Ex 2
%        >> a = 0                                              % Ex 3
%        >> a = 1                                              % Ex 4
%        >> a = 1                                              % Ex 5
%        >> a = 0                                              % Ex 6
%        >> Error using isext (line 102)                       % Ex 7
%        >> file.doc has invalid extension, should be one of:
%        >> .jpg
%        >> .png
%
% fnery, 20171103: original version
% fnery, 20180812: added 'throwError' option

% Init defaults and error checks
if nargin == 2
    throwError = false;
elseif not(nargin == 2 || nargin == 3)
    s1 = 'Syntax:';
    s2 = '    1) tf = isext(in, ext)';
    s3 = '    2) tf = isext(in, ext, throwError)';
    docStr = sprintf('%s\n%s\n%s', s1, s2, s3);
    error('This function requires 2 or 3 input arguments:\n%s', docStr);
end

if ~ischar(in)
    error('''in'' must be filepath OR name+extension');
end

if ~ischar(ext) && ~iscell(ext)
    error('''ext'' must be a string or a cell of strings');
elseif ischar(ext)
    ext = {ext};
end

[~, ~, inExt] = fileparts2(in);

if isempty(inExt)
    error('''in'' must contain a file extension')
end

dotsIdxs = cellfun(@(c) strfind(c, '.'), ext, 'UniformOutput', false);
extsWithoutDots = any(cellfun(@isempty,dotsIdxs));

if extsWithoutDots
    error('must include dots (.) in ''ext'' (i.e. ''.jpg'' not ''jpg''');
end

% Check how many of the EXPECTED_FILE_EXTS ext matches
matchingExt = cellfun(@(c) strcmp(c, inExt), ext, 'UniformOutput', false);
nMatches = sum(cell2mat(matchingExt));

if nMatches == 1
    tf = true;
elseif (nMatches == 0) && (throwError == false)
    tf = false;
elseif (nMatches == 0) && (throwError == true)
    error('%s has invalid extension, should be one of:\n%s', ...
        in, cell2str(ext, true));
end

end
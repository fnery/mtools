function tf = exist2(in, searchType, throwError)
% exist2.m: exist.m wrapper (common types + automatic error generation)
%
% Syntax:
%    1) tf = exist2(in, searchType)
%    2) tf = exist2(in, searchType, throwError)
%
% Description:
%    1) tf = exist2(in, searchType) checks if var/file/dir provided in 'in'
%       exists
%    2) tf = exist2(in, searchType, throwError) does the same as 1) but if
%       'throwError' is true, an error is thrown if ''in'' doesn't exist.
%
% Inputs:
%    1) in: full path to var/file/dir to test
%    2) searchType: string: one of: 'var', 'file' or 'dir'.
%    3) throwError: logical scalar (optional - default: false)
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
%    []
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180602: original version

VALID_TYPES = {'var', 'file', 'dir'};
CODE.var    = 1;
CODE.file   = 2;
CODE.dir    = 7;

if nargin ~= 2 && nargin ~= 3
    error('Error: ''exist2.m'' requires 2 or 3 input arguments');
end

if nargin == 2
    throwError = false;
end

if ~islogical(throwError) || ~isscalar(throwError)
    error('Error: ''throwError'' must be a logical scalar');
end

% Check if 'searchType' is valid
typeIsValid = ismember(searchType, VALID_TYPES);

if ~typeIsValid
    error('Error: invalid type - must be one of: ''var'', ''file'' or ''dir''.');
end

% Check if 'in' exists and is of the expected type
inExists = exist(in, searchType) == CODE.(searchType);

if ~inExists && throwError
    error('Error: %s ''%s'' doesn''t exist', searchType, in);
elseif ~inExists && ~throwError
    tf = false;
else
    tf = true;
end

end
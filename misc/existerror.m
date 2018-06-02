function existerror(in, searchType)
% existerror.m: check if var/file/dir exists - if not throw error
%
% Syntax:
%    1) existerror(in, searchType)
%
% Description:
%    1) existerror(in, searchType) checks if var/file/dir provided in 'in'
%       exists - if not throw error.
%
% Inputs:
%    1) in: full path to var/file/dir to test
%    2) searchType: string: one of: 'var', 'file' or 'dir'.
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

if nargin ~= 2
    error('Error: ''existerror.m'' requires two input arguments');
end

% Check if 'searchType' is valid
typeIsValid = ismember(searchType, VALID_TYPES);

if ~typeIsValid
    error('Error: invalid type - must be one of: ''var'', ''file'' or ''dir''.');
end

% Check if 'in' exists and is of the expected type
inExists = exist(in, searchType) == CODE.(searchType);

if ~inExists
    error('Error: %s ''%s'' doesn''t exist', searchType, in);
end

end
function out = filesepfix(in, platform)
% filesepfix.m: ensure input paths have separator suitable for a given system
%
% Syntax:
%    1) out = filesepfix(in)
%    2) out = filesepfix(in, platform)
%
% Description:
%    1) out = filesepfix(in) ensures input paths have separator suitable for 
%       the current system
%    2) out = filesepfix(in, platform) ensures input paths have separator
%       suitable for the system given by 'platform'
%
% Inputs:
%    1) in: input string or cell of strings
%    2) platform: input string, which can be:
%           - 'WIN': to get a windows filesep i.e. "\"
%           - 'UNIX': to get a unix filesep i.e. "/"
%
% Outputs:
%    1) out: output string
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) filesep2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20170914: original version
% fnery, 20171218: added 'platform' argin to specify output filesep type
% fnery, 20180220: now calls filesep2.m and 'PC' instances are replaced by 'WIN'
% fnery, 20180314: now works with cell of strings input

POSSIBLE_FILESEPS = '[\\//]';

if nargin == 1
    fSep = filesep2;
elseif nargin == 2
    if strcmp(platform, 'WIN')
        fSep = filesep2('WIN');
    elseif strcmp(platform, 'UNIX')
        fSep = filesep2('UNIX');
    else
        error('Error: ''platform'' must be either ''WIN'' or ''UNIX''')
    end
else
    error('Error: this function requires either 1 or 2 argins')
end

out = in;

if iscell(out)
    nStrings = numel(out);
    for iString = 1:nStrings
        cString = out{iString};
        cString(regexp(cString, POSSIBLE_FILESEPS)) = fSep; 
        out{iString} = cString;
    end
elseif ischar(out)
    out(regexp(in, POSSIBLE_FILESEPS)) = fSep; 
else
    error('Error: ''in'' must be a string or a cell of strings');
end
 
end
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
%    1) in: input string
%    2) platform: input string, which can be:
%           - 'PC': to get a windows filesep i.e. "\"
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
%    []
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20170914: original version
% fnery, 20171218: added 'platform' argin to specify output filesep type

POSSIBLE_FILESEPS = '[\\//]';

if nargin == 1
    fSep = filesep;
elseif nargin == 2
    if strcmp(platform, 'PC')
        fSep = '\';
    elseif strcmp(platform, 'UNIX')
        fSep = '/';
    else
        error('Error: ''platform'' must be either ''PC'' or ''UNIX''')
    end
else
    error('Error: this function requires either 1 or 2 argins')
end

out = in;
out(regexp(in, POSSIBLE_FILESEPS)) = fSep; 

end
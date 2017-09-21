function out = dropbox
% dropbox.m: retrieves path of main dropbox folder
%   
% Syntax:
%    1) out = dropbox
%
% Description:
%    1) out = dropbox retrieves path of main dropbox folder
%
% Inputs:
%    []
%
% Outputs:
%    1) out: (string) path of main dropbox folder
%
% Notes/Assumptions: 
%    1) Assumes that there is at least one path in current MATLAB search
%       path which contains 'Dropbox', so the output is extracted from the
%       string corresponding to that path
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
% fnery, 20170821: original version

TO_FIND = 'Dropbox';

p = path;

% Determine which path separator is used in the current system, typically
% ";" for windows and ":" for linux
pSep = pathsep;

% Get index of first character in 1st appearance of 'Dropbox'
startIdx = regexpi(p, TO_FIND);

if isempty(startIdx)
    error('Error: Couldn''t find a directory with ''%s'' in the path', TO_FIND);
end
    
startIdx(2:end) = []; 

% Get index of path separator immediately before 1st appearance of 'Dropbox'
pSepIdxs = regexpi(p, pSep);

if all(pSepIdxs>startIdx)
    % means "Dropbox" appears in the first path which never has a 'pSep' behind
    pSepIdxs = 0;
else
    pSepIdxs(pSepIdxs > startIdx) = [];
    pSepIdxs = pSepIdxs(end);
end

% Build output string based on above + length of 'Dropbox'
out = p(pSepIdxs+1:startIdx+length(TO_FIND)-1);

end
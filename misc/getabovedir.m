function [out] = getabovedir(in, n)
% getabovedir.m: returns path of directories closer to the root
%   
% Syntax:
%    1) out = getabovedir(in)
%    2) out = getabovedir(in, n)
%
% Description:
%    1) out = getabovedir(in) returns the path of 'in''s parent directory
%    2) out = getabovedir(in, n) same as 1) but 'nLevels' above
%
% Inputs:
%    1) in (char): input directory
%
% Outputs:
%    1) out (char): output directory
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
%    in = 'C:\Hello\World\Example\Directory';
%    1) [out] = getabovedir(in)
%        >> out = 'C:\Hello\World\Example'
%    2) [out] = getabovedir(in, 3)
%        >> out = 'C:\Hello'  
%
% fnery, 20130319: original version
% fnery, 20160326: now platform-independent 

if nargin == 0
    in = pwd;
    n = 1;
elseif nargin == 1
    n = 1;
end

reversedIn = fliplr(in);
sepIdxs    = strfind(reversedIn, filesep);
nSeps      = size(sepIdxs, 2);

if n > nSeps
    error('Error: for this ''in'', ''n'' can''t be larger than %d', nSeps)
end

limitSep = sepIdxs(n);
nCharsIn = size(in, 2);

firstIdxToDel = nCharsIn-limitSep+1;
out = in;
out(firstIdxToDel:end) = [];

end
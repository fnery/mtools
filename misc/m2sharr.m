function out = m2sharr(in)
% m2sharr.m: convert cell of strings to space-delimited list (like bash arrays)
%   
% Syntax:
%   1) out = m2sharr(in)
%
% Description:
%   1) out = m2sharr(in) takes a matlab cell (of strings) variable 
%      (e.g. filepaths), and converts it into a matlab variable with
%      all the strings separated by a space. 
%
% Inputs:
%   1) in: variable with matlab strings, which can be:
%      - a cell of strings
%      - a character array where each row is one string
%
% Outputs:
%   1) out: char row with space-delimited list of input strings
%
% Notes/Assumptions: 
%   1) This was created to use lists of strings in matlab as inputs to bash
%      functions called from within matlab with the "system" command
%
% References:
%   []
%
% Required functions:
%   []
%
% Required files:
%   []
% 
% Examples:
%   in = {'string1'; 'string2'; 'string3'};
%   out = m2sharr(in)
%   >> string1 string2 string3
%
% fnery, 20160219: original version

if iscell(in);
    % process cell input
    out = [];
    for i=1:length(in)
        cI = in{i};
        out = sprintf('%s %s', out, cI);
    end
elseif ischar(in)
    % process char input
    out = [];
    for i=1:size(in, 1)
        cI = in(i, :);
        out = sprintf('%s %s', out, cI);
    end
else
    % bad input type check
    error('Error: The input must be a cell of strings or char array');
end

end
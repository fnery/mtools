function out = uniquesubstr(in, delimiter)
% uniquesubstr.m: remove duplicate substrings from string 
%   
% Syntax:
%   1) out = uniquesubstr(in)
%   2) out = uniquesubstr(in, delimiter)
%
% Description:
%   1) out = uniquesubstr(in, delimiter) removes duplicate substrings from
%      input string ('in'), by default separated by the underscore character
%   2) out = uniquesubstr(in, delimiter) does the same as 1) but allows to
%      specify the 'delimiter' which separates the substrings of 'in'
%
% Inputs:
%   1) in (char): string to "crop"
%   2) delimiter (char): substring delimiter (default: '_')
%
% Outputs:
%   1) out (char): string with duplicate removed
%
% Notes/Assumptions: 
%   []
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
%   in = 'dti_b300_18dir_dti_b300_18dir_split_1_dti_b300_18newdir_split_1';
%   out = uniquesubstr(in)
%   >> out = dti_b300_18dir_split_1_18newdir
%
% fnery, 20170313: original version

if nargin == 1
    delimiter = '_';
end

splits = strsplit(in, delimiter);
splits = unique(splits, 'stable');

out = [sprintf('%s_', splits{1:end-1}), splits{end}];

end
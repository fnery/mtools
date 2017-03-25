function out = cellstrmatch(in, subStr, opt)
% cellstrmatch.m: create new cell from matching(or not) strings in input cell
%   
% Syntax:
%    1) out = cellstrmatch(in, subStr)
%    2) out = cellstrmatch(in, subStr, opt)
%
% Description:
%    1) out = cellstrmatch(in, subStr) creates a new cell with the strings
%       in the input cell 'in' that contain the sub-string 'substr'.
%    2) out = cellstrmatch(in, subStr, opt)
%           - if opt: true  - same as 1)
%           - if opt: false - creates a new cell with the strings in the 
%             input cell 'in' that DO NOT contain the sub-string 'substr'.
%
% Inputs:
%    1) in (cell): input cell of strings
%    2) subStr (char): substring to determine which strings to keep/remove
%    3) opt (logical): determines if we keep or remove the strings that
%       match ''subStr'
% 
% Outputs:
%    1) out (cell): reduced cell
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
%    IN = {'0020_ss'; ...
%          '0021_ns'; ...
%          '0022_di'; ...
%          '0023_ss'; ...
%          '0024_ns'; ...
%          '0025_di'};
%    SUB_STR = '_di_';
%    out1 = cellstrmatch(IN, SUB_STR, true)
%    out2 = cellstrmatch(IN, SUB_STR, false)
%    >> out1 = 
%    >>     '0022_di'
%    >>     '0025_di'
%    >> out2 = 
%    >>     '0020_ss'
%    >>     '0021_ns'
%    >>     '0023_ss'
%    >>     '0024_ns'
%
% fnery, 20170322: original version

if nargin == 2;
    opt = true;
end

if opt
    out = in(~cellfun('isempty', regexp(in, subStr)));
else
    out = in( cellfun('isempty', regexp(in, subStr)));
end
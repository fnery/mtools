function [path, name, ext] = filepartscell(in)
% filepartscell.m: extends matlab's fileparts for "cell of strings" inputs
%   
% Syntax:
%   1) [path, name, ext] = filepartscell(in)
%
% Description:
%   1) [path, name, ext] = filepartscell(in) simply uses cellfun.m together
%      with fileparts.m so that we can provide cell inputs
%
% Inputs:
%   1) in (cell): cell of strings (most likely full paths)
%
% Outputs:
%   (same as matlab's fileparts)
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
%   in = {'C:\Users\file1.txt', 'C:\Users\file2.txt', 'C:\Users\file3.txt'};
%   [a,b,c] = filepartscell(in)
%   >>
%   >> a = 
%   >>     'C:\Users'    'C:\Users'    'C:\Users'
%   >> b = 
%   >>     'file1'    'file2'    'file3'
%   >> c = 
%   >>     '.txt'    '.txt'    '.txt'
%
% fnery, 20160529: original version

[path, name, ext] = cellfun(@fileparts,in, 'UniformOutput', 0);

end
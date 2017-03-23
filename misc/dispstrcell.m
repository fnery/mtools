function out = dispstrcell(in, indent)
% dispstrcell.m: generate matlab code to re-create cell of strings variable
%   
% Syntax:
%    1) out = dispstrcell(in)
%    2) out = dispstrcell(in, indent)
%
% Description:
%    1) out = dispstrcell(in) displays a cell of strings formatted
%       with cell syntax. This allows to, for example, convert a cell of 
%       strings that was loaded manually to matlab "code". See example below.
%    2) out = dispstrcell(in, indent) does the same as 1) but allows to
%       control the indentation to generate vertically aligned code.
%
% Inputs:
%    1) in (cell): "1-D" cell where each element is a string
%
% Outputs:
%    1) out (char): matlab code to recreate 'in'
%
% Notes/Assumptions: 
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    1) Suppose we load the following cell manually (typical loading files):
%           testList = {'a'; 'b'; 'c'; 'd'}
%           testList = 
%           'a'
%           'b'
%           'c'
%           'd'
%       Now imagine we want to repeat this but don't want to load manually
%       again. Use this function (dispstrcell.m) to create a source code 
%       string to initialise this cell again
%           dispstrcell(testList,5)      
%           ans =      
%           {'a'; ...
%            'b'; ...
%            'c'; ...
%            'd'};
%       Now you can include this string in the code to generate the cell
%       variable automatically. 
%
% fnery, 20150923: original version
% fnery, 20160414: now also works with inputs with just one element

if nargin == 1
    indent = 0;
end

toIndent = repmat(' ', [1 indent]);

nSeries = length(in);

if nSeries < 2 
    out = sprintf('{''%s''};\n', in{1});
    return
end

out = '';
for iSeries = 1:nSeries
    cSeries = in{iSeries};
    if iSeries == 1 % first element
        out = sprintf('%s{''%s''; ...', out, cSeries);    
    elseif iSeries == nSeries % last element  
        out = sprintf('%s\n %s''%s''};\n', out, toIndent, cSeries);
    else % other elements    
        out = sprintf('%s\n %s''%s''; ...', out, toIndent, cSeries);
    end
end

end
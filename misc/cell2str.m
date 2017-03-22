function out = cell2str(in)
% cell2str.m: converts [n x 1] cell of strings to a [n x nChars] string
%   
% Syntax:
%    1) out = cell2str(in)
%
% Description:
%    1) out = cell2str(in) converts a [n x 1] cell of strings to a 
%      [n x nChars] string
%
% Inputs:
%    1) in: [n x 1] cell of strings
%
% Outputs:
%    1) out: [n x nChars] string
%
% Notes/Assumptions: 
%    1) Right pads each line so that in the end all lines have a length
%       equal to the longest line.
%    2) Created originally to help mimic the output of spm_select.m
%    3) Assumption 1: ''in'' must have only one column
%
% References:
%    []
%
% Required functions:
%    1) strpad.m
%
% Required files:
%    []
% 
% Examples:
%    in{1,1} = 'ababab';
%    in{2,1} = 'wow';
%    in{3,1} = 'longlinetoshowthespacepadding';
%    out = cell2str(in)
%    >> ababab                       
%       wow                            <-- note space-padding in lines 1,2
%       longlinetoshowthespacepadding
% 
% fnery, 20170309: original version

if ~iscell(in)
    error('Error: ''in'' must be a cell');
end

% Assumption 1
if size(in, 2) > 1
   error('Error: ''in'' must have only one column');
end 

nLines = size(in, 1);

% We'll have to pad the full files to the length of the longest fullpath
maxLen = max(cellfun('length',in));

out = '';
for iLine = 1:nLines
    cLine = in{iLine}; % Assumption 1
    cLine = strpad(cLine, maxLen);
    out(iLine,:) = cLine;
end
    
end
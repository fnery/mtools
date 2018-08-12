function out = cell2str(in)
% cell2str.m: converts "1D" cell of strings to [n x nChars] string
%
% Syntax:
%    1) out = cell2str(in)
%
% Description:
%    1) out = cell2str(in) converts "1D" cell of strings to [n x nChars]
%       string
%
% Inputs:
%    1) in: "1D" cell of strings
%
% Outputs:
%    1) out: [n x nChars] string, where 'n' is length(in)
%
% Notes/Assumptions:
%    1) Right pads each line so that in the end all lines have a length
%       equal to the longest line.
%    2) Created originally to help mimic the output of spm_select.m
%    3) Assumption 1: ''in'' must have only one column OR one line (i.e. 
%       must be a "1D" vector (see is1d.m)
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%    2) strpad.m
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
% fnery, 20180812: now accepts both row and column cell vectors

if ~iscell(in) || ~is1d(in)
    error('''in'' must be a "1D" cell of strings');
end

nStrings = length(in);

% We'll have to pad the full files to the length of the longest fullpath
maxLen = max(cellfun('length',in));

out = '';
for iString = 1:nStrings
    cString = in{iString}; % Assumption 1
    cString = strpad(cString, maxLen);
    out(iString,:) = cString;
end

end
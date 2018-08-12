function out = cell2str(in, doNewLines)
% cell2str.m: converts "1D" cell of strings to string
%
% Syntax:
%    1) out = cell2str(in)
%    2) out = cell2str(in, doNewLines)
%
% Description:
%    1) out = cell2str(in) converts "1D" cell of strings to string
%    2) out = cell2str(in, doNewLines) does the same as 1) but allows to
%       the format of the output string (see Outputs and Examples)
%
% Inputs:
%    1) in: "1D" cell of strings
%    2) doNewLines (optional): logical scalar (default: false)
%
% Outputs:
%    1) out: string, with format
%       - [n x nChars] if 'doNewLines' is false, where 'n' is length(in)
%       - [1 x nChars] if 'doNewLines' is true
%
% Notes/Assumptions:
%    1) Right pads each line so that in the end all lines in the output
%       string have a length equal to the longest line.
%    2) Created originally to help mimic the output of spm_select.m (when
%       'doNewLines' is false)
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
%     % Initialise 'in'
%     in{1} = 'ababab';
%     in{2} = 'wow';
%     in{3} = 'longlinetoshowthespacepadding';
%     % Example 1: 'doNewLines' false
%     out = cell2str(in, false)
%     whos out
%         >> out =
%         >>     'ababab                       '
%         >>     'wow                          '
%         >>     'longlinetoshowthespacepadding'
%         >>   Name      Size            Bytes  Class    Attributes
%         >>   out       3x29              174  char
%     % Example 2: 'doNewLines' true
%     out = cell2str(in, true)
%     whos out
%         >> out =
%         >>     'ababab                       <-- note space-padding
%         >>      wow                          <-- note space-padding
%         >>      longlinetoshowthespacepadding'
%         >>   Name      Size            Bytes  Class    Attributes
%         >>   out       1x89              178  char
%
% fnery, 20170309: original version
% fnery, 20180812: now accepts both row and column cell vectors
%                  added 'doNewLines' option

if nargin == 1
    doNewLines = false;
end

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

    if doNewLines
        out = sprintf('%s\n%s', out, cString);
        if iString == 1
            out(1) = [];
        end
    else
        out(iString,:) = cString;
    end

end

end
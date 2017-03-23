function out = cleanstr(in)
% cleanstr.m: replace spaces by underscores and remove non-alphanum chars
%   
% Syntax:
%    1) out = cleanstr(in)
%
% Description:
%    1) out = cleanstr(in) replaces spaces by underscores and removes
%       non-alphanum chars
%
% Inputs:
%    1) in (char): input string
%
% Outputs:
%    1) out (char): cleaned string
%
% Notes/Assumptions: 
%    1) Useful to generate file names
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
%    in = sprintf('   h$el''l\t*o{+@ w()orl-|d   123 ');
%    out = cleanstr(in)
%    >> out =
%    >> hello_world___123
%
% fnery, 20170309: original version

% Remove leading and trailing white space from string
out = strtrim(in);

% Replace spaces with underscores
out = strrep(out, ' ', '_');

% Remove all non-alphanumeric characters except underscores
toKeep = isstrprop(out, 'alphanum');
toKeep(strfind(out, '_')) = 1;
out(~toKeep) = [];

end
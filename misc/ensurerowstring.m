function out = ensurerowstring(in)
% ensurerowstring.m: ensure row string (i.e. readable) (transpose if needed)
%   
% Syntax:
%    1) out = ensurerowstring(in)
%
% Description:
%    1) out = ensurerowstring(in) ensures 'in' is a row string vector. 
%       If it's not it transposes it so that it becomes one
%
% Inputs:
%    1) in: input "1D" string
%
% Outputs:
%    1) out: output row string vector
%
% Notes/Assumptions: 
%    1) Useful to ensure strings are readable
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20160330: original version

% Make sure we are dealing with either a row or column vector
if ~is1d(in)
    error('Error: ''in'' isn''t a row or column string');
end

% Transpose if needed
if size(in, 1) > 1
    out = in';
else
    out = in;
end

end
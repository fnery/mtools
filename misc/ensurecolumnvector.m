function out = ensurecolumnvector(in)
% ensurecolumnvector.m: ensure input is a column vector (transpose if needed)
%   
% Syntax:
%    1) out = ensurecolumnvector(in)
%
% Description:
%    1) out = ensurecolumnvector(in) ensures 'in' is a column vector. 
%       If it's not it transposes it so that it becomes one (after checking
%       it's not a 2+D matrix
%
% Inputs:
%    1) in: input "1D" vector
%
% Outputs:
%    1) out: output column vector
%
% Notes/Assumptions: 
%    1) Useful to ensure inputs for "fit.m" are columns
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
%    1) >> in = zeros(1,2)
%       >> out = ensurecolumnvector(in)
%       in =
%            0     0
%       out =
%            0
%            0
%    2) >> in = zeros(2,1)
%       >> out = ensurecolumnvector(in)
%       in =
%            0
%            0
%       out =
%            0
%            0
%    3) >> in = zeros(2,2)
%       >> out = ensurecolumnvector(in)
%       in =
%            0     0
%            0     0
%       Error using ensurecolumnvector (line 59)
%       Error: 'in' isn't a row or column vector
%
% fnery, 20160330: original version

% Make sure we are dealing with either a row or column vector
if ~is1d(in)
    error('Error: ''in'' isn''t a row or column vector');
end

% Transpose if needed
if size(in, 2) > 1
    out = in';
else
    out = in;
end

end
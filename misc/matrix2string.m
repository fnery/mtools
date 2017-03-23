function out = matrix2string(in, nSpaces, fmt)
% matrix2string.m: converts 2D matrix to text (figure displaying purposes)
%   
% Syntax:
%   1) out = matrix2string(in)
%   2) out = matrix2string(in, nSpaces)
%   3) out = matrix2string(in, nSpaces, fmt)
%
% Description:
%   1) out = matrix2string(in) converts 2D matrix to text for figure
%      displaying purposes
%   2) out = matrix2string(in, nSpaces) does the same as 1) but allows to 
%      specify the number of spaces between columns of the matrix
%   3) out = matrix2string(in, nSpaces, fmt) does the same as 2) but allows 
%      to specify the format ('fmt') to use for displaying the elements of
%      matrix
%
% Inputs:
%   1) in (numeric): 2D matrix
%   2) nSpaces (integer): number of spaces between columns of the matrix
%   3) fmt (char): formatting specification (FormatSpec, see e.g. sprintf.m)
%
% Outputs:
%   1) out: matrix in char type
%
% Notes/Assumptions: 
%   1) Created for displaying matrices as text next to plots / images,
%      while keeping the matrix dimensions 
%   2) MATLAB's mat2str.m not suitable for 1)
%
% References:
%   []
%
% Required functions:
%   1) isint.m
%
% Required files:
%   []
% 
% Examples:
%    in = randn(3)
%    out1 = matrix2string(in)
%    out2 = matrix2string(in, 10)
%    out3 = matrix2string(in, 4, '%.6f')
%    >> out1 =
%    >>   0.33 -1.71  0.32
%    >>  -0.75 -0.10  0.31
%    >>   1.37 -0.24 -0.86
%    >> out2 =
%    >>   0.33          -1.71           0.32
%    >>  -0.75          -0.10           0.31
%    >>   1.37          -0.24          -0.86
%    >> out3 =
%    >>   0.325191    -1.711516     0.319207
%    >>  -0.754928    -0.102242     0.312859
%    >>   1.370299    -0.241447    -0.864880
%
% fnery, 20160825: original version
% fnery, 20161118: added 'nSpaces' option
% fnery, 20170323: removed the last newline from 'out'

% Defaults
if nargin < 3
    fmt = '%2.2f';
end
if nargin < 2
    nSpaces = 1;
end
if nargin < 1 || nargin > 3
    error('Error: wrong number of input arguments');
end

% Type checks
if ~isint(nSpaces)
    error('Error: ''nSpaces'' must be an integer number');
end
if ~ischar(fmt)
    error('Error: ''fmt'' must be a (FormatSpec) string');
end

% Main algorithm
space  = ' ';
spaces = repmat(space, [1 nSpaces]);

fmt = [fmt spaces]; % add in spaces

tmp = char(num2str(in, fmt));

out = [];
for iLine = 1:size(tmp, 1)
    out = sprintf('%s%s\n', out, tmp(iLine,:));
end

out(end) = [];

end
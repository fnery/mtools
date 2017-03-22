function [out] = is1d(in, flagDisplayWarnings)
% is1d.m: check if input is 1D "vector"
%   
% Syntax:
%    1) [out] = is1d(in)
%    2) [out] = is1d(in, flagDisplayWarnings)
%
% Description:
%    1) [out] = is1d(in) checks if input is 1D vector
%    2) [out] = is1d(in, flagDisplayWarnings) does the same as 1) but allows
%               to control whether the warnings are displayed. The default
%               behaviour is to display warnings, but this may be
%               problematic in functions which call this function and print
%               text in the command line (e.g. structcontents.m)
%
% Inputs:
%    1) in: numeric/logical input 
%    2) flagDisplayWarnings can be:
%           0 --> warnings are not displayed
%           1 --> warnings are displayed (default)
%
% Outputs:
%    1) out: logical
%
% Notes/Assumptions: 
%    1) In this function, column or row vectors, i.e. [Nx1] or
%       [1xN] are considered "1D" vectors. I know MATLAB 'a' 2D if a=1,
%       but in some cases I need to know whether I am dealing with a single
%       number, column or row vector
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    >> is1d(zeros(1, 3))
%    >> is1d(zeros(1, 1))
%    >> is1d(zeros(3, 1))
%    >> is1d(zeros(3, 2))
%       ans = 1
%       ans = 1
%       ans = 1
%       ans = 0
%                    
% fnery, 20150817: original version
% fnery, 20150825: instead of displaying an error and stopping the function
%                  when checking for numeric/logical, return false and
%                  display warning (to avoid stopping some functions)
% fnery, 20170315: now allows char inputs

% Define default value for flagDisplayWarnings
if nargin == 1;
    flagDisplayWarnings = 1;
end

% Check whether 'in' is a number (including logical 1's or 0's) or char
if ~(isnumeric(in) || islogical(in) || ischar(in) || iscell(in))
    if flagDisplayWarnings
        warning('Warning: Input isn''t a numeric, logical, char or cell')
    end
    out = false;
    return;
end

% To be 1D, as defined in assumption 1, in must be "2D" or less:
if ~ismatrix(in)
    out = false;
    return;
end

nRows = size(in, 1);
nCols = size(in, 2);
isColVector = (nRows >  1 && nCols == 1);
isRowVector = (nRows == 1 && nCols >  1);
isSingleVal = (nRows == 1 && nCols == 1);

% For 'in' to be 1D, one of the above conditions must be met
if isColVector || isRowVector || isSingleVal
    out = true;
else
    out = false;
end
    
end
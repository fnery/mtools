function [str] = vec2str(vec, fmt)       
% vec2str.m: converts a 1D-vector to a string
%   
% Syntax:
%    1) [str] = vec2str(vec)
%    2) [str] = vec2str(vec, fmt)
%
% Description:
%    1) [str] = vec2str(vec) converts a 1D-vector ('vec') to a string
%    2) [str] = vec2str(vec, fmt) does the same as 1) but allows the user 
%       to specify the format ('fmt') to use for displaying the elements of
%       vector
%
% Inputs:
%    1) vec: numeric vector
%    2) fmt (char): formatting specification (FormatSpec, see e.g. sprintf.m)
% 
% Outputs:
%    1) str (char): input vector in char format (e.g. to append to strings)
%
% Notes/Assumptions: 
%    []
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
%    vec = 100*rand(3,1);
%    vec2str(vec)         % convert with default format
%    vec2str(vec, '%f')   % convert with user-defined format
%    >> ans =
%    >> [9.65e+01, 1.58e+01, 9.71e+01]
%    >> ans =
%    >> [96.488854, 15.761308, 97.059278]
%
% fnery, 20130319: original version
% fnery, 20160911: added 2nd argin 'fmt'

%#ok<*INUSL> % Switch off warning saying 'vec' not used (it's used in eval)

% Default format (fmt)
if nargin == 1
    fmt = '%2.2d'; 
end

% Convert to string
str = sprintf('str = strrep([''['' sprintf(''%s, '', vec) '']''], '']'', '']'');', fmt);
eval(str);
str(end-2:end-1) = [];

end
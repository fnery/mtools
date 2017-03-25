function [out] = isallequal(in)
% isallequal.m: checks if all elements in the array are equal
%   
% Syntax:
%    1) [out] = isallequal(in)
%
% Description:
%    1) [out] = isallequal(in) checks if all elements in the input array
%       'in' are equal
%
% Inputs:
%    1) in (numeric/char): array
%
% Outputs:
%    1) out (logical): 
%        - 1 (true)  : all elements of 'in' are equal
%        - 0 (false) : otherwise
%
% Notes/Assumptions: 
%    1) I could make this work with cells but haven't had the time to do so
%       just yet
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    in = ones(2,2)
%    isallequal(in)
%    in(2,1) = 0;
%    isallequal(in)
%    >> isallequal(in)
%    >> in =
%    >>      1     1
%    >>      1     1
%    >> ans =
%    >>      1
%    >> in =
%    >>      1     1
%    >>      0     1
%    >> ans =
%    >>      0
%
% fnery, 20150820: original version
% fnery, 20170325: added valid input checks

if iscell(in) || isstruct(in)
   error('Error: ''in'' must be a numeric or char array'); 
end

in  = in(:);
out = all(in == in(1));

end
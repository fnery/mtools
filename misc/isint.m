function [out] = isint(in)
% isint.m: checks if the input is an integer
%   
% Syntax:
%    1) [out] = isint(in)
%
% Description:
%    1) isint: checks if the input is an integer because matlab's isinteger
%    function tests the type of an element, rather than the value
%
% Inputs:
%    1) in: numeric
%
% Outputs:
%    1) out (logical): 1 if 'in' is an integer, 0 otherwise
%
% Notes/Assumptions: 
%    1) Not as strict as matlab's isinteger.m. This one was purposely coded
%       to return true if provided inputs are integers, even if they are type
%       single/double. 
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    in = 2;
%    isinteger(in) % matlab's function
%    isint(in)     % this function
%    >> ans =
%    >>   logical
%    >>    0
%    >> ans =
%    >>   logical
%    >>    1
%
% fnery, 20150729: original version
% fnery, 20170322: updated documentation

out = isfinite(in) & isreal(in) & (in == floor(in));
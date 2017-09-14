function out = filesepfix(in)
% filesepfix.m: ensure hardcoded paths have separator suitable for current system
%
% Syntax:
%    1) out = filesepfix(in)
%
% Description:
%    1) out = filesepfix(in) ensures hardcoded paths have separator suitable 
%       for current system
%
% Inputs:
%    1) in: input string
%
% Outputs:
%    1) out: output string
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
%    []
%
%
% fnery, 20170914: original version

POSSIBLE_FILESEPS = '[\\//]';

out = in;
out(regexp(in, POSSIBLE_FILESEPS)) = filesep; 

end
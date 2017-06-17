function out = cf
% cf: [c]urrent [f]older - dir where calling function lives
% 
% Syntax:
%    1) out = cf
%
% Description:
%    1) out = cf provides a robust way (or so it seems) to get the 
%       directory where the function that called this function lives
%
% Inputs:
%    []
%
% Outputs:
%    1) out: directory where the function that called this function lives
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) folderinpath.m
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20160704: original version

STACK_POS = 2;

[St, ~] = dbstack('-completenames');

out = folderinpath(St(STACK_POS).file);

end
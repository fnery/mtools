function out = authstr(in)
% authstr.m: creates author string for function documentation
%   
% Syntax:
%    1) out = authstr(in)
%
% Description:
%    1) out = authstr(in) creates author string for function documentation
%
% Inputs:
%    1) in (char): message to include in the author string
%
% Outputs:
%    1) out (char): author string
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) ctime.m
%
% Required files:
%    []
% 
% Examples:
%    out = authstr('hello world')
%        >> % fnery, 20160329: hello world
%
% fnery, 20160329: original version

AUTH         = 'fnery';
DEFAULT_MSG  = 'original version';

if nargin == 0
    in = DEFAULT_MSG;
end

% Time stamp
t = ctime;
t = t(1:8);

out = sprintf('%% %s, %s: %s', AUTH, t, in);

end
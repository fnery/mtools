function out = authstr(msg, auth)
% authstr.m: creates author string for function documentation
%   
% Syntax:
%    1) out = authstr(msg)
%    2) out = authstr(msg, auth)
%
% Description:
%    1) out = authstr(msg) creates author string for function documentation
%    2) out = authstr(msg, auth) does the same as 1) but allows to specify
%       the author's id
%
% Inputs:
%    1) msg  (char): message to include in the author string
%    1) auth (char): author's id
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
%    out = authstr('added auth argin', '<name here>')
%        >> <name here>, 20170323: added auth argin
%
% fnery, 20160329: original version
% fnery, 20170323: added auth argin

% Defaults 
AUTH         = 'fnery';            % default for auth
DEFAULT_MSG  = 'original version';

if nargin < 2
    auth = AUTH;
end
if nargin < 1
    msg = DEFAULT_MSG;
end
if nargin > 2 
    error('Error: too many input arguments');
end

% Time stamp
t = ctime;
t = t(1:8);

out = sprintf('%% %s, %s: %s', auth, t, msg);

end
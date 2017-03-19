function cTime = ctime(fmt)
% ctime: creates string with current date-time (yyyymmdd_hhmmss[fff])
%   
% Syntax:
%    1) cTime = ctime;
%    2) cTime = ctime(fmt);
%
% Description:
%    1) cTime = ctime; creates string with current date-time with default
%       format 'yyyymmdd_hhmmss'
%    2) cTime = ctime(fmt); same as 1) but user can specify format ('fmt')
%
% Inputs:
%    1) fmt (char):
%       'ymdhms'  - output format 'yyyymmdd_hhmmss'
%       'ymdhmsf' - output format 'yyyymmdd_hhmmssfff' (includes millisecs)
%
% Outputs:
%    1) cTime (char): date-time
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
%     >> ctime
%        ctime('ymdhmsf')
%     ans =
%         20150506_100403
%     ans =
%         20150506_100403347
% 
% fnery, 20150506: original version

VALID_FORMATS{1} = 'ymdhms';
VALID_FORMATS{2} = 'ymdhmsf';

% Default format
if nargin == 0
    fmt = VALID_FORMATS{1};
end

% Check provided 'fmt' is valid
if ~ismember(fmt, VALID_FORMATS)
    error('Error: ''fmt'' must be either ''%s'' or ''%s''', ...
        VALID_FORMATS{1}, VALID_FORMATS{2});
end

% Create date-time string
%     - spaces become underscores
%     - '-' and ':' are removed
if strcmp(fmt, VALID_FORMATS{1})
    cTime = datestr(clock, 'yyyy-mm-dd HH:MM:SS');
    cTime(11) = '_';
    cTime([5,8, 14, 17]) = [];
elseif strcmp(fmt, VALID_FORMATS{2})
    cTime = datestr(clock, 'yyyy-mm-dd HH:MM:SS:FFF');
    cTime(11)            = '_';
    cTime([5,8, 14, 17, 20]) = [];
else
    error('Error: this point should never be reached');
end

end
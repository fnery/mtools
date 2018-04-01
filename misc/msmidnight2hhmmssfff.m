function hhmmssfff = msmidnight2hhmmssfff(msSinceMidnight)
% msmidnight2hhmmssfff.m: convert milisseconds since midnight to hh:mm:ss:fff
%
% Syntax:
%    1) hhmmssfff = msmidnight2hhmmssfff(msSinceMidnight)
%
% Description:
%    1) hhmmssfff = msmidnight2hhmmssfff(msSinceMidnight) converts a number of
%       milisseconds elapsed since midnight to a string with format hh:mm:ss:fff
%
% Inputs:
%    1) msSinceMidnight: number of milisseconds since midnight
%
% Outputs:
%    1) hhmmssfff: string with format hh:mm:ss:fff
%
% Notes/Assumptions: 
%    1) Used to convert Siemens .resp log timing variables (e.g. LogStartMDHTime
%       to a more human-readable format
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
%    % As of writing this the time is 18:37:23:987
%    % The following expression calculates the number of milisseconds elapsed
%    % since midnight:
%    % (18*(60*60*1000))+(37*(60*1000))+(23*1000)+987 = 67043987
%    % Running this function on this result takes us back to the original time 
%    % format:
%    msmidnight2hhmmssfff(67043987)
%    % which indeed yields 18:37:23:987
%
% fnery, 20180331: original version

MSEC_TO_SEC_FACTOR = 1e-3;
SEC_TO_MIN_FACTOR  = 1/60;
MIN_TO_H_FACTOR    = 1/60;

sec  = msSinceMidnight*MSEC_TO_SEC_FACTOR;
msec = round(mod(sec, 1)/MSEC_TO_SEC_FACTOR);
sec  = floor(sec);

min = sec*SEC_TO_MIN_FACTOR;
sec = round(mod(min, 1)/SEC_TO_MIN_FACTOR);
min = floor(min);

h   = min*MIN_TO_H_FACTOR;
min = round(mod(h, 1)/MIN_TO_H_FACTOR);
h   = floor(h);

hhmmssfff = sprintf('%02d:%02d:%02d:%03d', h, min, sec, msec);

end
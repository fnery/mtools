function res = yyyymmdddiff(yyyymmdd1, yyyymmdd2)
% yyyymmdddiff.m: difference (days) between two dates of format 'yyyymmdd' 
%   
% Syntax:
%    1) res = yyyymmdddiff(yyyymmdd1, yyyymmdd2)
%
% Description:
%    1) res = yyyymmdddiff(yyyymmdd1, yyyymmdd2) computes the difference, 
%       in days, between two dates of format yyyymmdd 
%
% Inputs:
%    1) yyyymmdd1: date 1 in format 'yyyymmdd'
%    2) yyyymmdd2: date 2 in format 'yyyymmdd'
%
% Outputs:
%    1) res: difference (days) between the two dates
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
%    >> sDate = 20121208;
%    >> eDate = 20131208;
%    >> res = yyyymmdddiff(sDate, eDate)
%           res = 365
%
% fnery, 20151016: original version

% ======================================================
% ===== Convert to suitable format for subtraction ===== ------------------
% ======================================================

% Date 1
if isnumeric(yyyymmdd1)
    tmp = num2str(yyyymmdd1);
end
tmp = strcat(tmp(1:4),'.',tmp(5:6),'.',tmp(7:8));
d1 = datenum(tmp,'yy.mm.dd');

% Date 2
if isnumeric(yyyymmdd2)
    tmp = num2str(yyyymmdd2);
end
tmp = strcat(tmp(1:4),'.',tmp(5:6),'.',tmp(7:8));
d2 = datenum(tmp,'yy.mm.dd');

% ====================
% ===== Subtract ===== ----------------------------------------------------
% ====================

res = abs(d1-d2); 

end
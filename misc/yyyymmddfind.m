function [dates, startIdxs] = yyyymmddfind(str)
% yyyymmddfind.m: finds and extracts date substrings of format 'yyyymmddfind'
%   
% Syntax:
%    1) [dates, startIdxs] = yyyymmddfind(str)
%
% Description:
%    1) [dates, startIdxs] = yyyymmddfind(str) uses regular expressions to 
%       find and extract date substrings of format 'yyyymmddfind'
%
% Inputs:
%    1) str (char): input string
%
% Outputs:
%    1) dates (cell): 'yyyymmdd' date substrings 
%    2) startIdxs (integer): start indexes of the date substrings
%
% Notes/Assumptions: 
%   1) Considers all days from 01-31 so may include impossible dates
%      such as 20130231 (Feb with 31 days!).
%
% References:
%   []
%
% Required functions:
%   []
%
% Required files:
%   []
% 
% Examples:
%    >> str = 'a string withdates123201509254fd201703254';
%    >> [dates, startIdxs] = yyyymmddfind(str)
%    dates =
%        1×2 cell array
%            '20150925'    '20170325'
%    startIdxs =
%        22    33
%
% fnery, 20150925: original version
% fnery, 20170325: now processes inputs with more than one date substrings

REG_EXP = '(19\d{2}|20\d{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])';

if ~ischar(in)
    error('Error: ''in'' must be a string');
end

startIdxs = regexp(str, REG_EXP);
nDates = length(startIdxs);

dates = cell(1, nDates);
for iDate = 1:nDates
    cDate = str(startIdxs(iDate):startIdxs(iDate)+7);
    dates{iDate} = cDate;
end

end
function out = dcmsiemensisolateascconv(in)
% dcmsiemensisolateascconv.m: isolates ASCCONV part in Siemens CSA headers
%   
% Syntax:
%    1) out = dcmsiemensisolateascconv(in)
%     
% Description:
%    1) out = dcmsiemensisolateascconv(in) isolates the string delimited by
%      the following substrings:
%      - ### ASCCONV BEGIN ###
%      - ### ASCCONV END ###
%      within the part in Siemens CSA headers, which corresponds to the more
%      "parseable" part of this private header
%
% Inputs:
%    1) in: complete CSA header string, extracted outside of this function
%
% Outputs:
%    1) out: ASCCONV-delimited portion of the complete Siemens CSA header
%
% Notes/Assumptions: 
%    1) The ### ASCCONV BEGIN ### and ### ASCCONV END ### substrings do not
%       necessarily only appear once in the file. Hopefully this is dealt
%       with, but additional files may have other types of inconsistencies,
%       so keep an eye on this
%    2) Only tested in VB17 data
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
% fnery, 20170314: original version

if ~ischar(in)
    error('Error: ''in'' must be the complete Siemens CSA header (string)');
end

tmp1 = strfind(in, '### ASCCONV BEGIN ###');
tmp2 = strfind(in, '### ASCCONV END ###');

lTmp1 = length(tmp1);
lTmp2 = length(tmp2);

% In some files, the string '### ASCCONV END ###' appears twice, one of
% those times before '### ASCCONV BEGIN ###'. 
% I also saw '### ASCCONV BEGIN ###' appearing after '### ASCCONV END ###'

if lTmp1 == 0
    error('Error: Couldn''t find ''### ASCCONV BEGIN ###''');
elseif lTmp1 > 1
    tmp1 = min(tmp1);
elseif lTmp1 == 1
    % looks good
else
    error('Error: this point should never be reached');
end

if lTmp2 == 0
    error('Error: Couldn''t find ''### ASCCONV END ###''');
elseif lTmp2 > 1
    tmp2(tmp2 <= tmp1) = [];
    tmp2 = min(tmp2);
elseif lTmp2 == 1
    % looks good
else
    error('Error: this point should never be reached');
end

% Only save ASCCONV part
out = in((tmp1+22):tmp2-2);

end
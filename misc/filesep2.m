function f = filesep2(platform)
% filesep2.m: extends filesep.m (user can specify platform)
%
% Syntax:
%    1) f = filesep2
%    2) f = filesep2(platform)
%
% Description:
%    1) f = filesep2(platform) extends filesep.m by allowing the user to
%       specify the platform for which the output file separator is compatible
%
% Inputs:
%    1) platform (optional): string which can be 'WIN' or 'UNIX'
%
% Outputs:
%    1) f: file separator character for current or specified platform
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
% fnery, 20180220: original version

if nargin == 0
    % just a regular call to filesep
    f = filesep;
elseif nargin == 1
    % user-specified platform
    if strcmp(platform, 'WIN')
        f = '\';
    elseif strcmp(platform, 'UNIX')
        f = '/';    
    else
        error('Error: ''platform'' must be ''WIN'' or ''UNIX''');
    end
end

end
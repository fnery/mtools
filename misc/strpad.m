function str = strpad(str, maxLen, opt)
% strpad.m: pad string with spaces to achieve a certain length
%   
% Syntax:
%    1) str = strpad(str, maxLen)
%    2) str = strpad(str, maxLen, opt)
%
% Description:
%    1) str = strpad(str, maxLen) pads the string 'str' with spaces to 
%       achieve a specific length ('maxLen'), the spaces are added on the
%       right
%    2) str = strpad(str, maxLen, opt) does the same as 1) but the 
%       argin 'opt' must be:
%       - 'right': to add spaces on the right
%       - 'left': to add spaces on the left
%
% Inputs:
%    1) str: string to pad
%    2) maxLen: desired maximum length of the string
%    3) opt: controls in which side of the string the spaces are added
%       - 'right': to add spaces on the right
%       - 'left': to add spaces on the left
%
% Outputs:
%    1) str: padded string
%
% Notes/Assumptions: 
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
% fnery, 20150813: original version

if nargin == 2
    opt = 'right';
end

% Create substring composed of spaces to pad
if strcmp(opt, 'right')
    pad = ['%-', num2str(maxLen),'s'];
elseif strcmp(opt, 'left')
    pad = ['%', num2str(maxLen),'s'];
else
    error('Error: ''opt'' must be either ''left'' or ''right''');
end

% Pad original string
str = sprintf(pad, str);

end
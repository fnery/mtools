function out = textheading(in)
% textheading.m: creates a text heading/separator string for documentation
%   
% Syntax:
%    1) out = textheading(in)
%
% Description:
%    1) out = textheading(in) creates a text heading/separator string for
%       documentation
%
% Inputs:
%    1) in: string with heading text
%
% Outputs:
%    1) out: complete heading/separator string (block)
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
%    >> in = 'hello world';
%    >> out = textheading(in)
%           out =
%           =======================
%           ===== hello world ===== ---------------------------------------
%           =======================
%
% fnery, 20151011: original version
% fnery, 20170309: added '%' at the beginning of the lines
%                  added hyphen separator

% Constants
BOX_THICKNESS = 5;
LINE_SEPARATOR_NCHARS = 75;

if nargin ~= 1
    error('Error: ''textheading.m'' needs one input argument');
end

% Create 'out' string
lenIn = length(in);
lenBounds = (BOX_THICKNESS*2)+2+lenIn;
bounds = repmat('=', [1, lenBounds]);
middle = repmat('=', [1, BOX_THICKNESS]);
out = sprintf('%% %s\n%% %s %s %s\n%% %s', ...
    bounds, middle, in, middle, bounds);

% Now add hyphens separator, not pretty
percents = strfind(out, '%');
x = percents(2)-2;
hyphensToAdd = LINE_SEPARATOR_NCHARS - x - 1;
hyphensToAdd = repmat('-', [1, hyphensToAdd]);

out = sprintf('%% %s\n%% %s %s %s %s\n%% %s', ...
    bounds, middle, in, middle, hyphensToAdd, bounds);

end
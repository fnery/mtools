function [out] = isallequal(in)
% isallequal.m: checks if all elements in input array are equal
%
% Syntax:
%    1) [out] = isallequal(in)
%
% Description:
%    1) [out] = isallequal(in) checks if all elements in the input array
%       'in' are equal
%
% Inputs:
%    1) in (numeric/char/cell): array
%
% Outputs:
%    1) out (logical):
%        - 1 (true)  : all elements of 'in' are equal
%        - 0 (false) : otherwise
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
%    in = ones(2,2)
%    isallequal(in)
%    in(2,1) = 0;
%    isallequal(in)
%    >> isallequal(in)
%    >> in =
%    >>      1     1
%    >>      1     1
%    >> ans =
%    >>      1
%    >> in =
%    >>      1     1
%    >>      0     1
%    >> ans =
%    >>      0
%
%    xEqual{1}    = [0 2 3];
%    xEqual{2}    = [0 2 3];
%    xEqual{3}    = [0 2 3];
%    xNotEqual{1} = [0 2 3];
%    xNotEqual{2} = [0 2 3];
%    xNotEqual{3} = [0 3 3]; % second element here different
%    xEqualTF = isallequal(xEqual)
%    xNotEqualTF = isallequal(xNotEqual)
%    >> xEqualTF = 1
%    >> xNotEqualTF = 0
%
%    xEqual{1}    = [0 2 3; 9 7 8];
%    xEqual{2}    = [0 2 3; 9 7 8];
%    xEqual{3}    = [0 2 3; 9 7 8];
%    xNotEqual{1} = [0 2 3; 9 7 8];
%    xNotEqual{2} = [0 2 3; 9 7 8];
%    xNotEqual{3} = [0 3 3; 9 7 8]; % second element here different
%    xEqualTF = isallequal(xEqual)
%    xNotEqualTF = isallequal(xNotEqual)
%    >> xEqualTF = 1
%    >> xNotEqualTF = 0
%
%    xEqual{1}    = 'asd';
%    xEqual{2}    = 'asd';
%    xEqual{3}    = 'asd';
%    xNotEqual{1} = 'asd';
%    xNotEqual{2} = 'asd';
%    xNotEqual{3} = 'axd'; % second element here different
%    xEqualTF = isallequal(xEqual)
%    xNotEqualTF = isallequal(xNotEqual)
%    >> xEqualTF = 1
%    >> xNotEqualTF = 0
%
%    xEqual{1}    = {'asd', 'asd'};
%    xEqual{2}    = {'asd', 'asd'};
%    xEqual{3}    = {'asd', 'asd'};
%    xNotEqual{1} = {'asd', 'asd'};
%    xNotEqual{2} = {'asd', 'asd'};
%    xNotEqual{3} = {'axd', 'asd'}; % second element here different
%    xEqualTF = isallequal(xEqual)
%    xNotEqualTF = isallequal(xNotEqual)
%    >> xEqualTF = 1
%    >> xNotEqualTF = 0
%
% fnery, 20150820: original version
% fnery, 20170325: added valid input checks
% fnery, 20190826: now accepts cell inputs

if ischar(in) || isstring(in) || isnumeric(in)
    in  = in(:);
    out = all(in == in(1));
elseif iscell(in)
    warning('isallequal.m invoked with cell inputs, which still requires some validation, so check everything OK')
    elementwiseCheck = cellfun(@isequal, in, repmat(in(1), size(in)));
    out = all(elementwiseCheck);
else
    error('Error: ''in'' must be a numeric, char, string or cell array');
end

end
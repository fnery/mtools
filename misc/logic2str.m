function out = logic2str(in)
% logic2str.m: converts logical scalar to string
%   
% Syntax:
%    1) out = logic2str(in)
%
% Description:
%    1) out = logic2str(in) converts a logical scalar to string, as I often
%       do when preparing logs and such.
%
% Inputs:
%    1) in (logical): scalar
%
% Outputs:
%    1) out (char): true/false string
%
% Notes/Assumptions: 
%    1) At the moment just works for scalar logical inputs
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
%    in = logical(1);
%    fprintf('%s\n', in)
%    >> 
%    fprintf('%d\n', in)
%    >> 1
%    fprintf('%s\n', logic2str(in))
%    >> true
%
% fnery, 20160530: original version
% fnery, 20170325: renamed from 'log2str.m' to 'logic2str.m'

if ~isscalar(in)
    error('Error: ''in'' must be a logical scalar');
end

if in
    out = 'true';
else
    out = 'false';
end

end
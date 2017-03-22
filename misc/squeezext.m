function out = squeezext(varargin)
% squeezext.m: extends squeeze.m (specify singleton dimensions keep/remove)
%   
% Syntax:
%    1) out = squeezext('in', in, 'dims', dims, 'rm', false)
%    2) out = squeezext('in', in, 'dims', dims, 'rm', true)
%
% Description:
%    1) out = squeezext('in', in, 'dims', dims, 'rm', false) removes all 
%       singleton dimensions except those in 'dims'.
%    2) out = squeezext('in', in, 'dims', dims, 'rm', true) only removes the
%       singleton dimensions in 'dims' (keeps all the other ones)
%
% Inputs:
%    ------------------------------ MANDATORY ------------------------------ 
%    <in>         numeric     n-D matrix: to be squeezed
%    <dims>       numeric     vector: singleton dimensions to keep/remove
%    ------------------------------ OPTIONAL -------------------------------
%    <rm>         logical     scalar; default: true
%                                 - true: <dims> will be removed
%                                 - false: <dims> will be kept
%
% Outputs:
%   1) out: output numeric array
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%
% Required files:
%    []
% 
% Examples:
%    in = rand(5, 4, 1, 3, 1, 6, 1, 1, 8);
%    out = squeezext('in', in, 'dims', [3], 'rm', false);
%    size(in)
%    size(out)
%    in = rand(5, 4, 1, 3, 1, 6, 1, 1, 8);
%    out = squeezext('in', in, 'dims', [3], 'rm', true);
%    size(in)
%    size(out)
%    >> ans =
%    >>      5     4     1     3     1     6     1     1     8
%    >> ans = % here 3rd dim (i.e. 1st singleton was kept)
%    >>      5     4     1     3     6     8 
%    >> ans =
%    >>      5     4     1     3     1     6     1     1     8
%    >> ans = % here 3rd dim (i.e. 1st singleton was removed)
%    >>      5     4     3     1     6     1     1     8
%
% fnery, 20160605: original version

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin);
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'in'}
            if isnumeric(cVal)
                in = cVal;
            else
                error('Error: ''in'' must be numeric');
            end
        case {'dims'}
            if is1d(cVal)
                dims = cVal;
            else
                error('Error: ''dims'' must be a vector');
            end
        case {'rm'}
            if islogical(cVal) && isscalar(cVal)
                rm = cVal;
            else
                error('Error: ''rm'' must be a logical scalar');
            end         
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =     ...
    exist('in'   , 'var') & ...
    exist('dims' , 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Defaults
rmExists = exist('rm', 'var');
if ~rmExists ; rm = true ; end;

sz = size(in);
singletonDims = sz == 1;

if ~all(ismember(dims, find(singletonDims)))
    error('Error: one or more elements of ''dims'' refers to non-singleton dimensions');
end

if rm
    % remove singleton dimension in 'dim', keep all other singletons
    nonSingletons = ~singletonDims;
    nonSingletons(setdiff(find(singletonDims), dims)) = 1;
    out = reshape(in, sz(nonSingletons));
elseif ~rm
    % keep singleton dimension in 'dim', remove all other singletons
    nonSingletons = ~singletonDims;
    nonSingletons(dims) = 1;
    out = reshape(in, sz(nonSingletons));
else
    error('Error: this point should never be reached');
end

end
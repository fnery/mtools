function bvalbveccheck(bval, bvec)
% bvalbveccheck.m: validity checks on .bval and .bvec files/matrices
%
% Syntax:
%    1) bvalbveccheck(bval, bvec)
%
% Description:
%    1) bvalbveccheck(bval, bvec) checks the following:
%       - (if inputs are strings) bval/bvec are full paths
%       - (if inputs are strings) bval/bvec have the correct extensions
%       - bval/bvec correspond to the same number of volumes (nVols)
%       - bval/bvec are in FSL format [1]
%            * bval is [1 x nVols] vector
%            * bvec is [3 x nVols] matrix
%
% Inputs:
%    1) bval: string full path to .bval file
%             OR 
%             numeric (assumed .bval file loaded previously)
%    2) bvec: string full path to .bvec file
%             OR 
%             numeric (assumed .bvec file loaded previously)
%
% Outputs:
%    []
%
% Notes/Assumptions:
%    []
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
%
% Required functions:
%    1) bvalbvecload.m
%
% Required files:
%    1) bval file from any given scan
%    2) bvec file from the corresponding scan of 1)
%
% Examples:
%    []
%
% fnery, 20180813: original version

EXTS.BVAL = '.bval';
EXTS.BVEC = '.bvec';

if ischar(bval) && ischar(bvec)

    % check 'bval' is a full path with the correct extension
    [bvalDir, ~, bvalExt] = fileparts(bval);
    if ~strcmp(bvalExt, EXTS.BVAL) || isempty(bvalDir)
        error('If ''bval'' is char must be fullpath with .bval extension');
    end

    % check 'bvec' is a full path with the correct extension
    [bvecDir, ~, bvecExt] = fileparts(bvec);
    if ~strcmp(bvecExt, EXTS.BVEC) || isempty(bvecDir)
        error('If ''bvec'' is char must be fullpath with .bvec extension');
    end

    % Files need to be loaded here to enable consistency and format checks
    [bval, bvec] = bvalbvecload(bval, bvec, false);

elseif isnumeric(bval) && isnumeric(bvec)
    
    % assume bval and bvec have been loaded into matrices previously
    % proceed to consistency and format checks
    
else
    error('''bval''/''bvec'' inputs must both be either char or numeric');
end

% Consistency and format checks
[a, b] = size(bval);
[c, d] = size(bvec);

% 1) must have same number of volumes if they belong to the same image data
if ~isequal(b, d)
    error('''bval'' and ''bvec'' must have same number of columns');
end

% 2) bval is composed of scalars and bvec of column vectors with 3 rows
if a ~= 1
    error('''bval'' must be a [1 x nVols] vector');
end
if c ~= 3
    error('''bvec'' must be a [3 x nVols] matrix');
end

end
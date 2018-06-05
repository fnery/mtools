function [bvalPath, bvecPath] = bvalbvecwrite(bvalArray, bvecArray, out)
% bvalbvecwrite.m: write .bval and/or .bvec files from MATLAB arrays
%
% Syntax:
%    1) [bvalPath, bvecPath] = bvalbvecwrite(bvalArray, bvecArray, out)
%
% Description:
%    1) [bvalPath, bvecPath] = bvalbvecwrite(bvalArray, bvecArray, out)
%       takes MATLAB array(s) with bvals and/or bvecs and as inputs and
%       creates corresponding .bval/.bvec files in the directory and with
%       name(s) specified by 'out'
%
% Inputs:
%    1) bvalArray: array with b-values  [1 x n]
%    2) bvecArray: array with b-vectors [3 x n]
%    3) out: base path (directory + name OR just name)
%
% Outputs:
%    1) bvalPath: full path to new .bval file
%    2) bvecPath: full path to new .bvec file
%
% Notes/Assumptions: 
%    1) bvalArray or bvecArray can be empty if just trying to create,
%       respectively a .bvec or .bval file
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%    2) outinit.m
%
% Required files:
%    []
%
% Examples:
%    [~       , bvecPath] = bvalbvecwrite([]       , bvecArray, 'out_name')
%    [bvalPath,        ~] = bvalbvecwrite(bvalArray, []       , 'out_name')
%    [bvalPath, bvecPath] = bvalbvecwrite(bvalArray, bvecArray, 'out_name')
%
% fnery, 20180605: original version

PRECISION = '%.6f';

if nargin ~= 3 
    error(['Error: bvalbvecwrite.m needs 3 input arguments' ...
           ' (any of the first two can be empty if not needed)']);
end

bvalArrayIsEmpty = isempty(bvalArray);
bvecArrayIsEmpty = isempty(bvecArray);

if bvalArrayIsEmpty && bvecArrayIsEmpty
    bvalPath = [];
    bvecPath = [];
    return;
end

% =================================================
% ===== Argin validity and consistency checks ===== -----------------------
% =================================================

% If bvalArray was provided, check its format is valid
if ~bvalArrayIsEmpty
    if ~is1d(bvalArray) || ...
       (is1d(bvalArray) && size(bvalArray, 2) < 2)
        error('Error: if not empty, bvalArray must be a row vector');
    end
    
    [~, nBVals] = size(bvalArray);
else
    bvalPath = [];
end

% If bvecArray was provided, check its format is valid
if ~bvecArrayIsEmpty
    if ~ismatrix(bvecArray) || ...
       (ismatrix(bvecArray) && (size(bvecArray, 1) ~= 3 || size(bvecArray, 2) < 2))
        error('Error: if not empty, bvecArray must be a [3 x nBVecs] matrix');
    end
    
    [~, nBVecs] = size(bvecArray);
else
    bvecPath = [];
end
    
% If both bvalArray and bvecArray their size must be consistent
if ~bvalArrayIsEmpty && ~bvecArrayIsEmpty
    if ~isequal(nBVals, nBVecs)
        error('Error: inconsistent bvalArray and bvecArray (different number of DWIs)');
    end
end

% =========================
% ===== Writing files ===== -----------------------------------------------
% =========================

basePath = outinit(out, false);

% .bval
if ~bvalArrayIsEmpty
    bvalPath = [basePath '.bval'];
    dlmwrite(bvalPath, bvalArray, 'delimiter', ' ', 'precision', PRECISION);
end

% .bvec
if ~bvecArrayIsEmpty
    bvecPath = [basePath '.bvec'];
    dlmwrite(bvecPath, bvecArray, 'delimiter', ' ', 'precision', PRECISION);
end

end
function [bVal, bVec] = bvalbveccat(bVals, bVecs, name, outDir)
% bvalbveccat.m: concatenate .bval and .bvec files
%
% Syntax:
%    1) [bVal, bVec] = bvalbveccat(bVals, bVecs, name)
%    2) [bVal, bVec] = bvalbveccat(bVals, bVecs, name, outDir)
%
% Description:
%    1) [bVal, bVec] = bvalbveccat(bVals, bVecs, name) concatenates .bval
%       and .bvec files and saves the resulting .bval and .bvec files in the 
%       working directory with the name 'name'
%    2) [bVal, bVec] = bvalbveccat(bVals, bVecs, name, outDir) does the
%       same as 1) but allows to specify the output directory where to save
%       the new files ('outDir')
%
% Inputs:
%    1) bVals: cell of strings of paths to .bval files
%    2) bVecs: cell of strings of paths to corresponding .bvecs files
%    3) name: string, name for output files
%    4) outDir: (optional) directory where to save output files
% 
% Outputs:
%    1) bVal: full path to new (concatenated) .bval file
%    2) bVec: full path to new (concatenated) .bvec file
%
% Notes/Assumptions: 
%    1) Useful when we merge dwi volumes and want to generate the
%       corresponding merged .bval/.bvec files
%
% References:
%    []
%
% Required functions:
%    1) bvalbvecload.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180420: original version

PRECISION = '%.6f';

if nargin < 3
    error('Error: bvalbveccat.m needs at least 3 input arguments');
elseif nargin == 3
    outDir = pwd;
end

nBVals = length(bVals);
nBVecs = length(bVecs);

if ~isequal(nBVals, nBVecs)
    error('Error: number of elements of ''bVals'' and ''bVecs'' must be the same');
else
    nBValsBVecs = nBVals;
end

% Load bvals and bvecs 
bValTmp = cell(1, nBValsBVecs);
bVecTmp = cell(1, nBValsBVecs);

for iBValsBVec = 1:nBValsBVecs
    cBVal = bVals{iBValsBVec};
    cBVec = bVecs{iBValsBVec};
    [bValTmp{iBValsBVec}, bVecTmp{iBValsBVec}] = bvalbvecload(cBVal, cBVec);
end

% Concatenate bvals and bvecs
bValArr = horzcat(bValTmp{:}); 
bVecArr = horzcat(bVecTmp{:});

% Full paths of output files
bVal = fullfile(outDir, [name '.bval']);
bVec = fullfile(outDir, [name '.bvec']);

% Write new .bval and .bvec files
dlmwrite(bVal, bValArr, 'delimiter', ' ', 'precision', PRECISION);
dlmwrite(bVec, bVecArr, 'delimiter', ' ', 'precision', PRECISION);

end
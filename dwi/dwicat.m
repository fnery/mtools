function [dwi, bVal, bVec] = dwicat(dwis, out)
% dwicat.m: concatenate 3/4D dwi NIfTI files along 4th dimension
%
% Syntax:
%    1) [dwi, bVal, bVec] = dwicat(dwis, out)
%
% Description:
%    1) [dwi, bVal, bVec] = dwicat(dwis, out) concatenates 3/4D dwi NIfTI
%       files along the 4th dimension. Also concatenates their corresponding
%       .bval and .bvec files (FSL-format) so that the output file is ready
%       to be used in DWI pipelines. Outputs will be:
%       - <out>.nii.gz
%       - <out>.bval
%       - <out>.bvec
%       Both basename and directory of the resulting files can be specified
%       in 'out'
% 
% Inputs:
%    1) dwis: cell of strings of paths to . 3D/4D dwi NIfTI files
%    2) name: string, name for output files
%    3) out: base path (directory + name OR just name)
% 
% Outputs:
%    1) dwi: full path to new NIfTI file
%    2) bVal: full path to new (concatenated) .bval file
%    3) bVec: full path to new (concatenated) .bvec file
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) bvalbvecpath.m
%    2) bvalbveccat.m (lives in this function)
%    3) outinit.m
%    4) win2wsl.m
%    5) m2sharr.m
%    6) system2.m
%    7) wsl2win.m
%    8) bvalbvecload.m
%    9) bvalbvecwrite.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180420: original version
% fnery, 20180605: now uses outinit.m and bvalbvecwrite.m

if nargin ~= 2
    error('Error: dwicat.m needs 2 input arguments');
end

% Init paths of .bvals and .bvecs corresponding to 'dwis' input
[bVals, bVecs] = bvalbvecpath(dwis);

% ===================================
% ===== Concatenate bvals/bvecs ===== -------------------------------------
% ===================================
% (filepaths in Windows format)

[bVal, bVec] = bvalbveccat(bVals, bVecs, out);

% ===================================
% ===== Concatenate NIfTI files ===== -------------------------------------
% ===================================
% (filepaths in UNIX (WSL) format)

basePath = outinit(out, false);

dwis     = win2wsl(dwis);
basePath = win2wsl(basePath);

% Filepath for output file
dwi = [basePath '.nii.gz'];

% Convert dwis to space-separated list as fslmerge requires
dwis = m2sharr(dwis);

% Build and run fslmerge command
cmd = sprintf('fslmerge -t %s %s', dwi, dwis);
status = system2('cmd', cmd, '-echo', false, '&', false);
if status ~= 0
    error('Error: There was an error when calling fslmerge');
end

% dwi back to Windows format
dwi = wsl2win(dwi);

end

function [bVal, bVec] = bvalbveccat(bVals, bVecs, out)
% bvalbveccat.m: concatenate .bval and .bvec files
%
% Syntax:
%    1) [bVal, bVec] = bvalbveccat(bVals, bVecs, out)
%
% Description:
%    1) [bVal, bVec] = bvalbveccat(bVals, bVecs, name) concatenates .bval
%       and .bvec files and saves the resulting .bval and .bvec files in
%       the directory and with file name specified by 'out'
%
% Inputs:
%    1) bVals: cell of strings of paths to .bval files
%    2) bVecs: cell of strings of paths to corresponding .bvecs files
%    3) out: base path (directory + name OR just name)
% 
% Outputs:
%    1) bVal: full path to new (concatenated) .bval file
%    2) bVec: full path to new (concatenated) .bvec file
%
% Notes/Assumptions: 
%    1) Useful when we merge DWI volumes and want to generate the
%       corresponding merged .bval/.bvec files
%
% References:
%    []
%
% Required functions:
%    1) bvalbvecload.m
%    2) bvalbvecwrite.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180420: original version
% fnery, 20180605: now uses bvalbvecwrite.m

if nargin ~= 3
    error('Error: bvalbveccat.m needs 3 input arguments');
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

% Write output files
[bVal, bVec] = bvalbvecwrite(bValArr, bVecArr, out);

end
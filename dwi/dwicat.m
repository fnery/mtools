function [dwi, bVal, bVec] = dwicat(dwis, name, outDir)
% dwicat.m: concatenate 3/4D dwi NIfTI files along 4th dimension
%
% Syntax:
%    1) [dwi, bVal, bVec] = dwicat(dwis, name)
%    2) [dwi, bVal, bVec] = dwicat(dwis, name, outDir)
%
% Description:
%    1) [dwi, bVal, bVec] = dwicat(dwis, name) concatenates 3/4D dwi NIfTI
%       files along the 4th dimension. Also concatenates their corresponding
%       .bval and .bvec files (FSL-format) so that the output file is ready
%       to be used in DWI pipelines. Outputs will be:
%       - <name>.nii.gz
%       - <name>.bval
%       - <name>.bvec
%       and are saved in the working directory
%    2) [dwi, bVal, bVec] = dwicat(dwis, name, outDir) does the same as 1)
%       but allows to specify the output directory where to save the new
%       files ('outDir')
% 
% Inputs:
%    1) dwis: cell of strings of paths to . 3D/4D dwi NIfTI files
%    2) name: string, name for output files
%    3) outDir: (optional) directory where to save output files
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
%    1) niibvalbvec.m
%    2) bvalbveccat.m (lives in this function)
%    3) win2wsl.m
%    4) filesep2.m
%    5) m2sharr.m
%    6) system2.m
%    7) wsl2win.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180420: original version

if nargin < 2
    error('Error: dwicat.m needs at least 2 input arguments');
elseif nargin == 2
    outDir = pwd;
end

% Init paths of .bvals and .bvecs corresponding to 'dwis' input
[bVals, bVecs] = niibvalbvec(dwis);

% ===================================
% ===== Concatenate bvals/bvecs ===== -------------------------------------
% ===================================
% (filepaths in Windows format)

[bVal, bVec] = bvalbveccat(bVals, bVecs, name, outDir);

% ===================================
% ===== Concatenate NIfTI files ===== -------------------------------------
% ===================================
% (filepaths in UNIX (WSL) format)

dwis   = win2wsl(dwis);
outDir = win2wsl(outDir);

% Filepath for output file
dwi = [outDir filesep2('UNIX') name '.nii.gz'];

% Convert dwis to space-separated list as fslmerge requires
dwis = m2sharr(dwis);

% Build and run fslmerge command
system2(sprintf('fsl5.0-fslmerge -t %s %s', dwi, dwis)); 

% dwi back to Windows format
dwi = wsl2win(dwi);

end

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
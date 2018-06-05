function [niiOut, bvalOut, bvecOut] = dwiextract(niiIn, out, tMin, tSize)
% dwiextract.m: extract subset of adjacent time points from DWI dataset
%
% Syntax:
%    1) [niiOut, bvalOut, bvecOut] = dwiextract(niiIn, out, tMin, tSize)
%
% Description:
%    1) [niiOut, bvalOut, bvecOut] = dwiextract(niiIn, out, tMin, tSize) 
%       extracts a subset of time points from DWI dataset. Generates a new
%       NIfTI file and a new corresponding bval/bvec set of files.%
%
% Inputs:
%    1) niiIn: fullpath string to NIfTI files to be cropped in the 4th dim
%    2) out: base path (directory + name OR just name)
%    3) tMin: minimum time point to include (1-indexing)
%    4) tMax: number of time points to include
%
% Outputs:
%    1) niiOut: path to output NIfTI file
%    2) bvalOut: path to output .bval file
%    3) bvecOut: path to output .bvec file
%
% Notes/Assumptions: 
%    1) Can only extract adjacent time points
%    2) Uses fslroi from FSL [1]
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
%
% Required functions:
%    1) isint.m
%    2) fileparts2.m
%    3) outinit.m
%    4) bvalbvecexist.m
%    5) win2wsl.m
%    6) system2.m
%    7) bvalbvecpath.m
%    8) bvalbvecload.m
%    9) bvalbvecwrite.m
%
% Required files:
%    none other than those specified on the input arguments
%
% Examples:
%    % 1) Extract first 10 time points, assuming a DWI.nii.gz exists in pwd
%    dwiextract(fullfile(pwd, 'DWI.nii.gz'), 'DWI_1_10', 1, 10);
%
% fnery, 20180605: original version

% =========================
% ===== Manage argins ===== -----------------------------------------------
% =========================

if nargin ~= 4
    error('Error: dwicat.m needs 4 input arguments');
end

if ~(isint(tMin) && tMin > 0)
    error('Error: ''tMin'' must be an integer larger than 0');
end

if ~(isint(tSize) && tSize > 0)
    error('Error: ''tSz'' must be an integer larger than 0');
end

if ~ischar(niiIn)
    error('Error: ''niiIn'' must be a char (path to a NIfTI file)');
end

[d, ~, ext] = fileparts2(niiIn);

if isempty(d)
    error('Error: the directory of ''niiIn'' must be specified');
end

out = outinit(out, false);

% Check bvals/bvecs associated to niiIn exist
bvalbvecexist(niiIn, true)

% =================================
% ===== Create new NIfTI file ===== ---------------------------------------
% =================================

% Create inputs for fslroi
niiInWsl  = win2wsl(niiIn);
niiOut    = [out ext];
niiOutWsl = win2wsl(niiOut);

% Convert tMin in MATLAB indexing (1-indexing) to FSL indexing (0-indexing)
tMinFSL = tMin - 1;

% Build and run fslroi command
cmd = sprintf('fslroi %s %s %d %d', niiInWsl, niiOutWsl, tMinFSL, tSize);
status = system2('cmd', cmd, '-echo', false, '&', false);
if status ~= 0
    error('Error: There was an error when calling fslroi');
end

% ============================
% ===== Create bval/bvec ===== --------------------------------------------
% ============================

% Init paths of .bvals and .bvecs corresponding to 'dwis' input
[bvalIn, bvecIn] = bvalbvecpath(niiIn);

% Load them
[bvalArr, bvecArr] = bvalbvecload(bvalIn, bvecIn);

% Compute upper time boundary
tMax = tMin + (tSize - 1);

% Crop bval/bvec
bvalArr = bvalArr(:, tMin:tMax);
bvecArr = bvecArr(:, tMin:tMax);

% Write
[bvalOut, bvecOut] = bvalbvecwrite(bvalArr, bvecArr, out);

end
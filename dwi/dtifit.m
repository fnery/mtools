function dtifit(in, mask, baseName)
% dtifit.m: FSL's dtifit wrapper
%
% Syntax:
%    dtifit(in, mask, baseName)
%
% Description:
%    1) dtifit(in, mask, baseName) wraps around FSL's dtifit with the
%       following features:
%       - uses compulsory argins only
%       - automatic .bval/.bvec path initialisation
%       - enhanced baseName management using outinit.m
%       - automatic conversion of Windows paths to WSL
%
% Inputs:
%    1) in: fullpath to 4D DTI NIfTI file
%    2) mask: fullpath to 3D mask NIfTI file
%    3) baseName: base filepath or filename for dtifit outputs
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    1) Assumes .bval and .bvec files corresponding to 'in' exist 
%       in the same directory 'in' is stored and have the same name
%       as 'in'
%    2) Assumes FSL (available in [1]) is installed in the Windows
%       subsystem for Linux
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/
%
% Required functions:
%    1) bvalbvecpath.m
%    2) exist2.m
%    3) outinit.m
%    4) win2wsl.m
%    5) system2.m
%
% Required files:
%    DTI 4D NIfTI image, associated .bval/.bvec files and NIFTI 3D mask
%
% Examples:
%    []
%
% fnery, 20180727: original version

SETTINGS.noDir  = 'make';
SETTINGS.silent = false;

% Init paths to .bval and .bvec files
[bVal, bVec] = bvalbvecpath(in);

% Check all files exist
exist2(in  , 'file', true);
exist2(mask, 'file', true);
exist2(bVal, 'file', true);
exist2(bVec, 'file', true);

% Manage basename
% - If baseName does not specify a dir, files will be
%   created in pwd
% - If baseName specifies a dir which does not exist
%   the directory will be created where the resulting
%   files will be saved
baseName = outinit('in'     , baseName        , ...
                   'useext' , false           , ...
                   'nodir'  , SETTINGS.noDir  , ...
                   'silent' , SETTINGS.silent);

% All inputs to dtifit have to be in WSL format
inWsl       = win2wsl(in);
maskWsl     = win2wsl(mask);
baseNameWsl = win2wsl(baseName);
bValWsl     = win2wsl(bVal);
bVecWsl     = win2wsl(bVec);

% Build and run dtifit command
cmd = sprintf('dtifit -k %s -o %s -m %s -r %s -b %s', ...
               inWsl, baseNameWsl, maskWsl, bVecWsl, bValWsl);

status = system2('cmd', cmd, '-echo', false, '&', false);
if status ~= 0
    error('Error: There was an error when calling FSL''s ''dtifit''');
end

end
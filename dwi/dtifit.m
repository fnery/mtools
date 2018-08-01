function Paths = dtifit(in, mask, baseName, bVal, bVec)
% dtifit.m: FSL's dtifit wrapper
%
% Syntax:
%    1) Paths = dtifit(in, mask, baseName)
%    2) Paths = dtifit(in, mask, baseName, bVal, bVec)
%
% Description:
%    1) Paths = dtifit(in, mask, baseName) wraps around FSL's dtifit with
%       the following features:
%       - uses compulsory argins only
%       - automatic .bval/.bvec path initialisation
%       - enhanced baseName management using outinit.m
%       - automatic conversion of Windows paths to WSL
%    2) Paths = dtifit(in, mask, baseName, bVal, bVec) does the same as 1)
%       except automatically initialising the paths to the .bval/.bvec
%       files. Useful for cases where the .bval/.bvec files do not have the 
%       same file name.
%
% Inputs:
%    1) in: fullpath to 4D DTI NIfTI file
%    2) mask: fullpath to 3D mask NIfTI file
%    3) baseName: base filepath or filename for dtifit outputs
%    4) bVal (optional): fullpath to .bval file
%    5) bVec (optional): fullpath to .bvec file
%
% Outputs:
%    Paths: struct with full paths to all output maps (NIfTI files)
%
% Notes/Assumptions: 
%    1) Assumption #1: If .bval and .bvec are not specified, this function
%       will assume bVals/bVecs corresponding to 'in' exist in
%       the same directory 'in' is stored and have the same name as 'in'
%    2) Assumption #2: Assumes FSL (available in [1]) is installed in the
%       Windows subsystem for Linux
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/
%
% Required functions:
%    1) bvalbvecpath.m
%    2) bvalbvecload.m
%    3) exist2.m
%    4) outinit.m
%    5) win2wsl.m
%    6) system2.m
%    7) dtifitpaths.m
%
% Required files:
%    DTI 4D NIfTI image, associated .bval/.bvec files and NIFTI 3D mask
%
% Examples:
%    []
%
% fnery, 20180727: original version
% fnery, 20180730: now allows .bval/.bvec files to be specified by user
%                  now can output paths of all generated NIfTI files

SETTINGS.noDir  = 'make';
SETTINGS.silent = false;

if nargin == 3
    % .bval and .bvec not specified: init paths automatically based on
    % Assumption #1
    [bVal, bVec] = bvalbvecpath(in);
elseif nargin == 5
    % .bval and .bvec specified by user, just do very brief preliminary
    % checks of their validity using the error checks of bvalbvecload.m
    bvalbvecload(bVal, bVec); % the files aren't actually loaded
else
    error('Error: this function requires either 3 or 5 input arguments');
end
    

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

% Generate struct with output paths
Paths = dtifitpaths(baseName);

end
function outPath = niicrop(varargin)
% niicrop.m: crops .nii file using fslroi according to .crop file
%
% Syntax:
%    1) [outPath] = niicrop('nii', nii, 'crop', crop', 'out', out, 'suffix', suffix)
%
% Description:
%    1) [outPath] = niicrop('nii', nii, 'crop', crop', 'out', out, 'suffix', suffix)
%       crops the nifti file given in 'nii' using fslroi according to the .crop
%       file given in 'crop', saves the output in 'out' with the 'suffix' suffix
%       appended to the output file names
%
% Inputs:
%    -------------------------------- MANDATORY -------------------------------
%    <nii>      char    :    full path to a nifti file
%    <crop>     char    :    full path to a .crop file
%    --------------------------------- OPTIONAL -------------------------------
%    <out>      char    :    full path to directory where to save output files
%    <suffix>   char    :    suffix to append to file names of output files
%    --------------------------------------------------------------------------
%
% Outputs:
%    1) outPath: path(s) of output .nii files
%
% Notes/Assumptions: 
%    1) Requires FSL to be installed (to use fslroi [1])
%    2) A good idea is to get the cropping coordinates from fslview [2]
%    3) Assumes that if this function is running on a PC (windows) FSL was
%       installed in the Windows Subsystem for Linux (WSL). Furthermore 
%       this function performs the conversion from absolute Windows file
%       paths to their WSL equivalent (see [3])  
%       
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%    [2] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslView
%    [3] https://docs.microsoft.com/en-us/windows/wsl/faq#what-can-i-do-with-wsl
%
% Required functions:
%    1) isnifti.m
%    2) isext.m
%    3) fileparts2.m
%    4) cropread.m
%    5) fslroi (see Note 1)
%
% Required files:
%    1) .nii file
%    2) .crop file
%
% Examples:
%    []
%
% fnery, 20171101: original version
% fnery, 20171103: now can specify suffix and inputs are in name-value form
% fnery, 20180221: now works in Windows OS (via Windows Subsystem for Linux)

CROP_EXT   = '.crop';
OUT_SUFFIX = 'crop'; 

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'nii'}
            % verify if 'nii' is valid
            if isnifti(cVal)
                nii = cVal;
            else
                error('Error: ''nii'' is invalid')
            end
        case {'crop'}
            % verify if 'crop' is valid 
            if isext(cVal, CROP_EXT)
                crop = cVal;
            else
                error('Error: ''crop'' is invalid')
            end
        case {'out'}
            % verify if 'out' is valid 
            if isdir(cVal)
                out = cVal;
            else
                error('Error: ''out'' is invalid');
            end
        case {'suffix'}
            % verify if 'suffix' is valid 
            if ischar(cVal)
                suffix = cVal;
            else
                error('Error: ''suffix'' is invalid');
            end                       
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =     ...
    exist('nii'  , 'var') & ...
    exist('crop' , 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

[niiDir, niiName, niiExt] = fileparts2(nii);

% If 'out' does not exist, save the cropped files in the input file dir
outExists  = exist('out', 'var');
if ~outExists
    out = niiDir;
end

suffixExists  = exist('suffix', 'var');
if ~suffixExists
    suffix = OUT_SUFFIX;
end

% Read .crop file
c = cropread(crop);

% Crop input .nii file
nROIs = size(c, 1);
outPath = cell(nROIs, 1);
for iROI = 1:nROIs
    
   % Build current output file name/path
   cOutName = sprintf('%s_%s_%d_of_%d', niiName, suffix, iROI, nROIs);
   cOutPath = fullfile(out, [cOutName niiExt]);
   cOutPathToSave = cOutPath;
   
   if iswinpath(nii)
       nii = win2wsl(nii);
   end
   if iswinpath(cOutPath)
       cOutPath = win2wsl(cOutPath);
   end       
   
   % Build command string
   cC = c(iROI, :);
   
   if strcmp(computer, 'PCWIN64')
   % assume here we're in a Windows PC, with MATLAB installed in the
   % Windows system and need to call fslroi via Windows Subsystem for Linux
       cCmd = sprintf('fsl5.0-fslroi %s %s %d %d %d %d %d %d', ...
           nii, cOutPath, cC(1), cC(2), cC(3), cC(4), cC(5), cC(6));
       cCmd = sprintf('bash -c "%s" &', cCmd);
   else
   % regular fslroi assuming MATLAB installed in a Linux environment
       cCmd = sprintf('fslroi %s %s %d %d %d %d %d %d', ...
           nii, cOutPath, cC(1), cC(2), cC(3), cC(4), cC(5), cC(6));
   end
   
   % Run fslroi command
   status = system(cCmd);
   if status ~= 0
       error('Error: There was an error when calling fslroi');
   end

   if strcmp(computer, 'PCWIN64')
       % kill resulting command window
       pckillcmd;
   end
   
   % Save outPath
   outPath{iROI, 1} = cOutPathToSave;
   
end

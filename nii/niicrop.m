function outPath = niicrop(varargin)
% niicrop.m: FSL's fslroi MATLAB wrapper
%
% Syntax:
%    1) outPath = niicrop('nii', nii, 'fics', fics, 'out', out, 'suffix', suffix)
%
% Description:
%    1) outPath = niicrop('nii', nii, 'fics', fics, 'out', out, 'suffix', suffix)
%       crops the NIfTI file given in 'nii' using fslroi according to the
%       [f]slroi [i]nput [c]oordinate[s] provided in 'fics' and saves the
%       output in 'out' with 'suffix' appended to the output file names
%
% Inputs:
%    -------------------------------- MANDATORY -------------------------------
%    <nii>     char  :  full path to a NIfTI file
%    <fics>    cell  :  (of strings) with [f]slroi [i]nput [c]oordinate[s]
%                       each element of the cell is a [1x6] vector (string
%                       format to use in the terminal) with format:
%                           <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
%                       which defines one cropping operation
%    --------------------------------- OPTIONAL -------------------------------
%    <out>     char  :  full path to directory where to save output files
%    <suffix>  char  :  suffix to append to file names of output files
%    --------------------------------------------------------------------------
%
% Outputs:
%    1) outPath: cell of strings: path(s) of output NIfTI files
%
% Notes/Assumptions: 
%    1) A good way to obtain fics is to use niidotmask.m
%    2) Requires FSL to be installed (to use fslroi [1])
%    3) Assumes that if this function is running on a PC (windows) FSL was
%       installed in the Windows Subsystem for Linux (WSL). Furthermore 
%       this function performs the conversion from absolute Windows file
%       paths to their WSL equivalent (see [2])  
%       
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%    [2] https://docs.microsoft.com/en-us/windows/wsl/faq#what-can-i-do-with-wsl
%
% Required functions:
%    1) isnifti.m
%    2) fileparts2.m
%    3) iswinpath.m
%    4) win2wsl.m
%    5) fslroi (see Note 2)
%    6) pckillcmd.m
%
% Required files:
%    1) NIfTI image file (nii)
%
% Examples:
%    []
%
% fnery, 20180305: original version

DEFAULT_SUFFIX = 'crop'; 

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
                error('Error: ''nii'' is not a NIfTI file')
            end
        case {'fics'}
            % verify if 'fics' is cell
            % (it would be nice to write an actual fics validity checker)
            if iscell(cVal)
                fics = cVal;
            else
                error('Error: ''fics'' must be a cell of strings (see doc)')
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
    exist('fics' , 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

[niiDir, niiName, niiExt] = fileparts2(nii);

% If 'out' does not exist, save the cropped files in the input file dir
outExists = exist('out', 'var');
if ~outExists
    out = niiDir;
end

suffixExists = exist('suffix', 'var');
if ~suffixExists
    suffix = DEFAULT_SUFFIX;
end

% Crop input .nii file
nROIs = length(fics);
outPath = cell(nROIs, 1);
for iROI = 1:nROIs
    
   % Build current output file name/path
   cOutName = sprintf('%s_%s_%02dof%02d', niiName, suffix, iROI, nROIs);
   cOutPath = fullfile(out, [cOutName niiExt]);
   cOutPathToSave = cOutPath;
   
   if iswinpath(nii)
       nii = win2wsl(nii);
   end
   if iswinpath(cOutPath)
       cOutPath = win2wsl(cOutPath);
   end       
   
   % Build command string  
   if strcmp(computer, 'PCWIN64')
   % assume here we're in a Windows PC, with MATLAB installed in the
   % Windows system and need to call fslroi via Windows Subsystem for Linux
       cCmd = sprintf('fsl5.0-fslroi %s %s %s', ...
           nii, cOutPath, fics{iROI});
       cCmd = sprintf('bash -c "%s" &', cCmd);
   else
   % regular fslroi assuming MATLAB installed in a Linux environment
       cCmd = sprintf('fslroi %s %s %s', ...
           nii, cOutPath, fics{iROI});
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

end
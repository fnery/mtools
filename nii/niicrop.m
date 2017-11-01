function outPath = niicrop(varargin)
% niicrop.m: crops .nii file using fslroi according to .crop file
%
% Syntax:
%    1) [outPath] = niicrop(niiPath, cropPath)
%    2) [outPath] = niicrop(niiPath, cropPath, outDir)
%
% Description:
%    1) [outPath] = niicrop(niiPath, cropPath) crops a .nii file using 
%       fslroi according to .crop file, the output .nii file(s) are saved in
%       the same directory where the input .nii file lives
%    2) [outPath] = niicrop(niiPath, cropPath, outDir) does the same as 1)
%       but saves the output .nii file(s) in outDir
%
% Inputs:
%    1) niiPath: path to .nii file
%    2) cropPath: path to .crop file
%    3) outDir (opt): path to directory where to save output .nii files
%
% Outputs:
%    1) outPath: path(s) of output .nii files
%
% Notes/Assumptions: 
%    1) Requires FSL to be installed (to use fslroi [1])
%    2) A good idea is to get the cropping coordinates from fslview [2]
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%    [2] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslView
%
% Required functions:
%    1) fileparts2.m
%    2) readcrop.m
%    3) fslroi (see Note 1)
%
% Required files:
%    1) .nii file
%    2) .crop file
%
% Examples:
%    []
%
% fnery, 20171101: original version

OUT_SUFFIX = '_crop'; 

niiPath = varargin{1};
cropPath = varargin{2};

[niiDir, niiName, niiExt] = fileparts2(niiPath);

if nargin == 2
    outDir = niiDir;
elseif nargin == 3
    outDir = varargin{3};
else
    error('Error: niicrop.m requires 2 or 3 input arguments');
end

% Read .crop file
c = readcrop(cropPath);

% Crop input .nii file
nROIs = size(c, 1);
outPath = cell(nROIs, 1);
for iROI = 1:nROIs
    
   % Build current output file name/path
   cOutName = sprintf('%s%s_%d_of_%d', niiName, OUT_SUFFIX, iROI, nROIs);
   cOutPath = fullfile(outDir, [cOutName niiExt]);
   
   % Build command string
   cC = c(iROI, :);
   cCmd = sprintf('fslroi %s %s %d %d %d %d %d %d', ...
       niiPath, cOutPath, cC(1), cC(2), cC(3), cC(4), cC(5), cC(6));
   
   % Run fslroi command
   status = system(cCmd);
   if status ~= 0
       error('Error: There was an error when calling fslroi');
   end
   
   % Save outPath
   outPath{iROI, 1} = cOutPath;
   
end

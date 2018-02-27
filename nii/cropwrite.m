function filePath = cropwrite(xMin, xMax, yMin, yMax, zMin, zMax, fileName, fileDir)
% cropwrite.m: creates .crop files with coordinates for cropping ROIs
%
% Syntax:
%    1) filePath = cropwrite(xMin, xMax, yMin, yMax, zMin, zMax)
%    2) filePath = cropwrite(xMin, xMax, yMin, yMax, zMin, zMax, fileName)
%    3) filePath = cropwrite(xMin, xMax, yMin, yMax, zMin, zMax, fileName, fileDir)
%
% Description:
%    1) filePath = cropwrite(xMin, xMax, yMin, yMax, zMin, zMax) creates one
%       .crop file with coordinates for cropping regions of interest (typically
%       for allowing independent rigid/affine registrations for each kidney of
%       a dataset). The file is given an unique name and store in the current
%       directory.
%    2) same as 1) but the file name will be the string given by 'fileName'
%    3) same as 2) but saves the file in the directory given by 'fileDir'
%
% Inputs:
%    1) xMin    : [1 x nROIs] vector with minimum x for each cropping region 
%    2) xMax    : [1 x nROIs] vector with maximum x for each cropping region
%    3) yMin    : [1 x nROIs] vector with minimum y for each cropping region
%    4) yMax    : [1 x nROIs] vector with maximum y for each cropping region
%    5) zMin    : [1 x nROIs] vector with minimum z for each cropping region
%    6) zMax    : [1 x nROIs] vector with maximum z for each cropping region
%    7) fileName: resulting file name                (optional) 
%    8) fileDir : directory where file will be saved (optional)
%
% Outputs:
%    1) filePath: path of resulting file
%
% Notes/Assumptions: 
%    1) The way I envisage this function being used, at least for now, is:
%       a) Open FSLview with dataset where cropping region is to be defined
%       b) Choose extreme coordinates for each cropping region (2 pixels enough
%          to describe a rectangular region)
%       c) Using FSLview's cursor tool, make a note on the extreme coordinates 
%          (xMin, xMax, ...) for all cropping regions
%       d) Create xMin, xMax, ... variables to feed to this function
%       e) Run this function to create .crop file
%    2) Note that even though the inputs I provide are:
%           <xmin> <xmax> <ymin> <ymax> <zmin> <zsmax>, 
%       the resulting file will contain cropping coordinates in the format
%       required by FSL's fslroi function [1], which is:
%           <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
%       In other words, visually it's easier to get (xMin, xMax) rather than
%       (xMin, xSize), but this function calculates the "sizes" automatically
%       before creating the .crop files
%    3) Using FSLview to extract coordinates to feed to FSLroi means that 
%       the pixel numbering convention is consistent by default
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%
% Required functions:
%    1) ctime.m
%
% Required files:
%    []
%
% See also:
%    1) cropread.m
%
% Examples:
%    fileName  = 'crop_example';        
%    fileDir   = pwd;
%    fileName  = cropwrite(12, 14, 20, 25, 0, 13, fileName, fileDir);
%    % This will generate a file named crop_example.crop with contents:
%    % {
%          % Coordinates to crop region(s) of interest (ROIs)
%          % Format used by FSL's fslroi function:
%          % <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
%          % Number of lines = number of ROIs in the dataset
%          12 2 20 5 0 13
%    % }
%    And save it in the current directory
%
% fnery, 20180227: original version

FILE_FORMAT = '.crop';

HELPSTR = sprintf(...
    ['%% Coordinates to crop region(s) of interest (ROIs)\n', ...
     '%% Format used by FSL''s fslroi function:\n'          , ...
     '%% <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>\n'    , ...                       
     '%% Number of lines = number of ROIs in the dataset']);
               
if nargin < 8
    fileDir = pwd;
end

if nargin < 7   
   fileName = sprintf('crop_%s', ctime('ymdhmsf')); 
end

xMinSz = size(xMin);  
xMaxSz = size(xMax);
yMinSz = size(yMin);
yMaxSz = size(yMax);
zMinSz = size(zMin);
zMaxSz = size(zMax);

if ~isequal(xMinSz, xMaxSz, yMinSz, yMaxSz, zMinSz, zMaxSz)
    error('xMin,xMax,yMin,yMax,zMin and zMax need to have the same number of elements');
else
    nMasks = max(xMinSz);
end

% remove file extension from fileName, if it was appended to the fileName
if length(fileName) >= length(FILE_FORMAT)
    fileNameHasExtension = strcmpi(fileName(end-(length(FILE_FORMAT)-1):end), FILE_FORMAT);
    if fileNameHasExtension
        fileName(end-(length(FILE_FORMAT)-1):end) = [];
    end
end

coordinatesStr = [];

for iMask = 1:nMasks;
    cxMax = xMax(iMask);
    cyMax = yMax(iMask);
    czMax = zMax(iMask);
    cxMin = xMin(iMask);
    cyMin = yMin(iMask);
    czMin = zMin(iMask);

    cxSz = cxMax-cxMin;
    cySz = cyMax-cyMin;
    czSz = czMax-czMin;

    coordinatesStr = sprintf('%s%d %d %d %d %d %d\n', ...
        coordinatesStr, cxMin, cxSz, cyMin, cySz, czMin, czSz);
end
  
% Last character in coordinatesStr is always a newline, so get rid of it
coordinatesStr(end) = [];

fileContents = sprintf('%s\n%s', HELPSTR, coordinatesStr);

% Write to .crop file
filePath = fullfile(fileDir, [fileName FILE_FORMAT]);

fileID = fopen(filePath,'w');
fprintf(fileID, '%s', fileContents);
fclose(fileID);
    
end
function imcheckerboard(varargin)
% imcheckerboard.m: display checkerboard of two images
%   
% Syntax:
%    1) imcheckerboard('im1'     , im1     , 'im2'     , im2    , ...
%                      'intOpt1' , intOpt1 , 'intOpt2' , intOpt1)
%
% Description:
%    1) imcheckerboard('im1'     , im1     , 'im2'     , im2    , ...
%                      'intOpt1' , intOpt1 , 'intOpt2' , intOpt1)
%       displays a checkerboard representation of  two images, useful to 
%       check visual differences between them (e.g. useful to evaluate 
%       results of image registration algorithms)
%       This function provides: 
%       - option to pick a different colormap for one of the images (one of
%         them is displayed in the 'gray' colormap by default
%       - options for controlling the intensity range for each image
%         (three types of options are possible (absolute, relative and 
%         percentile intensity ranges (IRs), one of which can be used 
%         independently for each image)
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------ 
%    <im1>      matrix        :  2D image | both need to have 
%    <im2>      matrix        :  2D image | equal dimensions
%    ----------------------------- OPTIONAL -------------------------------
%    <blsz>     int > 0       :  block size (in pixels)
%    <cmap>     string        :  builtin colormap string name (colormap.m)
%    <int1>     numeric   $1  :  intensity range (IR) [1x2] 
%    <int2>                         - IR(1) = int(1)
%                                   - IR(2) = int(2)
%    <rint1>    numeric   $1  :  [r]elative IR [1x2]
%    <rint2>                        - IR(1) = min(im(:))*rInt(1)
%                                   - IR(2) = max(im(:))*rInt(2)   
%    <pint1>    numeric   $1  :  [p]ercentile IR [1x2]
%    <pint2>                        - IR(1) = prctile(im(:), pInt(1))
%                                   - IR(2) = prctile(im(:), pInt(2))
%                                default: [min(im(:)) max(im(:))]] 
%    ------------------------------- NOTES --------------------------------
%    $1 - see imclipint.m doc
%    ----------------------------------------------------------------------
%
% Outputs:
%    (displays figure only)
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) imclipint.m
%
% Required files:
%    []
% 
% Examples:
%    >> % Init test images
%    >> im1 = phantom(256);
%    >> im2 = imtranslate(im1, [10, 10]);
%    >> % 1)
%    >> figure; imcheckerboard2('im1', im1, 'im2', im2, 'cmap', 'jet')
%    >> % 2)
%    >> figure; imcheckerboard2('im1', im1, 'im2', im2, 'cmap', 'hot', 'blsz', 40)
%
% fnery, 20160609: original version

COLORMAP_SIZE = 20000;

% ==================================
% ===== Manage input arguments ===== --------------------------------------
% ==================================

for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end    
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'im1'}
            % verify if 'im1' is valid
            isNumeric = isnumeric(cVal);
            isMatrix = ismatrix(cVal);
            if isNumeric && isMatrix            
                im1 = cVal;
            else
                error('Error: ''im1'' is invalid')
            end
        case {'im2'}
            % verify if 'im2' is valid
            isNumeric = isnumeric(cVal);
            isMatrix = ismatrix(cVal);
            if isNumeric && isMatrix            
                im2 = cVal;
            else
                error('Error: ''im2'' is invalid')
            end
        case {'blsz'}
            % verify if 'blsz' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar            
                blSz = cVal;
            else
                error('Error: ''blsz'' is invalid')
            end        
        case {'cmap'}
            % verify if 'cmap' is valid
            isChar = ischar(cVal);
            if isChar        
                cMap = cVal;
            else
                error('Error: ''cmap'' is invalid')
            end
        case {'int1'}  ; int1  = cVal ; % |
        case {'rint1'} ; rInt1 = cVal ; % |
        case {'pint1'} ; pInt1 = cVal ; % | error checks done in
        case {'int2'}  ; int2  = cVal ; % | imclipint.m
        case {'rint2'} ; rInt2 = cVal ; % |
        case {'pint2'} ; pInt2 = cVal ; % |               
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =        ...
    exist('im1' , 'var') & ...
    exist('im2' , 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

if ~isequal(size(im1), size(im2))
    error('Error: input images must have the same size');
end

% Check which options were provided
blSzExists  = exist('blSz'  , 'var');
cMapExists  = exist('cMap'  , 'var');
int1Exists  = exist('int1'  , 'var');
rInt1Exists = exist('rInt1' , 'var');
pInt1Exists = exist('pInt1' , 'var');
int2Exists  = exist('int2'  , 'var');
rInt2Exists = exist('rInt2' , 'var');
pInt2Exists = exist('pInt2' , 'var');

% Defaults
if ~blSzExists ; blSz = round(min(size(im1))/10) ; end;
if ~cMapExists ; cMap = 'gray'                   ; end;

% ==================================
% ===== Clip image intensities ===== --------------------------------------
% ==================================

% im1
nIntOptsIm1 = (int1Exists + rInt1Exists + pInt1Exists);
if nIntOptsIm1 > 1
    error('Error: too many intensity options chosen for <im1>');
end
if     int1Exists  ; im1 = imclipint('im', im1, 'int' , int1)  ;
elseif rInt1Exists ; im1 = imclipint('im', im1, 'rint', rInt1) ;
elseif pInt1Exists ; im1 = imclipint('im', im1, 'pint', pInt1) ;
else   % no change to im1
end

% im2
nIntOptsIm2 = (int2Exists + rInt2Exists + pInt2Exists);
if nIntOptsIm2 > 1
    error('Error: too many intensity options chosen for <im2>');
end
if     int2Exists  ; im2 = imclipint('im', im2, 'int' , int2)  ;
elseif rInt2Exists ; im2 = imclipint('im', im2, 'rint', rInt2) ;
elseif pInt2Exists ; im2 = imclipint('im', im2, 'pint', pInt2) ;
else   % no change to im2
end

% ==========================
% ===== Convert to RGB ===== ----------------------------------------------
% ==========================

% Convert 'im1' to RGB (all channels equal so still displays as grayscale)            
im1 = im1./max(im1(:));
im1 = im1(:,:,[1 1 1]);     

% Convert 'im2' to RGB (colors used for display depends on the cmap)     
im2 = im2./max(im2(:));
im2 = round(im2*COLORMAP_SIZE);
im2(im2==0) = 1;
try 
    cmd = sprintf('cm = colormap(%s(COLORMAP_SIZE));', cMap);
    eval(cmd);
catch
    error('Error: <cmap> seems invalid string')
end
sz = size(im2);
im2 = cm(im2(:), :); %#ok<NODEF> defined in the eval above
im2  = reshape(im2, [sz, 3]);

% ================================
% ===== Display checkerboard ===== ----------------------------------------
% ================================

imshow(im2);
hold on
h = imshow(im1);
hold off
p = ceil(sz(1) / blSz);
q = ceil(sz(2) / blSz);
alphaVal = checkerboard(blSz, p, q) > 0;
alphaVal = alphaVal(1:sz(1), 1:sz(2));
set(h, 'AlphaData', alphaVal);

pause(0.05); drawnow; pause(0.05);

end
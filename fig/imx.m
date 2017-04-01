function h = imx(varargin)
% imx.m: custom imshow/montage function
%   
% Syntax:
%   1) h = imx('im', im, 'opt2', var2 ...)
%
% Description:
%   1) imx displays 2D and 3D images (the latter as a montage).
%      This function has options to:
%      - control display intensity, in absolute and relative terms
%            {argins: <int>, <rint>, <pint>}
%      - control shape of the montage grid
%            {argins: <mgrid>}
%      - add image dividers when displaying volumes as montages
%            {argins: <divw>, <divc>}
%      - highlight points / regions using crosshairs (useful for evaluating
%        registrations)
%            {argins: <ch>, <chw>, <chc>, <chl>}
%      - display composite image of a base image (grayscale) and a
%        parametric map (RGB). This is done by specifying the locations
%        (pixels) of the parametric map to overlay on the base image using
%        a mask. The colorbar (if desired) corresponds to the parametric map
%        This requires a specific struct as an argin which can be created
%        with imxov.m (ov=overlay)
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------
%    <im>      numeric    :   2-3D image to display
%    ------------------------------ OPTIONAL ------------------------------
%    <int>     numeric    :   intensity range (IR) [1x2] 
%                                 - IR(1) = int(1)
%                                 - IR(2) = int(2)
%    <rint>    numeric    :   [r]elative IR [1x2]
%                                 - IR(1) = min(im(:))*rInt(1)
%                                 - IR(2) = max(im(:))*rInt(2)   
%    <pint>    numeric    :   [p]ercentile IR [1x2]
%                                 - IR(1) = prctile(im(:), pInt(1))
%                                 - IR(2) = prctile(im(:), pInt(2))
%                                 default: [min(im(:)) max(im(:))]] 
%    <mgrid>   $1 int     :   montage grid shape [1x2]
%                                 - [nRows , nColumns]
%                                 - [NaN   , nColumns]: forces no. of cols
%                                 - [nRows , NaN]     : forces no. of rows
%                                 default: similar to montage.m
%    <divw>    $1 int>0   :   divider width [1x1] 
%                                 - default: 1
%    <divc>    $1 num     :   divider color ([1x3] RGB vector) 
%                                 - default: [1 1 1]
%    <ch>      numeric    :   [c]ross[h]air centre coordinates (x,y,[z])
%                                 - [Nx2]: 2D ims
%                                 - [Nx3]: 3D ims (N = no. of crosshairs)
%              string     :   'grid': creates a crosshair grid
%    <chd>     int>0      :   no. (density) of grids per image plane [1x1]
%                                 - only available if <ch> is 'grid'
%              []         :   uses a default number of grids
%    <chw>     int>0      :   crosshair width [1x1] 
%                                 - default: 1
%    <chc>     numeric    :   crosshair color ([1x3] RGB vector) 
%                                 - default: [1 1 1]
%    <chl>     int>0      :   crosshair length [1x1] 
%                                 - default: equivalent to dims of <im>
%    <ov>      $2 imxov.m :  struct: data to overlay into 'im', with fields:
%                                |--map:  $3 param map with data to overlay
%                                |--mask: $3 mask with locations to overlay
%                                |--cAx:  intensity range (IR) for map
%    ------------------------------ NOTES ---------------------------------
%    $1 only available if <im> is 3D
%    $2 this should be turned into a class
%    $3 these matrices must have the same dimensions as 'im'
% 
% Outputs:
%    1) h: imshow handle 
%
% Notes/Assumptions: 
%   1) I could create an outside border as follows, but it isn't pretty 
%      because its not right on the edges of the figure:
%      % Make outside border
%      border = [ 0      , xLen3D , 0      , 0      ; ...
%                 0      , xLen3D , yLen3D , yLen3D ; ... 
%                 0      , 0      , 0      , yLen3D ; ... 
%                 xLen3D , xLen3D , 0      , yLen3D ];
%     
%      for i = 1:4 % 4 border lines
%          line([border(i, 1), border(i, 2)], ...
%               [border(i, 3), border(i, 4)], ...
%               'Color', divc, 'LineWidth', divw);
%      end
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%    2) isint.m
%    3) mgridshape.m
%    4) vol2mont.m
%    5) imxov.m (indirectly: to create <ov> argin for this function)
%    6) xyz2xy.m
%    7) xy2xyz.m
%
% Required files:
%   1) imxov.m
% 
% Examples:
%    % Create test volume  with non-square in-plane dimensions to make
%    % sure that row/col processing has no bugs
%    im(:,:,1) = phantom(256);
%    im(:,:,2) = imtranslate(im(:,:,1), [15, 15]);
%    im(:,:,3) = imtranslate(im(:,:,1), [30, 30]);
%    im(:,:,4) = imtranslate(im(:,:,1), [45, 45]);
%    im(:,:,5) = imtranslate(im(:,:,1), [60, 60]);
%    im(:,:,6) = imtranslate(im(:,:,1), [75, 75]);
%    im = im + randn(size(im))./10;
%    im(:,1:30,:) = [];
%    
%    % Specify points to highlight (crosshair)
%    ch(1,:) = [98, 9, 1];
%    ch(2,:) = [175, 122, 3];
%    
%    % Display
%    figure; imx('im', im, 'rint', [0 1]);
%    figure; imx('im', im, 'mgrid', [3 2]);
%    figure; imx('im', im, 'mgrid', [3 2], 'divw', 3, ...
%        'divc', [1 0 0]);
%    figure; imx('im', im, 'mgrid', [1 6], 'divw', 1, ...
%        'divc', [1 0 0], 'ch', 'grid', 'chc', [0 1 0]);
%    
%    % Display image above with parametric map (which is the same as 'im')
%    map = im;
%    mask = false(size(im));
%    mask(30:110, 30:60, 1) = true;
%    mask(130:160, 130:210, 3) = true;
%    ImxOv = imxov(map, mask);
%        figure; imx('im', im, 'mgrid', [1 6], 'divw', 1, ...
%        'divc', [1 0 0], 'ch', ch, 'chc', [0 1 0], 'chl', 30, ...
%        'ov', ImxOv);
%
% fnery, 20160612: original version
% fnery, 20160629: added <pint> option
% fnery, 20160917: added <ov> option
% fnery, 20170206: added option for full crosshair grid (if <ch> argument is 'grid')

EXPECTED_OV_FIELDS = {'map', 'mask', 'cAx'};
CHD_DEFAULT        = 5; % default nGrids per image plane if <ch> = 'grid'

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
        case {'im'}
            % verify if 'im' is valid
            isNumeric = isnumeric(cVal);
            isLogical = islogical(cVal);
            hasCorrectDims = ismatrix(cVal) || ndims(cVal) == 3;
            if (isNumeric || isLogical) && hasCorrectDims
                im = double(cVal);
            else
                error('Error: ''im'' is invalid')
            end
        case {'int'}
            % verify if 'int' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                int = cVal;
            else
                error('Error: ''int'' is invalid')
            end
        case {'rint'}
            % verify if 'rint' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                rInt = cVal;
            else
                error('Error: ''rint'' is invalid')
            end
        case {'pint'}
            % verify if 'pint' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                pInt = cVal;
            else
                error('Error: ''pint'' is invalid')
            end            
        case {'mgrid'}
            % verify if 'mgrid' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                mGrid = cVal;
            else
                error('Error: ''mgrid'' is invalid')
            end            
        case {'divw'}
            % verify if 'divw' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                divW = cVal;
            else
                error('Error: ''divw'' is invalid')
            end    
        case {'divc'}
            % verify if 'divc' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 3;
            if isNumeric && is1d(cVal) && hasCorrectLen
                divC = cVal;
            else
                error('Error: ''divc'' is invalid')
            end
        case {'ch'}
            % verify if 'ch' is valid
            allInts = all(isint(cVal(:)));
            isMatrix = ismatrix(cVal);
            hasCorrectDims = size(cVal,2)==2 || size(cVal,2)==3;
            if allInts && isMatrix && hasCorrectDims
                ch = cVal;
            elseif strcmp(cVal, 'grid')
                ch = cVal;       
            else
                error('Error: ''ch'' is invalid')
            end
        case {'chd'}
            % verify if 'chd' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                chD = cVal;
            else
                error('Error: ''chd'' is invalid')
            end               
        case {'chw'}
            % verify if 'chw' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                chW = cVal;
            else
                error('Error: ''chw'' is invalid')
            end   
        case {'chc'}
            % verify if 'chc' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 3;
            if isNumeric && is1d(cVal) && hasCorrectLen
                chC = cVal;
            else
                error('Error: ''chc'' is invalid')
            end            
        case {'chl'}
            % verify if 'chl' is valid
            isInt = isint(cVal);
            isScalar = isscalar(cVal);
            if isInt && isScalar
                chL = cVal;
            else
                error('Error: ''chl'' is invalid')
            end
        case {'ov'}
            % verify if 'ov' is struct
            isStruct = isstruct(cVal);
            % verify if 'ov' has correct fields
            if isStruct
                cFields = fieldnames(cVal)';
                correctFields = isequal(cFields, EXPECTED_OV_FIELDS);
                if correctFields
                    ov = cVal;
                else
                    error('Error: ''ov'' is struct, but not valid')
                end
            else
                error('Error: ''ov'' must be a struct')
            end            
        otherwise
            error('Error: input argument not recognized');
    end
end

% ====================
% ===== Defaults ===== ----------------------------------------------------
% ====================

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('im', 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end
[nRows, nCols, nSlices] = size(im);

% Check which argins were provided
intExists   = exist('int'   , 'var');
rIntExists  = exist('rInt'  , 'var');
pIntExists  = exist('pInt'  , 'var');
mGridExists = exist('mGrid' , 'var');
divWExists  = exist('divW'  , 'var');
divCExists  = exist('divC'  , 'var');
chExists    = exist('ch'    , 'var');
chDExists   = exist('chD'   , 'var');
chWExists   = exist('chW'   , 'var');
chCExists   = exist('chC'   , 'var');
chLExists   = exist('chL'   , 'var');
ovExists    = exist('ov'    , 'var');
if ~divWExists ; divW = 1       ; end;
if ~divCExists ; divC = [1 1 1] ; end;
if ~chWExists  ; chW  = 1       ; end;
if ~chCExists  ; chC  = [0 0 1] ; end;
if ~chLExists  ; chL  = max([nRows nCols]) ; end; % to match img dims

% ========================
% ===== Error checks ===== ------------------------------------------------
% ========================

% Single-slice argin restrictions
if nSlices == 1 && mGridExists
    error('Error: can''t use <mgrid> with a 2D <im>');
elseif nSlices == 1 && divWExists
    error('Error: can''t use <divw> with a 2D <im>');
elseif nSlices == 1 && divCExists
    error('Error: can''t use <divc> with a 2D <im>');
elseif nSlices == 1 && chExists && (~ischar(ch) && size(ch, 2)>2)
    error('Error: can''t use an [x,y,z] <ch> with a 2D <im>');
end

% Ensure no "ch" options are used if <ch> is not provided
if (chDExists || chWExists || chCExists || chLExists) && ~chExists
    error('Error: can''t use <chd>, <chw>, <chc> or <chl> when not using <ch>');
end

% Ensure <ch> is 'grid' if <chd> is being used
if (chExists && ~strcmp(ch, 'grid')) && chDExists
    error('Error: can''t use <chd> unless <ch> is ''grid''')
end

% ===================================
% ===== Image display intensity ===== -------------------------------------
% ===================================

imVec = im(:);
maxI  = max(imVec);
minI  = min(imVec);

nIntOpts = intExists + rIntExists + pIntExists;
if nIntOpts == 0
    intRange = [minI, maxI];
elseif nIntOpts > 1
    error('Error: can use only one of: <int>, <rint>, <pint>');
elseif intExists
    intRange = [int(1), int(2)];
elseif rIntExists
    intRange = [minI*rInt(1) maxI*rInt(2)];
else 
    % pintExists
    intRange = [prctile(imVec, pInt(1)) prctile(imVec, pInt(2))];
end
clear imVec;

% =======================
% ===== mGrid shape ===== -------------------------------------------------
% =======================

% Default <mgrid> shape
if ~mGridExists && (nSlices > 1)
    mGrid = mgridshape('nIms', nSlices);
elseif ~mGridExists && (nSlices == 1)
    mGrid = [1 1];
end

if mGridExists && (sum(isnan(mGrid)) == 1)
    nanPos = find(isnan(mGrid));
    if nanPos == 1
        mGrid = mgridshape('nIms', nSlices, 'nCols', mGrid(2));
    elseif nanPos == 2
        mGrid = mgridshape('nIms', nSlices, 'nRows', mGrid(1));
    end
elseif mGridExists && (sum(isnan(mGrid)) == 2)
    error('Error: Only one of the elements in <mgrid> can be NaN');
end

% ==========================================
% ===== Convert 3D volumes to montages ===== ------------------------------
% ==========================================

if nSlices > 1
    im = vol2mont(im, mGrid);
    xLen2D = nCols;
    yLen2D = nRows;
    [yLen3D, xLen3D] = size(im);
    y4szCheck = yLen3D;
    x4szCheck = xLen3D;
else
    [y4szCheck, x4szCheck] = size(im);
end

% ============================
% ===== Display image(s) ===== --------------------------------------------
% ============================

if ~ovExists
    h = imshow(im, intRange);
else
    % Crop the intensities in 'im' according to 'intRange'
    % (because 'im' will always be displayed w/ caxis when doing overlays:
    % so we need to decide which intensities to show beforehand by
    % changing the matrix itself)
    im(im<=intRange(1)) = intRange(1);
    im(im>=intRange(2)) = intRange(2);
    
    map = ov.map;
    
    if size(map, 3) > 1
        map = vol2mont(map, mGrid);
        ov.mask = vol2mont(ov.mask, mGrid);
        [yLenMap, xLenMap] = size(map);
    else
        [yLenMap, xLenMap] = size(map);
    end
    
    if ~isequal([y4szCheck, x4szCheck], [yLenMap, xLenMap])
        error('Error: ''im'' and overlay map must have the same dimensions');
    end
    
    % {
    % Large intensity hack 
    % --------------------
    % Because the upper intensity range for displaying 'im' is always
    % max(im), if we specify an intensity larger than this (using the
    % argin 'intRange') it will be ignored. So we take one voxel of base 
    % which will be overlayed by map (and therefore not be seen) and assign 
    % it the max intensity of 'intRange'
    [tmp1,tmp2] = ind2sub(size(ov.mask), find(ov.mask==1, 1));
    im(tmp1,tmp2) = intRange(2);
    % --------------------
    % Large intensity hack 
    % }
        
    cAxMin = ov.cAx(1);
    cAxMax = ov.cAx(2);
    map(map<=cAxMin) = cAxMin;
    map(map>=cAxMax) = cAxMax;
        
    im = im/(max(im(:)));          % normalize base (anatomical) image
    rgbBase = im(:,:,[1 1 1]);     % converting to RGB (ignore colormaps)
    imshow(map, ov.cAx);           % show parametric image
    colormap(gca, 'jet');          % apply colormap
    hold on;
    h = imshow(rgbBase);           % superimpose anatomical image
    set(h, 'AlphaData', ~ov.mask); % make pixels in the ROI transparent
    
end
hold on;

% ============================
% ===== Display dividers ===== --------------------------------------------
% ============================

if divWExists
        
    % number of divider lines in each direction
    nYDivs = mGrid(1)-1;
    nXDivs = mGrid(2)-1;
    
    % horizontal dividers (i.e. yDivs)
    tmp1 = repmat([1 xLen3D], [nYDivs, 1]);
    tmp2 = repmat(1+yLen2D*(1:nYDivs)', [1, 2]);
    yDivs = horzcat(tmp1, tmp2);
    
    % vertical dividers (i.e. xDivs)
    tmp1 = repmat(1+xLen2D*(1:nXDivs)', [1, 2]);
    tmp2 = repmat([0 yLen3D+1], [nXDivs, 1]); 
        % use tmp2 = repmat([1 yLen3D], [nXDivs, 1]); if lines too tall
    xDivs = horzcat(tmp1, tmp2); % xDivs
    
    % concatenate
    d = vertcat(yDivs, xDivs); % coordinates of all divider lines
    
    % Display
    for iD = 1:size(d, 1)
        line([d(iD,1),d(iD,2)], [d(iD,3),d(iD,4)], ... 
            'Color', divC, 'LineWidth',divW);
    end

end

% ==============================
% ===== Display crosshairs ===== ------------------------------------------
% ==============================

if chExists
    
    % If <ch> is char, by now it must be 'grid'. In this case, 1st step is
    % to compute the coordinates of each grid pixel. After this, 'ch' is in
    % the same format regardless of what the user provided.
    if ischar(ch)
        if ~chDExists
            chD = CHD_DEFAULT;
        end
        ch = chgrid([nRows, nCols, nSlices], chD);    
    end
    
    % Convert crosshair coordinates to 2D, since we will display a montage
    if size(ch, 2) == 3
        ch = xyz2xy('xyz', ch, 'sz', [nRows nCols nSlices], 'mgrid', mGrid);
    end
    
    % Display all crosshairs
    for iCh = 1:size(ch,1)
        cX = ch(iCh, 1);
        cY = ch(iCh, 2);
        chdisp(cX, cY, [nRows nCols nSlices], mGrid, chL, chC, chW);
    end
    
end

end

% -------------------------- imx's subfunctions ---------------------------

% ====================
% ===== chgrid.m ===== ----------------------------------------------------
% ====================

function coords = chgrid(imDims, n)
% chgrid.m: coords of in-plane grid to display crosshairs in a 2-3D image
%   
% Syntax:
%    1) coords = chgrid(imDims, n)
%
% Description:
%    1) coords = chgrid(imDims, n) initialises the coordinates of an 
%       in-plane grid used to later display crosshairs in a 2-3D image (im). 
%       The user specifies the number of grids per image (n).
%
% Inputs:
%    1) imDims: [1x3] image dimensions vector [nRows, nColumns, nSlices]
%    2) n (int>0): number (density) of grids per image plane 
% 
% Outputs:
%    1) coords: [nPoints x 3] (x,y,z) coordinates
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20170206: original version
% fnery, 20170328: updated doc, now strictly requires 2 argins
% fnery, 20170329: now 1st argin is image dimensions, not the image itself

if nargin ~= 2
    error('Error: This function needs two input arguments');
end

nR = imDims(1);
nC = imDims(2);
nS = imDims(3);

rAux = round(nR/n);
cAux = round(nC/n);

r = rAux:rAux:nR;
c = cAux:cAux:nC;
s = 1:nS;

lenRCS = [length(r) length(c) length(s)];

coords = NaN(prod(lenRCS), 3);
ct = 0;
for iR = 1:length(r)
    for iC = 1:length(c)
        for iS = 1:length(s)
            ct = ct + 1;
            coords(ct, :) = [c(iR) r(iC) s(iS)]; % note conversion rcs->xyz 
        end
    end
end

if any(isnan(coords(:)))
   error('Error: something went wrong in chgrid.m coords initialisation'); 
end

end

% ====================
% ===== chdisp.m ===== ----------------------------------------------------
% ====================

function chdisp(x, y, sz, mGrid, chL, chC, chW)
% chdisp.m: displays crosshair in current figure at specified coordinates
%   
% Syntax:
%    1) chdisp(x, y, sz, mGrid, chL, chC, chW)
%
% Description:
%    1) chdisp(x, y, sz, mGrid, chL, chC, chW) displays a crosshair in the 
%       current figure at specified coordinates
%
% Inputs:
%    1) x     : x coordinate
%    2) y     : y coordinate
%    3) sz    : underlying image size [nRows nCols nSlices]
%    4) mGrid : mGrid shape (from mgridshape.m)
%    5) chL   : length (size) of crosshair
%    6) chC   : crosshair color
%    7) chW   : crosshair width
% 
% Outputs:
%    (adds two lines, making up a crosshair, to the current figure)
%
% Notes/Assumptions: 
%    1) Likely to use only within imx.m
%
% References:
%    []
%
% Required functions:
%    1) xy2xyz.m
%
% Required files:
%    []
% 
% Examples:
%    >> im = phantom(128);
%    >> figure, imshow(im, []);
%    >> chdisp(80, 50, size(im), [1 1], 30, [0 1 0], 1);
%
% fnery, 20160612: original version
% fnery, 20170330: updated doc

if length(sz) == 2
    sz(end+1) = 1;
end

xyz = xy2xyz('xy', [x y], 'sz', sz, 'mgrid', mGrid);

if sum(xyz) == 0
    return;
end

% Make sure we don't go over dividers
if xyz(1)-chL < 0
    xMin = x-xyz(1)+2;
else
    xMin = x-chL;
end

if xyz(2)-chL < 0
    yMin = y-xyz(2)+2;
else
    yMin = y-chL;
end

if xyz(1)+chL > sz(2)
    toAddX = sz(2)-xyz(1);
    xMax = x+toAddX;
else
    xMax = x+chL;
end

if xyz(2)+chL > sz(1)
    toAddY = sz(1)-xyz(2);
    yMax = y+toAddY;
else
    yMax = y+chL;
end

% Display crosshair
line([xMin xMax], [y    y   ], 'Color', chC, 'LineWidth', chW, 'LineStyle', '--');
line([x    x   ], [yMin yMax], 'Color', chC, 'LineWidth', chW, 'LineStyle', '--');

pause(0.05); drawnow; pause(0.05);

end
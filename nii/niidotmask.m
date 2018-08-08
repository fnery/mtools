function out = niidotmask(varargin)
% niidotmask.m: process NIfTI 'dotmask' file
%
% Syntax:
%    1) paths = niidotmask('in', in, 'oris', oriS, 'orif', oriF, ...
%           'outtype', 'mask', 'outdir', outDir, 'outname', outName)
%    2) slice = niidotmask('in', in, 'oris', oriS, 'orif', oriF, ...
%           'outtype', 'slice')
%    3) fics  = niidotmask('in', in, 'oris', oriS, 'orif', oriF, ...
%           'outtype', 'fics')
%    4) swk   = niidotmask('in', in, 'oris', oriS, 'orif', oriF, ...
%           'outtype', 'swk')
%
% Description:
%    1) creates NIfTI logical files with masks as defined in the NIfTI
%       dotmask file. The NIfTI dotmask is a logical file where the only
%       1-valued voxels are extreme points that define rectangles around
%       regions of interest. There are several ways to define the dotmask
%       file. These are described (with examples) in [1]
%    2) allows one slice to be highlighted by adding one 1-valued voxel to
%       the boundary of the desired slice (see [1] for an example). No mask
%       files will be created. The only output would be a scalar
%       corresponding to the index of the slice of interest (see Note 1),
%       in the "post-cropping" volumes (and using 0-indexing).
%    3) Instead of creating NIfTI mask files, the output will be sets of
%       [1x6] coordinate vectors that can be directly fed to fslroi to crop
%       the NIfTI file used to generate dotmask, as specified in dropmask
%       to crop NIfTI datasets with FSL's fslroi function [2].
%    4) Instead of creating NIfTI mask files, the output will be a vector
%       whose elements corresponds to slice indexes where kidneys are in
%       the FOV according to dotmask
%
% Inputs:
%    -------------------------------- MANDATORY ---------------------------
%    <in>       string  :  path to dotmask file
%    <oris>     cell    :  (of strings) start orientation - see volori.m
%    <orif>     cell    :  (of strings) final orientation - see volori.m
%    <outtype>  string  :  string which can be:
%                          - mask  : to create NIfTI mask files
%                          - slice : to retrieve the highlighted slice
%                          - fics  : '[f]slroi [i]nput [c]oordinate[s]'
%                          - swk   : '[s]lices [w]ith [k]idneys�?
%    -------------------------------- OPTIONAL ----------------------------
%    <outdir>   string  :  directory where created NIfTI mask files are to
%                          be saved (only allowed when <outtype> is 'mask')
%    <outname>  string  :  base name for to-be-created NIfTI mask files
%                          (only allowed when <outtype> is 'mask'=
%                          Example: say i) 'outname'='mask' and ii) the
%                          dotmask file defines two masks: the absolute
%                          paths of the output files will be:
%                          >> fullfile(outdir, 'mask_01of02')
%                          >> fullfile(outdir, 'mask_02of02')
%    --------------------------------------------------------------------------
%
% Outputs:
%    1) Depending on the input argument <outtype>:
%       - If <outtype> is 'mask':
%             maskPath: full paths to created NIfTI mask files
%       - If <outtype> is 'slice'
%             highlightIdx: index of slice highlighted in dotmask
%       - If <outtype> is 'fics'
%             fics: cell of strings with [f]slroi [i]nput [c]oordinate[s]
%                   each element of the cell is a [1x6] vector (in string
%                   format to use in the terminal) with format:
%                       <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
%                   which defines one cropping operation
%       - If <outtype> is ‘swk’
%             swk: vector with slice indexes where kidneys are in the FOV
%
% Notes/Assumptions:
%    1) Unlike MATLAB, this function follows the same indexing convention as
%       FSL, i.e. 0-indexing (since as of now my plan is to create dotmask
%       files using FSLview).
%    2) This function assumes that we are moving laterally (left<-->right)
%       in dotmask in the column direction (more info in the subfunction
%       named processmask.m)
%
% References:
%    [1] mtools/auxl/richdoc/niidotmask.pdf
%    [2] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%    [3] mathworks.com/matlabcentral/fileexchange/8797
%
% Required functions:
%    1) load_untouch_nii.m (available in [3])
%    2) volori.m
%    3) save_untouch_nii.m (available in [3])
%    4) m2fsl.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180303: original version
% fnery, 20180328: now outputs 'highlightIdxAfterCrop'
% fnery, 20180808: added 'swk' 'outtype' option'

POSSIBLE_OUTTYPES = {'mask', 'slice', 'fics', 'swk'};

% _________________________________________________________________________
%                          Manage input arguments
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'in'}
            if ischar(cVal)
                in = cVal;
            else
                error('''in'' must be string (dotmask NIfTI file path)');
            end
        case {'oris'}
            if iscell(cVal)
                oriS = cVal;
            else
                error('''oris'' must be cell of strings (see volori.m)');
            end
        case {'orif'}
            if iscell(cVal)
                oriF = cVal;
            else
                error('''orif'' must be cell of strings (see volori.m)');
            end
        case {'outtype'}
            outTypeValid = ~isempty(find(strcmp(cVal,POSSIBLE_OUTTYPES),1));
            if outTypeValid
                outType = cVal;
            else
                outTypeOpts = sprintf('''%s'', ', POSSIBLE_OUTTYPES{:});
                outTypeOpts(end-1:end) = [];
                error('''outtype'' must be string (%s)', outTypeOpts);
            end
        case {'outdir'}
            if ischar(cVal)
                outDir = cVal;
            else
                error('''outdir'' must be string (path to output dir)');
            end
        case {'outname'}
            if ischar(cVal)
                outName = cVal;
            else
                error('''outname'' must be string (name for output files)');
            end
        otherwise
            error('Input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =        ...
    exist('in'      , 'var') & ...
    exist('oriS'    , 'var') & ...
    exist('oriF'    , 'var') & ...
    exist('outType' , 'var');
if ~allMandatoryOptsExist
    error('One or more mandatory options are missing');
end

% Input arguments 'outdir'/'outname' only allowed when creating mask files
outDirExists  = exist('outDir' , 'var');
outNameExists = exist('outName', 'var');

outTypeIsMask  = strcmp(outType, 'mask');
outTypeIsSlice = strcmp(outType, 'slice');
outTypeIsFics  = strcmp(outType, 'fics');
outTypeIsSwk   = strcmp(outType, 'swk');

if ~outTypeIsMask && outDirExists
    error('''outdir'' input only allowed if ''outtype'' is ''mask''');
elseif ~outTypeIsMask && outNameExists
    error('''outname'' input only allowed if ''outtype'' is ''mask''');
elseif outTypeIsMask && ~outDirExists
    error('''outdir'' input must be provided if ''outtype'' is ''mask''');
elseif outTypeIsMask && ~outNameExists
    error('''outname'' input must be provided if ''outtype'' is ''mask''');
end

% Load NIfTI file (requires toolbox in [3])
nii = load_untouch_nii(in);

% Change orientation of volume to as required (see note TKD)
dotMask = volori(nii.img, oriS, oriF);

% Find highlight-slice voxel (if it exists) and remove it from the mask for
% further processing. Also save the index of the highlighted slice.
[~, highlightIdxAfterCrop, dotMaskNoHighlight] = findrmhighlight(dotMask);

% Create mask by filling dots (see note TKD)
mask = processmask(dotMaskNoHighlight);

if outTypeIsSlice

    % Here just need to get the highlighted slice index (already calculated)
    out = highlightIdxAfterCrop;
    return;

elseif outTypeIsMask

    % Go back to original orientation for saving mask as NIfTIs
    mask = volori(mask, oriF, oriS);

    % Save mask as NIfTI files
    out = createniimasks(mask, nii, outDir, outName);

elseif outTypeIsFics

    % Compute fslroi input coordinates
    out = computefics(mask);

elseif outTypeIsSwk

    % Compute fslroi input coordinates
    fics = computefics(mask);
    % Compute slices with kidneys (swk) vector
    out = fics2swk(fics);

else
    error('Error: this point should never be reached');
end

end

% ===========================
% ===== findrmhighlight ===== ---------------------------------------------
% ===========================

function [highlightIdx, highlightIdxAfterCrop, dotMaskNoHighlight] = findrmhighlight(dotMask)
% findrmhighlight.m: find highlighted slice index and removes highlight
%                    voxel marker from mask
%
% Description:
%    1) [highlightIdx, dotMaskNoHighlight] = findrmhighlight(dotMask) computes
%       the index of the highlighted slice (if it exists) and removes
%       the voxel marker that defines which slice is highlighted from dotmask
%
% Outputs:
%    1) highlightIdx: index of slice highlighted in dotmask (empty if it
%       doesn't exist)
%    2) highlightIdxAfterCrop: analogous to highlightIdx but after
%       accounting for subsequent cropping operation, that is, this index
%       will correspond to the highlighted slice in the cropped volumes
%       doesn't exist)
%    3) dotMaskNoHighlight: dotmask WITHOUT the voxel marker that defines
%       which slice is highlighted
%
% Notes/Assumptions: 
%    1) Assumes highlight slice voxel marker is on the border of dotmask
%       (as specified in [1])
%    2) Both highlightIdx and highlightIdxAfterCrop are stored with
%       0-indexing as used in FSLview
%
% References:
%    [1] mtools/auxl/richdoc/niidotmask.pdf
%
% Required functions:
%    []
%
% fnery, 20180303: original version
% fnery, 20180328: now outputs 'highlightIdxAfterCrop'

cc = bwconncomp(dotMask, 4);

% Find index of dots that are on at least one boundary of cSlice
[r, c, s] = ind2sub(size(dotMask), vertcat(cc.PixelIdxList{:}));
[matchingRows, ~] = find(horzcat(r, c) == 1);

% And also allow the dot in both borders at the same time (if the highlight
% voxel marker is in the image vertices
matchingRows = unique(matchingRows);

if isempty(matchingRows)
    % No voxels on the boundary exist, therefore no slice was highlighted
    
    dotMaskNoHighlight = dotMask;
    highlightIdx = [];
    
elseif numel(matchingRows) == 1
    % Only on voxel exists in the boundaries of dotMask
    
    boundaryDotIdx = unique(matchingRows);
    
    % Get index of highlighted slice
    highlightIdx = s(boundaryDotIdx)-1; % -1: 0-indexing  
    
    % Get index of highlighted slice (after cropping)
    sAfterCrop = s-min(s);
    highlightIdxAfterCrop = sAfterCrop(boundaryDotIdx)-1; % -1: 0-indexing  
    
    % Remove
    dotMaskNoHighlight = dotMask;
    dotMaskNoHighlight(cc.PixelIdxList{boundaryDotIdx}) = false;
    
else
    
    error('Error: ''dotMask'' must have one or none 1-valued voxels on its boundaries')
    
end

end

% =======================
% ===== processmask ===== -------------------------------------------------
% =======================

function mask = processmask(in)
% processmask.m: creates filled masks based in dotmask
%
% Description:
%    1) mask = processmask(in) creates NIfTI files with filled masks based
%       in dotmask
%
% Outputs:
%    1) mask: 4D volume of masks (4th dim indexes 3D mask volumes)
%
% Notes/Assumptions: 
%    1) Assumption 1: each mask is defined by two points
%    2) Additional notes if necessary
%
% References:
%    []
%
% Required functions:
%    []
%
% fnery, 20180303: original version

N_DOTS_PER_MASK = 2;

% Compute number masks we will need to fill
cc = bwconncomp(in, 6);
[~, ~, s] = ind2sub(size(in), vertcat(cc.PixelIdxList{:}));

x = zeros(size(s));
for i = 1:length(s)
    x(i) = sum(s==s(i));
end
maxDotsInOneSlice = max(x);

nMasks = maxDotsInOneSlice/N_DOTS_PER_MASK; % see Assumption 1

[nRows, nCols, nSlices] = size(in);

mask = false(nRows, nCols, nSlices, nMasks);
maskSum4D = false(nRows, nCols, nSlices);

% Fill masks on a slice-by-slice fashion
for iSlice = 1:nSlices
    
    cSlice = in(:,:,iSlice);
  
    % Ensure all connected components are a single pixel only
    cConnComp = bwconncomp(cSlice, 4);
    x = find(cellfun('length', cConnComp.PixelIdxList(:)) > 1, 1);
    if ~isempty(x)
        error('Error: Slice %d in ''dotmask'' can''t have connected components of size > 1 pixel', iSlice);
    end    
    
    % Deal with slices with and without dots
    if cConnComp.NumObjects == 0
        
        % Slice with no dots
        continue;
        
    elseif rem(cConnComp.NumObjects, 2) == 1 
        
        % Odd number of dots
        error('Error: dotMask can''t have an odd number of ''dots'' in any slice');
              
    end
    
    % Create mask by filling cSlice (at this point only has boundary dots)
    
    % The number masks in a given slice can be different than the total
    % number of masks (one dataset can have two kidneys and at the same
    % contain slices with a single kidney when one kidney is more anterior
    % or posterior than the other) 
    cnMasks = numel(find(s==iSlice))/N_DOTS_PER_MASK;

    cMask = false(nRows, nCols);
    
    for iMask = 1:cnMasks
        
        [cRow, cCol] = ind2sub([nRows, nCols], [cConnComp.PixelIdxList{:}]);
        
        % Coordinates of voxels in the variables returned by ind2sub above
        % are in the order of increasing column. Therefore, since we assume
        % that we are moving laterally in dotmask in the column direction
        % the extremes of mask 1 will be given in the indexes 1 and 2 of
        % the outputs of ind2sub, the extremes of mask 2 will be given in
        % the indexes 3 and 4 of the outputs of ind2sub
        cIdxs = iMask*2-1:iMask*2;  
        cMask(cRow(cIdxs(1)):cRow(cIdxs(2)), cCol(cIdxs(1)):cCol(cIdxs(2))) = 1;
        maskSum4D(:,:,iSlice) = cMask;
        
    end
 
end

% Separate 3D connected components (assume each will be one 3D mask)
cc = bwconncomp(maskSum4D, 6);

if cc.NumObjects ~= nMasks
    error('Error: looks like the 3D mask(s) are not connected components');
end

for iMask = 1:nMasks
    tmp = false(nRows, nCols, nSlices);
    tmp(cc.PixelIdxList{iMask}) = true;
    mask(:,:,:,iMask) = tmp;
end  

end

% ==========================
% ===== createniimasks ===== ----------------------------------------------
% ==========================

function out = createniimasks(mask, nii, outDir, outName)
% createniimasks.m: saves 3D masks in NIfTI format
%
% Outputs:
%    1) out: paths of created files
%
% Required functions:
%    1) save_untouch_nii.m
%
% fnery, 20180303: original version

OUT_EXT = '.nii.gz';

nMasks = size(mask, 4);

out = cell(nMasks, 1);

for iMask = 1:nMasks
    
    % Fill in nii struct
    cMask = squeeze(mask(:,:,:,iMask));
    cNii = nii;
    cNii.img = cMask;
    
    % Create and save file path for output
    out{iMask} = sprintf('%s_%02d%s', ...
        fullfile(outDir, outName), iMask, OUT_EXT);
    
    % Save new .nii file
    save_untouch_nii(cNii, out{iMask});

end

end

% =======================
% ===== computefics ===== -------------------------------------------------
% =======================

function out = computefics(mask)
% computefics.m: computes [f]slroi [i]nput [c]oordinate[s]
%
% Description:
%    1) out = computefics(mask) creates a cell of strings, where each cell
%       containts a [1x6] vector (in string format) with [f]slroi [i]nput
%       [c]oordinate[s]
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%
% Required functions:
%    1) m2fsl.m
%
% fnery, 20180303: original version

[nRows, ~, ~, nMasks] = size(mask);

out = cell(nMasks, 1);

for iMask = 1:nMasks
    
    cMask = squeeze(mask(:,:,:,iMask));
    
    % Assumption 1: Each mask will be a single connected component in 3D
    cConnComp = bwconncomp(cMask, 6);
    
    if cConnComp.NumObjects ~= 1
        error('Error: Each 3D mask must be a single 3D connected component');
    end
    
    % Get row-col-slice coordinates of voxels in cMask
    [cR, cC, cS] = ind2sub(size(cMask), vertcat(cConnComp.PixelIdxList{1}));
    
    % Convert to fsl-format coordinates
    [cX, cY, cZ] = m2fsl(cR, cC, cS, nRows);
    
    % Compute fslroi [1] input coordinates (fics)
    cxMax = max(cX);
    cyMax = max(cY);
    czMax = max(cZ);
    cxMin = min(cX);
    cyMin = min(cY);
    czMin = min(cZ);

    % Here, we have coordinates in the format 
    %     <xmin> <xmax> <ymin> <ymax> <zmin> <zsmax>, 
    % fslroi requires cropping coordinates in the format
    %     <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
    cxSz = (cxMax-cxMin)+1;
    cySz = (cyMax-cyMin)+1;
    czSz = (czMax-czMin)+1;

    % Save fics as string ready to be fed to fslroi
    out{iMask} = sprintf('%d %d %d %d %d %d', ...
        cxMin, cxSz, cyMin, cySz, czMin, czSz);
    
end

end

% ====================
% ===== fics2swk ===== ----------------------------------------------------
% ====================

function swk = fics2swk(fics)
% fics2swk.m: converts fsl input coordinates to slices with kidneys vector
%
% Syntax:
%    1) swk = fics2s(fics)
%
% Description:
%    1) swk = fics2s(fics) converts fsl input coordinates to slices with
%       kidneys vector
%
% Inputs:
%    1) fics: cell output from niidotmask.m when 'outtype' is 'fics'
%
% Outputs:
%    1) swk: vector whose elements are the indices of slices where the
%       kidneys are in the field-of-view (FOV)
%
% Notes/Assumptions:
%    []]
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
% fnery, 20180808: original version

nFics = length(fics);

ficsMat = NaN(nFics, 6);

for iFics = 1:nFics
    cFics = fics{iFics};
    ficsMat(iFics, :) = str2num(cFics); %#ok<ST2NM>
end

if any(isnan(ficsMat(:)))
    error('ficsMat should not have NaNs at this stage');
end

zMin  = min(ficsMat(:, 5)) + 1; % +1 accounts for FSL's zero-based numbering
zSize = max(ficsMat(:, 6));

swk = zMin:zMin+(zSize-1);

end
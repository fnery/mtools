function out = niimaskrep(from, into, mask, out)
% niimaskrep.m: replace nii voxels with those from other nii in mask ROIs
%
% Syntax:
%    1) out = niimaskrep(from, into, mask, out)
%
% Description:
%    1) out = niimaskrep(from, into, mask, out) replaces voxel intensities
%       in the nii file given by 'into' with the intensities at the voxels
%       at the same coordinates in the nii file given by 'from'. The
%       coordinates where this replacement is to occur are given by the
%       mask(s) in out.
%
% Inputs:
%    1) from: string, path to source nii file                 (2-4D)
%    2) into: string, path to target nii file                 (2-4D)
%    3) mask: cell of string(s), path(s) to mask nii file(s)  (2-3D)
%    4) out: path or name of nii file to be created
%
% Outputs:
%    1) out: full path of created nii file
%
% Notes/Assumptions:
%    1) This was created to replace the results of masked motion correction
%       into the original (full FOV) images. For example:
%       1) Take volume A
%       2) Motion correct left kidney --> Volume B
%       3) Motion correct left kidney --> Volume C
%       4) Replace A from contents of B and C in the respective masks where
%          motion correction was done
%       This way we don't need to worry about left and right "volumes"
%    2) This was tested for all combinations of 2D, 3D and 4D target and
%       source that seem to make sense, and 2D and 3D masks. Therefore, the
%       allowed combinations of file dimensions are
%       --------------------
%       from    into    mask
%        2       2       2   : all 2D
%        2       4       2   : 2D images but 'into' has multiple measurements, say 100 (e.g. 64x64x1x100)
%        4       4       2   : 2D images but both 'from' and 'into' have multiple measurements (e.g. 64x64x1x100)
%        3       3       3   : all 3D volumes (say with 12 slices)
%        3       4       3   : all 3D volumes but 'into' has multiple measurements, say 100 (e.g. 64x64x12x100)
%        4       4       3   : all 3D volumes but both 'from' 'into' has multiple measurements (e.g. 64x64x12x100)
%       --------------------
%    3) Debug example nifti files and scripts available in my local
%       '...\matlab\wip\20180530_niimaskrep' directory
%
% References:
%    [1] https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%
% Required functions:
%    1) load_untouch_nii.m [1]
%    2) matrix2string.m
%    3) fileparts2.m
%    4) save_untouch_nii.m [1]
%
% Required files:
%    1) none other than the ones specified in the input arguments
%
% Examples:
%    These examples below only show emphasize again the possible
%    combinations of dimensions of the input files:     % | from    into    mask |
%    >> niimaskrep(from_1s_1v, into_1s_1v, mask_2D, ... % |  2       2       2   |
%    >> niimaskrep(from_1s_1v, into_1s_Nv, mask_2D, ... % |  2       4       2   |
%    >> niimaskrep(from_1s_Nv, into_1s_Nv, mask_2D, ... % |  4       4       2   |
%    >> niimaskrep(from_Ns_1v, into_Ns_1v, mask_3D, ... % |  3       3       3   |
%    >> niimaskrep(from_Ns_1v, into_Ns_Nv, mask_3D, ... % |  3       4       3   |
%    >> niimaskrep(from_Ns_Nv, into_Ns_Nv, mask_3D, ... % |  4       4       3   |
%       where 1s/1v = one slice/volume, Ns/Nv = multiple slices/volumes
%
% fnery, 20180531: original version
% fnery, 20180726: indexation bugfix

%                                      f i m
EXPECTED_NII_DIM_COMBINATIONS(1, :) = [2 2 2];
EXPECTED_NII_DIM_COMBINATIONS(2, :) = [2 4 2];
EXPECTED_NII_DIM_COMBINATIONS(3, :) = [4 4 2];
EXPECTED_NII_DIM_COMBINATIONS(4, :) = [3 3 3];
EXPECTED_NII_DIM_COMBINATIONS(5, :) = [3 4 3];
EXPECTED_NII_DIM_COMBINATIONS(6, :) = [4 4 3];

if nargin ~= 4
    error('Error: this function needs 4 input arguments');
end

if ~ischar(from)
    error('Error: ''from'' must be a string (path to file)');
end

if ~ischar(into)
    error('Error: ''into'' must be a string (path to file)');
end

if ischar(mask) && size(mask, 1) == 1
    mask = {mask};
    nMasks = 1;
elseif iscell(mask)
    nMasks = length(mask);
else
    error('Error: ''mask'' must be a string or cell of strings');
end

from = load_untouch_nii(from);
into = load_untouch_nii(into);

baseNii = into; % save 'into' as a base to later save the new nii

from = from.img;
into = into.img;

[fromR, fromC, fromS, ~] = size(from);
[intoR, intoC, intoS, intoT] = size(into);

% =======================================================
% ===== Load and check all masks have the same size ===== -----------------
% =======================================================

% Pre-allocate
masks = cell(1, nMasks);
maskSzs = cell(1, nMasks);

% Load and save sizes
for iMask = 1:nMasks

    cMask = mask{iMask};
    cMask = load_untouch_nii(cMask);
    cMask = cMask.img;
    masks{iMask} = cMask;
    [cC, cR, cS] = size(cMask);
    maskSzs{iMask} = [cC cR cS];

end

% Same size check (true if all rows in maskSzs are equal)
maskSzs = vertcat(maskSzs{:});
allMasksSameSize = size(unique(maskSzs, 'rows'), 1) == 1;

if ~allMasksSameSize
    error('Error: all masks must have the same dimensions');
else
    maskSz = maskSzs(1,:);
end

% =========================================================================
% === Check from, into and all masks have the same first 3D dimensions ====
% =========================================================================

from3Dsz = [fromR fromC fromS];
into3Dsz = [intoR intoC intoS];

if ~isequal(from3Dsz, into3Dsz, maskSz)
    error(['Error: ''from'' and/or ''into'' and/or ''mask'' have inconsistent slice/volume dimensions' ...
        '\n>> size(from) = %s\n>> size(into) = %s\n>> size(mask) = %s'], ...
        matrix2string(from3Dsz, 3, '%d'), matrix2string(into3Dsz, 3, '%d'), matrix2string(maskSz, 3, '%d'));
else
    nSlices = from3Dsz(3);
end

% ==============================================================
% ===== Ensure valid combination of the inputs' dimensions ===== ----------
% ==============================================================

fromDims = ndims(from);
intoDims = ndims(into);
maskDims = ndims(maskSz);

dimCombination = [fromDims, intoDims, maskDims];

validDimCombination = all(ismember(dimCombination, EXPECTED_NII_DIM_COMBINATIONS));

if ~validDimCombination
    error(['Error: [''from'' ''into'' ''mask''] dimensions are imcompatible with this function' ...
        '\n[''from'' ''into'' ''mask''] input combination:', ...
        '\n%s\n[''from'' ''into'' ''mask''] allowed combinations:', ...
        '\n%s\n'], matrix2string(dimCombination, 6, '%d'), matrix2string(EXPECTED_NII_DIM_COMBINATIONS, 6, '%d'))
end

% ========================
% ===== Manage 'out' ===== ------------------------------------------------
% ========================

[d, n, e] = fileparts2(out);

if isempty(d)
    d = pwd;
end
if isempty(n)
    error('Error: need to specify the name of ''out''');
end
if isempty(e)
    error('Error: need to specify the extension of ''out''');
end
out = fullfile(d, [n e]);

% =================================
% ===== Replacement algorithm ===== ---------------------------------------
% =================================

if fromDims < intoDims
    % Replicate from accross 4th dimension to enable substitution in the
    % for loop below in the case that dimCombination is 2,4,2 or 3,4,3
    nMeasurements = intoT; % init for readibility
    fromAux = repmat(from, [1 1 1 nMeasurements]);
else
    % No replication needed as the number of measurements in into and from
    % is the same
    fromAux = from;
end

% % % % DEBUG {
% % % allInts = [from(:); into(:)];
% % % cAx = [min(allInts) max(allInts)].*0.5;
% % %
% % % DEBUG_MEASUREMENT_INDEX_FROM = 5;
% % % DEBUG_MEASUREMENT_INDEX_INTO = 5;
% % % figure, imx('im', squeeze(from(:,:,:,DEBUG_MEASUREMENT_INDEX_FROM)), 'int', cAx); colorbar; fs;
% % % figure, imx('im', squeeze(into(:,:,:,DEBUG_MEASUREMENT_INDEX_INTO)), 'int', cAx); colorbar; fs;
% % % % DEBUG }

% Main loop
for iMask = 1:nMasks

    cMask = masks{iMask};

    % % % % DEBUG {
    % % % figure, imx('im', squeeze(cMask), 'int', [0 1]); colorbar; fs;
    % % % % DEBUG }

    for iSlice = 1:nSlices

        % Get coordinates of mask pixels
        cMaskSlice = cMask(:,:,iSlice);
        cCC = bwconncomp(cMaskSlice, 4);
        cPixelList = vertcat(cCC.PixelIdxList{:})';
        [cR, cC] = ind2sub(size(cMaskSlice), cPixelList);

        % Replace
        nPixels = length(cPixelList);
        
        % Slow loop, may be possible to vectorise if bottleneck
        for iPixel = 1:nPixels
            ccR = cR(iPixel);
            ccC = cC(iPixel);
            into(ccR, ccC, iSlice, :) = fromAux(ccR, ccC, iSlice, :);
        end

    end

    % % % % DEBUG {
    % % % figure, imx('im', squeeze(into(:,:,:,DEBUG_MEASUREMENT_INDEX_INTO)), 'int', cAx); colorbar; fs;
    % % % % DEBUG }

end

% Save new image into base nii
baseNii.img = into;

% Save new nii file
save_untouch_nii(baseNii, out)

end
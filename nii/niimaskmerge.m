function out = niimaskmerge(in, out)
% niimaskmerge.m: merge non-overlapping 3D masks into a single 3D mask file
%
% Syntax:
%    1) out = niimaskmerge(in, out)
%
% Description:
%    1) out = niimaskmerge(in, out) merges non-overlapping 3D masks (each 
%       in its own 3D NIfTI file and each may have multiple connected 
%       components) into a single 3D mask NIfTI file
%
% Inputs:
%    1) in: cell of string(s), path(s) to source 3D NIfTI mask files
%    2) out: path or name of NIfTI file to be created
%
% Outputs:
%    1) out: full path of created nii file
%
% Notes/Assumptions: 
%    1) If any voxel is 1-valued in the same coordinates of more than one 
%       mask file this function will throw an error.
%    2) Created this to merge left box with right box into a single file
%
% References:
%    [1] https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%
% Required functions:
%    1) load_untouch_nii.m (from [1])
%    2) ensurecolumnvector.m
%    3) outinit.m
%    4) fileparts2.m
%    5) niimaskrepn.m
%
% Required files:
%    1) None in addition to the files specified by the input arguments
%
% Examples:
%    % Assuming box_01.nii.gz and box_02.nii.gz exist in current directory:
%    in = fullfile(pwd, {'box_01.nii.gz', 'box_02.nii.gz'})'
%    out = niimaskmerge(in, 'boxes')
%
% fnery, 20180726: original version

NII_GZ_EXT = '.nii.gz';

if ~iscell(in)
    error('Error: ''in'' must be a cell with strings to NIfTI binary files');
end

nMasks = length(in);

if nMasks < 2 
    error('Error: ''in'' must contain paths to at least 2 NIfTI mask files');
end

for iMask = 1:nMasks 
    cMask = load_untouch_nii(in{iMask});
    cMask = cMask.img;

    % Check masks are binary files and that they are not empty (i.e. mask
    % without ROIs i.e. all zeros)
    cUniqueInts = sort(unique(cMask(:)));
    if ~isequal(ensurecolumnvector(cUniqueInts), [0 1]')
        error('Error: all inputs must be non-empty binary files');
    end
    
    % Check masks are 3D
    if ndims(cMask) ~= 3
        error('Error: all masks provided must be 3D');
    end
    
    masks(:,:,:,iMask) = cMask; %#ok<AGROW>
end

% Ensure masks do not overlap at any voxel, that is, any 1-valued voxel at
% any coordinates (x,y,z) only exists at one of the provided masks, that is
% the sum of all 3D masks will never yield a voxel with intensity > 1
masks = sum(masks, 4);

maxMasks = max(masks(:));

if maxMasks > 1
    error('Error: provided masks overlap at some point(s)(not allowed by this function)');
end

out = outinit(out);

[d, n, e] = fileparts2(out);

if isempty(e)
    out = fullfile(d, [n NII_GZ_EXT]);
elseif ~isempty(e) && ~strcmp(e, NII_GZ_EXT)
    error('Error: if providing ''out''s extension (optional) it has to be ''%s''', NII_GZ_EXT);
else
    % do nothing
end

% Merge masks
% This is actually a task that can be accomplished with niimaskrepn.m,
% which is a much more general function so there will be some extra
% overhead but I am fine with it as keeps code more modular and saves me
% time in coding a specific solution for this function
out = niimaskrepn(in(2:end)', in{1}, in(2:end)', out);

end
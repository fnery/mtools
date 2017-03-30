function [out] = vol2mont(in3d, shape, b)
% vol2mont.m: converts a 3D volume into a 2D montage
%   
% Syntax:
%    1) [out] = vol2mont(in3d, shape)
%    2) [out] = vol2mont(in3d, shape, b)
%
% Description:
%    1) [out] = vol2mont(in3d, shape) converts a 3D volume into a 2D montage
%    2) [out] = vol2mont(in3d, shape, b) does the same as 1) but also adds a
%       border of thickness 'b' pixels in all slices of the montage
%
% Inputs:
%    1) in3d: 3D volume
%    2) shape: shape of the montage [rows, cols]
%    2) b (opt): thickness of border in pixels
%
% Outputs:
%    1) out: 2D montage image
%
% Notes/Assumptions: 
%    1) Inspired by Michael Lustig's imshow3.m
%       Can't quite remember where I got this from but a version of this 
%       function can be found here:
%       <github.com/mikgroup/espirit-matlab-examples/blob/master/imshow3.m>
%    2) This function is useful when we want, for example, to overlay ROIs
%       in all slices of a volume. In this case MATLAB's montage function isn't
%       useful and we need to actually create a 2D montage from the 3D volume
%    3) The 'b' option is somewhat obsolete as now this function is most
%       likely called by imx.m which offers a better method for creating
%       borders for the individual slices of volumes.
%
% Required functions:
%    1) mgridshape.m
%    1) is1d.m
%
% Required files:
%    []
% 
% Examples:
%    >> BORDER_SZ = 5;
%    >> N_IMS = 5;
%    >> IM = repmat(phantom(128), [1 1 N_IMS]);
%    >> mGrid = mgridshape('nIms', N_IMS); % default mgridshape
%    >> out = vol2mont(IM, mGrid, BORDER_SZ);
%    >> figure, imshow(out, []);
%    >> mGrid = mgridshape('nIms', N_IMS, 'nRows', 5); % forcing nRows
%    >> out = vol2mont(IM, mGrid, BORDER_SZ);
%    >> figure, imshow(out, []);
%    >> mGrid = mgridshape('nIms', N_IMS, 'nCols', 5);  % forcing nCows 
%    >> out = vol2mont(IM, mGrid, BORDER_SZ);
%    >> figure, imshow(out, []);
%    >> mGrid = mgridshape('nIms', N_IMS, 'nRows', 3, 'nCols', 2);  % forcing both
%    >> out = vol2mont(IM, mGrid, BORDER_SZ);
%    >> figure, imshow(out, []);
%       (creates 4 figures)
%
% fnery, 20150827: original version
% fnery, 20160321: added support for borders (b input argument)
% fnery, 20160421: now roi produce borders of intensity 0: useful when
%                  using vol2mont'd rois in showoverlaymap.m
% fnery, 20170330: updated doc

out = in3d;

% At the moment this works for 3D matrices only
if ndims(out) ~= 3
    error('Error: Input must be a 3D matrix')
end

% Manage nargins and third input argument
if nargin == 1
    shape = mgridshape('nIms', size(in3d, 3));
    useBorder = 0;
elseif nargin == 2
    useBorder = 0;
elseif nargin == 3
    if b > 0
        useBorder = 1;
    elseif b == 0
        useBorder = 0;
    else
        error('Error: The 3rd input argument (''b'') must be >= 0');
    end
end

% Shape must be a 1D vector with 2 elements
if ~is1d(shape) || length(shape) ~= 2
    error('Error: ''shape'' must be a 1D vector with 2 elements')
end
              
% Dimensions of the input volume
[nRows, nCols, nSlices] = size(out);

if useBorder
    if ~islogical(out)
        borderVal = max(out(:));
    elseif islogical(out) 
        borderVal = 0; % in roi vols, we don't want a high intensity border
    end
    out(:,nCols+1:nCols+b,:) = borderVal;
    out(nRows+1:nRows+b,:,:) = borderVal;
    % Update dimensions of the input volume after adding borders
    [nRows, nCols, ~] = size(out);
end

% Deal with shape
lShape = prod(shape);
if lShape > nSlices
    tmp = zeros(nRows, nCols, lShape);
    tmp(:,:,1:nSlices) = out;
    out = tmp;
    nSlices = lShape;
end

% Reshape volume into a 2D montage, with dimensions given by shape
out = reshape(out, nRows, nCols*nSlices);
out = permute(out, [2 3 1]);
out = reshape(out, nCols*shape(2), shape(1),nRows);
out = permute(out, [3 2 1]);
out = reshape(out, nRows*shape(1), nCols*shape(2));

if useBorder
    % Update dimensions of the input volume after converting to mont
    [nRows, nCols, ~] = size(out);
    out(nRows-b+1:nRows, :) = [];
    out(:, nCols-b+1:nCols) = [];
end

end
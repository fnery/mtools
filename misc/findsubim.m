function [mask, subIm] = findsubim(im, shape, opt)   
% findsubim.m: find region (sub-image) of image with max/min mean intensity
%   
% Syntax:
%    1) [mask, subIm] = findsubim(im, shape, opt)
%
% Description:
%    1) [mask, subIm] = findsubim(im, shape, opt) takes an image with an
%       arbitrary number of dimensions 'im' and finds its "rectangular" 
%       sub-region of dimensions given by 'shape' with the highest or lowest
%       mean intensity, according to 'opt'
%
% Inputs:
%    1) im   : n-D image (number of dimensions = nDims)
%    2) shape: vector with nDims elements specifying the dimensions of the 
%              "rectangular" block (sub-image) to be found 
%    3) opt  : can be
%              - 'min': to look for region with minimum mean intensity
%              - 'max': to look for region with maximum mean intensity
% 
% Outputs:
%    1) mask : matrix with same dimensions as 'im' with 1-valued elements
%              corresponding to the desired region
%    2) subIm: extracted region, dimensions given by 'shape' with
%              intensities from 'im'
%
% Notes/Assumptions: 
%    1) This was created to automatically look for background regions in MR
%       data
%    2) Used eval for quickly coding this in a way that works with
%       n-Dimensional datasets
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
%    % This example shows how this may be useful to extract parts of the
%    foreground and background in image data
%    % Create test dataset, options for findsubim.m and run the function
%    im = imtest(6);
%    shape1 = [50,70,3];
%    shape2 = [10,10,3];
%    opt1 = 'max';
%    opt2 = 'min';
%    [mask1, subIm1] = findsubim(im, shape1, opt1);
%    [mask2, subIm2] = findsubim(im, shape2, opt2);
%    
%    % Prepare outputs for displaying as figures
%    im    = vol2mont(im   , [2 3]);
%    mask1 = vol2mont(mask1, [2 3]);
%    mask2 = vol2mont(mask2, [2 3]);
%    out1 = imfusion('im1', im, 'im2', mask1, 'w1', 0.5);
%    out2 = imfusion('im1', im, 'im2', mask2, 'w1', 0.5);
%       
%    % Show figures
%    figure, imshow(out1); 
%    title('highlight of region of dimensions given by ''shape1'' with max mean intensity');
%    figure, imshow(out2);
%    title('highlight of region of dimensions given by ''shape2'' with min mean intensity');
%    figure, imx('im', subIm1, 'rint', [0 1], 'mgrid', [1 3], 'divw', 2, 'divc', [0 0 1]);
%    title('extracted region of dimensions given by ''shape1'' with max mean intensity');
%
% fnery, 20170518: original version

% Switch off warnings due to use of eval
%#ok<*STOUT>
%#ok<*NASGU>

if nargin ~= 3
    error('Error: this function needs 3 input arguments');
end

nDims = ndims(im);

if ~isequal(nDims, numel(shape));
    error('Error: no. of elements in ''shape'' must equal no. of dimensions in ''im''');
end

if any(shape > size(im))
    error('Error: Elements of ''shape'' can''t be larger than size of ''im''');
end

xMean = convn(im, ones(shape), 'valid');

idxs = cell(1, nDims);

if strcmp(opt, 'min');
    [idxs{:}] = ind2sub(size(xMean), find(xMean==min(xMean(:)), 1)); 
elseif strcmp(opt, 'max');
    [idxs{:}] = ind2sub(size(xMean), find(xMean==max(xMean(:)), 1));
else
    error('Error: ''opt'' must be either ''min'' or ''max''');
end

mask = zeros(size(im));

% Here comes ugly - works, but improve in the future
cmd = [];
for iDim = 1:nDims
    cmd = sprintf('%sidxs{%d}+(0:shape(%d)-1),', cmd, iDim, iDim);
end
cmd(end) = [];

cmd1 = sprintf('mask(%s) = 1;', cmd);
cmd2 = sprintf('subIm = im(%s);', cmd);

eval(cmd1);
eval(cmd2);

end
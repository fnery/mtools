function [im, d] = imtest(n, aR)
% imtest.m: loads 2D or 3D test image from MATLAB's MRI dataset
%   
% Syntax:
%    1) [im, d] = imtest(n)
%    2) [im, d] = imtest(n, aR)
%
% Description:
%    1) [im, d] = imtest(n) loads a 2D or 3D test image from MATLAB's MRI
%       dataset, where 'n' is the number of slices desired (0<n<28)
%    2) [im, d] = imtest(n, aR) does the same as 1) but allows to specify
%       the in-plane aspect ratio ('aR') of the image
%
% Inputs:
%    1) n (int): number of slices (0<n<28) 
%           --> can be empty (if so, it is assumed to be 1)
%    2) aR ([1x2] numeric): in-plane aspect ratio
% 
% Outputs:
%    1) im: output image
%    2) d: size(im)
%
% Notes/Assumptions: 
%    1) Assumes the first two dimensions have the same length, which is
%       true for the MRI data set that comes with MATLAB
%
% References:
%    [1] mathworks.com/help/images/examples/exploring-slices-from-a-3-dimensional-mri-data-set.html
%
% Required functions:
%    []
%
% Required files:
%    1) MATLAB's MRI dataset [1]
% 
% Examples:
%    >> % 1)
%    >> im1 = imtest;
%           imtest.m created image of dims [128, 128]
%    >> % 2)
%    >> aR  = [16 9];
%    >> im2 = imtest([], aR);
%           imtest.m created image of dims [128, 72]
%    >> % 3)
%    >> n   = 5;
%    >> aR  = [16 9];
%    >> im3 = imtest(n, aR);
%           imtest.m created image of dims [128, 72, 5]
%
% fnery, 20170401: original version

DEFAULT_N_SLICES_TO_SHOW = 1;

if nargin == 0 || isempty(n)
   n = DEFAULT_N_SLICES_TO_SHOW;
end

load('mri');
tmp = squeeze(D);

nS = size(tmp, 3);

if n > nS
    error('Error: ''n'' can''t be larger than %d', nS);
end

s = round(linspace(1, nS, n));

tmp = double(tmp(:,:,s));

if nargin == 2
    d = [size(tmp, 1), size(tmp, 2)];
    x = (d.*aR)./(max(aR));
    im = NaN(x(1), x(2), n);
    for iS = 1:n
        im(:,:,iS) = imresize(tmp(:,:,iS), [x(1) x(2)], 'nearest'); 
    end
else
    im = tmp;
end

if any(isnan(im(:)))
    error('Error: problem in aspect ratio transformation');
end

d = size(im);

fprintf('imtest.m created image of dims %s\n', vec2str(d, '%d'));

end
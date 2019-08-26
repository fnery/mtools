function out = niiloadimn(niiPaths, oriS, oriF)
% niiloadimn.m: load multiple 2D or 3D NIfTI images into a single 4D matrix
%
% Syntax:
%    1) out = niiloadimn(niiPaths, oriS, oriF)
%    2) out = niiloadimn(niiPaths)
%
% Description:
%    1) out = niiloadimn(niiPaths, oriS, oriF) loads the input NIfTI images
%       using niiloadim.m and concatenates them in the 4th dimension
%    2) out = niiloadimn(niiPaths) does the same as 1), but for simplicity
%       assumes previously hard-coded defaults for 'oriS' and 'oriF' (use of
%       these defaults is discouraged as 'oriS' and 'oriF' are highly
%       application-dependent).
%
% Inputs:
%    1) niiPaths: cell of paths to NIfTI files
%    2) oriS: start orientation descriptor (cell of strings) - see imori.m
%    3) oriF: final orientation descriptor (cell of strings) - see imori.m
%
% Outputs:
%    1) out: 4D image matrix
%
% Notes/Assumptions:
%    1) Same as niiloadim.m
%    2) Output matrix is always x,y,z,t. Z may be of size 1 if single-slice
%
% References:
%    []
%
% Required functions:
%    1) niiloadim.m
%    2) isallequal.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20190826: original version

DEFAULT_ORI_S = {'+L', '-I', '+P'};
DEFAULT_ORI_F = {'+I', '+L', '+P'};

if nargin == 1
    oriS = DEFAULT_ORI_S;
    oriF = DEFAULT_ORI_F;
end

nIms = length(niiPaths);

cIms = cell(1, nIms);
cImSizes = cell(1, nIms);

for iIm = 1:nIms

    % Load current im and save its size
    cIm = niiPaths{iIm};
    cIm = niiloadim(cIm, oriS, oriF);
    cIms{iIm} = cIm;
    cImSizes{iIm} = size(cIm);

end

% Check all images have the same size
if isallequal(cImSizes)
    imSize = cImSizes{1};
else
    error('Error: all images in ''niiPaths'' must have the same size');
end

nDims = numel(imSize);


if nDims == 2

    % Concatenate 2D images in the 4th dimension (Assumption 1)
    out = NaN(imSize(1), imSize(2), 1, nIms);
    for iIm = 1:nIms
        out(:,:,1,iIm) = cIms{iIm};
    end
    if any(isnan(out(:)))
        error('Error: error creating output variable');
    end

elseif nDims == 3

    % Concatenate 3D images in the 4th dimension (Assumption 1)
    out = NaN(imSize(1), imSize(2), imSize(3), nIms);
    for iIm = 1:nIms
        out(:,:,:,iIm) = cIms{iIm};
    end
    if any(isnan(out(:)))
        error('Error: error creating output variable');
    end

else
    error('Error: all images in ''niiPaths'' must be 2D or 3D');
end

end
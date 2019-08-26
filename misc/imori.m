function out = imori(in, oriS, oriF)
% imori.m: change image orientation
%
% Syntax:
%    1) out = imori(in, oriS, oriF)
%
% Description:
%    1) out = imori(in, oriS, oriF) takes the image 'in', with orientation
%       given by 'oriS', applies transformations to make its orientation match
%      'oriF' and outputs the result as 'out'
%
% Inputs:
%    1) in: [2-4]-dimensional image matrix
%    2) oriS: orientation cell of strings
%    3) oriF: orientation cell of strings
%
% Outputs:
%    1) out: [2-4]-dimensional image matrix
%
% Notes/Assumptions:
%    1) An example of an orientation cell of strings (in the same format as
%       expected by 'oriS' and 'oriF') is:
%           - {'+I', '+L', '+P'}.
%       This corresponds to the desired orientation (radiological) when
%       displaying coronal (kidney) volumes using MATLAB, which is:
%           - Increasing row    (i.e. y axis): superior --> inferior  (+I)
%           - Increasing column (i.e. x axis): right    --> left      (+L)
%           - Increasing slices (i.e. z axis): anterior --> posterior (+P)
%    2) Currently, only the following orientation descriptions are
%       supported:
%           - {'+I', '+L', '+P'}
%           - {'+L', '-I', '+P'}
%    3) Assumption 1: no transformations needed on the 4th dimension
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
% fnery, 20180301: original version
% fnery, 20190816: now works in 2,3 and 4 dimensions (previous volori.m)

% Supported orientations
pLmIpP = {'+L', '-I', '+P'};
pIpLpP = {'+I', '+L', '+P'};

nDims = ndims(in);

if nDims < 2 || nDims > 4
    error('Error: ''in''  in must have 2, 3 or 4 dimensions');
end

if nDims > 2

    [~, ~, ~, nVols] = size(in);

    % Assumption 1: no transformations will be necessary on the 4th dimension
    for iVol = 1:nVols
        cVol = in(:,:,:,iVol);

        if isequal(oriS, pLmIpP) && isequal(oriF, pIpLpP)

            cVol = permute(cVol, [2 1 3]);
            cVol = cVol(end:-1:1, :, :);

        elseif isequal(oriS, pIpLpP) && isequal(oriF, pLmIpP)

            cVol = cVol(end:-1:1, :, :);
            cVol = permute(cVol, [2 1 3]);

        else
            error('Error: invalid orientation definition (See note 2)');
        end

        out(:,:,:,iVol) = cVol; %#ok<AGROW> % optimise later
    end

elseif nDims == 2

    if isequal(oriS, pLmIpP) && isequal(oriF, pIpLpP)

        in = permute(in, [2 1]);
        in = in(end:-1:1, :);

    elseif isequal(oriS, pIpLpP) && isequal(oriF, pLmIpP)

        in = in(end:-1:1, :);
        in = permute(in, [2 1]);

    else
        error('Error: invalid orientation definition provided (See note 2)');
    end

    out = in;

else
    error('nDims == 3 currently not implemented')
end

end
function [res] = sumn(in, dims)
% sumn.m: sum of array elements along multiple dimensions (sum in a loop)
%   
% Syntax:
%    1) [res] = sumn(in, dims)
%
% Description:
%    1) [res] = sumn(in, dims) returns the sum of array elements along 
%        dimensions 'dims'
%
% Inputs:
%    1) in: n-d matrix
%    2) dims: 1d vector with dimension indexes along which to sum
%
% Outputs:
%    1) res: result of the sum
%
% Notes/Assumptions: 
%    1) This is simply the application of MATLAB's 'sum' function in a loop, 
%       not efficient
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    1) in = round(100.*rand(2,3,4,5,6,7));
%       dims = [1 6];
%       res1 = squeeze(sum(sum(in, 1), 6));
%       res2 = sumn(in, dims);
%       isequal(res1, res2)
%    >> ans = 1
%    2) in = round(100.*rand(2,3,4,5,6,7));
%       dims = [1 3 5 6];
%       res1 = squeeze(sum(sum(sum(sum(in, 1), 3), 5), 6));
%       [res2] = sumn(in, dims);
%       isequal(res1, res2)
%    >> ans = 1
%
% fnery, 20150826: original version

% Sum along higher dims first to avoid issues with singleton dims
dims = sort(dims, 'descend');

% Sum along each dimension
res = in;
nDims = length(dims);
for iDim = 1:nDims
    cDim = dims(iDim);
    res = sum(res, cDim);  
end

res = squeeze(res);

end
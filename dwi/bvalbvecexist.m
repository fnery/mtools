function tf = bvalbvecexist(in, throwError)
% bvalbvecexist.m: check if bval and bvec files exist
%
% Syntax:
%    1) tf = bvalbvecexist(in)
%    2) tf = bvalbvecexist(in, throwError)
%
% Description:
%    1) tf = bvalbvecexist(in) checks if bval and bvec files exist for the
%       file provided in 'in';
%    2) tf = bvalbvecexist(in, throwError) does the same as 1) but if
%       'throwError' is true, an error is thrown if any of the bval or bvec
%       files doesn't exist.
%
% Inputs:
%    1) in: path to NIfTI DWI file
%    2) throwError: logical scalar (optional - default: false)
%
% Outputs:
%    1) tf: logical scalar
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) exist2.m
%    2) bvalbvecpath.m
%
% Required files:
%    1) 'in' NIfTI file for testing existence of corresponding bval/bvec 
%
% Examples:
%    []
%
% fnery, 20180602: original version

if nargin ~= 1 && nargin ~= 2
    error('Error: ''bvalbvecexist.m'' requires 1 or 2 input arguments');
end

if nargin == 1
    throwError = false;
end

% Check if 'in' exists
exist2(in, 'file', true);

% Generate paths to bval / bvec files
[bVal, bVec] = bvalbvecpath(in);

% Check if they exist
tf1 = exist2(bVal, 'file', throwError);
tf2 = exist2(bVec, 'file', throwError);

if ~all([tf1 tf2])
    tf = false;
else
    tf = true;
end

end
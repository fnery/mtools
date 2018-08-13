function [bval, bvec] = bvalbvecload(bval, bvec, doChecks)
% bvalbvecload.m: load one pair of bval and bvec files
%
% Syntax:
%    1) [bval, bvec] = bvalbvecload(bval, bvec)
%    2) [bval, bvec] = bvalbvecload(bval, bvec, doChecks)
%
% Description:
%    1) [bval, bvec] = bvalbvecload(bval, bvec) loads one pair of bval and
%        bvec files
%    2) [bval, bvec] = bvalbvecload(bval, bvec, doChecks) does the same as
%       1) but also performs a series of validity checks as implemented on
%       bvalbveccheck.m
%
% Inputs:
%    1) bval: string full path to .bval file
%    2) bvec: string full path to .bvec file
%
% Outputs:
%    1) bval: vector of b-values
%    2) bvec: matrix of b-vectors
%
% Notes/Assumptions:
%    []
%
% References:
%    []
%
% Required functions:
%    1) bvalbveccheck.m
%
% Required files:
%    1) bval file from any given scan
%    2) bvec file from the corresponding scan of 1)
%
% Examples:
%    []
%
% fnery, 20180126: original version
% fnery, 20180730: no longer assumes .bval/.bvec files have same file name
%                  (rotated bvec files may have different file names than
%                  their corresponding .bval files)
% fnery, 20180813: error checks now performed in a dedicated function

if ~(nargin == 2 || nargin == 3)
    error('This function needs 2 or 3 input arguments');
elseif nargin == 2
    doChecks = true;
end

bval = load(bval);
bvec = load(bvec);

if doChecks
    bvalbveccheck(bval, bvec);
end

end
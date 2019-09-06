function out = dwimean(im4d, bval, bvec, powder)
% dwimean.m: average repeated measurements or directions of 4D DWI volume
%
% Syntax:
%    1) out = dwimean(im4d, bval, bvec)
%    2) out = dwimean(im4d, bval, bvec, powder)
%
% Description:
%    1) out = dwimean(im4d, bval, bvec) takes a 4D volume of DWI data (where 3D
%       corresponding to different bvalues, bvecs and averages are concatenated)
%       and calculates the mean of repeated measurements (averages)
%    2) out = dwimean(im4d, bval, bvec, powder) does the same as 1) but the
%       'powder' bool scalar controls whether the mean of the different
%       directions (powder average) is also calculated
%
% Inputs:
%    1) im4d: 4D volume of DWI data with format [row, col, slice, volume#]
%    2) bval: string full path to .bval file
%    3) bvec: string full path to .bvec file
%    4) powder (optional): boolean scalar
%
% Outputs:
%    1) out: averaged DWI data (in a 4D or 5D matrix depending on 'powder')
%
% Notes/Assumptions:
%    1) See dwi6d.m
%
% References:
%    []
%
% Required functions:
%    1) dwi6d.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20190906: original version

DEFAULT_POWDER = false;

if nargin == 3
    powder = DEFAULT_POWDER;
end

% Organise 4D volume into 6D [row, col, slice, bvals, dirs, averages]
Im6D = dwi6d(im4d, bval, bvec);
im6d = Im6D.data;

% Calculate mean of repeated measurements (averages), if they exist
out = nanmean(im6d, 6);

% Calculate mean of different directions (powder average)
if powder
    out = nanmean(out, 5);
end

end
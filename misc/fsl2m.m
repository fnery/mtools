function [r, c, s] = fsl2m(x, y, z, nY)
% fsl2m.m: converts 3D coordinates from FSL to MATLAB formats
%
% Syntax:
%    1) [r, c, s] = fsl2m(x, y, z, nY)
%
% Description:
%    1) [r, c, s] = fsl2m(x, y, z, nY) converts 3D coordinates from FSL
%       to as displayed in MATLAB to take into account the different 
%       coordinate systems of matlab and FSL(view):
%                 MATLAB                   FSL
%           +x (i.e. +column)           ----------
%           ----->                      |  |  |  |
%           |   ----------              ----------
%           v   |  |  |  |              |  |  |  |
%          +y   ----------              ----------
%       (+row)  |  |  |  |              |  |  |  |
%               ----------        +y ^  ----------
%               |  |  |  |           |   +x
%               ----------           ---->
%       As well as the fact that FSL uses zero-based numbering [2], unlike
%       MATLAB
%
% Inputs:
%    1) x : x coordinate(s) in FSL
%    2) y : y coordinate(s) in FSL
%    3) z : z coordinate(s) in FSL 
%    4) nY: number of voxels in the y dimension
%
% Outputs:
%    1) r : row    index(es) in MATLAB (1st dim)
%    2) c : column index(es) in MATLAB (2nd dim)
%    3) s : slice  index(es) in MATLAB (3rd dim)
%
% Notes/Assumptions: 
%    []
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslView
%    [2] https://en.wikipedia.org/wiki/Zero-based_numbering
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
% fnery, 20180302: original version

r = nY - y;
c = x  + 1;
s = z  + 1;

end
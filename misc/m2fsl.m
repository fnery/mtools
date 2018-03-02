function [x, y, z] = m2fsl(r, c, s, nR)
% m2fsl.m: converts 3D coordinates from MATLAB to FSL formats
%
% Syntax:
%    1) [x, y, z] = m2fsl(r, c, s, nR)
%
% Description:
%    1) [x, y, z] = m2fsl(r, c, s, nR) converts 3D coordinates from MATLAB
%       to as displayed in FSL to take into account the different 
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
%    1) r : row    index(es) in MATLAB (1st dim)
%    2) c : column index(es) in MATLAB (2nd dim)
%    3) s : slice  index(es) in MATLAB (3rd dim)
%    4) nR: number of rows
%
% Outputs:
%    1) x : x coordinate(s) in FSL
%    2) y : y coordinate(s) in FSL
%    3) z : z coordinate(s) in FSL 
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

x = c  - 1;
y = nR - r;
z = s  - 1;

end
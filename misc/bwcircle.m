function out = bwcircle(imSz, circleParams)
% bwcircle.m: Creates binary (logical) image with a 1-valued circle
%   
% Syntax:
%    1) out = bwcircle(imSz, circleParams)
%    
% Description:
%    1) out = bwcircle(imSz, circleParams) creates a binary (logical) image 
%       of size 'imSz' with a 1-valued circle  with the parameters 
%       'circleParams' on a 0-valued background.
%
% Inputs:
%    1) imSz (int): 2-element vector specifying the image size, where
%           - imSz(1): number of rows    (y)
%           - imSz(2): number of columns (x)
%    2) circleParams: 3-element vector specifying circle parameters
%           - circleParams(1): circle centre coordinate (rows    ; y) 
%           - circleParams(2): circle centre coordinate (columns ; x)
%           - circleParams(3): circle radius (in pixels)
% 
% Outputs:
%    1) out: binary (logical) image
%
% Notes/Assumptions: 
%    []
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
%    mask = bwcircle([200 200], [125 75 50]);
%    figure, imshow(mask, [0 1])
%
% fnery, 20130319: original version

[xx,yy] = ndgrid((1:imSz(1)) - circleParams(1), ...
                 (1:imSz(2)) - circleParams(2));
             
out = (xx.^2 + yy.^2) < circleParams(3)^2;

end
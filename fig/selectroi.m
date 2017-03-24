function [mask] = selectroi(varargin)
% selectroi.m: draw ROIs in the displayed image and create corresponding masks
%   
% Syntax:
%    1) [mask] = selectroi('n', n, 'collapse', collapse)
%
% Description:
%    1) [mask] = selectroi('n', n, 'collapse', collapse) initializes a tool
%       (roipoly.m) to draw regions of interest (ROIs) in the currently
%        displayed image
%
% Inputs:
%    ------------------------------ OPTIONAL -------------------------------
%    <n>          int>0     :   number of ROIs to draw
%                               if not provided, user prompted to specify it
%    <collapse>   logical   :   scalar (default: false)
%                               [true]:  output 2D logical with collapsed ROIs
%                               [false]: output 3D logical where each plane 
%                               in the 3rd dim is each individually drawn ROI)
% 
% Outputs:
%    1) mask: 2D [rows, cols] or 3D matrix [rows, cols, roiIdx] mask
%             (depending on <collapse>)
%
% Notes/Assumptions: 
%    1) In this function it is always assumed that the ROI will be drawn
%       in a currently displayed/open figure. The reason for this is that
%       to draw a ROI we probably need an optimal caxis which would require
%       further input arguments to this function. So it is assumed that 
%       this display "optimization" is done before calling this function
%
% References:
%    []
%
% Required functions:
%    1) isint.m
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20150102: original version (only 2D)
% fnery, 20150825: now option to avoid collapsing ROIs
% fnery, 20151207: now no argins result in input to select nROIs
% fnery, 20170324: now argins in name-value format

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin);
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'n'}
            if isint(cVal) && cVal > 0 
                n = cVal;
            else
                error('Error: ''n'' must be an integer > 0 (number of ROIs)');
            end
        case {'collapse'}
            if islogical(cVal) && isscalar(cVal);
                collapse = cVal;
            else                
                error('Error: ''collapse'' must be a logical scalar');
            end                    
        otherwise
            error('Error: input argument not recognized');
    end
end

% Defaults
nExists = exist('n', 'var');
collapseExists = exist('collapse', 'var');

if ~nExists
    prompt = 'How many ROIs to draw? ';
    n = input(prompt);
end

if ~collapseExists
    collapse = false;
end

% Read image data from axes
im = getimage;
[nRows, nCols] = size(im);

% Draw ROI(s)
mask = zeros(nRows, nCols, n); % pre-allocate mask
for iROI = 1:n
    mask(:, :, iROI) = roipoly;
end

if collapse
    % Collapse matrices along the third dimension
    mask = sum(mask, 3) > 0;
end

end
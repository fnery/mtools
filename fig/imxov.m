function ImxOv = imxov(map, mask, cAx)
% imxov.m: create ImxOv struct for parametric map overlay in imx.m
%   
% Syntax:
%    1) ImxOv = imxov(map, mask)
%    2) ImxOv = imxov(map, mask, cAx)
%
% Description:
%    1) ImxOv = imxov(map, mask) creates an ImxOv struct for use with imx.m
%    2) ImxOv = imxov(map, mask, cAx) creates an ImxOv struct for use with
%       imx.m and further allows to specify the color axis for displaying
%       the parametric map with imx.m
%       Also see Note 1.
%
% Inputs:
%    1) map:  2-3D array (parametric map)
%    2) mask: 2-3D logical array (coordinates for displaying parametric map)
%    3) cAx:  intensity range (IR)
%             - [1x2]: IR = [int(1) int(2)]
%               default: [min(im(:)) max(im(:))]]
%
% Outputs:
%    1) ImxOv: struct containing the input arguments (including default
%              value for cAx if not supplied as an argin):
%              |--map
%              |--mask
%              |--cAx
%
% Notes/Assumptions: 
%    1) This was created specifically for use with imx.m. An unplanned issue
%       when imx.m was initially wrote was the overlay of parametric maps
%       on top of "base" images. As a quick fix, a new type of input
%       argument was included in imx.m (called 'imxov') which must be one of
%       the outputs of this function
%    2) This should be turned into a class
%    3) See also showoverlaymap.m
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%   1) imx.m (not necessary to run this function but this function is
%      only for use together with imx.m)
% 
% Examples:
%   []
%
% fnery, 20160917: original version

if nargin < 2 
    error('Error: ''imxov.m'' needs at least 2 input arguments');
elseif nargin > 3
    error('Error: ''imxov.m'' accepts 3 input arguments at the most');
end

if size(map) ~= size(mask)
    error('Error: ''map'' and ''mask'' must have the same dimensions');
end

map = double(map);

% Default cAxis
if nargin == 2
    x = map(:);
    cAx = [min(x) max(x)];
end

ImxOv.map = map;
ImxOv.mask = mask;
ImxOv.cAx = cAx;

end
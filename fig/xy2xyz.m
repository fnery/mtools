function xyz = xy2xyz(varargin)
% xy2xyz.m: convert point 2D (xy (as in montage)) to 3D (xyz) coordinates 
%   
% Syntax:
%    1) xyz = xy2xyz(varargin)
%
% Description:
%    1) xy = xyz2xy(varargin) takes a list of xy coordinates of several
%       points as they are displayed in a montage and converts them to 3D
%       coordinates 
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------ 
%    <xy>       int>0    :  [x,y] coordinates of points to convert to [x,y,z]
%                             - size [Nx2]: "N" points to convert
%    <sz>       int>0    :  size of 3D image corresponding to <xyz>
%                             - [1x3]: [rows, columns, slices]
%    ----------------------------- OPTIONAL -------------------------------
%    <mgrid>    vector   :  montage grid shape
%                             - size [1x2]: [nRows, nColumns]
%    ----------------------------------------------------------------------
%
% Outputs:
%   1) xyz: 3D (xy) coordinates
%
% Notes/Assumptions: 
%    1) Used in imx.m
%
% References:
%   []
%
% Required functions:
%   1) is1d.m
%   2) mgridshape.m
%
% Required files:
%   []
% 
% Examples:
%   []
%
% fnery, 20160612: original version

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'xy'}
            % verify if 'xy' is valid
            isNumeric = isnumeric(cVal);
            isMatrix = ismatrix(cVal);
            hasCorrectDims = size(cVal,2)==2;
            if isNumeric && isMatrix && hasCorrectDims
                xy = cVal;
            else
                error('Error: ''xy'' is invalid')
            end
        case {'sz'}
            % verify if 'sz' is valid
            isNumeric = isnumeric(cVal);
            isMatrix = ismatrix(cVal);
            hasCorrectDims = isequal(size(cVal), [1 3]);
            if isNumeric && isMatrix && hasCorrectDims
                sz = cVal;
            else
                error('Error: ''sz'' is invalid')
            end
        case {'mgrid'}
            % verify if 'mgrid' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                mGrid = cVal;
            else
                error('Error: ''mgrid'' is invalid')
            end            
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =        ...
    exist('xy'  , 'var') & ...    
    exist('sz'  , 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which argins were provided
mgridExists = exist('mGrid', 'var');
if ~mgridExists ; mGrid = mgridshape('nIms', sz(3)) ; end; % default mGrid

nPts = size(xy, 1);

% Aux variable: slice indexes in "mgrid" format
montIdxs = reshape(1:prod(mGrid), mGrid(end:-1:1))';

xyz = NaN(nPts, 3); % pre-allocate
 
for iPt = 1:nPts
    
    % Current point xyz coordinates
    cPt = xy(iPt,:); 
    
    xFact = ceil(cPt(1)/sz(2));
    yFact = ceil(cPt(2)/sz(1));
    
    if yFact > mGrid(1) || yFact > mGrid(2)
        % invalid, to remove later
        cX = 0;
        cY = 0;
        cZ = 0;
    else
        % valid, compute xyz coordinates
        cX = cPt(1)-(xFact-1)*sz(2);
        cY = cPt(2)-(yFact-1)*sz(1);
        cZ = montIdxs(yFact, xFact);
    end    

    % Save
    xyz(iPt, 1) = cX;
    xyz(iPt, 2) = cY;
    xyz(iPt, 3) = cZ;

end

end
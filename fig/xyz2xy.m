function xy = xyz2xy(varargin)
% xyz2xy.m: convert point 3D (xyz) to 2D (xy) coordinates (as in montage)
%   
% Syntax:
%    1) xy = xyz2xy(varargin)
%
% Description:
%    1) xy = xyz2xy('xyz', xyz, 'sz', sz) takes a list of xyz coordinates 
%       of several points and converts them to 2D coordinates as they are 
%       displayed in a montage
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------ 
%    <xyz>      int>0    :  [x,y,z] coords of points to convert to [x,y]
%                             - size [Nx3]: "N" points to convert
%    <sz>       int>0    :  size of 3D image corresponding to <xyz>
%                             - [1x3]: [rows, columns, slices]
%    ----------------------------- OPTIONAL -------------------------------
%    <mgrid>    vector   :  montage grid shape
%                             - size [1x2]: [nRows, nColumns]
%    ----------------------------------------------------------------------
%
% Outputs:
%    1) xy: 2D (xy) coordinates (as in montage)
%
% Notes/Assumptions: 
%    1) Used in imx.m
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%    2) mgridshape.m
%
% Required files:
%    []
% 
% Examples:
%    []
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
        case {'xyz'}
            % verify if 'xyz' is valid
            isNumeric = isnumeric(cVal);
            isMatrix = ismatrix(cVal);
            hasCorrectDims = size(cVal,2)==3;
            if isNumeric && isMatrix && hasCorrectDims
                xyz = cVal;
            else
                error('Error: ''xyz'' is invalid')
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
    exist('xyz' , 'var') & ...    
    exist('sz'  , 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which argins were provided
mGridExists = exist('mgrid', 'var');
if ~mGridExists ; mGrid = mgridshape('nIms', sz(3)) ; end; % default <mgrid>

nPts = size(xyz, 1);

% Aux variable: slice indexes in "mgrid" format
montIdxs = reshape(1:prod(mGrid), mGrid(end:-1:1))';

xy = NaN(nPts, 2); % pre-allocate
 
for iPt = 1:nPts
    
    % Current point xyz coordinates
    cPt = xyz(iPt,:); 
    
    % Compute xy coordinates in montage
    [yFact, xFact] = ind2sub(mGrid, find(montIdxs == cPt(3)));
    
    if yFact > mGrid(1) || yFact > mGrid(2)
        % invalid
        xy = [0 0]; % to remove later
    else
        % valid
        cX = (xFact-1)*sz(2)+cPt(1);
        cY = (yFact-1)*sz(1)+cPt(2);
    end
    
    % Save
    xy(iPt, 1) = cX;
    xy(iPt, 2) = cY;

end

end
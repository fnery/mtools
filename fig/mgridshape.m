function mGrid = mgridshape(varargin)
% mgridshape.m: get montage grid shape (can constrain nRows/nColumns)
%   
% Syntax:
%    1) mGrid = mgridshape('nIms', nIms, 'nRows', nRows, 'nCols', nCols>)
%
% Description:
%    1) mGrid = mgridshape('nIms', nIms, 'nRows', nRows, 'nCols', nCols)
%       initialises the dimensions of a grid to display 3D volumes as 2D 
%       montages. The number of rows or columns can be constrained.
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------
%    <nIms>    scalar   :    number of images
%    ------------------------------ OPTIONAL ------------------------------
%    <nRows>   scalar   :    number of rows we want to force mGrid to have
%    <nCols>   scalar   :    number of columns we want to force mGrid to have
%
% Outputs:
%    1) mGrid: scalar vector ([rows, cols]) of the grid for displaying montages
%
% Notes/Assumptions: 
%    1) Mostly to use in conjunction with imx.m
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
%    >> mGrid = mgridshape('nIms', 9)
%           mGrid =
%               3     3
%    >> mGrid = mgridshape('nIms', 9, 'nRows', 4)
%           mGrid =
%               4     3
%    >> mGrid = mgridshape('nIms', 9, 'nCols', 2)
%           mGrid =
%               5     2
%
% fnery, 20160612: original version
% fnery, 20160921: add row/col opts, argins now name-value pairs, updated doc

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
        case {'nims'}
            % verify if 'nIms' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                nIms = cVal;
            else
                error('Error: ''nIms'' is invalid')
            end
        case {'nrows'}
            % verify if 'nRows' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                nRows = cVal;
            else
                error('Error: ''nRows'' is invalid')
            end
        case {'ncols'}
            % verify if 'nCols' is valid
            isNumeric = isnumeric(cVal);
            isScalar = isscalar(cVal);
            if isNumeric && isScalar
                nCols = cVal;
            else
                error('Error: ''nCols'' is invalid')
            end      
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('nIms', 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which argins were provided
nRowsExists = exist('nRows'  , 'var');
nColsExists = exist('nCols'  , 'var');
if ~nRowsExists ; nRows = [] ; end;
if ~nColsExists ; nCols = [] ; end;

if nRows > nIms || nCol > nIms
    error('Error: <nRows> and <nCols> must be smaller than <nIms>');
end

% User-defined mGrid shape
if ~isempty(nRows) && ~isempty(nCols)
    if nRows*nCols>=nIms
        mGrid = [nRows, nCols];
    else
        error('Error: nRows*nCols can''t be smaller than nIms');
    end
end
  
% Default mGrid shape
if isempty(nRows) && isempty(nCols)
    x = sqrt(nIms);
    if round(x) > x
        mGrid(1) = ceil(x);
        mGrid(2) = ceil(x);
    else
        mGrid(1) = floor(x);
        mGrid(2) = ceil(x);
    end
end

% User-defined nRows
if ~isempty(nRows) && isempty(nCols)
    mGrid(1) = nRows;
    mGrid(2) = ceil(nIms/nRows);   
end

% User-defined nCols
if isempty(nRows) && ~isempty(nCols)
    mGrid(1) = ceil(nIms/nCols);   
    mGrid(2) = nCols;    
end

end
function out = imclipint(varargin)
% imclipint.m: clip image intensities
%   
% Syntax:
%    1) out = imclipint('im', im, 'opt', opt)
%
% Description:
%    1) out = imclipint('im', im, 'opt', opt) clips image intensities
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------
%    <im>      numeric    :   nD image
%    ------------------------------ OPTIONAL ------------------------------
%    <int>     numeric    :   intensity range (IR) [1x2] 
%                                 - IR(1) = int(1)
%                                 - IR(2) = int(2)
%    <rint>    numeric    :   [r]elative IR [1x2]
%                                 - IR(1) = min(im(:))*rInt(1)
%                                 - IR(2) = max(im(:))*rInt(2)   
%    <pint>    numeric    :   [p]ercentile IR [1x2]
%                                 - IR(1) = prctile(im(:), pInt(1))
%                                 - IR(2) = prctile(im(:), pInt(2))
%                             default: [min(im(:)) max(im(:))] (no change) 
%
% Outputs:
%    1) out: new image, with modified intensities
%
% Notes/Assumptions: 
%    1) Created for assisting when showing overlays
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%
% Required files:
%    []
% 
% Examples:
%    >> % Create test image
%    >> im1 = imtest;
%    >> fprintf('min(im)=%.1f; max(im)=%.1f\n', min(im1(:)), max(im1(:)))
%           min(im1)=0.0; max(im1)=88.0
%    >> % 1) 
%    >> int  = [10 60];
%    >> im2  = imclipint2('im', im1, 'int', int);
%    >> fprintf('min(im)=%.1f; max(im)=%.1f\n', min(im2(:)), max(im2(:)))
%           min(im2)=10.0; max(im2)=60.0
%    >> % 2)
%    >> rInt = [0.1 0.8];
%    >> im3  = imclipint2('im', im1, 'rint', rInt);
%    >> fprintf('min(im)=%.1f; max(im)=%.1f\n', min(im3(:)), max(im3(:)))
%           min(im3)=0.0; max(im3)=70.4
%    >> % 3)
%    >> pInt = [20 80];
%    >> im4  = imclipint2('im', im1, 'pint', pInt);
%    >> fprintf('min(im)=%.1f; max(im)=%.1f\n', min(im3(:)), max(im4(:)))
%           min(im4)=0.0; max(im4)=23.0
%
% fnery, 20160609: original version

% ==================================
% ===== Manage input arguments ===== --------------------------------------
% ==================================
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end    
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'im'}
            % verify if 'im' is valid
            isNumeric = isnumeric(cVal);
            isLogical = islogical(cVal);
            hasCorrectDims = ismatrix(cVal) || ndims(cVal) == 3;
            if (isNumeric || isLogical) && hasCorrectDims
                im = double(cVal);
            else
                error('Error: ''im'' is invalid')
            end
        case {'int'}
            % verify if 'int' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                int = cVal;
            else
                error('Error: ''int'' is invalid')
            end
        case {'rint'}
            % verify if 'rint' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                rInt = cVal;
            else
                error('Error: ''rint'' is invalid')
            end
        case {'pint'}
            % verify if 'pint' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectLen = length(cVal) == 2;
            if isNumeric && is1d(cVal) && hasCorrectLen
                pInt = cVal;
            else
                error('Error: ''pint'' is invalid')
            end                       
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('im', 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which argins were provided
intExists   = exist('int'   , 'var');
rIntExists  = exist('rInt'  , 'var');
pIntExists  = exist('pInt'  , 'var');

% ===================================
% ===== Image display intensity ===== -------------------------------------
% ===================================

imVec = im(:);
maxI  = max(imVec);
minI  = min(imVec);

nIntOpts = intExists + rIntExists + pIntExists;
if nIntOpts == 0
    intRange = [minI, maxI];
elseif nIntOpts > 1
    error('Error: can use only one of: <int>, <rint>, <pint>');
elseif intExists
    intRange = [int(1), int(2)];
elseif rIntExists
    intRange = [minI*rInt(1) maxI*rInt(2)];
else 
    % pintExists
    intRange = [prctile(imVec, pInt(1)) prctile(imVec, pInt(2))];
end
clear imVec;

% ====================================
% ===== Modify image intensities ===== ------------------------------------
% ====================================
newMin = intRange(1);
newMax = intRange(2);
im(im<newMin) = newMin;
im(im>newMax) = newMax;

out = im;

end
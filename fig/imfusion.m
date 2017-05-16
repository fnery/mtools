function out = imfusion(varargin)
% imfusion.m: create fusion image (composite of two images)
%   
% Syntax:
%    1) out = imfusion('im1', im1, 'im2', im2, 'w1', w1)
%
% Description:
%    1) out = imfusion('im1', im1, 'im2', im2, 'w1', w1) creates an RGB 
%       image "out" which corresponds to the fusion of images "im1" and 
%       "im2", according to the "im1" weighing factor "w1"
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------
%    <im1>    2D image    :    Image 1
%    <im2>    2D image    :    Image 2
%    ------------------------------ OPTIONAL ------------------------------
%    <w1>     scalar      :    Weighing factor for <im1>
%                                 - Range: [0-1]
%                                 - Note that <w2> = 1 - <w1>
%    <c>      char        :    Colormap used for displaying <im2>
%                                 - Default MATLAB colormap strings
% 
% Outputs:
%    1) out: RBG fused image
%
% Notes/Assumptions: 
%    1) Assumes intensity clipping is done outside (before) this function
%       Use imclipint.m for that purpose
%    2) Didn't optimise
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
%    >> im1 = phantom(256);
%    >> im2 = imtranslate(im1, [15, 15]);
%    >> out = imfusion('im1', im1, 'im2', im2);
%    >> figure, imshow(out); fs;
%
% fnery, 20170516: original version

N_COLORS = 2^12;

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
        case {'im1'}
            % verify if 'im1' is valid
            isMatrix = ismatrix(cVal);
            if isMatrix
                im1 = cVal;
            else
                error('Error: ''im1'' is invalid')
            end
        case {'im2'}
            % verify if 'im2' is valid
            isMatrix = ismatrix(cVal);
            if isMatrix
                im2 = cVal;
            else
                error('Error: ''im2'' is invalid')
            end
        case {'w1'}
            % verify if 'w1' is valid
            isScalar = isscalar(cVal);
            if isScalar
                w1 = cVal;
            else
                error('Error: ''w1'' is invalid')
            end
        case {'c'}
            % verify if 'c' is valid
            isChar = ischar(cVal);
            if isChar
                c = cVal;
            else
                error('Error: ''c'' is invalid')
            end
        otherwise
            error('Error: input argument not recognized');
    end
end

% ====================
% ===== Defaults ===== ----------------------------------------------------
% ====================

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('im1', 'var') && exist('im2', 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which argins were provided
w1Exists = exist('w1', 'var');
cExists  = exist('c' , 'var');
if ~w1Exists ; w1 = 0.5   ; end;
if ~cExists  ; c  = 'jet' ; end;


% ========================
% ===== Error checks ===== ------------------------------------------------
% ========================

% Ensure chosen colormap is valid
try 
    eval(sprintf('cmap = %s(N_COLORS);', c));
catch
    error('Error: The chosen colormap (''c'') is unknown');
end

% Dims
if ~isequal(size(im1), size(im2));
    error('Error: ''im1'' and ''im2'' need to have the same dimensions');
end

% w1 within range
if w1 < 0 || w1 > 1
   error('Error: ''w1'' must be between 0 and 1'); 
end

% ============================
% ===== Fusion algorithm ===== --------------------------------------------
% ============================

w2 = 1 - w1;

% Normalise intensities (see note 1 above)
im1 = im1./max(im1(:));
im2 = im2./max(im2(:));

im2 = repmat(im2, [1 1 3]);

out = NaN(size(im1, 1), size(im1, 2), 3); % pre-alloc

for iPixel = 1:numel(im1)
    
    cPix1 = im1(iPixel);
    cPix2 = im2(iPixel); 
    
    cCmapIdx = round(cPix2*N_COLORS);
    
    % (not pretty)
    if cCmapIdx >  N_COLORS ; cCmapIdx = N_COLORS ; end
    if cCmapIdx == 0        ; cCmapIdx = 1        ; end   
    
    cCmap = cmap(cCmapIdx, :); %#ok<NODEF>
    
    [cRow, cCol] = ind2sub(size(im1), iPixel);
    
    % Create fused image
    out(cRow, cCol, 1) = w1*cPix1 + w2*cPix2*cCmap(1);
    out(cRow, cCol, 2) = w1*cPix1 + w2*cPix2*cCmap(2);
    out(cRow, cCol, 3) = w1*cPix1 + w2*cPix2*cCmap(3);
    
end

end
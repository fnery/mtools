function [imOut, ptOut] = crop(varargin)
% crop.m: crop image and/or sets of coordinates
%   
% Syntax:
%    1) [imOut, ptOut] = crop('im', im, 'pt', pt, 'cropmask', cropmask);
%
% Description:
%    1) [imOut, ptOut] = crop(varargin) crops nD images according to
%       provided mask or set of pixel coordinates specifying a mask for
%       cropping.
%       If <pt> is provided the pixel coordinates are also "cropped". With
%       this, we can update voxel coordinates after cropping an image, so
%       that the new voxel coordinates reflect the cropping.
%
% Inputs:
%    ----------------------------------------------------------------------
%    <im>       $1 matrix  :  [2-n]D image to crop 
%    <pt>          int>0   :  points whose coordinates need to be 
%                             re-computed following cropping operation:
%                             - [x,y(,z)] vector: coordinates of 1 point
%                             - [nPts x nDims] matrix: coords of "n" points:
%                                  ---                        ---
%                                  | point1x , point1y, point1z |
%                                  | point2x , point2y, point2z |
%                                  |   ...   ,   ...  ,   ...   |
%                                  | pointNx , pointNy, pointNz |
%                                  ---                        ---
%    <cropmask> $2 logical :  2/3D image that specifies cropping         
%    <croppt>   $2 logical :  4/6 element vector that specifies cropping
%                             - [xmin ymin width height]
%                             - [xmin ymin zmin width height depth]
%    ------------------------------ NOTES --------------------------------- 
%    $1 can use both <im> and <pt> simultaneously or only one of them
%    $2 can only use one of these at a time
%
% Outputs:
%    1) imOut: new image following cropping
%    2) ptOut: new set of coordinates following cropping
%
% Notes/Assumptions: 
%    []
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
% Example:
%    >> % CONSTANTS
%    >> IM_SZ    = 128; 
%    >> N_SLICES = 4;
%    >> % Example point of interest "to be cropped"
%    >> IN_PT   = [62, 57, 2];
%    >> % Points to specify cropping  [xmin ymin zmin width height depth]
%    >> CROP_PT = [40, 25, 2, 50, 70, 2]; % keep centres of slices 2, 3 and 4
%    >> 
%    >> % Create test image
%    >> % (multiply slices by different factors (f) for distinguishing them)
%    >> im = phantom(IM_SZ);
%    >> im = repmat(im, [1 1 N_SLICES]);
%    >> f = repmat(reshape(1:2:N_SLICES*2, [1 1 N_SLICES]), [IM_SZ, IM_SZ, 1]);
%    >> im = im.*f;
%    >> 
%    >> % Go
%    >> [imOut, ptOut] = crop('im', im, 'pt', IN_PT, 'croppt', CROP_PT);
%    >> figure, imx('im', im, 'rint', [0 1], 'divw', 1); title('before');
%    >> c = caxis;
%    >> figure, imx('im', imOut, 'int', c, 'divw', 1); title('after');
%    >> 
%    >> % Info string
%    >> fprintf('pt    = %s \nptOut = %s\n', vec2str(IN_PT, '%d'), vec2str(ptOut, '%d'))
%    >> disp('Note how ''pt'' in ''im'' corresponds to ''ptOut'' in ''imOut''');
%           pt    = [62, 57, 2] 
%           ptOut = [23, 33, 1]
%           Note how 'pt' in 'im' corresponds to 'ptOut' in 'imOut'
%
% fnery, 20160612: original version
% fnery, 20160911: fixed bug when cropping 3D 'pt's; wrote documentation

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
        case {'im'}
            % verify if 'im' is valid
            isNumeric = isnumeric(cVal);
            isLogical = islogical(cVal);
            hasCorrectDims = ndims(cVal) >= 2;
            if (isNumeric || isLogical) && hasCorrectDims            
                im = cVal;
            else
                error('Error: ''im'' is invalid')
            end
        case {'pt'}
            % verify if 'pt' is valid 
            if is1d(cVal) || ismatrix(cVal)
                pt = cVal;
            else
                error('Error: ''pt'' is invalid');
            end
        case {'cropmask'}
            % verify if 'cropmask' is valid 
            hasCorrectDims = ismatrix(cVal) || ndims(cVal) == 3;
            if islogical(cVal) && hasCorrectDims
                cropMask = cVal;
            else
                error('Error: ''cropmask'' is invalid');
            end
        case {'croppt'}
            % verify if 'croppt' is valid 
            if is1d(cVal) && (length(cVal) == 4 || length(cVal) == 6)
                cropPt = cVal;
            else
                error('Error: ''croppt'' is invalid');
            end                       
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check existing inputs
imExists       = exist('im'       , 'var');
ptExists       = exist('pt'       , 'var');
cropMaskExists = exist('cropMask' , 'var');
cropPtExists   = exist('cropPt'   , 'var');

if (imExists+ptExists) == 0
    error('Error: Either <im> or <pt> must be used');
end

if (cropMaskExists+cropPtExists) == 2
    error('Error: Can''t use both <cropmask> or <croppt> at the same time');
elseif (cropMaskExists+cropPtExists) == 0
    error('Error: Either <cropmask> or <croppt> must be used');
end

if cropMaskExists
    
    % Convert <cropmask> "info" to same format as <croppt> $3 so that the
    % cropping algorithm is independent of the argin types
    
    % Get mask extremes
    [r, c, s] = ind2sub(size(cropMask), find(cropMask));
    rMin = min(r);
    rMax = max(r);
    cMin = min(c);
    cMax = max(c);
    sMin = min(s);
    sMax = max(s);
    
    % $3 Convert to [xmin ymin zmin width height depth] format
    xMin   = cMin;
    yMin   = rMin;
    zMin   = sMin;
    width  = cMax - cMin;
    height = rMax - rMin;
    depth  = sMax - sMin;
    
else
    
    % Parse <croppt> 
    if length(cropPt) == 4
        xMin   = cropPt(1);
        yMin   = cropPt(2);
        zMin   = 1;
        width  = cropPt(3);
        height = cropPt(4);
        depth  = 1;
    elseif length(cropPt) == 6
        xMin   = cropPt(1);
        yMin   = cropPt(2);
        zMin   = cropPt(3);
        width  = cropPt(4);
        height = cropPt(5);
        depth  = cropPt(6);
    else
        error('Error: this point should never be reached');
    end
    
end

% Debugging string below:
% fprintf('xMin   = %03d\nyMin   = %03d\nzMin   = %03d\nwidth  = %03d\nheight = %03d\ndepth  = %03d\n', ...
%     xMin, yMin, zMin, width, height, depth);
 
yMax = yMin+height-1; % -- 
xMax = xMin+width-1;  % | redundant but worth it for simplifying code below
zMax = zMin+depth;    % --

% _________________________________________________________________________
%                                 Crop <im>
% _________________________________________________________________________


if imExists
    % Crop <im>
    if ismatrix(im);
        % 2D
        imOut = im(yMin:yMax, xMin:xMax);
    elseif ndims(im) == 3
        % 3D
        imOut = im(yMin:yMax, xMin:xMax, zMin:zMax);
    else
        % nD
        tmp = repmat(', :', [1 (ndims(im)-3)]); % "ndim-independent" index
        cmd = sprintf('imOut = im(yMin:yMax, xMin:xMax, zMin:zMax%s);', tmp);
        eval(cmd);
    end
else
    imOut = [];
end

% _________________________________________________________________________
%                                 Crop <pt>
% _________________________________________________________________________

if ptExists
    
    ptOut(:, 1, :) = pt(:, 1, :) - (xMin-1);
    ptOut(:, 2, :) = pt(:, 2, :) - (yMin-1);
    
    if size(pt,2)>2
        ptOut(:, 3, :) = pt(:, 3, :) - (zMin-1);
    end
    
    if any(ptOut(:) < 1)
        error('Error: <pt> out of cropping range (coords <1 after cropping)');
    end
    
else
    ptOut = [];
    
end

end
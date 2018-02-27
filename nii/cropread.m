function out = cropread(in)
% cropread.m: parses .crop files with coordinates for cropping ROIs
%
% Syntax:
%    1) out = cropread(in)
%
% Description:
%    1) out = cropread(in) parses .crop files with coordinates for
%       cropping regions of interest (typically for allowing independent
%       rigid/affine registrations for each kidney of a dataset
%
% Inputs:
%    1) in: full file path to .crop file
%
% Outputs:
%    1) out: [nROIs x 6] matrix  cropping coordinates in the format used
%       by FSL's fslroi function [1]
%
% Notes/Assumptions: 
%    1) The following is an example of a crop file (ignore curly brackets):
%       {
%       % Coordinates to crop region(s) of interest (ROIs)
%       % Format used by FSL's fslroi function:
%       % <xmin> <xsize> <ymin> <ysize> <zmin> <zsize>
%       % Number of lines = number of ROIs in the dataset
%       13 32 34 48 0 14
%       54 31 36 49 0 14
%       }
%    2) .crop files as the one above can be create with cropwrite.m
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%
% Required functions:
%    []
%
% Required files:
%    1) .crop file
%
% See also:
%    1) cropwrite.m
%
% Examples:
%    []
%
% fnery, 20171101: original version
% fnery, 20180227: renamed from readcrop.m to cropread.m

% Suppress irrelevant warnings
%#ok<*AGROW>: don't care about pre-allocating out
%#ok<*ST2NM>: cLine is not a scalar

N_COORDS_PER_ROI = 6; % see Note 1)

% Open file
f = fopen(in);

% Parse 'in'
cLine = fgetl(f);

if cLine == -1
    
    fclose(f);
    error('Error: input file is empty');
    
end

ctAllLines = 1;
ctCoordLines = 0;

while ischar(cLine)  
    
    % Check if current line is to be parsed (ignore lines starting with %)
    toParse = (~isempty(cLine)) && (~strcmp('%', cLine(1)));
    
    if toParse
        
        ctCoordLines = ctCoordLines + 1;    
        cCoords = str2num(cLine); 
        
        % Some error checking
        if isempty(cCoords)
            
            fclose(f);
            error('Line %d in input file could not be parsed', ctAllLines)
            
        elseif length(cCoords) ~= N_COORDS_PER_ROI
            
            fclose(f);
            error('Line %d not in ''<xmin> <xsize> <ymin> <ysize> <zmin> <zsize>'' format', ctAllLines)
       
        end
        
        out(ctCoordLines, :) = str2num(cLine); 
    end
    
    % Next line
    cLine = fgetl(f);
    ctAllLines = ctAllLines + 1;
    
end

% Close file
fclose(f);

end
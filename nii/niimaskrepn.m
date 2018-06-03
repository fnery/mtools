function out = niimaskrepn(from, into, mask, out)
% niimaskrepn.m: niimaskrep.m wrapper for the case of multiple source images
%
% Syntax:
%    1) out = niimaskrepn(from, into, mask, out)
%
% Description:
%    2) out = niimaskrepn(from, into, mask, out) wraps niimaskrep.m when a 
%       mask replacement operation has multiple source (from) files.
%       This is the case following registration with multiple masks using
%       my elastix wrapper library (elx.m, elxn.m, elx4d.m). An example is
%       registering two kidneys separately. After running the registrations
%       we will have the following outputs (among others)
%       - image A: where kidney 1 has been registered using mask 1
%       - image B: where kidney 2 has been registered using mask 2
%       We want to create an image C which is equal to the moving image
%       that was the input to both registrations above but where the voxels
%       specified by mask 1 will now have the intensities of image A and
%       the voxels specified by mask 2 will now have the intensities of
%       image B   
%
% Inputs:
%    1) from: cell of string(s), path(s) to source nii file(s) (tested 3D nii)
%    2) into: string, path to target nii file                  (tested 3D nii)
%    3) mask: cell of string(s), path(s) to mask nii file(s)   (tested 3D nii)
%    4) out: path or name of nii file to be created
%
% Outputs:
%    1) out: full path of created nii file
%
% Notes/Assumptions: 
%    1) The main assumption in this function is that there is a 1-to-1
%       correspondence between the images in 'from' and the masks in 'mask'.
%       That is:
%       - Intensities from from{1} are going to replace the
%         ones in 'into' at the voxel coordinates specified by mask{1}
%       - Intensities from from{2} are going to replace the
%         ones in 'into' at the voxel coordinates specified by mask{2}
%       - ...
%       - Intensities from from{n} are going to replace the
%         ones in 'into' at the voxel coordinates specified by mask{n}
%    2) The other assumption is that the different masks do not share any
%       voxel in common (note this is not checked by the code!).
%    3) Only 3D NIfTI inputs have been tested but this function may work
%       with 2D and 4D input files. See niimaskrep.m for more.
%
% References:
%    []
%
% Required functions:
%    1) outinit.m
%    2) mkdirtmp.m
%    3) fileparts2.m
%    4) niimaskrep.m
%
% Required files:
%    1) None in addition to the files specified by the input arguments
%
% Examples:
%    []
%
% fnery, 20180603: original version

% Error checks
if nargin ~= 4
    error('Error: this function needs 4 input arguments');
end

if ~iscell(from)
    error('Error: ''from'' must be a cell of string(s) (path(s) to file)');
end

if ~ischar(into)
    error('Error: ''into'' must be a string (path to file)');
end

if ~iscell(mask)
    error('Error: ''mask'' must be a cell of string(s) (path(s) to file)');
end

if ~ischar(out)
    error('Error: ''out'' must be a string (file path or file name (incl. ext))');
else
    % Initialise full path of output file
    out = outinit(out);
end

nFrom  = length(from);
nMasks = length(mask);

if ~isequal(nFrom, nMasks)
    error('Error: no. of files in ''from'' must be equal to no. files in ''mask''');
else
    n = nFrom;
end

% Create temporary directory for temporary outputs
tmpDir = mkdirtmp;

% Get extension for temporary files
[~, ~, ext] = fileparts2(into);

% Main replacement algorithm
for i = 1:n
    
    % Initialise inputs for current call of niimaskrep.m
    cFrom = from{i};
    cMask = mask{i};
    cTmp  = fullfile(tmpDir, sprintf('tmp_%04d%s', i, ext));
    
    if i == 1
        cInto = into;
    else
        cInto = cOut;
    end
    
    % Replace in according to current mask
    cOut = niimaskrep(cFrom, cInto, cMask, cTmp);
    
end
    
% The output of the last call of niimaskrep.m is the file we desire, so we
% just need to move/rename it to the specified directory/name, given by out
status = movefile(cOut, out);
if status ~= 1
    error('Error: error renaming output file');
end
pause(1); % just in case
    
% Delete temporary directory its temporary files
fclose('all');
rmdir(tmpDir, 's')

end
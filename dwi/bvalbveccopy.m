function bvalbveccopy(inNii, outNii)
% bvalbveccopy.m: copy bval/bvec files (name to match existing NIfTI file)
%
% Syntax:
%    1) [bvalbveccopy(inNii, outNii)
%
% Description:
%    1) bvalbveccopy(inNii, outNii) takes existing bval/bvec files (via
%       their corresponding NIfTI (.nii/.nii.gz) filepath) and copies them 
%       with a name to match existing .NIfTI file(s).
%       This useful to generate bval/bvec pairs for new NIfTI files which
%       have been generated from a NIfTI file who has a bval/bvec pair which
%       is appropriate for the new NIfTI file. 
%       A use case is the need to create bval/bvec pairs after a cropping
%       operation. Say we have File.nii.gz (and the corresponding File.bval
%       and File.bvec). Say we crop File.nii.gz to generate File_cropped.nii.gz
%       By doing bvalbveccopy(File.nii.gz, File_cropped.nii.gz)
%       (pseudo-code) we will generate File_cropped.bval/File_cropped.bvec.
%       These two are just copies of File.bval and File.bvec but with name
%       matching the cropped NIfTI file.
%
% Inputs:
%    1) inNii: path of the NIfTI file for which there exists the bval/bvec
%       pair which will be copied
%    2) outNii: string OR cell of strings with path(s) of the NIfTI file(s)
%       for which we want to create the bval/bvec pair(s). 
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    1) Should work for both .nii and .nii.gz
%
% References:
%    []
%
% Required functions:
%    1) bvalbvecpath.m
%
% Required files:
%    In addition to inNii and outNii, a bval/bvec part for inNii must exist
%
% Examples:
%   []
%
% fnery, 20180516: original version

if ischar(outNii) && size(outNii, 1) == 1 && size(outNii, 2) > 0
    % outNii is a string, convert it to a cell
    outNii = {outNii};
elseif ~iscell(outNii)
    error('Error: ''outNii'' must be a string or a cell of strings');
end

[inbVal, inbVec] = bvalbvecpath(inNii);

nOutNiis = length(outNii);

for iOutNii = 1:nOutNiis
    cOutNii = outNii{iOutNii};
    
    % Generate new bval and bvec file paths
    [cOutNiibVal, cOutNiibVec] = bvalbvecpath(cOutNii);
    
    % Copy bval
    [cStatus, cMessage, ~] = copyfile(inbVal, cOutNiibVal);
    if cStatus ~= 1
        error('Error: Error copying ''%s'': %s', inbVal, cMessage);
    end
    
    % Copy bvec
    [cStatus, cMessage, ~] = copyfile(inbVec, cOutNiibVec);
    if cStatus ~= 1
        error('Error: Error copying ''%s'': %s', inbVec, cMessage);
    end    
    
end

end
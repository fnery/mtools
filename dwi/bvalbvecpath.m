function [bVal, bVec] = bvalbvecpath(in)
% bvalbvecpath.m: generate bval/bvec names/paths from corresponding .nii image
%
% Syntax:
%    1) [bVal, bVec] = bvalbvecpath(in)
%
% Description:
%    1) [bVal, bVec] = bvalbvecpath(in) generates bval/bvec names/paths from
%       corresponding .nii images. Sometimes we generate a .nii image from
%       another, and need to use the original bvals/bvecs in the new image.
%       In this case, we just need to generate the bvals/bvecs file by 
%       copying it from the original image. This function creates the names
%       or full paths for the new bvals/bvecs file.
%
% Inputs:
%    1) in: string or cell of strings with name or path to .nii image
%
% Outputs:
%    1) bVal: corresponding bVal string or cell of strings (name or paths)
%    2) bVec: corresponding bVal string or cell of strings (name or paths)
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) fileparts2.m
%
% Required files:
%    []
%
% Examples:
%    % Example 1: string (full path) input
%        in1 = '/this/is/a/random/path/im.nii.gz';
%        [bVal1, bVec1] = bvalbvecpath(in1)
%    % Example 2: string (name) input
%        in2 = 'im.nii.gz';
%        [bVal2, bVec2] = bvalbvecpath(in2)
%    % Example 3: cell of strings (full paths) input
%        in3{1} = '/this/is/a/random/path/im1.nii.gz';
%        in3{2} = '/this/is/a/random/path/im2.nii.gz';
%        [bVal3, bVec3] = bvalbvecpath(in3')
%    % Example 4: cell of strings (names) input
%        in4{1} = 'im1.nii.gz';
%        in4{2} = 'im2.nii.gz';
%        [bVal4, bVec4] = bvalbvecpath(in4')
%    % OUTPUT: 
%    %     bVal1 =
%    %         /this/is/a/random/path/im.bval
%    %     bVec1 =
%    %         /this/is/a/random/path/im.bvec
%    %     bVal2 =
%    %         im.bval
%    %     bVec2 =
%    %         im.bvec
%    %     bVal3 = 
%    %         '/this/is/a/random/path/im1.bval'
%    %         '/this/is/a/random/path/im2.bval'
%    %     bVec3 = 
%    %         '/this/is/a/random/path/im1.bvec'
%    %         '/this/is/a/random/path/im2.bvec'
%    %     bVal4 = 
%    %         'im1.bval'
%    %         'im2.bval'
%    %     bVec4 = 
%    %         'im1.bvec'
%    %         'im2.bvec'
%
% fnery, 20171101: original version

EXTS.bval  = '.bval';
EXTS.bvec  = '.bvec';

[directory, name, ~] = fileparts2(in);

if ischar(in)
    
    % case 1: single file provided in 'in'
    bVal = fullfile(directory, [name EXTS.bval]);
    bVec = fullfile(directory, [name EXTS.bvec]);
    
elseif iscell(in)
    
    % case 2: multiple files provided in 'in'
    bVal = fullfile(directory, strcat(name, repmat({EXTS.bval}, size(in))));
    bVec = fullfile(directory, strcat(name, repmat({EXTS.bvec}, size(in)))); 
    
else
    error('Error: ''in'' must be a string or a cell of strings')
end

end

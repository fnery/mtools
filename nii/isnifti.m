function out = isnifti(in)
% isnifti.m: lazy nifti file path checker
%
% Syntax:
%    1) out = isnifti(in)
%
% Description:
%    1) out = isnifti(in) lazily checks whether the filepath given in 'in'
%       corresponds to a nifti file. 
%
% Inputs:
%    1) in: string (file path OR name+extension)
%
% Outputs:
%    1) out: logical scalar
%
% Notes/Assumptions: 
%    1) Lazy because it does not look at whether the file is a valid nifti
%       file but rather just simply looks at the file extension
%
% References:
%    []
%
% Required functions:
%    1) isext.m
%
% Required files:
%    []
%
% Examples:
%    isnifti('file.nii')
%    isnifti('file.nii.gz')
%    isnifti('file.nii.gz2')
%    % OUTPUT
%    %    ans = 1
%    %    ans = 1
%    %    ans = 0
%
% fnery, 20171103: original version

EXPECTED_FILE_EXTS = {'.nii', '.nii.gz'};

out = isext(in, EXPECTED_FILE_EXTS);

end

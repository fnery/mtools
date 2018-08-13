function out = isnifti(in, throwError)
% isnifti.m: lazy nifti file path checker
%
% Syntax:
%    1) out = isnifti(in)
%    1) out = isnifti(in, throwError)
%
% Description:
%    1) out = isnifti(in) lazily checks whether the filepath given in 'in'
%       corresponds to a nifti file.
%    2) out = isnifti(in, throwError) throws an error if 'in' is not NIfTI
%       and 'throwError' is true.
%
% Inputs:
%    1) in: string (file path OR name+extension)
%    2) throwError (optional): logical scalar. Default: false.
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
%    isnifti('file.nii.gz2', true)
%    % OUTPUT
%    %    ans = 1
%    %    ans = 1
%    %    ans = 0
%    %    ans =
%    %        Error using isnifti (line 54)
%    %        'file.nii.gz2' is not a NIfTI file.
%    %        The file extension needs to be one of:
%    %        .nii
%    %        .nii.gz
%
% fnery, 20171103: original version
% fnery, 20180813: added throwError option

EXPECTED_FILE_EXTS = {'.nii', '.nii.gz'};

if nargin == 1
    throwError = false;
end

out = isext(in, EXPECTED_FILE_EXTS);

if throwError && not(out)
    error(['''%s'' is not a NIfTI file.\n', ...
        'The file extension needs to be one of:\n%s'], in, ...
        cell2str(EXPECTED_FILE_EXTS, true));
end

end
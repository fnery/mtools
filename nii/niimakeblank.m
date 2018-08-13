function out = niimakeblank(in, out)
% niimakeblank.m: create NIfTI image of zeros using existing NIfTI image
%
% Syntax:
%    1) out = niimakeblank(in, out)
%
% Description:
%    1) [out = niimakeblank(in, out) creates a NIfTI image of zeros using
%       an existing NIfTI image. 
%
% Inputs:
%    1) in: full path to existing NIfTI image
%    2) out: base path / name for output NIfTI image
%
% Outputs:
%    1) out: full path of output NIfTI image
%    2) outputn: description
%
% Notes/Assumptions: 
%    1) This is useful to create a blank image where later intensities
%       from other images are replaced into
%
% References:
%    [1] https://uk.mathworks.com/matlabcentral/fileexchange/8797
%
% Required functions:
%    1) exist2.m
%    2) isnifti.m
%    3) fileparts2.m
%    4) outinit.m
%    5) load_untouch_nii.m [1]
%    6) save_untouch_nii.m [1]
%
% Required files:
%    None in addition to 'in'
%
% Examples:
%    []
%
% fnery, 20180813: original version

% Check 'in' exists and has the correct extension
exist2(in, 'file', true);
isnifti(in, true);

% Get extension of 'in' which will be used in 'out'
[~, ~, ext] = fileparts2(in);

% Manage output path
out = outinit('in', out, ...
    'usename', true  , ...
    'useext' , false , ... % out inherits the extension of 'in' (next line)
    'nodir'  , 'make', ...
    'silent' , false);
out = sprintf('%s%s', out, ext);

% Replace by zeros
Nii = load_untouch_nii(in);
Nii.img = zeros(size(Nii.img), class(Nii.img));

% Save new nii file
save_untouch_nii(Nii, out);

end
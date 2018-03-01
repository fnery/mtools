function out = niiloadim(niiPath, oriS, oriF)
% niiloadim.m: load NIfTI image volume and fix orientation
%
% Syntax:
%    1) out = niiloadim(niiPath, oriS, oriF)
%    2) out = niiloadim(niiPath)
%
% Description:
%    1) out = niiloadim(niiPath, oriS, oriF) loads the input NIfTI image in
%       'niiPath' (using load_untouch_nii.m from [1]) and "fixes" its 
%       orientation according to the orientation descriptors given by 'oriS'
%       and 'oriF' using volori.m. See volori.m for how to define 'oriS' 
%       and 'oriF'.
%    2) out = niiloadim(niiPath) does the same as 1), but for simplicity
%       assumes previously hardcoded defaults for 'oriS' and 'oriF' (use of
%       these defaults is discouraged as they 'oriS' and 'oriF' are highly
%       application-dependent. 
%
% Inputs:
%    1) niiPath: path to one NIfTI file
%    2) oriS: start orientation descriptor (cell of strings) - see volori.m
%    3) oriF: final orientation descriptor (cell of strings) - see volori.m
%
% Outputs:
%    1) out: image matrix contained in 'niiPath'
%
% Notes/Assumptions: 
%    1) Requires an external toolbox: 
%       "Tools for NIfTI and ANALYZE image" by Jimmy Shen (available at [1])
%    2) Additional notes if necessary
%
% References:
%    [1] mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
%
% Required functions:
%    1) load_untouch_nii.m (available in [1])
%    2) volori.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180301: original version

DEFAULT_ORI_S = {'+L', '-I', '+P'};
DEFAULT_ORI_F = {'+I', '+L', '+P'};

if nargin == 1
    oriS = DEFAULT_ORI_S;
    oriF = DEFAULT_ORI_F;
end

out = load_untouch_nii(niiPath); % requires toolbox in [1]
out = double(out.img);
out = volori(out, oriS, oriF);
    
end
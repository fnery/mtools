function Dwi = dwiinn(in, doChecks)
% dwiinn.m: dwiin.m wrapper (for 'n' inputs)
%
% Syntax:
%    1) Dwi = dwiinn(in, doChecks)
%
% Description:
%    1) Dwi = dwiinn(in, doChecks) is a quick wrapper for allowing multiple
%       inputs (cell of strings of paths or structs of length > 1) to be
%       fed to dwiin.m.
%
% Inputs:
%    1) in: cell of strings OR struct of length > 1
%    2) doChecks (optional): logical scalar (passed directly to dwiin.m)
%
% Outputs:
%    1) Dwi: struct of length 'n' with structure identical to the output of
%       dwiin.m
%
% Notes/Assumptions:
%    1) Not optimized. No error checks (except those in dwiin.m of course)
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
%
% Required functions:
%    1) dwiin.m
%
% Required files:
%    1) NIfTI dwi files + corresponding .bvals and .bvecs (FSL format [1])
%
% Examples:
%    in{1} = 'C:\imaginary_path\imaginary_file_01.nii.gz';
%    in{2} = 'C:\imaginary_path\imaginary_file_02.nii.gz';
%    Dwi = dwiinn(in, false)
%        >> Dwi =
%        >>   1×2 struct array with fields:
%        >>     im
%        >>     bval
%        >>     bvec
%    Dwi(1)
%        >> ans =
%        >>   struct with fields:
%        >>       im: 'C:\imaginary_path\imaginary_file_01.nii.gz'
%        >>     bval: 'C:\imaginary_path\imaginary_file_01.bval'
%        >>     bvec: 'C:\imaginary_path\imaginary_file_01.bvec'
%    Dwi(2)
%        >> ans =
%        >>   struct with fields:
%        >>       im: 'C:\imaginary_path\imaginary_file_02.nii.gz'
%        >>     bval: 'C:\imaginary_path\imaginary_file_02.bval'
%        >>     bvec: 'C:\imaginary_path\imaginary_file_02.bvec'
%    % Easy to put things in a cell after this, e.g.:
%    {Dwi(:).bval}'
%        >> ans =
%        >>   2×1 cell array
%        >>     {'C:\imaginary_path\imaginary_file_01.bval'}
%        >>     {'C:\imaginary_path\imaginary_file_02.bval'}
%
% fnery, 20180813: original version

inIsStruct = isstruct(in);
inIsCell   = iscell(in);

nIn = length(in);

for iIn = nIn:-1:1 % backwards pre-allocation

    if inIsStruct
        cIn = in(iIn);
    elseif inIsCell
        cIn = in{iIn};
    else
        error('''in'' must be cell or struct');
    end

    Dwi(iIn) = dwiin(cIn, doChecks);
end

end
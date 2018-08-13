function Dwi = dwiin(in, doChecks)
% dwiin.m: dwi input parser
%
% Syntax:
%    1) Dwi = dwiin(in, doChecks)
%
% Description:
%    1) Dwi = dwiin(in, doChecks) is an argument parser for functions that
%       accept a path to a dwi image file (NIfTI) and optionally the path
%       to its corresponding .bval and .bvec files. The goal is to use this
%       function within other functions (parent functions) to minimise the
%       number of input arguments the parent function needs.
%       Here's a practical example where this function would be used.
%       Say I want to create a function named 'fx' which requires 1) a path
%       to a LTE DWI NIfTI file, 2) a path to its .bval file, 3) a path
%       to its .bvec file AND then the same for a STE DWI NIfTI file.
%       I could do:
%       >> fx(imLte, imSte)
%       and assume the .bvals and .bvecs have the same name as the image
%       files. But I do not want to assume this as in the future I may want
%       to modify the names of one of the files (e.g. if I rotate .bvec)
%       In this case I'd need to specify all 6 input arguments, like this:
%       >> fx(imLte, bvalLte, bvecLte, imSte, bvalSte, bvecSte)
%       It is bad practice to have such a large number of input arguments.
%       This function (dwiin.m), when used inside 'fx' allows both
%       >> fx(imLte, imSte)
%       making the same file name assumption as above, but also allows
%       >> fx(ImLte, ImSte)
%       where both ImLte and ImSte are structs with with fields
%           |---- im  : path to dwi image file (NIfTI)
%           |---- bval: path to corresponding .bval file
%           |---- bvec: path to corresponding .bvec file
%       allowing specific names for the .bvals / .bvecs to be used while
%       keeping the list of input arguments short
%
% Inputs:
%    1) in: can be
%           - struct with fields
%                 |---- im  : path to dwi image file (NIfTI)
%                 |---- bval: path to corresponding .bval file
%                 |---- bvec: path to corresponding .bvec file
%           - char (fullpath to dwi image file (NIfTI))
%    2) doChecks (optional): logical scalar that determines whether several
%       checks are performed to ensure the existence of all files and the
%       validity of the .bval/.bvec pair which will be saved in the output
%       ('Dwi'). Default = true.
%
% Outputs:
%    1) Dwi struct organised as follows:
%       Dwi
%       |---- im  : path to dwi image file (NIfTI)
%       |---- bval: path to corresponding .bval file
%       |---- bvec: path to corresponding .bvec file
%
% Notes/Assumptions:
%    1) In the case of 'in' being a struct with valid fields (which in turn
%       point to valid paths), the output ('Dwi') is the same as the input
%       Example 3) below shows this
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki
%
% Required functions:
%    1) cell2str.m
%    2) fileparts2.m
%    3) bvalbvecpath.m
%    4) exist2.m
%    5) bvalbveccheck.m
%
% Required files:
%    1) NIfTI dwi file + corresponding .bval and .bvec (in FSL format [1])
%
% Examples:
%    % USING A STRING INPUT
%    % --------------------
%
%    % Initialise a path to a non-existent '.nii.gz' file
%    in = 'C:\Users\fabio\Desktop\example_file.nii.gz';
%
%    % Example 1) run dwiin.m without error checks
%    Dwi = dwiin(in, false)
%    Dwi =
%      struct with fields:
%          im: 'C:\Users\fabio\Desktop\example_file.nii.gz'
%        bval: 'C:\Users\fabio\Desktop\example_file.bval'
%        bvec: 'C:\Users\fabio\Desktop\example_file.bvec'
%
%    % Example 2) run dwiin.m with error checks
%    Dwi = dwiin(in, true)
%    Error using exist2 (line 67)
%    Error: file 'C:\Users\fabio\Desktop\example_file.nii.gz' doesn't exist
%
%    % USING A STRUCT INPUT
%    % --------------------
%
%    % Initialise struct corresponding to non-existent '.nii.gz' file
%    In.im = 'C:\Users\fabio\Desktop\example_file.nii.gz';
%    In.bval = 'C:\Users\fabio\Desktop\example_file.bval';
%    In.bvec = 'C:\Users\fabio\Desktop\example_file.bvec';
%
%    % Example 3) run dwiin.m without error checks
%    Dwi = dwiin(In, false)
%    Dwi =
%      struct with fields:
%          im: 'C:\Users\fabio\Desktop\example_file.nii.gz'
%        bval: 'C:\Users\fabio\Desktop\example_file.bval'
%        bvec: 'C:\Users\fabio\Desktop\example_file.bvec'
%
%    % Example 4) run dwiin.m with error checks
%    Dwi = dwiin(In, true)
%    Error using exist2 (line 67)
%    Error: file 'C:\Users\fabio\Desktop\example_file.nii.gz' doesn't exist
%
% fnery, 20180813: original version

EXTS.IM = {'.nii', '.nii.gz'};
EXTS.BVAL = '.bval';
EXTS.BVEC = '.bvec';
ALLOWED_FIELDS = {'im', 'bval', 'bvec'};

if nargin == 1
    doChecks = true;
end

if isstruct(in)

    % Check struct fields are valid
    nAllowedFields = length(ALLOWED_FIELDS);
    fieldCheck = ismember(fieldnames(in), ALLOWED_FIELDS);
    fieldsAreValid = all(fieldCheck) && (sum(fieldCheck)==nAllowedFields);
    if ~fieldsAreValid
        error('''in'' has invalid fields. Allowed fields are:\n%s', ...
            cell2str(ALLOWED_FIELDS, true));
    end

    % Initialise variables for each field to check their validity
    % Note: im's validity checked further below (so that the code for this
    % only needs to be written once (regardless of struct or char input))
    % Note 2: .bval and .bvec's validity needs to be checked here, because
    % when the input is a char, .bval and .bvec will be valid by default
    % since they are generated based in 'im' by bvalbvecpath.m
    im = in.im;
    bval = in.bval;
    bvec = in.bvec;

    % Check .bval/.bvec paths are valid
    % Note this does not check for file existence (this is done below if
    % 'doChecks' is true)
    [bvalDir, ~, bvalExt] = fileparts2(bval);
    bvalExtIsValid = strcmp(bvalExt, EXTS.BVAL);
    if ~bvalExtIsValid || isempty(bvalDir)
        error('''Dwi.bval'' must be a full path to a ''.bval'' file');
    end
    [bvecDir, ~, bvecExt] = fileparts2(bvec);
    bvecExtIsValid = strcmp(bvecExt, EXTS.BVEC);
    if ~bvecExtIsValid || isempty(bvecDir)
        error('''Dwi.bvec'' must be a full path to a ''.bvec'' file');
    end

elseif ischar(in)

    im = in;
    [bval, bvec] = bvalbvecpath(im);

else
    error('''in'' must be either a string or a struct');
end

% Check im's path is valid
[imDir, ~, imExt] = fileparts2(im);
imExtIsValid = ismember(imExt, EXTS.IM);
if ~imExtIsValid || isempty(imDir)
    error(['''in'' must provide a fullpath to an image file with one', ...
    ' of the following extensions:\n%s'], cell2str(EXTS.IM, true));
end

% Optional checks
if doChecks
    exist2(im, 'file', true);
    bvalbveccheck(bval, bvec);
end

% Create output struct
Dwi.im   = im;
Dwi.bval = bval;
Dwi.bvec = bvec;

end
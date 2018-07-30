function Paths = dtifitnm(ins, masks, baseName, bVal, bVec)
% dtifitnm.m: dtifit and [n] merge [m]
%
% Syntax:
%    1) dtifitnm(ins, masks, baseName)
%    2) dtifitnm(ins, masks, baseName, bVal, bVec)
%
% Description:
%    1) dtifitnm(ins, masks, baseName) takes "n" 4D NIfTI DTI files whose
%       paths are given in <ins>, does a dtifit.m on each of them in the
%       regions (voxels) given by their corresponding masks in <masks>
%       and then merges all results into a single 4D NIfTI file (as it 
%       all masks as non-overlapping). This function wraps around dtifit.m
%       so it inherits its features/assumptions
%       - uses compulsory argins only
%       - automatic .bval/.bvec path initialisation
%       - enhanced baseName management using outinit.m
%       - automatic conversion of Windows paths to WSL
%    2) dtifitnm(ins, masks, baseName, bVal, bVec) allows the user to
%       specify paths to the .bval/.bvec files "manually" (see dtifit.m)
%
% Inputs:
%    1) ins: cell of strings with fullpaths to 4D NIfTI DTI files
%    2) masks: cell of strings with fullpaths to 3D NIfTI mask files
%    3) baseName: base filepath or filename for dtifit outputs
%    4) bVal (optional): cell of strings with fullpaths to .bval files
%    5) bVec (optional): cell of strings with fullpaths to .bvec files
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    1) Same assumptions as dtifit.m so requires FSL (available in [1])
%    2) Assumes all masks are non-overlapping
%    3) This was created to run dtifit.m on the left and right kidney,
%       which have been motion corrected separately (and therefore exist in
%       separate NIfTI files**) and then automatically returs just a single
%       NIfTI file for each of the fit outputs containing both the left and
%       right kidneys (i.e. they are merged into a single file again for
%       ease of visualisation)
%       ** I could have merged the output of the separate motion correction
%       of the left and right kidney into a single file before fitting****
%       but I couldn't find compelling enough reasons to do so
%       **** I would still need to run separate dtifit.m calls for the left
%       and right kidneys if the .bvecs had been rotated to account for
%       transformations during image registration
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/
%
% Required functions:
%    1) is1d.m
%    2) mkdirtmp.m
%    3) dtifit.m
%    4) dtifit from FSL [1]
%    5) niimaskrepn.m
%
% Required files:
%    DTI 4D NIfTI images, associated .bval/.bvec files and NIFTI 3D masks
%
% Examples:
%    []
%
% fnery, 20180730: original version

% Error checks
if ~iscell(masks) || ~is1d(masks)
    error('Error: ''masks'' must be a 1D cell of strings with paths to 3D NIfTI mask files');
else
    nMasks = length(masks);
end

if ~iscell(ins) || ~is1d(ins)
    error('Error: ''ins'' must be a 1D cell of strings with paths to 4D NIfTI DTI files');
else
    nIns = length(ins);
end

if nIns ~= nMasks
    error('Error: the number of paths in ''ins'' and in ''masks'' must be the same');
else
    n = nIns;
end

if nargin == 3
    bValBVecProvided = false;
elseif nargin == 5
    bValBVecProvided = true;
else
    error('Error: this function requires either 3 or 5 input arguments');
end

tmpDir = mkdirtmp; % temporary directory to store intermediate results

for i = 1:n
    % Initialise basename for intermediate files
    % (i.e. results of dtifit.m, which then have to be merged)
    cBaseNamePreffix = sprintf('tmp%04d', i);
    cBaseName = fullfile(tmpDir, cBaseNamePreffix);   
    
    % Init paths to inputs for dtifit.m for current iteration
    cIn   = ins{i};
    cMask = masks{i};
    
    if bValBVecProvided
        % .bval/.bvec files specified by user: do error checks in dtifit.m
        cBVal = bVal{i};
        cBVec = bVec{i};
        cPaths = dtifit(cIn, cMask, cBaseName, cBVal, cBVec);
    else
        % .bval/.bvec files not specified: init paths in dtifit.m
        cPaths = dtifit(cIn, cMask, cBaseName);
    end
    
    % Create a struct containing paths to all intermediate results (maps 
    % from dtifit) in a format which will facilitate calling niimaskrepn.m
    cMaps = fieldnames(cPaths);
    cNMaps = length(cMaps);
    for ciMap = 1:cNMaps
        Paths.(cMaps{ciMap}){i} = cPaths.(cMaps{ciMap});
    end
    
end

% Merge results from different masks
% Results from masks 2:n are replaced into the results from mask 1
% Assumes masks are non-overlapping
maps = fieldnames(Paths);
nMaps = length(maps);

for iMap = 1:nMaps
    cMap = maps{iMap};
    cFrom = Paths.(cMap)(2:end);
    cInto = Paths.(cMap){1};
    cMask = masks(2:end);
    cOut = [baseName '_' cMap];
    Paths.(cMap) = niimaskrepn(cFrom, cInto, cMask, cOut);
end

end
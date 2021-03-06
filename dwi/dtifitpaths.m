function [Paths, MAPS] = dtifitpaths(basePath)
% dtifitpaths.m: init paths to dtifit outputs
%
% Syntax:
%    1) [Paths, MAPS] = dtifitpaths(basePath)
%
% Description:
%    1) [Paths, MAPS] = dtifitpaths(basePath) initialises a struct with the
%       full paths to dtifit outputs based from the base path specified in
%       the dtifit run that generated them
%
% Inputs:
%    1) basePath: base path used in the dtifit run that generated the files
%       whose paths are to be initialised
%
% Outputs:
%    1) Paths: struct with paths to NIfTI maps generated by dtifit
%    2) MAPS: file name suffixes of the NIfTI maps generated by dtifit
%
% Notes/Assumptions: 
%    1) Assumes all outputs of dtifit.m (i.e. FSL's dtifit [1]) are .nii.gz
%    2) Also checks the files exist after initialising their path
%
% References:
%    [1] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/
%
% Required functions:
%    1) fileparts2.m
%    2) exist2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180730: original version

MAPS = {'FA', 'L1', 'L2', 'L3', 'MD', 'MO', 'S0', 'V1', 'V2', 'V3'};
EXT  = '.nii.gz';

[d, n, e] = fileparts2(basePath);

if ~isempty(e)
    error('Error: ''basePath'' can''t contain file extensions');
end

for iMap = 1:length(MAPS)
    
    % Init path to file corresponding to current dtifit output map
    cMap = MAPS{iMap};    
    cMapPath = fullfile(d, [n '_' cMap EXT]);       
    Paths.(cMap) = cMapPath;
    
    % Check file given by cMapPath exists
    exist2(cMapPath, 'file', true);
    
end
    
end
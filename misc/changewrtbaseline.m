function [res, idxs] = changewrtbaseline(varargin)
% changewrtbaseline.m: change in measurements with respect to a "baseline"
%   
% Syntax:
%    1) [res, idxs] = changewrtbaseline('in', in, 'base', base, 'type', type)
%
% Description:
%    1) [res, idxs] = changewrtbaseline('in', in, 'base', base, 'type', type) 
%       takes a 2D matrix of measurements [subjects x measurements] and 
%       computes the change in the measurements with respect to a
%       subject-specific "base", which can be:
%       - the first measurement
%       - the measurement which yielded the maximum value
%       It outputs the "change" ("normalised") matrix and the indexes of 
%       the base measurement for each subject
%
% Inputs:
%    ----------------------------- MANDATORY ------------------------------
%    <in>     numeric    :  2D matrix [subjects x measurements]
%    ------------------------------ OPTIONAL ------------------------------
%    <base>   char       :  baseline measurement:
%                           - 'first': first measurement is baseline
%                           - 'max': largest measurement is baseline
%    <type>   char       :  method used to compute <in>
%                           - 'ratio': simple division by baseline
%                           - 'prc': percentage w.r.t. baseline
% 
% Outputs:
%    1) res (numeric): 2D "change" matrix [subjects x measurements]
%    2) idxs (numeric): indexes of baseline measurements [subjects x 1]
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    codewhichisreadytorun
%    >> command line result (if applicable)
%
% fnery, 20170327: original version

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'in'}
            % verify if 'in' is valid
            isNumeric = isnumeric(cVal);
            hasCorrectDims = ismatrix(in);
            if isNumeric && hasCorrectDims
                in = cVal;
            else
                error('Error: ''in'' must be 2D [subjects x measurements]')
            end
        case {'base'}
            % verify if 'base' is valid
            if ischar(cVal)
                base = cVal;
            else
                error('Error: ''base'' must be a string')
            end
        case {'type'}
            % verify if 'type' is valid
            if ischar(cVal)
                type = cVal;
            else
                error('Error: ''type'' must be a string')
            end           
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = ...
    exist('in', 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Defaults
if ~exist('base', 'var'); base = 'first'; end
if ~exist('type', 'var'); type = 'ratio'; end

nS = size(in, 1);

% Get value of baseline measurements
if strcmp(base, 'first')
    baseVals = in(:, 1);
    idxs = ones(nS, 1);
elseif strcmp(base, 'max')
    [baseVals, idxs] = max(in, [], 2);
end

% Compute change
if strcmp(type, 'ratio')
    res = in ./ baseVals;
elseif strcmp(type, 'prc')
    res = (in - baseVals) ./ baseVals;
end

end
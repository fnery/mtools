function bvalbvecinfo(bval, bvec)
% bvalbvecinfo.m: get scan parameters from bval and bvec files
%
% Syntax:
%    1) bvalbvecinfo(bval, bvec)
%
% Description:
%    1) bvalbvecinfo(bval, bvec) takes one bval and corresponding bvec
%       files and computes scanning parameters that were used to generate
%       these files, specifically:
%       - unique b-values used
%       - number of directions per unique b-value
%       - number of averages per unique b-value
%
% Inputs:
%    1) bval: bvals (either path to bval file or vector with bvals)
%    1) bvec: bvals (either path to bvec file or matrix with bvecs)
%
% Outputs:
%    [] (text printed to command window)
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) strpad.m
%
% Required files:
%    1) bval file from one given scan
%    2) bvec file from the corresponding scan of 1)
%
% Examples:
%    % Create bval and bvec data for an hypothetical dataset with
%    % - b-values: 0, 200 and 400
%    % - 3 directions at non-zero b-values
%    % - 4 averages at b=0; 1 average at b=200 and 2 averages at b=400
%    bval = [0 0 0 0 200 200 200 400 400 400 400 400 400];
%    bvec = [0 0 0 0 1   0   0   1   0   0   1   0   0; ...
%            0 0 0 0 0   1   0   0   1   0   0   1   0; ...
%            0 0 0 0 0   0   1   0   0   1   0   0   1];
%    % Get info string on this hypothetical dataset    
%    bvalbvecinfo(bval, bvec)
%        >> bval (#01/03) = 0    | nBvecs = 1  | nAvgs = 4 
%        >> bval (#02/03) = 200  | nBvecs = 3  | nAvgs = 1 
%        >> bval (#03/03) = 400  | nBvecs = 3  | nAvgs = 2 
%    % The output essentially summarises the contents of bval and bvec, and
%    % the info we get when running bvalbvecinfo.m matches what we expected
%    % from the definition of this hypothetical dataset
%
% fnery, 20180124: original version
% fnery, 20180125: now also prints info in a way suitable for copy/pasting in a single line

%#ok<*AGROW>

MAXLEN_BVAL   = 4;
MAXLEN_NBVECS = 2;
MAXLEN_NAVGS  = 2;

% if inputs are paths to bval and bvec files, load them
if ischar(bval)
    bval = load(bval);
end

if ischar(bvec)
    bvec = load(bvec);
end

[a, b] = size(bval);
[c, d] = size(bvec);

% Some error checks
if ~isequal(b, d)
    error('Error: ''bval'' and ''bvec'' must have the same number of columns');
end

if a ~= 1
    error('Error: ''bval'' must have 1 row');
end

if c ~= 3
    error('Error: ''bvec'' must have 3 rows');
end

% Get unique bvals and count how many there are
bvalsUnique = unique(bval);
nUniqueBVals = length(bvalsUnique);

% Compute number of directions and averages at each unique bval
for iUniqueBVals = 1:nUniqueBVals
    
    cUniqueBVal = bvalsUnique(iUniqueBVals);
    
    % Compute indexes of bvecs at this bval
    cIdxs = bval == cUniqueBVal;
    
    % Get actual bvecs at this bval
    cBvecs = bvec(:, cIdxs);
    
    % Compute number of unique bvecs at this bval
    cNUniqueBvecs = size(unique(cBvecs.', 'rows').', 2);
    
    % Compute number of averages for this bval
    cNAvgs = size(cBvecs, 2) / cNUniqueBvecs;
    
    uniqueBvals(iUniqueBVals)  = cUniqueBVal; 
    nUniqueBVecs(iUniqueBVals) = cNUniqueBvecs;
    nAvgs(iUniqueBVals)        = cNAvgs;
    
    % Compute sub-strings for info text
    cUniqueBVal   = strpad(num2str(cUniqueBVal)  , MAXLEN_BVAL);
    cNUniqueBvecs = strpad(num2str(cNUniqueBvecs), MAXLEN_NBVECS);
    cNAvgs        = strpad(num2str(cNAvgs)       , MAXLEN_NAVGS);
    
    % Print info to command window
    fprintf('bval (#%02d/%02d) = %s | nBvecs = %s | nAvgs = %s\n', ...
        iUniqueBVals, nUniqueBVals, cUniqueBVal, cNUniqueBvecs, cNAvgs);
end

% Print an additional string which is basically the same as the above
% "table" but suitable for copy/pasting in a single line
uniqueBvalsStr  = vec2str(uniqueBvals, '%d');
nUniqueBVecsStr = vec2str(nUniqueBVecs, '%d');
nAvgsStr        = vec2str(nAvgs, '%d');

fprintf('(bvals/nBvecs/nAvgs = %s/%s/%s)\n', ...
    uniqueBvalsStr, nUniqueBVecsStr, nAvgsStr);

end
function [bvals, bvecs, idxs] = bvalbvecparse(bval, bvec)
% bvalbvecparse.m: parse a dwi dataset using the bval and bvec files
%
% Syntax:
%    1) [bvals, bvecs, idxs] = bvalbvecparse(bval, bvec) parses a dwi
%       dataset using the bval and bvec files
%
% Description:
%    1) [bvals, bvecs, idxs] = bvalbvecparse(bval, bvec) parses a dwi
%       dataset using the bval and bvec files. 
%       The main goal with this function is grouping the indexes of
%       dwi volumes acquired with identical scanning parameters (in this
%       context same b-value and b-vector). This grouping is given by the 
%       'idxs' parameter. 
%
% Inputs:
%    1) bval: bvals (either path to bval file or vector with bvals)
%    1) bvec: bvals (either path to bvec file or matrix with bvecs)
%
% Outputs:
%    1) bvals: unique b-values in this dataset
%    2) bvecs: unique b-vectors for each b-value
%    3) idxs: grouped indexes of volumes with same b-value and b-vector
%
% Notes/Assumptions: 
%    1) Assumption 1: Indexes will correspond to a 4D dataset [x,y,z,volume]
%       where each volume has been acquired with any bval or bvec (i.e.
%       the typical approach when converting dwi data to a 4D-NIfTI - by 
%       the way this conversion is what is supposed to generated the input
%       data to this function
%    2) The main goal in mind when this was created was to simplify the
%       retrospective averaging of dwi data, but will probably be useful in
%       a number of other circumstances
%
% References:
%    []
%
% Required functions:
%    1) uniquecols.m
%
% Required files:
%    1) bval file from one given scan
%    2) bvec file from the corresponding scan of 1)
%
% See also:
%    1) bvalbvecsummary.m (used to be called bvalbvecinfo.m)
%
% Example:
%
%    ---------------------------
%               CODE
%    ---------------------------
%    % Create bval and bvec data for an hypothetical dataset with
%    % - b-values: 0, 200 and 400
%    % - 3 directions at non-zero b-values
%    % - 4 averages at b=0; 1 average at b=200 and 2 averages at b=400
%    bval = [0 0 0 0 200 200 200 400 400 400 400 400 400];
%    bvec = [0 0 0 0 1   0   0   1   0   0   1   0   0; ...
%            0 0 0 0 0   1   0   0   1   0   0   1   0; ...
%            0 0 0 0 0   0   1   0   0   1   0   0   1];
%    % Parse this hypothetical dataset    
%    [bvals, bvecs, idxs] = bvalbvecparse(bval, bvec);
%
%    ---------------------------
%      ANALYSIS OF THE OUTPUTS
%    ---------------------------
%
%    First let's look at bvals
%    >> bvals
%    bvals =
%         0   200   400
%    Easy, these are the unique bvals.     
%    
%    Now let's look at bvecs
%    >> bvecs
%    bvecs =
%      1×3 cell array
%        {3×1 double}    {3×3 double}    {3×3 double}
%    We see three cells containing the bvecs (one cell per bval)
%    Going into the cells shows us the actual bvecs:
%        >> bvecs{1}
%        ans =
%             0
%             0
%             0
%        >> bvecs{2}
%        ans =
%             1     0     0
%             0     1     0
%             0     0     1 
%        >> bvecs{3}
%        ans =
%             1     0     0
%             0     1     0
%             0     0     1    
%    
%    Now, idxs:
%    idxs =
%      1×3 cell array
%        {1×1 cell}    {1×3 cell}    {1×3 cell}     
%    Again, one cell per b-value
%    Going in:
%        >> idxs{1}
%        ans =
%          1×1 cell array
%            {1×4 double}
%    Now we see that the first cell has 4 values
%            >> idxs{1}{:}
%            ans =
%                 1     2     3     4
%    These are the indexes of the volumes at the first bval, and they are
%    in a single vector because all volumes at this bval have the same bvec.
%    The second bval has volumes with different b-vecs, so we should see 
%    something different...
%        >> idxs{2}
%        ans =
%          1×3 cell array
%            {[5]}    {[6]}    {[7]}
%    Here, at the second bval we see that we go into another cell. That is, 
%    we don't immediately see a vector with volume indexes. For this we
%    need to go in again.
%            >> idxs{2}{:}
%            ans =
%                 5
%            ans =
%                 6
%            ans =
%                 7     
%    This happens because at this b-value there are different b-vectors  
%    (unlike the first bval (which is zero)). Therefore, for this function
%    to be general enough when we go into a given bval with more than one 
%    bvec we save the indexes of each bvec in its own cell. This allows this
%    function to work with datasets where different bvecs of the same bval 
%    have different numbers of averages (i.e. measurements). This is highly
%    unlikely but may be useful.             
%    Let's check the final bval (400):
%        >> idxs{3}
%        ans =
%          1×3 cell array
%            {1×2 double}    {1×2 double}    {1×2 double}
%    The fact that each variable within the cell is a vector and not a
%    scalar is already telling us that there are different b-vectors, each
%    with more than one volume (unlike the b-value of 200 which had a 
%    single average).
%    Let's see:
%            >> idxs{3}{:}
%            ans =
%                 8    11
%            ans =
%                 9    12
%            ans =
%                10    13
%    Right, as expected we see that each b-vector at this b-value had more
%    than one volume, therefore more than one index unlike the previous bval.     
%
% fnery, 20180125: original version

%#ok<*AGROW> optimise later

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
    cIdxs = find(bval == cUniqueBVal);
    
    % Get actual bvecs at this bval
    cBvecs = bvec(:, cIdxs);
    
    [cUniqueBvecs, cUniqueBvecsIdx] = uniquecols(cBvecs);
    
    for iUniqueBVecs = 1:length(cUniqueBvecsIdx)
        cUniqueBvecsTotalIdx = cIdxs(cUniqueBvecsIdx{iUniqueBVecs});
        idxs{iUniqueBVals}{iUniqueBVecs} = cUniqueBvecsTotalIdx;
    end
    
    bvecs{iUniqueBVals} = cUniqueBvecs; 
    
end

bvals = bvalsUnique;

end
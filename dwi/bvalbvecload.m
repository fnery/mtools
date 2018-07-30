function [bval, bvec] = bvalbvecload(bval, bvec)
% bvalbvecload.m: load one pair of bval and bvec files
%
% Syntax:
%    1) [bval, bvec] = bvalbvecload(bval, bvec)
%
% Description:
%    1) [bval, bvec] = bvalbvecload(bval, bvec) does the following:
%       a) takes full paths of one pair of bval and bvec files
%       b) loads them
%       c) checks that:
%           1) paths are valid
%           2) structure of the files is valid
%           3) files likely correspond to the same dataset, i.e. have
%              - same number of volumes
%
% Inputs:
%    1) bval: string full path to .bval file
%    2) bvec: string full path to .bvec file
%
% Outputs:
%    1) bval: vector of b-values
%    2) bvec: matrix of b-vectors
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
%    1) bval file from one given scan
%    2) bvec file from the corresponding scan of 1)
%
% Examples:
%    []
%
% fnery, 20180126: original version
% fnery, 20180730: no longer assumes .bval/.bvec files have same file name
%                  (rotated bvec files may have different file names than
%                  their corresponding .bval files)

BVAL_EXT = '.bval';
BVEC_EXT = '.bvec';

% bval input path validity checks
% -------------------------------

% bval
if ~ischar(bval)   
    error('Error: input ''bval'' must be string (full path to .bval file)') 
else
    [~, ~, bvalExt] = fileparts(bval);
    % check correct extension of bval file
    if ~strcmp(bvalExt, BVAL_EXT)
        error('Error: input ''bval'' must have .bval extension')
    end    
end

% bvec
if ~ischar(bvec)
    error('Error: input ''bvec'' must be string (fullpath to .bvec file)') 
else
    [~, ~, bvecExt] = fileparts(bvec); 
    % check correct extension of bvec file
    if ~strcmp(bvecExt, BVEC_EXT)
        error('Error: input ''bvec'' must have .bvec extension')
    end
end


% load bval/bvec files
% --------------------

bval = load(bval);
bvec = load(bvec);

[a, b] = size(bval);
[c, d] = size(bvec);


% bval/bvec contents validity checks
% ----------------------------------

% 1) must have same number of volumes if they belong to the same image data
if ~isequal(b, d)
    error('Error: ''bval'' and ''bvec'' must have same number of columns');
end

% 2) bval is made of scalars and bvec of column vectors with 3 rows
if a ~= 1
    error('Error: ''bval'' must have 1 row');
end
if c ~= 3
    error('Error: ''bvec'' must have 3 rows');
end

end
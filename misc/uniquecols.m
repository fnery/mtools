function [uniqueCols, uniqueIdxs] = uniquecols(in)
% uniquecols.m: find unique columns in 2D matrix and their row indexes
%
% Syntax:
%    1) [uniqueCols, uniqueIdxs] = uniquecols(in)
%
% Description:
%    1) [uniqueCols, uniqueIdxs] = uniquecols(in) finds unique columns in
%       2D matrix and their row indexes (grouping them)
%
% Inputs:
%    1) in: 2D matrix
%
% Outputs:
%    1) uniqueCols: unique columns found in 'in'
%    2) uniqueIdxs: grouped indexes of all occurences of unique columns
%
% Notes/Assumptions: 
%    1) Created to find indexes of repeated bvecs
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
%    in = [1 1 5 5 5 0; ...
%          1 1 5 5 5 0]
%    [uniqueCols, uniqueIdxs] = uniquecols(in)
%        >> in =
%        >>      1     1     5     5     5     0
%        >>      1     1     5     5     5     0
%        >> uniqueCols =
%        >>      1     5     0
%        >>      1     5     0
%        >> uniqueIdxs =
%        >>   1×3 cell array
%        >>     {1×2 double}    {1×3 double}    {[6]}
%
% fnery, 20180125: original version

%#ok<*AGROW>

[~, nCols] = size(in);

% Auxiliary variable to keep track which columns we have checked
check = NaN(1, nCols);

% Initialise counter
ct1 = 1; 
ct2 = 0; 

while any(isnan(check))
    
    % initialise first instance of one unique column
    cReference = in(:, ct1);
    
    if isnan(check(ct1))   
        
        ct2 = ct2 + 1;
        
        % find indexes of columns in 'in' which are equal to cReference
        cUniqueIdxs = find(~any(bsxfun(@minus, in, cReference))); 

        % Update auxiliary variable (tell it which columns we've checked)
        check(cUniqueIdxs) = true; 
        
        % save unique columns we have found
        uniqueCols(:, ct2) = cReference;
        
        % save grouped indexes of all occurences the current unique column
        % for example: uniqueIdxs{2} will show the indexes of all columns
        % that we found that are equal to uniqueCols(:, 2)
        uniqueIdxs{ct2} = cUniqueIdxs;
        
    end
    
    % Update counter
    ct1 = ct1 + 1;
    
end

end
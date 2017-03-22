function [output] = reparrew(array, replicationCounts)
% reparrew.m: replicate array (element-wise)
%   
% Syntax:
%    1) [output] = reparrew(array, replicationCounts)
%
% Description:
%    1) [output] = reparrew(array, replicationCounts) replicates
%       each element of array a number of times given by replicationCounts
%
% Inputs:
%    1) array: array whose elements will be replicated
%    2) replicationCounts: array which determines how many times each
%       element from 'array' will be replicated
%
% Outputs:
%    1) output: resulting array
%
% Notes/Assumptions: 
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
% 
% Examples:
%    array             = [3 1 9 4];
%    replicationCounts = [2 3 1 5];
%    reparrew(array, replicationCounts)
%    >> ans =  3   3   1   1   1   9   4   4   4   4   4
%
% fnery, 20130319: original version
% fnery, 20150815: updated documentation
% fnery, 20160226: replicationCounts now accepts zeros

% Ensure replicationCounts can accept zeros (ignores these indexes)
zIdxs = find(replicationCounts == 0);
if ~isempty(zIdxs)
    array(zIdxs) = [];
    replicationCounts(zIdxs) = [];
end

aux = zeros(1,sum(replicationCounts));
aux(cumsum([1 replicationCounts(1:end-1)])) = 1;
aux = cumsum(aux);
output = array(aux);

end
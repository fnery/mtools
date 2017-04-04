function [out] = folderinpath(fullPath)
% folderinpath.m: extracts folder from a full file path
%   
% Syntax:
%    1) [out] = folderinpath(fullPath)
%
% Description:
%    1) [out] = folderinpath(fullPath) extracts folder from a full file path
%
% Inputs:
%    1) fullPath: full path of a file
%
% Outputs:
%    1) out: string corresponding to the isolated folder of the file
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
% See also:
%    1) fileinpath.m
%
% fnery, 20160212: original version

[~, tmp] = strtok(fliplr(fullPath), filesep);
out = fliplr(tmp);

end
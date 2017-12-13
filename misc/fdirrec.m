function List = fdirrec(in)
% fdirrec.m: list sub-directories and files within them ([rec]ursive fdir.m)
%
% Syntax:
%    1) List = fdirrec(in)
%
% Description:
%    1) List = fdirrec(in) calls fdir.m recursively with default options to 
%       list all sub-directories of 'in' and files within them
%
% Inputs:
%    1) in: parent directory to search
%
% Outputs:
%    1) List: struct with attributes about sub-directories / files in 'in'
%
% Notes/Assumptions: 
%    1) When I have time I can merge fdirrec.m and fdir.m in a single function
%
% References:
%    []
%
% Required functions:
%    1) fdir.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20171213: original version

List = fdir('in', in, 'silent', true);

if isempty(List);
    return;
end

ListDirs = List;
ListDirs(~[List.isdir]) = [];

for iDir = 1:length(ListDirs)
    cDir = ListDirs(iDir).fullpath;
    
    List = [List; fdirrec(cDir)]; %#ok<AGROW>
    
end

end
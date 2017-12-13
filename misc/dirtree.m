function dirtree(in)
% dirtree.m: displays directory tree in the command line
%
% Syntax:
%    1) dirtree
%    2) dirtree(in)
%
% Description:
%    1) dirtree displays directory tree in the command line, starting at the
%       current working directory
%    2) dirtree(in) does the same as 1) but allows to start the search in an
%       arbitrary directory 'in'
%
% Inputs:
%    1) in: parent directory to search
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) fdir.m
%    2) nameinpath.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20171213: original version

if nargin == 0;
    in = pwd;
end

% Get directories in current directory
List = fdir('in', in, 'silent', true, 'ignorefiles', true);

if isempty(List);
    return;
end

ListDirs = List;
ListDirs(~[List.isdir]) = [];

for iDir = 1:length(ListDirs)
    cDir = ListDirs(iDir).fullpath;
    
    % Check how deep are we in the folder tree
    St = dbstack;
    cLevel = sum(cellfun(@(c) strcmp(c, mfilename), {St.name}))-1;
    
    % Print current position
    fprintf('%s%s\n', repmat(' | ', [1 cLevel]), nameinpath(cDir));
    
    % Recursion
    dirtree(cDir);
end

end
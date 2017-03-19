function [Out] = sortstruct(In, fieldIdx, order)
% sortstruct.m: sorts struct according to one of its fields
%   
% Syntax:
%    1) [Out] = sortstruct(In, fieldIdx)
%    2) [Out] = sortstruct(In, fieldIdx, order)
%
% Description:
%    1) [Out] = sortstruct(In, fieldIdx) sorts struct according to one of
%       its fields (ascending order by default).
%    2) [Out] = sortstruct(In, fieldIdx, order) same as 1) but the 'order'
%       input argument allows to control whether the sorting is ascending
%       or descending
%
% Inputs:
%    1) In (struct): input struct
%    2) fieldIdx (int): index of struct field according to which data is sorted
%    3) order (char)
%       - 'ascending' (default) 
%       - 'descending'
% 
% Outputs:
%    1) Out (struct): sorted struct
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
%    Original(1).name   = 'jose';
%    Original(1).age    = 15;
%    Original(1).height = 185;
%    Original(2).name   = 'antonio';
%    Original(2).age    = 30;
%    Original(2).height = 170;
%    Original(3).name   = 'Maria';
%    Original(3).age    = 23;
%    Original(3).height = 150;
%    SortedByName = sortstruct(Original, 1);
%    SortedByAge = sortstruct(Original, 2);
%    SortedByHeight = sortstruct(Original, 3);
%    {Original.name}
%    {SortedByName.name}
%    {SortedByAge.name}
%    {SortedByHeight.name}
%    >> ans = 
%    >>    'jose'    'antonio'    'Maria'
%    >> ans = 
%    >>    'antonio'    'jose'    'Maria'
%    >> ans = 
%    >>    'jose'    'Maria'    'antonio'
%    >> ans = 
%    >>    'Maria'    'antonio'    'jose'
%
% fnery, 20130327: original version
% fnery, 20150814: added documentation
% fnery, 20160415: now sorts string fields in case-insensive way

% Define default order
if nargin == 2
    order = 'ascending'; 
end

% Prepare original struct to use matlab's sortrows function
inputStructFields = fieldnames(In);                              
inputStructCell   = struct2cell(In);                             
sz                = size(inputStructCell);                                
inputStructCell   = reshape(inputStructCell, sz(1), []); % convert to a matrix
inputStructCell   = inputStructCell'; % make each field a column

tmp = inputStructCell;

% If we are sorting strings, we need to be careful, because matlab's sort
% is case-sensitive with uppercase letters appearing in the output before 
% the lowercase letters.
% Therefore, before sorting fields with strings, we need to convert all the
% strings to lower or uppercase
sortingStrings = all(cellfun(@ischar, inputStructCell(:, fieldIdx)));
if sortingStrings
    tmp(:, fieldIdx) = cellfun(@lower, ...
        tmp(:, fieldIdx), 'UniformOutput', false);
end

% sort by the 'fieldIdx'th field
if strcmp(order, 'ascending')
    [~, newOrder] = sortrows(tmp, fieldIdx);
elseif strcmp(order, 'descending')
    [~, newOrder] = sortrows(tmp, -fieldIdx);
else
    error('Error: ''order'' should either be ''ascending'' or ''descending''.');
end

inputStructCell = inputStructCell(newOrder,:);

% Return to original struct format, now sorted
inputStructCell = reshape(inputStructCell', sz);
In  = cell2struct(inputStructCell, inputStructFields, 1);   
Out = In;

end
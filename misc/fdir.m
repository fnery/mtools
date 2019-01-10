function [List, n] = fdir(varargin)
% fdir.m: custom dir function
%   
% Syntax:
%    1) [List, n] = fdir('opt1', val1, 'opt2', val2)
%
% Description:
%    1) fdir is a custom dir function with the following characteristics:
%        - can ignore directories or files using flag input arguments
%        - sorts according to name, date modified or filesize
%        - sorts strings (e.g. names) in case-insensitive way
%        - displays results as table in the command window
%        - returns the usual List struct but after sorting and/or
%          file/directory rejection
%        - unlike dir.m includes the file extension and its full path in
%          the output struct directly
%     
% Inputs/Options (order irrelevant):
%   ------------------------------ OPTIONAL -------------------------------
%    <in>           string: directory to search (see example 5 for wildcards)
%                       [default = pwd]
%    <sortmethod>   string: sort according to file characteristics
%                       can be:
%                       - 'name'
%                       - 'date'
%                       - 'filesize' or 'sz'
%                       [default = 'name']
%    <sortorder>    string
%                       can be:
%                       - 'ascending'
%                       - 'descending'
%                       [default = 'ascending']
%    <ignoredirs>   logical: only shows files
%    <ignorefiles>  logical: only shows dirs
%    <silent>       logical: determines whether to print contents to cmd line
%                       [default = false]
%
% Outputs:
%   1) List: struct with attributes about files in <in>
%
% Notes/Assumptions: 
%   []
%
% References:
%   []
%
% Required functions:
%   1) fileparts2.m
%   2) sortstruct.m
%
% Required files:
%   []
% 
% Examples:
%   1) Display table with contents of current directory
%      >> fdir;
%   2) Same as 1) ignoring dirs
%      >> fdir('ignoredirs', true);
%   3) Same as 1) but sorting by date modified (descending order)
%      >> fdir('sortMethod', 'date', 'sortOrder', 'descending' );
%   4) Same as 3) but don't print table and return sorted List struct
%      >> List = fdir('sortMethod', 'date', 'sortOrder', 'descending', 'silent', true);
%   5) Using wildcards to only retrieve .nii.gz files
%      >> List = fdir('in', '<directory_with_files>/*.nii.gz')
%
% fnery, 20160415: original version
% fnery, 20170309: now size in KBytes
%                  now struct includes 'ext' and 'fullpath' fields
%                  'ext' now a column in the optional output table
% fnery, 20170922: now calls fileparts2.m instead of filepartscell.m
% fnery, 20180420: now supports wildcards as used in original dir function
% fnery, 20180510: bugfix

BYTES_TO_KBYTES = 0.001;

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
            isString = ischar(cVal);
            hasCorrectDims = (size(cVal, 1) == 1 || size(cVal, 2) > 1);
            if isString && hasCorrectDims
                in = cVal;
            else
                error('Error: Option ''in'' must be a path string')
            end
        case {'sortmethod'}
            % verify if 'sortmethod' is valid
            if ~ischar(cVal)
                error('Error: Option ''sortmethod'' must be a string')
            end
            if strcmpi(cVal, 'name')
                orderingFieldNumber = 1;
            elseif strcmpi(cVal, 'date')  
                orderingFieldNumber = 3;
            elseif strcmpi(cVal, 'filesize') || strcmpi(cVal, 'sz')
                orderingFieldNumber = 4;
            else
                error('Error: Option ''sortmethod'' is invalid');
            end
        case {'sortorder'}
            % verify if 'sortorder' is valid
            if ~ischar(cVal)
                error('Error: Option ''sortorder'' must be a string')
            end
            if strcmpi(cVal, 'ascending')
                sortOrder = cVal;
            elseif strcmpi(cVal, 'descending')
                sortOrder = cVal;
            else
                error('Error: Option ''sortorder'' is invalid');
            end            
        case {'ignoredirs'}
            % verify if 'ignoredirs' is valid
            if ~islogical(cVal)
                error('Error: Option ''ignoredirs'' must be logical')
            else
                ignoreDirs = cVal;
            end
        case {'ignorefiles'}
            % verify if 'ignorefiles' is valid
            if ~islogical(cVal)
                error('Error: Option ''ignorefiles'' must be logical')
            else
                ignoreFiles = cVal;
            end
        case {'silent'}
            % verify if 'silent' is valid
            if ~islogical(cVal)
                error('Error: Option ''silent'' must be logical')
            else
                silent = cVal;
            end
        otherwise
            error('Error: input argument not recognized');
    end
end

% Defaults
if ~exist('in', 'var')
    in = pwd;
end
if ~exist('orderingFieldNumber', 'var')
    orderingFieldNumber = 1; % default is sort by name
end
if ~exist('sortOrder', 'var')
    sortOrder = 'ascending';
end
if ~exist('ignoreDirs', 'var')
    ignoreDirs = false;
end
if ~exist('ignoreFiles', 'var')
    ignoreFiles = false;
end
if ~exist('silent', 'var')
    silent = false;
end

% Other error checks
if ignoreDirs && ignoreFiles
    error('Error: ''ignoredirs'' and ''ignorefiles'' can''t be both true');
end

List = dir(in);  
% remove "." and ".."
thisDir = find(cellfun(@(S) strcmp('.',S), {List.name}'));
prevDir = find(cellfun(@(S) strcmp('..',S), {List.name}'));
List([thisDir prevDir]) = [];

% Remove wildcard from 'in' if it exists
if ~isdir(in) % the use of a wildcard makes 'in' not being a directory
    [in, ~, ~] = fileparts2(in);
end

if isempty(List)
    if ~silent
        fprintf('''%s'' is empty\n', in);
    end
    List = [];
    n = 0;
    return;
end

if ignoreDirs
    List([List.isdir]) = []; % remove dirs
elseif ignoreFiles
    List(~[List.isdir]) = []; % remove files
end

% Add file extensions to List struct and remove them from List.name
nFiles = length(List);
[~, names, exts] = fileparts2({List.name});
for iFile = 1:nFiles
    List(iFile).ext = exts{iFile};
    List(iFile).name = names{iFile};
    
    if isdir(in)    
        List(iFile).fullpath = fullfile(in, [names{iFile} exts{iFile}]);
    else
        List(iFile).fullpath = in;
    end
    
end

% Sort according to orderingFieldNumber and sortOrder
List = sortstruct(List, orderingFieldNumber, sortOrder);

% Display nice table in command line
if ~silent
    name = {List.name}';
    ext = {List.ext}';
    modificationDate = {List.date}';
    sizeBytes = {List.bytes}';
    sizeKBytes = cellfun(@(x) x.*BYTES_TO_KBYTES, sizeBytes, 'UniformOutput', false);
    isdirFlag = {List.isdir}';
    varNames = {'Name' 'Ext' 'ModificationDate' 'SizeKBytes' 'isdir'};
    t = horzcat(name, ext, modificationDate, sizeKBytes, isdirFlag);
    t = cell2table(t, 'VariableNames', varNames);
    fprintf('\n    ''%s'' contains:\n\n', in)
    disp(t);
end

% Save 'n', which can be nFiles or nDirs, depending on options
n = length(List);

end
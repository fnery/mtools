function out = dropboxfix(in)
% dropboxfix.m: ensure dropbox substring in preloaded paths matches current machine
%
% Syntax:
%    1) out = dropboxfix(in)
%
% Description:
%    1) out = dropboxfix(in) ensures that the dropbox substring in a pre-loaded
%       path (e.g. the substring "C:\Dropbox" from the path "C:\Dropbox\hello")
%       maches the current machine, modifying the preloaded path if needed
%       Example, say I created the following file with matlab in my Ubuntu desktop:
%       - "/home/fnery/Dropbox/file.ext"
%       And save its path in a .mat file for later loading the file.
%       If I later try to load this file in another machine (my Windows laptop,
%       for example) the actual file path will be:
%       - "C:\Users\fabio\Dropbox\file.ext"
%       So this function takes the original path and modifies so it becomes the
%       actual file path so that it can be loaded.
%       Multiple files can be provided at the same time making 'in' a cell of
%       paths (column or row cell only)    
%
% Inputs:
%    1) in: string or cell of strings with multiple paths
%
% Outputs:
%    1) out: string or cell of strings with multiple paths
%
% Notes/Assumptions: 
%    1) Assumption 1: the input char contains only one path (i.e. is
%       always of size [1 x nChars]. To input more than one path
%       use a cell of strings as input
%    2) Assumption 2: the input cell is always a vector or column cell
%
% References:
%    []
%
% Required functions:
%    1) dropbox.m
%    2) pathfix.m (lives in this file)
%    3) filesepfix.m
%
% Required files:
%    []
%
% Examples:
%    % Example 1: input is string
%        in1 = '/home/fnery/Dropbox/file.ext'
%        out1 = dropboxfix(in1)
%    % Example 2: input is cell of strings
%        in2{1} = '/home/fnery/Dropbox/file1.ext';
%        in2{2} = '/home/fnery/Dropbox/file2.ext';
%        in2 = in2'
%        out = dropboxfix(in2)
%    
%    % OUTPUT
%    %     in1 =
%    %         /home/fnery/Dropbox/file.ext
%    %     out1 =
%    %         C:\Users\fabio\Dropbox\file.ext
%    %     in2 = 
%    %         '/home/fnery/Dropbox/file1.ext'
%    %         '/home/fnery/Dropbox/file2.ext'
%    %     out = 
%    %         'C:\Users\fabio\Dropbox\file1.ext'
%    %         'C:\Users\fabio\Dropbox\file2.ext'
%
% fnery, 20171102: original version

% Suppress irrelevant warnings
%#ok<*AGROW>: no need to pre-allocate stuff

% Possible dropbox paths
POSSIBLE_DROPBOX_PATHS{1} = '/home/fnery/Dropbox';
POSSIBLE_DROPBOX_PATHS{2} = 'C:\Users\fabio\Dropbox';

nPossDropPaths = length(POSSIBLE_DROPBOX_PATHS);

currentDropboxPath = dropbox;

% =====================================================================
% ===== Get index of currentDropboxPath in POSSIBLE_DROPBOX_PATHS ===== ---
% =====================================================================

for iPossDropPath = 1:nPossDropPaths
    cPossDropPath = POSSIBLE_DROPBOX_PATHS{iPossDropPath};
    cIsMatch(iPossDropPath) = ~isempty(strfind(currentDropboxPath, cPossDropPath));
end

nMatches = sum(cIsMatch);
if nMatches == 0
    error('Error: current dropbox path does not match any POSSIBLE_DROPBOX_PATHS');
elseif nMatches == 1
    currentDropboxIdx = find(cIsMatch);
else
    error('Error: current dropbox path can not match more than one of POSSIBLE_DROPBOX_PATHS');
end
clear cIsMatch;


% ========================================================================
% ===== Ensure paths match current machine, modifying them if needed ===== 
% ========================================================================

if ischar(in)
    % Assumption 1: the input char contains only one path
    % (i.e. is always of size [1 x nChars]
    % To input more than one path use a cell as input
    
    out = pathfix(in, POSSIBLE_DROPBOX_PATHS, currentDropboxIdx);
    
elseif iscell(in)
    % Assumption 2: the input cell is always a vector or column cell   
    nPaths = length(in);
    
    for iPath = 1:nPaths
        cPath = in{iPath};       
        out{iPath} = pathfix(cPath, POSSIBLE_DROPBOX_PATHS, currentDropboxIdx);
    end
    
    % Reshape output so that it has the same dimensions of 'in'
    out = reshape(out, size(in));

end

end

function out = pathfix(in, POSSIBLE_DROPBOX_PATHS, currentDropboxIdx)
% pathfix.m: main algorithm of dropboxfix.m
%
% Syntax:
%    out = pathfix(in, POSSIBLE_DROPBOX_PATHS, currentDropboxIdx)
%
% Description:
%    out = pathfix(in, POSSIBLE_DROPBOX_PATHS, currentDropboxIdx) contains the
%    main algorithm of dropboxfix.m wrapped in a function because its used in 
%    two cases (string or cell inputs)
%
% Required functions:
%    1) filesepfix.m
%
% fnery, 20171102: original version

if ~ischar(in);
    error('Error: ''in'' must be a single path string')
end

nPossDropPaths = length(POSSIBLE_DROPBOX_PATHS);

for iPossDropPath = 1:nPossDropPaths
    cPossDropPath = POSSIBLE_DROPBOX_PATHS{iPossDropPath};
    cIsMatch(iPossDropPath) = ~isempty(strfind(in, cPossDropPath)); 
end

% Check if input file path matches any of the POSSIBLE_DROPBOX_PATHS
nMatches = sum(cIsMatch);
if nMatches == 0
    error('Error: one or more input paths do not match any POSSIBLE_DROPBOX_PATHS');
elseif nMatches == 1
    currentFileIdx = find(cIsMatch);
else
    error('Error: input paths can not match more than one of POSSIBLE_DROPBOX_PATHS');
end

% Check if input file path matches the dropbox path of the current machine
% If not, update dropbox-related substring + ensure fileseps match current OS
if ~isequal(currentFileIdx, currentDropboxIdx);
    substringToBeReplaced = POSSIBLE_DROPBOX_PATHS{currentFileIdx};
    newSubstring = POSSIBLE_DROPBOX_PATHS{currentDropboxIdx};
    out = strrep(in, substringToBeReplaced, newSubstring);
    out = filesepfix(out);
else
    % do nothing, input file has dropbox path matching the current machine
end

end
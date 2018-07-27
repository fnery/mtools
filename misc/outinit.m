function out = outinit(varargin)
% outinit: output path default initialisation
%
% Syntax:
%    1) out = outinit('in',in,'nodir',noDir,'silent',silent)
%    2) out = outinit('in',in,'useext',useExt,'nodir',noDir,'silent',silent)
%
% Description:
%    1) out = outinit('in',in,'useext',useExt,'nodir',noDir,'silent',silent)
%       generates an output path from an input file path OR file name
%       for a function which will generate other files
%       Case 1: If 'in': valid file-to-be path (i.e. full path), this
%           function does nothing (i.e. out = in) as EXAMPLE 1 shows
%       Case 2: If 'in': filename (i.e. no directory specified), this
%           function appends pwd to 'in' to make it a valid file path,
%           as EXAMPLE 2 shows below
%       With this first syntax, ''out'' will have the same extension as
%       ''in'' (or no extension if ''in'' doesn't have one)
%       If 'in' specifies a directory which does not exist, this function
%       will behave according to the choice of 'nodir' (see inputs below)
%    2) out = outinit('in',in,'useext',useExt,'nodir',noDir,'silent',silent)
%           provides further control on whether specifying the file extension
%           in 'in' is allowed (and subsequently used outside this function),
%           regardless of Case 1 or Case 2 and 'nodir' behaviour
%           Example where we would want to specify a file extension:
%               in = 'image.nii.gz' ---> out = '<pwd>\image.nii.gz'
%           Example where we would NOT want to specify a file extension:
%               in = 'image' ---> out = '<pwd>\image'
%               Using this 'out' we then could generate several files,
%               where the only difference between them is their extension,
%               such as when creating .bval and bvec .files.
%
% Inputs:
%    -------------------------------- MANDATORY -------------------------------
%    <in>      char     :  filepath OR filename $1
%    --------------------------------- OPTIONAL -------------------------------
%    <useext>  logical  :  scalar, control on whether specifying the file
%                          extension in 'in' is allowed
%    <nodir>   char     :  Tag describing the behaviour of this function
%                          if directory in <in> doesn't exist. Options are:
%                              - 'empty' --> returns empty out
%                              - 'error' --> exits with error
%                              - 'make'  --> creates directory in <in>
%                          [default]: 'error'
%    <silent>  logical  :  scalar, specifies if helpful text printed in cmd
%                          [default]: 'false'
%    --------------------------------------------------------------------------
%
% Outputs:
%    1) out: filepath (with/without extension depending whether 'useext' is
%       provided and if so on its value)
%
% Notes/Assumptions:
%    1) This was created to manage input arguments for other functions as
%       the strategy implemented here is used very frequently so worth
%       wrapping it into a single function
%
% References:
%    []
%
% Required functions:
%    1) fileparts2.m
%    2) exist2.m
%
% Required files:
%    []
%
% Examples:
%    % EXAMPLE 1: other existing directory
%    in     = 'C:\Users\fabio\Desktop\hello.txt';
%    useExt = true;
%    noDir  = 'error';
%    silent = false;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> out = 'C:\Users\fabio\Desktop\hello.txt'
%
%    % EXAMPLE 2: pwd (assuming we're in 'C:\Users\fabio')
%    in     = 'hello.txt';
%    useExt = true;
%    noDir  = 'error';
%    silent = false;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> out = 'C:\Users\fabio\hello.txt'
%
%    % EXAMPLE 3: other non-existing directory (return empty)
%    in     = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt';
%    useExt = true;
%    noDir  = 'empty';
%    silent = false;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> out = []
%
%    % EXAMPLE 4: other non-existing directory (throw error)
%    in     = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt';
%    useExt = true;
%    noDir  = 'error';
%    silent = false;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> Error using exist2 (line 67)
%    % >> Error: dir 'C:\Users\fabio\Desktop\non_existent_dir' doesn't exist
%
%    % EXAMPLE 5: other non-existing directory (make it) (not silent)
%    in     = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt';
%    useExt = true;
%    noDir  = 'make';
%    silent = false;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> Created directory: C:\Users\fabio\Desktop\non_existent_dir
%    % >> out = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt'
%
%    % EXAMPLE 6: other non-existing directory (make it) (silent)
%    in     = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt';
%    useExt = true;
%    noDir  = 'make';
%    silent = true;
%    out = outinit('in', in, 'useext', useExt, 'nodir', noDir, 'silent', silent)
%    % >> out = 'C:\Users\fabio\Desktop\non_existent_dir\hello.txt'
%
% fnery, 20180603: original version
% fnery, 20180605: outinit.m new option: extRequired
% fnery, 20180605: modified extension managing approach
% fnery, 20180726: made useExt optional as in some cases I don't want this
%                  function to do anything regarding extensions, i.e. just
%                  make 'out' have the same extension if 'in' even it if
%                  means no extension at all
% fnery, 20180727: added 'nodir' and 'silent' argins'
%                  modified function to value-pair argin format'
%                  updated documentation'

POSSIBLE_NODIRS = {'empty', 'error', 'make'};

% ==================================
% ===== Manage input arguments ===== --------------------------------------
% ==================================

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
            if ischar(cVal)
                in = cVal;
            else
                error('Error: ''in'' must be string (filepath OR filename)');
            end
        case {'useext'}
            if islogical(cVal) && isscalar(cVal)
                useExt = cVal;
            else
                error('Error: ''useext'' must be a logical scalar');
            end
        case {'nodir'}
            noDirIsValid = ~isempty(find(strcmp(cVal, POSSIBLE_NODIRS), 1));
            if noDirIsValid
                noDir = cVal;
            else
                noDirOpts = sprintf('''%s'', ', POSSIBLE_NODIRS{:});
                noDirOpts(end-1:end) = [];
                error('Error: ''nodir'' must be string (one of the following: %s)', noDirOpts);
            end
        case {'silent'}
            if islogical(cVal) && isscalar(cVal)
                silent = cVal;
            else
                error('Error: ''silent'' must be a logical scalar');
            end
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('in', 'var');
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which optional arguments exist
useExtExists = exist('useExt', 'var');
noDirExists  = exist('noDir' , 'var');
silentExists = exist('silent', 'var');

% By default, the function is not silent
if ~useExtExists
    useExtProvided = false;
else
    useExtProvided = true;
end
if ~noDirExists
    noDir = 'error';
end
if ~silentExists
    silent = false;
end

[d, n, e] = fileparts2(in);

% Manage directory
if isempty(d)
    % if no directory is provided, out will be in pwd
    d = pwd;
else
    if strcmp(noDir, 'error')
        % check for existence of specified directory, throw error if not
        exist2(d, 'dir', true);
    elseif strcmp(noDir, 'empty')
        dirExists = exist2(d, 'dir', false);
        if ~dirExists
            out = [];
            return;
        end
    elseif strcmp(noDir, 'make')
        dirExists = exist2(d, 'dir', false);
        if ~dirExists
            d = mkdirf('fullpath', d, 'silent', silent);
        end
    end
end

% Manage name
if isempty(n)
    error('Error: need to specify the name of ''%s''', in);
end

% Manage extension
if useExtProvided
    if isempty(e) && useExt
        error('Error: need to specify the extension in ''%s''', in);
    elseif ~isempty(e) && ~useExt
        error('Error: specifying the extension in ''%s'' is not allowed', in);
    end
end

out = fullfile(d, [n e]);

end
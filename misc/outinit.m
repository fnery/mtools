function out = outinit(in, useExt)
% outinit: output path default initialisation
%
% Syntax:
%    1) out = outinit(in)
%    1) out = outinit(in, useExt)
%
% Description:
%    1) out = outinit(in) manages input file paths OR file names.
%       Case 1: If 'in': valid file-to-be path (i.e. full path $1), this 
%           function does nothing (i.e. out = in), as Example 1) shows
%       Case 2: If 'in': filename $1 (i.e. no directory specified), this 
%           function appends pwd to 'in' to make it a valid file path $1,
%           as Example 3) shows below
%       With this first syntax, ''out'' will have the same extension as 
%       ''in'' (or no extension if ''in'' doesn't have one)
%    2) out = outinit(in, useExt) provides further control on whether 
%           specifying the file extension in 'in' is allowed (and 
%           subsequently used outside this function), regardless of Case 1
%           or Case 2.
%           Example where we would want to specify a file extension:
%               in = 'image.nii.gz' ---> out = '<pwd>\image.nii.gz'
%           Example where we would NOT want to specify a file extension:
%               in = 'image' ---> out = '<pwd>\image'
%               Using this 'out' we then could generate several files, 
%               where the only difference between them is their extension, 
%               such as when creating .bval and bvec .files.
%
% Inputs:
%    1) in: filepath OR filename (with/without extension depending on 'useExt')
%    2) useExt (optional): logical scalar
%
% Outputs:
%    1) out: filepath (with/without extension depending whether 'useExt' is
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
%    % For all the examples that follow, say that the current directory
%    % (i.e. pwd) is 'C:\Users\fabio' and useExt is true
%
%    % Example 1) Creating a file path in another (valid) directory
%        in = 'C:\Users\fabio\Desktop\hello.txt';
%        out = outinit(in, true)
%        out =
%             'C:\Users\fabio\Desktop\hello.txt'
%
%    % Example 2) Creating a file path in another directory (invalid) directory
%        in = 'C:\Users\fabio\fake_directory\hello.txt';
%        out = outinit(in, true)
%        Error: dir 'C:\Users\fabio\fake_directory' doesn't exist
%
%    % Example 3) Creating a file path in the current directory
%        in = 'hello.txt';
%        out = outinit(in, true)
%        out =
%            'C:\Users\fabio\hello.txt'
%
% fnery, 20180603: original version
% fnery, 20180605: outinit.m new option: extRequired
% fnery, 20180605: modified extension managing approach
% fnery, 20180726: made useExt optional as in some cases I don't want this
%                  function to do anything regarding extensions, i.e. just
%                  make 'out' have the same extension if 'in' even it if
%                  means no extension at all

if nargin < 1 || nargin > 2 
    error('Error: outinit.m expects 1 or 2 input arguments');
elseif nargin == 1
    useExtProvided = false;
elseif nargin == 2
    useExtProvided = true;
else
    error('Error: this point should never be reached');
end

[d, n, e] = fileparts2(in);

% Manage directory
if isempty(d)
    % if no directory is provided, out will be in pwd
    d = pwd;
else
    % check for existence of specified directory, throw error if not
    exist2(d, 'dir', true);
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
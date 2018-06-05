function out = outinit(in, extRequired)
% outinit: output path default initialisation
%
% Syntax:
%    1) out = outinit(in)
%    2) out = outinit(in, extRequired)
%
% Description:
%    1) out = outinit(in) manages input file paths OR file names.
%       If ''in'' is a valid file-to-be path (i.e. fullpath and specifying
%       an existing directory), this function does nothing (i.e. out = in),
%       as Example 1) shows (see below)
%       If ''in'' is just a file name + extension, this function appends
%       the pwd to ''in'' to make it a valid file path, as Example 3) shows
%       below
%    2) out = outinit(in, extRequired) does the same as 1) but allows to
%       control whether 'in' requires the extension of out to be specified.
%       This is the case in most cases. However, an example of where we do
%       not want to include the extension in out is when generating one
%       path (i.e. 'out') which will be common to several files (to be 
%       created later and outside of this function) where the only 
%       difference between the files is their extension, such as when
%       creating .bval and bvec .files
%
% Inputs:
%    1) in: (full file path) or (file name + extension)
%    2) extRequired (optional): logical scalar. Default = true;
%
% Outputs:
%    1) out: filepath (with or without extension depending on extRequired)
%
% Notes/Assumptions:
%    1) This function was created to manage input arguments for other
%       functions as the strategy implemented here is used very frequently,
%       so I don't want to replicate it any time I need it
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
%    % (i.e. pwd) is 'C:\Users\fabio'
%
%    % Example 1) Creating a file path in another (valid) directory
%        in = 'C:\Users\fabio\Desktop\hello.txt';
%        out = outinit(in)
%        out =
%             'C:\Users\fabio\Desktop\hello.txt'
%
%    % Example 2) Creating a file path in another directory (invalid) directory
%        in = 'C:\Users\fabio\fake_directory\hello.txt';
%        out = outinit(in)
%        Error: dir 'C:\Users\fabio\fake_directory' doesn't exist
%
%    % Example 3) Creating a file path in the current directory
%        in = 'hello.txt';
%        out = outinit(in)
%        out =
%            'C:\Users\fabio\hello.txt'
%
% fnery, 20180603: original version
% fnery, 20180605: outinit.m new option: extRequired

if nargin == 1
    extRequired = true;
elseif nargin == 2 && (~isscalar(extRequired) || ~islogical(extRequired))
    error('Error: ''extRequired'' must be a logical scalar');
end

[d, n, e] = fileparts2(in);

if isempty(d)
    % if no directory is provided, out will be in pwd
    d = pwd;
else
    % check for existence of specified directory, throw error if not
    exist2(d, 'dir', true);
end

if isempty(n)
    error('Error: need to specify the name of ''out''');
end

if isempty(e) && extRequired
    error('Error: need to specify the extension of ''out''');
end

out = fullfile(d, [n e]);

end
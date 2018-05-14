function out = targz(files, out)
% targz.m: convert list of files into .tar.gz archive
%
% Syntax:
%    1) out = targz(files, out)
%
% Description:
%    1) out = targz(files, out) takes the files in 'files' and compresses
%       them into a single .tar.gz archive
%
% Inputs:
%    1) files: cell of strings with fullpaths to input files to .tar.gz
%    2) out: string which specifies directory (optional) and filename 
%       (mandatory) for output file. See examples below.
%
% Outputs:
%    1) out: fullpath to output .tar.gz file
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    1) fileparts2.m
%
% Required files:
%    whatever input files whose files are given in 'files'
%
% Examples:
%    % Below are all valid ways to use targz.m
%    % Specifying directory and extension
%    out = targz(files, 'C:\Users\fabio\Desktop\output_targz_file.tar.gz')
%    % Specifying directory and not extension
%    out = targz(files, 'C:\Users\fabio\Desktop\output_targz_file')
%    % Specifying filename and extension
%    out = targz(files, 'output_targz_file.tar.gz')
%    % Specifying filename only
%    out = targz(files, 'output_targz_file')
%
% fnery, 20180514: original version

TAR_EXT =  '.tar';
TARGZ_EXT = '.tar.gz';

[dir, name, ext] = fileparts2(out);

% Input checks
if isempty(dir)
    dir = pwd;
elseif ~isdir(dir)
    error('Error: ''%s'' does not exist', out);
end

if isempty(name)
    error('Error: file name not specified');
end

if ~isempty(ext) && ~strcmp(ext, TARGZ_EXT)
    %#ok<*SPERR> have to use sprintf unlike matlab is suggesting...
    error(sprintf(... 
    ['Error: ''out'' is not specifying the correct file extension.\n', ...
     'Either do not specify an extension or if you do, it has to be ''.tar.gz''']))
elseif isempty(ext)
    ext = TARGZ_EXT;
end

% Tar input files
intermediateOut = fullfile(dir, [name TAR_EXT]);
tar(intermediateOut, files);

% Gzip resulting .tar file
gzip(intermediateOut);

% Delete intermediate .tar file
delete(intermediateOut);

% Build output file name for function output
out = fullfile(dir, [name ext]);

end
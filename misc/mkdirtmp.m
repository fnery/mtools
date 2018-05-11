function path = mkdirtmp
% mkdirtmp.m: make directory in Temp files
%
% Syntax:
%    1) path = mkdirtmp
%
% Description:
%    1) path = mkdirtmp creates a directory in Temp files
%
% Inputs:
%    []
%
% Outputs:
%    1) path: full path to resulting Temp directory
%
% Notes/Assumptions: 
%    []
%
% References:
%    [1] https://github.com/markus-nilsson/md-dmri/blob/7351da5a6eea208b41e7609ad7a13b677a3ed709/msf/msf_tmp_path.m
%
% Required functions:
%    []
%
% Required files:
%    []
%
% Examples:
%   []
%
% fnery, 20180511: original version, inspired by [1]

path = fullfile(tempdir, char(java.util.UUID.randomUUID));
status = mkdir(path);
if status ~= 1
    error('Error creating ''%s''', oDir);
end

end
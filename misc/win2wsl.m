function out = win2wsl(path)
% win2wsl.m: convert Windows path to its Windows Subsystem for Linux (WSL) equivalent
%
% Syntax:
%    1) out = win2wsl(path)
%    
% Description:
%    1) out = win2wsl(path) converts a path on the Windows file system to its
%       equivalent path on the Windows Subsystem for Linux (WSL) file system
%
% Inputs:
%    1) path: absolute file/directory path
%
% Outputs:
%    1) out: WSL-compatible path
%
% Notes/Assumptions: 
%    1) Say I'm working on a computer with a Windows OS but want to run 
%       linux programs on the Windows Subsystem for Linux (WSL). Furthermore
%       that we load a given file path from within MATLAB which is installed
%       on the original Windows OS (e.g. using fullfile.m+pwd.m). The file 
%       path may look like: 
%           - 'C:\Users\fnery\file.example'
%       If we want to provide this file path as an input to a WSL program, 
%       we need to convert it, following the given example, to:
%           - '/mnt/c/Users/fnery/file.example'
%       This function automates this task.
%    2) See several assumptions in the functions that this function calls
%
% References:
%    []
%
% Required functions:
%    1) driveinpath.m
%    2) filesepfix.m
%    3) ensuredrive.m
%
% Required files:
%    []
%
% Examples:
%    in = 'C:\Users\fnery\file.example'
%    out = win2wsl2(in)
%    >> in =
%    >> C:\Users\fnery\file.example
%    >> out =
%    >> /mnt/c/Users/fnery/file.example
%    
% fnery, 20171218: original version
% fnery, 20171220: added option for pre-loaded standard C: drive substrings
% fnery, 20180221: major changes: now automatically detects and converts drive substrings

% Extract drive from input string
drive = driveinpath(path);

% Get original string without drive substring
pathWithoutDrive = strrep(path, drive, '');
pathWithoutDrive = filesepfix(pathWithoutDrive, 'UNIX');

% Convert drive to WSL format
driveNew = ensuredrive(drive, 'WSL');

% Build new fullpath
out = [driveNew pathWithoutDrive];

end
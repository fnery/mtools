function out = win2wsl(path, winSubStr, wslSubStr)
% win2wsl.m: convert Windows path to its Windows Subsystem for Linux (WSL) equivalent
%
% Syntax:
%    1) out = win2wsl(path, winSubStr, wslSubStr)
%    
% Description:
%    1) out = win2wsl(path, winSubStr, wslSubStr) converts a path on the 
%       Windows file system to its equivalent path on the Windows Subsystem
%       for Linux (WSL) file system
%
% Inputs:
%    1) path: original file OR directory path 
%    2) winSubStr: drive substring on the windows file system (e.g. 'C:')
%    3) wslSubStr: drive substring on the WSL file system (e.g. '/mnt/c')
%
% Outputs:
%    1) out: WSL-converted path
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
%
% References:
%    []
%
% Required functions:
%    1) filesepfix.m
%
% Required files:
%    []
%
% Examples:
%    % 1)
%    path = 'C:\Users\fnery\file.example'
%    winSubStr = 'C:';
%    wslSubStr = '/mnt/c';
%    out = win2wsl(path, winSubStr, wslSubStr)
%    >> path =
%    >>     'C:\Users\fnery\file.example'
%    >> out =
%    >>     '/mnt/c/Users/fnery/file.example'
%    
% fnery, 20171218: original version

% Convert drive path from windows to WSL
out = strrep(path, winSubStr, wslSubStr);

% Ensure all path separators are appropriate for WSL (i.e. linux)
out = filesepfix(out, 'UNIX');

end
function out = wsl2win(path, wslSubStr, winSubStr)
% wsl2win.m: convert Windows Subsystem for Linux (WSL) path to its Windows equivalent
%
% Syntax:
%    1) out = wsl2win(path, wslSubStr, winSubStr)
%    2) out = wsl2win(path)
%    
% Description:
%    1) out = wsl2win(path, wslSubStr, winSubStr) converts a path on the 
%       Windows Subsystem for Linux (WSL) file system to its equivalent 
%       path on the Windows Subsystem for Linux (WSL) file system
%    2) out = wsl2win(path) does the same as 1) but assumes the drive
%       substrings to be '/mnt/c' and 'C:' for WSL and windows respectively
%
% Inputs:
%    1) path: original file OR directory path 
%    2) wslSubStr: drive substring on the WSL file system (e.g. '/mnt/c')
%    3) winSubStr: drive substring on the windows file system (e.g. 'C:')
%
% Outputs:
%    1) out: Windows-converted path
%
% Notes/Assumptions: 
%    1) This function performs the inverse operation to win2wsl.m. 
%    2) See notes of win2wsl.m  
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
%    path = '/mnt/c/Users/fnery/file.example'
%    wslSubStr = '/mnt/c';
%    winSubStr = 'C:';
%    out = wsl2win(path, wslSubStr, winSubStr)
%    >> path =
%    >>     '/mnt/c/Users/fnery/file.example'
%    >> out =
%    >>     'C:\Users\fnery\file.example'
%
% fnery, 20171218: original version
% fnery, 20171220: added option for pre-loaded standard C: drive substrings

if nargin == 1
    % standard C: drive substrings
    wslSubStr = '/mnt/c';
    winSubStr = 'C:';
end

% Convert drive path from WSL to windows
out = strrep(path, wslSubStr, winSubStr);

% Ensure all path separators are appropriate for Windows
out = filesepfix(out, 'PC');

end
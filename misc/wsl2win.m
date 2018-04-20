function out = wsl2win(path)
% wsl2win.m: convert Windows Subsystem for Linux (WSL) path(s) to Windows equivalent
%
% Syntax:
%    1) out = wsl2win(path)
%    
% Description:
%    1) out = wsl2win(path) converts path(s) on the Windows Subsystem for Linux
%       (WSL) file system to its equivalent path(s) on the Windows file system
%
% Inputs:
%    1) path: two options 
%             - string: absolute file/directory path
%             - cell: cell of strings with absolute file/directory paths
%
% Outputs:
%    1) out: Windows-compatible path(s)
%
% Notes/Assumptions: 
%    1) This function performs the inverse operation to win2wsl.m. 
%    2) See notes of win2wsl.m  
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
%    in = '/mnt/c/Users/fnery/file.example'
%    out = wsl2win2(in)
%    >> in =
%    >> /mnt/c/Users/fnery/file.example
%    >> out =
%    >> C:\Users\fnery\file.example
%
% fnery, 20171218: original version
% fnery, 20171220: added option for pre-loaded standard C: drive substrings
% fnery, 20180220: 'PC' instance was replaced by 'WIN'
% fnery, 20180221: major changes: now automatically detects and converts drive substrings
% fnery, 20180420: now accepts cell of strings argin

if iscell(path)
    % assume is cell of strings (multiple paths)
    nPaths = length(path);
    out = cell(size(path));
    for iPath = 1:nPaths
        cPath = path{iPath};
        out{iPath} = main(cPath);
    end
elseif ischar(path)
    out = main(path);   
end

end

function out = main(path)
    
% Extract drive from input string
drive = driveinpath(path);

% Get original string without drive substring
pathWithoutDrive = strrep(path, drive, '');
pathWithoutDrive = filesepfix(pathWithoutDrive, 'WIN');

% Convert drive to WSL format
driveNew = ensuredrive(drive, 'WIN');

% Build new fullpath
out = [driveNew pathWithoutDrive];

end
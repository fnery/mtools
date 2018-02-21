function out = driveinpath(in)
% driveinpath.m: extracts drive substring from absolute filepath
%
% Syntax:
%    1) out = driveinpath(in)
%
% Description:
%    1) out = driveinpath(in) extracts drive substring from an absolute filepath
%
% Inputs:
%    1) in: absolute filepath
%
% Outputs:
%    1) out: drive substring
%
% Notes/Assumptions: 
%    1) ASSUMPTION 1: Windows drives have one ':' char
%    2) See 2 assumptions of driveinwsl.m subfunction
%
% References:
%    []
%
% Required functions:
%    1) iswinpath.m
%    2) filesep2.m
%
% Required files:
%    []
%
% Examples:
%       in1 = 'C:\Users\fnery\file.example';     % windows absolute path
%       in2 = '/mnt/c/Users/fnery/file.example'; % WSL absolute path
%       out1 = driveinpath(in1)
%       out2 = driveinpath(in2)
%    >> out1 =
%    >> C:
%    >> out2 =
%    >> /mnt/c
%
% fnery, 20180221: original version

% Check if input string is a path within a Windows environment
tf = iswinpath(in);

if tf == true
    % windows drive finder algorithm
    idx = strfind(in, ':');
    if numel(idx) ~= 1
        error('Error: the input path must have one and only one colon')
    end
    out = in(1:idx);
else
    % windows subsystem for linux (wsl) drive finder algorithm
    out = driveinwsl(in);
end

end
    
function out = driveinwsl(in)
% driveinwsl.m: extract drive string from wsl paths
%
% Syntax:
%    1) out = driveinwsl(in)
%
% Description:
%    1) out = driveinwsl(in) extracts the drive (mnt) string from wsl paths
%
% Inputs:
%    1) in: fullpath string of file in a Windows Subsystem for Linux (WSL)
%           environment
%
% Outputs:
%    1) out: drive (mnt) string
%
% Notes/Assumptions: 
%    1) ASSUMPTION 1: files in WSL live in local drives mounted under the
%       /mnt folder
%    2) ASSUMPTION 2: The drive string in WSL is the substring that 
%       finishes just before the second filesep after WSL_PARENT_DIR
%       (/mnt folder)
%
% References:
%    []
%
% Required functions:
%    1) filesep2.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20180220: original version

WSL_PARENT_DIR = 'mnt';

seps = strfind(in, filesep2('UNIX'));
seps = seps(seps > strfind(in, WSL_PARENT_DIR));
out  = in(1:seps(2)-1);

end
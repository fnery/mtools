function [status, cmdout] = system2(command, echo)
% system2: system.m wrapper. If in Windows: redirects cmd.exe commands to bash
%
% Syntax:
%    1) [status, cmdout] = system2(command)
%    2) [status, cmdout] = system2(command, '-echo')
%
% Description:
%    1) [status, cmdout] = system2(command) is a system.m wrapper that
%       allows commands as they are usually called in bash to work when
%       called from within MATLAB using system.m. For this to happen, when
%       on a Windows machine (with Windows Subsystem for Linux), it 
%       encapsulates the bash command in 'bash -c <cmd> &'. If we're on a
%       Linux machine, this function passes 'command' to system.m unchanged.
%    2) [status, cmdout] = system2(command, '-echo') does the same as 1) 
%       but the second (optional) argin which has to be '-echo' serves the
%       same purpose as in system.m
%
% Inputs:
%    1) command: command to call in bash
%    2) echo: optional but if exists has to be '-echo' (same as in system.m)
%
% Outputs:
%    (same outputs as from system.m)
%
% Notes/Assumptions: 
%    1) If used on a Windows computer, has to be Windows 10 and needs to
%       have Windows Subsystem for Linux configured and working.
%    2) Not sure if there is a better way but for now works. Not very
%       pretty since seems to require the use of pckillcmd.m.
%
% References:
%    [1] https://blogs.msdn.microsoft.com/commandline/2016/10/19/interop-between-windows-and-bash/
%
% Required functions:
%    1) pckillcmd.m
%
% Required files:
%    []
%
% Examples:
%    % Example with fslroi:
%    system2('fsl5.0-fslroi');
%
% fnery, 20180420: original version

if nargin == 1
    doEcho = false;
elseif nargin == 2 && strcmp(echo, '-echo')
    doEcho = true;
else
    error('Error: the second input argument can only be ''-echo''');
end

isWin = strcmp(computer, 'PCWIN64');

if isWin
   % assume here we're in a Windows PC, with MATLAB installed in the
   % Windows system and need to call command via Windows Subsystem for Linux
    command = sprintf('bash -c "%s" &', command);
end

% Run command
if doEcho   
   [status, cmdout] = system(command, '-echo');
else
   [status, cmdout] = system(command);
end

if status ~= 0
    error('Error: There was an error when calling ''command''');
end

if isWin
    % kill resulting command window
    pckillcmd;
end

end
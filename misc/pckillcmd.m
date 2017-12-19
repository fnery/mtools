function pckillcmd
% pckillcmd.m: kills "cmd.exe" processes on Windows machines
%
% Syntax:
%    1) pckillcmd
%
% Description:
%    1) pckillcmd kills "cmd.exe" processes
%
% Inputs:
%    []
%
% Outputs:
%    []
%
% Notes/Assumptions: 
%    1) Calling a bash command in the Windows Subsystem for Linux from
%       within MATLAB using a trailing & to dispatch the command window to
%       the background while the Matlab system continues often opens a
%       windows command prompt which then can't be controlled given the
%       usage of the &. This command closes these windows by "killing" all
%       open cmd.exe processes
%    2) Only tested on a Windows machine.
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20171219: original version

[status, ~] = system('taskkill /f /im cmd.exe');

% System above is behaving strangely. 
% It does kill the command windows and returns a 'result' variable that
% looks like:
%    result =
%        'SUCCESS: The process "cmd.exe" with PID 14168 has been terminated.
%         SUCCESS: The process "cmd.exe" with PID 15300 has been terminated.
%         '
% This would lead me to believe that system should return a 'status' of 0,
% reflecting the success of the operation. 
% However, 'status' is returned as a 1.
% Tested this multiple times and is consistent, therefore I will assume a
% status of 1 is what we are looking for in this particular instance.

if status ~= 1
    error('Error: There was an error when killing ''cmd.exe'' processes');
end

end
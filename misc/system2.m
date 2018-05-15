function [status, cmdout] = system2(varargin)
% system2: system.m wrapper. If in Windows: redirects cmd.exe commands to bash
%
% Syntax:
%    1) [status, cmdout] = system2('cmd', cmd, '-echo', true, '&', true)
%
% Description:
%    1) [status, cmdout] = system2(command) is a system.m wrapper that
%       allows commands as they are usually called in bash to work when
%       called from within MATLAB using system.m. For this to happen, when
%       on a Windows machine (with Windows Subsystem for Linux), it 
%       encapsulates the bash command in 'bash -c -i <cmd>' or 
%       'bash -c -i <cmd> &' (note the ampersand). If we are on a Linux
%       machine, system2.m passes 'command' to system.m unchanged. The 
%       '-echo' argin does the same as in system.m but in this function 
%       is a boolean scalar, as is ampersand
%
% Inputs:
%    -------------------------------- MANDATORY -------------------------------
%    <cmd>    string    :    command to call in bash
%    --------------------------------- OPTIONAL -------------------------------
%    <-echo>  bool      :    boolean scalar (true or false)
%    <&>      bool      :    boolean scalar (true or false)
%                            determines whether commmand is to be run in
%                            the background
%    --------------------------------------------------------------------------
%
% Outputs:
%    (same outputs as from system.m)
%
% Notes/Assumptions: 
%    1) If used on a Windows computer, has to be Windows 10 and needs to
%       have Windows Subsystem for Linux configured and working.
%    2) Not sure if there is a better way but for now works. Not very
%       pretty since seems to require the use of pckillcmd.m.
%    3) Using bash's option -i forces bash to read the bashrc file.
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
%    system2('fslroi');
%
% fnery, 20180420: original version
% fnery, 20180422: now runs bash as an interactive shell (using -i option)
% fnery, 20180512: now in argument-value pairs; now supports <&>

% ==================================
% ===== Manage input arguments ===== --------------------------------------
% ==================================

for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'cmd'}
            if ischar(cVal)
                cmd = cVal;
            else
                error('Error: ''cmd'' must be a string (command)');
            end
        case {'-echo'}
            if islogical(cVal) && isscalar(cVal)
                doEcho = cVal;
            else
                error('Error: ''-echo'' must be a boolean scalar');
            end
        case {'&'}
            if islogical(cVal) && isscalar(cVal)
                ampsd = cVal;
            else
                error('Error: ''&'' must be a boolean scalar');
            end                          
        otherwise
            error('Error: input argument not recognized');
    end
end

% Check we have all mandatory options in the workspace
allMandatoryOptsExist = exist('cmd', 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

% Check which optional arguments exist
doEchoExists = exist('doEcho' , 'var');
ampsdExists  = exist('ampsd'  , 'var');

if ~doEchoExists
    doEcho = false;
end

if ~ampsdExists
    ampsd = true;
end

isWin = strcmp(computer, 'PCWIN64');

if isWin
    
   % assume here we're in a Windows PC, with MATLAB installed in the
   % Windows system and need to call command via Windows Subsystem for Linux
   if ampsd   
       cmd = sprintf('bash -c -i "%s" &', cmd);
   else
       cmd = sprintf('bash -c -i "%s"', cmd);
   end
   
end

% Run command
if doEcho   
   [status, cmdout] = system(cmd, '-echo');
else
   [status, cmdout] = system(cmd);
end

if status ~= 0
    error('Error: There was an error when calling ''command''');
end

if isWin && ampsd
    % kill resulting command window
    pckillcmd;
end

end
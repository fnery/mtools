function out = ensuredrive(in, platform)
% ensuredrive.m: ensure drive compatible with desired platform
%
% Syntax:
%    1) out = ensuredrive(in, platform)
%
% Description:
%    1) out = ensuredrive(in, platform) ensures that the input drive 'in' is
%       compatible with the desired 'platform', modifying 'in' if necessary
%
% Inputs:
%    1) in: drive string (most likely the output from driveinpath.m)
%    2) platform: input string, which can be:
%       - 'WIN': to get a windows filesep
%       - 'WSL': to get a Windows Subsystem for Linux (WSL) filesep (UNIX)
%
% Outputs:
%    1) out: drive string compatible to requested platform
%
% Notes/Assumptions: 
%    1) ASSUMPTION 1: Windows drives have one ':' char
%    2) ASSUMPTION 2: The substring given in the constant WSL_PARENT_DIR
%       appears once in WSL drives
%    3) ASSUMPTION 3: if a WIN drive is provided the drive letter is the 1st
%       character, which is then used with a simple heuristic (see code) to
%       create a compatible WSL-drive
%    4) ASSUMPTION 4: if a WSL drive is provided the drive letter is after
%       (WSL_PARENT_DIR + one filesep), which is then used with an simple
%       heuristic (see code) to create a compatible WSL-drive
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
%    in1 = '/mnt/c';
%    in2 = 'C:';
%    out1 = ensuredrive(in1, 'WIN')
%    out2 = ensuredrive(in1, 'WSL')
%    out3 = ensuredrive(in2, 'WIN')
%    out4 = ensuredrive(in2, 'WSL')
%    >> out1 =
%    >>     'C:'
%    >> out2 =
%    >>     '/mnt/c'
%    >> out3 =
%    >>     'C:'
%    >> out4 =
%    >>     '/mnt/c'
%
% fnery, 20180220: original version

WSL_PARENT_DIR = 'mnt';

% Basic error checks
if nargin ~= 2
    error('Error: this function needs two input arguments')
end

if ~strcmp(platform, 'WIN') && ~strcmp(platform, 'WSL')
    error('Error: ''platform'' must be either ''WIN'' or ''WSL''')
end

% Lazy-check if input string is actually a drive string
if numel(strfind(in, ':')) == 1
    isWinDrive = true;
    isWSLDrive = false;
elseif numel(strfind(in, WSL_PARENT_DIR)) == 1     
    isWinDrive = false;    
    isWSLDrive = true;
else
    error('Error: ''in'' does not seem to be a Windows or WSL drive string');
end

% Convert input drive to desired output platform
if isWinDrive
    if strcmp(platform, 'WIN')
        out = in;
    elseif strcmp(platform, 'WSL')
        % get drive letter (note WSL requires it lowercase)
        driveLetter = in(1);              
        driveLetter = lower(driveLetter);
        % create drive string
        out = [filesep2('UNIX') WSL_PARENT_DIR filesep2('UNIX') driveLetter];
    end
elseif isWSLDrive
    if strcmp(platform, 'WIN')
        % get drive letter (note WSL requires it lowercase)        
        % get drive letter (note WIN requires it lowercase)
        driveLetter = in(strfind(in, WSL_PARENT_DIR)+(length(WSL_PARENT_DIR)+1):end);
        driveLetter = upper(driveLetter);
        % create drive string       
        out = [driveLetter ':'];
    elseif strcmp(platform, 'WSL')
        out = in;
    end
end

end
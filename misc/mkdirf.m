function out = mkdirf(varargin)
% mkdirf.m: extends mkdir.m function (automatic name/overwrite control)
%   
% Syntax:
%    1) out = mkdirf('fullpath', fullPath, 'overwrite', false)
%    2) out = mkdirf('loc', loc, 'name', name, 'overwrite', false)
%
% Description:
%    1) mkdirf has similar functionalities to mkdir (except for messages)
%       and additionally provides:
%       - automatic name for dir to be created if no <name> argin is provided
%       - <overwrite> flag to control overwritting of dirs/files
%
% Inputs:
%    ----------------------------- OPTIONAL --------------------------------
%    <loc>           $a     char      dir where new folder will be created
%    <name>          $a     char      name of new directory
%    <fullpath,fp>   %b     char      fullpath of directory to be created
%    <overwrite,ow>  $1     logical   true  - overwrite if already exists
%                                     false - never overwrite
%                                     [default]: false
%    -----------------------------------------------------------------------
%
% Outputs:
%    1) out (char): resulting path of the created directory
%
% Notes/Assumptions: 
%    1) Two methods for creating the directory:
%       $a: providing a directory where to create it (<loc>),
%           together with the name of the new directory to create,
%           (<name>). The final path ends up as: fullfile(loc, name))
%       $b: providing the full path of the directory to be created
%           directly (<fullpath>)
%    2) If using method $a, and <name> doesn't exist, an unique
%       name will be generated
%    $1) If the directory the user asks to create already exists,
%        the program either stops or overwrites the existing
%        directory and its contents, dependent on the choice of
%         <overwrite>. Caution using this option, may result in permanently
%        lost files if used inadvertently!
%
% References:
%    []
%
% Required functions:
%    1) ctime.m
%
% Required files:
%    []
% 
% Examples:
%    []
% 
% fnery, 20160728: original version
% fnery, 20160808: now arguments are name-value pairs
%                  added <overwrite> option
% fnery, 20170311: now includes methods $a and $b

UNIQUE_NAME = sprintf('tmp_%s', ctime(1)); % not used if <name> exists

% Pause for an instant to ensure uniqueness of folder name
pause(0.01);

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin)
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'loc'}
            if ischar(cVal) || isempty(cVal)
                loc = cVal;
            else
                error('Error: ''loc'' must be [] or string (path to parent directory)');
            end
        case {'fullpath','fp'}
            if ischar(cVal) || isempty(cVal)
                fullPath = cVal;
            else
                error('Error: ''fullpath'' must be [] or string (fullpath for directory)');
            end            
        case {'name'}
            if ischar(cVal) || isempty(cVal)
                name = cVal;
            else
                error('Error: ''name'' must be [] or string (name for directory)');
            end  
        case {'overwrite', 'ow'}
            if islogical(cVal)
                overwrite = cVal;
            else
                error('Error: ''overwrite'' must be a logical');
            end                     
        otherwise
            error('Error: input argument not recognized');
    end
end

% Defaults
locExists       = exist('loc'       , 'var') && ~isempty(loc); 
nameExists      = exist('name'      , 'var') && ~isempty(name);
fullPathExists  = exist('fullPath'  , 'var') && ~isempty(fullPath);
overwriteExists = exist('overwrite' , 'var');

if fullPathExists && (locExists || nameExists)
    error('Error: <fullpath> is provided, so can''t supply <loc> or <name>');
end

if fullPathExists
    out = fullPath; % path of directory to be created
else
    if ~nameExists
        name = UNIQUE_NAME;
    end    
    if ~locExists
        loc = pwd;
    end
    if ~(exist(loc, 'dir') == 7)
        error('Error: The chosen parent directory <loc> doesn''t exist');
    end
    out = fullfile(loc, name); % path of directory to be created
end

if ~overwriteExists
    overwrite = false;
end

% Verify if desired directory already exists, proceed according to <overwrite>
if overwrite && (exist(out, 'dir') == 7)
    rmdir(out,'s');
elseif ~overwrite && (exist(out, 'dir') == 7)
    error('Error: The directory already exists and overwritting wasn''t allowed');
end

mkdir(out);

end
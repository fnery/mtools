function Out = nvargins2struct(varargin)
% nvargins2struct.m: converts cell of argins (name-value pairs) into a struct
%   
% Syntax:
%    1) Out = nvargins2struct('in', in)
%    2) Out = nvargins2struct('in', in, 'rm', rm)
%
% Description:
%    1) Out = nvargins2struct('in', in) converts a cell of input arguments,
%      in the format of name-value pairs into a struct
%    2) Out = nvargins2struct('in', in, 'rm', rm) does the same as 1) but
%       allows to avoid including certain name-value argin pairs in the
%       final struct (option <rm>)
%
% Inputs:
%   ------------------------------ MANDATORY ------------------------------ 
%   <in>     cell     :  of input arguments (name-value pair format)
%   ------------------------------ OPTIONAL -------------------------------
%   <rm>     cell     :  of string(s): names of argins not to include in Out
%
% Outputs:
%   1) Out: struct where each argin is a struct field
%
% Notes/Assumptions: 
%   1) Input argument names are converted to all lowercase
%
% References:
%   []
%
% Required functions:
%   []
%
% Required files:
%   []
% 
% Examples:
%   % Create 'argins' test input argument
%   argins{1} = 'argin1name';
%   argins{2} = 'value of argin1';
%   argins{3} = 'argin2name';
%   argins{4} = 10;
%   avoid{1}  = 'argin2name';
%   % 1) Run without removing anything
%   Out = nvargins2struct('in', argins, 'rm', [])
%   >> Out = 
%   >>     argin1name: 'value of argin1'
%   >>     argin2name: 10
%   % 2) Run removing 'argin2name'
%   Out = nvargins2struct('in', argins, 'rm', avoid)
%   >> Out = 
%   >>     argin1name: 'value of argin1'
%
% fnery, 20160606: original version
% fnery, 20160607: implemented <rm> option

% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin);
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'in'}
            if iscell(cVal)
                in = cVal;
            else
                error('Error: ''in'' must be cell (paths to images to avg)');
            end
        case {'rm'}
            if iscell(cVal)
                rm = cVal;
            elseif isempty(cVal);
                 % do nothing
            else                
                error('Error: ''rm'' must be a cell');
            end                    
        otherwise
            error('Error: input argument not recognized');
    end
end

rmExists = exist('rm', 'var');

% Convert cell of argins into struct where each argin is a struct field
for iArgin = 1:2:numel(in)
    cArginName = lower(in{iArgin});
    cArginValue = in{iArgin+1};
    Out.(cArginName) = cArginValue;
end

if rmExists
    if ~all(ismember(rm, fieldnames(Out)))
        error('Error: One or more values of <rm> is not a name-value pair');
    end
    % Remove unwanted name value pairs from final struct
    for iRm = 1:length(rm)
        Out = rmfield(Out, rm{iRm});
    end
end
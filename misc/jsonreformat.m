function out = jsonreformat(in)
% jsonreformat.m: reformats .json string to human-readable format
%
% Syntax:
%    1) out = jsonreformat(in)
%
% Description:
%    1) out = jsonreformat(in) reformats a .json character string (most 
%       likely output from jsonencode.m) to human-readable format
%
% Inputs:
%    1) in: .json character string (most likely output from jsonencode.m)
%
% Outputs:
%    1) out: .json character string in human-readable format
%
% Notes/Assumptions: 
%    1) Got format rules from https://jsonlint.com/
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
% Example 1:
%    % This example shows, for 4 "different" .json files 
%    % (with different last element), the following:
%    % a) Manual generation of struct to be converted to .json by a MATLAB
%    %    native function (jsonencode.m)
%    % b) jsonreformat.m of the text output jsonencode.m
%    % c) Regeneration of the struct from the output of jsonreformat.m
%    % d) Regenerated struct is equal to the original, i.e. jsonreformat.m 
%    %    did not mess up the original .json
%    
%    % 1.1)
%    JSON1_ORI_STRUCT.arrayInt   = [1; 2; 4; 6];
%    JSON1_ORI_STRUCT.arrayFloat = [1.2; 1.33; 15.42];
%    JSON1_ORI_STRUCT.cellString = {'str1'; 'str2'; 'str3'};
%    JSON1_ORI_STRUCT.int        = 8;
%    JSON1_ORI_STRUCT.float      = 9.21;
%    JSON1_ORI_STRUCT.string     = 'string1';
%    
%    JSON1_ENCODED = jsonencode(JSON1_ORI_STRUCT);
%    JSON1_FORMATTED = jsonreformat(JSON1_ENCODED);
%    JSON1_NEW_STRUCT = jsondecode(JSON1_FORMATTED);
%    isequal(JSON1_ORI_STRUCT, JSON1_NEW_STRUCT)
%    
%    %{
%    {
%    	"arrayInt": [1, 2, 4, 6],
%    	"arrayFloat": [1.2, 1.33, 15.42],
%    	"cellString": ["str1", "str2", "str3"],
%    	"int": 8,
%    	"float": 9.21,
%    	"string": "string1"
%    }
%    %}
%    
%    % 1.2)
%    JSON2_ORI_STRUCT.arrayInt   = [1; 2; 4; 6];
%    JSON2_ORI_STRUCT.arrayFloat = [1.2; 1.33; 15.42];
%    JSON2_ORI_STRUCT.cellString = {'str1'; 'str2'; 'str3'};
%    JSON2_ORI_STRUCT.int        = 8;
%    JSON2_ORI_STRUCT.string     = 'string1';
%    JSON2_ORI_STRUCT.float      = 9.21;
%    
%    JSON2_ENCODED = jsonencode(JSON2_ORI_STRUCT);
%    JSON2_FORMATTED = jsonreformat(JSON2_ENCODED);
%    JSON2_NEW_STRUCT = jsondecode(JSON2_FORMATTED);
%    isequal(JSON2_ORI_STRUCT, JSON2_NEW_STRUCT)
%    
%    %{
%    {
%    	"arrayInt": [1, 2, 4, 6],
%    	"arrayFloat": [1.2, 1.33, 15.42],
%    	"cellString": ["str1", "str2", "str3"],
%    	"int": 8,
%    	"string": "string1",
%    	"float": 9.21
%    }
%    %}
%    
%    % 1.3)
%    JSON3_ORI_STRUCT.arrayFloat = [1.2; 1.33; 15.42];
%    JSON3_ORI_STRUCT.cellString = {'str1'; 'str2'; 'str3'};
%    JSON3_ORI_STRUCT.int        = 8;
%    JSON3_ORI_STRUCT.string     = 'string1';
%    JSON3_ORI_STRUCT.float      = 9.21;
%    JSON3_ORI_STRUCT.arrayInt   = [1; 2; 4; 6];
%    
%    JSON3_ENCODED = jsonencode(JSON3_ORI_STRUCT);
%    JSON3_FORMATTED = jsonreformat(JSON3_ENCODED);
%    JSON3_NEW_STRUCT = jsondecode(JSON3_FORMATTED);
%    isequal(JSON3_ORI_STRUCT, JSON3_NEW_STRUCT)
%    
%    %{
%    {
%    	"arrayFloat": [1.2, 1.33, 15.42],
%    	"cellString": ["str1", "str2", "str3"],
%    	"int": 8,
%    	"string": "string1",
%    	"float": 9.21,
%    	"arrayInt": [1, 2, 4, 6]
%    }
%    %}
%    
%    % 1.4)
%    JSON4_ORI_STRUCT.arrayFloat = [1.2; 1.33; 15.42];
%    JSON4_ORI_STRUCT.int        = 8;
%    JSON4_ORI_STRUCT.string     = 'string1';
%    JSON4_ORI_STRUCT.float      = 9.21;
%    JSON4_ORI_STRUCT.arrayInt   = [1; 2; 4; 6];
%    JSON4_ORI_STRUCT.cellString = {'str1'; 'str2'; 'str3'};
%    
%    JSON4_ENCODED = jsonencode(JSON4_ORI_STRUCT);
%    JSON4_FORMATTED = jsonreformat(JSON4_ENCODED);
%    JSON4_NEW_STRUCT = jsondecode(JSON4_FORMATTED);
%    isequal(JSON4_ORI_STRUCT, JSON4_NEW_STRUCT)
%    
%    %{
%    {
%    	"arrayFloat": [1.2, 1.33, 15.42],
%    	"int": 8,
%    	"string": "string1",
%    	"float": 9.21,
%    	"arrayInt": [1, 2, 4, 6],
%    	"cellString": ["str1", "str2", "str3"]
%    }
%    %}
%
% fnery, 20190109: original version

% Silence pre-allocation warning for now
%#ok<*AGROW>

NEW_LINE_PROMPT = ',';
PAREN_OPEN      = '[';
PAREN_CLOSE     = ']';
CHAR_START      = '{';
CHAR_END        = '}';

% Quick format checks
if ~strcmp(in(1), CHAR_START)
    error('Invalid .json: first character must be ''{''')
end

if ~strcmp(in(end), CHAR_END)
    error('Invalid .json: last character must be ''}''')
end

parenOpenIdxs  = strfind(in, PAREN_OPEN);
parenCloseIdxs = strfind(in, PAREN_CLOSE);

nParenOpen  = numel(parenOpenIdxs);
nParenClose = numel(parenCloseIdxs);

if ~isequal(nParenOpen, nParenClose)
    error('nParenOpen and nParenClose must be equal');
else
    nParen = nParenOpen;
end

% Get newline prompt indexes
nNewLinePrompts = length(NEW_LINE_PROMPT);
newLinePromptIdxs = [];
for iNewLinePrompt = 1:nNewLinePrompts
    cNewLinePrompt = NEW_LINE_PROMPT(iNewLinePrompt);
    
    newLinePromptIdxs = [newLinePromptIdxs strfind(in, cNewLinePrompt)];
end
newLinePromptIdxs = sort(newLinePromptIdxs);

% Remove commas from within [ ] (don't want newlines in those)
for iParen = 1:nParen
    cParenOpen = parenOpenIdxs(iParen);
    cParenClose = parenCloseIdxs(iParen);
    
    cCommasToDelete = (newLinePromptIdxs > cParenOpen) & ...
        (newLinePromptIdxs < cParenClose);
    
    newLinePromptIdxs(cCommasToDelete) = [];
end

% Start making output .json text
out = CHAR_START;

nNewLinePromptIdxs = length(newLinePromptIdxs);

for iNewLinePromptIdx = 1:nNewLinePromptIdxs
    
    % Determine start and end indexes for current line
    if iNewLinePromptIdx == 1
        cStartIdx = 2; % the first char is '{' and already taken care of
        cEndIdx = newLinePromptIdxs(iNewLinePromptIdx);
    else
        cStartIdx = newLinePromptIdxs(iNewLinePromptIdx-1)+1;
        cEndIdx = newLinePromptIdxs(iNewLinePromptIdx);
    end
    
    % Add line
    out = sprintf('%s\n\t%s', out, in(cStartIdx:cEndIdx));
    
end

% Add data line (i.e. not counting the final line with just "}"
cStartIdx = newLinePromptIdxs(end)+1;
cEndIdx = length(in)-1;
out = sprintf('%s\n\t%s', out, in(cStartIdx:cEndIdx));

% Final touches
out = sprintf('%s\n}\n', out);    % closing }
out = strrep(out, '":', '": ');   % add spaces after all :
out = strrep(out, ',', ', ');     % add spaces after all ,
out = regexprep(out,' \n','\n');  % remove spaces added in , at end of line

end
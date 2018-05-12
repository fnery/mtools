function out = dispcmd(cmd)
% dispcmd.m: human-readable display long dash argument-value command strings
%
% Syntax:
%    1) out = dispcmd(cmd)
%
% Description:
%    1) out = dispcmd(cmd) takes a string corresponding to a long command
%    which is in the format of dash argument-value pairs and displays it in
%    the command line in a more human-readable way, by showing each 
%    argument-value pair in its own line
%
% Inputs:
%    1) cmd: command string
%
% Outputs:
%    1) out: command string with modified formatting
%
% Notes/Assumptions: 
%    1) Only works for argument-value pairs where the argument is marked
%    with a dash (-) in the beginning
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
%    cmd = 'randomcommand -arg1 random_long_value -arg2 random_much_longer_value_which_will_make_the_string_very_long -argument3 random_long_value_now_the_string_doesnt_fit_in_one_line -arg4 i_really_dont_line_scrolling_left_to_right'
%    >> 'randomcommand
%    >> -arg1      random_long_value
%    >> -arg2      random_much_longer_value_which_will_make_the_string_very_long
%    >> -argument3 random_long_value_now_the_string_doesnt_fit_in_one_line
%    >> -arg4      i_really_dont_line_scrolling_left_to_right'
%
% fnery, 20180512: original version

% Divide input string into its components (space-delimited)
strComponents = strsplit(cmd, ' ');
nStrComponents = length(strComponents);

% Count number of characters in each argument component
isArg = false(1, nStrComponents);
for i = 1:nStrComponents
    cI = strComponents{i};
    
    if strcmp(cI(1), '-')
        isArg(i) = true;
    end
   
end
lengths = cellfun('length', strComponents(isArg));

% Determine number of spaces to pad arguments for ensuring values aligned
toPad = (max(lengths)-lengths)+1;

% Create output string
ctPad = 0;
out = '';
for i = 1:length(strComponents)
    cI = strComponents{i};
    
    if isArg(i)
        ctPad = ctPad + 1;
        out = sprintf('%s\n%s%s', out, cI, repmat(' ', [1 toPad(ctPad)]));
    else
        out = sprintf('%s%s', out, cI);
    end
        
end

end

    
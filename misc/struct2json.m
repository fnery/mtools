function out = struct2json(in, outBaseName)
% struct2json.m: convert MATLAB struct into .json file
%
% Syntax:
%    1) S = struct2json(in)
% 
% Description:
%    1) S = struct2json(in) converts one MATLAB struct into a .json file
%
% Inputs:
%    1) in: MATLAB struct
%    2) outBaseName: base path/name for output .json file
%
% Outputs:
%    1) out: full path to output .json file
%
% Notes/Assumptions: 
%    1) Uses MATLAB's jsonencode.m to encode the .json and my custom
%       function jsonreformat.m to make it human-readable, so see also
%       note within it
%
% References:
%    []
%
% Required functions:
%    1) outinit.m
%    2) jsonreformat.m
%
% Required files:
%    []
%
% Example:
%    % Create example struct, save it as 'example.json' in current directory
%    in.arrayInt   = [1; 2; 4; 6];
%    in.arrayFloat = [1.2; 1.33; 15.42];
%    in.cellString = {'str1'; 'str2'; 'str3'};
%    in.int        = 8;
%    in.float      = 9.21;
%    in.string     = 'string1';
%    
%    outBaseName = 'example';
%    
%    out = struct2json(in, outBaseName);
%    
%    % This should generated the .json below:
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
% fnery, 20190109: original version

JSON_EXT = '.json';

% Init full path for output file
out = outinit('in'     , outBaseName , ...
              'useext' , false       , ...
              'nodir'  , 'error');
          
% Add extension          
out = [out JSON_EXT];       

% Encode .json and make it human-readable
inEncoded     = jsonencode(in);
inReformatted = jsonreformat(inEncoded);

% Write .json
fid = fopen(out,'wt');
fprintf(fid, '%s', inReformatted);
fclose(fid);    

end
function S = json2struct(path)
% json2struct.m: load .json file into MATLAB struct
%
% Syntax:
%    1) S = json2struct(path)
% 
% Description:
%    1) S = json2struct(path) loads one .json file into a MATLAB struct
%
% Inputs:
%    1) path: path to a single .json file
%
% Outputs:
%    1) S: struct with fields/values from input .json file
%
% Notes/Assumptions: 
%    []
%
% References:
%    []
%
% Required functions:
%    []
%
% Required files:
%    none other than the input file
%
% Examples:
%    []
%
% fnery, 20190108: original version

% Open .json file and convert initialise its contents as a MATLAB string
fid = fopen(path);
raw = fread(fid, inf);
str = char(raw');
fclose(fid);

% Parse .json file
S = jsondecode(str);

end
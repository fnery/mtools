function tf = iswinpath(in)
% iswinpath.m: checks if input path is from a file in a windows filesystem
%
% Syntax:
%    1) tf = iswinpath(in)
%
% Description:
%    1) tf = iswinpath(in) checks if input path is from a file in a windows
%       filesystem
%
% Inputs:
%    1) in: full filepath
%
% Outputs:
%    1) tf: logical scalar
%
% Notes/Assumptions: 
%    []
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
%    in1 = '/mnt/c/Users/fnery/file.example';
%    in2 = 'C:\Users\fnery\file.example';
%    iswinpath(in1)
%    iswinpath(in2)
%    >> ans =
%    >>   logical
%    >>    0
%    >> ans =
%    >>   logical
%    >>    1
%
% fnery, 20180220: original version

if contains(in, filesep2('WIN'))
   tf = true;    
elseif contains(in, filesep2('UNIX'))
   tf = false;    
else
    error('Error: no file separators found');
end

end
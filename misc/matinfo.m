function Out = matinfo
% matinfo.m: info struct to attach to any automatically generated .mat file
%   
% Syntax:
%    1) Out = matinfo
%
% Description:
%    1) Out = matinfo creates an info struct to attach to (i.e. save in)
%       any automatically generated .mat file, so that then a couple of
%       weeks later when I load the .mat file I know where it came from
%
% Inputs:
%    []
% 
% Outputs:
%    1) Out: struct with useful info
%
% Notes/Assumptions: 
%    1) New "concept" which I didn't take the time to think much about so
%       room for improvement here
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
% fnery, 20170617: original version

STACK_POS = 2;

[St, ~] = dbstack('-completenames');

if length(St) == 1;
    error('Error: ''matinfo.m'' needs to be called by another function');
end

Out.readMe = 'Info about the .mat file from which this struct was loaded';
Out.createdWith = St(STACK_POS).file;
Out.createdWhen = ctime;

end
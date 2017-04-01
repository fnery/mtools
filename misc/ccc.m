function ccc
% ccc.m: cleans MATLAB's cmd window, workspace, figures, etc...
%   
% Syntax:
%    1) ccc
%
% Description:
%    1) ccc cleans cmd window, workspace, figures, etc
%
% Inputs:
%    []
% 
% Outputs:
%    []
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
%    []
% 
% Examples:
%    []
%
% fnery, 20151015, original version

clear variables;
close all;
close all hidden;
close all force;
clc;
fclose('all');

% Find/close all windows of type figure which have an empty FileName attribute.
delete(findall(0, 'Type', 'figure'));

% If the above didn't work, this should...
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
set(0,'ShowHiddenHandles','off');

end
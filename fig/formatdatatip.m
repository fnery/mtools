function formatdatatip(fmt, figHandle)
% formatdatatip.m: change format when displaying plot info using data cursor
%
% Syntax:
%    1) formatdatatip(fmt)
%    2) formatdatatip(fmt, figHandle)
%
% Description:
%    1) formatdatatip(fmt) allows to change the format of the datatip when
%       looking at data in plots using the data cursor
%    2) formatdatatip(fmt, figHandle) does the same as 1) but allows to specify
%       the handle of the figure in which datatip is to be modified
%
% Inputs:
%    1) fmt: format (as specified by sprintf.m) to use when displaying datatip
%    2) figHandle (optional): figure handle in which datatip is to be modified
%
% Outputs:
%    changes the format of the datatip of the desired figure (plot)
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
%    % The following two examples will create figures. Select values in the
%    % plot using the data cursor to see how the format of the datatip changes
%    figure, plot(sin(linspace(0, 2*pi, 100))); formatdatatip('%.3f');
%    figure, plot(sin(linspace(0, 2*pi, 100))); formatdatatip('%010.4f');
%
% fnery, 20180402: original version

if nargin < 1
    fmt = '%.5f';
end
if nargin < 2;
    figHandle = gcf;
end


set(datacursormode(figHandle), 'UpdateFcn', @setfmtfun, 'Enable', 'on');

    function outText = setfmtfun(~, event) 
        pos = get(event, 'Position');
        if length(pos) == 3
            outText = {sprintf(sprintf('X: %s', fmt), pos(1)), ...
                       sprintf(sprintf('Y: %s', fmt), pos(2)), ...
                       sprintf(sprintf('Z: %s', fmt), pos(3))};
            
        else
            outText = {sprintf(sprintf('X: %s', fmt), pos(1)), ...
                       sprintf(sprintf('Y: %s', fmt), pos(2))};
        end
    end

end
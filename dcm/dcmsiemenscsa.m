function Out = dcmsiemenscsa(in)
% dcmsiemenscsa.m: parse DICOM Siemens CSA header (ASCCONV subset only)
%   
% Syntax:
%    1) Out = dcmsiemenscsa(in)
%
% Description:
%    1) Out = dcmsiemenscsa(in) parses the DICOM Siemens CSA header
%
% Inputs:
%    1) in: can be:
%         - struct: assumed to be a DICOM header read with dicominfo.m
%         - string: assume it is the complete CSA header, in string format
%
% Outputs:
%    1) Out: struct with parsed ASCCONV portion of the DICOM Siemens CSA header
%
% Notes/Assumptions: 
%    1) One of the subfunctions used (dcmsiemensisolateascconv.m) isn't as
%       robust as I want it to be
%    2) Uses external code [1]
%    3) Only tested in VB17 data
%
% References:
%    [1] mathworks.com/matlabcentral/fileexchange/27941-dicom-toolbox/content/SiemensInfo.m
%        Copyright (c) 2010, Dirk-Jan Kroon
%
% Required functions:
%    1) dcmsiemensisolateascconv.m
%
% Required files:
%    []
% 
% Examples:
%    []
% 
% fnery, 20170314: original version

EXPECTED_DCM_HEADER_FIELD = 'Private_0029_1020';

% Switch off warning related to eval usage
%#ok<*NODEF> 

if isstruct(in) 
    % assume its a DICOM header read with dicominfo.m, check CSA header exists
    if ~isfield(in, EXPECTED_DCM_HEADER_FIELD)
        error('Error: No Siemens CSA header available in the provided DICOM header');
    end
    % isolate csa header, eval used to make sure we use the defined constant
    eval(sprintf('csa = in.%s;', EXPECTED_DCM_HEADER_FIELD))
    csa = char(csa)'; 
elseif ischar(in)
    % assume it is the complete CSA header, in string format
    csa = in;
end

% Isolate ### ASCCONV ### part
csa = dcmsiemensisolateascconv(csa);

try
    % The following code is part of
    % mathworks.com/matlabcentral/fileexchange/27941-dicom-toolbox/content/SiemensInfo.m
    % by Dirk-Jan Kroon
    request_lines = regexp(csa, '\n+', 'split');
    request_words = regexp(request_lines, '=', 'split');
    Out=struct;
    for i=1:length(request_lines)
        s=request_words{i};
        name=s{1};
        while(name(end)==' '); name=name(1:end-1); end
        while(name(1)==' '); name=name(2:end); end
        value=s{2}; value=value(2:end);
        if(any(value=='"'))
            value(value=='"')=[];
            valstr=true;
        else
            valstr=false;
        end
        names = regexp(name, '\.', 'split');
        ind=zeros(1,length(names));
        for j=1:length(names)
            name=names{j};
            ps=find(name=='[');
            if(~isempty(ps))
                pe=find(name==']');
                ind(j)=str2double(name(ps+1:pe-1))+1;
                names{j}=name(1:ps-1);
            end
        end
        try
            evalstr='Out';
            for j=1:length(names)
                if(ind(j)==0)
                    evalstr=[evalstr '.(names{' num2str(j) '})'];
                else
                    evalstr=[evalstr '.(names{' num2str(j) '})(' num2str(ind(j)) ')'];
                end
            end
            if(valstr)
                evalstr=[evalstr '=''' value ''';'];
            else
                if(strcmp(value(1:min(2:end)),'0x'))
                    evalstr=[evalstr '='  num2str(hex2dec(value(3:end))) ';'];
                else
                    evalstr=[evalstr '=' value ';'];
                end
            end
            eval(evalstr);
        catch ME
            warning(ME.message);
        end
    end
catch
    error('Error: Error parsing Siemens CSA header using external code within dcmsiemenscsa.m');
end

end
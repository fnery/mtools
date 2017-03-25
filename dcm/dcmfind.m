function Out = dcmfind(in)
% dcmfind.m: List DICOM files in dir (and its subdirs)
%   
% Syntax:
%    1) Out = dcmfind(in)
%
% Description:
%    1) Out = dcmfind(in) find and lists all DICOM files in the input dir
%       and its subdirs. 
%
% Inputs:
%    1) in: fullpath of input directory containing any combination of files
%           and subdirectories
%
% Outputs:
%    1) Out: struct with contents
%         |--name
%         |--bytes
%
% Notes/Assumptions: 
%    1) Ignores:
%          - any non-DICOM files
%          - DICOM .SR files
%    2) Assumes MATLAB's isdicom works well \o/
%
% References:
%    []
%
% Required functions:
%    1) subdir.m
%    2) cellstrmatch.m
%
% Required files:
%    []
% 
% Examples:
%    []
%
% fnery, 20170308: original version
% fnery, 20170313: now saves bytes for use with dcmparse.m
% fnery, 20170325: now uses cellstrmatch.m instead of cellmatchstr.m

Out = subdir(in);

% Remove dirs
Out([Out.isdir]) = [];

% From now on I only care about the full filepaths and size in bytes;
nFiles = length(Out);
Out = rmfield(Out, {'date'; 'isdir'; 'datenum'});

% Remove all but dicom files
isdcm = zeros(1, nFiles);
for iFile = 1:nFiles
    isdcm(iFile) = isdicom(Out(iFile).name);
end
Out(~isdcm) = [];

% ======================
% ===== Exceptions ===== --------------------------------------------------
% ======================

% Remove DICOMDIR files
[~, idxs] = cellstrmatch({Out.name}, '\DICOMDIR', false);
Out(~idxs) = [];

% Remove .SR files
[~, idxs] = cellstrmatch({Out.name}, '\.SR', false);
Out(~idxs) = [];

dicomsNotFound = isempty(Out);
if dicomsNotFound
	fprintf('No DICOM files found in ''%s''\n', in);
	Out = [];
end

end
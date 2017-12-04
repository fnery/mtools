function Out = aslorder(nMeasurements, nPLDs, setOrder, loopOrder, silent)
% aslorder.m: returns order matrix for ASL experiment
%
% Syntax:
%    1) Out = aslorder(nMeasurements, nPLDs, setOrder, loopOrder, silent)
%
% Description:
%    1) Out = aslorder(nMeasurements, nPLDs, setOrder, loopOrder, silent)
%       returns an order matrix for a specific ASL experiment with settings
%       given by the options provided to this function
%
% Inputs:
%    1) nMeasurements: number of measurements (i.e. ASL pairs)
%    2) nPLDs: number of PLDs (post-labelling delays)
%    3) setOrder: code describing the input data's set order
%           >> option 1: 'ct'  : [control, tag]
%           >> option 2: 'tc'  : [tag, control]
%           >> option 3: 'ctd' : [control, tag, difference]
%           >> option 4: 'tcd' : [tag, control, difference]
%    4) loopOrder: code describing the input data's loop order
%           >> option 1: 'smp' : [sets, measurements, PLDs]
%           >> option 2: 'spm' : [sets, PLDs, measurements]
%           >> option 3: 'psm' : [PLDs, sets, measurements]
%           >> option 4: 'pms' : [PLDs, measurements, sets]
%           >> option 5: 'mps' : [measurements, PLDs, sets]
%           >> option 6: 'msp' : [measurements, sets, PLDs]
%    5) silent (optional): logical scalar, controls whether output is printed
%           to the command window
%           [default] = true
%
% Outputs:
%    1) Out: struct containing fields:
%           >> 'order': ASL order matrix
%           >> 'log':  log helper string 
%           >> 'controlSetIdx': control set index
%           >> 'tagSetIdx': tag set index
%           >> 'differenceSetIdx': difference set index
%
% Notes/Assumptions: 
%    1) Limited error checking as this function is typically called by asl6d.m
%       who does relevant error checks
%    2) This is used to sort ASL, which will have as final format:
%           - output set order:  [control, tag, difference]
%           - output loop order: [set, measurement, PLDs]
%
% References:
%    []
%
% Required functions:
%    1) reparrew.m
%    2) matrix2string.m
%
% Required files:
%    []
%
% Examples:
%    % Example 1:
%        nMeasurements = 3;
%        nPLDs     = 4;
%        setOrder  = 'tc';
%        loopOrder = 'smp';
%        Out       = aslorder(nMeasurements, nPLDs, setOrder, loopOrder, false);
%        >>    -------------------
%        >>    nMeasurements = 3
%        >>    nPLDs         = 4
%        >>    setOrder      = tc
%        >>    loopOrder     = smp
%        >>    -------------------
%        >>            ORDER      
%        >>    -------------------
%        >>    set     meas    pld
%        >>    2       1       1
%        >>    1       1       1
%        >>    2       2       1
%        >>    1       2       1
%        >>    2       3       1
%        >>    1       3       1
%        >>    2       1       2
%        >>    1       1       2
%        >>    2       2       2
%        >>    1       2       2
%        >>    2       3       2
%        >>    1       3       2
%        >>    2       1       3
%        >>    1       1       3
%        >>    2       2       3
%        >>    1       2       3
%        >>    2       3       3
%        >>    1       3       3
%        >>    2       1       4
%        >>    1       1       4
%        >>    2       2       4
%        >>    1       2       4
%        >>    2       3       4
%        >>    1       3       4
%        >>    -------------------
%
% fnery, 20171204: original version: STILL NEEDS TESTING

CONTROL_SET_INDEX    = 1;
TAG_SET_INDEX        = 2;
DIFFERENCE_SET_INDEX = 3;

N_SPACES = 7;

if nargin < 4
    error('Error: at least 4 input arguments are necessary');
elseif nargin == 4
    silent = true;
elseif nargin > 5
    error('Error: too many input arguments');
else
    % looks good
end   

if strcmp(setOrder, 'ctd') || strcmp(setOrder, 'tcd')
    % Input ASL data includes difference images
    measurementSize = 3; 
else
    % Input ASL data does not include difference images
    measurementSize = 2; 
end

nVolumes = measurementSize*nMeasurements*nPLDs;

order = NaN(nVolumes, 3);

% =================================
% ===== Define setDefaultIdxs ===== ---------------------------------------
% =================================

if strcmp(setOrder, 'ct')
    setDefaultIdxs = [CONTROL_SET_INDEX, TAG_SET_INDEX]';
elseif strcmp(setOrder, 'tc')
    setDefaultIdxs = [TAG_SET_INDEX, CONTROL_SET_INDEX]';
elseif strcmp(setOrder, 'ctd')
    setDefaultIdxs = [CONTROL_SET_INDEX, TAG_SET_INDEX, DIFFERENCE_SET_INDEX]';
elseif strcmp(setOrder, 'tcd')
    setDefaultIdxs = [TAG_SET_INDEX, CONTROL_SET_INDEX, DIFFERENCE_SET_INDEX]';
else
    error('Error: invalid ''setOrder'' provided (see documentation)');
end

nSets = length(setDefaultIdxs);

% ========================
% ===== Define order ===== ------------------------------------------------
% ========================

if strcmp(loopOrder, 'smp');
    sIdxs = repmat(setDefaultIdxs, [nMeasurements*nPLDs 1]);
    mIdxs = repmat(reparrew(1:nMeasurements, nSets)', [nPLDs 1]);
    pIdxs = reparrew(1:nPLDs, nSets*nMeasurements)';
elseif strcmp(loopOrder, 'spm');
    sIdxs = repmat(setDefaultIdxs, [nMeasurements*nPLDs 1]);
    pIdxs = repmat(reparrew(1:nPLDs, nSets)', [nMeasurements 1]);
    mIdxs = reparrew(1:nMeasurements, nSets*nPLDs)';
elseif strcmp(loopOrder, 'psm');
    pIdxs = repmat((1:nPLDs)', [nSets*nMeasurements 1]);
    sIdxs = repmat(reparrew(setDefaultIdxs, nPLDs), [nMeasurements 1]);
    mIdxs = reparrew(1:nMeasurements, nSets*nPLDs)';
elseif strcmp(loopOrder, 'pms');
    pIdxs = repmat((1:nPLDs)', [nSets*nMeasurements 1]);
    mIdxs = repmat(reparrew(1:nMeasurements, nPLDs)', [nSets 1]);
    sIdxs = reparrew(setDefaultIdxs, nMeasurements*nPLDs);
elseif strcmp(loopOrder, 'mps');
    mIdxs = repmat((1:nMeasurements)', [nSets*nPLDs 1]);
    pIdxs = repmat(reparrew(1:nPLDs, nMeasurements)', [nSets 1]);
    sIdxs = reparrew(setDefaultIdxs, nMeasurements*nPLDs);
elseif strcmp(loopOrder, 'msp');
    mIdxs = repmat((1:nMeasurements)', [nSets*nPLDs 1]);
    sIdxs = repmat(reparrew(setDefaultIdxs, nMeasurements), [nPLDs 1]);
    pIdxs = reparrew(1:nPLDs, nSets*nMeasurements)';
end

if any(size(sIdxs) ~= [nVolumes, 1])
    error('''sIdxs'' must be a column-vector of length equal to ''nVolumes''');
elseif any(size(mIdxs) ~= [nVolumes, 1])
    error('''mIdxs'' must be a column-vector of length equal to ''nVolumes''');
elseif any(size(pIdxs) ~= [nVolumes, 1])
    error('''pIdxs'' must be a column-vector of length equal to ''nVolumes''');
else
    % looks good
    order(:, 1) = sIdxs;
    order(:, 2) = mIdxs;
    order(:, 3) = pIdxs;
end


log = sprintf(['-------------------\n' ...
               'nMeasurements = %d\n'  ...
               'nPLDs         = %d\n'  ...
               'setOrder      = %s\n'  ...
               'loopOrder     = %s\n'  ...
               '-------------------\n' ...
               '        ORDER      \n' ...
               '-------------------\n' ...
               'set     meas    pld\n'   ...
               '%s\n'                  ...
               '-------------------\n'], ...
               nMeasurements, nPLDs, setOrder, loopOrder, ...
               matrix2string(order, N_SPACES, '%d'));
           
if ~silent               
    disp(log)
end

Out.order = order;
Out.log   = log;
Out.controlSetIdx    = CONTROL_SET_INDEX;
Out.tagSetIdx        = TAG_SET_INDEX;
Out.differenceSetIdx = DIFFERENCE_SET_INDEX;

end
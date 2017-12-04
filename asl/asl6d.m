function Out = asl6d(varargin)
% asl6d.m: organises a 4D ASL volume into a 6D ASL volume
%
% Syntax:
%    1) Out = asl6d('data', data, 'nMeasurements', nMeasurements, 'nPLDs', nPLDs, ...
%                   'setOrder', setOrder, 'loopOrder', loopOrder)
%
% Description:
%    1) asl6d.m does the following: 
%       - organises a 4D ASL volume into a standardised 6D ASL volume format
%         regardless of acquisition order / loop structure
%       - control-label subtraction
%       The format of the output 6D volume will be:
%       [row, col, slice, set, measurement, PLD], where
%       - PLD = post-labelling delay
%       - output set order: [control, tag, difference]
%
% Inputs:
%    -------------------------------- MANDATORY -------------------------------
%    <data>       4D vol  :  input ASL volume ($1)
%    <nMeasurements> int  :  number of ASL measurements
%    <nPLDs>      int     :  number of Description of input argument 2
%    <setOrder>   string  :  code describing the input data's set order.
%                                option 1: 'ct'  : [control, tag]
%                                option 2: 'tc'  : [tag, control]
%                                option 3: 'ctd' : [control, tag, difference]
%                                option 4: 'tcd' : [tag, control, difference]
%    <loopOrder>  string  :  code describing the input data's loop order
%                                option 1: 'smp' : [sets, measurements, PLDs]
%                                option 2: 'spm' : [sets, PLDs, measurements]
%                                option 3: 'psm' : [PLDs, sets, measurements]
%                                option 4: 'pms' : [PLDs, measurements, sets]
%                                option 5: 'mps' : [measurements, PLDs, sets]
%                                option 6: 'msp' : [measurements, sets, PLDs]
%    --------------------------------------------------------------------------
%    $1 - See Assumption #1
%
% Outputs:
%    1) Out: struct containing fields: 
%       |--data: ASL data volume in 6D format (see description or note 3)
%       |--nRows
%       |--nCols
%       |--nSlices
%       |--nSets
%       |--nMeasurements
%       |--nPLDs
%       |--setOrder
%       |--loopOrder
%       |--order: ASL order matrix
%       |--orderLog: helper string (easy display of ASL order matrix)
%       |--controlSetIdx
%       |--tagSetIdx
%       |--differenceSetIdx
%       |--offlineDifferenceImageCalculation: informs if control-tag subtraction done with this function
%
% Notes/Assumptions: 
%    1) Assumption #1: Assumes difference image sets (e.g. control/tag),
%       measurements and PLDs (post-labelling delays) to be concatenated
%       in the 4th dimension. Even if the input data is single-slice it
%       will be a 4D volume (with a single element in the 3rd dimension). 
%    2) Format of output 6D volume: [row, col, slice, set, measurement, PLDs]
%
% References:
%    []
%
% Required functions:
%    1) is1d.m
%    2) aslorder.m
%
% Required files:
%    []
%
% Examples:
%    []
%
% fnery, 20171204: original version: STILL NEEDS TESTING

POSSIBLE_SET_ORDERS  = {'ct', 'tc', 'ctd', 'tcd'};
POSSIBLE_LOOP_ORDERS = {'smp', 'spm', 'psm', 'pms', 'mps', 'msp'};
SILENT = false;
N_SETS_OUTPUT = 3; % if difference image does not exist it will be calculated 
                   % in this function so the nSets in the output is always 3
      
% _________________________________________________________________________
%                          Manage input arguments                              
% _________________________________________________________________________
for iOptIn = 1:2:numel(varargin);
    % init option name and value
    cOpt = varargin{iOptIn};
    if ~ischar(cOpt)
        error('Error: Invalid argument list');
    end
    cVal = varargin{iOptIn+1};
    % attempt to recognise options
    switch lower(cOpt)
        case {'data'}
            if ndims(cVal) == 4
                data = cVal;
            else
                error('Error: ''data'' must be a 4D volume');
            end
        case {'nmeasurements'}
            if isint(cVal) && is1d(cVal)
                nMeasurements = cVal;
            else
                error('Error: ''nMeasurements'' must be a 1D int (no. of ASL measurements');
            end
        case {'nplds'}
            if isint(cVal) && is1d(cVal)
                nPLDs = cVal;
            else
                error('Error: ''nPLDs'' must be a 1D int (no. of ASL PLDs');
            end
        case {'setorder'}
            if ismember(cVal, POSSIBLE_SET_ORDERS)
                setOrder = cVal;
            else
                error('Error: invalid ''setOrder'' provided (see documentation)');
            end
        case {'looporder'}
            if ismember(cVal, POSSIBLE_LOOP_ORDERS)
                loopOrder = cVal;
            else
                error('Error: invalid ''loopOrder'' provided (see documentation)');
            end               
        otherwise
            error('Error: input argument not recognized');
    end
end

% ==============================
% ===== Basic error checks ===== ------------------------------------------
% ==============================

% Check we have all mandatory options in the workspace
allMandatoryOptsExist =              ...
    exist('data'          , 'var') & ...
    exist('nMeasurements' , 'var') & ...
    exist('nPLDs'         , 'var') & ...
    exist('setOrder'      , 'var') & ...
    exist('loopOrder'     , 'var'); 
if ~allMandatoryOptsExist
    error('Error: One or more mandatory options are missing');
end

[nRows, nCols, nSlices, nVolumes] = size(data);

if strcmp(setOrder, 'ctd') || strcmp(setOrder, 'tcd')
    % Input ASL data includes difference images
    measurementSize = 3;
    offlineDifferenceImageCalculation = false;
else
    % Input ASL data does not include difference images
    measurementSize = 2;
    offlineDifferenceImageCalculation = true;
end

% Check if number of volumes in the data matches provided options
nVolumesExpected = measurementSize*nMeasurements*nPLDs;

if nVolumes ~= nVolumesExpected
    error('Error: input ''data'' dimensions do not match ''nMeasurements'' and/or ''nPLDs''');
end

% ================================
% ===== Get ASL order matrix ===== ----------------------------------------
% ================================

Order = aslorder(nMeasurements, nPLDs, setOrder, loopOrder, SILENT);

% =======================================
% ===== Arrange data into 6D volume ===== ---------------------------------
% =======================================

% Pre-allocate
dataOut = NaN(nRows, nCols, nSlices, N_SETS_OUTPUT, nMeasurements, nPLDs);

% Build 6D volume
for iVolume = 1:nVolumes
    cVolume      = data(:,:,:,iVolume); % don't use squeeze!
    cSet         = Order.order(iVolume, 1);
    cMeasurement = Order.order(iVolume, 2);
    cPLD         = Order.order(iVolume, 3);
    dataOut(:,:,:,cSet,cMeasurement,cPLD) = cVolume;    
end

if offlineDifferenceImageCalculation
    control    = dataOut(:,:,:,Order.controlSetIdx,:,:);
    tag        = dataOut(:,:,:,Order.tagSetIdx,:,:);
    difference = control - tag;
    dataOut(:,:,:,Order.differenceSetIdx,:,:) = difference;    
end

% ================================
% ===== Create output struct ===== ----------------------------------------
% ================================

Out.data          = dataOut;
Out.nRows         = nRows;
Out.nCols         = nCols;
Out.nSlices       = nSlices;
Out.nSets         = N_SETS_OUTPUT;
Out.nMeasurements = nMeasurements;
Out.nPLDs         = nPLDs;
Out.setOrder      = setOrder;
Out.loopOrder     = loopOrder;
Out.order         = Order.order;
Out.orderLog      = Order.log;
Out.controlSetIdx = Order.controlSetIdx;
Out.tagSetIdx     = Order.tagSetIdx;
Out.differenceSetIdx = Order.differenceSetIdx;
Out.offlineDifferenceImageCalculation = offlineDifferenceImageCalculation;

end
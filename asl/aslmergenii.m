function [outNii, outJSON] = aslmergenii(inDir, outDir)
% aslmergenii.m: sorts and merges 3D ASL NIfTIs into 4D NIfTIs 
%
% Syntax:
%    1) [outNii, outJSON] = aslmergenii(inDir, outDir)
%
% Description:
%    1) [outNii, outJSON] = aslmergenii(inDir, outDir) sorts and merges 3D
%       ASL NIfTIs converted from DICOM using dcm2niix [1] into 4D NIfTIs.
%       These files must correspond to data acquired with MG's VB17 ASL
%       sequences $1 (also see Notes below). The resulting 4D NIfTIs will 
%       also have a .json sidecar which is a copy of the first .json of the
%       group of files and some additions (see $3)
%
% Inputs:
%    1) inDir: input directory with NIfTI and JSON files
%    2) outDir: directory where outputs will be saved
%
% Outputs:
%    1) outNii: cell list of output NIfTI files
%    2) outJSON: cell list of output JSON files
%
% Notes/Assumptions: 
%    1) Just works for data acquired with MG's VB17 ASL sequences $1
%    2) Only processes slice-selective (SS) and non slice-selective (NS)
%       data (both background-supressed (BS) ASL and non-BS data (e.g. M0, 
%       separate T1 mapping sequences) provided that $1) (i.e. no ASL 
%       difference images or other maps (online computed blood flow, etc))
%    3) Assumes INPUT_DIR contains only NIfTI files and their sidecar .json
%       files obtained with dcm2niix [1]
%    4) Grouping rationale: Group files in a way that avoids subsequent
%       merging of files with the same protocol name but who were acquired
%       at different points in time (different runs).
%       Example:
%           BEFORE GROUPING (INPUT):
%               | File # | Protocol Name |
%               |   1    |       A       |
%               |   2    |       B       |
%               |   3    |       C       |
%               |   4    |       A       |
%               |   5    |       D       |
%               |   6    |       D       |
%               |   7    |       A       |
%               |   8    |       D       |
%               |   9    |       A       |
%               |   10   |       A       |
%            
%           AFTER GROUPING (OUTPUT):
%               | Group Name | File #'s included' |
%               |      A     |        1           |
%               |      B     |        2           |
%               |      C     |        3           |
%               |      A     |        4           |
%               |      D     |        5, 6        |
%               |      A     |        7           |
%               |      D     |        8           |
%               |      A     |        9, 10       |
%           
%           Note i) files with same protocol name are grouped separately if
%           between them there is another file with different protocol name
%           acquired  them (e.g. files #1 and #4) and ii) files with same
%           protocol name are grouped together (e.g. files #5 and #6)
%
% References:
%    [1] https://github.com/rordenlab/dcm2niix
%    [2] https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils
%
% Required functions:
%    1)  exist2.m
%    2)  semicolonrep.m
%    3)  fdir.m
%    4)  json2struct.m
%    5)  struct2json.m
%    6)  fileparts2.m
%    7)  win2wsl.m
%    8)  m2sharr.m
%    9)  system2.m
%    10) fslmerge [2]
%
% Required files:
%    None other than the input .json/.nii.gz files
%
% Examples:
%    []
%
% fnery, 20190110: original version

% Silence pre-allocation warning for now
%#ok<*AGROW>

% ---------
% Constants
% ---------

JSON_WILDCARD = '*.json'; % to find any .json file

% To find any file acquired with MG's VB17 ASL sequences*
PULSE_SEQ_DETAILS = 'pgrs3d_seg_asl_new2';
SEQ_NAMES = {'grs3d3d1_1080t0', 'MGj03C3d1_512t0', 'MGj03C3d1_1080t'};

% To find ss and ns files
SSNS_REGEXP = '.s_TE00_(TI\d{4})';
          
ASL_EXTRA_HEADER_SOFTWARE_TAG = 'fn';

% ---------------------------------------------------
% Ensure input directories exist, if not: throw error
% ---------------------------------------------------

exist2(inDir, 'dir', true);
exist2(outDir, 'dir', true);

% --------------------------------
% Remove semicolons from filenames
% --------------------------------

% Semicolons replaced with underscores if needed). Avoids errors with
% filenames when using fslmerge. Also avoids need to enclose them in ""
% (saves characters due to cmd character limit)

semicolonrep(inDir)

% ---------------------------------------
% Read all .json files in input directory
% ---------------------------------------

[List, n] = fdir('in', fullfile(inDir, JSON_WILDCARD), 'silent', true);

if n == 0
    error('No *.json files were found in ''%s''', inDir);
end

paths = {List.fullpath}';

% -------------------------------------------------------------------------
% Identify files which:
% 1) were acquired with the intended sequence (MG's VB17 ASL sequences $1
% 2) correspond to the data of interest $2
%      $1 Avanto before 201811 upgrade
%      $2 slice-selective (SS) and non slice-selective (NS) data
% -------------------------------------------------------------------------

ssNsCount = 0;

for iPath = 1:n
    
    cPath = paths{iPath};
    
    % Read current .json file into a MATLAB struct
    CJson = json2struct(cPath);
    
    % Check if file corresponds to data acquired with desired sequences $1
    cPulseSequenceDetails = CJson.PulseSequenceDetails;
    
    try
        cSequenceName = CJson.SequenceName;
    catch
        % If there is not SequenceName field in the .json assume this is
        % not a file which we are looking for
        continue;
    end

    seqDetailsValid = contains(cPulseSequenceDetails, PULSE_SEQ_DETAILS);
    seqNameValid = ismember(cSequenceName, SEQ_NAMES);
    
    fileWasAcquiredWithDesiredSequence = seqDetailsValid && seqNameValid;
    
    % Further look into files acquired with desired sequences $1
    if fileWasAcquiredWithDesiredSequence
        
        % Check if current file is a SS or NS scan
        % (i.e. no difference images or other maps) $2
        cImageComments = CJson.ImageComments;
        cSeriesDescription = CJson.SeriesDescription;
        
        if ~isequal(cImageComments, cSeriesDescription)
            error(['Assumption of ImageComments/SeriesDescription ', ...
                'being equal in MG''s VB17 ASL files was not verified.']);
        end
        
        startIndex = regexp(cImageComments, SSNS_REGEXP);
        
        fileIsSsOrNs = startIndex == 1;
        
        % --------------------------------------------------------------
        % Read necessary attributes from MG's VB17 SS/NS ASL .json files
        % --------------------------------------------------------------
        
        if fileIsSsOrNs
            
            ssNsCount = ssNsCount + 1;
            
            cProtocolName = CJson.ProtocolName;
            cSeriesNumber = CJson.SeriesNumber;
            cAcquisitionTime = CJson.AcquisitionTime;
            
            AuxHdr(ssNsCount).JSONPath = cPath;
            AuxHdr(ssNsCount).PulseSequenceDetails = cPulseSequenceDetails;
            AuxHdr(ssNsCount).SequenceName = cSequenceName;
            AuxHdr(ssNsCount).ProtocolName = cProtocolName;
            AuxHdr(ssNsCount).ImageComments = cImageComments;
            AuxHdr(ssNsCount).SeriesDescription = cSeriesDescription;
            AuxHdr(ssNsCount).SeriesNumber = cSeriesNumber;
            AuxHdr(ssNsCount).AcquisitionTime = cAcquisitionTime;
            
            % ------------------------------------------------------------
            % Compute file indices where a different protocol name is seen
            % ------------------------------------------------------------
            
            if ssNsCount == 1
                cProtocolNameChanged = true;
            else
                prevProtocolName = AuxHdr(ssNsCount-1).ProtocolName;
                cProtocolNameChanged = not(strcmp(prevProtocolName, ...
                                                  cProtocolName));
            end
            
            AuxHdr(ssNsCount).ProtocolNameChanged  = cProtocolNameChanged;
            
        end
    end
end
            
groupBoundIdxsAux = [find([AuxHdr.ProtocolNameChanged]) ssNsCount+1];

% ----------------------------------
% Process each file group separately
% ----------------------------------

nGroups = length(groupBoundIdxsAux)-1;
outJSON = cell(nGroups, 1);
outNii = cell(nGroups, 1);
for iGroup = 1:nGroups
    
    % -------------------------------
    % Create base name for each group
    % -------------------------------
    
    % Initialise indices of files in current group
    cLowerBoundIdx = groupBoundIdxsAux(iGroup);
    cUpperBoundIdx = groupBoundIdxsAux(iGroup+1)-1;
    cIdxs = cLowerBoundIdx:cUpperBoundIdx;
    
    % Generate base file name for current group, of format
    % <cLowerBoundIdx>_<cUpperBoundIdx>_<cProtocolName> with padded indices
    cImageComments = {AuxHdr(cIdxs).ImageComments}';
    cSeriesNumbers = {AuxHdr(cIdxs).SeriesNumber}';
    
    cProtocolName = AuxHdr(cLowerBoundIdx).ProtocolName;
    
    cName = sprintf('%04d_%04d_%s', ...
        cSeriesNumbers{1}, cSeriesNumbers{end}, cProtocolName);
    
    % --------------------------------------------------------------------
    % Create this groups' .json sidecar (for 4D NIfTI to be created below)
    % --------------------------------------------------------------------
    
    % $3 This .json file will be a copy of the .json file from the first
    % file in the group with the following additions:
    % - ASLControlTag: list of control ('c') or tag ('t') characters
    % - ASLPostLabelDelay: list of post-labelling delay times in [ms]
    % - ASLExtraHdrSoftware: tag to mark .jsons created w/ this method
    
    % Generate ASLControlTag and ASLPostLabelDelay variables for .json file
    [cCt, cPld] = parseimagecomments(cImageComments);    
    
    cJSONPaths = {AuxHdr(cIdxs).JSONPath}';  
    
    cFirstJSON = json2struct(cJSONPaths{1});
    cFirstJSON.ASLControlTag = cCt;
    cFirstJSON.ASLPostLabelDelay = cPld;
    cFirstJSON.ASLSeriesNumbers = cell2mat(cSeriesNumbers);
    cFirstJSON.ASLExtraHdrSoftware = ASL_EXTRA_HEADER_SOFTWARE_TAG;
    
    cOutJSONPath = fullfile(outDir, cName);
    
    outJSON{iGroup} = struct2json(cFirstJSON, cOutJSONPath);
    
    % ---------------------------------------------------------------------
    % Create single 4D NIfTI file with files from this group using fslmerge
    % ---------------------------------------------------------------------
    
    % Get paths to NIfTI files from this group
    [cD, cN, ~] = fileparts2(cJSONPaths);
    cE = repmat({'.nii.gz'}, [length(n), 1]);
    cNIfTIPaths = strcat(fullfile(cD, cN), cE);
    
    [~, cN, cE] = fileparts2(cNIfTIPaths);
    cNIfTINameExt = strcat(cN, cE);
    
    % Generate path for output 4D NIfTI file
    niiPath = fullfile(outDir, [cName '.nii.gz']);
    outNii{iGroup} = niiPath;    
    
    % Prep inputs for fslmerge:
    % - If in a Windows machine: convert paths to WSL format
    % - Input paths list must be in shell array format (not using fullpaths
    %   to reduce number of characters in command)
    niiPathWsl = win2wsl(niiPath);         
    inputDirWsl = win2wsl(inDir);
    cNIfTINameExt = m2sharr(cNIfTINameExt); % 
    
    % Build and run fslmerge command
    cmd = sprintf('cd ''%s''; fslmerge -t %s %s', ...
        inputDirWsl, niiPathWsl, cNIfTINameExt);
    
    % debug string below to check if commands are too long 
    % (google: Command prompt (Cmd.exe) command-line string limitation)
    % fprintf('### generating %s...\nlen(cmd) = %d\n', cName, length(cmd));
    
    status = system2('cmd', cmd, '-echo', false, '&', false);
    if status ~= 0
        error('Error: There was an error when calling ''fslmerge''');
    end

end

end

% ================================
% ===== parseimagecomments.m ===== ----------------------------------------
% ================================

function [ct, pld] = parseimagecomments(ImageComments)
% 
% Example:
%    If the input is: 
%        ImageComments =
%            9×1 cell array
%            
%              {'ss_TE00_TI0100'}
%              {'ss_TE00_TI0400'}
%              {'ss_TE00_TI0700'}
%              {'ss_TE00_TI1000'}
%              {'ss_TE00_TI1300'}
%              {'ss_TE00_TI1600'}
%              {'ss_TE00_TI1900'}
%              {'ss_TE00_TI2200'}
%              {'ss_TE00_TI2500'}
% 
%    The outputs will be:
%        ct =
%            9×1 cell array
%            
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%              {'c'}
%      
%        pld =   
%            100 
%            400 
%            700 
%            1000
%            1300
%            1600
%            1900
%            2200
%            2500

nFiles = length(ImageComments);

ct  = cell(nFiles, 1);
pld = NaN(nFiles, 1);

for iFile = 1:nFiles
    cString = ImageComments{iFile};
    
    cSsNsTag = cString(1:2);

    % ns: tag     --> t
    % ss: control --> c
    
    if strcmp(cSsNsTag, 'ss')
       ct{iFile} = 'c';
    elseif strcmp(cSsNsTag, 'ns')
       ct{iFile} = 't';
    else
        error('''cSsNsTag'' must be either ''ss'' or ''ns''');
    end
      
    pld(iFile) = str2double(cString(end-3:end));
    
end

if any(isnan(pld))
    error('There can be no NaNs in ''pld'' at this point');
end

end
function Out = dwi6d(im4d, bval, bvec)
% dwi6d.m: organises a 4D DWI volume into a 6D DWI volume
%
% Syntax:
%    1) Out = dwi6d(im4d, bval, bvec)
%
% Description:
%    1) Out = dwi6d(im4d, bval, bvec) organises a 4D DWI volume into a 6D 
%       DWI volume, where the format of the output 6D volume will be:
%       [row, col, slice, bval, bvec, measurement]
%
% Inputs:
%    1) im4d: 4D volume of DWI data with format [row, col, slice, volume#]
%    2) bval: string full path to .bval file
%    3) bvec: string full path to .bvec file
%
% Outputs:
% Outputs:
%    1) Out: struct containing fields: 
%       |--data: DWI data volume in 6D format (see description or note 2)
%       |--bvals * 
%       |--bvecs * 
%       |--idxs  *
%                *outputs of bvalbvecparse
%
% Notes/Assumptions: 
%    1) im4d is the dwi after loading with an appropriate NIfTI, which loads
%       the different orders in the DWI experiment (in the 4th dimension), 
%       in the order given in the corresponding bval/bvec pair
%    2) Format of output 6D volume: [row, col, slice, bval, bvec, measurement] 
%
% References:
%    []
%
% Required functions:
%    1) bvalbvecparse.m
%
% Required files:
%    1) bval file from one given scan
%    2) bvec file from the corresponding scan of 1)
%
% Examples:
%    []
%
% fnery, 20180127: original version
% fnery, 20190906: now preallocates output volume with NaNs to simplify
%                  further calculations (e.g. powder averaging)

if ~isnumeric(im4d) || ndims(im4d) ~= 4
    error('Error: the first input (''im4d'') must be a 4D numeric matrix');
end

% Parse .bval and .bvec file
[bvals, bvecs, idxs] = bvalbvecparse(bval, bvec);

% Pre-allocate output volume with NaNs
[nR, nC, nS, nBvals, nDirsMax, nAvgsMax] = getpreallocdims(im4d, idxs);
im6d = NaN(nR, nC, nS, nBvals, nDirsMax, nAvgsMax);

% Build 6D dwi volume
for iBval = 1:nBvals  
    
    cnBvecs = size(bvecs{iBval}, 2);
    
    for iBvec = 1:cnBvecs
        
        cVolIdxs = idxs{iBval}{iBvec};
        cnVols = size(cVolIdxs, 2);
        
        for iVol = 1:cnVols
            
            cVolIdx = cVolIdxs(iVol);
            cVol = im4d(:,:,:,cVolIdx);
            im6d(:,:,:,iBval,iBvec,iVol) = cVol; 
            
        end 
        
    end 
    
end

% Build output struct
Out.data  = im6d;
Out.bvals = bvals;
Out.bvecs = bvecs;
Out.idxs  = idxs;

end

function [nR, nC, nS, nBvals, nDirsMax, nAvgsMax] = getpreallocdims(im4d, idxs)
% getpreallocdims: Get length of different dimensions for the output volume

[nR, nC, nS, ~] = size(im4d);

nBvals = length(idxs);

nDirs = NaN(1, nBvals);
nAvgs = NaN(1, nBvals);
for iBVal = 1:nBvals
    cIdxs = idxs{iBVal};
    nDirs(iBVal) = length(cIdxs);
    cNAvgs = cellfun(@(x) size(x,2), cIdxs);
    
    if length(cNAvgs) > 1 && ~isallequal(cNAvgs)
        error('Error: why would different directions of the same bval have a different number of averages?')
    else           
        nAvgs(iBVal) = cNAvgs(1);
    end
end
    
nDirsMax = max(nDirs);
nAvgsMax = max(nAvgs);

end